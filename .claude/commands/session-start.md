---
description: Start a new session to track agent activities and collaboration
tags: [session, tracking, project]
---

# Start New Session

Start a new session to track your work, activities, and progress in the slack-hq workspace.

## Task

1. **Load the session-tracking skill** - Use the session-tracking skill for implementation details
2. **Generate session data** with:
   - Unique UUID for session_id
   - Current ISO8601 timestamp
   - Agent name (from environment or "Claude Code")
   - Task name from user input
   - Project: "slack-hq"
   - Working directory: current directory
   - Status: "active"
   - Empty activities array

3. **Execute session start script**:
   ```bash
   ~/.claude/skills/session-tracking/scripts/session.sh start "Task Name" [--auto-post] [--channel #council-ops]
   ```

4. **Validate against schema**:
   - Use schema at `~/.claude/skills/session-tracking/scripts/session-schema.json`
   - Ensure all required fields are present

5. **Persist session**:
   - Save to `.claude/data/sessions/<uuid>.json`
   - Create directory if needed

6. **Report to user**:
   - Session ID
   - Started at timestamp
   - Task name
   - Auto-post status (if enabled)

## Parameters

- Task name (required): Brief description of what you're working on
- `--auto-post`: Automatically post to Slack when session starts
- `--channel`: Slack channel for posting (default: #council-ops)

## Example

```bash
/session-start "Implement user authentication"
/session-start "Fix API rate limiting" --auto-post
/session-start "Deploy to staging" --auto-post --channel #deployments
```

## Success Criteria

- Session JSON file created and validated
- Session ID returned to user
- If auto-post enabled, confirmation of Slack post
- No schema validation errors
