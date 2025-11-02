# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Status

This is a newly initialized project directory. No codebase exists yet.

## Getting Started

When development begins, this file should be updated to include:
- Build, test, and lint commands
- Development environment setup instructions
- High-level architecture decisions and patterns
- Any project-specific conventions or workflows

## Keeping Documentation Updated

This project uses a living documentation approach:

### Automatic Sync Check
Use `/sync-docs` to check if CLAUDE.md needs updates:
```bash
/sync-docs
```

This command:
- Analyzes recent git changes (past 7 days)
- Checks for structural/architectural changes
- Compares current state against CLAUDE.md
- Suggests specific, actionable updates
- Focuses on high-value information (commands, patterns, conventions)

### When to Run `/sync-docs`
- After major refactors
- When adding new architectural patterns
- After changing build/test tooling
- Before onboarding new team members
- Weekly during active development

### Documentation Philosophy
CLAUDE.md stays relevant by focusing on:
- **Commands** that aren't obvious (custom scripts, non-standard workflows)
- **Architecture patterns** that require reading multiple files to understand
- **Conventions** that aren't enforced by linters
- **Non-obvious decisions** that save future developers time

It avoids:
- Detailed folder structures (easily discovered)
- File-by-file listings
- Generic best practices
- Information that changes frequently
