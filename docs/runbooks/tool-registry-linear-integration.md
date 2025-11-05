# Runbook: Tool Registry → Linear Integration

**Purpose:** Document the workflow for proposing, tracking, and deploying new tools in the slack-hq ecosystem using Linear for project management.

**Last Updated:** 2025-11-03

---

## Overview

This runbook establishes a structured process for managing tool proposals from ideation through deployment. The workflow ensures:

- **Single Source of Truth:** TOOL-REGISTRY.md is canonical; Notion is secondary
- **Traceability:** Every tool has a Linear issue tracking its lifecycle
- **Governance:** Clear stages with approval gates
- **Visibility:** The Council can see tool status in Linear

---

## Workflow States

```
Proposed → Triage → Staging Test → Production Deploy → Announced → Review (30d)
   ↓          ↓           ↓                ↓              ↓          ↓
 Draft    Active      Testing         Active         Active    Active
(Linear) (Linear)    (Linear)        (Linear)       (Linear)  (Linear)
```

### State Definitions

| State | Description | Linear Status | Owner Action |
|-------|-------------|---------------|--------------|
| **Proposed** | Tool identified, needs evaluation | Draft | Document use case, capabilities |
| **Triage** | Reviewing scopes, security, cost | Triage | Assign owner/backup, review scopes |
| **Staging Test** | Testing in non-prod environment | In Progress | Execute runbook & test plan |
| **Production Deploy** | Tool is live and operational | Done | Mark Active in registry |
| **Announced** | Council notified via Slack | Done | Post to #council-core |
| **Review (30d)** | Scheduled maintenance check | Backlog | Health check + audit |

---

## Process: Adding a New Tool

### Step 1: Proposal (Draft)

**Add entry to TOOL-REGISTRY.md:**

```markdown
### [Tool ID] Tool Name

**Status:** 🟡 Proposed

**Purpose:** One-line description of what this tool does

**Proposed By:** Your Name

**Use Cases:**
- Use case 1
- Use case 2

**Capabilities:**
- Feature 1
- Feature 2

**Dependencies:**
- Required tokens/auth
- Installation requirements

**Risk Assessment:**
- **Risk Level:** Low/Medium/High
- **Data Classification:** Public/Internal/Confidential/Restricted
- **Security Concerns:** Any potential issues

**Estimated Effort:** X days/weeks

**Linear Issue:** [SLHQ-XXX](https://linear.app/abuah/issue/SLHQ-XXX)
```

**Create Linear Issue:**

Use the script below or create manually.

---

### Step 2: Triage (Active)

**Linear Task Checklist:**
- [ ] Owner and Backup Owner assigned
- [ ] Security review completed (if High/Restricted)
- [ ] OAuth scopes/permissions documented
- [ ] Cost analysis (if paid service)
- [ ] Integration points identified
- [ ] Conflicts with existing tools checked
- [ ] Test plan drafted

**Update TOOL-REGISTRY.md:**
```markdown
**Status:** 🟡 In Triage

**Owner:** Name
**Backup Owner:** Name
**Scopes/Permissions:** List exact scopes
**Secret Storage:** 1Password path
```

---

### Step 3: Staging Test (In Progress)

**Linear Task Checklist:**
- [ ] Test environment configured
- [ ] Credentials generated (dev/staging)
- [ ] Test plan executed
- [ ] Health check validated
- [ ] Error handling tested
- [ ] Documentation complete

**Create Test Runbook:**
```markdown
## Test Plan: [Tool Name]

### Setup
1. Install dependencies
2. Configure environment variables
3. Initialize credentials

### Connection Test
[Commands to verify connectivity]

### Permission Checks
[Verify each scope works]

### Failure Simulation
[Test error handling]

### Success Criteria
- [ ] All test cases pass
- [ ] No security warnings
- [ ] Performance acceptable
```

---

### Step 4: Production Deploy (Done)

**Pre-Deployment Checklist:**
- [ ] All staging tests passed
- [ ] Production credentials stored in 1Password
- [ ] Council Bot scopes updated (if Slack)
- [ ] Runbook reviewed and approved
- [ ] Rollback plan documented

**Update TOOL-REGISTRY.md:**
```markdown
**Status:** ✅ Active

**Environment:** Prod
**Deployed:** YYYY-MM-DD
**Health Check:** [URL or command]
**Logging:** Where to find logs
```

**Update Linear Issue:**
- Move to "Done" status
- Add deployment notes
- Link to production endpoints
- Document any issues encountered

---

### Step 5: Announce (Done)

**Post to Slack (#council-core):**

```json
{
  "channel": "C09Q8KCGM9C",
  "blocks": [
    {
      "type": "header",
      "text": {
        "type": "plain_text",
        "text": "🚀 New Tool Deployed: [Tool Name]"
      }
    },
    {
      "type": "section",
      "text": {
        "type": "mrkdwn",
        "text": "*What:* Brief description\n*Use Cases:* List 2-3 key capabilities\n*Access:* How agents can use it\n*Docs:* Link to TOOL-REGISTRY.md section"
      }
    },
    {
      "type": "section",
      "text": {
        "type": "mrkdwn",
        "text": "*Owner:* @owner | *Linear:* <https://linear.app/abuah/issue/SLHQ-XXX|SLHQ-XXX>"
      }
    }
  ]
}
```

**Command:**
```bash
curl -s -X POST https://slack.com/api/chat.postMessage \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN" \
  -H "Content-Type: application/json; charset=utf-8" \
  --data @scripts/slack/tool-announcement.json
```

---

### Step 6: Schedule Review (Backlog)

**Set Next Review Date:** 30 days from deployment

**Linear Task:**
- Create follow-up issue: "Tool Review: [Tool Name]"
- Due date: 30 days
- Assignee: Original owner
- Template checklist below

---

## Automation Script

### Create Linear Issue from Tool Proposal

**Location:** `scripts/create-tool-issue.sh`

```bash
#!/usr/bin/env bash
# Create Linear issue for tool proposal
# Usage: ./scripts/create-tool-issue.sh "Tool Name" "Description"

set -euo pipefail

TOOL_NAME="${1:-}"
DESCRIPTION="${2:-}"

if [ -z "$TOOL_NAME" ]; then
  echo "Usage: $0 \"Tool Name\" \"Description\""
  exit 1
fi

# Use Linear MCP to create issue
cat <<EOF
Create Linear issue with the following details:

Title: "Tool Registry: ${TOOL_NAME}"
Team: SLHQ
Project: Slack-HQ Foundation & Setup
Description: ${DESCRIPTION}

Capabilities:
- [To be documented]

Use Cases:
- [To be documented]

Lifecycle Checklist:
- [ ] Proposal documented in TOOL-REGISTRY.md
- [ ] Owner/Backup assigned
- [ ] Security review (if needed)
- [ ] Scopes/permissions documented
- [ ] Staging tests passed
- [ ] Production deployment
- [ ] Slack announcement
- [ ] 30-day review scheduled

Labels: ["Tool Registry", "Infrastructure"]
Priority: Medium (adjust as needed)
EOF
```

---

## Templates

### Linear Issue Template: New Tool Proposal

```markdown
## Tool Information

**Tool Name:** [Name]
**Category:** Messaging / Docs / DevOps / Data / AI-Agent / Payments / Other
**Workspace/Tenant:** [Where it's hosted]
**Risk Level:** Low / Medium / High
**Data Classification:** Public / Internal / Confidential / Restricted

## Use Cases

1. [Use case 1]
2. [Use case 2]
3. [Use case 3]

## Proposed Capabilities

- [ ] Capability 1
- [ ] Capability 2
- [ ] Capability 3

## Security & Compliance

**Auth Method:** OAuth / Bot Token / API Key / Service Account / SSO

**Scopes/Permissions:**
- scope1
- scope2

**Secret Storage:** 1Password://vault/[path]

**Data Retention:** [Policy]

**Audit Trail:** [Where logs live]

## Implementation Checklist

### Triage Phase
- [ ] Owner assigned: ___________
- [ ] Backup Owner assigned: ___________
- [ ] Security review completed
- [ ] OAuth scopes approved
- [ ] Cost analysis (if paid)
- [ ] Integration points identified
- [ ] Test plan documented

### Staging Phase
- [ ] Dev/staging environment setup
- [ ] Credentials generated
- [ ] Connection tests passed
- [ ] Permission checks passed
- [ ] Error handling validated
- [ ] Performance acceptable
- [ ] Documentation complete

### Deploy Phase
- [ ] Production credentials in 1Password
- [ ] Council Bot updated (if Slack)
- [ ] Runbook approved
- [ ] Rollback plan documented
- [ ] Deployment executed
- [ ] Health check validated

### Announce Phase
- [ ] TOOL-REGISTRY.md updated with "Active" status
- [ ] Slack announcement posted to #council-core
- [ ] Documentation linked
- [ ] Team trained/notified

### Review Phase
- [ ] 30-day review issue created
- [ ] Monitoring/alerting configured
- [ ] Success metrics defined

## Links

- **Registry Entry:** [Link to TOOL-REGISTRY.md section]
- **Runbook:** [Link when created]
- **Test Plan:** [Link when created]
- **Slack Announcement:** [Link after posted]

## Notes

[Any additional context, decisions, or issues]
```

---

### Linear Issue Template: 30-Day Tool Review

```markdown
## Review: [Tool Name]

**Deployed:** [YYYY-MM-DD]
**Owner:** [Name]
**Original Issue:** [SLHQ-XXX]

## Health Check

- [ ] Tool is operational and accessible
- [ ] Credentials are valid and not expiring soon
- [ ] No security incidents or vulnerabilities
- [ ] Usage metrics are within expected range
- [ ] Error rates are acceptable
- [ ] Logs are being captured correctly

## Usage Analysis

**Adoption:**
- Number of agents using: ___
- Frequency of use: Daily / Weekly / Monthly / Rarely
- Most common use cases: ___

**Performance:**
- Average response time: ___
- Error rate: ___
- Uptime: ___

## Issues & Incidents

**Since Deployment:**
- [ ] No incidents (skip to Recommendations)
- [ ] Minor issues (document below)
- [ ] Major incidents (document below)

[Document any issues here]

## Feedback

**From The Council:**
- What's working well?
- What needs improvement?
- Any missing features?

## Recommendations

- [ ] Continue as-is (no changes)
- [ ] Expand capabilities
- [ ] Adjust scopes/permissions
- [ ] Deprecate (not meeting needs)
- [ ] Replace with alternative

**Action Items:**
[List any follow-up tasks]

## Next Review

**Schedule:** [30/60/90 days from now]
**Priority:** Low / Medium / High
```

---

## Quick Reference Commands

### Check Tool Status in Linear
```bash
# List all tool-related issues
mcp__linear-server__list_issues team="SLHQ" label="Tool Registry"

# Get specific tool issue
mcp__linear-server__get_issue id="SLHQ-XXX"
```

### Update Tool Status
```bash
# Mark as Active (Production Deploy)
mcp__linear-server__update_issue id="SLHQ-XXX" state="Done"

# Add deployment notes
mcp__linear-server__add_issue_comment \
  issueId="SLHQ-XXX" \
  body="Deployed to production. Health check: ✅"
```

### Create Review Issue
```bash
# 30 days after deployment
mcp__linear-server__create_issue \
  team="SLHQ" \
  title="Review: [Tool Name]" \
  description="[Template from above]" \
  dueDate="YYYY-MM-DD" \
  labels=["Tool Registry", "Review"]
```

---

## Integration with Notion (Secondary)

**Notion Tool Registry is secondary.** The primary source is TOOL-REGISTRY.md.

### Sync Strategy (Optional)

If maintaining Notion database:

1. **One-Way Sync:** TOOL-REGISTRY.md → Notion (not vice versa)
2. **Manual Updates:** Update markdown first, then sync to Notion
3. **Automation:** Consider building sync script if needed

**DO NOT** use Notion as source of truth. Always reference TOOL-REGISTRY.md for canonical state.

---

## Governance

### Who Can Propose Tools?

- **Any Council Member:** Can add proposals to TOOL-REGISTRY.md
- **Tool Owner:** Assigned during Triage phase
- **Backup Owner:** Ensures continuity

### Approval Requirements

| Risk Level | Approver | Review Process |
|------------|----------|----------------|
| **Low** | Tool Owner | Self-review + peer check |
| **Medium** | Tool Owner + Council Lead | Security review + cost analysis |
| **High** | Tool Owner + Council Lead + Security Review | Comprehensive audit + approval ticket |

### Security Reviews

**Required for:**
- High/Restricted data classification
- Broad OAuth scopes (admin, write-all)
- External API integrations
- Financial/payment tools

**Review Checklist:**
- [ ] Data classification appropriate
- [ ] Least-privilege scopes
- [ ] Secrets stored securely (1Password)
- [ ] Audit logging enabled
- [ ] Retention policy defined
- [ ] Incident response plan

---

## Metrics & Success Criteria

### Tool Health Metrics

**Track for each tool:**
- **Uptime:** Target 99.5%+
- **Error Rate:** < 1% of requests
- **Adoption:** % of agents using
- **Usage Frequency:** Calls/day or calls/week
- **Response Time:** p95 latency

### Review Triggers

**Schedule reviews when:**
- [ ] 30 days after deployment (routine)
- [ ] Error rate > 5% for 24h
- [ ] Security vulnerability discovered
- [ ] Major feature changes
- [ ] Low adoption (< 20% after 60 days)
- [ ] Cost exceeds budget

---

## Examples

### Example 1: Adding Notion API

**Step 1: Proposal (TOOL-REGISTRY.md)**
```markdown
### notion-api (Notion API)

**Status:** 🟡 Proposed

**Purpose:** Sync Tool Registry and documentation to Notion

**Linear Issue:** [SLHQ-250](https://linear.app/abuah/issue/SLHQ-250)
```

**Step 2: Create Linear Issue**
```bash
mcp__linear-server__create_issue \
  team="SLHQ" \
  project="Slack-HQ Foundation & Setup" \
  title="Tool Registry: Notion API" \
  description="[Template from above]"
```

**Step 3: Track Progress in Linear**
- Assign owner: Kelvin Abuah
- Add scopes: `databases:read,write; pages:read,write`
- Stage in dev: Test with sandbox workspace
- Deploy to prod: Use EFL Notion workspace
- Announce: Post to #council-core

**Step 4: 30-Day Review**
- Create follow-up issue
- Check adoption, performance, errors
- Gather feedback from agents

---

## Troubleshooting

### Issue: Tool proposal stuck in Triage

**Possible causes:**
- Missing owner assignment
- Unclear use cases
- Security concerns unresolved

**Resolution:**
- Assign owner explicitly
- Document 2-3 concrete use cases
- Complete security review checklist

---

### Issue: Staging tests failing

**Possible causes:**
- Invalid credentials
- Network/firewall blocks
- Insufficient permissions

**Resolution:**
- Verify credentials in 1Password
- Check network access from test env
- Review OAuth scopes, request additional if needed

---

### Issue: Low adoption after deployment

**Possible causes:**
- Poor documentation
- Not solving real problems
- Too complex to use

**Resolution:**
- Improve docs with examples
- Gather feedback from Council
- Create quick-start guide
- Consider deprecation if no improvement

---

## Related Documentation

- **TOOL-REGISTRY.md** - Primary tool catalog (canonical)
- **CLAUDE.md** - Project guidance for AI agents
- **docs/runbooks/definition-of-done.md** - Quality checklist
- **docs/adrs/001-markdown-single-source-of-truth.md** - Markdown SSOT policy

---

## Change Log

**2025-11-03:** Initial runbook created
- Documented 6-stage workflow (Proposal → Review)
- Added Linear integration templates
- Created automation script template
- Defined governance and approval gates
- Established metrics and success criteria
