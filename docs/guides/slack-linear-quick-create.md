---
title: "Slack → Linear Quick-Create Flow"
linear_id: SLHQ-11
type: guide
status: Active
created: 2025-11-02
updated: 2025-11-02
author: Claude
related: [SLHQ-14, SLHQ-15, SLHQ-3]
---

# Slack → Linear Quick-Create Flow

## Overview

This guide shows you how to create Linear issues directly from Slack in under 30 seconds. Use this workflow when a discussion in Slack identifies an action item that needs tracking.

**Time to create issue**: <30 seconds
**Required**: Linear + Slack integration (see SLHQ-14)

---

## Quick Reference Card

### Creating an Issue

```
In any Slack channel:
/linear create [title]

Example:
/linear create Fix login button alignment
```

### Common Commands

| Command | Purpose | Example |
|---------|---------|---------|
| `/linear create [title]` | Create new issue | `/linear create Update docs` |
| `/linear [issue-id]` | View issue details | `/linear SLHQ-15` |
| `/linear search [query]` | Search issues | `/linear search auth bug` |
| `/linear assign [issue] @user` | Assign issue | `/linear assign SLHQ-15 @kelvin` |
| `/linear comment [issue] [text]` | Add comment | `/linear comment SLHQ-15 In progress` |

---

## Step-by-Step: Create Issue from Slack

### Step 1: Identify Need in Conversation

**Scenario**: You're discussing something in Slack and realize it needs to be tracked.

**Example Slack Thread**:
```
@kelvin: The GitHub integration docs need updating with the new webhook URL
@claude: Good catch! We should track this.
```

### Step 2: Use `/linear create` Command

**In the same channel or thread**:
```
/linear create Update GitHub integration docs with new webhook URL
```

**What happens**:
1. Linear's Slack app opens a dialog
2. Pre-filled with your title
3. Shows optional fields: description, assignee, labels, project

### Step 3: Fill Optional Details (Recommended)

**In the Linear dialog**:
- **Team**: SLHQ (auto-selected)
- **Priority**: Leave default or set urgency
- **Project**: Select if part of larger initiative
- **Labels**: Add `area:docs`, `needs:human`, etc.
- **Description**: Add context from thread
- **Assignee**: Pick person or leave unassigned

**Pro tip**: You can skip optional fields and add them in Linear later.

### Step 4: Submit and Get Issue ID

**Click "Create Issue"**

**Linear responds in Slack**:
```
✅ Issue created: SLHQ-17
📋 Update GitHub integration docs with new webhook URL
🔗 https://linear.app/abuah/issue/SLHQ-17
```

### Step 5: Use Issue ID Everywhere

**Now reference in commits**:
```bash
git commit -m "docs(SLHQ-17): update webhook URL in integration guide"
```

**Reference in docs**:
```markdown
See SLHQ-17 for context on webhook changes.
```

**Total time**: 20-30 seconds ⚡

---

## Advanced Workflows

### Create Issue from Thread Message

**Use case**: Specific message in thread needs action

**Method**: React with emoji, then create issue

1. Find the message with actionable content
2. Click "More actions" (three dots)
3. Select "Create Linear issue from message"
4. Linear pre-fills description with message content
5. Adjust and submit

**Result**: Issue automatically links back to Slack message

---

### Create Issue with Labels

**Faster labeling at creation time**:

```
/linear create [title]
```

Then in dialog:
- Click "Labels" field
- Start typing: `area`, `ai`, `artifact`, `needs`
- Select from autocomplete
- Multiple labels OK

**Common label combinations**:
- Documentation: `area:docs`, `artifact:md`, `ai:claude`
- Infrastructure: `area:infra`, `area:ops`
- Urgent fix: `needs:human`, `priority:urgent`

---

### Assign During Creation

**Create and assign in one step**:

```
/linear create Fix broken test suite
```

In dialog:
- Click "Assignee" field
- Type name: `@kelvin`, `@claude`
- Select from list

**Or after creation**:
```
/linear assign SLHQ-17 @kelvin
```

---

### Link to Project/Epic

**If issue is part of larger work**:

```
/linear create Implement user search feature
```

In dialog:
- Click "Project" field
- Start typing project name
- Select from list

**Result**: Issue appears in project board, tracked in epic

---

## Integration with Slack Threads

### Pattern 1: Thread → Issue

**Scenario**: Long discussion concludes with action item

**Workflow**:
1. Discussion happens in thread
2. Last message: "Let's track this"
3. Someone runs `/linear create [summary]`
4. Include thread link in Linear description

**Linear Description**:
```markdown
Context from Slack thread:
https://yourworkspace.slack.com/archives/C123/p1234567890

## Summary
[Your summary of the discussion]

## Action Required
[What needs to be done]
```

---

### Pattern 2: Message → Issue → Task

**Scenario**: Someone shares idea, you convert to task

**Workflow**:
1. @mention shares idea: "We should add dark mode"
2. You: "Great idea! 👍"
3. You: `/linear create Add dark mode support`
4. React to original message with `:linear:` emoji
5. Post Linear link as thread reply

**Result**: Clear traceability from idea to implementation

---

### Pattern 3: Daily Standup → Issues

**Scenario**: Standup reveals blockers or new tasks

**Workflow in #standup channel**:
```
@kelvin: Blocked on API docs for new endpoint
→ /linear create Document new user search API endpoint

@designer: Need review on landing page mockups
→ /linear create Review landing page mockups

@engineer: Found bug in payment flow
→ /linear create Fix payment flow validation bug
```

**Result**: All action items captured with ownership

---

## Notifications and Updates

### What Gets Posted to Slack

**By default, these post to channel where integration is active**:

✅ **Always Posted**:
- Issue created
- Issue assigned to someone
- Issue status changed to "In Review" or "Done"
- High-priority issue created

⚠️ **Optional (configure in Linear settings)**:
- Every status change
- Every comment added
- Labels added/removed
- Issues moved between projects

❌ **Never Posted (too noisy)**:
- Issue title edited
- Issue description updated
- Estimate changed
- Low-priority changes

### Configuring Notifications

**In Linear > Settings > Integrations > Slack**:

1. Choose notification channel (e.g., `#council-core`)
2. Select notification triggers:
   - Status changes: ✅ Recommended
   - Comments: ✅ Recommended
   - Issue created: ❌ Too noisy
   - Assignments: ✅ Recommended
3. Save changes

**Recommended setup**:
- **#council-core**: Status changes, assignments, high-priority
- **#team-private**: All notifications for team issues
- **DMs**: Personal assignments and mentions

---

## Best Practices

### ✅ Do This

**Create issues early and often**:
- Conversation reveals action? Create issue immediately
- Don't wait to "think about it more" - capture now, refine later
- Better to have issue you close than lose track of work

**Use descriptive titles**:
```
✅ Good: "Fix login button misalignment on mobile Safari"
❌ Bad: "Fix bug"
```

**Add context in description**:
```markdown
## Problem
Login button overlaps with footer on iPhone 12/13

## Reproduction
1. Open app on iPhone 12 Safari
2. Navigate to login page
3. Scroll to bottom

## Expected
Button should be 20px above footer

## Slack Context
Discussion: https://workspace.slack.com/archives/C123/p456
```

**Link Slack and Linear**:
- Post Linear issue link back in Slack thread
- Include Slack thread URL in Linear description
- Maintains full context chain

**Use labels immediately**:
- Add appropriate labels at creation time
- Makes filtering and organization easier later
- Team can find issues by category

---

### ❌ Don't Do This

**Don't create issues for everything**:
```
❌ "Think about adding feature X someday"
❌ "Maybe we could improve Y"
✅ "Add feature X (MVP requirements defined)"
✅ "Improve Y performance (currently 2s, target 200ms)"
```

**Don't use vague titles**:
```
❌ "Fix thing"
❌ "Update stuff"
❌ "Do the task we discussed"
```

**Don't skip Linear ID in follow-ups**:
```
❌ Commit: "fixed the docs"
✅ Commit: "docs(SLHQ-17): update webhook URLs"
```

**Don't leave issues orphaned**:
- Always assign OR explicitly mark "needs assignment"
- Add to project if part of larger work
- Set realistic due date if time-sensitive

---

## Naming Conventions

### Issue Titles

**Format**: `[Action Verb] [Object] [Context]`

**Good Examples**:
- `Fix authentication timeout on Safari`
- `Add export CSV feature to reports dashboard`
- `Update Python dependencies to latest stable`
- `Document GitHub webhook configuration`
- `Refactor user service for better performance`

**Bad Examples**:
- `Bug` (no context)
- `Need to fix something` (vague)
- `The login thing we talked about` (assumes context)

---

### Labels

**Slack-HQ uses these label categories**:

**Area** (`area:*`):
- `area:docs` - Documentation tasks
- `area:infra` - Infrastructure and tooling
- `area:automation` - Automation and scripting
- `area:ops` - Operations and maintenance

**AI Agent** (`ai:*`):
- `ai:claude` - Task for Claude
- `ai:chatgpt` - Task for ChatGPT
- `ai:gemini` - Task for Gemini

**Artifact** (`artifact:*`):
- `artifact:md` - Produces markdown
- `artifact:docx` - Produces Word doc
- `artifact:pdf` - Produces PDF

**Special**:
- `needs:human` - Requires human decision/input
- `blocked` - Cannot proceed (describe blocker in description)

**Use in Slack**:
```
/linear create Document API endpoints
→ Add labels: area:docs, artifact:md, ai:claude
```

---

## Troubleshooting

### Problem: `/linear` Command Not Working

**Symptoms**: Slash command doesn't appear or errors

**Causes**:
1. Linear app not installed in workspace
2. Linear app not connected to team
3. You don't have permissions

**Solutions**:
```
1. Check if Linear is in app directory:
   Slack → Apps → Search "Linear"

2. Install if missing:
   Click "Add to Slack"
   Authorize Linear

3. Connect to team:
   Linear → Settings → Integrations → Slack
   Select your workspace
   Click "Connect"

4. Check permissions:
   Ask workspace admin to grant access
```

---

### Problem: Can't See SLHQ Team in Dialog

**Symptoms**: Wrong team or "Select a team" dropdown empty

**Cause**: Not a member of SLHQ team in Linear

**Solution**:
```
1. Open Linear web app
2. Click workspace icon (bottom left)
3. Select "Settings" → "Teams"
4. Find "SLHQ" team
5. Add yourself as member
6. Return to Slack, try again
```

---

### Problem: Issue Created But Not in Right Project

**Symptoms**: Issue exists but not showing in project board

**Solution**:
```
In Linear:
1. Open the issue (SLHQ-XX)
2. Click "Project" field (currently empty or wrong)
3. Select correct project
4. Save

Or in Slack:
/linear SLHQ-XX
Click "Edit in Linear" link
Update project field
```

---

### Problem: Notifications Too Noisy

**Symptoms**: Too many Linear updates in Slack

**Solution**:
```
1. Linear → Settings → Integrations → Slack
2. Click "Configure" next to your workspace
3. Uncheck notification types you don't want:
   - Uncheck "Issue created" (too many)
   - Keep "Status changed to In Review"
   - Keep "Status changed to Done"
   - Keep "High priority issue created"
4. Save changes
```

---

### Problem: Lost Track of Issue ID

**Symptoms**: Created issue but forgot ID

**Solution**:
```
In Slack:
/linear search [keywords from title]

Example:
/linear search webhook docs
→ Shows: SLHQ-17: Update GitHub integration docs

Or check Linear directly:
linear.app/abuah/team/SLHQ
View recent issues
```

---

## Examples

### Example 1: Bug Report from User Feedback

**Slack Context (#feedback channel)**:
```
@user: The export button doesn't work on the reports page
@support: Can reproduce. Clicking export does nothing, no error shown.
```

**Create Issue**:
```
/linear create Fix export button not working on reports page
```

**In Linear dialog, add**:
- **Labels**: `area:ops`, `needs:human` (for priority decision)
- **Priority**: High (affects users)
- **Description**:
  ```
  ## User Report
  User unable to export reports. Button click has no effect.

  ## Reproduction (confirmed by @support)
  1. Navigate to /reports
  2. Select any report
  3. Click "Export" button
  4. Nothing happens, no error

  ## Slack Thread
  https://workspace.slack.com/archives/C456/p789

  ## Impact
  Users cannot export data, blocking their workflow
  ```

**Result**: SLHQ-25 created, assigned, team notified

---

### Example 2: Feature Request from Meeting

**Slack Context (#council-core channel)**:
```
@pm: In today's planning meeting, we agreed to add bulk user import
@eng: I can start on this next week
@pm: Great, let's track it
```

**Create Issue**:
```
/linear create Add bulk user import via CSV upload
```

**In Linear dialog, add**:
- **Project**: Q1 User Management Improvements
- **Assignee**: @eng
- **Labels**: `area:infra`, `ai:claude` (for spec), `needs:human` (for UX review)
- **Description**:
  ```
  ## Feature Request
  Allow admins to import multiple users via CSV file upload

  ## Requirements (from planning meeting)
  - CSV format: email, name, role
  - Validate before import
  - Show preview with errors
  - Send welcome emails after import
  - Rollback if batch fails

  ## Meeting Notes
  https://workspace.slack.com/archives/C123/p456

  ## Success Criteria
  - Admin can upload 100 users in <5 seconds
  - Clear error messages for invalid data
  - Audit log of all imports
  ```

**Next steps**:
```
1. @claude creates spec: /docs/specs/SLHQ-25-bulk-user-import.md
2. @pm reviews spec
3. @eng implements after approval
4. Spec and issue both reference SLHQ-25
```

---

### Example 3: Documentation Improvement

**Slack Context (DM with @designer)**:
```
@designer: I tried following the onboarding docs and got confused at step 3
@you: Which part was unclear?
@designer: The screenshot shows old UI, and the button names changed
```

**Create Issue**:
```
/linear create Update onboarding docs with current UI screenshots
```

**In Linear dialog, add**:
- **Labels**: `area:docs`, `artifact:md`, `ai:claude`
- **Priority**: Medium
- **Assignee**: @you (or @claude for documentation tasks)
- **Description**:
  ```
  ## Problem
  Onboarding documentation has outdated screenshots showing old UI

  ## Changes Needed
  1. Replace screenshots in /docs/onboarding.md
  2. Update button names:
     - "Next Step" → "Continue"
     - "Complete Setup" → "Finish"
  3. Add notes about recent UI refresh

  ## User Feedback
  @designer got confused at step 3 due to mismatch

  ## Files to Update
  - /docs/onboarding.md
  - /docs/media/onboarding-step-*.png
  ```

**Result**: Quick fix that improves user experience

---

## Integration Examples

### With GitHub

**Workflow**: Issue → Commits → PR → Done

```bash
# 1. Create issue in Slack
/linear create Fix database connection leak

# Result: SLHQ-28 created

# 2. Create branch using Linear's suggested name
git checkout -b kelvin/slhq-28-fix-database-connection-leak

# 3. Make commits with Linear ID
git commit -m "fix(SLHQ-28): add connection pool cleanup"
git commit -m "test(SLHQ-28): verify connection release"

# 4. Push and create PR
git push -u origin kelvin/slhq-28-fix-database-connection-leak

# 5. PR title includes Linear ID
"fix(SLHQ-28): Fix database connection leak"

# 6. Merge PR → Linear automatically moves to "Done"
```

**Result**: Full traceability from Slack discussion to deployed fix

---

### With Notion

**Workflow**: Issue → Spec → Notion Knowledge Base

```
# 1. Create issue in Slack
/linear create Document REST API authentication flow

# Result: SLHQ-30 created

# 2. Claude creates spec
docs/specs/SLHQ-30-api-auth-flow.md

# 3. Spec synced to Notion
Notion database gets new entry:
- Title: "REST API Authentication Flow"
- Type: Spec
- Linear ID: SLHQ-30
- Status: Published
- Link: /docs/specs/SLHQ-30-api-auth-flow.md
```

**Result**: Documentation discoverable in Notion, source in Git

---

## Quick Win Patterns

### Pattern: "Yes, and let's track it"

**In any conversation**:
```
@teammate: We should update the error messages to be more helpful
@you: Yes! /linear create Improve error message clarity
```

**Time**: 10 seconds
**Benefit**: Idea captured, won't be forgotten

---

### Pattern: "Assign and forget"

**When you need to delegate**:
```
@you: /linear create Review security audit report
→ Assign to @security-lead
→ Add label: needs:human
→ Set due date: End of week
```

**Time**: 20 seconds
**Benefit**: Clear ownership, deadline set, off your plate

---

### Pattern: "Batch create from list"

**After meeting with multiple action items**:
```
/linear create Update deployment runbook
/linear create Fix staging environment SSL cert
/linear create Document new API rate limits
/linear create Schedule team retro for Q1
```

**Time**: 2 minutes for 4 issues
**Benefit**: Nothing falls through cracks

---

## Related Documents

### Setup and Configuration
- [SLHQ-14: Configure Linear + Slack Integration](/docs/tasks/initial-setup.md)
- [SLHQ-15: GitHub Linear Integration Guide](/docs/GITHUB-LINEAR-INTEGRATION.md)

### Process Documentation
- [Definition of Done](/docs/runbooks/definition-of-done.md)
- [Agents Registry](/agents/agents.md)
- [README: SSOT Policy](/README.md#single-source-of-truth-ssot-policy)

### Linear Resources
- [Linear Slack Integration Docs](https://linear.app/docs/slack)
- [Linear Keyboard Shortcuts](https://linear.app/shortcuts)

---

## Appendix: Command Reference

### Full Command List

```bash
# Issue Creation
/linear create [title]                    # Create new issue
/linear create-from-message              # Create from message context

# Issue Management
/linear [issue-id]                        # View issue details
/linear assign [issue-id] @user          # Assign issue
/linear unassign [issue-id]              # Remove assignee
/linear comment [issue-id] [text]        # Add comment
/linear close [issue-id]                 # Close issue

# Search and Discovery
/linear search [query]                    # Search all issues
/linear search assignee:me status:todo   # Advanced search
/linear my issues                         # Your assigned issues

# Project Management
/linear projects                          # List all projects
/linear project [name]                    # View project details
/linear cycles                            # List current cycles

# Shortcuts
/l                                        # Short form of /linear
```

### Keyboard Shortcuts (in Linear App)

```
c            Create new issue
/            Open command palette
cmd+k        Quick search
?            Show all shortcuts
```

---

**This guide enables anyone on the team to capture work items instantly, maintaining the connection between discussion and execution.**
