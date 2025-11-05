# Linear Integration Status

**Last Updated:** 2025-11-03
**Issue:** SLHQ-4
**Status:** ⚠️ Setup In Progress

## Integration Overview

This document tracks the status of Linear integrations with GitHub and Slack for the slack-hq project.

### Quick Status

| Integration | Status | Last Verified |
|------------|--------|---------------|
| GitHub | ⏳ Pending Setup | - |
| Slack | ⏳ Pending Setup | - |

---

## GitHub Integration

**Status:** ⏳ Awaiting manual setup
**Repository:** IkechukwuAbuah/slack-hq
**Team:** SLHQ

### Configuration Details

Once enabled, the following automations will be active:

| Trigger | Action | Status |
|---------|--------|--------|
| PR opened with SLHQ-X | Set status to "In Review" | ⏳ Pending |
| PR merged | Set status to "Done" | ⏳ Pending |
| Commit with SLHQ-X | Link to issue | ⏳ Pending |

### Branch Naming Format

```
<username>/<issue-id>-<issue-title-slug>
```

**Example:**
```
kelvin/slhq-4-enable-linear-github-slack-integrations
```

### Commit Message Patterns

Linear recognizes these patterns:
- `SLHQ-\d+` (standard reference)
- `Fixes SLHQ-\d+` (closes issue)
- `Closes SLHQ-\d+` (closes issue)
- `Resolves SLHQ-\d+` (closes issue)

**Recommended format:**
```
<type>(SLHQ-X): <description>

Examples:
feat(SLHQ-4): enable Linear Slack integration
fix(SLHQ-12): resolve authentication timeout
docs(SLHQ-8): update integration guide
```

### Test Results

After setup completion, verify:

- [ ] Commits with SLHQ-X link to issues
- [ ] PRs appear in issue Git section
- [ ] PR merge updates issue status to "Done"
- [ ] Branch name suggestions work in Linear UI
- [ ] Links open correctly from Linear → GitHub
- [ ] GitHub activity appears in Linear issue timeline

---

## Slack Integration

**Status:** ⏳ Awaiting manual setup
**Workspace:** The Council (T068KC5GURY)
**Channel:** #council-core (ID: C09QAKDHKMG)
**Team:** SLHQ

### Notification Channel Strategy

**Decision:** Use dedicated #council-core channel

**Rationale:**
- Clean separation of automation from human conversation
- Easy to filter/mute for users who want less noise
- Scalable as more integrations are added
- Keeps #general focused on human announcements
- Matches SLHQ-4 specification

**Alternative considered:** Using #general
- Rejected due to mixing automation with conversation
- Would make channel harder to read
- No clean way to filter automated updates

### Configured Notifications

Once enabled, the following events will trigger Slack notifications:

**Enabled Events:**

| Event | Enabled | Rationale | Format |
|-------|---------|-----------|--------|
| Issue status changed | ✅ YES | Track progress visibility | "📋 SLHQ-X moved to [Status]" |
| Issue commented | ✅ YES | Foster collaboration | "💬 [User] commented on SLHQ-X" |
| Issue assigned | ✅ YES | Alert assignees immediately | "👤 SLHQ-X assigned to [User]" |
| Issue priority changed | ✅ YES | Highlight urgency shifts | "⚡ SLHQ-X priority: [Priority]" |
| PR opened (GitHub) | ✅ YES | Code review awareness | "🔀 PR opened for SLHQ-X" |
| PR merged (GitHub) | ✅ YES | Celebrate completions | "✅ PR merged for SLHQ-X" |

**Disabled Events:**

| Event | Enabled | Rationale |
|-------|---------|-----------|
| Issue created | ❌ NO | Too noisy (per SLHQ-4 spec) |
| Issue updated (general) | ❌ NO | Too granular, many false positives |
| Issue labeled | ❌ NO | Low priority, not actionable |
| Issue description changed | ❌ NO | Low priority, usually minor edits |

### Notification Format

- **Style:** Compact (not verbose)
- **Includes:** Issue title, status, assignee, link
- **Links:** Direct to Linear issue
- **PR Events:** Include both Linear and GitHub links
- **User Mentions:** @mention if Slack ↔ Linear accounts linked

### Test Results

After setup completion, verify:

- [ ] Status changes post to #council-core
- [ ] Comments trigger notifications with preview
- [ ] Assignments notify channel (with @mention if linked)
- [ ] PR events broadcast correctly with GitHub links
- [ ] Issue creation does NOT trigger notification (confirmed silent)
- [ ] Messages include working links to Linear
- [ ] Notification format is compact and readable
- [ ] Council Bot appears as message author

---

## Integration Testing

### GitHub Integration Tests

**Test 1: Commit Linking**
```bash
# Command to run after setup:
git checkout kelvin/slhq-4-enable-linear-github-slack-integrations
echo "\n## Integration Test\nGitHub integration verified." >> docs/LINEAR-INTEGRATION-SETUP.md
git add docs/LINEAR-INTEGRATION-SETUP.md
git commit -m "test(SLHQ-4): verify GitHub Linear commit linking"
git push
```

**Expected Result:**
- ✅ Commit appears in SLHQ-4's "Git" section in Linear
- ✅ Can click commit link → opens GitHub commit
- ✅ Activity log shows "Commit added by [name]"

---

**Test 2: PR Creation & Status Update**
```bash
# Command to run after setup:
git checkout -b test/slhq-4-pr-integration
echo "PR integration test" > test-pr-integration.txt
git add test-pr-integration.txt
git commit -m "test(SLHQ-4): verify PR integration"
git push -u origin test/slhq-4-pr-integration

gh pr create \
  --title "test(SLHQ-4): verify PR integration" \
  --body "Testing PR integration with Linear. References SLHQ-4." \
  --base main \
  --head test/slhq-4-pr-integration
```

**Expected Result:**
- ✅ PR appears in SLHQ-4's "Git" section
- ✅ SLHQ-4 status updates to "In Review" (if configured)
- ✅ PR link is clickable from Linear
- ✅ Slack notification posted to #council-core

---

**Test 3: PR Merge & Status Update**
```bash
# Command to run after PR tests pass:
gh pr merge test/slhq-4-pr-integration --squash --delete-branch
```

**Expected Result:**
- ✅ SLHQ-4 status updates to "Done" (if configured)
- ✅ Activity log shows "PR merged"
- ✅ PR link still works (even after merge)
- ✅ Slack notification posted to #council-core

---

**Test 4: Branch Name Generation**

**Steps:**
1. Open SLHQ-4 in Linear UI
2. Click "Create branch" button
3. Verify suggested name matches format
4. Copy to clipboard

**Expected Result:**
- ✅ Suggested name: `kelvin/slhq-4-enable-linear-github-slack-integrations`
- ✅ Copy to clipboard works
- ✅ Name follows convention

---

### Slack Integration Tests

**Test 1: Status Change Notification**
```bash
# Via Linear MCP:
linear issue update SLHQ-4 --status "In Progress"
```

**Expected Result:**
- ✅ Message appears in #council-core
- ✅ Format: "📋 SLHQ-4 moved to In Progress by [name]"
- ✅ Includes direct link to Linear issue
- ✅ Posted by Linear bot

---

**Test 2: Comment Notification**
```bash
# Via Linear UI or MCP:
linear issue comment SLHQ-4 --body "Testing Slack notification for comments"
```

**Expected Result:**
- ✅ Message appears in #council-core
- ✅ Format: "💬 [name] commented on SLHQ-4: [preview]"
- ✅ Includes link to issue

---

**Test 3: Assignment Notification**
```bash
# Via Linear:
linear issue update SLHQ-4 --assignee "Kelvin Abuah"
```

**Expected Result:**
- ✅ Message appears in #council-core
- ✅ Format: "👤 SLHQ-4 assigned to Kelvin Abuah"
- ✅ @mentions assignee if accounts linked

---

**Test 4: PR Event from GitHub**

**Steps:**
1. Create test PR (from GitHub test 2)
2. Check #council-core for notification

**Expected Result:**
- ✅ Message appears: "🔀 PR opened for SLHQ-4: [title]"
- ✅ Includes both Linear and GitHub links
- ✅ Posted by Linear bot

---

**Test 5: Verify Issue Creation is Silent**
```bash
# Create test issue:
linear issue create \
  --team SLHQ \
  --title "Test: Verify issue creation doesn't notify" \
  --description "This should NOT trigger Slack notification"
```

**Expected Result:**
- ❌ NO message appears in #council-core
- ✅ Issue created successfully in Linear
- ✅ Confirms "issue created" events disabled

---

## Troubleshooting

### GitHub Integration Issues

**Problem: Commits not appearing in Linear**

Possible causes:
- Commit message doesn't include exact issue ID format (SLHQ-X)
- Repository not connected in Linear settings
- GitHub app lacks repository access

Solutions:
1. Verify commit message format: `<type>(SLHQ-X): description`
2. Check Linear → Integrations → GitHub → Connected repos
3. Reinstall GitHub app if needed

---

**Problem: PR status not updating**

Possible causes:
- "Update status on PR merge" automation disabled
- Target status doesn't exist in workflow
- Automation rule misconfigured

Solutions:
1. Verify automation enabled in Linear GitHub settings
2. Check "Done" status exists in SLHQ workflow
3. Review automation rules: Settings → Integrations → GitHub

---

**Problem: Branch name suggestions not working**

Possible causes:
- Browser cache
- GitHub integration not fully connected
- Linear issue doesn't have proper metadata

Solutions:
1. Refresh Linear issue page (hard refresh)
2. Verify GitHub integration shows "Connected"
3. Try disconnecting and reconnecting repository

---

### Slack Integration Issues

**Problem: No notifications appearing**

Possible causes:
- Slack integration not enabled for SLHQ team
- #council-core not configured correctly
- Linear lacks permission to post
- Council Bot not in channel

Solutions:
1. Verify integration: Linear → Integrations → Slack → SLHQ team
2. Check channel configuration in Slack integration settings
3. Verify Council Bot is member of #council-core
4. Check Linear app permissions in Slack

---

**Problem: Notifications too noisy**

Possible causes:
- Too many events enabled
- No event filtering configured
- All teams posting to same channel

Solutions:
1. Review enabled events in Slack integration settings
2. Disable lower-priority events (labels, descriptions)
3. Consider per-project overrides for fine-tuning

---

**Problem: @mentions not working**

Possible causes:
- Slack and Linear accounts not linked
- User email mismatch between platforms
- Linear lacks Slack user information

Solutions:
1. Users must link accounts: Linear → Settings → Connected accounts → Slack
2. Verify email addresses match between platforms
3. Re-authorize Slack integration if needed

---

**Problem: Messages appear in wrong channel**

Possible causes:
- Channel configuration incorrect
- Multiple channel settings conflicting
- Project-level override active

Solutions:
1. Check Linear → Integrations → Slack → Channel settings
2. Verify #council-core is default for SLHQ team
3. Review per-project overrides if configured

---

## Maintenance Schedule

### Weekly (First Month)
- Monitor #council-core for notification volume feedback
- Collect team input on noise level
- Adjust event settings based on feedback

### Monthly (Ongoing)
- Verify integrations show "Connected" in Linear
- Test one notification of each type
- Review automation rules for any needed updates

### Quarterly
- Review event configuration with team
- Assess need for per-project overrides
- Consider new automation opportunities
- Update documentation for any changes

### After Major Updates
- **Linear platform updates:** Retest all automations
- **Slack workspace changes:** Verify channel permissions
- **GitHub repo changes:** Reconnect if renamed/moved
- **Workflow changes:** Update status automation targets

---

## Team Onboarding

### New Team Members

When new engineers join:

1. **Link Slack ↔ Linear accounts**
   - In Linear: Settings → Account → Connected accounts → Slack
   - Click "Connect" and authorize
   - Enables @mentions in notifications

2. **Join #council-core**
   - Channel should be public and discoverable
   - Explain notification patterns
   - Show how to mute if overwhelming

3. **Understand commit conventions**
   - Always include Linear issue ID in commits
   - Use conventional commit types
   - Format: `<type>(SLHQ-X): description`

4. **Learn PR workflow**
   - PR opened → Issue moves to "In Review"
   - PR merged → Issue moves to "Done"
   - Team gets Slack notification at each step

---

## Resources

- **Documentation:**
  - [Linear GitHub Integration Docs](https://linear.app/docs/github)
  - [Linear Slack Integration Docs](https://linear.app/docs/slack)
  - [Setup Guide](LINEAR-INTEGRATION-SETUP.md)
  - [Configuration Backup](../integrations/linear-config-backup.md)

- **Links:**
  - [GitHub Repository](https://github.com/IkechukwuAbuah/slack-hq)
  - [Linear Workspace](https://linear.app/abuah/team/SLHQ)
  - [Slack Workspace](https://app.slack.com/client/T068KC5GURY)
  - [SLHQ-4 Issue](https://linear.app/abuah/issue/SLHQ-4)

- **Support:**
  - Linear Support: support@linear.app
  - Check #council-core for integration status
  - Review this document for troubleshooting

---

## Change Log

### 2025-11-03 - Initial Setup
- Created documentation structure
- Documented integration plans
- Defined channel strategy (#council-core)
- Specified event configuration
- Created test procedures

### [Pending] - Setup Completion
- Enable GitHub integration
- Enable Slack integration
- Complete all test procedures
- Update status to "Active"

---

**Next Steps:**

1. Complete manual setup following [LINEAR-INTEGRATION-SETUP.md](LINEAR-INTEGRATION-SETUP.md)
2. Run all test procedures
3. Update this document with:
   - Actual channel ID for #council-core
   - Test completion timestamps
   - Any configuration deviations
4. Change status to "✅ Active"
5. Post completion announcement to #council-core

---

**Status:** ⚠️ Awaiting manual setup (Phases 1-3 of LINEAR-INTEGRATION-SETUP.md)
**Owner:** Kelvin Abuah
**Last Updated:** 2025-11-03
