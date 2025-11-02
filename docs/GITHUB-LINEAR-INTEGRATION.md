# GitHub ↔ Linear Integration Setup

**Task**: SLHQ-15
**Status**: Setup Complete - Integration Configuration Needed
**Date**: November 2, 2025

## Overview

This guide walks you through connecting your GitHub repository with Linear for seamless bidirectional integration.

## What's Already Done ✅

1. **Git Repository Initialized**
   - Local git repository created
   - Initial commit made with proper format

2. **GitHub Repository Created**
   - Repository: [IkechukwuAbuah/slack-hq](https://github.com/IkechukwuAbuah/slack-hq)
   - Description: "Enterprise workspace coordination and documentation system"
   - Public repository
   - Main branch established and pushed

3. **Commit Message Format Established**
   - Format: `<type>(SLHQ-<number>): <description>`
   - Examples already in repo:
     - `feat(SLHQ-13): initialize Slack-HQ repository`
     - `docs(SLHQ-15): add GitHub repository URL to README`

## What You Need to Do 🎯

### Step 1: Install Linear GitHub Integration

1. **Go to Linear Settings**
   - Open Linear: https://linear.app/ikechukwu-abuah
   - Click on your workspace icon (bottom left)
   - Select "Settings" → "Integrations"

2. **Find and Install GitHub Integration**
   - Scroll to "GitHub" in the integrations list
   - Click "Install" or "Add to workspace"
   - You'll be redirected to GitHub

3. **Authorize Linear on GitHub**
   - Sign in to GitHub if prompted
   - Click "Install" on the Linear GitHub App page
   - Select "Only select repositories"
   - Choose: `IkechukwuAbuah/slack-hq`
   - Click "Install"

4. **Complete Setup in Linear**
   - You'll be redirected back to Linear
   - The slack-hq repository should now appear
   - Click "Connect" next to the repository

### Step 2: Configure Integration Settings

In Linear's GitHub integration settings:

1. **Auto-link Issues**
   - Enable "Auto-link issues from commits"
   - Linear will detect patterns like `SLHQ-15` in commit messages

2. **PR Status Updates**
   - Enable "Update issue status when PR is merged"
   - Configure which status to set (recommend: "Done")

3. **Branch Naming**
   - Linear auto-generates branch names like:
     - `kelvin/slhq-15-connect-github-linear`
   - You can customize the format if desired

4. **Commit Patterns** (Default should work)
   - Linear recognizes: `SLHQ-\d+`
   - Also matches: `fixes SLHQ-15`, `closes #15`, etc.

### Step 3: Test the Integration

Let's verify everything works with a test commit:

```bash
# Make a small change to test
echo "\n## Integration Test\nTesting GitHub ↔ Linear integration." >> docs/GITHUB-LINEAR-INTEGRATION.md

# Commit with Linear issue reference
git add docs/GITHUB-LINEAR-INTEGRATION.md
git commit -m "test(SLHQ-15): verify GitHub Linear integration"
git push
```

**Expected Results:**
1. Commit appears in GitHub
2. SLHQ-15 in Linear shows:
   - Link to the commit in the "Git" section
   - Activity log entry: "Commit added by [your name]"
3. Click the commit link in Linear → opens GitHub commit

### Step 4: Test PR Integration

```bash
# Create a test branch using Linear's suggested name
git checkout -b kelvin/slhq-15-test-pr-integration

# Make a change
echo "PR integration test" >> docs/test-pr.md
git add docs/test-pr.md
git commit -m "test(SLHQ-15): test PR integration"
git push -u origin kelvin/slhq-15-test-pr-integration

# Create PR on GitHub
# Title: "test(SLHQ-15): test PR integration"
# Description: "Testing GitHub PR integration with Linear issue SLHQ-15"
```

**Expected Results:**
1. PR appears in SLHQ-15 under "Git" section
2. Merge the PR → SLHQ-15 status updates automatically
3. Can click PR link from Linear → opens GitHub PR

## Integration Features

Once configured, you'll have:

### 1. Commit Linking
Every commit with `SLHQ-XX` in the message:
- Appears in Linear issue's Git section
- Shows commit hash, message, author
- Links directly to GitHub commit

### 2. PR Integration
PRs referencing Linear issues:
- Show up in issue's Git section
- Display PR status (open, merged, closed)
- Link to GitHub PR page
- Auto-update issue status on merge

### 3. Branch Management
Linear provides suggested branch names:
- Format: `kelvin/slhq-XX-issue-title-slug`
- Copy directly from Linear issue view
- Maintains naming consistency

### 4. Activity Tracking
All Git activity logged in Linear:
- Commit added/removed
- PR opened/merged/closed
- Branch created/deleted
- Full audit trail

## Commit Message Best Practices

### Format
```
<type>(SLHQ-<number>): <description>

[optional body]

[optional footer]
```

### Types
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `chore`: Maintenance tasks
- `refactor`: Code refactoring
- `test`: Adding/updating tests
- `style`: Formatting changes

### Examples
```bash
# Simple commit
git commit -m "feat(SLHQ-20): add user authentication module"

# With body
git commit -m "fix(SLHQ-21): resolve database connection timeout

Added retry logic with exponential backoff.
Increased connection pool size to 20."

# Multiple issues
git commit -m "refactor(SLHQ-15, SLHQ-22): update integration docs"

# Closing an issue
git commit -m "fix(SLHQ-23): resolve login bug

Fixes SLHQ-23"
```

## Verification Checklist

After completing setup:

- [ ] GitHub app installed in repository
- [ ] Repository connected in Linear settings
- [ ] Test commit shows in Linear issue
- [ ] Test PR shows in Linear issue
- [ ] Commit links open GitHub from Linear
- [ ] PR merge updates Linear issue status
- [ ] Branch naming format works
- [ ] Integration shows in SLHQ-15 activity

## Troubleshooting

### Commits Not Appearing in Linear
- Check commit message includes exact issue ID (e.g., `SLHQ-15`)
- Verify integration is enabled in Linear settings
- Repository might need to be reconnected

### PR Not Linking
- Ensure PR title or description includes issue ID
- Check that GitHub app has repository access
- Verify PR is against the connected repository

### Status Not Auto-Updating
- Check "Update issue status on PR merge" is enabled
- Verify target status exists in your workflow
- May need to manually configure status mapping

## Next Steps

After confirming integration works:

1. **Update SLHQ-15 to Done** in Linear
2. **Move to SLHQ-14**: Configure Linear + Slack integration
3. **Document any custom settings** you configured
4. **Share integration patterns** with team

## Resources

- [Linear GitHub Integration Docs](https://linear.app/docs/github)
- [GitHub Repository](https://github.com/IkechukwuAbuah/slack-hq)
- [Linear Workspace](https://linear.app/ikechukwu-abuah/team/SLHQ)
- [SLHQ-15 Issue](https://linear.app/abuah/issue/SLHQ-15)

---

**Status**: Ready for manual integration setup
**Last Updated**: November 2, 2025
