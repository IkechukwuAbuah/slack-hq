# Linear MCP Tools & Linear Bot Reference

Complete reference for using Linear's Model Context Protocol (MCP) tools and the linear-bot subagent.

## Table of Contents

1. [Overview](#overview)
2. [What is Linear MCP?](#what-is-linear-mcp)
3. [What is linear-bot?](#what-is-linear-bot)
4. [Authentication & Setup](#authentication--setup)
5. [Issue Management Tools](#issue-management-tools)
6. [Team & Project Tools](#team--project-tools)
7. [User & Cycle Tools](#user--cycle-tools)
8. [Label Management Tools](#label-management-tools)
9. [Common Workflows](#common-workflows)
10. [Error Handling](#error-handling)
11. [Rate Limiting](#rate-limiting)
12. [Examples & Patterns](#examples--patterns)

---

## Overview

The Linear integration provides two complementary ways to work with Linear:

| Tool | Best For | Access | Speed |
|------|----------|--------|-------|
| **Linear MCP** | Direct API access, automation, scripting | Python, Bash, CLI | Fast, low-level |
| **linear-bot** | High-level tasks, coordination, human language | Claude Code, conversations | Medium, high-level |

---

## What is Linear MCP?

Linear MCP (Model Context Protocol) is a standardized interface for AI tools to access Linear's API programmatically.

### Why Use Linear MCP?

- ✅ Direct API access without wrapper layers
- ✅ All Linear API features available
- ✅ Fast and efficient
- ✅ Integrates with Claude Code subagents
- ✅ Scriptable and automatable
- ✅ Full error information and debugging

### MCP vs Direct API

| Aspect | Linear MCP | Direct API |
|--------|-----------|-----------|
| Authentication | Automatic via Claude Code | Manual token handling |
| Error Handling | Built-in error messages | Manual parsing |
| Integration | Native Claude Code tools | External scripts |
| Learning Curve | Lower (function names) | Higher (REST, JSON) |

---

## What is linear-bot?

The `linear-bot` is a specialized Claude Code subagent that wraps Linear MCP tools with high-level task understanding.

### linear-bot Capabilities

The linear-bot can:

- ✅ Create issues from natural language descriptions
- ✅ Update issues with smart property mapping
- ✅ List and filter issues intelligently
- ✅ Add comments and collaborate
- ✅ Manage labels and statuses
- ✅ Query teams, projects, and cycles
- ✅ Coordinate multi-step workflows
- ✅ Explain Linear concepts

### When to Use linear-bot

Use linear-bot when you:
- Need to create/update multiple issues
- Want high-level task understanding
- Prefer conversation over raw API
- Need workflow orchestration
- Want error handling and retries

### When to Use Linear MCP Directly

Use Linear MCP directly when you:
- Need precise control over API calls
- Building automation scripts
- Want lowest latency
- Need advanced filtering
- Scripting complex workflows

---

## Authentication & Setup

### Linear MCP Authentication

Linear MCP uses API token authentication through Claude Code:

```bash
# Linear API Token is stored in .env
# File: /Users/x/Downloads/slack-hq/.env
LINEAR_API_KEY="lin_api_xxxxxxxxxxxxxxxxxxxxx"

# Verify authentication
echo $LINEAR_API_KEY | wc -c  # Should be > 20 characters
```

### Checking Your Setup

```bash
# Check Linear MCP is available
# In Claude Code, these tools should be available:
mcp__linear-server__list_teams
mcp__linear-server__list_issues
mcp__linear-server__create_issue
# ... etc
```

### Using with linear-bot

The linear-bot subagent handles authentication automatically:

```bash
# In Claude Code:
Task(
  subagent_type="linear-bot",
  prompt="Create a bug issue in SLHQ team"
)

# linear-bot automatically:
# 1. Authenticates using stored token
# 2. Formats API calls correctly
# 3. Handles errors gracefully
# 4. Returns human-readable results
```

---

## Issue Management Tools

### List Issues

**Tool**: `mcp__linear-server__list_issues`

**Purpose**: Query and filter issues in the workspace

**Parameters**:
```
team (optional)        - Team name or ID (e.g., "SLHQ")
assignee (optional)    - Assignee filter (User ID, name, email, or "me")
cycle (optional)       - Cycle name or ID
label (optional)       - Label name or ID
state (optional)       - State name or ID (e.g., "In Progress")
query (optional)       - Full-text search in title/description
limit (optional)       - Number of results (max 250, default 50)
orderBy (optional)     - Sort field (createdAt or updatedAt)
direction (optional)   - Sort direction (asc or desc)
```

**Examples**:

```bash
# List all open issues in SLHQ team
mcp__linear-server__list_issues(
  team: "SLHQ",
  state: "In Progress",
  limit: 50
)

# List my assigned issues
mcp__linear-server__list_issues(
  assignee: "me",
  state: "In Progress"
)

# List issues with specific label
mcp__linear-server__list_issues(
  team: "SLHQ",
  label: "Feature"
)

# Search for issues
mcp__linear-server__list_issues(
  team: "SLHQ",
  query: "authentication"
)

# List completed issues
mcp__linear-server__list_issues(
  team: "SLHQ",
  state: "Done",
  orderBy: "updatedAt",
  direction: "desc",
  limit: 20
)
```

### Get Issue Details

**Tool**: `mcp__linear-server__get_issue`

**Purpose**: Get detailed information about a specific issue

**Parameters**:
```
id (required)  - Issue ID (e.g., "SLHQ-15")
```

**Returns**: Full issue object with all properties

**Examples**:

```bash
# Get specific issue
mcp__linear-server__get_issue(
  id: "SLHQ-15"
)

# Result includes:
# - ID, title, description
# - Status, assignee, priority
# - All labels
# - Created/updated timestamps
# - Git integration (branch name, commits)
# - Linked issues and PRs
```

### Create Issue

**Tool**: `mcp__linear-server__create_issue`

**Purpose**: Create a new issue in Linear

**Parameters**:
```
title (required)       - Issue title
team (required)        - Team name or ID (e.g., "SLHQ")
description (optional) - Issue description (Markdown supported)
labels (optional)      - Array of label names or IDs
assignee (optional)    - Assignee name, email, ID, or "me"
cycle (optional)       - Cycle name, number, or ID
dueDate (optional)     - Due date in ISO format (YYYY-MM-DD)
priority (optional)    - Priority (0=None, 1=Urgent, 2=High, 3=Normal, 4=Low)
state (optional)       - Initial state name or ID
project (optional)     - Project name or ID
parentId (optional)    - Parent issue ID (for sub-issues)
links (optional)       - Array of link objects {url, title}
```

**Examples**:

```bash
# Create simple feature
mcp__linear-server__create_issue(
  title: "Implement user authentication",
  team: "SLHQ",
  description: "Add JWT-based authentication to API"
)

# Create detailed issue with all properties
mcp__linear-server__create_issue(
  title: "Fix API timeout on large requests",
  team: "SLHQ",
  description: "## Problem\nAPI returns 504 on large requests\n\n## Steps to Reproduce\n1. Send 10MB request\n2. Wait 30 seconds",
  labels: ["Bug", "ai:cursor", "Engineering Team"],
  assignee: "me",
  priority: 2,
  dueDate: "2025-11-10",
  links: [
    {url: "https://github.com/IkechukwuAbuah/slack-hq/issues/42", title: "GitHub Issue"}
  ]
)

# Create sub-issue
mcp__linear-server__create_issue(
  title: "Write unit tests for auth module",
  team: "SLHQ",
  parentId: "SLHQ-15",
  labels: ["Feature", "Phase 3.2 - TDD Tests"]
)
```

### Update Issue

**Tool**: `mcp__linear-server__update_issue`

**Purpose**: Update properties of an existing issue

**Parameters**:
```
id (required)          - Issue ID (e.g., "SLHQ-15")
title (optional)       - New title
description (optional) - New description
state (optional)       - New state name or ID
assignee (optional)    - New assignee
labels (optional)      - Replace all labels with this array
priority (optional)    - New priority (0-4)
dueDate (optional)     - New due date (ISO format)
estimate (optional)    - Story point estimate
project (optional)     - Move to project
parentId (optional)    - Change parent issue
links (optional)       - Replace all links
```

**Examples**:

```bash
# Update status
mcp__linear-server__update_issue(
  id: "SLHQ-15",
  state: "In Review"
)

# Update assignee
mcp__linear-server__update_issue(
  id: "SLHQ-15",
  assignee: "me"
)

# Update labels (replaces all labels)
mcp__linear-server__update_issue(
  id: "SLHQ-15",
  labels: ["Feature", "ai:claude-code", "Engineering Team", "Phase 3.3"]
)

# Complete update
mcp__linear-server__update_issue(
  id: "SLHQ-15",
  state: "Done",
  priority: 3,
  dueDate: "2025-11-08"
)
```

### Create Comment

**Tool**: `mcp__linear-server__create_comment`

**Purpose**: Add a comment to an issue

**Parameters**:
```
issueId (required)  - Issue ID (e.g., "SLHQ-15")
body (required)     - Comment text (Markdown supported)
parentId (optional) - Parent comment ID (for replies)
```

**Examples**:

```bash
# Add comment
mcp__linear-server__create_comment(
  issueId: "SLHQ-15",
  body: "I've started working on this. The authentication module needs refactoring first."
)

# Add comment with Markdown
mcp__linear-server__create_comment(
  issueId: "SLHQ-15",
  body: "## Progress Update\n\n- [x] Module analysis complete\n- [ ] Tests written\n- [ ] Implementation started"
)

# Reply to comment
mcp__linear-server__create_comment(
  issueId: "SLHQ-15",
  parentId: "comment-id-from-previous",
  body: "Great! Let me know when you need code review."
)
```

### List Comments

**Tool**: `mcp__linear-server__list_comments`

**Purpose**: Get all comments on an issue

**Parameters**:
```
issueId (required)  - Issue ID
```

**Returns**: Array of comment objects

---

## Team & Project Tools

### List Teams

**Tool**: `mcp__linear-server__list_teams`

**Purpose**: List all teams in the workspace

**Parameters**:
```
query (optional)   - Search query for team names
limit (optional)   - Number of results (default 50)
```

**Examples**:

```bash
# List all teams
mcp__linear-server__list_teams()

# Search for specific team
mcp__linear-server__list_teams(
  query: "SLHQ"
)
```

### Get Team Details

**Tool**: `mcp__linear-server__get_team`

**Purpose**: Get detailed information about a specific team

**Parameters**:
```
query (required)  - Team ID, key (SLHQ), or name
```

**Examples**:

```bash
# By team key
mcp__linear-server__get_team(
  query: "SLHQ"
)

# By ID
mcp__linear-server__get_team(
  query: "7a15a4a6-7f83-4ead-8d80-3024d6bb7151"
)

# Returns:
# - Team ID, name, key
# - Icon and description
# - Created/updated timestamps
```

### List Projects

**Tool**: `mcp__linear-server__list_projects`

**Purpose**: List projects in the workspace

**Parameters**:
```
team (optional)      - Filter by team name or ID
state (optional)     - Filter by project state
query (optional)     - Search project names
limit (optional)     - Number of results
```

**Examples**:

```bash
# List projects in SLHQ
mcp__linear-server__list_projects(
  team: "SLHQ"
)

# List active projects
mcp__linear-server__list_projects(
  team: "SLHQ",
  state: "started"
)
```

### Get Project Details

**Tool**: `mcp__linear-server__get_project`

**Purpose**: Get information about a specific project

**Parameters**:
```
query (required)  - Project ID or name
```

**Examples**:

```bash
# By name
mcp__linear-server__get_project(
  query: "Slack-HQ Foundation & Setup"
)

# Returns full project information
```

---

## User & Cycle Tools

### List Users

**Tool**: `mcp__linear-server__list_users`

**Purpose**: List all users in the workspace

**Parameters**:
```
query (optional)  - Search by name or email
```

**Examples**:

```bash
# List all users
mcp__linear-server__list_users()

# Search for user
mcp__linear-server__list_users(
  query: "kelvin"
)
```

### Get User Details

**Tool**: `mcp__linear-server__get_user`

**Purpose**: Get information about a specific user

**Parameters**:
```
query (required)  - User ID, name, email, or "me"
```

**Examples**:

```bash
# Get current user
mcp__linear-server__get_user(
  query: "me"
)

# Get by email
mcp__linear-server__get_user(
  query: "kelvin@abuah.com"
)
```

### List Cycles

**Tool**: `mcp__linear-server__list_cycles`

**Purpose**: List cycles/sprints for a team

**Parameters**:
```
teamId (required)  - Team ID
type (optional)    - "current", "next", "previous", or "all"
```

**Examples**:

```bash
# Get current cycle
mcp__linear-server__list_cycles(
  teamId: "7a15a4a6-7f83-4ead-8d80-3024d6bb7151",
  type: "current"
)

# Get next cycle
mcp__linear-server__list_cycles(
  teamId: "7a15a4a6-7f83-4ead-8d80-3024d6bb7151",
  type: "next"
)
```

---

## Label Management Tools

### List Labels

**Tool**: `mcp__linear-server__list_issue_labels`

**Purpose**: List all labels for a team

**Parameters**:
```
team (optional)  - Team name or ID
name (optional)  - Search by label name
limit (optional) - Number of results
```

**Examples**:

```bash
# List all labels for SLHQ
mcp__linear-server__list_issue_labels(
  team: "SLHQ"
)

# Search for AI labels
mcp__linear-server__list_issue_labels(
  team: "SLHQ",
  name: "ai"
)
```

### Create Label

**Tool**: `mcp__linear-server__create_issue_label`

**Purpose**: Create a new label

**Parameters**:
```
name (required)        - Label name
teamId (required)      - Team ID (not team name)
description (optional) - Label description
color (optional)       - Hex color (e.g., "#FF0000")
```

**Examples**:

```bash
# Create simple label
mcp__linear-server__create_issue_label(
  name: "urgent-fix",
  teamId: "7a15a4a6-7f83-4ead-8d80-3024d6bb7151"
)

# Create label with color and description
mcp__linear-server__create_issue_label(
  name: "ai:claude-code",
  teamId: "7a15a4a6-7f83-4ead-8d80-3024d6bb7151",
  color: "#0066FF",
  description: "Documentation, coordination, markdown specialist"
)
```

---

## Status Management Tools

### List Issue Statuses

**Tool**: `mcp__linear-server__list_issue_statuses`

**Purpose**: List all available states for issues in a team

**Parameters**:
```
team (required)  - Team name or ID
```

**Examples**:

```bash
# Get all states in SLHQ
mcp__linear-server__list_issue_statuses(
  team: "SLHQ"
)

# Returns: Todo, Backlog, In Progress, In Review, Done, Canceled, Duplicate
```

### Get Status Details

**Tool**: `mcp__linear-server__get_issue_status`

**Purpose**: Get information about a specific state

**Parameters**:
```
team (required)  - Team name or ID
id or name       - Status ID or name (at least one required)
```

**Examples**:

```bash
# By name
mcp__linear-server__get_issue_status(
  team: "SLHQ",
  name: "In Progress"
)

# By ID
mcp__linear-server__get_issue_status(
  team: "SLHQ",
  id: "945a5fc9-e101-44e0-b845-7c8365a56ce0"
)
```

---

## Common Workflows

### Workflow 1: Create and Assign Issue

```bash
# Step 1: Create issue
mcp__linear-server__create_issue(
  title: "Implement user registration",
  team: "SLHQ",
  description: "Add user registration with email validation",
  labels: ["Feature", "ai:claude-code", "Engineering Team"]
)

# Result: Returns SLHQ-XX

# Step 2: Assign to yourself
mcp__linear-server__update_issue(
  id: "SLHQ-XX",
  assignee: "me"
)

# Step 3: Move to In Progress
mcp__linear-server__update_issue(
  id: "SLHQ-XX",
  state: "In Progress"
)
```

### Workflow 2: Update Multiple Issues

```bash
# Find all issues to update
issues = mcp__linear-server__list_issues(
  team: "SLHQ",
  label: "outdated-docs"
)

# For each issue, update
for issue in issues:
  mcp__linear-server__update_issue(
    id: issue.id,
    labels: ["Documentation", "Phase 3.3"],
    state: "Todo"
  )
```

### Workflow 3: Close Issue with Comment

```bash
# Add comment
mcp__linear-server__create_comment(
  issueId: "SLHQ-15",
  body: "Completed! Tests passing and deployed to staging."
)

# Close issue
mcp__linear-server__update_issue(
  id: "SLHQ-15",
  state: "Done"
)
```

### Workflow 4: Coordination with linear-bot

```bash
# Using linear-bot for high-level coordination
Task(
  subagent_type="linear-bot",
  prompt: "
    Create 3 sub-issues for SLHQ-15 (User Authentication):
    1. Write unit tests for JWT module
    2. Implement token refresh mechanism
    3. Add rate limiting for auth endpoints

    Each sub-issue should be labeled with Phase 3.2 (TDD Tests)
    and assigned to engineering team.
  "
)
```

---

## Error Handling

### Common Errors

**Authentication Error**:
```
Error: Invalid or expired Linear API token
Solution: Check LINEAR_API_KEY in .env file
```

**Team Not Found**:
```
Error: Team 'SLHQ' not found
Solution: Use team ID instead or verify team name spelling
```

**Label Not Found**:
```
Error: Label 'nonexistent' not found
Solution: Check label exists in LINEAR-LABELS-REFERENCE.md
```

**Invalid State Transition**:
```
Error: Cannot transition from 'Done' to 'In Progress'
Solution: Check workflow state diagram in LINEAR-ONBOARDING.md
```

### Error Response Format

```json
{
  "status": "error",
  "message": "Descriptive error message",
  "code": "ERROR_CODE",
  "details": {
    "field": "problematic field",
    "reason": "why it failed"
  }
}
```

---

## Rate Limiting

### Linear API Rate Limits

Linear applies rate limiting to protect the service:

- **Requests per minute**: 60
- **Requests per hour**: 1000
- **Burst limit**: 10 requests per second

### Handling Rate Limits

If you exceed rate limits:

```python
# Exponential backoff strategy
delay = 1
for attempt in range(3):
  try:
    response = api_call()
    break
  except RateLimitError:
    sleep(delay)
    delay *= 2  # 1s, 2s, 4s
```

### Best Practices

- ✅ Use `limit` parameter to reduce results
- ✅ Batch operations when possible
- ✅ Cache frequently accessed data
- ✅ Use filters to narrow results
- ✅ Implement exponential backoff

---

## Examples & Patterns

### Pattern 1: Issue Batch Update

```bash
# Update all Issues assigned to me
tasks = mcp__linear-server__list_issues(
  assignee: "me",
  state: "In Progress"
)

# Process each issue
for task in tasks:
  mcp__linear-server__update_issue(
    id: task.id,
    # Only update if certain conditions met
  )
```

### Pattern 2: Automated Issue Creation

```bash
# Create issues from structured data
issues_to_create = [
  {
    "title": "Frontend setup",
    "labels": ["Feature", "Phase 3.1"],
  },
  {
    "title": "Backend API",
    "labels": ["Feature", "Phase 3.1"],
  },
]

for issue_data in issues_to_create:
  mcp__linear-server__create_issue(
    title: issue_data["title"],
    team: "SLHQ",
    labels: issue_data["labels"]
  )
```

### Pattern 3: Issue Status Reporter

```bash
# Report on all issues
all_issues = mcp__linear-server__list_issues(
  team: "SLHQ"
)

# Group by status and count
statuses = {}
for issue in all_issues:
  state = issue.state.name
  statuses[state] = statuses.get(state, 0) + 1

# Print report
for state, count in statuses.items():
  print(f"{state}: {count} issues")
```

---

## Resources

### Related Documentation
- [LINEAR-ONBOARDING.md](./LINEAR-ONBOARDING.md) - Full onboarding guide
- [LINEAR-LABELS-REFERENCE.md](./LINEAR-LABELS-REFERENCE.md) - Complete label reference
- [TOOL-REGISTRY.md](../TOOL-REGISTRY.md) - Overall tools reference

### External Links
- [Linear API Docs](https://developers.linear.app/) - Official Linear API documentation
- [MCP Specification](https://modelcontextprotocol.io/) - MCP protocol details

### Getting Help

- **Documentation**: Check guides above
- **Slack**: Post in #council-core
- **Issues**: Create with label "question" or "help-needed"

---

## Document Information

- **Last Updated**: November 5, 2025
- **Version**: 1.0
- **Maintained By**: Kelvin Abuah & Council Team
- **Status**: Active & Maintained

For MCP/linear-bot questions, create an issue in Linear with label "question" and tag @ai:claude-code.
