# Slack Direct API Runbook

Fallback procedures for interacting with Council Bot’s Slack workspace whenever the Slack MCP server is unavailable, lacks required scopes, or engineers need functionality not yet exposed via MCP.

## Why This Exists
- Claude MCP outages and token drift have repeatedly blocked workstreams.
- Some Slack endpoints (channel lifecycle, invites, archival) are not yet exposed via MCP.
- Shell scripts give every agent a reproducible, reviewable alternative that fits the repository’s automation-first philosophy.

## Prerequisites
- `.env` populated with at least `SLACK_BOT_TOKEN`.
- Token scopes required for specific commands:
  - `channels:manage`, `channels:write.invites` for channel lifecycle.
  - `chat:write`, `chat:write.public` for messaging.
  - `users:read` for user lookup (optional; command fails gracefully without it).
- `jq` installed (homebrew: `brew install jq`).

## Tooling Layout
- `scripts/slack-api-helper.sh` — unified entry point for direct Slack API calls.
- Scripts live under `scripts/` to stay consistent with other automation utilities.
- JSON payload templates (if needed) belong in `scripts/slack/` alongside existing announcement blocks.

## Available Commands
Run `./scripts/slack-api-helper.sh help` for the latest list. Key flows:

| Command | Description | Notes |
| --- | --- | --- |
| `list-channels` | Enumerate public channels with member counts | Paginates up to 200 records |
| `find-channel <search>` | Fuzzy search channel names | Useful before lifecycle work |
| `create-channel <name> [--private] [--topic text] [--purpose text]` | Create channels end-to-end | Automatically applies optional topic/purpose |
| `invite-to-channel <id> <member...>` | Bulk invite users by ID | Accepts space-delimited IDs |
| `archive-channel <id>` | Archive a channel | Requires `channels:manage` scope |
| `post-message <id> <text>` | Send announcement or update | Escapes handled internally |
| `post-thread <id> <ts> <text>` | Reply to an existing thread | Thread TS from parent message |
| `channel-history <id> [limit]` | Inspect recent messages | 10 message default |
| `open-dm <user-id> [message]` | Open DM (optionally send text) | Returns channel object when no message provided |
| `list-users` | List workspace members | Fails with `missing_scope` if token lacks `users:read` |
| `get-user <id>` or `--email` | Fetch profile metadata | Email lookup via Slack API |

All commands exit non-zero on Slack errors and surface the raw API payload for quick triage.

## Example Workflows

### Channel Lifecycle (New Initiative)
```bash
./scripts/slack-api-helper.sh create-channel customer-updates --topic "Customer insights" --purpose "Share learnings"
./scripts/slack-api-helper.sh invite-to-channel C12345678 U11111111 U22222222
./scripts/slack-api-helper.sh post-message C12345678 "Channel created. See runbook: https://... "
```

### DM Handoff
```bash
channel_json=$(./scripts/slack-api-helper.sh open-dm U12345678)
thread_ts=$(echo "$channel_json" | jq -r '.latest.ts? // empty')
./scripts/slack-api-helper.sh open-dm U12345678 "Heads up: Session SLHQ-42 complete. Details in #council-ops."
```

### Triaging Permissions
```bash
./scripts/slack-api-helper.sh list-users
# -> {"ok":false,"error":"missing_scope","needed":"users:read", ...}
```

Use failures to confirm scope gaps before involving platform engineers.

## Fit With Slack HQ Ambitions
- **Resilience**: Keeps the Council operating during MCP outages without stalling engineering work.
- **Auditability**: Command usage can be logged via session tracking once the schema issue is resolved.
- **Extensibility**: Shell entry point can wrap new Slack surfaces (usergroups, bookmarks, canvases) without blocking on MCP ingestion.
- **Documentation-First**: Runbook plus scripts ensure every fallback stays reviewable and versioned. Update this document when adding new subcommands.

## Maintenance Checklist
- When scopes change or new endpoints are added, update both the script help text and this runbook.
- Prefer adding subcommands here before creating ad-hoc curl calls in other scripts.
- Cross-reference `docs/council-bot.md` so primary MCP documentation links to this fallback.
- After major updates, run `./scripts/slack-api-helper.sh help` and capture example output in PR descriptions for reviewers.

