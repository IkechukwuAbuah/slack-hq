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
├── agents/
│   ├── agents.md            # Worker registry and handoff rules
│   └── claude.md            # Claude-specific instructions
├── docs/
│   ├── templates/           # Document templates
│   │   ├── spec.md
│   │   ├── adr.md
│   │   └── runbook.md
│   ├── specs/               # Feature specifications
│   ├── adrs/                # Architecture Decision Records
│   └── runbooks/            # Operational procedures
└── scripts/
    └── convert.sh           # Markdown ↔ DOCX conversion utility

```

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

## Contributing

1. All documentation changes go through PR review
2. Include Linear issue ID in commits: `feat(LIN-123): description`
3. Update templates if you discover better patterns
4. Keep SSOT policy: markdown is source, everything else is derivative

## Slack CLI Setup (Council Bot)

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
   ```bash
   SLACK_BOT_TOKEN=your-token slack api auth.test
   ```

### Usage

See docs/slack-cli-capabilities.md for:
- Full list of available capabilities
- CLI command examples
- AI agent integration patterns
- Troubleshooting guide

## Support

- Documentation questions: Check `/docs/templates/` for examples
- Agent coordination: See `/agents/agents.md`
- Claude usage: See `/agents/claude.md`
- Slack integration: See `docs/slack-cli-capabilities.md`
- Council Bot for AI agents: See `/agents/council-bot-reference.md`
- Linear issues: [Your Linear workspace URL]
