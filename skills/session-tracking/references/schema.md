# Session JSON Schema

Complete specification for session data structure and validation rules.

## Schema Location
`config/schemas/session.json` - JSON Schema v7 format

## Required Fields

```json
{
  "session_id": "uuid",          // UUIDv4 format
  "agent_name": "string",        // Agent identifier
  "started_at": "ISO8601",       // UTC timestamp
  "project": "slack-hq",         // Project name
  "working_directory": "path",   // Absolute path
  "status": "active|paused|completed"
}
```

## Optional Fields

### Slack Integration
```json
{
  "auto_post": false,              // Boolean - auto Slack posting
  "slack_channel": "#council-ops", // Channel for updates
  "slack_message_ts": null,        // Message timestamp for updates
  "slack_thread_ts": null          // Thread timestamp for replies
}
```

### Activity Tracking
```json
{
  "activities": [
    {
      "timestamp": "ISO8601",
      "type": "code|analysis|meeting|deployment",
      "summary": "Brief description",
      "details": "Longer explanation (optional)",
      "files": ["relative/path/to/file.ts"],
      "tools": ["tool_name", "command"],
      "linked_issue": "SLHQ-XXX"
    }
  ]
}
```

Activity types:
- **code**: File modifications, refactoring, bug fixes
- **analysis**: Research, investigation, documentation review
- **meeting**: Discussions, planning, coordination
- **deployment**: Releases, infrastructure changes, rollouts

### Metadata Collections
```json
{
  "prompts": ["raw prompt text"],                    // Input prompts
  "tools_used": ["apply_patch", "slack"],            // Tools invoked
  "files_modified": ["docs/specs/example.md"],       // Changed files
  "tags": ["session", "phase-1", "high-priority"],  // Categorization
  "notes": "Freeform summary and handoff guidance"   // Agent notes
}
```

### Handoff Management
```json
{
  "handoff_status": {
    "state": "none|requested|transferred",
    "assignee": "agent-id-or-name",
    "notes": "Context for next agent"
  }
}
```

Handoff states:
- **none**: No handoff requested
- **requested**: Handoff initiated, awaiting transfer
- **transferred**: Successfully handed to assignee

### Timestamp Management
```json
{
  "ended_at": "ISO8601 | null"  // Completion timestamp
}
```

## Validation Rules

### String Constraints
- session_id: Must be valid UUIDv4
- agent_name: Non-empty string, max 100 chars
- project: Fixed value "slack-hq"
- working_directory: Valid absolute path
- status: Enum ["active", "paused", "completed"]

### Timestamp Format
- ISO8601 UTC format: `YYYY-MM-DDTHH:MM:SSZ`
- Example: `2025-01-17T18:20:00Z`
- Generate with: `date -u +%Y-%m-%dT%H:%M:%SZ`

### Array Constraints
- activities: Each item must have timestamp, type, summary
- prompts, tools_used, files_modified, tags: Array of strings
- Empty arrays are valid

### Nested Object Validation
- handoff_status: All three fields required (state, assignee, notes)
- Slack fields: message_ts and thread_ts must match Slack timestamp format

## Example Complete Session

```json
{
  "session_id": "3f12b5d4-a6b7-4521-9f42-2b9f06fb8d6a",
  "agent_name": "Codex",
  "started_at": "2025-01-17T18:20:00Z",
  "ended_at": "2025-01-17T19:10:31Z",
  "project": "slack-hq",
  "working_directory": "/workspace/slack-hq",
  "status": "completed",
  "auto_post": true,
  "slack_channel": "#council-ops",
  "slack_message_ts": "1705516800.123456",
  "slack_thread_ts": "1705516800.123456",
  "activities": [
    {
      "timestamp": "2025-01-17T18:25:00Z",
      "type": "analysis",
      "summary": "Reviewed session tracking requirements",
      "details": "Analyzed existing patterns and integration points",
      "files": ["docs/research/session-tracking-analysis.md"],
      "tools": ["filesystem", "text-analysis"],
      "linked_issue": "SLHQ-241"
    },
    {
      "timestamp": "2025-01-17T18:45:00Z",
      "type": "code",
      "summary": "Implemented session.sh script",
      "details": "Created bash controller with start/stop commands",
      "files": ["scripts/session.sh"],
      "tools": ["bash", "jq", "uuidgen"],
      "linked_issue": "SLHQ-301"
    }
  ],
  "prompts": [
    "Create session tracking implementation",
    "Add Slack integration support"
  ],
  "tools_used": ["bash", "jq", "uuidgen", "slack-api"],
  "files_modified": [
    "scripts/session.sh",
    "config/schemas/session.json",
    "docs/specs/session-tracking.md"
  ],
  "tags": ["session", "phase-1", "slack-integration"],
  "notes": "Implementation complete. Ready for testing and Slack integration validation.",
  "handoff_status": {
    "state": "transferred",
    "assignee": "QA-Agent",
    "notes": "Please validate Slack posting and schema validation"
  }
}
```

## Validation Command

```bash
npx --yes ajv-cli validate -s config/schemas/session.json -d session.json
```

Returns exit code 0 on success, non-zero with error details on failure.

## Common Validation Errors

**Missing required field:**
```
Error: data must have required property 'session_id'
```
Fix: Ensure all required fields present in JSON

**Invalid enum value:**
```
Error: data.status must be equal to one of the allowed values
```
Fix: Use only "active", "paused", or "completed"

**Invalid UUID format:**
```
Error: data.session_id must match format "uuid"
```
Fix: Generate with `uuidgen` or valid UUID library

**Invalid timestamp:**
```
Error: data.started_at must match format "date-time"
```
Fix: Use ISO8601 format with timezone (Z suffix)
