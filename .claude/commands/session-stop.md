---
description: Stop the current or specified session and optionally post to Slack
tags: [session, tracking, project]
---

# Stop Session

Stop the current active session or a specific session by ID, marking it as completed.

## Task

1. **Load the session-tracking skill** - Use for implementation details

2. **Identify session to stop**:
   - If session ID provided: use that session
   - If no ID: find the most recent active session
   - Error if no active session found

3. **Execute session stop script**:
   ```bash
   ~/.claude/skills/session-tracking/scripts/session.sh stop <session-id> [--notes "Summary"] [--post]
   ```

4. **Update session data**:
   - Set `ended_at` to current ISO8601 timestamp
   - Set `status` to "completed"
   - Add notes if provided
   - Calculate duration

5. **Optional Slack posting** (if --post flag used):
   - Check SLACK_BOT_TOKEN is set
   - Format session summary with Block Kit
   - Post to configured channel (or thread if continuation)
   - Store message_ts for threading

6. **Report to user**:
   - Session ID
   - Task name
   - Duration (started_at to ended_at)
   - Activities count
   - Slack post confirmation (if applicable)

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
