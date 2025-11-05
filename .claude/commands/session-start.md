---
description: Start a new session using session-tracker-2 subagent with direct Slack MCP integration
tags: [session, tracking, project]
---

# Start New Session

Start a new session using the **session-tracker-2 subagent** to track your work and progress.

## Task

**This command MUST use the session-tracker-2 subagent - NOT the old session-tracker agent (v1), shell scripts, or session-tracking skill.**

1. **Launch session-tracker-2 subagent**:
   ```
   Use Task tool with subagent_type="session-tracker-2"
   ```

2. **Provide context to subagent**:
   ```
   Operation: start_session
   Description: "[user provided description]"
   Auto Post: [true/false if --auto-post flag provided]
   Channel: [if --channel flag provided, default: C09QAKDHKMG]
   Project: "slack-hq"
   Working Directory: [current directory]
   ```

3. **Subagent will handle EVERYTHING (including Slack posting)**:
   - Generating UUID v4 for session_id
   - Creating ISO8601 timestamps
   - Building complete session JSON structure
   - Validating against schema
   - Persisting to `.claude/data/sessions/{uuid}.json`
   - Creating directories if needed
   - **DIRECTLY posting to Slack** via `mcp__slack__slack_post_message` (if auto-post enabled)
   - Storing message_ts for threading

4. **Expected subagent output**:
   - Session ID (UUID)
   - Started at timestamp
   - Task description
   - File path where session is stored
   - Slack post confirmation with message URL (if auto-post enabled)

## Parameters

- Task name (required): Brief description of what you're working on
- `--auto-post`: Automatically post to Slack when session starts
- `--channel`: Slack channel for posting (default: #council-core)

## Example

```bash
/session-start "Implement user authentication"
/session-start "Fix API rate limiting" --auto-post
/session-start "Deploy to staging" --auto-post --channel #automation
```

## Success Criteria

- Session JSON file created and validated
- Session ID returned to user
- If auto-post enabled, confirmation of Slack post
- No schema validation errors
