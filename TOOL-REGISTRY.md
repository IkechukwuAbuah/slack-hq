# Tool Registry

**Purpose:** Comprehensive catalog of all tools, APIs, scripts, and integrations available in the slack-hq project.

**Last Updated:** 2025-11-03 (Session Tracking Hooks proposal added)

---

## Table of Contents

- [Tool Lifecycle & Linear Integration](#tool-lifecycle--linear-integration)
- [Local Scripts](#local-scripts)
- [Documentation & Specs](#documentation--specs)
- [MCP Servers](#mcp-servers)
- [CLI Tools](#cli-tools)
- [APIs](#apis)
- [Claude Code Subagents](#claude-code-subagents)
- [Claude Code Skills](#claude-code-skills)
- [Development Tools](#development-tools)
- [Quick Reference](#quick-reference)
- [Maintenance Process](#maintenance-process)

---

## Tool Lifecycle & Linear Integration

**IMPORTANT:** This registry (TOOL-REGISTRY.md) is the **primary source of truth** for all tools. Notion is secondary.

All tool proposals, deployments, and reviews are tracked in Linear for project management and visibility.

---

### Lifecycle Stages

Every tool goes through a structured lifecycle with Linear tracking:

```
Proposed → Triage → Staging Test → Production Deploy → Announced → Review (30d)
```

| Stage | Description | Linear Status | Registry Status |
|-------|-------------|---------------|-----------------|
| **Proposed** | Tool identified, needs evaluation | Draft | 🟡 Proposed |
| **Triage** | Security, scopes, cost review | Triage/Active | 🟡 In Triage |
| **Staging Test** | Testing in non-prod | In Progress | 🟡 Testing |
| **Production Deploy** | Live and operational | Done | ✅ Active |
| **Announced** | Council notified | Done | ✅ Active |
| **Review (30d)** | Maintenance check | Backlog | ✅ Active |

---

### Adding a New Tool

#### Step 1: Create Proposal

Use the helper script to generate the Linear issue template:

```bash
./scripts/create-tool-issue.sh "Tool Name" "Category" "Description"
```

**Example:**
```bash
./scripts/create-tool-issue.sh "Notion API" "Docs" "Sync Tool Registry to Notion"
```

This outputs a template that you can use with Claude Code to create the Linear issue.

---

#### Step 2: Create Linear Issue

Copy the output from Step 1 and ask Claude Code:

```
Create a Linear issue in the SLHQ team with the template from create-tool-issue.sh output
```

Claude will use the Linear MCP server to create the issue and return the issue ID (e.g., SLHQ-250).

---

#### Step 3: Add to TOOL-REGISTRY.md

Add a new entry to the appropriate section (MCP Servers, CLI Tools, etc.):

```markdown
### [tool-slug] Tool Name

**Status:** 🟡 Proposed

**Linear Issue:** [SLHQ-XXX](https://linear.app/abuah/issue/SLHQ-XXX)

**Purpose:** One-line description

**Proposed By:** Your Name
**Proposed Date:** YYYY-MM-DD

**Use Cases:**
- Use case 1
- Use case 2

**Capabilities:**
- Capability 1
- Capability 2

**Dependencies:**
- Required tokens/auth
- Installation requirements

**Risk Assessment:**
- **Risk Level:** Low/Medium/High
- **Data Classification:** Public/Internal/Confidential/Restricted

**Estimated Effort:** X days/weeks
```

---

#### Step 4: Follow the Workflow

The full workflow is documented in:
**[docs/runbooks/tool-registry-linear-integration.md](docs/runbooks/tool-registry-linear-integration.md)**

**Summary:**
1. **Triage:** Assign owner, review scopes, security check
2. **Staging:** Test in dev/staging environment
3. **Deploy:** Move to production
4. **Announce:** Post to #council-core Slack channel
5. **Review:** Schedule 30-day health check

---

### Quick Commands

#### List Tool Proposals in Linear
```bash
# Via Claude Code:
"List all Linear issues with label 'Tool Registry' in SLHQ team"

# Or directly with Linear MCP:
mcp__linear-server__list_issues team="SLHQ" label="Tool Registry"
```

#### Update Tool Status
```bash
# Mark as Active (after deployment)
mcp__linear-server__update_issue id="SLHQ-XXX" state="Done"

# Add deployment notes
mcp__linear-server__add_issue_comment \
  issueId="SLHQ-XXX" \
  body="Deployed to production. Health check: ✅"
```

#### Create 30-Day Review Issue
```bash
mcp__linear-server__create_issue \
  team="SLHQ" \
  title="Review: [Tool Name]" \
  description="[Review template]" \
  dueDate="YYYY-MM-DD" \
  labels=["Tool Registry", "Review"]
```

---

### Governance

**Approval Requirements:**

| Risk Level | Approver | Review Process |
|------------|----------|----------------|
| **Low** | Tool Owner | Self-review + peer check |
| **Medium** | Tool Owner + Council Lead | Security review + cost analysis |
| **High** | Tool Owner + Council Lead + Security Review | Comprehensive audit |

**Security Review Required For:**
- High/Restricted data classification
- Broad OAuth scopes (admin, write-all)
- External API integrations
- Financial/payment tools

---

### Notion Integration (Secondary)

**Notion Tool Registry Database:**
- Location: `SLHQ Onboarding for Agents` page in 2nd Brain
- Status: Operational database (secondary to this markdown file)
- Purpose: Operational view for The Council workspace

**Key Principle:**
- **Primary Source of Truth:** TOOL-REGISTRY.md (this file)
- **Secondary/Operational:** Notion database
- **Sync Strategy:** One-way (markdown → Notion), manual updates

**DO NOT** use Notion as the source of truth. Always reference TOOL-REGISTRY.md for canonical tool state.

---

### Related Documentation

- **Runbook:** [docs/runbooks/tool-registry-linear-integration.md](docs/runbooks/tool-registry-linear-integration.md)
- **Linear Templates:** In runbook above
- **Helper Script:** [scripts/create-tool-issue.sh](scripts/create-tool-issue.sh)
- **Slack Templates:** [scripts/slack/tool-proposal-template.json](scripts/slack/tool-proposal-template.json)

---

## Local Scripts

### 1. slack-setup.sh

**Location:** `scripts/slack-setup.sh`

**Purpose:** Deploy and configure Council Bot in "The Council" Slack workspace

**Capabilities:**
- Authenticate with Slack CLI
- Validate and deploy app manifest
- Install/update Council Bot with OAuth flow
- Generate installation URLs

**Usage:**
```bash
./scripts/slack-setup.sh
```

**Requirements:**
- Slack CLI installed (`brew install --cask slack-cli`)
- Access to "The Council" workspace

**When to Use:**
- Initial Council Bot setup
- Updating manifest.yml changes
- Re-authenticating after token expiry

---

### 2. convert.sh

**Location:** `scripts/convert.sh`

**Purpose:** Bidirectional conversion between Markdown and DOCX formats

**Capabilities:**
- Markdown → DOCX conversion (preserves structure, code blocks, tables)
- DOCX → Markdown conversion (extracts media, adds YAML frontmatter)
- Batch conversion support
- Auto-generated output filenames
- Syntax highlighting preservation

**Usage:**
```bash
# Convert markdown to DOCX
./scripts/convert.sh md2docx docs/specs/feature.md

# Convert DOCX to markdown
./scripts/convert.sh docx2md external-spec.docx docs/specs/imported-spec.md
```

**Requirements:**
- Pandoc installed (`brew install pandoc`)

**When to Use:**
- Sharing specs with external stakeholders (DOCX format)
- Importing external documentation (DOCX → MD)
- Creating presentation-ready documents

---

### 3. session.sh

**Location:** `scripts/session.sh`

**Purpose:** Session tracking CLI for managing AI agent activity logs and audit trails

**Capabilities:**
- Session lifecycle management (start, stop, pause, resume)
- JSON schema validation before persistence
- UUID-based unique session identifiers
- Activity logging with timestamps
- File modification tracking
- Slack integration for progress updates
- Multi-agent coordination support

**Usage:**
```bash
# Start a new session
./scripts/session.sh start "Implement authentication" --auto-post --channel #council-ops

# Check current session status
./scripts/session.sh status

# View session history
./scripts/session.sh history --limit 10

# Show detailed session info
./scripts/session.sh show <session-id>

# Post update to Slack
./scripts/session.sh post --id <session-id> --summary "Progress update"

# Stop session with notes
./scripts/session.sh stop <session-id> --notes "Feature complete, tests passing"
```

**Requirements:**
- `.claude/data/sessions/` directory (auto-created)
- `config/schemas/session.json` schema file
- `jq` for JSON manipulation
- `uuidgen` for session ID generation
- Slack Bot Token for Slack integration (optional)

**Session Data Structure:**
- **Storage:** `.claude/data/sessions/{uuid}.json`
- **Schema:** JSON Schema v7 validation
- **Gitignored:** Session data stays local for privacy
- **Fields:** agent_name, started_at, ended_at, status, activities[], files_modified[], handoff_status

**When to Use:**
- Starting significant work that needs tracking
- Creating audit trails for compliance
- Coordinating multi-agent workflows
- Posting progress updates to Slack
- Managing session handoffs between agents
- Generating activity reports

**Related Documentation:**
- Spec: `docs/specs/session-tracking.md` (SLHQ-241)
- Research: `docs/research/session-tracking-analysis.md`
- Guide: `docs/guides/posting-session-tracking-announcement.md`
- Runbook: `docs/runbooks/session-tracking-rollout.md`

---

## Documentation & Specs

### Session Tracking Documentation Suite

**Status:** ✅ Complete (Research, Design, Communication phases)
**GitHub Issue:** [#2 Session Tracking](https://github.com/IkechukwuAbuah/slack-hq/issues/2)
**Slack Announcement:** Posted to channel C0684S1LTLP @ ts:1762130277.053359

**Purpose:** Comprehensive documentation for implementing chronological session tracking across AI Council agents

---

#### 1. Research Report

**Location:** `docs/research/session-tracking-analysis.md`

**Contents:**
- Executive summary
- Current slack-hq architecture analysis
- Reference implementation review (claude md project)
- Gap analysis
- 4 Architecture Decision Records (ADRs)
- File structure proposal
- 4-phase implementation roadmap
- Risk assessment & success metrics
- Slack integration patterns

**Size:** 136 lines

**When to Use:**
- Understanding session tracking requirements
- Learning from reference implementation
- Reviewing architectural decisions
- Planning implementation approach

---

#### 2. Technical Specification

**Location:** `docs/specs/session-tracking.md`

**Linear ID:** SLHQ-241

**Contents:**
- Feature overview with user stories
- Complete JSON schema with validation
- 6 command specifications (`/session start|stop|status|history|show|post`)
- File structure and state machine
- Slack Block Kit integration
- Implementation guide (4 phases, ~10 days)
- Usage examples
- 4 ADRs with architectural rationale

**Size:** 342 lines

**Key Components:**
```
.claude/
  commands/session/          # Slash command definitions
  data/sessions/             # JSON session files (gitignored)
  hooks/                     # Lifecycle automation
scripts/
  session.sh                 # Main CLI script
config/
  schemas/session.json       # JSON Schema validation
```

**When to Use:**
- Implementing session tracking features
- Understanding data schema
- Reviewing command specifications
- Planning Slack integration

---

#### 3. Slack Announcement Package

**Locations:**
- Message Payload: `scripts/slack/session-tracking-announcement.json`
- Posting Guide: `docs/guides/posting-session-tracking-announcement.md`

**Purpose:** Council communication and feedback gathering

**Message Structure:**
- Block Kit formatted announcement
- Problem statement & inspiration
- Key features (5 bullets)
- Architecture overview (4 components)
- 4-phase roadmap with timelines
- Documentation links
- Council feedback questions
- Interactive buttons (Priority/Review/Volunteer)

**Usage:**
```bash
# Post to Slack
curl -s -X POST https://slack.com/api/chat.postMessage \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN" \
  -H "Content-Type: application/json; charset=utf-8" \
  --data @scripts/slack/session-tracking-announcement.json
```

**When to Use:**
- Announcing features to Council
- Gathering stakeholder feedback
- Coordinating multi-agent implementation

---

#### 4. Rollout Summary

**Location:** `docs/runbooks/session-tracking-rollout.md`

**Contents:**
- Complete deliverables summary
- Phase completion status
- Implementation roadmap
- Success metrics
- Risk mitigation strategies
- Next steps & timeline

**When to Use:**
- Tracking project status
- Onboarding new contributors
- Reviewing implementation progress

---

#### 5. Announcement Record

**Location:** `docs/runbooks/session-tracking-announcement-record.md`

**Contents:**
- Mission completion summary
- All phase deliverables
- Slack post details (channel, timestamp)
- Architecture decisions
- Implementation roadmap
- Success metrics
- Lessons learned

**When to Use:**
- Historical reference
- Post-mortem analysis
- Documenting completed phases

---

### Session Tracking Quick Reference

**Implementation Phases:**
1. **Phase 1** (2-3 days): Session Persistence - JSON storage, hooks, schema validation
2. **Phase 2** (3-4 days): Slash Commands - CLI interface, command templates
3. **Phase 3** (2-3 days): Slack Integration - Council Bot posting, threading
4. **Phase 4** (2 days): Status Line - Real-time session display

**ADRs:**
- **ADR-001**: JSON storage over SQLite (portability)
- **ADR-002**: Gitignore session data (security)
- **ADR-003**: Manual posting with opt-in auto-post (noise control)
- **ADR-004**: Multi-agent concurrency model (coordination)

**Success Metrics:**
- 80%+ agent adoption within first month
- 100% active sessions produce JSON entries
- Average 1+ Slack update per sprint
- 90%+ handoffs include notes/activities

---

## MCP Servers

### 1. Slack MCP Server

**Package:** `@modelcontextprotocol/server-slack`

**Status:** 🟡 Configured but not actively used (curl preferred)

**Configuration:**
```json
{
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-slack"],
  "env": {
    "SLACK_BOT_TOKEN": "$SLACK_BOT_TOKEN",
    "SLACK_TEAM_ID": "T068KC5GURY",
    "SLACK_CHANNEL_IDS": "C0684S1LTLP,C068K8VDXGB,C0684RPSHCP"
  }
}
```

**Theoretical Capabilities:**
- Post messages to channels
- Read channel history
- Search conversations
- Manage reactions
- File uploads

**Current Status:**
- ✅ Token configured and valid
- ✅ Channels accessible (C0684S1LTLP, C068K8VDXGB, C0684RPSHCP)
- 🟡 Not actively used (Slack Web API via curl is preferred)

**Why Use curl Instead:**
- Direct API access is simpler and more reliable
- No MCP server overhead
- Easier to debug and verify requests
- Same bot token works for both

**When to Use MCP:**
- If you need MCP-specific features
- If using tools that require MCP integration
- For consistency with other MCP servers

**Documentation:** See Slack Web API section below for working examples

---

### 2. Linear MCP Server

**Package:** `@modelcontextprotocol/server-linear` (assumed)

**Capabilities:**
- Create/update Linear issues
- List issues with filters
- Manage projects and cycles
- Update issue status
- Add comments
- Search documentation

**Available Functions:** (visible in tool list)
- `mcp__linear-server__list_issues`
- `mcp__linear-server__create_issue`
- `mcp__linear-server__update_issue`
- `mcp__linear-server__list_teams`
- `mcp__linear-server__get_team`
- `mcp__linear-server__list_projects`
- `mcp__linear-server__create_project`
- And 20+ more functions

**When to Use:**
- Creating issues from Slack messages
- Syncing Linear updates to Slack
- Automated project management
- Generating Linear reports

**Documentation:** See `docs/guides/slack-linear-quick-create.md`

---

### 3. GitHub MCP Server

**Package:** `@modelcontextprotocol/server-github`

**Capabilities:**
- Repository management (create, fork, search)
- File operations (read, write, push multiple files)
- Issue management (create, update, comment, search)
- Pull request operations (create, merge, review, status)
- Branch management (create, list commits)
- Code search

**Available Functions:** (30+ functions including)
- `mcp__github__create_repository`
- `mcp__github__push_files`
- `mcp__github__create_pull_request`
- `mcp__github__create_issue`
- `mcp__github__search_code`
- `mcp__github__search_issues`
- `mcp__github__merge_pull_request`
- `mcp__github__get_pull_request_files`

**When to Use:**
- Automated repo setup
- Bulk file operations
- CI/CD integration
- Code search across repositories
- PR automation

**Documentation:** See `docs/GITHUB-LINEAR-INTEGRATION.md`

---

### 4. Notion MCP Server

**Package:** `@modelcontextprotocol/server-notion` (assumed)

**Capabilities:**
- User management (retrieve users, list all users)
- Database operations (query, create, update, retrieve)
- Page operations (create, retrieve, update properties)
- Block operations (append children, retrieve, update, delete)
- Comment management (retrieve, create)
- Search functionality

**Available Functions:** (25+ functions including)
- `mcp__notionApi__API-post-search`
- `mcp__notionApi__API-post-database-query`
- `mcp__notionApi__API-create-a-database`
- `mcp__notionApi__API-post-page`
- `mcp__notionApi__API-patch-page`
- `mcp__notionApi__API-patch-block-children`
- `mcp__notionApi__API-create-a-comment`

**When to Use:**
- Long-term knowledge storage
- Creating meeting notes
- Documentation backups
- Cross-linking with Linear issues

---

## CLI Tools

### 1. Slack CLI

**Version:** v3.9.0

**Installation:** `brew install --cask slack-cli`

**⚠️ Limited Functionality:** v3.9.0 removed the `slack api` command

**What Works ✅:**
```bash
slack auth list              # Check authentication status
slack manifest validate      # Validate manifest.yml syntax
# Note: These commands are for setup/deployment only
```

**What DOESN'T Work ❌:**
```bash
slack api conversations.list      # Command not found
slack api chat.postMessage         # Command not found
# The 'api' subcommand was removed in v3.9.0
```

**When to Use:**
- ✅ Checking authentication status
- ✅ Validating app manifest syntax
- ❌ API operations (use Slack Web API with curl instead)
- ❌ Posting messages (use curl or Slack MCP)
- ❌ Reading channels (use curl or Slack MCP)

**Recommendation:** Use Slack Web API (curl) or Slack MCP Server for all operational tasks

---

### 2. Gemini CLI

**Installation:** Via environment variable `GEMINI_API_KEY`

**Primary Use:** Large codebase analysis with massive context window

**Key Features:**
- 2M+ token context window
- `@file` and `@directory` syntax for inclusion
- Read-only analysis (no file modifications)
- Project-wide pattern search

**Usage:**
```bash
# Single file analysis
gemini -p "@src/main.py Explain this file's purpose"

# Entire codebase analysis
gemini -p "@./ identify all components using deprecated APIs"

# Multi-file comparison
gemini -p "@package.json @src/index.js Analyze dependencies"
```

**When to Use:**
- Analyzing 100+ files at once
- Project-wide architecture review
- Security audits across entire codebase
- Finding patterns in large codebases

**Documentation:** See CLAUDE.md section "Using Gemini CLI for Large Codebase Analysis"

---

### 3. Cursor CLI (cursor-agent)

**Installation:** Available via system PATH

**Primary Use:** Interactive AI coding with conversation state

**Key Features:**
- Maintains conversation history
- Resume previous conversations
- Project rules integration (`.cursor/rules`)
- Git diff integration
- Multiple output formats (text, JSON)

**Usage:**
```bash
# Interactive mode
cursor-agent "analyze this codebase for performance bottlenecks"

# Resume last conversation
cursor-agent resume

# Non-interactive mode for automation
cursor-agent -p "review code for security vulnerabilities" --output-format text

# With git diffs
cursor-agent --with-diffs -p "review these changes"
```

**When to Use:**
- Interactive development sessions
- Complex refactoring with context
- Code review workflows
- CI/CD automation

**Documentation:** See CLAUDE.md section "Tool: Cursor CLI for Interactive AI Coding Assistance"

---

### 4. Codex CLI

**Model:** GPT-5 by default

**Installation:** Available via system PATH

**Primary Use:** Autonomous coding with reasoning and sandboxing

**Key Features:**
- Built-in reasoning display
- Progressive autonomy levels (suggest, auto-approval, full-auto)
- Sandboxed execution
- AGENTS.md rules integration
- No @ syntax needed (infers context)

**Approval Modes:**
```bash
# Suggest mode (manual approval for each action)
codex -a untrusted "review and fix API endpoints"

# Auto-approval for trusted operations
codex -a on-failure "implement user registration"

# Full autonomy with sandboxing
codex --full-auto "fix all linting errors"
```

**Sandboxing Levels:**
```bash
# Read-only (safest)
codex -s read-only "analyze code quality"

# Workspace write (balanced)
codex -s workspace-write "implement new feature"

# Full access (use carefully)
codex -s danger-full-access "setup development environment"
```

**When to Use:**
- Complex debugging with reasoning
- Autonomous feature implementation
- Automated code quality improvements
- TDD workflows
- CI/CD pipeline tasks

**Documentation:** See CLAUDE.md section "Tool: OpenAI Codex CLI for Autonomous Coding"

---

## APIs

### 1. Slack Web API

**Base URL:** `https://slack.com/api/`

**Authentication:** Bearer token (`SLACK_BOT_TOKEN`)

**Status:** ✅ **VERIFIED WORKING** (Used for session tracking announcement)

**Why Use This:** Slack CLI v3.9.0 removed the `api` command, direct Web API is now the primary method

---

#### Verified Working Operations ✅

**Post Message with Block Kit (TESTED):**
```bash
# Successfully posted session tracking announcement
curl -s -X POST https://slack.com/api/chat.postMessage \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN" \
  -H "Content-Type: application/json; charset=utf-8" \
  --data @scripts/slack/session-tracking-announcement.json

# Response: {"ok":true,"channel":"C0684S1LTLP","ts":"1762130277.053359"}
```

**Key Success Factors:**
- ✅ Use channel ID (e.g., `C0684S1LTLP`), NOT channel name (e.g., `#council-ops`)
- ✅ Include `charset=utf-8` in Content-Type header
- ✅ Use `-s` flag with curl to suppress progress output
- ✅ Block Kit formatting works perfectly with buttons and rich text

---

#### Untested But Should Work 🟡

**List Channels:**
```bash
curl -X GET https://slack.com/api/conversations.list \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN" \
  -H "Content-Type: application/json; charset=utf-8" \
  -G \
  --data-urlencode "types=public_channel,private_channel" \
  --data-urlencode "exclude_archived=true"
```

**Read Channel History:**
```bash
curl -X GET https://slack.com/api/conversations.history \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN" \
  -H "Content-Type: application/json; charset=utf-8" \
  -G \
  --data-urlencode "channel=C0684S1LTLP" \
  --data-urlencode "limit=50"
```

**Read Thread Replies:**
```bash
curl -X GET https://slack.com/api/conversations.replies \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN" \
  -H "Content-Type: application/json; charset=utf-8" \
  -G \
  --data-urlencode "channel=C0684S1LTLP" \
  --data-urlencode "ts=1762130277.053359"
```

**Add Reaction:**
```bash
curl -X POST https://slack.com/api/reactions.add \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN" \
  -H "Content-Type: application/json; charset=utf-8" \
  --data '{"channel":"C0684S1LTLP","timestamp":"1762130277.053359","name":"thumbsup"}'
```

**Get Reactions:**
```bash
curl -X GET https://slack.com/api/reactions.get \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN" \
  -H "Content-Type: application/json; charset=utf-8" \
  -G \
  --data-urlencode "channel=C0684S1LTLP" \
  --data-urlencode "timestamp=1762130277.053359"
```

**Create Channel:**
```bash
curl -X POST https://slack.com/api/conversations.create \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN" \
  -H "Content-Type: application/json; charset=utf-8" \
  --data '{"name":"new-channel","is_private":false}'
```

**Set Channel Topic:**
```bash
curl -X POST https://slack.com/api/conversations.setTopic \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN" \
  -H "Content-Type: application/json; charset=utf-8" \
  --data '{"channel":"C0684S1LTLP","topic":"Channel description"}'
```

---

#### What I Can Do Now ✅

With the configured bot token, I can:

1. **Post Messages** ✅ (Verified)
   - Plain text messages
   - Rich Block Kit formatting
   - Interactive buttons and elements
   - Threaded replies

2. **Read Conversations** 🟡 (Should work)
   - List all channels
   - Read channel history
   - Read thread replies
   - Search messages

3. **Manage Reactions** 🟡 (Should work)
   - Add reactions to messages
   - Get reactions on messages
   - List who reacted

4. **Channel Management** 🟡 (Should work)
   - Create new channels
   - Set channel topics
   - Invite users to channels
   - Archive/unarchive channels

---

#### What I CANNOT Do ❌

- **Install/deploy the app** (requires Slack CLI with proper workspace permissions)
- **Modify app manifest** (requires Slack CLI + admin permissions)
- **Delete messages** (requires additional bot scopes)
- **Manage users** (limited by OAuth scopes)
- **Access DMs** (unless explicitly granted)

---

#### Current Workspace Configuration

**Workspace:** 2nd Brain (formerly "The Council")
**Team ID:** T068KC5GURY
**Bot Token:** `$SLACK_BOT_TOKEN` (set in environment)
**Bot User:** claude_mcp (U09QP9FG5HP)
**Bot ID:** B09Q8AVT14N

**Accessible Channels:**
- `C0684S1LTLP` - #2nd-brain (verified working - posted announcement here)
- `C068K8VDXGB` - #general
- `C0684RPSHCP` - #random

**Other Channels (from previous documentation):**
- `C09R4SBU4JU` - #council-bot
- `C09Q73W69GD` - #ai-agents
- `C09QAHNAFL2` - #project-updates
- `C09R4SCJ108` - #documentation
- `C09R4SCGR24` - #automation

---

#### Best Practices

1. **Always use channel IDs, not names**
   - ❌ `"channel":"#council-ops"`
   - ✅ `"channel":"C0684S1LTLP"`

2. **Include charset in Content-Type**
   - ✅ `Content-Type: application/json; charset=utf-8`

3. **Use GET for reads, POST for writes**
   - GET: conversations.list, conversations.history, reactions.get
   - POST: chat.postMessage, conversations.create, reactions.add

4. **Check response.ok before parsing**
   ```bash
   response=$(curl -s ...)
   if echo "$response" | jq -e '.ok == true' > /dev/null; then
     echo "Success!"
   else
     echo "Error: $(echo "$response" | jq -r '.error')"
   fi
   ```

5. **Store responses for debugging**
   ```bash
   curl -s ... | tee /tmp/slack-response.json | jq .
   ```

**Documentation:**
- Official: https://api.slack.com/methods
- Project: `docs/slack-cli-capabilities.md`
- Session tracking example: `scripts/slack/session-tracking-announcement.json`

---

### 2. Linear API

**Access Method:** Via Linear MCP Server (recommended)

**Direct API:** `https://api.linear.app/graphql`

**Why Use MCP:** Type-safe operations, automatic error handling, built-in retries

**See:** MCP Servers section for Linear MCP Server details

---

### 3. GitHub API

**Access Method:** Via GitHub MCP Server (recommended)

**Direct API:** `https://api.github.com/`

**Why Use MCP:** Simplified authentication, batch operations, PR management

**See:** MCP Servers section for GitHub MCP Server details

---

### 4. Notion API

**Access Method:** Via Notion MCP Server (recommended)

**Direct API:** `https://api.notion.com/v1/`

**Why Use MCP:** Database queries, block operations, hierarchical content management

**See:** MCP Servers section for Notion MCP Server details

---

## Claude Code Subagents

**Purpose:** Specialized AI assistants with focused expertise and separate context windows

**Access Method:** Via `Task` tool with `subagent_type` parameter

**Available Subagents:**

### General Purpose
- **general-purpose:** Complex multi-step tasks, research, file search
- **Explore:** Fast codebase exploration and architecture discovery
- **Plan:** Planning and design without execution

### Code Quality
- **code-reviewer:** Proactive code review after writing code
- **test-writer-fixer:** Write tests, run tests, fix failures
- **test-runner:** Proactive test execution after code changes
- **test-results-analyzer:** Analyze test data and generate quality reports
- **error-debugger:** Root cause analysis and debugging

### Development
- **rapid-prototyper:** Quick MVPs and proof-of-concepts (6-day cycles)
- **implementation-validator:** Verify claims match actual implementation
- **consistency-checker:** Cross-file validation and naming conventions

### Security & Performance
- **security-auditor:** Vulnerability scanning and compliance checks
- **performance-benchmarker:** Performance testing and optimization

### Testing & Quality
- **tdd-reporter-setup:** Auto-configure TDD Guard reporters
- **sdd-tdd-orchestrator:** Bridge specs to test-driven implementation
- **api-tester:** API testing, load testing, contract testing

### Design & UX
- **ui-designer:** UI components and design systems
- **ux-researcher:** User research and journey mapping
- **visual-storyteller:** Visual narratives and infographics
- **brand-guardian:** Brand guidelines and consistency

### Tools & Integration
- **tool-registry-manager:** Validate, test, and manage TOOL-REGISTRY.md; Linear lifecycle tracking
- **tool-evaluator:** Evaluate frameworks and tools
- **workflow-optimizer:** Human-agent collaboration workflows
- **tmux-agent-controller:** Wrap interactive CLI tools (codex, gemini, cursor-agent)
- **linear-bot:** Linear API operations and task management
- **meta-agent:** Generate new subagent configurations

### Workflow & Coordination
- **session-tracker:** Session lifecycle management, audit trails, Slack integration, multi-agent coordination

### Specialized
- **hello-world:** Simple greeting responses
- **llm-researcher:** AI/ML research and news gathering
- **work-completion-summary:** Audio summaries with TTS
- **statusline-setup:** Configure Claude Code status line

**When to Use Subagents:**
- Complex tasks requiring specialized expertise
- Preserve main conversation context
- Parallel execution of independent tasks
- Automatic delegation for specific patterns (code review, testing)

**Documentation:** See `AGENTS.md` and individual agent configs in `~/.claude/agents/`

---

## Claude Code Skills

**Purpose:** Self-contained knowledge packages with reference documentation and implementation guidance

**Access Method:** Via `Skill` tool with skill name parameter

**Base Directory:** `~/.claude/skills/` or `.claude/skills/`

**Available Skills:**

### session-tracking

**Location:** `.claude/skills/session-tracking/`

**Purpose:** Comprehensive guidance for implementing session tracking infrastructure

**Contents:**
- `SKILL.md` - Main skill documentation
- `references/cli-commands.md` - CLI command specifications
- `references/schema.md` - JSON schema details
- `references/slack-integration.md` - Slack API integration patterns
- `references/testing-guide.md` - Testing procedures
- `scripts/session-schema.json` - JSON Schema v7 file
- `scripts/session.sh` - Reference CLI implementation

**When to Use:**
- Implementing `/session` commands
- Creating or validating session JSON files
- Setting up Slack integration for Council Bot
- Managing session lifecycle and state transitions
- Building multi-agent coordination workflows
- Understanding session data schema

**Key Capabilities:**
- Session initialization with UUID and ISO8601 timestamps
- State machine (idle → active → paused → completed)
- Activity logging (code, analysis, meetings, deployments)
- JSON Schema validation before persistence
- Slack Block Kit formatting and threading
- Multi-agent handoff tracking

**Invocation:**
```bash
# In Claude Code
/skill session-tracking
```

**Documentation:** See `SKILL.md` for complete workflow and implementation patterns

---

## Development Tools

### 1. Spec Kit

**Purpose:** Spec-Driven Development (SDD) - specifications become executable

**Installation:** `uv tool install specify-cli --from git+https://github.com/github/spec-kit.git`

**Key Commands:**
- `specify init <project-name>` - Create spec-driven project
- `specify check` - Verify system requirements

**Slash Commands (in Claude Code):**
- `/constitution` - Define project principles
- `/specify` - Describe WHAT to build
- `/clarify` - Refine specifications
- `/plan` - Define technical approach
- `/tasks` - Break down into tasks
- `/implement` - Execute implementation

**When to Use:**
- Greenfield projects
- Feature specifications
- Quality-focused development
- AI-first workflows

**Documentation:** See CLAUDE.md section "Spec-Driven Development (SDD)"

---

### 2. TDD Guard

**Purpose:** Automated TDD enforcement with red-green-refactor cycle

**Installation:** Configured globally in `~/.claude/settings.json` hooks

**Components:**
- **TDD Guard Hook:** Blocks implementation without failing tests
- **TDD Reporter Setup Agent:** Auto-configures test reporters
- **SDD-TDD Orchestrator:** Bridges specs to tests

**Reporters:**
- JavaScript/TypeScript: `tdd-guard-vitest`, `tdd-guard-jest`
- Python: `tdd-guard-pytest`
- PHP, Go, Rust: Framework-specific

**Setup Command:** `/setup-tdd [project-path]`

**When to Use:**
- Enforcing test-first development
- Quality-critical projects
- Pairing with Spec Kit for SDD→TDD flow

**Documentation:** See CLAUDE.md section "TDD Guard + SDD Integration"

---

### 3. Session Tracking Hooks

**Status:** 🟡 Proposed

**Linear Issue:** [SLHQ-17](https://linear.app/abuah/issue/SLHQ-17)

**GitHub Issue:** [#2](https://github.com/IkechukwuAbuah/slack-hq/issues/2)

**Purpose:** Automatic session tracking via Claude Code hooks system - replaces manual slash commands with deterministic hook-based automation

**Proposed By:** Kelvin Ikechukwu Abuah
**Proposed Date:** 2025-11-03

**Use Cases:**
- Automatic session creation when Claude starts work (SessionStart hook)
- Real-time activity tracking as tools are used (PreToolUse hook)
- Automatic session completion with Slack posting (Stop hook)
- Subagent handoff tracking (SubagentStop hook)
- Zero manual intervention needed (no /session-start or /session-stop)

**Capabilities:**
- Auto-create session on SessionStart hook
- Track activities via PreToolUse hook (Write/Edit/Bash/Read/Grep)
- Auto-complete session on Stop hook with optional Slack posting
- Log subagent handoffs via SubagentStop hook
- Backward compatible with existing slash commands
- Configurable auto-post, channel routing, filters
- JSON Schema validation before persistence
- Slack Block Kit integration for rich formatting

**Architecture:**
```
~/.claude/hooks/
├── session_tracker.py        # Main hook handler (receives JSON from stdin)
├── session_manager.py        # Session CRUD operations
├── slack_poster.py           # Slack Block Kit integration
└── config.json              # Settings (auto-post, channels, filters)

.claude/data/sessions/        # Existing storage (unchanged)
└── *.json
```

**Hook Configuration:**
```json
{
  "hooks": {
    "SessionStart": [{"matcher": "", "hooks": [{"type": "command", "command": "uv run ~/.claude/hooks/session_tracker.py start"}]}],
    "Stop": [{"matcher": "", "hooks": [{"type": "command", "command": "uv run ~/.claude/hooks/session_tracker.py stop --auto-post"}]}],
    "PreToolUse": [
      {"matcher": "Write|Edit|MultiEdit", "hooks": [{"type": "command", "command": "uv run ~/.claude/hooks/session_tracker.py activity --type code"}]},
      {"matcher": "Bash", "hooks": [{"type": "command", "command": "uv run ~/.claude/hooks/session_tracker.py activity --type deployment"}]},
      {"matcher": "Read|Grep|Glob", "hooks": [{"type": "command", "command": "uv run ~/.claude/hooks/session_tracker.py activity --type analysis"}]}
    ],
    "SubagentStop": [{"matcher": "", "hooks": [{"type": "command", "command": "uv run ~/.claude/hooks/session_tracker.py subagent"}]}]
  }
}
```

**Dependencies:**
- Python 3.10+ with `uv` package manager
- Existing `SLACK_BOT_TOKEN` in environment
- `.claude/data/sessions/` directory (auto-created)
- Existing session JSON schema

**Risk Assessment:**
- **Risk Level:** Low
- **Data Classification:** Internal (session metadata)
- **Security Concerns:** Hook runs on every tool use (must be fast <100ms), should fail gracefully
- **Data Retention:** Same as existing sessions (gitignored, local only)
- **Audit Trail:** All hooks log to ~/.claude/logs/hooks/

**Estimated Effort:** 3-4 days
- Day 1: Hook scripts (session_tracker.py, session_manager.py, slack_poster.py)
- Day 2: Configuration, testing, validation
- Day 3: Documentation updates (CLAUDE.md, AGENTS.md)
- Day 4: Deployment, announcement, monitoring setup

**Benefits Over Current Approach:**
- ✅ Automatic tracking (no manual commands needed)
- ✅ Comprehensive activity capture (real-time)
- ✅ Transparent operation (works silently)
- ✅ Deterministic execution (always runs, not LLM-dependent)
- ✅ Backward compatible (manual controls remain)

**When to Use:**
- Enable for all Claude Code sessions (automatic)
- Configure auto-post behavior per project
- Adjust activity filters based on workflow needs

**Documentation:**
- Hook Docs: `/Users/x/Downloads/api-docs/anthropic/cc_hooks_docs.md`
- Subagent Docs: `/Users/x/Downloads/api-docs/anthropic/anthropic_docs_subagents.md`
- Existing Skill: `.claude/skills/session-tracking/`
- Linear Issue: [SLHQ-17](https://linear.app/abuah/issue/SLHQ-17)
- GitHub Issue: [#2](https://github.com/IkechukwuAbuah/slack-hq/issues/2)

---

## Quick Reference

### Decision Tree: Which Tool to Use?

```
Need to...

Deploy Council Bot?                    → scripts/slack-setup.sh
Convert docs (MD ↔ DOCX)?             → scripts/convert.sh
Track agent work sessions manually?    → scripts/session.sh
Track agent work sessions automatically? → Session Tracking Hooks (proposed)
Propose new tool integration?          → scripts/create-tool-issue.sh

Post to Slack?                         → Slack Web API (curl)
Create Linear issue?                   → Linear MCP Server
Push to GitHub?                        → GitHub MCP Server
Update Notion page?                    → Notion MCP Server

Analyze 100+ files?                    → Gemini CLI
Interactive coding session?            → Cursor CLI
Autonomous implementation?             → Codex CLI
Slack CLI operations?                  → Slack CLI (auth/manifest only)

Specialized AI task?                   → Claude Code Subagent
Code review?                           → code-reviewer subagent
Write tests?                           → test-writer-fixer subagent
Debug error?                           → error-debugger subagent
Track session lifecycle?               → session-tracker subagent
Validate tool registry?                → tool-registry-manager subagent
Check if tools are working?            → tool-registry-manager subagent

Need implementation guidance?          → Claude Code Skill
Implement session tracking?            → session-tracking skill

Start new project?                     → Spec Kit (specify init)
Enforce TDD?                           → TDD Guard + reporters

Track tool lifecycle?                  → See Tool Lifecycle & Linear Integration
Review tool health (30d)?              → Linear review issue template
```

---

### Common Workflows

#### 1. Slack → Linear → GitHub Flow

```bash
# 1. Monitor Slack for requests
curl https://slack.com/api/conversations.history \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN"

# 2. Create Linear issue (via MCP)
mcp__linear-server__create_issue

# 3. Push code to GitHub (via MCP)
mcp__github__push_files

# 4. Post update to Slack
curl https://slack.com/api/chat.postMessage \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN"
```

#### 2. Spec-Driven Development with TDD

```bash
# 1. Initialize spec-driven project
specify init my-feature --ai claude

# 2. Define spec
/specify "Build authentication with JWT tokens"

# 3. SDD-TDD Orchestrator auto-generates test structure
# (happens automatically)

# 4. TDD Guard enforces test-first
# (blocks implementation without failing tests)

# 5. Implement with TDD cycle
/implement
```

#### 3. Large Codebase Analysis → Fix

```bash
# 1. Analyze with Gemini's massive context
gemini -p "@./ identify security vulnerabilities"

# 2. Create fix plan with subagent
# Use error-debugger subagent via Task tool

# 3. Implement fixes autonomously
codex --full-auto "fix identified security issues"

# 4. Run tests
# Use test-runner subagent

# 5. Post results to Slack
curl https://slack.com/api/chat.postMessage
```

#### 4. Session Tracking Workflow

```bash
# 1. Start a new session
./scripts/session.sh start "Feature Implementation"

# 2. Work on tasks (automatically tracked)
# Session hooks capture activities

# 3. Check session status
./scripts/session.sh status

# 4. Post update to Slack
./scripts/session.sh post --id <session-id>

# 5. End session with notes
./scripts/session.sh stop <session-id> --notes "Feature complete, tests passing"

# 6. Review session history
./scripts/session.sh history --limit 10
```

#### 5. Tool Lifecycle Management

```bash
# 1. Propose new tool
./scripts/create-tool-issue.sh "Notion API" "Docs" "Sync Tool Registry to Notion"

# 2. Create Linear issue (via Claude Code)
# Copy output from step 1 and ask Claude to create the Linear issue

# 3. Add to TOOL-REGISTRY.md
# Add entry with Proposed status and Linear issue link

# 4. Triage phase
mcp__linear-server__update_issue id="SLHQ-XXX" state="Triage"
# Assign owner, review scopes, security check

# 5. Staging tests
# Test in dev/staging environment
# Document test results in Linear

# 6. Production deployment
mcp__linear-server__update_issue id="SLHQ-XXX" state="Done"
# Update TOOL-REGISTRY.md status to ✅ Active

# 7. Announce to Council
curl -X POST https://slack.com/api/chat.postMessage \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN" \
  --data @scripts/slack/tool-announcement.json

# 8. Schedule 30-day review
mcp__linear-server__create_issue \
  team="SLHQ" \
  title="Review: Notion API" \
  dueDate="YYYY-MM-DD" \
  labels=["Tool Registry", "Review"]
```

#### 6. Multi-Phase Project Workflow

```bash
# Phase 1: Research with Explore subagent
# Use Task tool with subagent_type=Explore

# Phase 2: Design specification
# Create docs/specs/<feature>.md

# Phase 3: Council communication
# Post announcement to Slack with Block Kit

# Phase 4: Implementation
# Assign phases to agents via Linear

# Phase 5: Testing & rollout
# Use test-runner subagent for validation
```

---

## Environment Variables

Required environment variables for full toolset access:

### Slack
```bash
SLACK_BOT_TOKEN=xoxb-...           # Bot user OAuth token
SLACK_TEAM_ID=T068KC5GURY         # Workspace/team ID
SLACK_CHANNEL_IDS=C123,C456       # Default channel IDs
```

### AI CLI Tools
```bash
GEMINI_API_KEY=AIza...            # Google Gemini API key
CURSOR_MODEL=gpt-5                # Cursor CLI model
CODEX_MODEL=gpt-5                 # Codex CLI model
```

### MCP Servers
MCP server configurations are stored in `.cursor/mcp.json` or equivalent MCP client config.

---

## Notes

### Tool Selection Philosophy

**Local Scripts:** Simple, repeatable automation tasks
**MCP Servers:** Type-safe API operations with error handling
**CLI Tools:** Large-scale analysis and autonomous implementation
**APIs:** Direct access when MCP isn't available
**Subagents:** Specialized expertise with context isolation

### Adding New Tools

When adding new tools to this registry:

1. **Document the tool** in the appropriate section
2. **Explain when to use it** (use cases, decision criteria)
3. **Provide usage examples** (code snippets, commands)
4. **List dependencies** (installation, auth requirements)
5. **Update the Quick Reference** decision tree

## Maintenance Process

### When to Update This Registry

This registry MUST be updated when:
- ✅ New scripts are added to `scripts/`
- ✅ New MCP servers are configured in `.cursor/mcp.json`
- ✅ New Claude Code subagents are created in `.claude/agents/`
- ✅ New Claude Code skills are created in `.claude/skills/`
- ✅ New integrations are established (Slack, Linear, GitHub, etc.)
- ✅ CLI tools are installed, upgraded, or deprecated
- ✅ New documentation suites are created
- ✅ APIs change or new endpoints are used
- ✅ Development tools are added or configured

### Update Process (5 Steps + Verification)

#### Step 1: Identify Changes
```bash
# Check what files have changed
git status

# Review new files in key directories
ls -la scripts/
ls -la .claude/agents/
ls -la .claude/skills/
```

**Document:**
- What was added/changed/removed?
- What problem does it solve?
- When should someone use it?

---

#### Step 2: Update Appropriate Section

**Decision Matrix:**

| What Changed | Update Section | Add To |
|--------------|----------------|--------|
| New script in `scripts/` | Local Scripts | Add entry with usage, requirements, when to use |
| New subagent in `.claude/agents/` | Claude Code Subagents | Add to categorized list + quick reference |
| New skill in `.claude/skills/` | Claude Code Skills | Add full section with contents, capabilities, invocation |
| New MCP server | MCP Servers | Add with capabilities, functions, when to use |
| New CLI tool | CLI Tools | Add with installation, usage, when to use |
| New API usage | APIs | Document endpoints, authentication, examples |
| New workflow pattern | Common Workflows | Add step-by-step workflow example |

---

#### Step 3: Update Cross-References

After adding new content, update these sections:

1. **Table of Contents**
   - Add new section links if major additions
   - Keep alphabetical/logical order

2. **Quick Reference Decision Tree**
   - Add "Need to X?" → "Tool Y" entries
   - Keep concise and action-oriented

3. **Related Documentation**
   - Link to specs, ADRs, runbooks
   - Cross-reference with AGENTS.md, CLAUDE.md

4. **Common Workflows**
   - Add workflow patterns showing tool integration
   - Include real command examples

---

#### Step 4: Update Metadata

```markdown
**Last Updated:** YYYY-MM-DD  # Top of file

**Last Review:** YYYY-MM-DD   # Maintenance section
**Next Review:** When major tooling changes occur

### Recent Updates

**YYYY-MM-DD:**
- ✅ What was added
- ✅ What was changed
- ✅ What was removed
- Impact and rationale
```

---

#### Step 5: Verification Phase ✅

Before committing changes, complete this **mandatory checklist**:

```bash
# Run the verification script
./scripts/verify-tool-registry.sh  # (to be created)

# Or manually verify:
```

**Verification Checklist:**

- [ ] **Completeness Check**
  - [ ] All sections follow the same format
  - [ ] Each tool has: Purpose, Capabilities, Usage, Requirements, When to Use
  - [ ] Code examples are complete and runnable
  - [ ] File paths are absolute and correct

- [ ] **Accuracy Check**
  - [ ] Test at least one command/example from each new entry
  - [ ] Verify file paths exist: `test -f scripts/session.sh && echo "✓"`
  - [ ] Check tool availability: `which gemini && echo "✓"`
  - [ ] Confirm MCP servers are configured: `cat .cursor/mcp.json | jq .`

- [ ] **Consistency Check**
  - [ ] Terminology is consistent (e.g., "subagent" not "sub-agent")
  - [ ] Format matches existing entries (headers, code blocks, bullets)
  - [ ] Cross-references use correct syntax: `[Link Text](path.md)`
  - [ ] Section anchors match Table of Contents

- [ ] **Links Check**
  - [ ] All internal links work: `docs/specs/session-tracking.md`
  - [ ] All cross-references resolve: `AGENTS.md`, `CLAUDE.md`
  - [ ] External links are accessible (test with curl/browser)
  - [ ] GitHub links point to correct repos/branches

- [ ] **Decision Tree Check**
  - [ ] New tools appear in Quick Reference
  - [ ] "Need to X?" entries are action-oriented
  - [ ] Tool recommendations are accurate
  - [ ] No duplicate or conflicting entries

- [ ] **Metadata Check**
  - [ ] Last Updated date is today's date
  - [ ] Recent Updates section has today's entry
  - [ ] Version or review dates updated if applicable
  - [ ] Related Documentation section is current

- [ ] **Readability Check**
  - [ ] No typos or grammatical errors
  - [ ] Technical terms are explained on first use
  - [ ] Examples are clear and practical
  - [ ] "When to Use" guidance is specific and helpful

---

#### Verification Script Template

Create `scripts/verify-tool-registry.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail

echo "🔍 Verifying TOOL-REGISTRY.md..."

# Check file exists
test -f TOOL-REGISTRY.md || { echo "❌ TOOL-REGISTRY.md not found"; exit 1; }

# Check Last Updated is recent (within 30 days)
last_updated=$(grep "Last Updated:" TOOL-REGISTRY.md | head -1 | grep -oE "[0-9]{4}-[0-9]{2}-[0-9]{2}")
days_old=$(( ($(date +%s) - $(date -j -f "%Y-%m-%d" "$last_updated" +%s)) / 86400 ))
if [ "$days_old" -gt 30 ]; then
  echo "⚠️  Last Updated is $days_old days old. Consider reviewing."
fi

# Verify local scripts exist
echo "📝 Checking local scripts..."
grep -oE "scripts/[a-z-]+\.sh" TOOL-REGISTRY.md | sort -u | while read -r script; do
  if [ -f "$script" ]; then
    echo "  ✅ $script"
  else
    echo "  ❌ $script (referenced but missing)"
  fi
done

# Verify agent files exist
echo "🤖 Checking Claude Code agents..."
grep -oE "\.claude/agents/[a-z-]+\.md" TOOL-REGISTRY.md | sort -u | while read -r agent; do
  global_agent="/Users/$(whoami)/$agent"
  if [ -f "$agent" ] || [ -f "$global_agent" ]; then
    echo "  ✅ $(basename "$agent")"
  else
    echo "  ❌ $(basename "$agent") (referenced but missing)"
  fi
done

# Verify skill directories exist
echo "📚 Checking Claude Code skills..."
grep -oE "\.claude/skills/[a-z-]+" TOOL-REGISTRY.md | sort -u | while read -r skill; do
  global_skill="/Users/$(whoami)/$skill"
  if [ -d "$skill" ] || [ -d "$global_skill" ]; then
    echo "  ✅ $(basename "$skill")"
  else
    echo "  ❌ $(basename "$skill") (referenced but missing)"
  fi
done

# Check for broken internal links
echo "🔗 Checking internal documentation links..."
grep -oE "docs/[^)]*\.md" TOOL-REGISTRY.md | sort -u | while read -r doc; do
  if [ -f "$doc" ]; then
    echo "  ✅ $doc"
  else
    echo "  ⚠️  $doc (referenced but missing)"
  fi
done

echo ""
echo "✅ Verification complete! Review any ❌ or ⚠️  items above."
```

Make executable: `chmod +x scripts/verify-tool-registry.sh`

---

### Review Schedule

**Quarterly Review (every 3 months):**
- Audit all entries for accuracy
- Remove deprecated tools
- Update version numbers
- Check all links still work
- Verify examples still run

**Annual Review (yearly):**
- Complete rewrite/restructure if needed
- Major formatting updates
- Consolidate similar tools
- Add metrics (usage data, adoption rates)

**Last Review:** 2025-11-03
**Next Quarterly Review:** 2026-02-03
**Next Annual Review:** 2026-11-03

### Recent Updates

**2025-11-03 (Session Tracking Hooks Proposal):**
- 🟡 **Proposed Session Tracking Hooks** - Automatic session tracking via Claude Code hooks
- ✅ **Created Linear issue SLHQ-17** - Full tool lifecycle tracking initiated
- ✅ **Linked GitHub issue #2** - Session Tracking for Multi-Agent Coordination
- ✅ **Added to Development Tools** section in TOOL-REGISTRY.md
- ✅ **Updated Quick Reference** decision tree with automatic vs manual tracking
- **Status:** Proposed (awaiting triage phase)
- **Risk Level:** Low (reuses existing infrastructure)
- **Estimated Effort:** 3-4 days implementation
- **Benefits:** Automatic, comprehensive, transparent, deterministic, backward compatible

**2025-11-03 (Tool Registry Manager):**
- ✅ **Created tool-registry-manager subagent** (v1.0.0) at `~/.claude/agents/tools/tool-registry-manager.md`
- ✅ **Comprehensive registry management capabilities:**
  - Registry validation (completeness, accuracy, format)
  - Tool availability testing (scripts, CLI, MCP, APIs)
  - Linear lifecycle tracking (Proposed → Active workflow)
  - Documentation quality checks (links, cross-refs, consistency)
  - Health reporting with prioritized recommendations
- ✅ **Added to AGENTS.md** Claude Code Subagents section
- ✅ **Added to TOOL-REGISTRY.md** Tools & Integration category
- ✅ **Updated Quick Reference** decision tree with validation entries
- Enables proactive "validate tool registry" and "check capabilities" requests
- Integrates with Linear for tool proposal → deployment → 30-day review workflow

**2025-11-03 (Earlier):**
- ✅ **Added session-tracker subagent** to Claude Code Subagents section
- ✅ **Added session-tracking skill** - New Claude Code Skills section created
- ✅ **Added session.sh script** to Local Scripts with complete documentation
- Updated Quick Reference decision tree with session tracking entries
- Updated AGENTS.md with session-tracker agent definition (v1.1)
- Documented session lifecycle, JSON schema validation, and Slack integration
- Added process documentation for maintaining tool registry

**2025-01-17:**
- Added Session Tracking Documentation Suite
- 5 new documentation files covering research, specs, guides, and runbooks
- ✅ **Slack announcement successfully posted** to channel C0684S1LTLP @ ts:1762130277.053359
- Updated Quick Reference with session tracking workflow
- Added multi-phase project workflow pattern
- **Verified Slack Web API functionality** - Direct curl method confirmed working
- Updated Slack CLI section to reflect v3.9.0 limitations (removed `api` command)
- Added detailed "What Works / What Doesn't Work" breakdown for Slack integration
- Documented channel ID requirements (not names)

---

## Related Documentation

### Project Guidance
- **CLAUDE.md** - Project-specific AI guidance
- **AGENTS.md** - Claude Code subagent details
- **QUICKSTART.md** - Quick start guide

### Workflow Documentation
- **docs/slack-cli-capabilities.md** - Detailed Slack API reference
- **docs/GITHUB-LINEAR-INTEGRATION.md** - GitHub↔Linear workflows
- **docs/guides/slack-linear-quick-create.md** - Quick-create workflows
- **docs/guides/posting-session-tracking-announcement.md** - Slack posting guide

### Specifications
- **docs/specs/session-tracking.md** - Session tracking technical spec (SLHQ-241)

### Research & Runbooks
- **docs/research/session-tracking-analysis.md** - Session tracking architecture research
- **docs/runbooks/session-tracking-rollout.md** - Session tracking project status
- **docs/runbooks/session-tracking-announcement-record.md** - Announcement completion record
- **docs/runbooks/definition-of-done.md** - Quality checklist

### Architecture Decisions
- **docs/adrs/001-markdown-single-source-of-truth.md** - Markdown SSOT policy
