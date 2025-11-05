---
description: Stop session using session-tracker-2 subagent with direct Slack MCP posting
tags: [session, tracking, project]
---

# Stop Session

Stop the current active session or a specific session. Uses **session-tracker-2 subagent** which handles EVERYTHING including Slack posting.

## Task

**Architecture: Subagent stops session AND posts to Slack directly (if --post)**

1. **Launch session-tracker-2 subagent**:
   ```
   Use Task tool with subagent_type="session-tracker-2"
   Operation: stop_session
   Session ID: [provided or "active"]
   Notes: "[user provided notes]"
   Post to Slack: [true if --post flag provided]
   ```

2. **Subagent handles EVERYTHING**:
   - Load session from `.claude/data/sessions/{uuid}.json`
   - Set `ended_at` to current ISO8601 timestamp
   - Set `status` to "completed"
   - Calculate accurate duration from start/end times
   - Add notes to final activity if provided
   - Persist updated session JSON
   - **If --post flag: DIRECTLY post to Slack** using `mcp__slack__slack_post_message`
   - Build Block Kit message with:
     - Status emoji and description
     - Agent, duration, completion time
     - Activities list
     - Handoff info (if applicable)
     - Tags and Linear links
   - Store `slack_message_ts` in session JSON for threading
   - Return complete session summary

4. **Final output**:
   - Session ID
   - Task description
   - Duration in hours and minutes (calculated from timestamps)
   - Total activities logged
   - Slack post confirmation with URL (if --post used)
   - Updated session file path

## Parameters

- Session ID (optional): Specific session to stop (defaults to current active session)
- `--notes`: Summary notes about what was accomplished
- `--post`: Post session summary to Slack

## Examples

```bash
/session-stop
/session-stop --notes "Completed authentication implementation with tests"
/session-stop --notes "Feature complete" --post
/session-stop a1b2c3d4-5678-90ef-ghij-klmnopqrstuv --post
```

## Success Criteria

- Session marked as completed
- ended_at timestamp recorded
- Notes added (if provided)
- Slack post successful (if requested)
- No data loss or validation errors
