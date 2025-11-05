# How to Post Session Tracking Announcement to Slack

## Prerequisites

- Configure `.env` with `SLACK_BOT_TOKEN`
- Ensure the Council Bot has `chat:write`, `chat:write.public`, and `channels:read` scopes
- When working inside Claude Code, confirm the Slack MCP server is loaded (it is on by default)

## Method 1: Slack MCP (Preferred)

Use Slack MCP tools directly so the post is auditable in the agent transcript.

```javascript
import fs from 'node:fs';

const payload = JSON.parse(fs.readFileSync('docs/guides/session-tracking-announcement.json', 'utf8'));

mcp__slack__slack_post_message({
  channel_id: 'C09Q8KCGM9C', // #council-ops
  text: payload.text,
  blocks: payload.blocks
});
```

- Update `channel_id` if you are posting somewhere besides `#council-ops`
- The MCP call returns the message timestamp; persist it in session notes or logs

## Method 2: Direct Web API (Fallback)

If Slack MCP is unavailable, call the Web API with curl. Slack CLI v3.9.0 does **not** support `slack api …` commands.

```bash
curl -s -X POST https://slack.com/api/chat.postMessage \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN" \
  -H "Content-Type: application/json" \
  --data @docs/guides/session-tracking-announcement.json
```

## Verification Checklist

1. Message appears in the target channel
2. Block Kit layout renders correctly
3. Timestamp recorded for future updates
4. Session notes updated with link to announcement

## Troubleshooting

| Issue | Likely Cause | Resolution |
|-------|--------------|------------|
| `not_authed` | Token missing | Load `.env` or export `SLACK_BOT_TOKEN` |
| `channel_not_found` | Bot not invited | Invite Council Bot to the channel or use the channel ID |
| Formatting issues | Malformed JSON | Validate with `jq empty docs/guides/session-tracking-announcement.json` |

## Related Files

- `docs/guides/session-tracking-announcement.json`
- `scripts/slack/session-tracking-announcement.json`
- `.claude/agents/session-tracker-2.md`
