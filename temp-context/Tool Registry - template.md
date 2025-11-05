# Tool Registry — Standard Template

> Single source of truth for all integrations connected to the Council HQ.

## Properties (create these columns in the database)
- **Tool Name** (Title)
- **Tool ID** (Formula → slugify Tool Name; use: `lower(replaceAll(replaceAll(prop("Tool Name"), " ", "-"), "[^a-zA-Z0-9-]", ""))`)
- **Category** (Select: Messaging, Docs, DevOps, Data, AI-Agent, Payments, Other)
- **Workspace / Tenant** (Select)
- **Environment** (Multi-select: Dev, Staging, Prod)
- **Owner** (Person)
- **Backup Owner** (Person)
- **Status** (Select: Draft, Proposed, Active, Limited, Deprecated)
- **Risk Level** (Select: Low, Medium, High)
- **Data Classification** (Select: Public, Internal, Confidential, Restricted)
- **Auth Method** (Select: OAuth, Bot Token, API Key, Service Account, SSO)
- **Secret Ref** (Text; reference only — secrets live in 1Password/Vault)
- **Capabilities** (Multi-select)
- **Scopes/Permissions** (Text)
- **Targets / Channels / Collections** (Text)
- **Related Agents** (Relation → Agents DB)
- **Runbooks** (Relation → Runbooks DB)
- **ADR / Spec** (Relation → ADRs or Specs DB)
- **Health Check** (Text/URL)
- **Logging / Audit Trail** (Text)
- **Last Verified** (Date)
- **Next Review** (Formula: `dateAdd(prop("Last Verified"), 30, "days")`)
- **Change Log** (Relation → Registry Changes DB)

---

## Standard Tool Record (copy inside each record page)

### Overview
- Purpose
- Where it’s used in the Council

### Capabilities & Limits
- What it can do today
- What is planned

### Scopes & Access
- Exact scopes
- Link to approval ticket (if any)

### Configuration Spec (JSON)
```json
{
  "name": "<tool name>",
  "workspace": "<tenant>",
  "env": ["Prod"],
  "capabilities": ["<cap1>", "<cap2>"],
  "scopes": ["<scope1>", "<scope2>"],
  "targets": {
    "channels": ["#example"],
    "databases": ["Tool Registry"]
  },
  "health_check": "<how to validate>",
  "secret_ref": "1Password://vault/<path>"
}
```

### Operational Runbook
- Install / upgrade / rollback

### Test Plan
- Connection
- Permission checks
- Failure simulation

### Security Notes
- Data classification
- Retention
- Logging

### Change History
- Link to “Registry Changes” entries

---

## Quick Intake (pin this in #council-core)
1. **Proposal** → add a new row in Tool Registry
2. **Triage** → set Owner/Backup + review scopes
3. **Staging Test** → execute runbook & test plan
4. **Production Deploy** → mark **Active**
5. **Announce** → link the record in #council-core
6. **Schedule Review** → `Next Review` auto-calculates

---

## Seed Entries Included (CSV)
- Slack Connector (Active; 2ndBrainWorld Slack)
- Notion API (Proposed; EFL Notion)
- Linear (Proposed; VPC Linear)
- GitHub (Proposed; Council GitHub Org)
- Loconav (Proposed; VPC — Restricted)
- Vercel (Proposed; Council Apps)

**Imported on:** 2025-11-03
