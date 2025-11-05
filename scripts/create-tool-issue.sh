#!/usr/bin/env bash
# Create Linear issue for tool proposal
# Usage: ./scripts/create-tool-issue.sh "Tool Name" "Category" "Description"

set -euo pipefail

TOOL_NAME="${1:-}"
CATEGORY="${2:-Other}"
DESCRIPTION="${3:-}"

if [ -z "$TOOL_NAME" ]; then
  cat <<EOF
Usage: $0 "Tool Name" "Category" "Description"

Categories: Messaging, Docs, DevOps, Data, AI-Agent, Payments, Other

Example:
  $0 "Notion API" "Docs" "Sync Tool Registry to Notion workspace"

This script generates a Linear issue template. Copy the output and ask Claude Code to:
"Create a Linear issue with the following details: [paste output]"
EOF
  exit 1
fi

# Convert tool name to slug (lowercase, hyphenated)
TOOL_SLUG=$(echo "$TOOL_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | sed 's/[^a-z0-9-]//g')

# Generate Linear issue creation command
cat <<EOF

===============================================================================
LINEAR ISSUE TEMPLATE: ${TOOL_NAME}
===============================================================================

Copy the following and ask Claude Code to create the Linear issue:

---

Create a Linear issue in the SLHQ team with these details:

Title: Tool Registry: ${TOOL_NAME}

Team: SLHQ

Project: Slack-HQ Foundation & Setup

Labels: ["Tool Registry", "Infrastructure"]

Priority: Medium

Description:

## Tool Information

**Tool Name:** ${TOOL_NAME}
**Tool ID:** ${TOOL_SLUG}
**Category:** ${CATEGORY}
**Status:** Proposed
**Proposed By:** $(whoami)
**Proposed Date:** $(date +%Y-%m-%d)

**Description:** ${DESCRIPTION:-[To be documented]}

## Use Cases

1. [Use case 1 - to be documented]
2. [Use case 2 - to be documented]
3. [Use case 3 - to be documented]

## Proposed Capabilities

- [ ] Capability 1 - [to be documented]
- [ ] Capability 2 - [to be documented]
- [ ] Capability 3 - [to be documented]

## Security & Compliance

**Auth Method:** [OAuth / Bot Token / API Key / Service Account / SSO]

**Scopes/Permissions:**
- [To be documented]

**Secret Storage:** 1Password://vault/council/${TOOL_SLUG}

**Risk Level:** [Low / Medium / High]
**Data Classification:** [Public / Internal / Confidential / Restricted]

**Security Concerns:**
- [To be documented]

**Data Retention:** [Policy to be defined]
**Audit Trail:** [To be documented]

## Implementation Checklist

### Triage Phase
- [ ] Owner assigned
- [ ] Backup Owner assigned
- [ ] Security review completed (if needed)
- [ ] OAuth scopes approved
- [ ] Cost analysis (if paid service)
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
- [ ] Council Bot updated (if Slack integration)
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

- **Registry Entry:** [TOOL-REGISTRY.md#${TOOL_SLUG}](../TOOL-REGISTRY.md#${TOOL_SLUG})
- **Runbook:** [To be created]
- **Test Plan:** [To be created]
- **Slack Announcement:** [Link after posted]

## Estimated Effort

[X days/weeks - to be determined during triage]

## Notes

[Any additional context, decisions, or dependencies]

---

===============================================================================
NEXT STEPS
===============================================================================

1. Copy the Linear issue description above

2. In Claude Code, run:
   "Create a Linear issue with the above details"

3. Claude will use the Linear MCP to create the issue and return the issue ID

4. Add the issue to TOOL-REGISTRY.md:

   ### ${TOOL_SLUG} (${TOOL_NAME})

   **Status:** 🟡 Proposed

   **Purpose:** ${DESCRIPTION:-One-line description}

   **Proposed By:** $(whoami)
   **Proposed Date:** $(date +%Y-%m-%d)

   **Linear Issue:** [SLHQ-XXX](https://linear.app/abuah/issue/SLHQ-XXX)

   **Use Cases:**
   - [To be documented]

   **Capabilities:**
   - [To be documented]

   **Dependencies:**
   - [To be documented]

   **Risk Assessment:**
   - **Risk Level:** [Low/Medium/High]
   - **Data Classification:** [Public/Internal/Confidential/Restricted]

5. Commit to git:
   git add TOOL-REGISTRY.md
   git commit -m "feat(tools): propose ${TOOL_NAME} integration"

6. Start triage phase in Linear

===============================================================================

EOF
