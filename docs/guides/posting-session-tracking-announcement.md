# Posting the Session Tracking Announcement

## Prerequisites

1. Copy `.env.example` to `.env` and add `SLACK_BOT_TOKEN`
2. Verify the Slack MCP server is active (restart Claude Code if tools are missing)
3. For fallback workflows, source `.env` so `SLACK_BOT_TOKEN` is exported

## Preferred: Post via Slack MCP

```javascript
import fs from 'node:fs';

const payload = JSON.parse(fs.readFileSync('scripts/slack/session-tracking-announcement.json', 'utf8'));

mcp__slack__slack_post_message({
  channel_id: 'C09Q8KCGM9C',
  text: payload.text,
  blocks: payload.blocks
});
```

- Keep the MCP call inside the active session so the timestamp is captured automatically
- Update the channel ID if posting to a different Council channel

## Fallback: Direct Web API Request

Slack CLI v3.9.0 does **not** expose `slack api …` commands. Use curl if MCP is unavailable.

```bash
curl -s -X POST https://slack.com/api/chat.postMessage \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN" \
  -H "Content-Type: application/json" \
  --data @scripts/slack/session-tracking-announcement.json
```

## After Posting

1. Record the `ts` value returned by Slack
2. Update session notes and any tracking docs with the channel + timestamp
3. Monitor the thread for reactions and questions
4. Follow up within 24 hours with a summary (use session-tracker-2 `--post` when closing the session)

## Troubleshooting

- `not_authed`: token missing or expired — refresh the bot token in `.env`
- `channel_not_found`: bot not invited — invite Council Bot or use the numeric channel ID
- `invalid_blocks`: JSON malformed — validate with `jq . scripts/slack/session-tracking-announcement.json`
