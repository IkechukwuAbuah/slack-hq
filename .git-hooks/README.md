# Git Hooks

Optional git hooks for this project.

## Installation

To enable these hooks:

```bash
# Set git to use this hooks directory
git config core.hooksPath .git-hooks
```

## Available Hooks

### post-commit
Reminds you to run `/sync-docs` when:
- 15+ files are added/deleted/renamed in last 10 commits
- Build configuration files change (package.json, etc.)

This is non-blocking - just a helpful reminder.

## Disable

To disable:
```bash
git config --unset core.hooksPath
```
