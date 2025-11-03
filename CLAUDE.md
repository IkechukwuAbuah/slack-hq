# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) and other AI agents when working with this repository.

## Project Overview

**Slack HQ** is a documentation-first workspace coordination system that connects AI agents to "The Council" Slack workspace via **Council Bot**.

### Core Infrastructure

- **Repository Type**: Documentation & automation scripts (no application code yet)
- **Primary Tool**: Slack CLI v3.9.0 (installed globally via Homebrew)
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

### Slack CLI Commands

As an AI agent working in this repository, you have access to the Slack CLI. Use it for:

#### Authentication & Setup
```bash
# Check authentication status
slack auth list

# Validate manifest before deployment
slack manifest validate --file manifest.yml

# Deploy app updates
./scripts/slack-setup.sh
```

#### Channel Operations
```bash
# List all channels
slack api conversations.list --data '{"types":"public_channel,private_channel"}' --token "$SLACK_BOT_TOKEN"

# Create a channel
slack api conversations.create --data '{"name":"new-channel"}' --token "$SLACK_BOT_TOKEN"

# Invite users to a channel
slack api conversations.invite --data '{"channel":"C123","users":"U111,U222"}' --token "$SLACK_BOT_TOKEN"

# Set channel topic
slack api conversations.setTopic --data '{"channel":"C123","topic":"Channel description"}' --token "$SLACK_BOT_TOKEN"
```

#### Messaging
```bash
# Post a message
slack api chat.postMessage --data '{"channel":"#general","text":"Message"}' --token "$SLACK_BOT_TOKEN"

# Read channel/DM history
slack api conversations.history --data '{"channel":"C123","limit":50}' --token "$SLACK_BOT_TOKEN"
```

#### Usergroup Management
```bash
# List usergroups
slack api usergroups.list --token "$SLACK_BOT_TOKEN"

# Update usergroup members
slack api usergroups.users.update --data '{"usergroup":"S123","users":"U111,U222"}' --token "$SLACK_BOT_TOKEN"
```

### When to Use Slack CLI

**DO use Slack CLI when:**
- User asks to post updates to Slack channels
- User requests channel creation or management
- User wants to query Slack workspace state
- Automating workflows that involve Slack notifications
- Setting up integrations between tools and Slack

**DO NOT use Slack CLI when:**
- User hasn't explicitly requested Slack interaction
- Tokens are not configured in `.env`
- Testing/debugging (use mock data instead)

### Environment Requirements

Before using Slack CLI commands, ensure:
```bash
# Check if tokens are set
test -n "$SLACK_BOT_TOKEN" && echo "Token configured" || echo "Token missing"

# Verify CLI is available
slack version
```

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

#### Session Tracking Implementation

The session tracking system is implemented as:
- **Claude Code Skill**: `.claude/skills/session-tracking/` (project-specific)
- **Slash Commands**: `.claude/commands/session-*.md` (user interface)
- **Data Storage**: `.claude/data/sessions/*.json` (gitignored)
- **Schema Validation**: JSON Schema v7 validation before persistence

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
slack login
./scripts/slack-setup.sh

# Update manifest after changes
slack manifest validate --file manifest.yml
./scripts/slack-setup.sh

# Test connection
slack api auth.test --token "$SLACK_BOT_TOKEN"
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
