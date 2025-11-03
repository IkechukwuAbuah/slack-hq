---
description: Post session summary to Slack with Block Kit formatting
tags: [session, tracking, slack, project]
---

# Post Session to Slack

Post a formatted session summary to the Council Bot Slack channel, creating engagement through rich formatting and threading.

## Task

1. **Load the session-tracking skill** - Use for Slack integration details

2. **Verify prerequisites**:
   - Check SLACK_BOT_TOKEN environment variable is set
   - Verify session exists
   - Confirm Slack CLI is available

3. **Load session data**:
   - If session ID provided: use that session
   - If no ID: use current active session
   - Read from `.claude/data/sessions/<session-id>.json`

4. **Format message with Block Kit**:

   **Header Section:**
   - Session title with status emoji
   - Agent name and task name
   - Duration and timestamp

   **Activities Section:**
   - List key activities (max 5)
   - Show file changes count
   - Display tools used

   **Links Section:**
   - Link to Linear issue (if applicable)
   - Link to relevant docs/specs
   - Link to PR (if available)

   **Metadata:**
   - Tags as hashtags
   - Handoff information (if applicable)

5. **Post to Slack**:
   ```bash
   slack api chat.postMessage --data '{
     "channel": "#council-ops",
     "text": "Session Summary: Task Name",
     "blocks": [...],
     "thread_ts": "...",
     "unfurl_links": false
   }' --token "$SLACK_BOT_TOKEN"
   ```

6. **Handle threading**:
   - If session has existing slack_message_ts: post as reply in thread
   - If new session: create new message and store message_ts
   - Update session JSON with message_ts and channel

7. **Error handling**:
   - Retry on rate limit (max 3 times with exponential backoff)
   - Log errors to `logs/slack-post-errors.log`
   - Validate payload size before posting (< 40KB)
   - Gracefully handle missing SLACK_BOT_TOKEN

8. **Report to user**:
   - Confirmation message
   - Slack message URL
   - Thread status

## Parameters

- Session ID (optional): Specific session to post (defaults to current active)
- `--channel`: Slack channel to post to (default: #council-ops)
- `--thread`: Reply to existing thread (requires thread_ts)
- `--dry-run`: Preview message without posting
- `--minimal`: Use compact formatting

## Examples

```bash
/session-post
/session-post --dry-run
/session-post a1b2c3d4 --channel #deployments
/session-post --minimal
```

## Example Slack Message

```
📊 Session Complete: Implement user authentication

👤 Agent: Claude Code
⏱️  Duration: 2h 15m
📅 Completed: Jan 15, 2025 at 11:45 AM

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🎯 Key Activities (5)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

• Created authentication middleware
• Implemented JWT token generation
• Added comprehensive test coverage
• Reviewed security best practices
• Updated environment configuration

📁 8 files changed
🔧 Tools: Write, Edit, Bash, WebFetch

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔗 Links
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📋 Issue: SLHQ-42
📖 Spec: /docs/specs/authentication.md

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

#authentication #security #backend
```

## Block Kit Structure

Use the following block types:
- `header`: Session title with emoji
- `section`: Agent, duration, metadata
- `divider`: Visual separation
- `section` with markdown: Activities list
- `context`: Tags and supplementary info
- `actions`: (optional) Quick action buttons

Reference: `~/.claude/skills/session-tracking/references/slack-integration.md`

## Success Criteria

- Message posted successfully to Slack
- Block Kit rendering correctly
- Links clickable and functional
- Session JSON updated with message_ts
- Threading works for continued updates
- Error handling prevents data loss
- Rate limiting handled gracefully

## Troubleshooting

**Error: SLACK_BOT_TOKEN not set**
- Ensure token is exported in environment
- Check `.env` file is loaded

**Error: Rate limited**
- Script will automatically retry with backoff
- Check Slack API rate limit status

**Error: Payload too large**
- Use `--minimal` flag
- Reduce activities shown
- Truncate long descriptions
