---
description: Post session summary to Slack with Block Kit formatting using session-tracker-2 subagent
tags: [session, tracking, slack, project]
---

# Post Session to Slack

Post a formatted session summary to the Council Bot Slack channel. Uses **session-tracker-2 subagent** which handles EVERYTHING including Slack posting.

## Task

**Architecture: Subagent loads session, builds Block Kit, posts to Slack, updates session JSON**

1. **Launch session-tracker-2 subagent**:
   ```
   Use Task tool with subagent_type="session-tracker-2"
   Operation: post_session
   Session ID: [provided or "active"]
   Channel: [if --channel provided, default: C09QAKDHKMG]
   Thread: [if --thread provided with thread_ts]
   Dry Run: [if --dry-run flag provided]
   ```

2. **Subagent handles EVERYTHING**:
   - Load session from `.claude/data/sessions/{uuid}.json`
   - Calculate duration (hours, minutes)
   - Format timestamp
   - Build Block Kit message with:
     - Header with status emoji (✅/🔵/⏸️/❌)
     - Section with agent, duration, date
     - Divider
     - Activities section (formatted list)
     - Handoff section (if applicable)
     - Context footer with tags and Linear links
   - **DIRECTLY post to Slack** using `mcp__slack__slack_post_message`
   - Store `slack_message_ts` and `slack_thread_ts` in session JSON
   - Return confirmation with Slack message URL

3. **Expected output**:
   - Confirmation of successful post
   - Slack message URL
   - Thread timestamp
   - Updated session file path

## Parameters

- Session ID (optional): Specific session to post (defaults to current active)
- `--channel`: Slack channel to post to (default: #council-core)
- `--thread`: Reply to existing thread (requires thread_ts)
- `--dry-run`: Preview message without posting
- `--minimal`: Use compact formatting

## Examples

```bash
/session-post
/session-post --dry-run
/session-post a1b2c3d4 --channel #automation
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
