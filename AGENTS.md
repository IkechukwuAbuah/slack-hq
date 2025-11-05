# Repository Guidelines

This repository is an empty scaffold for the Slack HQ initiative. Keep this guide close as you bring the first services online so that contributions remain predictable, reviewable, and easy to automate.

## Project Structure & Module Organization
The root currently contains `CLAUDE.md` (agent onboarding notes) and `logs/` (prior AI session telemetry). When you introduce code, place runtime modules under `src/`, shared configuration in `config/`, tests in `tests/`, and developer scripts in `scripts/`. Favor shallow slices over deep nesting; for example:

```
src/
  slack/
    client.ts
    workflows/
tests/
  slack/
    client.spec.ts
```

## Build, Test, and Development Commands
Record every runnable script in `package.json` or a `Makefile` so agents can execute them non-interactively. Expected baseline once tooling is added:

```
npm install          # install dependencies
npm run dev          # start the local Slack integration sandbox
npm test             # run the entire automated test suite
```

If another toolchain is chosen (e.g., Poetry, Taskfile), replicate the same triad: install, dev loop, and tests.

## Coding Style & Naming Conventions
Default to TypeScript with ES2022 targets. Use 2-space indentation, trailing commas, and single quotes. Name modules in kebab-case (`user-routing.ts`), export classes in PascalCase, and keep pure helpers in `utils/`. Enforce consistency with ESLint + Prettier (`npm run lint` and `npm run format` once configured). Document any intentional deviations directly in `CLAUDE.md`.

## Testing Guidelines
Adopt a fast unit runner (Jest or Vitest) and add integration coverage for Slack API flows. Mirror source paths inside `tests/`, suffixing files with `.spec.ts` or `.test.ts`. Ensure PRs include the relevant new or updated tests and keep coverage at ≥80% for core packages. Run `npm test -- --watch` during development to catch regressions early.

## Commit & Pull Request Guidelines
There is no existing Git history, so start with Conventional Commits (`feat:`, `fix:`, `chore:`). Link issues in the body, describe behavior changes, and list impacted services. Pull requests should state deployment impact, include screenshots or console logs for user-facing changes, and confirm the test command output. Flag any manual Slack workspace steps so reviewers can reproduce them.

## Slack Integration (Council Bot)

Council Bot exposes Slack capabilities to all agents (Claude Code, Codex, ChatGPT, Gemini, Grok, Cursor, Warp, Windsurf).

### Setup

1. Install Slack CLI: `brew install --cask slack-cli`
2. Run setup script: `./scripts/slack-setup.sh`
3. Complete OAuth flow in browser
4. Configure `.env` with tokens

### Usage Pattern for Agents

**Default to Slack MCP tools for all workspace operations.** Examples:

> ⚠️ **Codex limitation:** The Codex CLI cannot access Slack MCP tools in this environment. When you are operating as Codex, fall back to the Slack Web API workflow described below.

```javascript
// Post an update (preferred)
mcp__slack__slack_post_message({
  channel_id: "C09QAKDHKMG",
  text: "Automated update from Codex"
});

// Reply in an existing thread
mcp__slack__slack_reply_to_thread({
  channel_id: "C09QAKDHKMG",
  thread_ts: "1730659852.123456",
  text: "Follow-up context"
});
```

**Fallback (when MCP is unavailable):** Use the Web API directly with curl. The Slack CLI v3.9.0 does **not** support `slack api …` commands.

```bash
curl -X POST https://slack.com/api/chat.postMessage \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"channel":"C09Q761LJUD","text":"Automated update"}'
```

### Typical Flows

- **Channel lifecycle**: create → invite → set topic → post welcome
- **DM analysis**: read history (where permitted) → summarize → post result
- **Usergroup changes**: list → update members

**Reference**: [docs/slack-cli-capabilities.md](./docs/slack-cli-capabilities.md)

## Session Tracking for Agent Coordination

All agents working in the slack-hq workspace should use the session tracking system to maintain audit trails, coordinate handoffs, and share progress updates with The Council.

### Quick Start

When starting any significant work unit:

```bash
/session-start "Brief description of task"
```

When completing work:

```bash
/session-stop --notes "Summary of what was accomplished" --post
```

Check current status anytime:

```bash
/session-status
```

### Available Commands

- **`/session-start "task"`** - Begin tracking a work session
  - Generates UUID, timestamps, creates JSON file
  - Optional: `--auto-post` to notify Slack immediately
  - Optional: `--channel #channel-name` for custom notification channel

- **`/session-stop [session-id]`** - Complete a session
  - Defaults to current active session if no ID provided
  - Optional: `--notes "text"` to add completion summary
  - Optional: `--post` to share summary in Slack

- **`/session-status`** - View current/latest session details
  - Shows: ID, task, duration, activities, handoff status

- **`/session-history`** - List recent sessions
  - Optional: `--limit N` to control how many to show
  - Optional: `--status active|completed|paused` to filter
  - Optional: `--agent "name"` to filter by agent
  - Optional: `--search "term"` to find specific sessions

- **`/session-show <id>`** - Display comprehensive session details
  - Full activity log with timestamps
  - Files changed, tools used
  - Statistics and breakdowns

- **`/session-post [session-id]`** - Share session to Slack
  - Uses Block Kit formatting for rich display
  - Supports threading for ongoing updates
  - Optional: `--dry-run` to preview without posting

### Data Structure

Sessions are stored as JSON in `.claude/data/sessions/<uuid>.json`:

```json
{
  "session_id": "uuid",
  "agent_name": "Claude Code",
  "task": "Task description",
  "project": "slack-hq",
  "status": "active|paused|completed",
  "started_at": "ISO8601 timestamp",
  "ended_at": "ISO8601 timestamp",
  "activities": [
    {
      "timestamp": "ISO8601",
      "type": "code|analysis|meeting|deployment",
      "summary": "What happened",
      "files": ["paths"],
      "tools": ["tool names"],
      "linked_issue": "SLHQ-XXX"
    }
  ],
  "handoff_status": {
    "state": "none|requested|transferred",
    "assignee": "target agent",
    "notes": "context for handoff"
  },
  "slack_channel": "#council-ops",
  "slack_message_ts": "1234567890.123456",
  "tags": ["keywords"],
  "notes": "Additional context"
}
```

### Multi-Agent Coordination

**Handoff Pattern:**

When transferring work to another agent:

1. Document current state in session notes
2. Set handoff_status with target assignee
3. Post session summary to Slack: `/session-post --channel #council-ops`
4. Target agent starts new session referencing handoff

**Best Practices:**

- Start a session for each distinct work unit
- Log significant activities as you work (Claude tracks automatically)
- Link Linear issues when applicable
- Use meaningful task descriptions
- Post milestone updates to keep Council informed
- Complete sessions promptly to maintain accurate history

### 🚨 MANDATORY: Session Broadcasting

**REQUIREMENT: All agents MUST broadcast completed sessions to Slack.**

Every session completion MUST include the `--post` flag to ensure Council visibility:

```bash
/session-stop --notes "Work summary" --post
```

**Channel Guidelines:**

| Work Type | Channel | Channel ID |
|-----------|---------|------------|
| Session tracking (automated) | #council-core | C09QAKDHKMG |
| General updates | #announcements | C09Q8KCGM9C |
| Engineering | #engineering | C09QAL92HFC |
| Design/UX | #design-lab | C09QALF8WD8 |
| Operations | #council-ops | C09Q761LJUD |
| Documentation | #docs | C09Q76ULRHB |
| Deployments | #automation | C09R4SCGR24 |

**Note:** #council-core is the default channel for session tracking (automated updates), while #announcements is reserved for major human-initiated broadcasts.

**Broadcasting Requirements:**

✅ **MUST broadcast:**
- All completed sessions with deliverables
- Milestone achievements
- Multi-agent handoffs
- Blocked work requiring input
- Production deployments
- Significant refactors or architectural changes

❌ **Optional (no broadcast needed):**
- Exploratory work (< 15 minutes)
- Pure research with no outputs
- Failed/abandoned attempts
- Private drafts not ready for review

**Examples:**

```bash
# Standard completion
/session-stop --notes "Implemented user auth with full test coverage" --post

# Engineering work to specific channel
/session-stop --notes "Refactored API layer for better performance" --post --channel engineering

# Handoff with context
/session-stop --notes "Database schema ready. Frontend team can now implement UI" --post --channel announcements
```

**Enforcement:**

Non-compliance with session broadcasting:
- Reduces Council visibility into agent activities
- Breaks audit trails
- Complicates multi-agent coordination
- May result in duplicate work

All agents are expected to broadcast sessions consistently.

### Integration with Slack

Sessions integrate with Council Bot for team visibility:

- Auto-posting creates threaded conversations
- Activity updates can be streamed to channels
- Handoff requests generate notifications
- Session summaries use Block Kit formatting

### Schema Validation

All session data is validated against JSON Schema v7 before persistence. The schema ensures:

- Required fields are present
- Timestamps are valid ISO8601
- Status values are from allowed enum
- Activity types are recognized
- File paths and tool names are strings

Invalid data will fail with clear error messages.

### Implementation Details

- **Skill Location**: `.claude/skills/session-tracking/`
- **Command Definitions**: `.claude/commands/session-*.md`
- **Data Storage**: `.claude/data/sessions/*.json` (gitignored)
- **Scripts**: Shell and JSON utilities in skill directory
- **Schema**: JSON Schema v7 validation

**Reference**: Full documentation in `.claude/skills/session-tracking/SKILL.md`

**🔄 Future Enhancement (Proposed - SLHQ-17):**

A hooks-based automation system is proposed to replace manual session commands with automatic tracking:
- **Auto-creation**: SessionStart hook creates sessions automatically
- **Real-time tracking**: PreToolUse hook logs activities as they happen
- **Auto-completion**: Stop hook completes and posts to Slack
- **Zero intervention**: No manual /session-start or /session-stop needed
- **Status**: [SLHQ-17](https://linear.app/abuah/issue/SLHQ-17) (Proposed)
- **Details**: See [TOOL-REGISTRY.md](TOOL-REGISTRY.md#3-session-tracking-hooks)

## Claude Code Subagents

The slack-hq project utilizes specialized Claude Code subagents for focused tasks. These agents have separate context windows and custom instructions for specific domains.

### Tool Registry Manager (tool-registry-manager)

**Location:** `~/.claude/agents/tools/tool-registry-manager.md`

**Version:** 1.0.0

**Purpose:** Proactive management, validation, and lifecycle tracking for TOOL-REGISTRY.md

**Trigger Keywords:**
- "validate tool registry"
- "check capabilities"
- "verify tools are working"
- "is [tool] operational"
- "tool registry health check"
- "add tool to registry"
- "review tool lifecycle"

**Core Capabilities:**
1. **Registry Validation** - Completeness, accuracy, format consistency
2. **Tool Availability Testing** - Scripts, CLI tools, MCP servers, APIs
3. **Lifecycle Tracking** - Linear integration for Proposed → Active flow
4. **Documentation Quality** - Cross-references, examples, consistency
5. **Reporting** - Health reports, availability reports, recommendations

**Key Features:**
- Runs `scripts/verify-tool-registry.sh` for automated checks
- Tests tool availability (scripts exist, CLI tools installed, APIs responsive)
- Creates/updates Linear issues with "Tool Registry" label
- Manages tool lifecycle: Proposed → Triage → Testing → Deployed → Review
- Generates comprehensive health reports with prioritized recommendations

**When to Use:**
- New tools/scripts/integrations added to project
- TOOL-REGISTRY.md is modified
- Validating tool availability
- Preparing for quarterly/annual registry review
- Tool proposals need triage
- Deployment verification needed

**Access via Task tool:**
```bash
# In Claude Code
Use Task tool with subagent_type="tool-registry-manager"
```

**Outputs:**
- Validation reports (✅ Healthy, 🟡 Needs Attention, ❌ Critical)
- Tool availability status by category
- Linear issue links for tool proposals
- Prioritized recommendations for fixes/improvements

**Related Documentation:**
- TOOL-REGISTRY.md - The registry this agent manages
- docs/runbooks/tool-registry-linear-integration.md - Lifecycle workflow
- scripts/verify-tool-registry.sh - Automated validation script
- scripts/create-tool-issue.sh - Linear issue template generator

### Session Tracker (session-tracker)

**Location:** `~/.claude/agents/workflow/session-tracker.md` (assumed)

**Purpose:** Session lifecycle management, audit trails, multi-agent coordination

**Core Capabilities:**
- Session initialization with UUID and timestamps
- State machine (idle → active → paused → completed)
- Activity logging (code, analysis, meetings, deployments)
- JSON Schema validation before persistence
- Slack integration for progress updates
- Multi-agent handoff tracking

**When to Use:**
- Starting significant work that needs tracking
- Creating audit trails for compliance
- Coordinating multi-agent workflows
- Posting progress updates to Slack
- Managing session handoffs between agents

**Access via Slash Commands:**
```bash
/session-start "Task description"
/session-stop --notes "Summary" --post
/session-status
/session-history
```

## Security & Configuration Tips

Store workspace secrets in `.env`, never in version control. Supply `.env.example` with placeholder keys (`SLACK_BOT_TOKEN`, `SLACK_SIGNING_SECRET`, `SLACK_APP_TOKEN`, `SLACK_WORKSPACE_ID`). Validate environment variables at startup and gate any production toggles behind feature flags so agents can exercise staging environments safely.
