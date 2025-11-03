---
description: List recent sessions with filtering and search capabilities
tags: [session, tracking, project]
---

# Session History

List recent sessions with optional filtering by status, agent, date range, or search terms.

## Task

1. **Load the session-tracking skill** - Use for implementation details

2. **Execute history script**:
   ```bash
   ~/.claude/skills/session-tracking/scripts/session.sh history [--limit N] [--status active|completed|paused] [--agent name] [--since YYYY-MM-DD]
   ```

3. **Scan session files**:
   - Read all JSON files from `.claude/data/sessions/`
   - Parse and validate each session
   - Sort by started_at (most recent first)

4. **Apply filters** (if provided):
   - `--limit`: Maximum number of sessions to show (default: 10)
   - `--status`: Filter by session status
   - `--agent`: Filter by agent name
   - `--since`: Show sessions since date
   - `--search`: Search in task names and notes

5. **Display results** in table format:
   ```
   ID       | Task                          | Agent       | Status    | Started           | Duration
   ---------|-------------------------------|-------------|-----------|-------------------|----------
   a1b2c3d4 | Implement authentication      | Claude      | Completed | Jan 15, 09:30     | 2h 15m
   e5f6g7h8 | Fix rate limiting bug         | Codex       | Completed | Jan 14, 14:20     | 45m
   i9j0k1l2 | Deploy to staging             | Claude      | Active    | Jan 13, 11:00     | (ongoing)
   ```

6. **Summary statistics**:
   - Total sessions found
   - Active sessions count
   - Total time tracked (for completed sessions)
   - Most common activity types

## Parameters

- `--limit N`: Show N most recent sessions (default: 10)
- `--status`: Filter by status (active, completed, paused)
- `--agent`: Filter by agent name
- `--since`: Show sessions since date (YYYY-MM-DD)
- `--search`: Search term in task names/notes

## Examples

```bash
/session-history
/session-history --limit 20
/session-history --status active
/session-history --agent "Claude Code"
/session-history --since 2025-01-01
/session-history --search "authentication"
```

## Success Criteria

- Sessions displayed in reverse chronological order
- Filters applied correctly
- Summary statistics accurate
- Helpful message if no sessions match criteria
- Performance acceptable even with many sessions
