The first 12 tasks (pre-scoped, so you can paste them into Linear now)

SLHQ-1 – Create GitHub repo and push local slack-hq

Deliverables: repo live; README stub with SSOT rules.

Acceptance: URL pinned in Slack; repo linked in Linear.

SLHQ-2 – Add repo structure + templates

Deliverables: /docs, /agents, /artifacts, /scripts/convert.sh, templates.

Acceptance: tree matches structure above.

SLHQ-3 – Configure Linear (team, workflow, labels, fields)

Deliverables: team SLHQ, states, labels, custom fields.

Acceptance: can create a task with all fields; appears in Slack.

SLHQ-4 – Enable Linear ↔ GitHub + Slack

Deliverables: integrations installed; notifications scoped to project.

Acceptance: state changes post to #council-core; PRs link back to issues.

SLHQ-5 – Notion DB: “Slack‑HQ Docs”

Deliverables: DB with properties and templates.

Acceptance: new Spec/ADR from template; relation to a test Linear issue.

SLHQ-6 – Define agents registry

Deliverables: /agents/agents.md with roles, triggers, handoff rules.

Acceptance: contains “Claude = md”, “ChatGPT = docx/pdf”, conversion path.

SLHQ-7 – LLM output contracts

Deliverables: /agents/claude.md and (optional) /agents/chatgpt.md.

Acceptance: both reference Linear ID–first filenames and acceptance rules.

SLHQ-8 – Pandoc conversion pipeline

Deliverables: scripts/convert.sh with md↔docx wrappers and examples.

Acceptance: run script on sample files in /artifacts.

SLHQ-9 – Issue hygiene guardrails

Deliverables: label set + saved views in Linear (By Owner, By Area, Blocked).

Acceptance: dashboards exist; “Blocked > 24h” view is shareable.

SLHQ-10 – First ADR: SSOT + formats

Deliverables: ADR in Notion + /docs/adr/000-ssot-formats.md.

Acceptance: linked from README; supersedes any conflicting habits.

SLHQ-11 – Slack quick‑create flow

Deliverables: documented /linear create quick guide pinned in #council-core.

Acceptance: anyone can spawn SLHQ-* from a thread in under 30 seconds.

SLHQ-12 – Definition of Done

Deliverables: DoD in /docs/runbooks/dod.md.

Acceptance: checkbox list appears in Linear template and PR template.

Opinionated callouts (to prevent slow bleed)

One backlog. Don’t mirror tasks in Notion or GitHub Projects. Link, don’t duplicate.

Markdown is canonical. Convert for sharing, not for storage. PDFs are dead text; only generate when sending outside.

Every artifact must map to a task. If it doesn’t justify an issue, it’s probably not worth producing.

Automations later, not first. Stand up the bones, then wire automations (n8n/Zapier) to mirror status into Notion views if you still need that.