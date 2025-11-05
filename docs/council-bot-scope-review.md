# Council Bot OAuth Scope Review

**Date**: 2025-11-04 (Updated after testing)
**Status**: ⚠️ Partially Resolved - Second Scope Needed
**Issue**: Two user-related scopes required for documented MCP functions

---

## Executive Summary

**Testing Results:**
- ✅ `users:read` - Added via Slack UI, working (not yet in manifest.yml)
- ❌ `users.profile:read` - Still missing, required for profile function

**Impact**:
- ✅ User listing works (`slack_get_users`)
- ❌ User profile details fail (`slack_get_user_profile`)

**Recommendation**: Add both scopes to `manifest.yml` for consistency and full functionality.

---

## Current Scope Inventory

### Bot Scopes (13 total)

| Scope | Purpose | Status |
|-------|---------|--------|
| `channels:join` | Join public channels | ✅ Active |
| `channels:manage` | Manage public channels | ✅ Active |
| `channels:read` | View channel info | ✅ Active |
| `channels:write.invites` | Invite users to channels | ✅ Active |
| `channels:write.topic` | Set channel topics | ✅ Active |
| `chat:write` | Post messages | ✅ Active |
| `chat:write.public` | Post without joining | ✅ Active |
| `groups:read` | View private channels | ✅ Active |
| `groups:write` | Manage private channels | ✅ Active |
| `groups:write.invites` | Invite to private channels | ✅ Active |
| `groups:write.topic` | Set private channel topics | ✅ Active |
| `im:history` | Read DM history | ✅ Active |
| `usergroups:write` | Manage usergroups | ✅ Active |
| **`users:read`** | **List workspace users** | ✅ **Active (via UI)** |
| **`users.profile:read`** | **Read user profiles** | ❌ **MISSING** |

### User Scopes (4 total)

| Scope | Purpose | Status |
|-------|---------|--------|
| `channels:history` | Read channel messages | ✅ Active |
| `channels:read` | View channels | ✅ Active |
| `channels:write` | Manage channels | ✅ Active |
| `chat:write` | Post messages | ✅ Active |

---

## Scope Analysis & Test Results

### ✅ `users:read` (Bot Scope) - WORKING

**Status**: Added via Slack UI on 2025-11-04, not yet in manifest.yml

**Slack API Methods:**
- ✅ `users.list` - List all workspace users

**MCP Functions:**

#### 1. `mcp__slack__slack_get_users` ✅ WORKING
**Purpose**: List all workspace members
**Usage**: Session tracking, user discovery, agent coordination
**Test Result**: ✅ Successfully returns workspace members

```javascript
mcp__slack__slack_get_users({ limit: 10 })
// ✅ Returns: 9 members (Slackbot, Brain, Jira, Linear, Devin, Claude, Codex, Scribe, etc.)
```

---

### ❌ `users.profile:read` (Bot Scope) - MISSING

**Status**: Not yet added

**Slack API Methods:**
- ❌ `users.info` - Get user details by ID
- ❌ `users.profile.get` - Get user profile information

**MCP Functions:**

#### 2. `mcp__slack__slack_get_user_profile` ❌ NOT WORKING
**Purpose**: Get detailed user profile by ID
**Usage**: User identification, session attribution, agent handoffs
**Test Result**: 🔴 Fails with "missing_scope" error

```javascript
mcp__slack__slack_get_user_profile({ user_id: "U068MRDCPDJ" })
// Error: "missing_scope", "needed": "users.profile:read"
// Provided scopes include users:read but NOT users.profile:read
```

---

## Impact Assessment

### Critical Impact ⚠️

**1. Session Tracking System**
- Session-tracker-2 agent has `mcp__slack__slack_get_users` in its toolset
- Cannot resolve usernames to user IDs
- Cannot attribute sessions to specific users
- **Workaround**: Use fixed user IDs (loses flexibility)

**2. User Identification in Workflows**
- Cannot dynamically look up users by name
- Cannot get user profile details for context
- Cannot identify who triggered actions
- **Workaround**: Manual user ID lookup, hard-code IDs

**3. Documentation-Code Mismatch**
- `docs/council-bot.md` documents these functions as available (lines 118-144)
- Functions are listed in examples and best practices
- Creates confusion for agents and developers
- **Resolution Required**: Either add scope OR update docs

### Minor Impact

**4. Agent Coordination**
- Subagent handoff tracking may be less precise
- User mentions in Slack updates less dynamic
- **Workaround**: Reference roles instead of users

---

## Risk Assessment

### Adding `users:read` Scope

**Security Risk**: 🟢 **Low**
- Read-only scope (cannot modify user data)
- Standard scope used by most Slack apps
- No sensitive data exposed beyond normal workspace visibility
- Aligns with Council Bot's purpose (workspace operations)

**Implementation Risk**: 🟢 **Low**
- Non-breaking change (additive only)
- Requires app reinstall/reauthorization
- No code changes needed (MCP functions already exist)
- Manifest validation will confirm compatibility

**Operational Risk**: 🟢 **Low**
- No user-facing changes
- Functions fail gracefully if scope missing
- Can be tested before deployment

### NOT Adding `users:read` Scope

**Documentation Risk**: 🟡 **Medium**
- Must update council-bot.md to remove non-functional examples
- Must document workarounds for user identification
- May confuse future developers/agents

**Functionality Risk**: 🟡 **Medium**
- Limits session tracking capabilities
- Reduces automation flexibility
- Forces hard-coded user IDs

**Technical Debt**: 🟡 **Medium**
- MCP functions exist but unusable
- Creates exceptions in tooling patterns
- May need revisiting later anyway

---

## Recommendations

### Option 1: Add Both Scopes ✅ (Recommended)

**Rationale:**
- Enables full documented functionality
- Aligns with Council Bot's comprehensive permissions strategy
- Low risk, high value
- Standard scopes for workspace bots

**Implementation Steps:**

1. **Update manifest.yml**
```yaml
oauth_config:
  scopes:
    bot:
      # ... existing scopes ...
      - users:read           # For users.list (listing users)
      - users.profile:read   # For users.info/users.profile.get (profile details)
```

2. **Validate manifest**
```bash
slack manifest validate --file manifest.yml
```

3. **Redeploy app**
```bash
./scripts/slack-setup.sh
```

4. **Reauthorize in Slack**
   - Go to Slack App settings
   - Reinstall to workspace
   - Approve new scopes (users.profile:read only - users:read already added)

5. **Test both user functions**
```javascript
// Test users:read (already working)
mcp__slack__slack_get_users({ limit: 10 })
// ✅ Should return user list

// Test users.profile:read (currently failing)
mcp__slack__slack_get_user_profile({ user_id: "U068MRDCPDJ" })
// ✅ Should return profile details
```

6. **Update documentation**
   - Mark both scopes as active in scope review
   - Confirm full user functionality enabled
   - No CLAUDE.md changes needed (functions already documented)

**Timeline**: ~15 minutes
**Risk**: Low
**Approval Required**: Workspace admin (one-time for users.profile:read)

---

### Option 2: Document the Limitation

**Rationale:**
- Maintain minimal scope footprint
- Defer until user functions are actively needed
- Avoid workspace admin approval process

**Implementation Steps:**

1. **Update docs/council-bot.md**
```markdown
## 🚧 Limited User Functionality

**Status**: `users:read` scope not yet enabled

The following MCP functions are **documented but non-functional**:
- `mcp__slack__slack_get_users` - Returns missing_scope error
- `mcp__slack__slack_get_user_profile` - Returns missing_scope error

**Workarounds**:
- Use fixed user IDs: `U123ABC456`
- Look up IDs manually via Slack UI
- Reference roles instead of specific users

**To enable**: Add `users:read` to manifest.yml and reinstall app.
```

2. **Update session-tracker-2.md**
```markdown
## User Identification Limitations

⚠️ **Note**: User lookup functions require `users:read` scope (not yet enabled).

When logging activities:
- Use fixed user IDs if known
- Use "unknown" for dynamic user identification
- Rely on Slack thread context for attribution
```

3. **Add to CLAUDE.md under "Known Limitations"**
```markdown
### User Functions Unavailable
- `mcp__slack__slack_get_users` requires `users:read` scope
- Workaround: Use fixed user IDs or manual lookup
- To enable: Update manifest.yml and get stakeholder approval
```

**Timeline**: ~30 minutes
**Risk**: Medium (creates exceptions in documented patterns)
**Approval Required**: None (documentation-only change)

---

## Comparison Matrix

| Criteria | Add Scope | Document Limitation |
|----------|-----------|---------------------|
| **Time to implement** | 15 min | 30 min |
| **Approval required** | Yes (workspace admin) | No |
| **Risk level** | Low | Medium |
| **Functionality** | Full | Partial (workarounds) |
| **Documentation match** | Yes | No (requires updates) |
| **Future-proof** | Yes | No (likely revisit) |
| **Maintenance burden** | None | Ongoing (workarounds) |
| **Best practice alignment** | Yes | No |

---

## Current Status & Next Decision

**Completed**: ✅ `users:read` added via Slack UI (2025-11-04)

**Remaining Decision**: Should we add `users.profile:read` for profile details?

**Context**:
- `users:read` enables user listing (✅ working)
- `users.profile:read` enables profile details (❌ not yet added)
- Both are read-only, standard scopes for workspace bots
- Profile function is documented but currently fails
- Alternative: document limitation and use workarounds

**Recommended**: ✅ Yes, add `users.profile:read` + update manifest.yml with both scopes

---

## Next Steps

### To Complete Full User Functionality:

**Phase 1: Update manifest.yml** (keeps config in sync)
1. [ ] Add `users:read` to manifest.yml bot scopes
2. [ ] Add `users.profile:read` to manifest.yml bot scopes
3. [ ] Validate manifest: `slack manifest validate --file manifest.yml`
4. [ ] Commit changes to git

**Phase 2: Add Second Scope** (enables profile function)
1. [ ] Add `users.profile:read` via Slack UI OR
2. [ ] Redeploy with updated manifest: `./scripts/slack-setup.sh`
3. [ ] Reinstall/reauthorize app in workspace

**Phase 3: Verify & Document**
1. [ ] Test `slack_get_user_profile` function
2. [ ] Update scope review status to "Fully Implemented"
3. [ ] Update council-bot.md if needed (currently already documented)

### Alternative: Defer Second Scope
1. [ ] Update council-bot.md noting `slack_get_user_profile` limitation
2. [ ] Document workaround (use `slack_get_users` for basic info)
3. [ ] Create Linear issue for future scope addition
4. [ ] Update scope review status to "Partially Implemented"

---

## References

- **Slack Scopes Reference**: https://api.slack.com/scopes/users:read
- **Council Bot Manifest**: `/Users/x/Downloads/slack-hq/manifest.yml`
- **Council Bot Capabilities**: `/Users/x/Downloads/slack-hq/docs/council-bot.md`
- **Session Tracker Agent**: `/Users/x/Downloads/slack-hq/.claude/agents/session-tracker-2.md`
- **OAuth Best Practices**: https://api.slack.com/authentication/oauth-v2
