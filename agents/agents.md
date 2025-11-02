# Agent Worker Registry

This document defines all AI agents/workers in the Slack HQ system, their responsibilities, prompts, and handoff protocols.

## Registry Overview

| Agent | Role | Primary Tasks | Handoff To |
|-------|------|---------------|------------|
| **Claude** | Documentation & Coordination | Specs, ADRs, markdown docs, agent orchestration | Gemini (analysis), Codex (implementation) |
| **Gemini** | Codebase Analysis | Large-scale code analysis, pattern detection, architecture review | Claude (docs), Codex (fixes) |
| **Codex** | Implementation | Feature development, bug fixes, test writing, refactoring | Claude (documentation) |
| **Cursor** | Interactive Development | Iterative coding, debugging sessions, exploratory work | Claude (finalization) |

---

## Agent Definitions

### Claude (Documentation Lead)

**Purpose**: Orchestrate multi-agent workflows, produce all documentation artifacts, maintain SSOT

**Capabilities**:
- Write and maintain all `.md` files
- Create specs, ADRs, runbooks from templates
- Coordinate handoffs between agents
- Track Linear issue IDs
- Enforce markdown-first policy

**Standard Prompt**:
```
Task: [Description]
Context: [Relevant background]
Linear ID: LIN-XXX
Output: [spec.md | adr.md | runbook.md]
Requirements:
- Follow /docs/templates/[type].md structure
- Include Linear ID in header
- Use markdown formatting
- Link to related artifacts
```

**Handoff Rules**:
- **To Gemini**: When needing large codebase analysis (100+ files)
- **To Codex**: When implementation is ready (spec approved, Linear created)
- **To Cursor**: When interactive exploration needed
- **From any agent**: Receives results and documents them in markdown

**Output Contract**:
- All outputs in `.md` format
- Linear ID in header metadata
- Follows template structure
- Cross-references related docs
- Committed to `/docs/[specs|adrs|runbooks]/`

---

### Gemini (Analysis Specialist)

**Purpose**: Large-scale codebase analysis with massive context window

**Capabilities**:
- Scan entire codebases (1000+ files)
- Pattern detection across multiple files
- Architecture visualization
- Dependency analysis
- Code quality assessment

**Standard Prompt**:
```
Analyze: [scope description]
Focus: [specific concerns]
Context files: @src/ @lib/ @tests/
Output format: Structured markdown report
Deliverables:
- Key findings
- Patterns identified
- Recommendations
- Risk areas
```

**Handoff Rules**:
- **From Claude**: Receives analysis requests with context
- **To Claude**: Returns markdown report for documentation
- **To Codex**: If immediate fixes needed, includes fix plan

**Output Format**:
```markdown
# Analysis Report: [Topic]
Linear ID: LIN-XXX
Date: YYYY-MM-DD

## Executive Summary
[High-level findings]

## Findings
### [Category 1]
- Finding 1
- Finding 2

## Recommendations
1. [Action item]
2. [Action item]

## Risk Assessment
- High: [items]
- Medium: [items]
- Low: [items]
```

---

### Codex (Implementation Engine)

**Purpose**: Autonomous code implementation with reasoning and sandboxed execution

**Capabilities**:
- Feature implementation
- Bug fixes with root cause analysis
- Test-driven development
- Refactoring operations
- CI/CD automation

**Standard Prompt**:
```
Implement: [feature/fix description]
Linear ID: LIN-XXX
Spec: /docs/specs/feature-name.md
Requirements:
- Follow TDD: write tests first
- Use approval mode: [untrusted|on-failure|full-auto]
- Include comprehensive error handling
- Update documentation
- Run test suite before completion
```

**Handoff Rules**:
- **From Claude**: Receives approved spec with Linear ID
- **To Claude**: Returns implementation summary for documentation
- **Approval Modes**:
  - `untrusted`: For experimental/risky changes
  - `on-failure`: For standard development
  - `full-auto`: For safe, well-defined tasks

**Output Requirements**:
- All tests passing
- Code follows project conventions
- Linear ID in commit messages
- Summary for Claude to document

**Example Command Flow**:
```bash
# Claude hands off to Codex
codex exec "Implement feature per /docs/specs/LIN-123-auth.md"

# Codex returns summary
# Claude documents in Linear and updates spec status
```

---

### Cursor (Interactive Developer)

**Purpose**: Interactive development sessions with conversation memory

**Capabilities**:
- Iterative development
- Debugging sessions
- Exploratory coding
- Context-aware refactoring
- Project rules integration

**Standard Prompt**:
```
Session: [task description]
Linear ID: LIN-XXX
Context: @file @directory
Mode: interactive
Goal: [end state description]
Constraints:
- Follow .cursor/rules
- Maintain test coverage
- Document major decisions
```

**Handoff Rules**:
- **From Claude**: Receives tasks needing iteration/exploration
- **To Claude**: Ends session with summary for documentation
- **Use `cursor-agent resume`**: To continue previous sessions

**Session Patterns**:

1. **Exploration Mode**:
```bash
cursor-agent "explore authentication implementation and suggest improvements"
# Interactive back-and-forth
# When done, summarize for Claude
```

2. **Iterative Development**:
```bash
cursor-agent "implement user service"
# Make changes
# Review results
cursor-agent resume  # Continue
# Repeat until complete
```

3. **Debugging**:
```bash
cursor-agent "debug: API returns 500 on POST /users"
# Investigate
# Fix
# Verify
```

**Output Protocol**:
- Session transcripts saved
- Final summary provided to Claude
- Claude documents in appropriate markdown format

---

## Handoff Protocols

### Protocol 1: Spec → Implementation

```
1. Claude creates spec from template
   - Uses /docs/templates/spec.md
   - Creates Linear issue
   - Adds Linear ID to spec header

2. Spec review and approval
   - Stakeholder sign-off
   - Linear issue status: "Ready for Dev"

3. Claude hands off to implementation agent
   Choice A: Codex for autonomous implementation
   Choice B: Cursor for interactive development

4. Implementation agent completes work
   - Tests passing
   - Code committed
   - Linear issue updated

5. Claude documents results
   - Updates spec with implementation notes
   - Creates runbook if needed
   - Closes Linear issue
```

### Protocol 2: Bug Fix Flow

```
1. Bug reported in Linear (LIN-XXX)

2. Claude assigns to appropriate agent:
   - Simple bug → Codex (full-auto)
   - Complex bug → Cursor (interactive debugging)
   - Architectural issue → Gemini (analysis) → Codex (fix)

3. Agent completes fix
   - Tests added/updated
   - Root cause documented
   - Returns to Claude

4. Claude creates postmortem if needed
   - Uses /docs/templates/runbook.md
   - Documents fix and prevention
   - Updates Linear with resolution
```

### Protocol 3: Large Refactoring

```
1. Claude creates ADR for architectural change
   - Uses /docs/templates/adr.md
   - Captures decision rationale
   - Creates Linear epic

2. Gemini analyzes current state
   - Scans affected files
   - Identifies dependencies
   - Creates migration plan

3. Claude documents migration plan
   - Creates spec from analysis
   - Breaks into Linear sub-tasks

4. Codex executes migration
   - Step-by-step with approval points
   - Tests at each checkpoint
   - Progressive rollout

5. Claude creates runbook
   - Operational procedures
   - Rollback plan
   - Monitoring guidelines
```

---

## Agent Selection Guide

**Use Claude when**:
- Creating or updating documentation
- Coordinating multi-agent workflows
- Enforcing SSOT policy
- Reviewing and approving changes
- Maintaining project structure

**Use Gemini when**:
- Analyzing 100+ files at once
- Understanding large-scale architecture
- Finding patterns across codebase
- Assessing code quality holistically
- Pre-refactoring analysis

**Use Codex when**:
- Implementing approved specs
- Fixing bugs autonomously
- Running TDD workflows
- Automating repetitive tasks
- CI/CD pipeline execution

**Use Cursor when**:
- Exploring unfamiliar code
- Debugging complex issues
- Iterative development
- Trying multiple approaches
- Learning codebase interactively

---

## Communication Standards

### All Agents Must:
1. Reference Linear IDs in all outputs
2. Produce markdown-formatted summaries
3. Follow project conventions in `/CLAUDE.md`
4. Hand off cleanly to next agent
5. Update status in Linear

### Handoff Checklist:
- [ ] Linear issue ID provided
- [ ] Context files/docs linked
- [ ] Success criteria defined
- [ ] Output format specified
- [ ] Next steps clear

### Status Updates:
- Use Linear comments for progress
- Tag relevant stakeholders
- Include links to commits/PRs
- Summarize key decisions
- Flag blockers immediately

---

## Emergency Protocols

### Critical Bug
1. Create Linear P0 issue immediately
2. Claude assigns to Codex (full-auto mode disabled)
3. Codex analyzes and proposes fix
4. Manual review required before applying
5. Claude documents incident

### System Outage
1. Escalate to humans immediately
2. Claude coordinates diagnosis (Gemini analysis)
3. Human approval for any changes
4. Post-incident: Claude creates detailed runbook

### Data Loss Risk
1. STOP all automated operations
2. Human review required
3. Backup verification
4. Manual execution only

---

## Version History

- **v1.0** (2025-11-02): Initial registry structure
- Updates: Add new agents/protocols as they're proven

---

## Related Documentation

- `/agents/claude.md` - Claude-specific instructions
- `/docs/templates/` - All document templates
- `/CLAUDE.md` - Project-wide Claude instructions
- `README.md` - SSOT policy and project overview
