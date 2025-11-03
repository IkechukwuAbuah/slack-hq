# Linear Integration Setup Guide

**Issue:** SLHQ-4 - Enable Linear GitHub & Slack Integrations
**Status:** Setup Required
**Last Updated:** 2025-11-03

This guide walks through the manual steps required to enable Linear's GitHub and Slack integrations for the slack-hq project.

## Prerequisites

- [x] GitHub repository exists: `IkechukwuAbuah/slack-hq`
- [x] Linear workspace exists: SLHQ team
- [x] Slack workspace exists: "The Council" (T068KC5GURY)
- [x] Admin access to Linear workspace
- [x] Admin access to GitHub repository
- [x] Admin/channel creation permissions in Slack

## Phase 1: Slack Channel Setup

### Create #council-core Channel

**Why #council-core?**
- Dedicated channel for Linear/GitHub automation notifications
- Keeps automation separate from human conversation
- Easy to filter/mute for users who want less noise
- Scalable for future integrations (CI/CD, deployments, etc.)

**Steps:**

1. Open Slack workspace "The Council"
2. Click "+" next to "Channels" in the sidebar
3. Select "Create a channel"
4. Configure channel:
   - **Name:** `council-core`
   - **Description:** `Linear issue tracking and automation notifications. Status changes, assignments, and PR updates from Linear workspace.`
   - **Visibility:** Public (for full team visibility)
5. Click "Create"
6. Invite Council Bot to the channel:
   - In #council-core, type: `/invite @Council Bot`
   - Or click channel name → Integrations → Add apps → Council Bot
7. **Note the channel ID** (format: C0XXXXXXXXX)
   - Click channel name → scroll to bottom → copy Channel ID
   - **Save this ID** - you'll need it for documentation

**Expected Result:**
- #council-core channel created
- Council Bot is a member
- Channel ID captured for documentation

---

## Phase 2: Linear → GitHub Integration

### Step 1: Install Linear GitHub App

1. Navigate to Linear Settings:
   - Click your profile → Settings → Integrations
   - Or visit: https://linear.app/settings/integrations

2. Find "GitHub" in the integrations list

3. Click "Install" or "Add Integration"

4. Authorize Linear to access GitHub:
   - You'll be redirected to GitHub
   - Click "Install & Authorize"
   - Select your GitHub account or organization

5. Configure repository access:
   - Select: "Only select repositories"
   - Check: `IkechukwuAbuah/slack-hq`
   - Click "Install"

6. Return to Linear (automatic redirect)

**Expected Result:**
- Linear GitHub integration shows "Connected"
- slack-hq repository appears in Linear's integration settings

### Step 2: Connect Repository to SLHQ Team

1. In Linear's GitHub integration settings:
   - Find "slack-hq" in the repository list
   - Click "Connect" next to the repository name
   - Select team: **SLHQ**

2. Verify connection:
   - Repository should show "Connected to SLHQ team"
   - Green checkmark indicates active connection

**Expected Result:**
- slack-hq connected to SLHQ team
- Repository available for issue linking

### Step 3: Configure Status Automations

Enable automatic status transitions based on PR activity:

1. In Linear GitHub settings, find "Automations" section

2. Enable the following rules:

   **PR Opened Automation:**
   - ✅ Enable: "Update issue status when PR is opened"
   - Status: **In Review**
   - Apply to: All issues with SLHQ-X in PR title/body

   **PR Merged Automation:**
   - ✅ Enable: "Update issue status when PR is merged"
   - Status: **Done**
   - Apply to: All issues linked to merged PR

   **Commit Linking:**
   - ✅ Enable: "Link commits to issues"
   - Pattern: `SLHQ-\d+` (should be default)
   - Also recognize: `Fixes SLHQ-X`, `Closes SLHQ-X`, `Resolves SLHQ-X`

3. Configure branch naming (usually pre-configured):
   - Format: `{username}/{issue-id}-{issue-title-slug}`
   - Example: `kelvin/slhq-4-enable-linear-github-slack-integrations`

4. Save automation settings

**Expected Result:**
- PR opened → Issue status changes to "In Review"
- PR merged → Issue status changes to "Done"
- Commits with SLHQ-X → Appear in issue's Git section

### Step 4: Test GitHub Integration

**Test 1: Verify Integration Active**

In any SLHQ issue (like SLHQ-4):
1. Click the Git icon or "Create branch" button
2. Verify suggested branch name appears
3. Name should follow format: `username/slhq-4-issue-title-slug`

**Test 2: Create Test Commit** (via Claude Code)

```bash
# This will be automated after setup
git checkout kelvin/slhq-4-enable-linear-github-slack-integrations
echo "\n## Integration Test\nGitHub integration verified." >> docs/LINEAR-INTEGRATION-SETUP.md
git add docs/LINEAR-INTEGRATION-SETUP.md
git commit -m "test(SLHQ-4): verify GitHub Linear commit linking"
git push
```

Expected result:
- Commit appears in SLHQ-4's Git section in Linear
- Can click commit → opens GitHub commit
- Activity log shows "Commit added"

**Test 3: Create Test PR** (via Claude Code after setup)

Expected result:
- PR appears in SLHQ-4's Git section
- If configured, SLHQ-4 status updates to "In Review"
- PR link is clickable from Linear

---

## Phase 3: Linear → Slack Integration

### Step 1: Install Linear Slack App

1. In Linear Settings → Integrations:
   - Find "Slack" in the integrations list
   - Click "Add to Slack" or "Install"

2. Authorize Linear to access Slack:
   - You'll be redirected to Slack
   - Review permissions requested:
     - Post messages to channels
     - Read channel information
     - Read user information
   - Click "Allow"

3. Return to Linear (automatic redirect)

4. Select Linear team:
   - Choose: **SLHQ**
   - This connects SLHQ team to Slack workspace

**Expected Result:**
- Linear Slack integration shows "Connected"
- SLHQ team linked to "The Council" workspace

### Step 2: Configure Notification Channel

1. In Linear's Slack integration settings:
   - Find "Default notification channel" setting
   - Click "Select channel"
   - Choose: **#council-core**
   - Confirm selection

2. Configure team-wide settings:
   - Apply to team: **SLHQ**
   - Notification scope: "Team-wide" (all SLHQ issues)

**Expected Result:**
- #council-core set as notification channel
- All SLHQ team issues will notify this channel

### Step 3: Configure Event Notifications

Enable appropriate events to balance visibility and noise:

**Enable These Events:**

| Event | Enabled | Rationale |
|-------|---------|-----------|
| Issue status changed | ✅ YES | Track progress visibility |
| Issue commented | ✅ YES | Foster collaboration |
| Issue assigned | ✅ YES | Alert assignees immediately |
| Issue priority changed | ✅ YES | Highlight urgency shifts |
| PR opened (via GitHub) | ✅ YES | Code review awareness |
| PR merged (via GitHub) | ✅ YES | Celebrate completions |

**Disable These Events:**

| Event | Enabled | Rationale |
|-------|---------|-----------|
| Issue created | ❌ NO | Too noisy (per spec) |
| Issue updated (general) | ❌ NO | Too granular |
| Issue labeled | ❌ NO | Low priority |
| Issue description changed | ❌ NO | Low priority |

**Notification Format Settings:**
- Format: **Compact** (not verbose)
- Include: Issue title, status, assignee
- Show: Direct link to Linear issue
- For PR events: Include GitHub link

### Step 4: Test Slack Integration

**Test 1: Status Change Notification**

1. In Linear, open any SLHQ issue (e.g., SLHQ-4)
2. Change status (e.g., "Backlog" → "In Progress")
3. Check #council-core in Slack

Expected result:
- Message appears: "📋 SLHQ-4 moved to In Progress by [name]"
- Includes clickable link to Linear issue
- Message posted by Linear bot

**Test 2: Comment Notification**

1. In Linear, add comment to SLHQ-4:
   - "Testing Slack notification for comments"
2. Check #council-core in Slack

Expected result:
- Message appears: "💬 [name] commented on SLHQ-4: [comment preview]"
- Link to issue included

**Test 3: Assignment Notification**

1. In Linear, assign SLHQ-4 to yourself
2. Check #council-core in Slack

Expected result:
- Message appears: "👤 SLHQ-4 assigned to [name]"
- If Linear/Slack accounts linked: @mentions assignee

**Test 4: Verify Issue Creation is Silent**

1. Create a test issue in Linear:
   ```
   Title: Test - Verify issue creation doesn't notify
   Team: SLHQ
   ```
2. Check #council-core in Slack

Expected result:
- ❌ NO notification appears
- Confirms "issue created" events are disabled
- Issue successfully created in Linear

---

## Phase 4: Documentation & Completion

After manual setup is complete, Claude Code will:

1. ✅ Create LINEAR-INTEGRATION-STATUS.md (runtime status doc)
2. ✅ Create integration configuration backup
3. ✅ Update CLAUDE.md with integration guidance
4. ✅ Update README.md with integrations overview
5. ✅ Create test commits to verify GitHub integration
6. ✅ Post announcement to #council-core
7. ✅ Update SLHQ-4 status to "Done" (triggers notification!)

---

## Troubleshooting

### GitHub Integration Issues

**Commits not appearing in Linear:**
- Verify commit message includes exact issue ID format: `SLHQ-X`
- Check repository is connected in Linear → GitHub settings
- Ensure GitHub app has repository access (reinstall if needed)

**PR status not updating:**
- Verify "Update status on PR merge" is enabled
- Check target status ("Done") exists in SLHQ workflow
- Review automation rules in Linear GitHub settings

**Branch name suggestions not working:**
- Refresh Linear issue page
- Verify GitHub integration shows "Connected"
- Try disconnecting and reconnecting repository

### Slack Integration Issues

**No notifications appearing:**
- Verify Slack integration enabled for SLHQ team
- Check #council-core is correctly configured
- Ensure Linear has permission to post (check app permissions)
- Verify Council Bot is member of #council-core

**Notifications too noisy:**
- Review enabled events in Slack integration settings
- Disable lower-priority events (labels, descriptions)
- Consider per-project overrides for fine-grained control

**@mentions not working:**
- Users must link Slack and Linear accounts
- In Linear: Settings → Account → Connected accounts → Slack
- Click "Connect" and authorize

### General Issues

**Integration disconnected:**
- Check OAuth token hasn't expired
- Reauthorize integration via Linear settings
- Verify GitHub/Slack app still installed

**Events not triggering:**
- Wait 1-2 minutes (there can be slight delay)
- Check Linear activity log for event
- Verify automation rules are enabled

---

## Post-Setup Verification Checklist

After completing all phases, verify:

- [ ] #council-core channel created and Council Bot invited
- [ ] Channel ID documented for future reference
- [ ] Linear GitHub app installed and authorized
- [ ] slack-hq repository connected to SLHQ team
- [ ] PR status automations configured (opened → In Review, merged → Done)
- [ ] Commit linking enabled (SLHQ-X pattern)
- [ ] Branch name suggestions working in Linear
- [ ] Linear Slack app installed and authorized
- [ ] SLHQ team connected to The Council workspace
- [ ] #council-core configured as notification channel
- [ ] Appropriate events enabled (status, comments, assignments, PRs)
- [ ] Noisy events disabled (issue creation, labels, descriptions)
- [ ] Test status change posted to Slack successfully
- [ ] Test comment notification worked
- [ ] Test assignment notification worked
- [ ] Verified issue creation is silent (no notification)
- [ ] Test commit appeared in Linear issue
- [ ] All documentation created by Claude Code

---

## Next Steps

Once manual setup is complete, respond to Claude Code with:

```
Linear integrations setup complete:
- GitHub integration: ✅ Enabled and tested
- Slack integration: ✅ Enabled and tested
- #council-core channel ID: [paste channel ID here]

Ready for automated documentation and testing.
```

Claude Code will then:
1. Create all documentation files
2. Perform additional automated tests
3. Update project documentation
4. Post announcement to #council-core
5. Complete SLHQ-4

---

## Maintenance

### Monthly Checks
- Verify integrations still show "Connected" in Linear
- Test notification delivery to #council-core
- Review event configuration for any noise issues

### After Major Updates
- Linear platform updates: Retest automations
- Slack workspace changes: Verify channel permissions
- GitHub repository changes: Reconnect if renamed/moved

### Team Onboarding
- New team members should link Slack ↔ Linear accounts
- Show new members #council-core and notification patterns
- Explain how to mute channel if notifications overwhelming

---

## Resources

- [Linear GitHub Integration Docs](https://linear.app/docs/github)
- [Linear Slack Integration Docs](https://linear.app/docs/slack)
- [GitHub Repository](https://github.com/IkechukwuAbuah/slack-hq)
- [Linear Workspace](https://linear.app/abuah/team/SLHQ)
- [Slack Workspace](https://app.slack.com/client/T068KC5GURY)
- [SLHQ-4 Issue](https://linear.app/abuah/issue/SLHQ-4)

---

**Status:** ⚠️ Awaiting manual setup completion
**Next:** Complete Phases 1-3 above, then notify Claude Code to proceed with automation
