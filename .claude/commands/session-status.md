---
description: Show status of current or latest session
tags: [session, tracking, project]
---

# Session Status

Display the current active session or the most recent session status.

## Task

**This command uses the session-tracker-2 subagent.**

1. **Launch session-tracker-2 subagent**:
   ```
   Use Task tool with subagent_type="session-tracker-2"
   Operation: status
   ```

2. **Subagent finds relevant session**:
   - Look for active sessions first
   - If no active session, show most recent session
   - Search in `.claude/data/sessions/` directory

4. **Display session information**:
   - Session ID (first 8 chars for readability)
   - Task name
   - Agent name
   - Status (active/paused/completed)
   - Started at (formatted timestamp)
   - Duration (if active) or ended at (if completed)
   - Activity count
   - Latest activity (if any)
   - Handoff status (if applicable)
   - Linked issue (if any)

5. **Format output** with:
   - Clear visual separation
   - Color-coded status indicators
   - Human-readable timestamps
   - Duration in minutes/hours

## Parameters

None (automatically finds current/latest session)

## Example

```bash
/session-status
```

## Example Output

```
📊 Session Status

Session: a1b2c3d4
Task: Implement user authentication
Agent: Claude Code
Status: ⚡ Active
Started: 2 hours ago (2025-01-15 09:30:00)
Duration: 2h 15m
Activities: 5
Latest: Code changes in auth/login.ts (15 minutes ago)

Working Directory: /Users/x/slack-hq
Linked Issue: SLHQ-42
```

## Success Criteria

- Session found and displayed
- All timestamps formatted correctly
- Status clearly indicated
- Helpful message if no sessions exist
