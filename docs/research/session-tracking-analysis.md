# Session Tracking Implementation Research

## 1. Executive Summary
Session tracking will provide the slack-hq initiative with chronological, queryable records of agent activity so multi-agent work stays auditable and handoffs remain smooth. Drawing from the mature session manager in the claude md project, we will transpose persistent session metadata, lifecycle hooks, and Slack-facing touchpoints into slack-hq’s lightweight scaffold. The resulting capability enables agents to see who is working on what, when progress changed, and how to resume or review prior work without losing context.

## 2. Current State Analysis (slack-hq)
- **Repository structure**: Runtime code has not been introduced yet; coordination assets live in `docs/`, with tooling scaffolding under `.claude/` and shell scripts in `scripts/`. There is no dedicated session storage or lifecycle automation.
- **.claude directory**: Contains `commands/sync-docs.md` only. No hooks, data directories, or output styles have been defined for session management.
- **Logging**: `logs/status_line.json` records historical status line telemetry from Claude Code runs (timestamps, session IDs, cost metrics) but stores no per-session narrative or metadata.
- **Slack integration**: Council Bot setup scripts exist (`scripts/slack-setup.sh`) and `docs/slack-cli-capabilities.md` catalogues CLI usage, yet no automation currently emits session updates.
- **Configuration**: `.env.example` lists Slack tokens, but there are no environment variable validations or guards enforcing session metadata collection.

## 3. Reference Implementation Review (claude md)
- **Session persistence**: `.claude/data/sessions/*.json` holds per-session files keyed by UUID with prompt history and (in newer files) supplementary metadata. Files are untracked by git to avoid leaking sensitive history.
- **Lifecycle hooks**: `hooks/session_start.py` captures session source, timestamps, git state, and bootstraps contextual files; `hooks/stop.py` records stop events, optionally copies transcripts, and triggers audible completion.
- **Status line integration**: `status-lines/status_line_v5.py` enriches CLI feedback with session metadata by reading `.claude/data/sessions/{session_id}.json`, showing active prompts, git status, and icons.
- **CLI presentation**: With output styles deprecated, the reference repo now favors direct CLI helpers to format session summaries, which we can emulate via dedicated status commands in slack-hq.
- **Logging approach**: Hooks append structured JSON to `logs/session_start.json` and `logs/stop.json`, offering historical auditing beyond session files.
- **Slack usage**: The reference implementation does not directly auto-post to Slack but demonstrates how hooks provide integration points for downstream notifications.

## 4. Gap Analysis
- **Missing capabilities**: slack-hq lacks session file storage, lifecycle hooks, and any user commands to read/write session data. There is no CLI entry point (slash command or script) to manage sessions.
- **Infrastructure to leverage**: Existing `.claude` scaffolding, Slack CLI setup docs, and `logs/status_line.json` provide the foundation for command placement, environment bootstrap, and history correlation.
- **New components required**: Session data directory, hook scripts, command markdown templates, Council Bot integration scripts, and documentation/specification assets.
- **Council Bot alignment**: Current automation does not touch Slack; we must decide on auto vs manual posting and define message formatting.

## 5. Architecture Design & Key Decisions

### ADR-001: Session Data Location
- **Status**: Proposed
- **Context**: Need a canonical storage path accessible to hooks and commands without polluting git history.
- **Decision**: Store session JSON files under `.claude/data/sessions/` with `.gitignore` coverage. This mirrors claude md conventions, keeps data co-located with automation assets, and isolates sensitive timelines from git.
- **Consequences**: Requires ensuring `.gitignore` excludes the directory; automation must create the path if missing. Enables shared tooling between repositories.

### ADR-002: Lifecycle Hook Implementation
- **Status**: Proposed
- **Context**: slack-hq currently triggers no automation on session start/stop, so the system cannot capture metadata automatically.
- **Decision**: Introduce `hooks/session_start.sh` and `hooks/session_stop.sh` (shell thin wrappers) that read stdin payloads and invoke TypeScript/Node or Python helpers to persist session metadata, mirroring the Python scripts in the reference repo but aligned with slack-hq’s future toolchain.
- **Consequences**: Ensures portability across agents (shell + Node). Hooks can later call Slack posting routines or validate env variables before writing data.

### ADR-003: Council Bot Posting Strategy
- **Status**: Proposed
- **Context**: Need alignment on when Slack messages should be published to avoid noise while keeping stakeholders informed.
- **Decision**: Default to manual posting via `/session post`, with optional opt-in auto-post toggles per session (stored in metadata). This balances signal vs noise and allows agents to consciously share updates for significant milestones.
- **Consequences**: Hooks must respect an `auto_post` flag; manual command must accept channel overrides and format Block Kit payloads consistently.

## 6. File Structure Proposal
```text
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
docs/
  research/
    session-tracking-analysis.md
  specs/
    session-tracking.md
scripts/
  session.sh
```

## 7. Implementation Roadmap
- **Phase 1 – Session Persistence (2–3 days)**
  - Implement hooks to capture session start/stop events, write JSON using the schema defined in the design spec.
  - Add environment validation and `.gitignore` updates.
  - Provide smoke-test script: `./scripts/session.sh record-start` and `./scripts/session.sh record-stop`.
- **Phase 2 – Slash Command Interface (3–4 days)**
  - Fill `.claude/commands/session/*.md` with prompts to drive `/session` subcommands.
  - Implement CLI parsing in `scripts/session.sh` (Node or Bash) to read/write session files and present summaries.
  - Unit-test serialization helpers via `npm test -- session` once test harness exists.
- **Phase 3 – Slack Integration (2–3 days)**
  - Add `./scripts/session.sh post` invoking `slack api chat.postMessage` with JSON templates.
  - Support automatic posting when `auto_post` metadata is true; include channel selection and threading options.
  - Validate with manual command: `SLACK_BOT_TOKEN=... ./scripts/session.sh post --session <id>`.
- **Phase 4 – Status Line & Realtime Tracking (2 days)**
  - Extend status line script to read new JSON fields (activities, tags).
  - Display session ID, elapsed time, Slack channel, and last activity in `logs/status_line.json` output.
  - Add a CLI regression test: `./scripts/session.sh status-line-preview` to verify formatting.

## 8. Risk Assessment
- **Data drift**: Without validation, session JSON could become inconsistent across agents. Mitigation: centralize schema validation helper and run on every write.
- **Slack noise**: Over-posting could overwhelm #council-ops. Mitigation: default manual posting; expose per-session `auto_post` flag with channel overrides.
- **Concurrent edits**: Multiple agents writing the same session file may cause race conditions. Mitigation: include session ownership metadata and optimistic locking (timestamp check) in Phase 2.
- **Security**: Tokens stored in `.env`; ensure scripts fail gracefully if `SLACK_BOT_TOKEN` missing or scope insufficient.
- **Adoption**: Agents may forget to start/stop sessions. Mitigation: integrate reminders in hooks/status line and document workflow in CLAUDE.md.

## 9. Success Metrics
- **Adoption**: ≥80% of agent-led tasks initiated via `/session start` within first month.
- **Coverage**: 100% of active sessions produce corresponding JSON entries with start/stop timestamps.
- **Engagement**: Average of ≥1 curated Slack update per active sprint.
- **Handoff quality**: ≥90% of session handoffs include notes/activities fields filled.
- **Operational reliability**: No more than 1% of sessions fail schema validation during writes.

## 10. Slack Integration Patterns
- **Posting updates**:
  ```bash
  slack api chat.postMessage \
    --data '{"channel":"#council-ops","text":"📊 Session Update","blocks":[]}' \
    --token "$SLACK_BOT_TOKEN"
  ```
- **Fetching channel history for context merging**:
  ```bash
  slack api conversations.history \
    --data '{"channel":"#council-ops","limit":20}' \
    --token "$SLACK_BOT_TOKEN"
  ```
- **Storing Slack thread IDs**: persist `slack_message_ts` and `slack_thread_ts` in session metadata for follow-up posts.

## 11. Testing Commands (Conceptual)
- Validate schema: `npm test -- session-schema` (to be implemented).
- Dry-run CLI: `./scripts/session.sh status --session latest --dry-run`.
- Slack posting smoke test (with dummy token): `SLACK_BOT_TOKEN=fake ./scripts/session.sh post --session latest --noop`.

## 12. Key Questions Answered
1. **Should session data be git-tracked?** No, keep under `.claude/data/sessions/` and gitignore it to protect sensitive context while enabling local analytics (ADR-001).
2. **Granularity of tracking?** Per-session (per agent task) with optional activity entries per command; focus on start/stop plus append-only activity log for command-level notes.
3. **Auto-post vs on-demand?** Manual by default with opt-in auto-post flag captured in metadata (ADR-003).
4. **Valuable metadata?** Agent name, timestamps, cwd, active tool list, files touched, Slack message references, tags (initiative, priority), and ownership/hand-off notes.
5. **Concurrent agents?** Allow multiple active sessions distinguished by session IDs and owner fields; expose discovery commands listing active sessions and include `handoff_status` to coordinate transitions.

## 13. References
- claude md session manager assets: `/Users/x/Downloads/claude md/.claude/{hooks,status-lines,data}`
- slack-hq telemetry: `logs/status_line.json`
- Council Bot capabilities: `docs/slack-cli-capabilities.md`
