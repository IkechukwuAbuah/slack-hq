---
title: Session Tracking Platform
linear_id: SLHQ-241
type: spec
status: draft
created: 2025-01-17
updated: 2025-01-17
author: Codex (Architecture & Design Lead)
related:
  - docs/research/session-tracking-analysis.md
---

# Session Tracking Platform

## Section 1: Feature Overview
Session tracking provides a unified audit trail for all AI Council agents collaborating inside slack-hq. It captures when a session begins, what activities occur, which files change, and how progress is surfaced to the Council via Slack.

**Problem Statement**: Agents lack a shared view of ongoing work, making handoffs brittle and losing institutional memory between sessions.

**Proposed Solution**: Introduce a `/session` slash command suite, backed by structured JSON session files, lifecycle hooks, and Council Bot messaging. The workflow mirrors the proven claude md implementation while aligning with slack-hq conventions.

**User Stories**
- *SLHQ-301 (Claude Code)*: “As a build-focused agent, I want `/session start` to stamp my task with metadata so others can see progress without digging through logs.”
- *SLHQ-302 (Codex)*: “As a coding agent, I want `/session history` to list recent sessions so I can resume or review ongoing work.”
- *SLHQ-303 (Council Ops)*: “As a coordinator, I want Slack updates summarizing key milestones so I can assign follow-up tasks.”

**Success Criteria**
- Every active session writes JSON with validated metadata.
- Agents can fetch session status/history within two CLI commands.
- Council Bot posts are formatted with Block Kit and include links to spec, issue, and research.

## Section 2: Technical Design

### 2.1 Data Schema
```json
{
  "session_id": "uuid",
  "agent_name": "string",
  "started_at": "ISO8601",
  "ended_at": "ISO8601 | null",
  "project": "slack-hq",
  "working_directory": "path",
  "status": "active | paused | completed",
  "auto_post": false,
  "slack_channel": "#council-ops",
  "slack_message_ts": null,
  "slack_thread_ts": null,
  "activities": [
    {
      "timestamp": "ISO8601",
      "type": "code | analysis | meeting | deployment",
      "summary": "string",
      "details": "string",
      "files": ["src/example.ts"],
      "tools": ["apply_patch", "npm test"],
      "linked_issue": "SLHQ-301"
    }
  ],
  "prompts": ["raw prompt text"],
  "tools_used": ["apply_patch", "slack"],
  "files_modified": ["docs/specs/session-tracking.md"],
  "tags": ["session", "phase-1"],
  "notes": "Freeform summary and handoff guidance",
  "handoff_status": {
    "state": "none | requested | transferred",
    "assignee": "agent id or name",
    "notes": "handoff commentary"
  }
}
```

**Schema validation**: Implement JSON Schema v7 stored at `config/schemas/session.json` to enforce required fields and enumerations before persisting files.

### 2.2 File Structure
```
.claude/
  commands/
    session/
      status.md
      history.md
      start.md
      stop.md
      show.md
      post.md
  data/
    sessions/
      .gitkeep
  hooks/
    session_start.sh
    session_stop.sh
config/
  schemas/
    session.json
docs/
  research/
    session-tracking-analysis.md
  specs/
    session-tracking.md
scripts/
  session.sh
  slack/
    session_post_payload.json
tests/
  session/
    session-schema.spec.ts
```

### 2.3 Command Specifications
- `/session status`: Prints current session summary; falls back to latest completed session if none active.
- `/session history [--limit N]`: Lists sessions sorted by `started_at` descending.
- `/session start [name] [--auto-post] [--channel]`: Generates UUID, writes JSON, optionally toggles auto-post and Slack channel.
- `/session stop [--notes] [--post]`: Stamps `ended_at`, appends final activity, optionally posts to Slack.
- `/session show <id>`: Outputs detailed JSON summary (pretty-printed) and highlights key activities.
- `/session post [--id <id>] [--thread|-t]`: Posts update to Slack using stored metadata; default uses current active session.

### 2.4 Script Implementation (`scripts/session.sh`)
```bash
#!/usr/bin/env bash
set -euo pipefail

DATA_DIR=".claude/data/sessions"
SCHEMA="config/schemas/session.json"

ensure_dirs() {
  mkdir -p "$DATA_DIR"
}

load_json() {
  local id="$1"
  cat "$DATA_DIR/$id.json"
}

validate_json() {
  local payload="$1"
  npx --yes ajv-cli validate -s "$SCHEMA" -d <(echo "$payload")
}

command_start() {
  ensure_dirs
  local name="${1:-Unnamed Session}"
  local id
  id=$(uuidgen)
  local now
  now=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  local payload
  payload=$(jq -n --arg id "$id" \
    --arg name "$name" --arg now "$now" \
    '{session_id:$id, agent_name:$name, started_at:$now, ended_at:null, project:"slack-hq", working_directory:$PWD, status:"active", auto_post:false, slack_channel:null, activities:[], prompts:[], tools_used:[], files_modified:[], tags:[], notes:"", handoff_status:{state:"none", assignee:null, notes:""}}')
  validate_json "$payload"
  echo "$payload" >"$DATA_DIR/$id.json"
  jq '{session_id, started_at, working_directory}' <<<"$payload"
}

command_stop() {
  ensure_dirs
  local id="$1"
  local path="$DATA_DIR/$id.json"
  jq --arg end "$(date -u +%Y-%m-%dT%H:%M:%SZ)" '.ended_at=$end | .status="completed"' "$path" | sponge "$path"
  jq '{session_id, ended_at, status}' "$path"
}

case "${1:-help}" in
  start) shift; command_start "$@" ;;
  stop) shift; command_stop "$@" ;;
  status) shift; ./scripts/session_status.ts "$@" ;;
  history) shift; ./scripts/session_history.ts "$@" ;;
  show) shift; ./scripts/session_show.ts "$@" ;;
  post) shift; ./scripts/session_post.ts "$@" ;;
  *) echo "Usage: $0 {start|stop|status|history|show|post}" >&2; exit 1 ;;
esac
```

### 2.5 State Machine Diagram
```
┌────────────┐   start    ┌──────────────┐   stop     ┌─────────────┐
│  idle/off  ├──────────►│  active      ├──────────►│  completed  │
└────────────┘           └──────┬───────┘            └─────┬───────┘
                                 │ resume                     │ reopen
                                 ▼                           ▼
                               paused ───────────────────► active
```

## Section 3: Slack Integration

### 3.1 API Endpoints
- `chat.postMessage`: Post session updates and summaries.
- `chat.update`: Revise messages when sessions progress.
- `conversations.history`: Retrieve existing threads for threading decisions.
- `users.info`: Resolve agent display names when necessary.

### 3.2 Message Templates
`scripts/slack/session_post_payload.json` (rendered through `jq`):
```json
{
  "channel": "#council-ops",
  "text": "📊 Session Update: {{session_id}}",
  "blocks": [
    {"type": "header", "text": {"type": "plain_text", "text": "📊 {{title}}"}},
    {"type": "section", "text": {"type": "mrkdwn", "text": "*Agent*: {{agent_name}}\n*Status*: {{status}}\n*Started*: {{started_at}}"}},
    {"type": "section", "text": {"type": "mrkdwn", "text": "*Highlights*:\n{{highlights}}"}},
    {"type": "context", "elements": [
      {"type": "mrkdwn", "text": "Spec: docs/specs/session-tracking.md"},
      {"type": "mrkdwn", "text": "Research: docs/research/session-tracking-analysis.md"},
      {"type": "mrkdwn", "text": "Issue: SLHQ-241"}
    ]}
  ]
}
```

### 3.3 Posting Rules
- Manual `/session post` posts to `slack_channel` stored in metadata (default `#council-ops`).
- When `auto_post=true`, hooks trigger `session.sh post --id <id> --auto` during start/stop.
- Channel overrides allowed via `/session start --channel #feature-labs`.
- Updates to existing posts use message `ts` stored in metadata; subsequent updates append to the same thread.

### 3.4 Threading Strategy
- Default: Start a thread for each session using the initial message `ts` and store `slack_thread_ts`.
- Additional updates use `chat.postMessage` with `thread_ts`.
- Optionally pin final post when status transitions to `completed`.

### 3.5 Error Handling
- Missing token: abort with actionable error (`echo "SLACK_BOT_TOKEN not set" >&2; exit 2`).
- HTTP failure: log response body to `logs/slack-post-errors.log` for triage.
- Rate limits: inspect `Retry-After` header, sleep, and retry up to 3 times.
- Validation failure: abort before network call when payload exceeds Slack block limit (use `jq` length checks).

## Section 4: Implementation Guide

### 4.1 Command Development Steps
1. Generate schema (`config/schemas/session.json`) and add validator helper in `scripts/session.sh`.
2. Implement `start`, `stop`, `status`, `history`, `show`, `post` subcommands in Bash/TypeScript wrappers.
3. Populate `.claude/commands/session/*.md` with step-by-step instructions for agents, referencing CLI commands and inline formatting guidance (output styles are deprecated).
4. Update `CLAUDE.md` with workflow primer linking to spec and research.

### 4.2 Testing Procedures
- **Unit tests** (`tests/session/session-schema.spec.ts`): Validate JSON serialization/deserialization, ensure required fields present, confirm state transitions.
- **Integration tests**: Mock Slack CLI via `slack api chat.postMessage --dry-run` (use stub script). Validate that auto-post flag triggers commands.
- **Manual QA checklist**:
  - `./scripts/session.sh start "Codex Spike"`
  - `./scripts/session.sh status`
  - Edit a file, run `./scripts/session.sh stop <id> --notes "Documented spec"`
  - `./scripts/session.sh post --id <id> --noop` (dry run) and verify payload.

### 4.3 Rollout Plan
1. Land Phase 1 persistence in a feature branch; include `.gitkeep` to create directory.
2. Release slash commands with doc updates and CLI usage examples; require Council review.
3. Enable Slack posting once tokens verified in staging workspace.
4. Announce completion via `#council-ops` update and update `docs/runbooks` with session management runbook.

### 4.4 Migration Plan
- Parse existing `logs/status_line.json` to seed historical sessions using a migration script (`scripts/session_migrate.py`).
- For each entry, map `session_id`, `timestamp`, and `cwd` into new JSON files with minimal metadata.
- Mark migrated sessions with tag `legacy-import` and status `completed`.

### 4.5 Future Enhancements
1. Analytics dashboard summarizing session durations and active agents.
2. Cross-project linking to reference tasks in other repositories.
3. Session templates pre-populating activities for common workflows (e.g., release, incident).
4. AI-generated summaries appended to Slack posts leveraging `openai` or `anthropic` APIs.

### 4.6 Success Metrics
- Adoption: ≥80% of agents execute `/session start` before editing files.
- Slack engagement: ≥3 reactions/comments per milestone post.
- Handoff success: 90% of `handoff_status` transitions include assignee and note.
- System reliability: <1% schema validation failures per week.

## Section 5: Usage Examples

### 5.1 Example Workflow
```bash
./scripts/session.sh start "Initialize Session Tracking" --auto-post --channel #council-ops
./scripts/session.sh status
./scripts/session.sh history --limit 5
./scripts/session.sh post --summary "Drafted spec and research" --id $(./scripts/session.sh current)
./scripts/session.sh stop $(./scripts/session.sh current) --notes "Ready for implementation"
```

### 5.2 Expected CLI Outputs
```
📊 Current Session
Session: 3f12b5d4-a6b7-4521-9f42-2b9f06fb8d6a
Agent: Codex
Started: 2025-01-17T18:20:00Z
Status: active
Recent activities:
• 18:25Z – analysis – Drafted research summary

✅ Session completed
Session: 3f12b5d4-a6b7-4521-9f42-2b9f06fb8d6a
Ended: 2025-01-17T19:10:31Z
Notes: Ready for implementation
```

### 5.3 Slack Message Sample
```json
{
  "channel": "#council-ops",
  "text": "📊 Session Update: Initialize Session Tracking",
  "blocks": [
    {"type": "header", "text": {"type": "plain_text", "text": "📊 Initialize Session Tracking"}},
    {"type": "section", "text": {"type": "mrkdwn", "text": "*Agent*: Codex\n*Status*: Completed\n*Highlights*:\n• Drafted research report\n• Authored implementation spec"}},
    {"type": "context", "elements": [
      {"type": "mrkdwn", "text": "Spec → docs/specs/session-tracking.md"},
      {"type": "mrkdwn", "text": "Issue → SLHQ-241"}
    ]}
  ]
}
```

## Section 6: ADRs

### ADR 001: JSON over SQLite for Storage
- **Status**: Accepted
- **Context**: Agents need portable, diffable files without introducing DB dependencies.
- **Decision**: Use JSON files stored per session in `.claude/data/sessions/`.
- **Consequences**: Easy local editing and review; requires schema validation to prevent drift.

### ADR 002: Session Data Gitignore Strategy
- **Status**: Accepted
- **Context**: Session files may contain sensitive prompts and tokens.
- **Decision**: Keep `.claude/data/sessions/` gitignored while shipping `.gitkeep` to preserve directory.
- **Consequences**: Session data stays local; analytics requiring central storage must export sanitized datasets separately.

### ADR 003: Slack Auto-posting vs Manual Posting
- **Status**: Accepted
- **Context**: Need to balance visibility with channel noise.
- **Decision**: Default to manual `/session post` with per-session `auto_post` flag toggled at start; hooks respect flag for automated updates.
- **Consequences**: Agents stay in control; requires metadata field and hooks to check flag.

### ADR 004: Multi-Agent Concurrency Model
- **Status**: Accepted
- **Context**: Multiple agents may collaborate simultaneously across initiatives.
- **Decision**: Allow concurrent sessions, each with explicit `agent_name`, optional `workspace_id`, and `handoff_status`. `/session history` highlights active sessions, and `/session show` exposes ownership.
- **Consequences**: Requires CLI filtering by agent and ensures session files include owner metadata; additional guard rails may be added later (e.g., warnings if same directory active).

---

### Appendices
- Research report: `docs/research/session-tracking-analysis.md`
- Slack CLI references: `docs/slack-cli-capabilities.md`
- GitHub Issue Draft: SLHQ-241 (see communication deliverables)
