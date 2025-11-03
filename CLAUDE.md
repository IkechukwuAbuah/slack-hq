# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) and other AI agents when working with this repository.

## Sense of Ownership

When working on this project, **take ownership of the work**. This means:

- **Think holistically**: Consider how changes affect the entire system, not just the immediate task
- **Anticipate needs**: Identify related issues, documentation updates, or tests that should be addressed
- **Maintain quality**: Ensure consistency in code style, documentation, and architecture patterns
- **Clean up as you go**: Update stale documentation, fix related issues, improve what you touch
- **Communicate clearly**: Provide context in commit messages, update relevant docs, post meaningful Slack updates
- **Verify completeness**: Don't just implement - test, document, and confirm it works end-to-end

**This is your project.** Treat it with the same care and attention you'd give to your own work.

## Project Overview

**Slack HQ** is a documentation-first workspace coordination system that connects AI agents to "The Council" Slack workspace via **Council Bot**.

### Core Infrastructure

- **Repository Type**: Documentation & automation scripts (no application code yet)
- **Primary Tool**: Slack MCP (Model Context Protocol server for direct API access)
- **Secondary Tool**: Slack CLI v3.9.0 (for app development and manifest management)
- **Slack App**: Council Bot (AI agent connector with comprehensive OAuth scopes)
- **Workspace**: "The Council" - private Slack workspace for AI collaboration

## Tool Registry

**IMPORTANT:** For a comprehensive catalog of all available tools, APIs, scripts, and integrations, see **[TOOL-REGISTRY.md](TOOL-REGISTRY.md)**.

The tool registry includes:
- Local scripts (slack-setup.sh, convert.sh)
- MCP servers (Slack, Linear, GitHub, Notion)
- CLI tools (Slack CLI, Gemini CLI, Cursor CLI, Codex CLI)
- APIs (direct access patterns)
- Claude Code subagents (40+ specialized agents)
- Development tools (Spec Kit, TDD Guard)
- Quick reference decision trees
- Common workflow patterns

**When to use the registry:**
- Discovering available capabilities before implementing new tools
- Finding the right tool for a specific task
- Understanding integration patterns
- Checking environment variable requirements

### Tool Registry Management

The tool registry has a dedicated **tool-registry-manager subagent** that handles:
- **Validation**: Completeness, accuracy, format consistency
- **Testing**: Tool availability (scripts, CLI, MCP, APIs)
- **Lifecycle**: Linear integration for tool proposals (Proposed → Active)
- **Quality**: Documentation checks, broken links, cross-references
- **Reporting**: Health reports with prioritized recommendations

**Trigger keywords:**
- "validate tool registry"
- "check capabilities"
- "verify tools are working"
- "is [tool] operational"
- "tool registry health check"

**When to use:**
- After adding new tools/scripts/integrations
- Before quarterly reviews
- When TOOL-REGISTRY.md is modified
- To verify tool availability
- To propose new tool integrations

**Location:** `~/.claude/agents/tools/tool-registry-manager.md` (see AGENTS.md for details)

## Available Toolset

### Slack Integration

This project uses **two different Slack tools** for different purposes:

#### 1. Slack MCP (Primary - For All Slack Operations)

**Use Slack MCP for all workspace operations, messaging, and channel management.**

The Slack MCP server provides direct access to Slack's API through Claude Code's MCP interface. It's pre-configured, authenticated, and ready to use immediately.

**Available MCP Tools:**
```bash
# Messaging
mcp__slack__slack_post_message         # Post messages to channels
mcp__slack__slack_reply_to_thread      # Reply to specific threads
mcp__slack__slack_add_reaction         # Add emoji reactions

# Channel Management
mcp__slack__slack_list_channels        # List all channels
mcp__slack__slack_get_channel_history  # Get recent messages
mcp__slack__slack_get_thread_replies   # Get thread messages

# User Management
mcp__slack__slack_get_users            # List workspace users
mcp__slack__slack_get_user_profile     # Get user details
```

**Example Usage:**
```javascript
// Post a message
mcp__slack__slack_post_message({
  channel_id: "C068K8VDXGB",
  text: "Hello from Claude!"
})

// List channels
mcp__slack__slack_list_channels({ limit: 50 })

// Reply to a thread
mcp__slack__slack_reply_to_thread({
  channel_id: "C068K8VDXGB",
  thread_ts: "1234567890.123456",
  text: "Thread reply"
})
```

#### 2. Slack CLI v3.9.0 (Secondary - For App Development Only)

**Use Slack CLI ONLY for app manifest management and development workflows.**

The Slack CLI v3.9.0 is designed for **building Slack apps**, not for API operations. It does NOT support `slack api` commands.

**What Slack CLI IS for:**
```bash
# App manifest management
slack manifest validate --file manifest.yml
slack manifest info

# App deployment (via helper script)
./scripts/slack-setup.sh

# Authentication management
slack auth list
slack auth login
```

**What Slack CLI is NOT for:**
- ❌ Posting messages (`slack api chat.postMessage` does not exist)
- ❌ Managing channels (`slack api conversations.*` does not exist)
- ❌ Direct API calls (no `slack api` command in v3.9.0)

**For all API operations, use Slack MCP instead.**

### When to Use Which Tool

**Use Slack MCP when:**
- ✅ Posting messages or updates to channels
- ✅ Reading channel history or threads
- ✅ Managing channels (list, create, invite)
- ✅ Getting user information
- ✅ Adding reactions to messages
- ✅ Any workspace operation or automation

**Use Slack CLI when:**
- ✅ Validating manifest.yml changes
- ✅ Deploying app updates
- ✅ Managing authentication
- ✅ Developing Slack app features (triggers, workflows, datastores)

**Use neither when:**
- ❌ User hasn't explicitly requested Slack interaction
- ❌ Testing/debugging (use mock data instead)

### Direct API Access (Alternative)

If Slack MCP is unavailable, you can use direct API calls via curl:

```bash
# Requires SLACK_BOT_TOKEN in environment
source .env

# Post a message
curl -X POST https://slack.com/api/chat.postMessage \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"channel":"C068K8VDXGB","text":"Hello"}'

# List channels
curl -X GET "https://slack.com/api/conversations.list?types=public_channel" \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN"
```

**Note:** Direct API calls require proper environment setup and token configuration.

## Development Workflows

### Session Tracking

The slack-hq project includes a comprehensive session tracking system for all AI agents working in The Council workspace. This system provides structured audit trails, activity logging, and Slack integration for progress updates.

#### Available Session Commands

All session tracking is managed through slash commands:

- **`/session-start`** - Start tracking a new work session
  ```bash
  /session-start "Task description"
  /session-start "Implement feature" --auto-post --channel #council-ops
  ```

- **`/session-stop`** - Complete the current session
  ```bash
  /session-stop
  /session-stop --notes "Completed with tests" --post
  ```

- **`/session-status`** - Check current session status
  ```bash
  /session-status
  ```

- **`/session-history`** - View recent sessions
  ```bash
  /session-history --limit 20
  /session-history --status active
  /session-history --search "authentication"
  ```

- **`/session-show`** - Display detailed session information
  ```bash
  /session-show a1b2c3d4
  ```

- **`/session-post`** - Share session updates to Slack
  ```bash
  /session-post
  /session-post --dry-run
  /session-post --channel #deployments
  ```

**⚠️ Important:** All `/session` commands use the **session-tracker-2 subagent** (`.claude/agents/session-tracker-2.md`). The old `session-tracking` skill (`.claude/skills/session-tracking/`) is **DEPRECATED** - it uses shell scripts with broken Slack integration. Do NOT use the skill or call shell scripts directly.

#### Session Tracking Implementation

The session tracking system is implemented using:

**Core Components:**
- **Session Tracker 2 Subagent**: `.claude/agents/session-tracker-2.md` (handles ALL operations including Slack posting)
- **Slack MCP Integration**: session-tracker-2 uses `mcp__slack__*` tools directly
- **Slash Commands**: `.claude/commands/session-*.md` (user interface)
- **Data Storage**: `.claude/data/sessions/*.json` (gitignored)
- **Schema Validation**: JSON Schema v7 validation before persistence

**Architecture:**
```
User Command → Slash Command → Task Tool → session-tracker-2 subagent
                                                     ↓
                                            Manages Session JSON
                                                     ↓
                                            Posts DIRECTLY to Slack (via MCP)
                                                     ↓
                                            Stores thread_ts in session JSON
```

**Key Features:**
- ✅ session-tracker-2 manages all session JSON operations
- ✅ session-tracker-2 has Slack MCP tools and posts directly (no main agent needed)
- ✅ Accurate duration calculation from timestamps
- ✅ Subagent activity logging and handoff tracking
- ✅ All-in-one: data management + Slack integration in single agent

#### Subagent Integration

**All subagents can now log activities to sessions for comprehensive tracking.**

When launching a subagent, pass session context:

```javascript
Task({
  subagent_type: "test-writer-fixer",
  prompt: `
    PARENT_SESSION_ID: ${current_session_id}
    PARENT_SESSION_CHANNEL: C09Q8KCGM9C
    PARENT_SESSION_THREAD_TS: ${slack_thread_ts}

    Task: Write comprehensive tests for authentication module

    When complete, log your activity using session-tracker-2 subagent.
  `
});
```

The subagent can then log its work (and optionally post to Slack):

```javascript
// After completing work
Task({
  subagent_type: "session-tracker-2",
  prompt: `
    Operation: log_activity
    Session ID: ${PARENT_SESSION_ID}
    Activity Type: code
    Summary: Created 15 unit tests with 100% coverage
    Files: ["tests/auth/jwt.test.ts", ...]
    Tools: ["Write", "Edit", "Bash"]
    Subagent: test-writer-fixer

    # Optional: Post milestone update to Slack thread
    Post to Slack Thread: true
    Channel: ${PARENT_SESSION_CHANNEL}
    Thread TS: ${PARENT_SESSION_THREAD_TS}
    Slack Message: "✅ test-writer-fixer: 15 unit tests with 100% coverage"
  `
});
```

**Benefits:**
- ✅ Complete activity timeline across all agents
- ✅ Proper subagent identification (no more "unknown")
- ✅ Accurate handoff tracking
- ✅ Real-time Slack updates from any agent

**See:** [Subagent Session Integration Guide](/docs/guides/subagent-session-integration.md)

**🔄 Future Enhancement (Proposed - SLHQ-17):**
- **Hooks-Based Automation**: Automatic session tracking via Claude Code hooks system
  - Auto-creates sessions on `SessionStart` hook
  - Tracks activities in real-time via `PreToolUse` hook
  - Auto-completes sessions on `Stop` hook with optional Slack posting
  - Logs subagent handoffs via `SubagentStop` hook
  - **Status:** Proposed ([SLHQ-17](https://linear.app/abuah/issue/SLHQ-17), [GitHub #2](https://github.com/IkechukwuAbuah/slack-hq/issues/2))
  - **Benefits:** Automatic, comprehensive, transparent, deterministic
  - See [TOOL-REGISTRY.md](TOOL-REGISTRY.md#3-session-tracking-hooks) for details

#### Key Features

- **Structured JSON storage** with UUID-based session IDs
- **Activity tracking** for code, analysis, meetings, deployments
- **Multi-agent coordination** with handoff status tracking
- **Slack integration** with Block Kit formatting and threading
- **Linear issue linking** for traceability
- **Session history** and analytics

#### When to Use Session Tracking

**DO use session tracking when:**
- Starting significant work that should be tracked
- Coordinating with other agents
- Need to share progress updates with The Council
- Creating audit trails for compliance or reporting
- Tracking time and activities for project management

**BEST PRACTICE:** Start a session at the beginning of each significant work unit:
```bash
/session-start "Implement OAuth authentication flow"
# ... do work, Claude automatically tracks activities ...
/session-stop --notes "Completed with full test coverage" --post
```

#### 🚨 MANDATORY: Session Broadcasting

**All completed sessions MUST be broadcasted to Slack for Council visibility.**

When completing a session, the agent MUST use the `--post` flag to share the summary:

```bash
/session-stop --notes "Summary of work completed" --post
```

**Channel Selection:**
- Default: `#announcements` (C09Q8KCGM9C) - For general Council updates
- Engineering work: `#engineering` - For technical implementations
- Design work: `#design-lab` - For UI/UX and design tasks
- Deployments: `#ops` - For production changes
- Documentation: `#docs` - For documentation updates

**When to broadcast:**
- ✅ All completed sessions with deliverables
- ✅ Milestone achievements
- ✅ Handoffs to other agents
- ✅ Blocked work requiring Council input
- ❌ Trivial/exploratory sessions (< 15 minutes)

**Example:**
```bash
# Engineering work
/session-stop --notes "Implemented JWT auth with tests" --post --channel engineering

# Handoff
/session-stop --notes "Auth complete, ready for frontend integration" --post
```

This ensures The Council maintains visibility into all agent activities and progress.

## Project-Specific Commands

### Setup & Deployment
```bash
# Initial setup (run once)
slack auth login
./scripts/slack-setup.sh

# Update manifest after changes
slack manifest validate --file manifest.yml
./scripts/slack-setup.sh

# Test Slack MCP connection
# Use mcp__slack__slack_list_channels to verify connectivity
```

### Documentation
```bash
# Convert markdown to DOCX (if needed)
./scripts/convert.sh md2docx docs/specs/my-spec.md

# Convert DOCX to markdown
./scripts/convert.sh docx2md external-doc.docx
```

## Architecture & Patterns

### Single Source of Truth (SSOT)

- **Markdown files** are the canonical source for all documentation
- **Linear issues** track work items and tasks
- **Notion** serves as long-term knowledge repository
- **Git** is the version control source of truth
- **Slack** is the operational communication layer

### Council Bot Design

**Purpose**: Unified Slack interface for all AI agents (not just Claude)

**Agents supported**: Claude Code, Codex, ChatGPT, Gemini, Grok, Cursor, Warp, Windsurf

**Key principle**: One bot, many agents. All AI agents share the same Slack app and tokens to maintain consistent identity in the workspace.

**OAuth Scopes Strategy**:
- Comprehensive permissions requested upfront (channels, groups, DMs, usergroups)
- Allows any agent to perform full workspace operations
- Reduces friction from missing scopes during automation

### File Organization Conventions

```
slack-hq/
├── .claude/                  # Claude Code configuration
│   ├── commands/            # Slash commands (session-*, sync-docs, etc.)
│   ├── skills/              # Project-specific skills
│   │   └── session-tracking/  # Session tracking implementation
│   ├── data/                # Runtime data (gitignored)
│   │   └── sessions/        # Session JSON files
│   └── settings.local.json  # Local Claude settings
├── manifest.yml              # Slack app configuration (Council Bot)
├── scripts/                  # Automation scripts
│   ├── slack-setup.sh       # Main deployment script
│   └── convert.sh           # Markdown/DOCX conversion
├── docs/                     # All documentation
│   ├── specs/               # Feature specifications
│   ├── adrs/                # Architecture Decision Records
│   ├── runbooks/            # Operational procedures
│   ├── guides/              # Implementation guides
│   └── templates/           # Document templates
├── agents/                   # Agent-specific guidance
├── context/                  # Project context & background
└── logs/                     # Session logs and telemetry
```

## Linear Integration Behavior

**Status:** ⏳ Setup in progress (SLHQ-4)
**Documentation:** [LINEAR-INTEGRATION-STATUS.md](docs/LINEAR-INTEGRATION-STATUS.md)

When working with Linear issues and GitHub, follow these conventions to ensure proper integration:

### Commit Messages

**Always include Linear issue ID** in your commit messages for automatic linking:

```bash
# Standard format
<type>(SLHQ-X): <description>

# Examples
feat(SLHQ-4): enable Linear Slack integration
fix(SLHQ-12): resolve authentication timeout
docs(SLHQ-8): update integration guide
chore(SLHQ-15): update dependencies
refactor(SLHQ-20): simplify error handling
test(SLHQ-18): add integration tests
```

**Commit types:**
- `feat` - New feature
- `fix` - Bug fix
- `docs` - Documentation changes
- `chore` - Maintenance tasks
- `refactor` - Code refactoring
- `test` - Test additions/changes
- `perf` - Performance improvements

**Issue closing patterns:**
```bash
# These automatically close issues when merged
Fixes SLHQ-X: description
Closes SLHQ-X: description
Resolves SLHQ-X: description
```

**Why this matters:**
- Commits automatically appear in Linear issue's Git section
- Links are bidirectional (Linear → GitHub, GitHub → Linear)
- Provides complete audit trail of code changes
- Enables automatic status updates via PR workflows

### Pull Requests

**Include issue ID in PR title or body** for automatic linking:

```markdown
# PR Title
feat(SLHQ-4): Enable Linear integrations with GitHub and Slack

# Or in PR Body
This PR implements the requirements from SLHQ-4.
```

**PR Workflow (after setup):**
1. PR opened → Issue status changes to "In Review"
2. PR merged → Issue status changes to "Done"
3. Team receives Slack notification at each step

**Branch Naming:**
- Use Linear's branch name suggestions when available
- Format: `<username>/<issue-id>-<issue-title-slug>`
- Example: `kelvin/slhq-4-enable-linear-github-slack-integrations`
- Copy suggested name from Linear UI for consistency

### Slack Notifications

**After SLHQ-4 completion, Linear will automatically post to #council-core:**

**Events that notify:**
- ✅ Issue status changed → "📋 SLHQ-X moved to [Status]"
- ✅ Issue commented → "💬 [User] commented on SLHQ-X"
- ✅ Issue assigned → "👤 SLHQ-X assigned to [User]"
- ✅ Issue priority changed → "⚡ SLHQ-X priority: [Priority]"
- ✅ PR opened → "🔀 PR opened for SLHQ-X"
- ✅ PR merged → "✅ PR merged for SLHQ-X"

**Events that don't notify (by design):**
- ❌ Issue created (too noisy)
- ❌ Issue updated (general edits)
- ❌ Issue labeled
- ❌ Issue description changed

**Be mindful:**
- Comments trigger notifications → Use for actionable updates
- Status changes trigger notifications → Expected for progress tracking
- Each PR event notifies team → Normal for code review workflow

### Integration Testing

**After SLHQ-4 manual setup, Claude Code will:**
1. Create test commits to verify GitHub integration
2. Create test PR to verify status updates
3. Test Slack notifications end-to-end
4. Verify all links work bidirectionally

**Manual verification steps:**
- Check commit appears in Linear issue's Git section
- Verify PR updates issue status correctly
- Confirm Slack notifications post to #council-core
- Test links from Linear → GitHub and vice versa

### Troubleshooting

**Common issues and solutions:**

**Commits not appearing in Linear:**
- Verify exact format: `<type>(SLHQ-X): description`
- Check repository is connected in Linear settings
- Ensure commit is pushed (local commits don't sync)

**PR status not updating:**
- Verify PR title/body includes issue ID
- Check automation enabled in Linear GitHub settings
- Ensure target status exists in workflow

**No Slack notifications:**
- Verify integration enabled for SLHQ team
- Check #council-core configuration
- Ensure event type is enabled

**See also:**
- [LINEAR-INTEGRATION-STATUS.md](docs/LINEAR-INTEGRATION-STATUS.md) - Current status and test results
- [LINEAR-INTEGRATION-SETUP.md](docs/LINEAR-INTEGRATION-SETUP.md) - Manual setup guide
- [linear-config-backup.md](docs/integrations/linear-config-backup.md) - Configuration backup

## Keeping Documentation Updated

This project uses a living documentation approach:

### Automatic Sync Check
Use `/sync-docs` to check if CLAUDE.md needs updates:
```bash
/sync-docs
```

This command:
- Analyzes recent git changes (past 7 days)
- Checks for structural/architectural changes
- Compares current state against CLAUDE.md
- Suggests specific, actionable updates
- Focuses on high-value information (commands, patterns, conventions)

### When to Run `/sync-docs`
- After major refactors
- When adding new architectural patterns
- After changing build/test tooling
- Before onboarding new team members
- Weekly during active development

### Documentation Philosophy
CLAUDE.md stays relevant by focusing on:
- **Commands** that aren't obvious (custom scripts, non-standard workflows)
- **Architecture patterns** that require reading multiple files to understand
- **Conventions** that aren't enforced by linters
- **Non-obvious decisions** that save future developers time

It avoids:
- Detailed folder structures (easily discovered)
- File-by-file listings
- Generic best practices
- Information that changes frequently

## Key Lessons Learned

### GitHub Integration

**Prefer GitHub MCP over GitHub CLI** - Until token scopes are improved.

- Use `mcp__github__*` tools for GitHub operations (create_repository, push_files, etc.)
- GitHub CLI (`gh`) may have insufficient token scopes for certain operations
- Example: `gh repo create` fails with "Resource not accessible by personal access token"
- GitHub MCP tools work reliably with proper authentication
- Only fall back to `gh` CLI for read-only operations or when MCP is unavailable

**Rationale:** The GitHub CLI token may lack repository creation permissions, while the GitHub MCP has proper scopes configured. This was discovered during the claude-skills repository deployment (2025-11-03).
