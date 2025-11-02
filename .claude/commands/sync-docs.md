---
description: Check if CLAUDE.md needs updates based on project changes
tags: [project, documentation]
---

You are reviewing whether CLAUDE.md needs updates to stay current with the codebase.

## Your Task

1. **Check for structural changes:**
   - Look for package.json, requirements.txt, or other config files
   - Check if build/test/lint commands changed
   - Identify new major directories or architectural patterns

2. **Check git history (if available):**
   - Run `git log --oneline --since="7 days ago" --name-status` to see recent changes
   - Look for major refactors, new features, or tooling changes
   - Identify patterns: "Lots of files moved to new structure", "New testing framework", etc.

3. **Read current CLAUDE.md:**
   - Compare what's documented vs. what you found
   - Identify gaps: missing commands, outdated architecture notes, new conventions

4. **Make focused recommendations:**
   - Suggest specific additions/updates (don't rewrite the whole file)
   - Focus on high-value information that saves time
   - Keep recommendations brief and actionable

5. **Apply updates if user approves:**
   - Update CLAUDE.md with the agreed changes
   - Keep it concise (1-2 pages max)

## What to Look For

**High Priority:**
- Changed build/test/dev commands
- New architectural patterns (monorepo, microservices, etc.)
- Major dependency changes (framework migrations)
- New project conventions

**Medium Priority:**
- New feature areas that have non-obvious patterns
- Cross-cutting concerns (auth, state, API patterns)

**Low Priority (Usually Skip):**
- Minor file moves
- Individual component additions
- Small refactors

## Output Format

Provide a summary:
```
## Sync Status: [UP_TO_DATE | NEEDS_MINOR_UPDATES | NEEDS_MAJOR_UPDATES]

### Changes Detected:
- [List significant changes]

### Recommended Updates:
- [Specific suggestions]

Would you like me to update CLAUDE.md with these changes?
```
