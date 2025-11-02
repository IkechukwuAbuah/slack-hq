# Slack-HQ Initial Setup Complete

**Date**: November 2, 2025
**Completed by**: Claude Code

## What Was Accomplished

### 1. ✅ Live Links Initialized

The README.md now contains real, working URLs:

- **Linear Workspace**: [SLHQ Team](https://linear.app/ikechukwu-abuah/team/SLHQ)
- **Notion Knowledge Base**: Placeholder added (needs your Notion URL)
- **GitHub Repository**: Placeholder added (needs your GitHub URL)

### 2. ✅ Task Lineage Established

Created four foundational Linear issues with proper naming:

| ID | Title | Status | URL |
|----|-------|--------|-----|
| SLHQ-13 | Initialize repository & templates | ✅ Done | [Link](https://linear.app/abuah/issue/SLHQ-13) |
| SLHQ-14 | Configure Linear + Slack integration | 📋 Todo | [Link](https://linear.app/abuah/issue/SLHQ-14) |
| SLHQ-15 | Connect GitHub & Linear | 📋 Todo | [Link](https://linear.app/abuah/issue/SLHQ-15) |
| SLHQ-16 | Setup Notion DB links | 📋 Todo | [Link](https://linear.app/abuah/issue/SLHQ-16) |

### 3. ✅ Linear Workspace Already Configured

The SLHQ team workspace came pre-configured with:

**Workflow States**:
- Backlog
- Todo
- In Progress
- In Review
- Done
- Canceled
- Duplicate

**Labels**:
- **Area labels**: `area:infra`, `area:docs`, `area:automation`, `area:ops`
- **AI agent labels**: `ai:claude`, `ai:chatgpt`
- **Artifact labels**: `artifact:md`, `artifact:docx`, `artifact:pdf`
- **Special labels**: `needs:human`

### 4. ✅ Task Tracking Document Created

Created `/docs/tasks/initial-setup.md` with:
- Detailed task descriptions
- Linear links
- Step-by-step instructions
- Naming conventions
- Quick reference table

## What's Next

### Immediate Actions Required

#### 1. Update README.md Links (5 min)
```bash
# Edit README.md and replace:
- Notion URL: https://www.notion.so/slack-hq-docs → your actual Notion workspace
- GitHub URL: https://github.com/yourusername/slack-hq → your actual repo URL
```

#### 2. Configure Linear + Slack Integration (SLHQ-14)
```bash
# Steps:
1. Go to Slack workspace settings
2. Add Linear app from Slack App Directory
3. Authorize Linear to access your workspace
4. In Linear, connect to your Slack workspace
5. Configure #council-core channel
6. Test with: /linear create Test issue
```

#### 3. Connect GitHub & Linear (SLHQ-15)
```bash
# Steps:
1. In Linear settings → Integrations → GitHub
2. Install Linear GitHub app
3. Select your slack-hq repository
4. Configure commit message patterns
5. Test with a commit: git commit -m "feat(SLHQ-15): test integration"
```

#### 4. Setup Notion Database (SLHQ-16)
```bash
# Steps:
1. Create new Notion database: "Slack-HQ Docs"
2. Add properties:
   - Type (Select): Spec, ADR, Runbook, Guide
   - Status (Select): Draft, Review, Published
   - Linear ID (Text)
   - GitHub URL (URL)
   - Tags (Multi-select)
3. Create database view filtered by Type
4. Share database link in README.md
```

### Future Enhancements

After completing SLHQ-14, SLHQ-15, and SLHQ-16, consider:

1. **Create saved views in Linear**:
   - By Agent (Claude / ChatGPT / Gemini)
   - By Area (Docs / Infra / Automation)
   - Blocked > 24h

2. **Set up automation**:
   - Auto-sync markdown files to Notion
   - GitHub Actions for document validation
   - Slack notifications for task updates

3. **Document workflows**:
   - Create runbooks for common operations
   - Add ADRs for architectural decisions
   - Build out spec templates

## How to Use This System

### Creating New Tasks

```bash
# In Slack #council-core
/linear create [title]

# The task will automatically:
- Get a SLHQ-* ID
- Appear in Linear
- Generate a suggested branch name
```

### Committing Code

```bash
# Always use Linear ID in commits
git commit -m "feat(SLHQ-14): add Linear Slack integration"
git commit -m "docs(SLHQ-16): update Notion sync guide"
git commit -m "fix(SLHQ-15): correct GitHub webhook config"
```

### Creating Documentation

```bash
# Use Linear ID as prefix
cp docs/templates/spec.md docs/specs/SLHQ-020-feature-spec.md
cp docs/templates/adr.md docs/adrs/SLHQ-025-architecture-decision.md
cp docs/templates/runbook.md docs/runbooks/SLHQ-030-deployment-guide.md
```

## Repository Structure

```
slack-hq/
├── README.md                          # Updated with live links ✅
├── CLAUDE.md                          # AI agent instructions
├── agents/
│   ├── agents.md                     # Worker registry
│   └── claude.md                     # Claude-specific workflows
├── docs/
│   ├── SETUP-COMPLETE.md             # This file ✅
│   ├── tasks/
│   │   └── initial-setup.md          # Task tracking ✅
│   ├── templates/
│   │   ├── spec.md
│   │   ├── adr.md
│   │   └── runbook.md
│   ├── specs/                        # Feature specifications
│   ├── adrs/                         # Architecture decisions
│   └── runbooks/                     # Operational procedures
└── scripts/
    └── convert.sh                    # Markdown ↔ DOCX conversion
```

## Success Metrics

- ✅ Linear workspace configured
- ✅ Initial tasks created (SLHQ-13 through SLHQ-16)
- ✅ Live links established in README
- ✅ Task tracking document created
- ⏳ Slack integration pending (SLHQ-14)
- ⏳ GitHub integration pending (SLHQ-15)
- ⏳ Notion database pending (SLHQ-16)

## Resources

- **Linear Workspace**: https://linear.app/ikechukwu-abuah/team/SLHQ
- **Task Tracking**: `/docs/tasks/initial-setup.md`
- **Templates**: `/docs/templates/`
- **Agent Coordination**: `/agents/agents.md`

## Questions?

Refer to:
- `/agents/claude.md` for Claude Code workflows
- `/docs/templates/` for document examples
- Linear issues for specific task details

---

**The foundation is set. Time to build!** 🚀
