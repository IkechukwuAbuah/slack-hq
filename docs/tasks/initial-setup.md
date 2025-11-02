# Initial Setup Tasks

This document tracks the initial bootstrap tasks for the Slack-HQ project.

## Task Lineage

All tasks use the `SLHQ-*` prefix for Linear integration and cross-referencing.

## Setup Tasks

### ✅ SLHQ-13: Initialize repository & templates
**Status**: Done
**Linear**: [SLHQ-13](https://linear.app/abuah/issue/SLHQ-13)
**Labels**: `area:infra`, `ai:claude`, `artifact:md`

Set up the initial project structure:
- README.md with project overview and links
- CLAUDE.md with AI agent instructions
- Directory structure (docs/, agents/, scripts/)
- Document templates (spec.md, adr.md, runbook.md)
- Basic scripts (convert.sh for markdown/docx conversion)

**Outcome**: Foundation established for the Slack-HQ documentation system.

---

### 📋 SLHQ-14: Configure Linear + Slack integration
**Status**: Todo
**Linear**: [SLHQ-14](https://linear.app/abuah/issue/SLHQ-14)
**Labels**: `area:automation`, `area:ops`

Set up the Linear Slack integration:
- `/linear create` command in #council-core
- Automatic notifications for issue updates
- Issue status changes reflected in Slack
- Link previews for Linear issues

**Goal**: Enable seamless task creation and tracking from Slack.

**Steps**:
1. Install Linear app in Slack workspace
2. Configure channel integrations (#council-core)
3. Set notification preferences
4. Test `/linear create` command
5. Verify bidirectional sync

---

### 📋 SLHQ-15: Connect GitHub & Linear
**Status**: Todo
**Linear**: [SLHQ-15](https://linear.app/abuah/issue/SLHQ-15)
**Labels**: `area:automation`, `area:infra`

Set up GitHub ↔ Linear integration:
- Auto-link commits to Linear issues via commit messages
- PR references in Linear issues
- Status updates when PRs are merged
- Branch naming conventions with Linear IDs

**Goal**: Create bidirectional traceability between code and tasks.

**Steps**:
1. Install Linear GitHub integration
2. Configure repository connections
3. Set up commit message patterns (e.g., `feat(SLHQ-15): description`)
4. Test PR linking
5. Verify status automation

---

### 📋 SLHQ-16: Setup Notion DB links
**Status**: Todo
**Linear**: [SLHQ-16](https://linear.app/abuah/issue/SLHQ-16)
**Labels**: `area:docs`, `area:automation`

Configure Notion as the knowledge base:
- Create "Slack-HQ Docs" database view
- Set up properties: Type, Status, Linear ID, GitHub URL
- Configure templates for different doc types
- Establish sync process (markdown files → Notion)

**Goal**: Complete the three-pillar architecture: Linear (tasks), GitHub (code/docs), Notion (knowledge).

**Steps**:
1. Create Notion database "Slack-HQ Docs"
2. Add properties: Type, Status, Linear ID, GitHub URL, Tags
3. Create templates for specs, ADRs, runbooks
4. Document sync workflow
5. Update README with Notion database URL

---

## Naming Conventions

### Commit Messages
```
<type>(SLHQ-<number>): <description>

Examples:
feat(SLHQ-14): add Linear Slack integration
docs(SLHQ-13): update README with live links
chore(SLHQ-15): configure GitHub integration
```

### Branch Names
Linear auto-generates branch names in format:
```
kelvin/slhq-<number>-<title-slug>

Examples:
kelvin/slhq-14-configure-linear-slack-integration
kelvin/slhq-15-connect-github-linear
```

### File Names
Use Linear IDs as prefixes for related artifacts:
```
docs/tasks/SLHQ-014-integration-setup.md
docs/specs/SLHQ-020-feature-spec.md
docs/adrs/SLHQ-025-architecture-decision.md
```

---

## Quick Reference

| ID | Title | Status | Linear Link |
|----|-------|--------|-------------|
| SLHQ-13 | Initialize repository & templates | ✅ Done | [View](https://linear.app/abuah/issue/SLHQ-13) |
| SLHQ-14 | Configure Linear + Slack integration | 📋 Todo | [View](https://linear.app/abuah/issue/SLHQ-14) |
| SLHQ-15 | Connect GitHub & Linear | 📋 Todo | [View](https://linear.app/abuah/issue/SLHQ-15) |
| SLHQ-16 | Setup Notion DB links | 📋 Todo | [View](https://linear.app/abuah/issue/SLHQ-16) |

---

## Next Steps

1. **SLHQ-14**: Install Linear Slack app and configure #council-core
2. **SLHQ-15**: Set up GitHub integration for commit/PR linking
3. **SLHQ-16**: Create Notion database and establish sync workflow
4. Start using the task lineage system for all new work
