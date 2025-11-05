# COMPREHENSIVE PROMPT: Complete SLHQ-4 - Enable Linear Integrations

**Issue:** [SLHQ-4](https://linear.app/abuah/issue/SLHQ-4/enable-linear-github-slack-integrations)
**Author:** Claude Code (session-tracker-2)
**Created:** 2025-11-03
**Status:** Ready for execution
**Estimated Time:** 95 minutes
**Branch:** `kelvin/slhq-4-enable-linear-github-slack-integrations`

## 🎯 OBJECTIVE

Complete Linear issue **SLHQ-4** by enabling and configuring Linear integrations with GitHub and Slack to create seamless bidirectional workflows for issue tracking, PR management, and team notifications.

## 📋 CONTEXT

**Issue:** [SLHQ-4](https://linear.app/abuah/issue/SLHQ-4/enable-linear-github-slack-integrations)
**Branch:** `kelvin/slhq-4-enable-linear-github-slack-integrations`
**Status:** Backlog → In Progress → Done
**Project:** Slack-HQ Foundation & Setup
**Labels:** area:automation, area:ops

**Current State Analysis:**
- ✅ GitHub repository exists: [IkechukwuAbuah/slack-hq](https://github.com/IkechukwuAbuah/slack-hq)
- ✅ Linear workspace exists: SLHQ team
- ✅ Slack workspace exists: "The Council" (T068KC5GURY)
- ✅ Council Bot (Slack app) configured with comprehensive OAuth scopes
- ✅ Documentation exists for GitHub integration (docs/GITHUB-LINEAR-INTEGRATION.md)
- ❌ Linear → GitHub integration NOT YET ENABLED
- ❌ Linear → Slack integration NOT YET ENABLED
- ⚠️ Channel strategy needs clarification (#council-core vs existing channels)

**Channel Inventory:**
- Canonical: `#announcements` (C09Q8KCGM9C), `#council-core` (C09QAKDHKMG), `#council-ops` (C09Q761LJUD), `#engineering` (C09QAL92HFC)
- Workspace defaults: `#general` (C068K8VDXGB)
- Historical/Deprecated: `#2nd-brain` (C0684S1LTLP), `#random` (C0684RPSHCP)
- **Action needed:** Confirm `#council-core` exists and is connected to Linear notifications

## 📦 REQUIRED DELIVERABLES

### 1. GitHub Integration Setup

Enable Linear's GitHub integration to create bidirectional connection between issues and code.

**Configuration Steps:**

**A. Install Linear GitHub App**
1. Navigate to Linear Settings → Integrations → GitHub
2. Click "Install" and authorize Linear to access GitHub
3. Select repository: `IkechukwuAbuah/slack-hq`
4. Complete GitHub App installation

**B. Connect Repository**
1. In Linear, find `slack-hq` repository in GitHub integration settings
2. Click "Connect" to link repository to SLHQ team
3. Verify repository appears in Linear's connected repos list

**C. Configure Auto-Status Rules**

| GitHub Event | Linear Status Transition | Configuration |
|--------------|-------------------------|---------------|
| PR opened with `SLHQ-X` | → In Review | Enable "Set status when PR opened" |
| PR merged | → Done | Enable "Set status when PR merged" |
| PR closed (not merged) | No change | Keep current status |
| Commit with `SLHQ-X` | Add to issue | Enable "Link commits to issues" |

**D. Configure Branch Naming**

Verify format: `<username>/<issue-id>-<issue-title-slug>`
Example: `kelvin/slhq-4-enable-linear-github-slack-integrations`

### 2. Slack Integration Setup

**A. Channel Strategy Decision**

**DECISION NEEDED:** Create `#council-core` (recommended) for dedicated Linear notifications.

**B. Create #council-core Channel**
- Manual creation in Slack workspace "The Council"
- Description: "Linear issue tracking and automation notifications"
- Make public, invite Council Bot
- Note channel ID after creation

**C. Install Linear Slack Integration**
1. Navigate to Linear Settings → Integrations → Slack
2. Click "Add to Slack" and authorize
3. Select SLHQ team
4. Complete OAuth flow

**D. Configure Notification Settings**

**Enable:** Issue status changed, commented, assigned, priority changed, PR opened/merged
**Disable:** Issue created (too noisy), general updates, labeled, description changed

### 3. Integration Testing & Validation

**GitHub Tests:**
- Commit linking verification
- PR status update testing
- PR merge automation
- Branch name generation

**Slack Tests:**
- Status change notifications
- Comment notifications
- Assignment notifications
- PR event broadcasting
- Issue creation silence verification

## ✅ ACCEPTANCE CRITERIA

1. **✓ GitHub Integration Enabled**
   - [ ] Linear GitHub app installed
   - [ ] Repository connected
   - [ ] Commits link to issues
   - [ ] PRs update status
   - [ ] Branch suggestions work

2. **✓ Slack Integration Enabled**
   - [ ] #council-core created
   - [ ] SLHQ team connected
   - [ ] Status changes notify
   - [ ] Comments notify
   - [ ] Assignments notify
   - [ ] Issue creation silent

3. **✓ Integration Tests Pass**
   - [ ] Test commit appears
   - [ ] Test PR links
   - [ ] Status auto-updates
   - [ ] Slack notifications work

## 🚀 EXECUTION PLAN

### Phase 1: GitHub Integration (20 min)
1. Install Linear GitHub app
2. Connect slack-hq repository
3. Configure PR status automations
4. Test with commit and PR

### Phase 2: Channel Strategy (10 min)
5. Decide on #council-core
6. Create channel if needed
7. Invite Council Bot
8. Document decision

### Phase 3: Slack Integration (15 min)
9. Install Linear Slack app
10. Connect SLHQ team
11. Configure notifications
12. Enable/disable events

### Phase 4: Testing (20 min)
13. Test GitHub commit linking
14. Test PR integration
15. Test Slack notifications
16. Verify all functionality

### Phase 5: Documentation (20 min)
17. Create LINEAR-INTEGRATION-STATUS.md
18. Update CLAUDE.md
19. Update README.md
20. Create config backup

### Phase 6: Communication (10 min)
21. Post announcement to Slack
22. Update SLHQ-4 in Linear
23. Monitor for issues

**Total: 95 minutes**

## 📤 COMPLETION CHECKLIST

- [ ] Linear GitHub app installed
- [ ] GitHub automations configured
- [ ] #council-core created
- [ ] Linear Slack app installed
- [ ] Notifications configured
- [ ] All tests pass
- [ ] Documentation complete
- [ ] Team announcement posted
- [ ] SLHQ-4 updated to "Done"

## 🤖 AGENT INSTRUCTIONS

**Manual steps required:**
- Linear settings UI access (cannot be automated)
- Slack channel creation (if needed)
- OAuth authorization flows

**Execute methodically:**
- Use Linear MCP for issue updates
- Use Slack MCP for verification
- Document all decisions
- Test thoroughly before finalizing

---

**END OF PROMPT**
