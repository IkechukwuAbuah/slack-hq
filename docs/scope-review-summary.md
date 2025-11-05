# Scope Review Summary

**Date**: 2025-11-04
**Status**: ⚠️ Partially Complete

---

## Test Results

### ✅ Working: User Listing
```javascript
mcp__slack__slack_get_users({ limit: 10 })
// SUCCESS: Returns 9 workspace members
// Scope: users:read (added via Slack UI)
```

### ❌ Not Working: User Profiles
```javascript
mcp__slack__slack_get_user_profile({ user_id: "U068MRDCPDJ" })
// ERROR: missing_scope
// Needed: users.profile:read
```

---

## What's Missing

### Two Scopes Needed (Not One)

| Scope | Function | Status |
|-------|----------|--------|
| `users:read` | List users | ✅ Added (via UI) |
| `users.profile:read` | Get profile details | ❌ Missing |

**Note**: `users:read` was added via Slack UI but is **not in manifest.yml**.

---

## Recommendations

### 1. Update manifest.yml (Both Scopes)

```yaml
# manifest.yml - Add to bot scopes:
oauth_config:
  scopes:
    bot:
      # ... existing 13 scopes ...
      - users:read           # Already active, needs manifest sync
      - users.profile:read   # Still needs to be added
```

**Why?**
- Keeps manifest in sync with actual app config
- Enables version control of scope changes
- Required for automated deployments

### 2. Add Second Scope

**Option A: Via Slack UI** (quickest)
- Go to Slack App settings → OAuth & Permissions
- Add `users.profile:read` to bot scopes
- Reinstall app to workspace

**Option B: Via Manifest** (recommended)
```bash
# After updating manifest.yml:
slack manifest validate --file manifest.yml
./scripts/slack-setup.sh
# Follow prompts to reinstall
```

### 3. Test & Verify

```javascript
// Should both work after adding second scope:
mcp__slack__slack_get_users({ limit: 10 })           // ✅ Already working
mcp__slack__slack_get_user_profile({ user_id: "..." }) // ✅ Will work after scope added
```

---

## Impact of NOT Adding Second Scope

**Currently Working:**
- ✅ List all workspace users
- ✅ Get basic user info from list (ID, name, avatar, deleted status)

**Not Working:**
- ❌ Get detailed profile by user ID
- ❌ Get user timezone, status, contact info
- ❌ Direct user lookup without listing all users first

**Workaround**: Call `slack_get_users`, find user in list, use basic info from there.

**Limitation**: Less efficient (must list all users to find one), less detail (no extended profile fields).

---

## Action Items

**To complete full user functionality:**

- [ ] Update `manifest.yml` with both scopes
- [ ] Add `users.profile:read` via Slack UI or manifest redeploy
- [ ] Test `slack_get_user_profile` function
- [ ] Commit manifest changes to git

**Timeline**: ~10 minutes
**Risk**: Low (read-only scope)

---

## References

- **Full Analysis**: `docs/council-bot-scope-review.md`
- **Slack Scopes**: https://api.slack.com/scopes
- **users:read**: https://api.slack.com/scopes/users:read
- **users.profile:read**: https://api.slack.com/scopes/users.profile:read
