# Slack Integration Guide

Complete guide for integrating session tracking with Slack via Council Bot.

## Slack API Endpoints

### chat.postMessage
Post new messages to channels. Used for initial session updates.

```bash
curl -X POST https://slack.com/api/chat.postMessage \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "channel": "#council-ops",
    "text": "Session Update",
    "blocks": [...]
  }'
```

### chat.update
Update existing messages. Used when session progresses.

```bash
curl -X POST https://slack.com/api/chat.update \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "channel": "#council-ops",
    "ts": "1705516800.123456",
    "blocks": [...]
  }'
```

### conversations.history
Retrieve message history for threading decisions.

```bash
curl -X GET "https://slack.com/api/conversations.history?channel=C12345&limit=10" \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN"
```

### users.info
Resolve agent display names when formatting messages.

```bash
curl -X GET "https://slack.com/api/users.info?user=U12345" \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN"
```

## Message Templates

### Block Kit Structure

Session updates use Block Kit for rich formatting:

```json
{
  "channel": "#council-ops",
  "text": "📊 Session Update: {{session_id}}",
  "blocks": [
    {
      "type": "header",
      "text": {
        "type": "plain_text",
        "text": "📊 {{title}}"
      }
    },
    {
      "type": "section",
      "text": {
        "type": "mrkdwn",
        "text": "*Agent*: {{agent_name}}\n*Status*: {{status}}\n*Started*: {{started_at}}"
      }
    },
    {
      "type": "section",
      "text": {
        "type": "mrkdwn",
        "text": "*Highlights*:\n{{highlights}}"
      }
    },
    {
      "type": "context",
      "elements": [
        {
          "type": "mrkdwn",
          "text": "Spec: docs/specs/session-tracking.md"
        },
        {
          "type": "mrkdwn",
          "text": "Research: docs/research/session-tracking-analysis.md"
        },
        {
          "type": "mrkdwn",
          "text": "Issue: SLHQ-241"
        }
      ]
    }
  ]
}
```

### Template Variables

Variables replaced by `jq` during rendering:

- `{{session_id}}` - UUID of session
- `{{title}}` - Session name from agent_name field
- `{{agent_name}}` - Agent identifier
- `{{status}}` - Current status (active/paused/completed)
- `{{started_at}}` - Start timestamp
- `{{highlights}}` - Formatted activity summary

### Highlights Formatting

Generate from activities array:

```bash
jq -r '.activities[] | "• \(.timestamp | split("T")[1] | split(".")[0]) – \(.type) – \(.summary)"' session.json
```

Example output:
```
• 18:25:00 – analysis – Drafted research summary
• 18:45:00 – code – Implemented session.sh
• 19:10:00 – deployment – Updated production config
```

## Posting Rules

### Manual Posting

Triggered explicitly via `/session post`:

```bash
./scripts/session.sh post --id <session-id>
```

Reads `slack_channel` from session metadata (default: `#council-core`).

### Automatic Posting

When `auto_post=true` in session:
- Session start triggers post via hook
- Session stop triggers update via hook
- Intermediate updates can be triggered manually

Enable at session start:
```bash
./scripts/session.sh start "Task" --auto-post --channel #feature-labs
```

### Channel Override

Specify channel at start or post time:

```bash
# At start
./scripts/session.sh start "Task" --channel #engineering

# During post
./scripts/session.sh post --id <id> --channel #product
```

## Threading Strategy

### Initial Post

First post creates a new message and stores timestamp:

1. Call `chat.postMessage` with session content
2. Extract `ts` from response
3. Store in session as `slack_message_ts`
4. Store same `ts` as `slack_thread_ts`

### Subsequent Updates

Thread replies use stored timestamp:

1. Read `slack_thread_ts` from session
2. Call `chat.postMessage` with `thread_ts` parameter
3. Update appends to existing thread

### Pinning Final Posts

Optional: Pin completed session posts to channel:

```bash
curl -X POST https://slack.com/api/pins.add \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "channel": "#council-ops",
    "timestamp": "1705516800.123456"
  }'
```

## Error Handling

### Missing Token

Check `SLACK_BOT_TOKEN` before API calls:

```bash
if [ -z "$SLACK_BOT_TOKEN" ]; then
  echo "Error: SLACK_BOT_TOKEN not set" >&2
  echo "Set with: export SLACK_BOT_TOKEN=xoxb-..." >&2
  exit 2
fi
```

### HTTP Failures

Log full response for debugging:

```bash
response=$(curl -s -w "\n%{http_code}" -X POST ...)
http_code=$(echo "$response" | tail -n1)
body=$(echo "$response" | sed '$d')

if [ "$http_code" != "200" ]; then
  echo "Slack API error: $http_code" >&2
  echo "$body" | jq '.' >> logs/slack-post-errors.log
  exit 1
fi
```

### Rate Limiting

Respect `Retry-After` header with exponential backoff:

```bash
retry_count=0
max_retries=3

while [ $retry_count -lt $max_retries ]; do
  response=$(curl -s -i -X POST ...)
  
  if echo "$response" | grep -q "HTTP/2 429"; then
    retry_after=$(echo "$response" | grep -i "retry-after" | cut -d: -f2 | tr -d ' \r')
    echo "Rate limited. Waiting ${retry_after}s..." >&2
    sleep "$retry_after"
    ((retry_count++))
  else
    break
  fi
done
```

### Payload Validation

Check Block Kit limits before posting:

```bash
# Max 50 blocks per message
block_count=$(echo "$payload" | jq '.blocks | length')
if [ "$block_count" -gt 50 ]; then
  echo "Error: Payload exceeds 50 block limit ($block_count blocks)" >&2
  exit 1
fi

# Max 3000 characters per text block
max_text=$(echo "$payload" | jq '[.blocks[].text.text // "" | length] | max')
if [ "$max_text" -gt 3000 ]; then
  echo "Error: Text block exceeds 3000 character limit" >&2
  exit 1
fi
```

## Implementation Example

Complete posting script (`scripts/slack/session_post.sh`):

```bash
#!/usr/bin/env bash
set -euo pipefail

# Configuration
SLACK_TOKEN="${SLACK_BOT_TOKEN:-}"
SESSION_FILE="$1"
DRY_RUN="${2:-false}"

# Validate token
if [ -z "$SLACK_TOKEN" ]; then
  echo "Error: SLACK_BOT_TOKEN not set" >&2
  exit 2
fi

# Load session data
session=$(cat "$SESSION_FILE")
channel=$(echo "$session" | jq -r '.slack_channel // "#council-ops"')
message_ts=$(echo "$session" | jq -r '.slack_message_ts // empty')

# Build highlights
highlights=$(echo "$session" | jq -r '
  .activities[] | 
  "• \(.timestamp | split("T")[1] | split("Z")[0]) – \(.type) – \(.summary)"
' | head -5)

# Render template
payload=$(jq -n \
  --arg channel "$channel" \
  --arg title "$(echo "$session" | jq -r '.agent_name')" \
  --arg agent "$(echo "$session" | jq -r '.agent_name')" \
  --arg status "$(echo "$session" | jq -r '.status')" \
  --arg started "$(echo "$session" | jq -r '.started_at')" \
  --arg highlights "$highlights" \
  '{
    channel: $channel,
    text: ("📊 Session Update: " + $title),
    blocks: [
      {type: "header", text: {type: "plain_text", text: ("📊 " + $title)}},
      {type: "section", text: {type: "mrkdwn", text: ("*Agent*: " + $agent + "\n*Status*: " + $status + "\n*Started*: " + $started)}},
      {type: "section", text: {type: "mrkdwn", text: ("*Highlights*:\n" + $highlights)}},
      {type: "context", elements: [
        {type: "mrkdwn", text: "Spec: docs/specs/session-tracking.md"},
        {type: "mrkdwn", text: "Issue: SLHQ-241"}
      ]}
    ]
  }')

# Add thread_ts if updating
if [ -n "$message_ts" ]; then
  payload=$(echo "$payload" | jq --arg ts "$message_ts" '. + {thread_ts: $ts}')
fi

# Dry run
if [ "$DRY_RUN" = "true" ]; then
  echo "Dry run - would post:"
  echo "$payload" | jq '.'
  exit 0
fi

# Post to Slack
response=$(curl -s -X POST https://slack.com/api/chat.postMessage \
  -H "Authorization: Bearer $SLACK_TOKEN" \
  -H "Content-Type: application/json" \
  -d "$payload")

# Check response
if echo "$response" | jq -e '.ok' >/dev/null; then
  ts=$(echo "$response" | jq -r '.ts')
  echo "Posted successfully: $ts"
  
  # Update session with message_ts
  jq --arg ts "$ts" '.slack_message_ts = $ts | .slack_thread_ts = $ts' "$SESSION_FILE" | 
    sponge "$SESSION_FILE"
else
  echo "Post failed:" >&2
  echo "$response" | jq '.' >&2
  exit 1
fi
```

Usage:
```bash
# Dry run
./scripts/slack/session_post.sh .claude/data/sessions/abc123.json true

# Actual post
./scripts/slack/session_post.sh .claude/data/sessions/abc123.json
```
