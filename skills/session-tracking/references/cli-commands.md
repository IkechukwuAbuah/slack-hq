# CLI Commands Reference

Complete specification for all `/session` command implementations.

## Command Overview

```
session.sh <command> [options]

Commands:
  start    - Create new session
  stop     - Complete session
  status   - Show current/latest session
  history  - List recent sessions
  show     - Display session details
  post     - Send Slack update
```

## session start

Create a new session with metadata and optional Slack auto-posting.

### Syntax

```bash
./scripts/session.sh start [name] [--auto-post] [--channel <channel>]
```

### Arguments

- `name` - Session name (default: "Unnamed Session")

### Options

- `--auto-post` - Enable automatic Slack posting on lifecycle events
- `--channel <channel>` - Slack channel for updates (default: #council-ops)

### Behavior

1. Generate UUIDv4 for session_id
2. Capture current timestamp (ISO8601)
3. Get working directory (`$PWD`)
4. Create JSON with required fields
5. Validate against schema
6. Persist to `.claude/data/sessions/<uuid>.json`
7. Return session summary

### Output

```json
{
  "session_id": "3f12b5d4-a6b7-4521-9f42-2b9f06fb8d6a",
  "started_at": "2025-01-17T18:20:00Z",
  "working_directory": "/workspace/slack-hq"
}
```

### Examples

```bash
# Basic session
./scripts/session.sh start "Implement feature X"

# With auto-posting
./scripts/session.sh start "Deploy to prod" --auto-post

# Custom channel
./scripts/session.sh start "Hotfix" --auto-post --channel #incidents
```

### Exit Codes

- `0` - Success
- `1` - Validation error
- `2` - File system error

## session stop

Complete a session with optional summary and Slack notification.

### Syntax

```bash
./scripts/session.sh stop <session-id> [--notes <text>] [--post]
```

### Arguments

- `session-id` - UUID of session to stop

### Options

- `--notes <text>` - Summary notes for handoff
- `--post` - Trigger Slack update

### Behavior

1. Load session JSON by ID
2. Validate session exists
3. Update `ended_at` timestamp
4. Change status to "completed"
5. Append notes if provided
6. Persist changes
7. Optionally post to Slack

### Output

```json
{
  "session_id": "3f12b5d4-a6b7-4521-9f42-2b9f06fb8d6a",
  "ended_at": "2025-01-17T19:10:31Z",
  "status": "completed"
}
```

### Examples

```bash
# Basic stop
./scripts/session.sh stop 3f12b5d4-a6b7-4521-9f42-2b9f06fb8d6a

# With notes
./scripts/session.sh stop abc123 --notes "Feature complete, needs testing"

# With Slack post
./scripts/session.sh stop abc123 --notes "Deployed to staging" --post
```

### Exit Codes

- `0` - Success
- `1` - Session not found
- `2` - Invalid session state

## session status

Display current active session or most recent completed session.

### Syntax

```bash
./scripts/session.sh status
```

### Behavior

1. Search for active session
2. If none active, find most recent by `started_at`
3. Display formatted summary
4. Show recent activities (last 5)

### Output

```
📊 Current Session
Session: 3f12b5d4-a6b7-4521-9f42-2b9f06fb8d6a
Agent: Codex
Started: 2025-01-17T18:20:00Z
Status: active
Recent activities:
• 18:25Z – analysis – Drafted research summary
• 18:45Z – code – Implemented session.sh
```

### Exit Codes

- `0` - Success
- `1` - No sessions found

## session history

List recent sessions with optional filtering and limit.

### Syntax

```bash
./scripts/session.sh history [--limit <N>] [--agent <name>] [--status <status>]
```

### Options

- `--limit <N>` - Max sessions to return (default: 10)
- `--agent <name>` - Filter by agent name
- `--status <status>` - Filter by status (active/paused/completed)

### Behavior

1. Scan `.claude/data/sessions/` directory
2. Parse JSON files
3. Apply filters
4. Sort by `started_at` descending
5. Limit results
6. Display formatted list

### Output

```
📋 Session History (last 10)

3f12b5d4... | Codex     | 2025-01-17 18:20 | completed | Implement session tracking
a1b2c3d4... | Claude    | 2025-01-17 14:30 | active    | Review API changes
9e8f7g6h... | Codex     | 2025-01-16 16:45 | completed | Database migration
```

### Examples

```bash
# Recent 5 sessions
./scripts/session.sh history --limit 5

# Only Codex sessions
./scripts/session.sh history --agent Codex

# Active sessions only
./scripts/session.sh history --status active
```

### Exit Codes

- `0` - Success (even if no results)
- `1` - Invalid filter values

## session show

Display detailed information for a specific session.

### Syntax

```bash
./scripts/session.sh show <session-id>
```

### Arguments

- `session-id` - UUID of session to display

### Behavior

1. Load session JSON
2. Pretty-print with jq
3. Highlight key fields
4. Display all activities with full details

### Output

```json
{
  "session_id": "3f12b5d4-a6b7-4521-9f42-2b9f06fb8d6a",
  "agent_name": "Codex",
  "started_at": "2025-01-17T18:20:00Z",
  "ended_at": "2025-01-17T19:10:31Z",
  "status": "completed",
  "activities": [
    {
      "timestamp": "2025-01-17T18:25:00Z",
      "type": "analysis",
      "summary": "Drafted research summary",
      "files": ["docs/research/analysis.md"],
      "tools": ["filesystem"]
    }
  ],
  "files_modified": ["scripts/session.sh"],
  "notes": "Ready for testing"
}
```

### Examples

```bash
# Show full session
./scripts/session.sh show 3f12b5d4-a6b7-4521-9f42-2b9f06fb8d6a

# Pipe to grep for filtering
./scripts/session.sh show abc123 | grep -A5 activities
```

### Exit Codes

- `0` - Success
- `1` - Session not found
- `2` - Invalid session file

## session post

Post or update session information to Slack.

### Syntax

```bash
./scripts/session.sh post [--id <session-id>] [--thread|-t] [--dry-run]
```

### Options

- `--id <session-id>` - Specific session (default: current active)
- `--thread|-t` - Reply to existing thread instead of new message
- `--dry-run` - Preview payload without posting

### Behavior

1. Load session by ID (or find active)
2. Read Slack channel from metadata
3. Build Block Kit payload
4. Check for existing message_ts
5. Post or update message
6. Store message_ts in session

### Examples

```bash
# Post current session
./scripts/session.sh post

# Post specific session
./scripts/session.sh post --id abc123

# Thread reply
./scripts/session.sh post --id abc123 --thread

# Preview without posting
./scripts/session.sh post --dry-run
```

### Exit Codes

- `0` - Success
- `1` - Session not found
- `2` - Slack API error
- `3` - Missing credentials

## Helper Commands

### session current

Get UUID of current active session.

```bash
./scripts/session.sh current
```

Output: `3f12b5d4-a6b7-4521-9f42-2b9f06fb8d6a`

### session validate

Validate session JSON against schema.

```bash
./scripts/session.sh validate <session-id>
```

Returns validation result and detailed errors if any.

## Common Usage Patterns

### Standard Workflow

```bash
# Start work
SESSION_ID=$(./scripts/session.sh start "My Task" | jq -r .session_id)

# Check status during work
./scripts/session.sh status

# Complete work
./scripts/session.sh stop "$SESSION_ID" --notes "Task completed" --post
```

### Multi-Session Management

```bash
# List all active
./scripts/session.sh history --status active

# Show details
./scripts/session.sh show <session-id>

# Stop specific session
./scripts/session.sh stop <session-id>
```

### Slack Integration

```bash
# Auto-post enabled
./scripts/session.sh start "Deploy" --auto-post --channel #deployments

# Manual updates
./scripts/session.sh post --id <session-id>

# Thread replies for progress
./scripts/session.sh post --id <session-id> --thread
```

## Error Messages

### Session Not Found

```
Error: Session not found: 3f12b5d4-a6b7-4521-9f42-2b9f06fb8d6a
Check session ID and try again.
```

### Invalid Status

```
Error: Invalid status 'running'. Must be one of: active, paused, completed
```

### Schema Validation Failed

```
Error: Schema validation failed
data.session_id: must match format "uuid"
data.started_at: must match format "date-time"
```

### Slack Token Missing

```
Error: SLACK_BOT_TOKEN not set
Set with: export SLACK_BOT_TOKEN=xoxb-...
```

## Implementation Notes

### TypeScript Wrappers

Commands `status`, `history`, and `show` are implemented as TypeScript for rich formatting:

```typescript
// scripts/session_status.ts
import { loadSession, formatSessionStatus } from './lib/session';

const session = await loadSession('current');
console.log(formatSessionStatus(session));
```

### Bash Controller

Main `session.sh` routes commands and handles basic CRUD:

```bash
case "${1:-help}" in
  start) shift; command_start "$@" ;;
  stop) shift; command_stop "$@" ;;
  status) shift; ./scripts/session_status.ts "$@" ;;
  # ...
esac
```

### Hooks

Lifecycle events trigger hooks in `.claude/hooks/`:

```bash
# .claude/hooks/session_start.sh
#!/bin/bash
SESSION_ID="$1"
if [ "$(jq -r .auto_post "$SESSION_FILE")" = "true" ]; then
  ./scripts/session.sh post --id "$SESSION_ID"
fi
```
