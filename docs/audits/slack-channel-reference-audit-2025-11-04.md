# Slack Channel Reference Audit — 2025-11-04

## Objective
Validate every Slack channel ID referenced in the repository, replace placeholders or deprecated values, and ensure a single up-to-date source for Council Bot automation.

## Context
- **Reference Type:** Slack channel IDs (The Council workspace)
- **Identifier Pattern:** ``C0[0-9A-Z]{8,}`` (public channel IDs beginning with `C0`)
- **Issue:** Several prompts, scripts, and guides still point to legacy channels (`#2nd-brain`, `#random`) or placeholder IDs (`C0XXXXXXXXX`), which risks misdirected announcements and integration noise.

## Current Valid References
```
C09Q8KCGM9C - #announcements      - General updates and broadcasts
C09QAKDHKMG - #council-core       - Automation and Linear notifications
C09Q761LJUD - #council-ops        - Operational handoffs and deployments
C09Q73W69GD - #ai-agents          - Coordination across agent platforms
C09QAHNAFL2 - #project-updates    - Project milestones and release notes
C09R4SBU4JU - #council-bot        - Council Bot instrumentation
C09R4SCGR24 - #automation         - CI/CD and automation logs
C09R4SCJ108 - #documentation      - Documentation updates
C09QAL92HFC - #engineering        - Engineering workstreams
C09QALF8WD8 - #design-lab         - Design and UX collaboration
C09Q76ULRHB - #docs               - Documentation (alternate canonical)
C09QPHJR517 - #briefings          - Brief status roll-ups
C068K8VDXGB - #general            - Workspace-wide chatter
```

## Deprecated / Historical References
```
C0684S1LTLP - #2nd-brain  - Legacy knowledge-base channel; decommissioned
C0684RPSHCP - #random     - Legacy social channel; superseded by #general guidelines
C09QAM66X8A - #sandbox    - Historical testing channel captured in debugging notes
C09Q763Q56Z - #tracking   - Historical automation feed; not part of current taxonomy
C09Q47USWKV - #reports    - Historical reporting channel retained only in bug report
C09PV6PP0CX - #notion-sync - Historical integration test target
C09PV6BS431 - #product-dev - Historical integration test target
C09QE7EAV6Y - #intros      - Historical onboarding archive
C09QPGVA8BT - #projects    - Historical planning workspace
C09R4UETKNC - #meta        - Historical coordination channel
C0XXXXXXXXX - Placeholder used in templates; must be replaced before execution
```

## Discovery Summary (2025-11-04)
- **Search Command:** `rg -n "C0[0-9A-Z]{8,}"` across repo root
- **Hits:** 162 matches across 24 files
- **Distribution:** Active references concentrated in `CLAUDE.md`, `SLACK-CHANNELS.md`, and `TOOL-REGISTRY.md`. Deprecated IDs primarily appear in runbooks, debugging logs, and prompt templates.

### Validation Matrix
| File | References Found | Status | Action |
|------|------------------|--------|--------|
| docs/guides/linear-integration-announcement.md | `C0XXXXXXXXX` | Active guide | ✅ Updated to `C09QAKDHKMG` (#council-core) |
| scripts/slack/session-tracking-implementation-complete.json | `C0684S1LTLP` | Live Slack payload | ✅ Updated to `C09Q8KCGM9C` (#announcements) |
| docs/guides/posting-session-tracking-ready-announcement.md | `C0684S1LTLP` | Ops guide | ✅ Examples now point to `#announcements` / `#council-ops` |
| agents/prompts/SLHQ-4-enable-linear-integrations.md | `C0684S1LTLP`, `C0684RPSHCP` | Execution prompt | ✅ Channel inventory refreshed to current taxonomy |
| docs/integrations/channel-strategy.md | `C0684S1LTLP`, `C0684RPSHCP` | Strategy doc | ✅ Current channel lineup documented; legacy noted |
| docs/testing/SESSION-TRACKER-2-MCP-TEST-REPORT.md | `C0684S1LTLP`, `C0684RPSHCP` | Historical test log | ✅ Annotated as historical snapshot |
| docs/runbooks/session-tracking-announcement-record.md | `C0684S1LTLP` | Historical record | ✅ Marked as legacy broadcast record |
| docs/debugging/slack-mcp-channel-bug.md | Multiple legacy IDs | Debug log | ✅ Clarified as debugging snapshot for archival use |

### Prioritized Remediation
1. **Replace placeholders** in execution guides (`docs/guides/linear-integration-announcement.md`).
2. **Update automation payloads** (`scripts/slack/session-tracking-implementation-complete.json`) so Council Bot posts to active channels.
3. **Refresh prompts and strategy docs** to prevent new work from targeting legacy channels.
4. **Annotate historical artefacts** where legacy IDs must remain for traceability.

## Recommended Update Workflow
1. **Batch editing:** Apply targeted `sed`/`rg --replace` updates for placeholder IDs.
2. **Manual verification:** Cross-check each updated document against `SLACK-CHANNELS.md`.
3. **Regression scan:** Re-run `rg "C0684S1LTLP"` and `rg "C0XXXXXXXXX"` to confirm removal from active assets.
4. **Documentation sync:** Update `SLACK-CHANNELS.md` if new channels are introduced during cleanup.

## Verification Checklist
- [ ] All executable prompts/scripts reference only current IDs.
- [ ] Historical docs clearly labelled to avoid accidental reuse.
- [ ] `rg "C0XXXXXXXXX" --glob '!docs/audits/*'` returns no results (placeholder confined to this audit).
- [ ] `rg "C0684S1LTLP"` limited to archival directories (`docs/runbooks/`, `docs/testing/`, `docs/debugging/`).
- [ ] Updated files reviewed with stakeholders before broadcasting changes.

## Notes
- Slack MCP access is unavailable in Codex; rely on `curl`-based verification if channel status must be reconfirmed.
- Keep `.env.example` aligned with these IDs when session-tracking automation is implemented.
