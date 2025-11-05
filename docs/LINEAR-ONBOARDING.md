# Linear Onboarding Guide

## Table of Contents

1. [Quick Start](#quick-start)
2. [Workspace Configuration](#workspace-configuration)
3. [Team Structure & Members](#team-structure--members)
4. [Workflow States](#workflow-states)
5. [Labels System](#labels-system)
6. [Label Groups & Organization](#label-groups--organization)
7. [Projects & Planning](#projects--planning)
8. [Linear Bot & Automation](#linear-bot--automation)
9. [Integration Ecosystem](#integration-ecosystem)
10. [Daily Workflows](#daily-workflows)
11. [MCP Tools Reference](#mcp-tools-reference)
12. [Quick Reference Cards](#quick-reference-cards)
13. [Common Patterns & Examples](#common-patterns--examples)
14. [Troubleshooting](#troubleshooting)

---

## Quick Start

Welcome to the SLHQ team in Linear! This guide will help you understand the workspace, team structure, and workflows used in the Slack-HQ project.

### What You Need to Know First

- **Workspace URL**: https://linear.app/abuah
- **Team**: SLHQ (Slack-HQ Foundation & Setup)
- **Team Key**: SLHQ
- **Team ID**: `7a15a4a6-7f83-4ead-8d80-3024d6bb7151`
- **Current Project**: Slack-HQ Foundation & Setup (Status: Code Review)
- **Target Date**: 2025-11-15

### First Steps

1. **Log in** to https://linear.app/abuah
2. **Select the SLHQ team** from the team switcher
3. **Review the Dashboard** to see current issues and project status
4. **Check your profile** and set your preferences
5. **Read this guide** thoroughly before creating issues

---

## Workspace Configuration

### Workspace Details

| Property | Value |
|----------|-------|
| **Workspace Name** | abuah |
| **Workspace URL** | https://linear.app/abuah |
| **Owner** | Kelvin Abuah (kelvin@abuah.com) |
| **Members** | 7 total (see Team Structure section) |
| **Access** | Invitation-based |

### Slack Workspace Integration

The Linear workspace is integrated with "The Council" Slack workspace:

| Property | Value |
|----------|-------|
| **Slack Workspace** | The Council |
| **Slack ID** | T068KC5GURY |
| **Notification Channel** | #council-core (C09QAKDHKMG) |
| **Integration Status** | ✅ Configured |

**What triggers Slack notifications:**
- Status changes (e.g., issue moved to "Done")
- Comments on issues
- Issue assignments
- Priority changes
- PR opened/merged

### GitHub Integration

The SLHQ team is integrated with GitHub for automatic linking:

| Property | Value |
|----------|-------|
| **GitHub Repository** | IkechukwuAbuah/slack-hq |
| **Repository URL** | https://github.com/IkechukwuAbuah/slack-hq |
| **Integration Status** | ✅ Configured |
| **Commit Format** | `<type>(SLHQ-X): description` |

**How it works:**
1. Commit messages with `SLHQ-X` automatically link to issues
2. Pull requests with issue IDs trigger status updates
3. PR merge automatically closes the associated issue
4. Links appear in Linear issue's "Git" section

**Example commit linking:**
```bash
git commit -m "feat(SLHQ-4): enable Linear GitHub integration"
git commit -m "fix(SLHQ-12): resolve authentication timeout"
```

---

## Team Structure & Members

### SLHQ Team Roster

The SLHQ team has **7 members** with various roles and specializations:

#### Human Members

| Name | Email | Role | Status | Notes |
|------|-------|------|--------|-------|
| **Kelvin Abuah** | kelvin@abuah.com | Admin | Active | Team lead, workspace owner |
| **Happiness Nneka Okoro** | happinessnnekaokoro@gmail.com | Member | Active | Team collaborator |

#### AI Agent Members

| Name | Type | Status | Purpose |
|------|------|--------|---------|
| **Devin** | OAuth App | Active | AI code assistant for autonomous implementation |
| **Cursor** | OAuth App | Active | Interactive development assistant |
| **Charlie** | OAuth App | Active | Additional AI support |
| **Factory** | OAuth App | Active | Infrastructure automation |
| **Notion AI** | OAuth App | Active | Knowledge management integration |

### Member Roles & Permissions

- **Admin**: Full access to all team settings, members, and issues
- **Member**: Can create, edit, and update issues; limited settings access
- **Guest**: View-only access (if applicable)

### Adding Team Members

To add a new member to the SLHQ team:

1. Go to **Team Settings** (⚙️ icon)
2. Navigate to **Members**
3. Click **Invite members**
4. Enter email address or select from workspace
5. Choose role (Admin or Member)
6. Send invitation

---

## Workflow States

### Issue Status Progression

The SLHQ team uses a 7-state workflow for issue management:

```
Backlog → Todo → In Progress → In Review → Done
           ↓                                    ↓
         Canceled                          Duplicate
```

### All Issue States

| State | ID | Type | Purpose | When to Use |
|-------|----|----|---------|------------|
| **Todo** | c9240e4b-b86d-45f3-b2f0-1a38ab958f8d | Unstarted | Work to be started | Ready for someone to pick up |
| **Backlog** | 59f3ab65-6eb5-4041-a862-775254b63f86 | Backlog | Lower priority items | Important but not urgent work |
| **In Progress** | 945a5fc9-e101-44e0-b845-7c8365a56ce0 | Started | Active work | Currently being worked on |
| **In Review** | 656d7908-a7b3-4a74-972a-1c2514358a37 | Started | Code/design review phase | Awaiting review before merge |
| **Done** | c9b0944e-4303-4692-b5ef-160b63387633 | Completed | Completed work | Finished and deployed |
| **Canceled** | a252eebf-6f3c-4007-8889-59ef93ea2abd | Canceled | Cancelled/won't do | Decided not to implement |
| **Duplicate** | dc8a0a83-9b36-4283-8541-0112c0cf8889 | Canceled | Duplicate of another issue | Merged into another issue |

### Status Transition Guide

**Normal Flow** (for typical features):
1. **Backlog** - Issue created, waiting for prioritization
2. **Todo** - Prioritized, ready to start
3. **In Progress** - Someone is actively working
4. **In Review** - Code/design review in progress
5. **Done** - Merged/deployed and complete

**Alternative Flows**:
- **Backlog → Canceled** - Decided not to implement
- **Todo/In Progress → Duplicate** - Found existing issue doing same work
- **In Review → In Progress** - Requested changes, back to work
- **Done → Backlog** - Regression found, reopened

### Best Practices for Status Updates

- **Move promptly**: Update status when work changes state
- **Add context**: Leave comments when status changes explain why
- **Assign yourself**: Set assignee when moving to "In Progress"
- **Request review**: Move to "In Review" when ready for feedback
- **Close properly**: Move to "Done" only when fully complete (including tests, docs, deployed)

---

## Labels System

### Overview

The SLHQ team uses a comprehensive label system organized into **5 main categories**:

1. **Type Labels** - What kind of work (Bug, Feature, Improvement, Documentation)
2. **AI Agent Labels** - Which AI agents are involved
3. **Team/Area Labels** - Which team or area of the project
4. **Phase Labels** - Development or design phase
5. **Status/Meta Labels** - Additional context

### Type Labels

Core issue types used across the team:

| Label | Color | ID | Purpose | When to Use |
|-------|-------|----|----|---------|
| **Bug** | Red (#EB5757) | 80133c8a-34ad-472b-ac9f-171710e0bb32 | Bug reports and fixes | When reporting or fixing defects |
| **Feature** | Purple (#BB87FC) | 9cec5303-1e24-42d0-b663-c931da959c2b | New features | New capability or feature request |
| **Improvement** | Blue (#4EA7FC) | e885ef6a-f7ca-4ae9-98fd-f8e6a6f31bc3 | Enhancements to existing features | Improvement to existing functionality |
| **Documentation** | Green (#4cb782) | 4299fff0-e24d-4231-b215-027966d6a541 | Documentation updates | Documentation creation/updates |

### AI Agent Labels

Labels for which AI agents are involved in the work:

#### Core AI Services

| Label | Color | ID | Purpose |
|-------|-------|----|----|
| **ai:claude-code** | Bright Blue (#0066FF) | fab99e28-0f7c-4a48-ba79-bdd684e70ab3 | Documentation, coordination, markdown specialist |
| **ai:claude-desktop** | Light Purple (#C084FC) | 7f03ad85-df5b-4806-a1ac-1e73c8f6e9cf | Claude Desktop application work |
| **ai:codex** | Medium Blue (#0052CC) | 7f4a163a-87d0-4c52-880e-41fd11696120 | Autonomous implementation with reasoning (GPT-5) |
| **ai:chatgpt** | Purple (#8B5CF6) | 3fd90d0d-f57a-472e-9d4e-aed410269424 | ChatGPT tasks - General AI assistance |
| **ai:gemini** | Deep Blue (#002966) | 9b44ea0e-293c-43a4-a422-51318ae21c85 | Large-scale codebase analysis (2M+ token context) |
| **ai:cursor** | Red (#FF6B6B) | 99193c05-4c04-4502-bffd-9f72cf7f9c70 | Cursor code editor assistant |
| **claude** | Purple (#8B5CF6) | c8edf242-1007-48be-b346-50177d42164c | Claude in every form (generic) |

#### IDE & Terminal Assistants

| Label | Color | ID | Purpose |
|-------|-------|----|----|
| **warp** | Blue-Violet (#3333FF) | dc5c96fe-4c73-4314-b314-13f80d90c5a2 | Warp terminal AI assistant |
| **windsurf** | Light Blue (#4D4DFF) | e40ed0fc-3f2c-49e0-a6a3-1caa9029910f | Windsurf code editing assistant |
| **Devin** | Cyan (#26b5ce) | bb5e0319-df6a-457f-9cc7-0338d4643384 | Devin AI code assistant |

#### Infrastructure & Management

| Label | Color | ID | Purpose |
|-------|-------|----|----|
| **session-tracker** | Medium Green (#009933) | 32a0e172-9364-433a-8381-15f4b2eae820 | Session management and audit trails |
| **tool-registry-manager** | Dark Green (#008822) | f2a9009c-3f7f-4417-8ee1-ed597b7a27a7 | Tool validation and lifecycle management |

### Team/Area Labels

Labels indicating which team or area of the project:

| Label | Color | Purpose |
|-------|-------|---------|
| **Engineering Team** | Beige (#f7c8c1) | Engineering work and tasks |
| **Design Team** | Beige (#f7c8c1) | Design and UX work |
| **Product Team** | Beige (#f7c8c1) | Product management tasks |

### Development Phase Labels

Labels for development lifecycle stages:

| Label | Color | Purpose |
|-------|-------|---------|
| **Phase 3.1 - Setup** | Dark Blue (#0066CC) | Project setup and initialization |
| **Phase 3.2 - TDD Tests** | Red (#FF6B6B) | Test-driven development phase |
| **Phase 3.3 - Core Implementation** | Green (#4ECB71) | Core feature implementation |
| **Phase 3.4 - API Endpoints** | Yellow (#FFD93D) | API endpoint development |
| **Phase 3.5 - Integration** | Purple (#9D5CFF) | System integration work |
| **Phase 3.6 - Voice/Chat** | Orange (#FF9500) | Voice and chat features |
| **Phase 3.7 - Polish** | Teal (#00BFA5) | Polish and refinement |

### Design Phase Labels

Labels for design workflow phases:

| Label | Color | Purpose |
|-------|-------|---------|
| **User Research Phase** | Green (#4cb782) | User research and discovery |
| **Ideation Phase** | Green (#4cb782) | Brainstorming and ideation |
| **Design Phase** | Green (#4cb782) | Design creation |
| **Prototype Phase** | Green (#4cb782) | Prototype development |
| **Handoff Phase** | Green (#4cb782) | Design handoff to engineering |

### Other Labels

| Label | Color | Purpose |
|-------|-------|---------|
| **Can Run Parallel** | Brown (#795548) | Work that can be parallelized |
| **Design** | Blue (#5e6ad2) | Design-related work |
| **Engineering** | Orange (#f2994a) | Engineering-related work |
| **Customer Request** | Beige (#f7c8c1) | Customer-initiated request |

### Label Usage Conventions

**Single Label Per Category:**
- Use ONE type label (Bug, Feature, Improvement, or Documentation)
- Use ONE team label (Engineering Team, Design Team, or Product Team)
- Use ONE phase label from development OR design phases

**Multiple Allowed:**
- AI Agent labels: Use MULTIPLE when multiple agents are involved
- Status/Meta labels: Use as needed for additional context

**Examples:**

```
Good:
- [Feature] + [ai:claude-code, ai:codex] + [Engineering Team] + [Phase 3.3]
- [Bug] + [ai:cursor] + [Engineering Team]
- [Documentation] + [ai:claude-code] + [Engineering Team]
- [Improvement] + [Design] + [Design Team] + [Design Phase]

Avoid:
- [Bug] + [Feature] + [Improvement] (pick one type)
- [Engineering Team] + [Design Team] + [Product Team] (pick one team)
- [Phase 3.1] + [Phase 3.2] + [Phase 3.3] (use current phase)
```

---

## Label Groups & Organization

### Understanding Label Groups

Linear allows organizing labels into **groups** for better organization and filtering. The SLHQ team uses groups to organize by category:

**Default Groups:**
- **Type**: Bug, Feature, Improvement, Documentation
- **AI Agents**: All ai:* prefixed labels
- **Teams**: Engineering Team, Design Team, Product Team
- **Phases**: Development phases (3.1-3.7) and Design phases
- **Infrastructure**: Session Tracker, Tool Registry Manager

### Using Label Groups

When creating or editing issues:

1. **Click the label icon** on the issue
2. **See grouped labels** for easy navigation
3. **Select from group** instead of scrolling long list
4. **Apply multiple** from different groups as needed

### Common Label Combinations

**For AI Agent Coordination Tasks:**
```
Feature + ai:claude-code + Engineering Team + Can Run Parallel
```

**For Bug Fixes:**
```
Bug + [specific ai agent] + Engineering Team + [current phase]
```

**For Design Work:**
```
Improvement + Design Team + [Design Phase] + Design
```

**For Documentation:**
```
Documentation + ai:claude-code + Engineering Team
```

---

## Projects & Planning

### Active Projects

#### Slack-HQ Foundation & Setup

| Property | Value |
|----------|-------|
| **Project ID** | d6b2c921-8f98-4613-bf8a-70da4bcb3504 |
| **Status** | Code Review |
| **Summary** | Establish the foundational infrastructure, integrations, and documentation for the Slack-HQ project management system |
| **Start Date** | 2025-11-02 |
| **Target Date** | 2025-11-15 |
| **URL** | https://linear.app/abuah/project/slack-hq-foundation-and-setup-edc16f971592 |
| **Icon** | TextParagraph |
| **Description** | Initial setup and foundational infrastructure for Slack-HQ system. Includes repository structure, integrations, documentation templates, and core workflows. |

### Cycles & Sprints

**Current Status**: No active cycles configured

The SLHQ team currently operates without sprint cycles. Work is prioritized through the Backlog → Todo progression instead.

**To activate cycles** in the future:
1. Go to Team Settings → Cycles
2. Configure cycle dates (weekly, bi-weekly, etc.)
3. Assign issues to cycles during planning
4. Use cycle view for sprint planning

---

## Linear Bot & Automation

### What is Linear Bot?

The **linear-bot** is a specialized Claude Code subagent that handles all Linear API operations and automations. It provides programmatic access to Linear through the Model Context Protocol (MCP).

### Linear Bot Capabilities

The linear-bot can:

- ✅ Create issues programmatically
- ✅ Update issue properties (status, labels, assignee, etc.)
- ✅ List and filter issues
- ✅ Create comments on issues
- ✅ Manage labels
- ✅ Query teams, users, and projects
- ✅ Get cycle and sprint information
- ✅ Retrieve issue details and history

### Using Linear Bot

To use the linear-bot in Claude Code:

```bash
# In Claude Code, use the Task tool:
Task(
  subagent_type="linear-bot",
  prompt="Create an issue titled 'Fix authentication bug' in SLHQ team with label 'Bug'"
)
```

### Common Linear Bot Tasks

**Create an Issue:**
```
Use linear-bot to create a new issue with:
- Title: "Implement user authentication"
- Team: SLHQ
- Labels: [Feature, ai:claude-code, Engineering Team]
- Description: Clear requirements
- Assignee: (optional)
```

**Update Issue Status:**
```
Use linear-bot to update SLHQ-12 status to "In Progress" and add comment about progress
```

**Add Labels:**
```
Use linear-bot to add "ai:codex" and "In Review" labels to SLHQ-15
```

**List Issues:**
```
Use linear-bot to list all open issues in SLHQ team with Engineering Team label
```

---

## Integration Ecosystem

### GitHub Integration

**Purpose**: Automatic linking between Linear issues and GitHub commits/PRs

**How It Works**:
1. Include SLHQ issue ID in commit message: `feat(SLHQ-4): description`
2. Commit automatically appears in Linear issue's "Git" section
3. PR with issue ID triggers status updates
4. PR merge closes the associated issue

**Commit Format**:
```bash
<type>(SLHQ-X): <description>
```

**Types**: feat, fix, docs, chore, refactor, test, perf

**Examples**:
```bash
git commit -m "feat(SLHQ-4): enable Linear GitHub integration"
git commit -m "fix(SLHQ-12): resolve authentication timeout"
git commit -m "docs(SLHQ-8): update Linear onboarding guide"
```

**Automatic Issue Closing**:
```bash
git commit -m "fix(SLHQ-20): resolve connection pool issue"
# When PR is merged, SLHQ-20 automatically moves to "Done"
```

**See Also**: [GitHub-Linear Integration Guide](./GITHUB-LINEAR-INTEGRATION.md)

### Slack Integration

**Purpose**: Real-time notifications in Slack for Linear activity

**Notification Channel**: #council-core (C09QAKDHKMG)

**Events That Notify Slack**:
- ✅ Issue status changed
- ✅ Issue commented
- ✅ Issue assigned
- ✅ Issue priority changed
- ✅ PR opened/merged

**Events That Don't Notify**:
- ❌ Issue created (too noisy)
- ❌ Issue updated (general edits)
- ❌ Issue labeled
- ❌ Issue description changed

**Slack Message Format**:
- Status change: "📋 SLHQ-X moved to [Status]"
- Comment: "💬 [User] commented on SLHQ-X"
- Assignment: "👤 SLHQ-X assigned to [User]"
- Priority: "⚡ SLHQ-X priority: [Priority]"
- PR events: "🔀 PR opened for SLHQ-X" or "✅ PR merged for SLHQ-X"

### Session Tracking Integration

**Purpose**: Track all work sessions and activities across AI agents

**How It Works**:
1. Start session: `/session-start "Task description"`
2. Session automatically tracks activities
3. Agents log work to session
4. Stop session: `/session-stop --post` broadcasts to Slack

**Benefits**:
- Comprehensive audit trails
- Multi-agent coordination
- Real-time progress updates
- Historical record of all work

**See Also**: [Session Tracking Guide](../guides/session-tracking.md)

---

## Daily Workflows

### Creating a New Issue

**Step-by-Step:**

1. **Click "New Issue"** in Linear
2. **Enter title**: Clear, concise description
3. **Select team**: SLHQ
4. **Add description**: Detailed requirements using Markdown
5. **Add labels**:
   - ONE type label (Bug/Feature/Improvement/Docs)
   - ONE team label (Engineering/Design/Product)
   - AI agent labels if known
   - Phase label if applicable
6. **Set assignee**: Who will work on it (optional)
7. **Set priority**: If urgent (optional)
8. **Click "Create"**

**Example Issue**:
```
Title: Implement JWT authentication

Description:
Add JWT-based authentication to the API endpoints.

Requirements:
- Support token generation and validation
- Include refresh token mechanism
- Add tests with 100% coverage

Labels: Feature, ai:claude-code, Engineering Team, Phase 3.3
Assignee: (optional)
```

### Updating Issue Status

**Normal Progression:**
1. **Create** → Backlog (waiting for prioritization)
2. **Prioritize** → Todo (ready to work)
3. **Start work** → In Progress (actively working)
4. **Submit PR** → In Review (awaiting review)
5. **Merge** → Done (complete)

**To Change Status:**
1. **Click status button** on issue
2. **Select new status** from dropdown
3. **Add comment** explaining the change (recommended)
4. Slack notification sent automatically

### Adding Labels to Issues

**When Creating:**
- Add in the "Labels" field during creation

**When Editing:**
1. **Click issue** to open
2. **Click label icon** (or use `/labels` command)
3. **Select from grouped labels**
4. **Remove old labels** if needed
5. **Confirm** - updates immediately

**Label Change Tips:**
- Removing development phase? Update to appropriate phase
- AI agent changed? Remove old agent, add new one
- Be specific with AI labels to coordinate with right agents

### Linking to GitHub

**Automatic Linking:**
- Include `SLHQ-X` in commit message or PR
- Linear automatically detects and links
- No manual action needed

**Manual Linking:**
1. **Get GitHub PR/Commit URL**
2. **Add to issue description** or comment
3. **Linear detects** URL and auto-links

### Collaborating on Issues

**Adding Comments:**
1. **Scroll to comments** section
2. **Type your message** (supports Markdown)
3. **@mention** specific people if needed
4. **Click "Comment"** to post
5. Slack notification sent (for substantive comments)

**Assigning Work:**
1. **Click assignee field**
2. **Search for team member** or AI agent
3. **Assign** - notifies them automatically
4. Multiple assignees allowed

---

## MCP Tools Reference

### Available Linear MCP Tools

The Linear MCP server provides direct API access through these tools:

#### Issue Management

| Tool | Purpose | Parameters |
|------|---------|-----------|
| `mcp__linear-server__list_issues` | List issues with filters | team, assignee, cycle, label, state, query |
| `mcp__linear-server__get_issue` | Get specific issue details | id |
| `mcp__linear-server__create_issue` | Create new issue | title, team, description, labels, assignee |
| `mcp__linear-server__update_issue` | Update issue properties | id, title, state, assignee, labels |
| `mcp__linear-server__create_comment` | Add comment to issue | issueId, body |
| `mcp__linear-server__list_comments` | Get issue comments | issueId |

#### Label Management

| Tool | Purpose | Parameters |
|------|---------|-----------|
| `mcp__linear-server__list_issue_labels` | List all labels | team, name |
| `mcp__linear-server__create_issue_label` | Create new label | name, teamId, color, description |

#### Team & Project Management

| Tool | Purpose | Parameters |
|------|---------|-----------|
| `mcp__linear-server__list_teams` | List all teams | query, limit |
| `mcp__linear-server__get_team` | Get team details | query (ID, key, or name) |
| `mcp__linear-server__list_projects` | List projects | team, state |
| `mcp__linear-server__get_project` | Get project details | query (ID or name) |

#### User & Cycle Management

| Tool | Purpose | Parameters |
|------|---------|-----------|
| `mcp__linear-server__list_users` | List workspace users | query |
| `mcp__linear-server__get_user` | Get user details | query |
| `mcp__linear-server__list_cycles` | List cycles/sprints | teamId, type |

#### Status Management

| Tool | Purpose | Parameters |
|------|---------|-----------|
| `mcp__linear-server__list_issue_statuses` | List available states | team |
| `mcp__linear-server__get_issue_status` | Get status details | id or name |

### Example MCP Usage

**List all open issues assigned to me:**
```bash
mcp__linear-server__list_issues(
  team: "SLHQ",
  assignee: "me",
  state: "started"
)
```

**Create a new feature issue:**
```bash
mcp__linear-server__create_issue(
  title: "Implement OAuth integration",
  team: "SLHQ",
  description: "Add OAuth 2.0 authentication support",
  labels: ["Feature", "ai:claude-code", "Engineering Team"],
  assignee: "me"
)
```

**Update issue status:**
```bash
mcp__linear-server__update_issue(
  id: "SLHQ-15",
  state: "In Review"
)
```

**List all labels for the team:**
```bash
mcp__linear-server__list_issue_labels(
  team: "SLHQ"
)
```

---

## Quick Reference Cards

### Label Quick Lookup

**Type Labels** (Pick one):
- 🐛 **Bug** (#EB5757) - Bug fixes
- ✨ **Feature** (#BB87FC) - New features
- 📈 **Improvement** (#4EA7FC) - Enhancements
- 📚 **Documentation** (#4cb782) - Docs

**AI Agent Labels** (Pick multiple if applicable):
- 📝 **ai:claude-code** (#0066FF) - Documentation specialist
- 🤖 **ai:codex** (#0052CC) - Autonomous implementation
- 💬 **ai:chatgpt** (#8B5CF6) - General AI assistance
- 📊 **ai:gemini** (#002966) - Large codebase analysis
- 🔧 **ai:cursor** (#FF6B6B) - Code editor
- 🌪️ **warp** (#3333FF) - Terminal assistant
- 🌬️ **windsurf** (#4D4DFF) - Code assistant
- 👨‍💻 **Devin** (#26b5ce) - AI coder

**Team Labels** (Pick one):
- ⚙️ **Engineering Team** (#f7c8c1)
- 🎨 **Design Team** (#f7c8c1)
- 📦 **Product Team** (#f7c8c1)

**Development Phases** (Pick current phase):
- 🔧 **Phase 3.1** - Setup
- 🧪 **Phase 3.2** - TDD Tests
- 💻 **Phase 3.3** - Core Implementation
- 🌐 **Phase 3.4** - API Endpoints
- 🔗 **Phase 3.5** - Integration
- 🎤 **Phase 3.6** - Voice/Chat
- ✨ **Phase 3.7** - Polish

### Status Workflow Cheat Sheet

```
Creation     Backlog
    ↓          ↓
Prioritize   Todo (Ready)
    ↓          ↓
 Assign     In Progress (Working)
    ↓          ↓
  Review     In Review (Reviewing)
    ↓          ↓
  Merge       Done (Finished)
    ↓          ↓
 Deploy   Slack Notified
```

### Team IDs Reference

```bash
# SLHQ Team
SLHQ_TEAM_ID="7a15a4a6-7f83-4ead-8d80-3024d6bb7151"

# Key Members
KELVIN_ID="8377163b-70f8-4721-bec3-f2df19ae84ec"
HAPPINESS_ID="47088f92-6aad-4d75-907b-1cbd311f7b9e"

# AI Agents
DEVIN_ID="d266c386-aead-4e58-a70e-87d30a1e3ae0"
CURSOR_ID="f621c7a7-5394-440c-ab4c-1b06e79d4859"
CHARLIE_ID="a6060fa7-16da-4b71-882d-4479608e119d"
```

### Common Issue Commands

```bash
# Create issue using linear-bot
Task(subagent_type="linear-bot",
  prompt="Create issue titled 'Fix login bug' in SLHQ with Bug label")

# List my issues
Task(subagent_type="linear-bot",
  prompt="List all issues assigned to me in SLHQ team")

# Update status
Task(subagent_type="linear-bot",
  prompt="Update SLHQ-15 status to 'In Review'")

# Add label
Task(subagent_type="linear-bot",
  prompt="Add 'ai:claude-code' label to SLHQ-20")
```

---

## Common Patterns & Examples

### Pattern 1: Feature Development Issue

```markdown
Title: Implement OAuth 2.0 authentication

Description:
Add OAuth 2.0 authentication support to allow third-party integrations.

## Requirements
- Support multiple OAuth providers (Google, GitHub, Microsoft)
- Implement token refresh mechanism
- Add rate limiting for token endpoints
- Comprehensive error handling

## Testing
- Unit tests for token generation and validation (100% coverage)
- Integration tests for OAuth flows
- End-to-end tests with real providers (staging)

## Acceptance Criteria
- [ ] OAuth flows working for all providers
- [ ] Tests passing with 100% coverage
- [ ] Documentation updated
- [ ] Code reviewed and approved

Labels: Feature, ai:claude-code, Engineering Team, Phase 3.3
```

### Pattern 2: Bug Report Issue

```markdown
Title: Fix API timeout on large requests

Description:
## Problem
API returns 504 Gateway Timeout when processing large data requests (>5MB).

## Steps to Reproduce
1. Send POST request with 10MB JSON payload
2. Wait 30 seconds
3. Observe 504 timeout error

## Expected Behavior
Request should complete or return 413 Payload Too Large error

## Current Behavior
Gateway timeout after 30 seconds

## Environment
- Node.js 18.0
- Express 4.18
- Database: PostgreSQL 14

Labels: Bug, ai:cursor, Engineering Team
```

### Pattern 3: Documentation Issue

```markdown
Title: Document Linear integration setup

Description:
Create comprehensive documentation for setting up Linear integrations
with GitHub and Slack.

## Sections Needed
- Workspace configuration
- GitHub integration steps
- Slack integration steps
- Common workflows
- Troubleshooting

## Deliverables
- LINEAR-INTEGRATION-SETUP.md (updated)
- GitHub-Linear guide
- Slack-Linear guide

Labels: Documentation, ai:claude-code, Engineering Team
```

### Pattern 4: Design Work Issue

```markdown
Title: Design user dashboard mockups

Description:
Create detailed mockups for the new user dashboard including:
- Dashboard layout and organization
- Widget designs
- Dark/light mode support
- Mobile responsiveness

## Deliverables
- 3 high-fidelity mockups (desktop, tablet, mobile)
- Design system updates
- Component specification

Labels: Improvement, Design Team, Design Phase, ai:figma
```

---

## Troubleshooting

### Common Issues & Solutions

#### Issue: "Can't see newly created labels"

**Problem**: Labels created via MCP don't appear in Linear UI

**Solutions**:
1. **Refresh page**: F5 or Cmd+Shift+R
2. **Verify team ID**: Ensure labels were created for SLHQ team
3. **Check label list**: Navigate to Team Settings → Labels
4. **Wait for sync**: Sometimes takes 10-30 seconds

#### Issue: "GitHub commits not linking to Linear"

**Problem**: Commits with SLHQ-X don't appear in issue's Git section

**Solutions**:
1. **Check format**: Use `feat(SLHQ-X):` not `feat: SLHQ-X`
2. **Verify integration**: Check GitHub integration is enabled
3. **Check repository**: Confirm GitHub repo is linked to Linear team
4. **Push commits**: Local commits don't sync; must be pushed

#### Issue: "Status changes not reflecting in Linear"

**Problem**: Issue shows old status or changes revert

**Solutions**:
1. **Clear cache**: Hard refresh browser (Cmd+Shift+R)
2. **Check permissions**: Ensure you have member or admin role
3. **Try again**: Sometimes requires retry after brief delay
4. **Contact admin**: If persistent, contact Kelvin Abuah

#### Issue: "Slack notifications not working"

**Problem**: No Slack messages when issue status changes

**Solutions**:
1. **Check channel**: Verify #council-core exists and bot is member
2. **Check integration**: Team Settings → Integrations → Slack
3. **Check event**: Some events (like "created") intentionally don't notify
4. **Verify bot**: Ensure Linear bot is connected to Slack workspace

#### Issue: "linear-bot subagent not responding"

**Problem**: linear-bot tasks fail or timeout

**Solutions**:
1. **Check network**: Verify internet connection
2. **Verify credentials**: Ensure Linear API token is valid
3. **Try simpler query**: Start with `list_issues` before complex queries
4. **Check rate limits**: May be hitting Linear's rate limits
5. **Contact admin**: If persistent, report to Kelvin

### Getting Help

**For Linear Questions**:
1. Check [Linear Documentation](https://linear.help)
2. Review this guide (you're reading it!)
3. Check [GitHub Integration Guide](./GITHUB-LINEAR-INTEGRATION.md)

**For SLHQ Team Questions**:
1. Post in #council-core Slack channel
2. Create an issue (meta): "Linear question about..."
3. Tag @kelvin for urgent help

**For linear-bot Issues**:
1. Verify credentials in `.env` file
2. Check Linear MCP configuration
3. Test with simple queries first
4. Report issue with reproduction steps

---

## Additional Resources

### Internal Documentation
- [TOOL-REGISTRY.md](../TOOL-REGISTRY.md) - Complete toolset reference
- [GitHub-Linear Integration](./GITHUB-LINEAR-INTEGRATION.md) - GitHub integration details
- [Session Tracking Guide](../guides/session-tracking.md) - Tracking work sessions
- [LINEAR-INTEGRATION-SETUP.md](./LINEAR-INTEGRATION-SETUP.md) - Initial setup documentation
- [LINEAR-INTEGRATION-STATUS.md](./LINEAR-INTEGRATION-STATUS.md) - Current integration status

### External Links
- [Linear Workspace](https://linear.app/abuah) - SLHQ workspace
- [Linear Docs](https://linear.help) - Official Linear help
- [GitHub Repository](https://github.com/IkechukwuAbuah/slack-hq) - Linked GitHub repo

### Contact
- **Admin**: Kelvin Abuah (kelvin@abuah.com)
- **Slack**: #council-core
- **Issues**: Create in Linear with label "question" or "help-needed"

---

## Document Information

- **Last Updated**: November 5, 2025
- **Version**: 1.0
- **Maintained By**: Kelvin Abuah & Council Team
- **Status**: Active & Maintained

For updates to this guide, create an issue in Linear with label "Documentation" and tag @ai:claude-code.
