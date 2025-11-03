---
name: session-tracking
description: Session tracking system for AI Council agents collaborating in slack-hq workspace. Use when implementing or working with `/session` commands to track agent activities, manage collaborative workflows, create audit trails, or integrate with Slack for progress updates. Handles session lifecycle (start/stop/pause), structured JSON storage, CLI commands, Slack integration, and multi-agent coordination.
---

# Session Tracking

Session tracking provides a unified audit trail for AI Council agents collaborating in the slack-hq workspace, capturing activities, file changes, and surfacing progress via Slack.

## When to Use This Skill

Use this skill when:
- Implementing `/session` CLI commands (start, stop, status, history, show, post)
- Creating or validating session JSON files with proper schema
- Managing session lifecycle and state transitions
- Integrating with Slack for Council Bot updates
- Setting up multi-agent coordination and handoffs
- Building analytics or reporting on agent activities

## Core Workflow

### 1. Starting a Session

```bash
./scripts/session.sh start "Task Name" [--auto-post] [--channel #council-ops]
```

Creates a new session with:
- UUID generation for unique session_id
- ISO8601 timestamp
- Agent name and working directory
- Optional auto-posting to Slack
- Validates against JSON schema before persisting

### 2. Managing Session State

Sessions follow this state machine:
```
idle → active → completed
         ↓ ↑
       paused
```

Track activities throughout:
- Code changes
- Analysis work
- Meetings
- Deployments

### 3. Stopping a Session

```bash
./scripts/session.sh stop <session-id> [--notes "Summary"] [--post]
```

Stamps end time, marks completed, optionally posts to Slack.

### 4. Querying Sessions

- `/session status` - Current or latest session
- `/session history [--limit N]` - Recent sessions
- `/session show <id>` - Detailed session view

## Data Schema

Sessions are stored as JSON in `.claude/data/sessions/<uuid>.json`:

**Required fields:**
- session_id, agent_name, started_at, project, working_directory, status

**Key structures:**
- activities[] - Timestamped events with type, summary, files, tools
- handoff_status - For multi-agent coordination
- slack_channel, slack_message_ts - For threading updates
- tags[] - For categorization
- notes - Freeform handoff guidance

See `references/schema.md` for complete data model.

## Implementation Patterns

### Session Initialization
1. Generate UUID
2. Create JSON with required fields
3. Validate against schema (`config/schemas/session.json`)
4. Persist to `.claude/data/sessions/`
5. Return session summary

### Activity Logging
Append to activities array:
```json
{
  "timestamp": "ISO8601",
  "type": "code|analysis|meeting|deployment",
  "summary": "Brief description",
  "files": ["path/to/file"],
  "tools": ["tool_name"],
  "linked_issue": "SLHQ-XXX"
}
```

### Slack Integration
- Manual: `/session post [--id <id>]` 
- Automatic: `auto_post=true` triggers hooks
- Threading: Store message_ts for thread continuity
- Block Kit formatting with links to specs/issues

See `scripts/slack_post.sh` for implementation.

### Multi-Agent Coordination
- Each session explicitly names agent_name
- handoff_status tracks transfers:
  - state: none → requested → transferred
  - assignee: target agent
  - notes: context for handoff

## File Structure

```
.claude/
  commands/session/    - Agent-facing command docs
  data/sessions/       - Session JSON files (gitignored)
  hooks/              - Lifecycle automation
config/
  schemas/session.json - JSON Schema v7 validation
scripts/
  session.sh          - Main CLI controller
  session_*.ts        - Command implementations
  slack/              - Slack integration scripts
```

## Error Handling

**Schema Validation:**
- Validate JSON before persistence using ajv-cli
- Abort on validation failure with clear error message

**Slack Integration:**
- Check SLACK_BOT_TOKEN presence
- Log failures to `logs/slack-post-errors.log`
- Handle rate limits with Retry-After header (max 3 retries)
- Validate payload size before posting

**File Operations:**
- Create directories if missing (`mkdir -p`)
- Use atomic writes with temporary files
- Handle missing sessions gracefully

## Testing Approach

**Unit Tests** (`tests/session/session-schema.spec.ts`):
- JSON serialization/deserialization
- Required field validation
- State transition logic

**Integration Tests**:
- Mock Slack API with dry-run mode
- Test auto-post flag behavior
- Verify threading logic

**Manual QA Checklist**:
1. Start session with unique name
2. Check status output
3. Make file changes, log activities
4. Stop session with notes
5. Verify Slack post payload (dry-run)
6. Test history command filtering

## Migration

For existing systems with status_line.json:
- Use `scripts/session_migrate.py` to convert
- Map timestamp, session_id, cwd to new schema
- Tag with "legacy-import"
- Mark status as "completed"

## Success Metrics

- 80%+ agent adoption (execute `/session start` before work)
- 3+ reactions per milestone Slack post
- 90% handoffs include assignee and notes
- <1% schema validation failures weekly

## References

- **Schema Details**: `references/schema.md` - Complete JSON schema specification
- **Slack Integration**: `references/slack-integration.md` - API endpoints, message templates, threading strategy
- **CLI Commands**: `references/cli-commands.md` - Detailed command specifications and examples

## Quick Reference

**Start session:**
```bash
./scripts/session.sh start "My Task"
```

**Check status:**
```bash
./scripts/session.sh status
```

**Stop and post:**
```bash
./scripts/session.sh stop <id> --notes "Completed" --post
```

**View history:**
```bash
./scripts/session.sh history --limit 10
```
