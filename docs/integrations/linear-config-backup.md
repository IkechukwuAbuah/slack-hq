# Linear Integration Configuration Backup

**Purpose:** Disaster recovery backup of Linear integration settings
**Project:** slack-hq
**Team:** SLHQ
**Last Updated:** 2025-11-03

This document serves as a reference for restoring Linear integrations if they need to be reconfigured.

---

## GitHub Integration Configuration

### App Installation

**Integration:** Linear GitHub App
**Repository:** IkechukwuAbuah/slack-hq
**Repository URL:** https://github.com/IkechukwuAbuah/slack-hq
**Team Connection:** SLHQ

**Required Permissions:**
- ✅ Read repository contents
- ✅ Read and write pull requests
- ✅ Read and write issues
- ✅ Read commit data
- ✅ Webhook notifications

### Status Automation Rules

```json
{
  "automations": {
    "pr_opened": {
      "enabled": true,
      "target_status": "In Review",
      "condition": "PR contains SLHQ-X in title or body",
      "description": "When PR is opened, set linked issue to In Review"
    },
    "pr_merged": {
      "enabled": true,
      "target_status": "Done",
      "condition": "PR is merged (not just closed)",
      "description": "When PR is merged, set linked issue to Done"
    },
    "pr_closed_unmerged": {
      "enabled": false,
      "action": "no_change",
      "description": "Closed PRs without merge don't affect status"
    },
    "commit_linking": {
      "enabled": true,
      "patterns": [
        "SLHQ-\\d+",
        "Fixes SLHQ-\\d+",
        "Closes SLHQ-\\d+",
        "Resolves SLHQ-\\d+"
      ],
      "description": "Automatically link commits to issues"
    }
  }
}
```

### Branch Naming Convention

```json
{
  "branch_naming": {
    "format": "{username}/{issue-id}-{issue-title-slug}",
    "settings": {
      "lowercase": true,
      "replace_spaces": "-",
      "max_length": 100,
      "remove_special_chars": true
    },
    "examples": [
      "kelvin/slhq-4-enable-linear-github-slack-integrations",
      "kelvin/slhq-12-implement-authentication-flow",
      "kelvin/slhq-8-update-documentation"
    ]
  }
}
```

### Commit Message Recognition

**Primary Pattern:** `SLHQ-\d+`

**Closing Patterns:**
- `Fixes SLHQ-\d+` → Closes issue when commit is merged
- `Closes SLHQ-\d+` → Closes issue when commit is merged
- `Resolves SLHQ-\d+` → Closes issue when commit is merged

**Recommended Commit Format:**
```
<type>(SLHQ-X): <description>

Where type is one of:
- feat: New feature
- fix: Bug fix
- docs: Documentation changes
- chore: Maintenance tasks
- refactor: Code refactoring
- test: Test additions/changes
- perf: Performance improvements

Examples:
feat(SLHQ-4): enable Linear Slack integration
fix(SLHQ-12): resolve authentication timeout
docs(SLHQ-8): update integration guide
```

---

## Slack Integration Configuration

### App Installation

**Integration:** Linear Slack App
**Workspace:** The Council
**Workspace ID:** T068KC5GURY
**Team Connection:** SLHQ
**Primary Channel:** #council-core (ID: TBD after creation)

**Required Permissions:**
- ✅ Post messages to channels
- ✅ Read channel information
- ✅ Read user information
- ✅ Send notifications
- ✅ Unfurl links

### Event Configuration

```json
{
  "notifications": {
    "channel": "#council-core",
    "team": "SLHQ",
    "scope": "team-wide",
    "format": "compact",

    "enabled_events": {
      "issue_status_changed": {
        "enabled": true,
        "format": "📋 {issue-id} moved to {status} by {user}",
        "include_link": true,
        "rationale": "Track progress visibility for all team members"
      },
      "issue_commented": {
        "enabled": true,
        "format": "💬 {user} commented on {issue-id}: {preview}",
        "include_link": true,
        "preview_length": 100,
        "rationale": "Foster collaboration and discussion awareness"
      },
      "issue_assigned": {
        "enabled": true,
        "format": "👤 {issue-id} assigned to {assignee}",
        "mention_assignee": true,
        "include_link": true,
        "rationale": "Alert assignees immediately of new responsibilities"
      },
      "issue_priority_changed": {
        "enabled": true,
        "format": "⚡ {issue-id} priority changed to {priority}",
        "include_link": true,
        "rationale": "Highlight urgency shifts for team planning"
      },
      "pr_opened": {
        "enabled": true,
        "format": "🔀 PR opened for {issue-id}: {pr-title}",
        "include_github_link": true,
        "include_linear_link": true,
        "source": "github_integration",
        "rationale": "Code review awareness for development team"
      },
      "pr_merged": {
        "enabled": true,
        "format": "✅ PR merged for {issue-id}: {pr-title}",
        "include_github_link": true,
        "include_linear_link": true,
        "source": "github_integration",
        "rationale": "Celebrate completions and track delivery"
      }
    },

    "disabled_events": {
      "issue_created": {
        "enabled": false,
        "rationale": "Too noisy - creates notification spam. Per SLHQ-4 specification."
      },
      "issue_updated": {
        "enabled": false,
        "rationale": "Too granular - triggers on every field change, even minor edits"
      },
      "issue_labeled": {
        "enabled": false,
        "rationale": "Low priority - label changes not typically actionable"
      },
      "issue_description_changed": {
        "enabled": false,
        "rationale": "Low priority - description edits are usually minor refinements"
      },
      "issue_title_changed": {
        "enabled": false,
        "rationale": "Low priority - title changes don't require immediate team awareness"
      }
    }
  }
}
```

### Notification Format Settings

```json
{
  "format_settings": {
    "style": "compact",
    "include_title": true,
    "include_status": true,
    "include_assignee": true,
    "include_link": true,
    "link_unfurl": false,
    "use_emoji": true,
    "thread_replies": false,
    "daily_digest": false
  },

  "mention_settings": {
    "mention_assignee_on_assignment": true,
    "mention_on_comment": false,
    "require_linked_accounts": true,
    "fallback_to_name": true
  }
}
```

---

## Channel Configuration

### Primary Notification Channel

**Channel Name:** #council-core
**Channel Purpose:** Linear issue tracking and automation notifications
**Visibility:** Public
**Members:** All SLHQ team members, Council Bot

**Channel Description:**
```
Linear issue tracking and automation notifications. Status changes,
assignments, and PR updates from Linear workspace. Mute if too noisy!
```

**Channel Topic:**
```
🤖 Automated Linear notifications | Docs: /docs/LINEAR-INTEGRATION-STATUS.md
```

### Alternative Channel Strategy

If #council-core becomes too noisy or team prefers consolidation:

**Option 1: Per-Project Channels**
- Create separate channels for different projects
- Example: #slhq-notifications, #project-x-notifications
- Configure Linear per-project overrides

**Option 2: Centralized in #general**
- Use #general for all notifications
- Pros: Single source of truth, easier monitoring
- Cons: Mixes automation with conversation

**Option 3: Thread-Based Notifications**
- Post parent message daily (e.g., "Daily Updates - 2025-11-03")
- All notifications as thread replies
- Reduces channel noise significantly

---

## Restore Procedures

### If GitHub Integration Fails

1. **Uninstall and Reinstall:**
   ```
   1. Linear → Settings → Integrations → GitHub
   2. Click "Remove" or "Disconnect"
   3. Confirm removal
   4. Wait 30 seconds
   5. Click "Install" and follow OAuth flow
   6. Select repository: IkechukwuAbuah/slack-hq
   7. Complete authorization
   ```

2. **Reconnect Repository:**
   ```
   1. In Linear GitHub settings
   2. Find "slack-hq" in repository list
   3. Click "Connect"
   4. Select team: SLHQ
   5. Verify connection shows green checkmark
   ```

3. **Reconfigure Automations:**
   - Use JSON configuration above
   - Enable PR → In Review automation
   - Enable PR merge → Done automation
   - Enable commit linking with SLHQ-\d+ pattern
   - Verify branch naming format

4. **Test Connection:**
   ```bash
   # Create test commit
   git commit -m "test(SLHQ-4): verify GitHub integration restored"
   git push

   # Check Linear issue for commit
   # Should appear in Git section within 1-2 minutes
   ```

### If Slack Integration Fails

1. **Uninstall and Reinstall:**
   ```
   1. Linear → Settings → Integrations → Slack
   2. Click "Disconnect" or "Remove"
   3. Confirm removal
   4. Wait 30 seconds
   5. Click "Add to Slack" and follow OAuth flow
   6. Authorize Linear access to The Council workspace
   7. Complete authorization
   ```

2. **Reconnect Team:**
   ```
   1. In Linear Slack settings
   2. Select team: SLHQ
   3. Verify workspace: The Council (T068KC5GURY)
   4. Set primary channel: #council-core
   5. Confirm connection
   ```

3. **Reconfigure Events:**
   - Use JSON configuration above
   - Enable: status_changed, commented, assigned, priority_changed
   - Enable: pr_opened, pr_merged (from GitHub integration)
   - Disable: issue_created, issue_updated, labeled, description_changed
   - Set format: compact
   - Enable @mentions for assignments

4. **Test Connection:**
   ```bash
   # Via Linear MCP or UI
   # Change any issue status
   linear issue update SLHQ-4 --status "In Progress"

   # Check #council-core for notification
   # Should appear within 5-10 seconds
   ```

### If Both Integrations Need Reset

1. **Document current state:**
   - Screenshot Linear integration settings
   - Note any custom configurations
   - Record channel IDs and team mappings

2. **Disconnect both integrations:**
   - GitHub first, then Slack
   - Wait 1 minute between disconnects

3. **Clear browser cache:**
   - May help with authorization issues
   - Force refresh Linear settings page

4. **Reinstall in order:**
   - GitHub integration first (easier to test)
   - Test GitHub integration completely
   - Then Slack integration
   - Test Slack integration

5. **Verify end-to-end:**
   - Create commit → appears in Linear
   - Create PR → status changes, Slack notifies
   - Merge PR → status changes to Done, Slack notifies
   - Change status manually → Slack notifies

---

## Configuration History

### Version 1.0 (2025-11-03)
- Initial configuration documented
- GitHub integration: PR automations + commit linking
- Slack integration: 6 enabled events, 4 disabled
- Channel: #council-core (dedicated notifications)
- Format: Compact with emoji indicators

### [Future versions will be documented here]

---

## Testing Checklist

After restoring integrations, verify:

**GitHub Integration:**
- [ ] Repository shows "Connected" in Linear settings
- [ ] Test commit appears in issue Git section
- [ ] Test PR appears in issue Git section
- [ ] PR opening changes status to "In Review"
- [ ] PR merge changes status to "Done"
- [ ] Branch name suggestions work
- [ ] Links are clickable and correct

**Slack Integration:**
- [ ] Integration shows "Connected" in Linear settings
- [ ] #council-core configured as primary channel
- [ ] Test status change posts to Slack
- [ ] Test comment triggers notification
- [ ] Test assignment triggers notification
- [ ] PR events trigger notifications
- [ ] Issue creation does NOT trigger notification
- [ ] All links in notifications work

**End-to-End:**
- [ ] Commit → Linear → Slack (full flow)
- [ ] PR open → Linear status change → Slack notification
- [ ] PR merge → Linear status change → Slack notification
- [ ] Manual status change → Slack notification
- [ ] No unexpected notifications

---

## Support Contacts

**Linear Support:**
- Email: support@linear.app
- Docs: https://linear.app/docs
- Status: https://status.linear.app

**GitHub Support:**
- Docs: https://docs.github.com
- Community: https://github.community
- Status: https://www.githubstatus.com

**Slack Support:**
- Help: https://slack.com/help
- API Docs: https://api.slack.com
- Status: https://status.slack.com

**Internal:**
- Check: docs/LINEAR-INTEGRATION-STATUS.md
- Ask: #council-core channel
- Review: docs/LINEAR-INTEGRATION-SETUP.md

---

## Notes

- Keep this document updated when configuration changes
- Document all deviations from standard config
- Include version history for major changes
- Test restore procedures quarterly
- Verify backups are accessible to team leads

---

**Last Verified:** 2025-11-03
**Next Review:** 2025-12-03 (monthly)
**Configuration Version:** 1.0
