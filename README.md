# Slack HQ

Enterprise workspace coordination and documentation system.

## Overview

Slack HQ is a documentation-first project management system that coordinates AI agents, human workers, and processes through a unified markdown-based workflow.

## Single Source of Truth (SSOT) Policy

**All project artifacts live in markdown.**

- **Documentation**: All specs, ADRs, runbooks, and guides are written in `.md` format
- **Task Tracking**: Linear issues are the canonical source for work items
- **Knowledge Base**: Notion serves as the long-term knowledge repository
- **Version Control**: Git is the source of truth for all markdown files
- **Conversions**: Use `/scripts/convert.sh` for .docx exports when needed

### Why Markdown?

- Version controllable with Git
- Human and machine readable
- Plain text = portable, future-proof
- Integrates with all AI agents
- Easy to diff, review, and collaborate

## Project Links

- **Linear Workspace**: [SLHQ Team](https://linear.app/ikechukwu-abuah/team/SLHQ) - Project management and issue tracking
- **Notion Knowledge Base**: [Slack-HQ Docs](https://www.notion.so/slack-hq-docs) *(Update with your actual Notion workspace URL)*
- **GitHub Repository**: [IkechukwuAbuah/slack-hq](https://github.com/IkechukwuAbuah/slack-hq)
- **Repository**: Current directory

## Directory Structure

```
slack-hq/
├── README.md                 # This file
├── CLAUDE.md                 # Claude Code instructions
├── TOOL-REGISTRY.md          # Comprehensive tool and API catalog
├── AGENTS.md                 # AI agent configuration
├── manifest.yml              # Slack app configuration (Council Bot)
├── .env.example              # Environment variables template
│
├── agents/                   # AI agent coordination
│   ├── agents.md            # Worker registry and handoff rules
│   ├── claude.md            # Claude-specific instructions
│   ├── council-bot-reference.md # Council Bot integration guide
│   ├── prompts/             # Reusable prompt library
│   │   └── README.md        # Prompts usage guide
│   └── registry/            # Agent metadata registry
│       └── README.md        # Registry documentation
│
├── docs/                     # Documentation (markdown SSOT)
│   ├── templates/           # Document templates
│   │   ├── spec.md          # Feature specification template
│   │   ├── adr.md           # Architecture Decision Record template
│   │   └── runbook.md       # Operational runbook template
│   ├── specs/               # Feature specifications
│   ├── adrs/                # Architecture Decision Records
│   ├── runbooks/            # Operational procedures
│   ├── guides/              # Implementation guides
│   ├── setup/               # Setup documentation
│   ├── testing/             # Testing documentation
│   └── research/            # Research and explorations
│
├── artifacts/                # AI-generated documents (gitignored)
│   ├── README.md            # Artifacts policy and usage
│   ├── chatgpt/             # ChatGPT outputs (.docx, .pdf)
│   │   └── README.md
│   └── claude/              # Claude outputs (.md, .txt)
│       └── README.md
│
├── scripts/                  # Automation utilities
│   ├── convert.sh           # Markdown ↔ DOCX conversion
│   ├── slack-setup.sh       # Council Bot deployment
│   └── post-to-slack.sh     # Slack messaging utility
│
├── .claude/                  # Claude Code configuration
│   ├── commands/            # Custom slash commands
│   ├── skills/              # Project-specific skills
│   ├── agents/              # Subagent definitions
│   └── data/                # Runtime data (gitignored)
│
└── logs/                     # Session logs and telemetry (gitignored)
```

**Key Principles:**
- **Markdown is source** - All canonical documentation in `.md`
- **Artifacts are derivatives** - Generated files live in `/artifacts`
- **Structure is tracked** - Directories committed, most contents gitignored
- **Templates are reusable** - Use `/docs/templates` for new documents

## Key Documentation

- **[TOOL-REGISTRY.md](TOOL-REGISTRY.md)** - Comprehensive catalog of all available tools, APIs, MCP servers, CLI tools, and integrations. Check here first when looking for capabilities.
- **[CLAUDE.md](CLAUDE.md)** - Instructions for Claude Code and other AI agents working in this repository
- **[AGENTS.md](AGENTS.md)** - AI agent configuration and orchestration
- **[docs/slack-cli-capabilities.md](docs/slack-cli-capabilities.md)** - Detailed Slack API reference and Council Bot capabilities

## Getting Started

### Prerequisites

- Git
- Pandoc (for document conversion): `brew install pandoc`
- Linear account with API access
- Notion workspace access

### Quick Start

1. **Clone and initialize**:
   ```bash
   git init
   git add .
   git commit -m "Initial project skeleton"
   ```

2. **Update project links**: Edit this README with your Linear and Notion URLs

3. **Create your first spec**:
   ```bash
   cp docs/templates/spec.md docs/specs/my-feature.md
   # Edit and fill in the template
   ```

4. **Use agent coordination**:
   - See `/agents/agents.md` for worker registry
   - See `/agents/claude.md` for Claude-specific workflows

## Workflows

### Creating a New Feature

1. Create spec from template: `docs/specs/feature-name.md`
2. Create Linear issue and add ID to spec header
3. Create ADR if architectural changes needed: `docs/adrs/NNN-decision.md`
4. Implement with agent coordination (see `/agents/agents.md`)
5. Create runbook if operational procedures needed

### Document Conversion

```bash
# Markdown to DOCX
./scripts/convert.sh md2docx docs/specs/my-spec.md

# DOCX to Markdown
./scripts/convert.sh docx2md external-doc.docx
```

## Integrations

**Status:** ⏳ Setup in progress (SLHQ-4)
**Documentation:** [LINEAR-INTEGRATION-STATUS.md](docs/LINEAR-INTEGRATION-STATUS.md)

### Linear ↔ GitHub

Bidirectional integration between Linear issues and GitHub code:

**Features:**
- ✅ Commits with `SLHQ-X` automatically link to issues
- ✅ PRs update issue status (opened → In Review, merged → Done)
- ✅ Branch names generated by Linear
- ✅ Full bidirectional sync between Linear and GitHub
- ✅ Commit patterns: `<type>(SLHQ-X): description`

**Workflow:**
```bash
# 1. Get branch name from Linear issue
# Linear UI → "Create branch" → Copy suggested name

# 2. Create branch and work
git checkout -b kelvin/slhq-4-enable-linear-integrations
# ... make changes ...

# 3. Commit with Linear issue ID
git commit -m "feat(SLHQ-4): enable Linear Slack integration"
git push

# 4. Create PR (automatically updates Linear)
gh pr create --title "feat(SLHQ-4): Enable Linear integrations"

# 5. PR opened → Linear status changes to "In Review"
# 6. PR merged → Linear status changes to "Done"
```

### Linear ↔ Slack

Real-time notifications from Linear to #council-core channel:

**Enabled Notifications:**
- 📋 Issue status changed
- 💬 Issue commented
- 👤 Issue assigned
- ⚡ Issue priority changed
- 🔀 PR opened (via GitHub integration)
- ✅ PR merged (via GitHub integration)

**Disabled Notifications (by design):**
- ❌ Issue created (too noisy)
- ❌ General updates (labels, descriptions)

**Channel:** #council-core (dedicated automation notifications)

### Setup

After manual Linear integration setup (see [LINEAR-INTEGRATION-SETUP.md](docs/LINEAR-INTEGRATION-SETUP.md)):

1. GitHub integration enables commit/PR linking
2. Slack integration enables team notifications
3. All automations configured for SLHQ team
4. #council-core receives all Linear updates

**Resources:**
- [LINEAR-INTEGRATION-STATUS.md](docs/LINEAR-INTEGRATION-STATUS.md) - Current status and test results
- [LINEAR-INTEGRATION-SETUP.md](docs/LINEAR-INTEGRATION-SETUP.md) - Manual setup guide
- [linear-config-backup.md](docs/integrations/linear-config-backup.md) - Configuration backup

## Contributing

1. All documentation changes go through PR review
2. Include Linear issue ID in commits: `feat(SLHQ-123): description`
3. Update templates if you discover better patterns
4. Keep SSOT policy: markdown is source, everything else is derivative

## Slack CLI Setup (Council Bot)

> **Note:** Slack CLI v3.9.0 is for app development (manifest validation, authentication, deployment). For Slack operations (posting messages, reading channels, managing users), use **Slack MCP**. See [TOOL-REGISTRY.md](TOOL-REGISTRY.md) for `mcp__slack__*` functions.

### Prerequisites

- macOS with Homebrew
- Slack CLI installed: `brew install --cask slack-cli`
- Admin/App Manager access to "The Council" Slack workspace

### Installation Steps

1. **Authenticate CLI** with your Slack workspace "The Council":
   ```bash
   slack login
   slack auth list
   ```

2. **Run the setup script**:
   ```bash
   cd /Users/x/Downloads/slack-hq
   ./scripts/slack-setup.sh
   ```

3. **Complete the OAuth install** in the browser when prompted

4. **Configure environment**:
   ```bash
   cp .env.example .env
   # Edit .env and fill in:
   # - SLACK_BOT_TOKEN (from OAuth & Permissions page)
   # - SLACK_SIGNING_SECRET (from Basic Information page)
   # - SLACK_APP_TOKEN (from App-Level Tokens)
   # - SLACK_WORKSPACE_ID (from workspace settings)
   ```

5. **Test the connection**:

   Test with Slack MCP: See [TOOL-REGISTRY.md](TOOL-REGISTRY.md) for `mcp__slack__*` functions like `slack_post_message`, `slack_list_channels`, etc.

### Usage

See docs/slack-cli-capabilities.md for:
- Full list of available capabilities (both Slack MCP and CLI)
- MCP function reference and examples
- CLI commands for app development
- AI agent integration patterns
- Troubleshooting guide

## Support

- Documentation questions: Check `/docs/templates/` for examples
- Agent coordination: See `/agents/agents.md`
- Claude usage: See `/agents/claude.md`
- Slack integration: See `docs/slack-cli-capabilities.md`
- Council Bot for AI agents: See `/agents/council-bot-reference.md`
- Linear issues: [Your Linear workspace URL]
