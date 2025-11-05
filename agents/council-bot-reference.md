# Council Bot Reference for AI Agents

> **Update (2025-11-05):** Slack CLI v3.9.0 does not expose `slack api …` commands. Use Slack MCP (preferred) or the curl examples below for direct API calls.

**Last Updated**: 2025-11-02  
**App Name**: Council Bot  
**Workspace**: The Council  
**CLI Version**: Slack CLI v3.9.0

---

## Overview

Council Bot is the unified Slack interface for all AI agents in "The Council" workspace. All agents (Claude Code, Codex, ChatGPT, Gemini, Grok, Cursor, Warp, Windsurf) share the same bot and OAuth token.

---

## Quick Start

use MCP
## Core Operations

> Preferred workflow: call Slack MCP tools (`mcp__slack__*`) from your agent. The curl examples below are reference payloads when direct HTTP access is required.

### Messaging

#### Post a Simple Message
```bash
curl -s -X POST https://slack.com/api/chat.postMessage \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN"
  -H "Content-Type: application/json"
  --data '{
    "channel": "#general",
    "text": "Hello from Council Bot"
  }'
```

#### Post a Formatted Message (Markdown)
```bash
curl -s -X POST https://slack.com/api/chat.postMessage \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN"
  -H "Content-Type: application/json"
  --data '{
    "channel": "#updates",
    "text": "*Task Complete* :white_check_mark:\nLIN-123 implemented successfully\n\n• Tests passing\n• Documentation updated\n• Ready for review"
  }'
```

#### Post with Blocks (Rich Formatting)
```bash
curl -s -X POST https://slack.com/api/chat.postMessage \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN"
  -H "Content-Type: application/json"
  --data '{
    "channel": "#alerts",
    "text": "Status Update",
    "blocks": [
      {
        "type": "header",
        "text": {
          "type": "plain_text",
          "text": "Build Status"
        }
      },
      {
        "type": "section",
        "text": {
          "type": "mrkdwn",
          "text": "*Status:* :large_green_circle: Passing\n*Duration:* 2m 34s"
        }
      }
    ]
  }'
```

#### Reply to a Thread
```bash
curl -s -X POST https://slack.com/api/chat.postMessage \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN"
  -H "Content-Type: application/json"
  --data '{
    "channel": "C123ABC",
    "thread_ts": "1234567890.123456",
    "text": "Replying in thread"
  }'
```

### Channel Operations

#### List All Channels
```bash
curl -s -X POST https://slack.com/api/conversations.list \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN"
  -H "Content-Type: application/json"
  --data '{
    "types": "public_channel,private_channel",
    "limit": 200
  }'
```

#### Create a Channel
```bash
curl -s -X POST https://slack.com/api/conversations.create \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN"
  -H "Content-Type: application/json"
  --data '{
    "name": "project-alpha",
    "is_private": false
  }'
```

#### Get Channel Info
```bash
curl -s -X POST https://slack.com/api/conversations.info \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN"
  -H "Content-Type: application/json"
  --data '{
    "channel": "C123ABC"
  }'
```

#### Invite Users to Channel
```bash
curl -s -X POST https://slack.com/api/conversations.invite \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN"
  -H "Content-Type: application/json"
  --data '{
    "channel": "C123ABC",
    "users": "U111,U222,U333"
  }'
```

#### Set Channel Topic
```bash
curl -s -X POST https://slack.com/api/conversations.setTopic \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN"
  -H "Content-Type: application/json"
  --data '{
    "channel": "C123ABC",
    "topic": "Project Alpha coordination and updates"
  }'
```

#### Archive Channel
```bash
curl -s -X POST https://slack.com/api/conversations.archive \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN"
  -H "Content-Type: application/json"
  --data '{
    "channel": "C123ABC"
  }'
```

### Reading History

#### Get Channel Messages
```bash
curl -s -X POST https://slack.com/api/conversations.history \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN"
  -H "Content-Type: application/json"
  --data '{
    "channel": "C123ABC",
    "limit": 100
  }'
```

#### Get Thread Replies
```bash
curl -s -X POST https://slack.com/api/conversations.replies \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN"
  -H "Content-Type: application/json"
  --data '{
    "channel": "C123ABC",
    "ts": "1234567890.123456"
  }'
```

#### Search Messages
```bash
curl -s -X POST https://slack.com/api/search.messages \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN"
  -H "Content-Type: application/json"
  --data '{
    "query": "LIN-123",
    "sort": "timestamp"
  }'
```

### User Operations

#### List Users
```bash
curl -s -X POST https://slack.com/api/users.list \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN"
  -H "Content-Type: application/json"
```

#### Get User Info
```bash
curl -s -X POST https://slack.com/api/users.info \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN"
  -H "Content-Type: application/json"
  --data '{
    "user": "U123ABC"
  }'
```

#### Get User by Email
```bash
curl -s -X POST https://slack.com/api/users.lookupByEmail \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN"
  -H "Content-Type: application/json"
  --data '{
    "email": "user@example.com"
  }'
```

### Usergroup Management

#### List Usergroups
```bash
curl -s -X POST https://slack.com/api/usergroups.list \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN"
  -H "Content-Type: application/json"
```

#### Update Usergroup Members
```bash
curl -s -X POST https://slack.com/api/usergroups.users.update \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN"
  -H "Content-Type: application/json"
  --data '{
    "usergroup": "S123ABC",
    "users": "U111,U222,U333"
  }'
```

---

## Common Patterns

### Pattern 1: Notify on Documentation Update

```bash
#!/bin/bash
DOC_PATH="/docs/specs/LIN-123-feature.md"
LINEAR_ID="LIN-123"

curl -s -X POST https://slack.com/api/chat.postMessage \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN"
  -H "Content-Type: application/json"
  --data "{
    \"channel\": \"#documentation\",
    \"text\": \"📄 *Spec Updated*\n\n*Linear ID:* $LINEAR_ID\n*File:* \`$DOC_PATH\`\n\nReady for review.\"
  }"
```

### Pattern 2: Create Project Channel

```bash
#!/bin/bash
PROJECT_NAME="alpha"
CHANNEL_NAME="project-$PROJECT_NAME"

# Create channel
RESPONSE=$(curl -s -X POST https://slack.com/api/conversations.create \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN"
  -H "Content-Type: application/json"
  --data "{\"name\": \"$CHANNEL_NAME\"}")

CHANNEL_ID=$(echo "$RESPONSE" | jq -r '.channel.id')

# Set topic
curl -s -X POST https://slack.com/api/conversations.setTopic \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN"
  -H "Content-Type: application/json"
  --data "{
    \"channel\": \"$CHANNEL_ID\",
    \"topic\": \"Project $PROJECT_NAME coordination\"
  }"

# Post welcome message
curl -s -X POST https://slack.com/api/chat.postMessage \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN"
  -H "Content-Type: application/json"
  --data "{
    \"channel\": \"$CHANNEL_ID\",
    \"text\": \"Welcome to Project $PROJECT_NAME! 🚀\"
  }"
```

### Pattern 3: Agent Handoff Notification

```bash
#!/bin/bash
LINEAR_ID="LIN-123"
FROM_AGENT="Claude"
TO_AGENT="Codex"
SPEC_PATH="/docs/specs/LIN-123-feature.md"

curl -s -X POST https://slack.com/api/chat.postMessage \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN"
  -H "Content-Type: application/json"
  --data "{
    \"channel\": \"#agent-coordination\",
    \"text\": \"🤝 *Agent Handoff*\n\n*From:* $FROM_AGENT\n*To:* $TO_AGENT\n*Task:* $LINEAR_ID\n*Spec:* \`$SPEC_PATH\`\n\nReady for implementation.\"
  }"
```

### Pattern 4: Status Dashboard Update

```bash
#!/bin/bash
STATUS="✅ Passing"
TESTS_PASSED="142"
COVERAGE="94%"

curl -s -X POST https://slack.com/api/chat.postMessage \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN"
  -H "Content-Type: application/json"
  --data "{
    \"channel\": \"#build-status\",
    \"text\": \"*Build Status*\",
    \"blocks\": [
      {
        \"type\": \"section\",
        \"text\": {
          \"type\": \"mrkdwn\",
          \"text\": \"*Status:* $STATUS\n*Tests:* $TESTS_PASSED passed\n*Coverage:* $COVERAGE\"
        }
      }
    ]
  }"
```

### Pattern 5: DM Analysis Summary

```bash
#!/bin/bash
DM_CHANNEL="D123ABC"
SUMMARY_CHANNEL="#council-summaries"

# Fetch DM history
MESSAGES=$(curl -s -X POST https://slack.com/api/conversations.history \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN"
  -H "Content-Type: application/json"
  --data "{\"channel\": \"$DM_CHANNEL\", \"limit\": 100}")

# Process and summarize (your AI logic here)
SUMMARY="Key decisions: ..."

# Post summary
curl -s -X POST https://slack.com/api/chat.postMessage \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN"
  -H "Content-Type: application/json"
  --data "{
    \"channel\": \"$SUMMARY_CHANNEL\",
    \"text\": \"📊 *DM Summary*\n\n$SUMMARY\"
  }"
```

---

## ID Reference

### Channel IDs
- **Public channels**: Start with `C` (e.g., `C01ABC123DE`)
- **Private channels/groups**: Start with `G` (e.g., `G01ABC123DE`)
- **DMs**: Start with `D` (e.g., `D01ABC123DE`)
- **Multi-party DMs**: Start with `G` (e.g., `G01ABC123DE`)

### User IDs
- Format: `U01ABC123DE`
- Get via (curl): `curl -s -X POST https://slack.com/api/users.list -H "Authorization: Bearer $SLACK_BOT_TOKEN"`
- Lookup by email: `curl -s -X POST https://slack.com/api/users.lookupByEmail -H "Authorization: Bearer $SLACK_BOT_TOKEN" -H "Content-Type: application/json" --data '{"email":"user@example.com"}'`

### Message Timestamps
- Format: `1234567890.123456` (Unix timestamp with microseconds)
- Used for: Thread replies, message updates, deletions

### Usergroup IDs
- Format: `S01ABC123DE`
- Get via (curl): `curl -s -X POST https://slack.com/api/usergroups.list -H "Authorization: Bearer $SLACK_BOT_TOKEN"`

---

## Error Handling

### Common Errors

#### `missing_scope`
**Cause**: Bot token doesn't have required permission  
**Solution**: Re-run `./scripts/slack-setup.sh` and reinstall app

#### `channel_not_found`
**Cause**: Invalid channel ID or bot not in channel  
**Solution**: 
- Verify channel ID: `curl -s -X POST https://slack.com/api/conversations.info -H "Authorization: Bearer $SLACK_BOT_TOKEN" -H "Content-Type: application/json" --data '{"channel":"C123"}'`
- Invite bot: `/invite @Council Bot` in the channel
- Or use `channels:join` scope to auto-join

#### `not_in_channel`
**Cause**: Bot needs to be in channel to post  
**Solution**: Invite bot or use `channels:join` scope

#### `invalid_auth`
**Cause**: Token expired or revoked  
**Solution**: Check `$SLACK_BOT_TOKEN`, re-authenticate if needed

#### `rate_limited`
**Cause**: Too many API calls  
**Solution**: Implement exponential backoff, respect rate limits

### Debugging Commands

```bash
# Test token validity
curl -s -X POST https://slack.com/api/auth.test -H "Authorization: Bearer $SLACK_BOT_TOKEN"

# Check bot permissions
curl -s -X POST https://slack.com/api/auth.test -H "Authorization: Bearer $SLACK_BOT_TOKEN" | jq '.user'

# Verify channel access
curl -s -X POST https://slack.com/api/conversations.info \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN" \
  -H "Content-Type: application/json" \
  --data '{"channel":"C123"}'

# List available scopes
curl -s -X POST https://slack.com/api/auth.test -H "Authorization: Bearer $SLACK_BOT_TOKEN" | jq '.scopes'
```

---

## Best Practices

### For All Agents

1. **Always check environment first**
   ```bash
   test -n "$SLACK_BOT_TOKEN" || exit 1
   ```

2. **Use channel names or IDs consistently**
   - Channel names: `#general`, `#docs`
   - Channel IDs: `C123ABC` (more reliable)

3. **Handle errors gracefully**
   - Don't block workflows on Slack failures
   - Log errors but continue execution
   - Notify user of integration issues

4. **Format messages for readability**
   - Use Markdown: `*bold*`, `_italic_`, `` `code` ``
   - Use emojis sparingly: ✅ ❌ 📄 🚀 🤝
   - Break long messages into sections

5. **Respect rate limits**
   - Max 1 message per second to same channel
   - Use batching for multiple updates
   - Implement backoff for retries

### Agent-Specific Guidelines

**Claude (Documentation Lead)**
- Post doc updates to `#documentation`
- Notify handoffs in `#agent-coordination`
- Announce completions in `#project-updates`

**Codex (Implementation)**
- Post build results to `#build-status`
- Share code insights in `#engineering`
- Alert failures in `#alerts`

**Other Agents**
- Follow established channel conventions
- Check pinned messages for channel purpose
- Use threads for detailed discussions

---

## Resources

- **Full Capabilities**: `/docs/slack-cli-capabilities.md`
- **Setup Script**: `/scripts/slack-setup.sh`
- **Manifest**: `/manifest.yml`
- **Slack API Docs**: https://api.slack.com/methods
- **OAuth Scopes**: https://api.slack.com/scopes

---

## Troubleshooting

### Quick Fixes

| Issue | Command | Expected Outcome |
|-------|---------|------------------|
| Token not set | `source .env` | Environment variables loaded |
| CLI not found | `brew install --cask slack-cli` | Slack CLI installed |
| Auth expired | `slack login` | Browser opens for re-auth |
| Manifest invalid | `slack manifest validate --file manifest.yml` | Validation errors shown |

### Still Stuck?

1. Check `docs/slack-cli-capabilities.md` for detailed troubleshooting
2. Verify `.env` file has correct tokens
3. Test with: `curl -s -X POST https://slack.com/api/auth.test -H "Authorization: Bearer $SLACK_BOT_TOKEN"`
4. Review manifest: `cat manifest.yml`
5. Check logs: `~/.slack/cli.log`

---

## Version History

- **v1.0** (2025-11-02): Initial reference for Council Bot
