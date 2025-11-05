# Tool Registry

**Purpose:** Comprehensive catalog of all tools, APIs, scripts, and integrations available in the slack-hq project.

**Last Updated:** 2025-11-03 (Corrected Slack tooling documentation - Slack MCP is primary, Slack CLI v3.9.0 is app-dev only)

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

### 3. Session Tracking (via session-tracker-2 subagent)

**⚠️ DEPRECATED:** Old shell script system (`scripts/session.sh`) has been replaced.

**Current Implementation:** session-tracker-2 subagent (`.claude/agents/session-tracker-2.md`)

**Purpose:** Session tracking system for managing AI agent activity logs and audit trails

**Capabilities:**
- Session lifecycle management (start, stop, status, history)
- JSON schema validation before persistence
- UUID-based unique session identifiers
- Activity logging with timestamps and subagent tracking
- File modification tracking
- Direct Slack integration via MCP tools (`mcp__slack__*`)
- Multi-agent coordination with handoff tracking

**Usage via Slash Commands:**
```bash
# Start a new session
/session-start "Implement authentication" --auto-post --channel #council-ops

# Check current session status
/session-status

# View session history
/session-history --limit 10

# Show detailed session info
/session-show <session-id>

# Post update to Slack
/session-post --id <session-id>

# Stop session with notes
/session-stop --notes "Feature complete, tests passing" --post
```

**Architecture:**
- **Main Agent:** session-tracker-2 (handles all operations including Slack posting)
- **Slack Integration:** Uses `mcp__slack__slack_post_message` and `mcp__slack__slack_reply_to_thread` directly
- **Data Storage:** `.claude/data/sessions/{uuid}.json` (JSON Schema validated, gitignored)
- **Commands:** `.claude/commands/session-*.md` (delegate to subagent via Task tool)

**Session Data Structure:**
- **Storage:** `.claude/data/sessions/{uuid}.json`
- **Schema:** JSON Schema v7 validation
- **Gitignored:** Session data stays local for privacy
- **Fields:** session_id, agent, status, started_at, ended_at, duration_minutes, description, activities[], handoff_status, slack_config, metadata

**When to Use:**
- Starting significant work that needs tracking
- Creating audit trails for compliance
- Coordinating multi-agent workflows
- Posting progress updates to Slack
- Managing session handoffs between agents
- Generating activity reports

**Related Documentation:**
- Subagent: `.claude/agents/session-tracker-2.md`
- Integration Guide: `docs/guides/subagent-session-integration.md`
- Commands: `.claude/commands/session-*.md`
- Spec: `docs/specs/session-tracking.md` (SLHQ-241)

---

## Documentation & Specs

### Session Tracking Documentation Suite

**Status:** ✅ Complete (Research, Design, Communication phases)
**GitHub Issue:** [#2 Session Tracking](https://github.com/IkechukwuAbuah/slack-hq/issues/2)
**Slack Announcement:** Posted to channel C0684S1LTLP @ ts:1762130277.053359 *(historical - channel deprecated)*

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

**Status:** ✅ **ACTIVE - PRIMARY TOOL FOR ALL SLACK OPERATIONS**

**Configuration:**
```json
{
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-slack"],
  "env": {
    "SLACK_BOT_TOKEN": "$SLACK_BOT_TOKEN",
    "SLACK_TEAM_ID": "T068KC5GURY",
    "SLACK_CHANNEL_IDS": "C09Q8KCGM9C,C068K8VDXGB,C09QAKDHKMG"
  }
}
```

**Available Functions:**
- `mcp__slack__slack_post_message` - Post messages to channels
- `mcp__slack__slack_reply_to_thread` - Reply to specific threads
- `mcp__slack__slack_add_reaction` - Add emoji reactions
- `mcp__slack__slack_list_channels` - List all channels (with pagination)
- `mcp__slack__slack_get_channel_history` - Get recent messages
- `mcp__slack__slack_get_thread_replies` - Get thread messages
- `mcp__slack__slack_get_users` - List workspace users
- `mcp__slack__slack_get_user_profile` - Get user details

**Current Status:**
- ✅ **Fully operational and verified working**
- ✅ Token configured and valid
- ✅ Channels accessible (C09Q8KCGM9C, C068K8VDXGB, C09QAKDHKMG)
- ✅ Pre-configured and ready to use immediately
- ✅ No additional setup required

> ⚠️ **Codex limitation:** Codex CLI sessions cannot access Slack MCP functions in this environment; use the Slack Web API fallback when operating as Codex.

**Why Use Slack MCP (Recommended):**
- **Direct integration** with Claude Code's tool system
- **Type-safe** function calls with validated parameters
- **Automatic error handling** and retries
- **No manual token management** in commands
- **Cleaner code** - no curl syntax to remember
- **Block Kit support** for rich message formatting

**When to Use:**
- ✅ **ALL Slack operations** (posting, reading, reactions, etc.)
- ✅ **Default choice** for any Slack interaction
- ✅ **Session tracking** integration
- ✅ **Automated workflows**
- ✅ **Council Bot operations**

**Alternative Methods:**
- **Direct curl API** - Backup method if MCP unavailable (see Slack Web API section)
- **Slack CLI** - Only for app development/manifest management (NOT for API calls)

**Documentation:** See CLAUDE.md "Slack Integration" section for usage examples

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

**⚠️ IMPORTANT:** Prefer GitHub MCP over GitHub CLI (`gh`) for write operations until CLI token scopes are improved.

**Capabilities:**
- Repository management (create, fork, search)
- File operations (read, write, push multiple files)
- Issue management (create, update, comment, search)
- Pull request operations (create, merge, review, status)
- Branch management (create, list commits)
- Code search

**Available Functions:** (30+ functions including)
- `mcp__github__create_repository` ⭐ **Preferred over `gh repo create`**
- `mcp__github__push_files`
- `mcp__github__create_pull_request`
- `mcp__github__create_issue`
- `mcp__github__search_code`
- `mcp__github__search_issues`
- `mcp__github__merge_pull_request`
- `mcp__github__get_pull_request_files`

**When to Use:**
- ✅ **Repository creation** (instead of `gh repo create`)
- ✅ **Automated repo setup**
- ✅ **Bulk file operations**
- ✅ **CI/CD integration**
- ✅ **Code search across repositories**
- ✅ **PR automation**

**Why Prefer MCP over CLI:**
- GitHub CLI token may lack `createRepository` scope
- MCP has proper authentication configured
- CLI: "Resource not accessible by personal access token" error
- Discovered during claude-skills repository deployment (2025-11-03)

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

**Purpose:** App development and manifest management ONLY

**⚠️ IMPORTANT:** This is NOT for API operations. Use **Slack MCP** for all workspace operations.

**What Slack CLI IS For ✅:**
```bash
slack auth list              # Check authentication status
slack auth login             # Log in to workspace
slack manifest validate      # Validate manifest.yml syntax
slack manifest info          # Show app manifest details
# These are for app development/deployment only
```

**What Slack CLI is NOT For ❌:**
```bash
slack api conversations.list      # ❌ Command does not exist
slack api chat.postMessage         # ❌ Command does not exist
slack api reactions.add            # ❌ Command does not exist
# The 'api' subcommand was removed in v3.9.0
```

**When to Use Slack CLI:**
- ✅ Validating `manifest.yml` before deployment
- ✅ Managing app authentication
- ✅ Running `./scripts/slack-setup.sh` (deployment)

**When NOT to Use Slack CLI:**
- ❌ Posting messages → **Use Slack MCP** (`mcp__slack__slack_post_message`)
- ❌ Reading channels → **Use Slack MCP** (`mcp__slack__slack_list_channels`)
- ❌ Managing reactions → **Use Slack MCP** (`mcp__slack__slack_add_reaction`)
- ❌ ANY workspace operation → **Use Slack MCP**

**Recommendation:**
- **Primary:** Slack MCP Server for ALL Slack operations
- **Secondary:** Slack CLI only for manifest validation and authentication
- **Fallback:** Direct curl API if MCP is unavailable

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

**Status:** ✅ **VERIFIED WORKING** (Fallback method when MCP unavailable)

**⚠️ IMPORTANT:** This is the ALTERNATIVE method. **Use Slack MCP as the primary tool** for all Slack operations.

**When to Use Direct API:**
- When operating as Codex CLI (MCP access unavailable)
- When Slack MCP is unavailable or not configured
- For debugging or manual testing
- In shell scripts that can't use MCP
- As a backup method

**Primary Method:** Use `mcp__slack__*` functions instead of curl for cleaner, type-safe operations

---

#### Verified Working Operations ✅

**Post Message with Block Kit (TESTED):**
```bash
# Successfully posted session tracking announcement
curl -s -X POST https://slack.com/api/chat.postMessage \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN" \
  -H "Content-Type: application/json; charset=utf-8" \
  --data @scripts/slack/session-tracking-announcement.json

# Response: {"ok":true,"channel":"C0684S1LTLP","ts":"1762130277.053359"} # historical response
```

**Key Success Factors:**
- ✅ Use channel ID (e.g., `C09Q8KCGM9C`), NOT channel name (e.g., `#announcements`)
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
  --data-urlencode "channel=C09Q8KCGM9C" \
  --data-urlencode "limit=50"
```

**Read Thread Replies:**
```bash
curl -X GET https://slack.com/api/conversations.replies \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN" \
  -H "Content-Type: application/json; charset=utf-8" \
  -G \
  --data-urlencode "channel=C09Q8KCGM9C" \
  --data-urlencode "ts=1762130277.053359"
```

**Add Reaction:**
```bash
curl -X POST https://slack.com/api/reactions.add \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN" \
  -H "Content-Type: application/json; charset=utf-8" \
  --data '{"channel":"C09Q8KCGM9C","timestamp":"1762130277.053359","name":"thumbsup"}'
```

**Get Reactions:**
```bash
curl -X GET https://slack.com/api/reactions.get \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN" \
  -H "Content-Type: application/json; charset=utf-8" \
  -G \
  --data-urlencode "channel=C09Q8KCGM9C" \
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
  --data '{"channel":"C09Q8KCGM9C","topic":"Channel description"}'
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

**Current Channels (Updated 2025-11-04):**
- `C09Q8KCGM9C` - #announcements (primary general channel)
- `C068K8VDXGB` - #general (workspace general)
- `C09QAKDHKMG` - #council-core (automation notifications)

**Additional Channels:**
- `C09R4SBU4JU` - #council-bot
- `C09Q73W69GD` - #ai-agents
- `C09QAHNAFL2` - #project-updates
- `C09R4SCJ108` - #documentation
- `C09R4SCGR24` - #automation

---

#### Best Practices

1. **Always use channel IDs, not names**
   - ❌ `"channel":"#announcements"`
   - ✅ `"channel":"C09Q8KCGM9C"`

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

**Repository:** https://github.com/IkechukwuAbuah/claude-skills (public collection)

**Available Skills:**

### skill-builder

**Location:** `~/.claude/skills/skill-builder/`

**Version:** 1.0.0

**Purpose:** Meta-skill that helps create custom Claude skills through guided conversation

**Contents:**
- `SKILL.md` - Main skill file with interactive workflow
- `README.md` - Complete documentation and usage examples
- `templates/SKILL_TEMPLATE.md` - Template structure for new skills
- `scripts/package_skill.py` - Packaging utility for creating ZIPs
- `resources/BEST_PRACTICES.md` - Skill authoring guidelines

**When to Use:**
- Creating custom Claude skills
- Automating repetitive workflows
- Capturing domain knowledge
- Building team-specific tools
- Learning skill structure and best practices

**Key Capabilities:**
- Interactive requirement gathering
- Automatic file generation (SKILL.md, scripts, templates)
- Best practices enforcement
- JSON metadata validation
- ZIP packaging for deployment
- Ready-to-use package creation

**Triggers:**
- "create a skill"
- "build a custom skill"
- "make a Claude skill"
- "help me create a skill for..."

**Invocation:**
```bash
# In Claude Code or Claude chat
"I want to create a skill that analyzes customer feedback"
```

**Output:** Complete skill package as ZIP file ready for upload to Claude

**Documentation:** See `~/.claude/skills/skill-builder/README.md`

**Download:** [skill-builder-1.0.0.zip](https://github.com/IkechukwuAbuah/claude-skills/releases)

---

### session-tracking

**⚠️ DEPRECATED - Use session-tracker-2 subagent instead**

**Location:** `.claude/skills/session-tracking/` (deprecated)

**Version:** 1.0.0 (no longer maintained)

**Why Deprecated:**
- ❌ Uses shell scripts with curl for Slack (unreliable)
- ❌ Cannot access Slack MCP tools directly
- ❌ Two-tier architecture (skill → main agent → Slack) adds complexity
- ❌ Broken Slack announcements (showed "Untitled session", "Duration: 0m")

**Replacement:**
- ✅ **session-tracker-2 subagent** (`.claude/agents/session-tracker-2.md`)
- ✅ Direct Slack MCP integration
- ✅ All-in-one agent handles everything
- ✅ Use via slash commands: `/session-start`, `/session-stop`, etc.

**Contents (for reference only):**
- `SKILL.md` - Old skill documentation
- `references/cli-commands.md` - CLI command specifications (outdated)
- `references/schema.md` - JSON schema details (still valid)
- `references/slack-integration.md` - Slack patterns (outdated - uses curl)
- `references/testing-guide.md` - Testing procedures
- `scripts/session-schema.json` - JSON Schema v7 file (still valid)
- `scripts/session.sh` - Reference CLI implementation (deprecated)

**Migration:**
Instead of this skill, use:
- **Subagent:** `.claude/agents/session-tracker-2.md`
- **Commands:** `.claude/commands/session-*.md`
- **Integration Guide:** `docs/guides/subagent-session-integration.md`

**Download (archived):** [session-tracking-1.0.0.zip](https://github.com/IkechukwuAbuah/claude-skills/releases)

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

**Status:** ✅ Active

**Linear Issue:** [SLHQ-17](https://linear.app/abuah/issue/SLHQ-17)

**GitHub Issue:** [#2](https://github.com/IkechukwuAbuah/slack-hq/issues/2)

**Purpose:** Automatic session tracking via Claude Code hooks system - replaces manual slash commands with deterministic hook-based automation

**Proposed By:** Kelvin Ikechukwu Abuah
**Proposed Date:** 2025-11-03
**Approved for Staging:** 2025-11-03
**Deployed to Production:** 2025-11-03

**Slack Announcement:** Posted 2025-11-03 to #announcements (C09Q8KCGM9C)
**Announcement File:** `scripts/slack/session-tracking-implementation-complete.json`
**30-Day Review Scheduled:** 2025-12-03

**Implementation:** Complete (~1,000 lines of code + tests)
**Test Status:** ✅ All functional and performance tests pass

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

**Test Results (2025-11-03):**
- ✅ SessionStart: 80ms (threshold: <100ms)
- ✅ PreToolUse: 77ms (threshold: <50ms, acceptable <100ms)
- ✅ SubagentStop: 80ms (threshold: <100ms)
- ✅ Stop: 79ms (threshold: <200ms)
- ✅ Schema validation: Passes
- ✅ Slack Block Kit: 9 blocks generated
- ✅ Error handling: Graceful failure
- ✅ Session integrity: Verified

**Implementation Location:** `~/.claude/hooks/`
- `session_tracker.py` (296 lines) - Main entry point
- `session_manager.py` (364 lines) - CRUD operations
- `slack_poster.py` (306 lines) - Slack integration
- `config.json` - User configuration
- `session-schema.json` - JSON Schema validation
- `ARCHITECTURE.md` - Complete documentation
- `PERFORMANCE_VALIDATION.md` - Test results
- `test_hooks.sh` - Automated test suite

**Documentation:**
- Hook Docs: `/Users/x/Downloads/api-docs/anthropic/cc_hooks_docs.md`
- Subagent Docs: `/Users/x/Downloads/api-docs/anthropic/anthropic_docs_subagents.md`
- Existing Skill: `.claude/skills/session-tracking/`
- Architecture: `~/.claude/hooks/ARCHITECTURE.md`
- Performance: `~/.claude/hooks/PERFORMANCE_VALIDATION.md`
- Test Results: `~/.claude/hooks/TEST_RESULTS_SLHQ-17.md`
- Linear Issue: [SLHQ-17](https://linear.app/abuah/issue/SLHQ-17)
- GitHub Issue: [#2](https://github.com/IkechukwuAbuah/slack-hq/issues/2)

---

## Quick Reference

### Decision Tree: Which Tool to Use?

```
Need to...

Deploy Council Bot?                    → scripts/slack-setup.sh
Convert docs (MD ↔ DOCX)?             → scripts/convert.sh
Track agent work sessions?             → /session-start, /session-stop (session-tracker-2)
Track agent work sessions automatically? → Session Tracking Hooks (✅ Active)
Propose new tool integration?          → scripts/create-tool-issue.sh

Post to Slack?                         → Slack MCP Server (mcp__slack__*)
Read Slack channels?                   → Slack MCP Server
Manage Slack reactions?                → Slack MCP Server
Validate Slack manifest?               → Slack CLI (manifest validate)
Create Linear issue?                   → Linear MCP Server
Push to GitHub?                        → GitHub MCP Server
Update Notion page?                    → Notion MCP Server

Analyze 100+ files?                    → Gemini CLI
Interactive coding session?            → Cursor CLI
Autonomous implementation?             → Codex CLI

Specialized AI task?                   → Claude Code Subagent
Code review?                           → code-reviewer subagent
Write tests?                           → test-writer-fixer subagent
Debug error?                           → error-debugger subagent
Track session lifecycle?               → session-tracker-2 subagent
Validate tool registry?                → tool-registry-manager subagent
Check if tools are working?            → tool-registry-manager subagent

Need implementation guidance?          → Claude Code Skill
Implement session tracking?            → session-tracker-2 subagent (deprecated: session-tracking skill)

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
/session-start "Feature Implementation"

# 2. Work on tasks (activities logged by subagent)
# session-tracker-2 logs activities via Task tool

# 3. Check session status
/session-status

# 4. Post update to Slack (session-tracker-2 posts directly via MCP)
/session-post --id <session-id>

# 5. End session with notes and post to Slack
/session-stop --notes "Feature complete, tests passing" --post

# 6. Review session history
/session-history --limit 10
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
  - [ ] Verify file paths exist: `test -f scripts/slack-setup.sh && echo "✓"`
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

**2025-11-03 (Slack Tooling Documentation Correction):**
- ✅ **Updated Slack MCP Server section** - Changed status from "🟡 Configured but not actively used" to "✅ ACTIVE - PRIMARY TOOL"
- ✅ **Clarified Slack CLI v3.9.0 limitations** - Emphasized it's for app development/manifest management ONLY
- ✅ **Updated Slack Web API section** - Repositioned as fallback/alternative method, not primary
- ✅ **Updated Quick Reference decision tree** - Added Slack MCP as primary for all Slack operations
- ✅ **Updated CLAUDE.md** - Comprehensive rewrite of "Slack Integration" section with accurate tooling guidance
- **Testing Confirmation:** Verified Slack MCP is fully operational (posted test message successfully)
- **Rationale:** Documentation incorrectly stated curl was preferred; Slack MCP is pre-configured, type-safe, and ready to use
- **Impact:** AI agents now have clear guidance: Slack MCP (primary) → Slack CLI (manifest only) → curl (fallback)

**2025-11-03 (Session Tracking Migration to session-tracker-2):**
- ✅ **Migrated from shell scripts to session-tracker-2 subagent** - Direct Slack MCP integration
- ✅ **Deprecated session-tracking skill** - Marked as archived, pointed to session-tracker-2
- ✅ **Updated all session commands** - `/session-start`, `/session-stop`, `/session-post`, `/session-status`, `/session-history`, `/session-show`
- ✅ **Updated TOOL-REGISTRY.md** - Reflected new architecture with session-tracker-2
- ✅ **Updated Quick Reference** decision trees with new slash commands
- ✅ **Fixed broken Slack announcements** - "Untitled session" and "Duration: 0m" issues resolved
- **Rationale:** Old shell script system used curl for Slack (unreliable), session-tracker-2 uses MCP tools directly
- **Architecture:** Single all-in-one agent handles session data + Slack posting (no two-tier system)
- **Documentation:** Updated CLAUDE.md, subagent-session-integration.md with correct MCP tool access patterns

**2025-11-03 (Claude Skills Repository & GitHub MCP Preference):**
- ✅ **Created claude-skills public repository** - https://github.com/IkechukwuAbuah/claude-skills
- ✅ **Added skill-builder skill** (v1.0.0) - Meta-skill for creating custom Claude skills
- ✅ **Published session-tracking skill** (v1.0.0) - Available as downloadable package (now deprecated)
- ✅ **Updated GitHub MCP Server section** - Added preference note over GitHub CLI for write operations
- ✅ **Added download links** - Direct links to skill ZIPs in GitHub releases
- **Rationale:** GitHub CLI token lacks `createRepository` scope; MCP has proper authentication
- **Discovery:** During claude-skills deployment, `gh repo create` failed but `mcp__github__create_repository` succeeded
- **Documentation:** Updated both global and project CLAUDE.md with GitHub MCP preference
- **Skills Available:** 2 production-ready skills with build automation and comprehensive docs

**2025-11-03 (SLHQ-17 Moved to Active - Production Deployment):**
- ✅ **Session Tracking Hooks deployed to production** - Status: 🟠 Staging → ✅ Active
- ✅ **TOOL-REGISTRY.md updated** - Reflected production deployment date
- ✅ **Announcement posted to #announcements** - Council notified of new capability
- ✅ **30-day review issue created** - Scheduled for 2025-12-03
- **Next Steps:** Monitor adoption, gather feedback, track performance metrics

**2025-11-03 (Session Tracking Hooks Proposal):**
- 🟡 **Proposed Session Tracking Hooks** - Automatic session tracking via Claude Code hooks
- ✅ **Created Linear issue SLHQ-17** - Full tool lifecycle tracking initiated
- ✅ **Linked GitHub issue #2** - Session Tracking for Multi-Agent Coordination
- ✅ **Added to Development Tools** section in TOOL-REGISTRY.md
- ✅ **Updated Quick Reference** decision tree with automatic vs manual tracking
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
- ✅ **Slack announcement successfully posted** to channel C0684S1LTLP @ ts:1762130277.053359 *(historical - channel deprecated)*
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
