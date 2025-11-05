# Agent Prompts Library

This directory stores reusable prompts for common workflows and tasks across all AI agents in The Council workspace.

## Purpose

The prompts library provides:
- **Reusable templates** for common tasks
- **Consistent workflows** across different AI agents
- **Best practices** encoded as prompts
- **Quick start guides** for complex operations

**Key principle:** Don't reinvent the wheel - use proven prompts that work.

## Organization

Prompts are organized by category and task type:

```
agents/prompts/
├── README.md               # This file
├── development/            # Software development prompts
│   ├── code-review.md
│   ├── refactoring.md
│   ├── testing.md
│   └── debugging.md
├── documentation/          # Documentation prompts
│   ├── spec-writing.md
│   ├── adr-creation.md
│   ├── runbook-writing.md
│   └── api-docs.md
├── operations/             # Operational prompts
│   ├── deployment.md
│   ├── monitoring.md
│   ├── incident-response.md
│   └── performance-tuning.md
└── coordination/           # Multi-agent coordination
    ├── handoff-protocol.md
    ├── session-tracking.md
    ├── council-updates.md
    └── collaboration.md
```

**Note:** Subdirectories and prompts will be created as needed. Use this README as a guide for structure.

## How to Use

### For AI Agents

When starting a task, check if a relevant prompt exists:

```bash
# List available prompts
ls -R agents/prompts/

# Read a prompt
cat agents/prompts/development/code-review.md

# Use the prompt template
# (Copy relevant sections to your current task)
```

### For Developers

Reference prompts when instructing agents:

```bash
# Direct reference
"Use the code review prompt from agents/prompts/development/code-review.md"

# Inline guidance
"Follow the code review checklist defined in our prompts library"
```

## Prompt Structure

Each prompt should follow this structure:

```markdown
# [Task Name] Prompt

## Purpose
Brief description of what this prompt accomplishes

## When to Use
- Scenario 1
- Scenario 2
- Scenario 3

## Prerequisites
- Required context
- Tools needed
- Permissions required

## Prompt Template

[Full prompt text here]

## Example Usage

[Concrete example with inputs and expected outputs]

## Best Practices
- Tip 1
- Tip 2
- Tip 3

## Common Issues
- Issue 1: Solution
- Issue 2: Solution

## Related Prompts
- Link to related prompt 1
- Link to related prompt 2
```

## Categories

### Development Prompts
**Focus:** Code quality, testing, debugging, refactoring

**Example prompts:**
- Code review checklist
- Test-driven development workflow
- Debugging systematic approach
- Refactoring patterns
- Security audit steps

### Documentation Prompts
**Focus:** Writing specifications, ADRs, runbooks, API docs

**Example prompts:**
- Feature specification template
- ADR creation workflow
- Runbook writing guide
- API documentation standards
- README generation

### Operations Prompts
**Focus:** Deployment, monitoring, incident response

**Example prompts:**
- Deployment checklist
- Monitoring setup
- Incident response protocol
- Performance investigation
- Infrastructure changes

### Coordination Prompts
**Focus:** Multi-agent collaboration, handoffs, updates

**Example prompts:**
- Agent handoff protocol
- Session tracking workflow
- Council update format
- Collaboration patterns
- Status reporting

## Creating New Prompts

### When to Create a Prompt

Create a new prompt when:
- **Workflow is repeatable** - Same steps for similar tasks
- **Multiple agents need it** - Not agent-specific
- **Best practices identified** - Proven effective approach
- **Complexity warrants it** - Multi-step or intricate process

### How to Create a Prompt

1. **Identify the need**
   - What task is this prompt for?
   - Who will use it?
   - What problem does it solve?

2. **Write the prompt**
   - Follow the prompt structure template
   - Include concrete examples
   - Add troubleshooting tips

3. **Test the prompt**
   - Use it for a real task
   - Refine based on results
   - Get feedback from other agents

4. **Document and organize**
   - Choose appropriate category
   - Link related prompts
   - Update this README if needed

### Example Creation Workflow

```bash
# 1. Create new prompt file
touch agents/prompts/development/tdd-workflow.md

# 2. Write prompt using template
# (Edit agents/prompts/development/tdd-workflow.md)

# 3. Test the prompt
# (Use in a real TDD task)

# 4. Refine based on experience
# (Update prompt with learnings)

# 5. Commit to repository
git add agents/prompts/development/tdd-workflow.md
git commit -m "feat(prompts): add TDD workflow prompt"
```

## Integration with Agents

### Claude Code

```bash
# Reference prompt in task
"Follow the code review prompt from agents/prompts/development/"

# Or copy prompt content directly
cat agents/prompts/development/code-review.md
# (Use content in current task)
```

### ChatGPT

```
When I ask you to review code, always follow the checklist in:
/agents/prompts/development/code-review.md

Use this as your standard operating procedure.
```

### Other Agents

All agents have access to the repository and can read prompts:

```bash
# Gemini CLI
gemini -p "@agents/prompts/development/code-review.md Review this codebase"

# Cursor CLI
cursor-agent "@agents/prompts/development/ Show me available prompts"

# Codex CLI
codex exec "Use the testing prompt to create comprehensive tests"
```

## Best Practices

### 1. Keep Prompts Focused
Each prompt should address one task or workflow:
```
✅ Good: "Code Review Checklist"
❌ Bad: "Code Review, Testing, and Deployment Guide"
```

### 2. Include Examples
Always provide concrete examples:
```markdown
## Example Usage

**Input:** Feature X needs code review

**Process:**
1. Check for security vulnerabilities
2. Verify test coverage > 80%
3. Review error handling

**Output:** Detailed review with actionable feedback
```

### 3. Link Related Prompts
Create a web of interconnected prompts:
```markdown
## Related Prompts
- [Testing Workflow](../development/testing.md)
- [Security Audit](../development/security-audit.md)
```

### 4. Update Based on Experience
Prompts are living documents:
```bash
# After using a prompt, update it
# Add learnings, fix issues, improve clarity
```

### 5. Version Control
Track prompt changes like code:
```bash
git commit -m "refactor(prompts): improve code review checklist based on findings"
```

## Common Patterns

### Pattern 1: Checklist Prompt
**Use for:** Step-by-step procedures
```markdown
# Code Review Checklist

- [ ] Security vulnerabilities checked
- [ ] Test coverage verified
- [ ] Error handling reviewed
- [ ] Documentation updated
```

### Pattern 2: Workflow Prompt
**Use for:** Multi-stage processes
```markdown
# TDD Workflow

## Phase 1: Red
1. Write failing test
2. Verify test fails

## Phase 2: Green
3. Write minimal code to pass
4. Run tests

## Phase 3: Refactor
5. Improve code quality
6. Keep tests passing
```

### Pattern 3: Template Prompt
**Use for:** Document generation
```markdown
# Feature Specification Template

## Overview
[Brief description]

## Requirements
- Functional requirement 1
- Functional requirement 2

## Success Criteria
- Criterion 1
- Criterion 2
```

### Pattern 4: Investigation Prompt
**Use for:** Debugging and analysis
```markdown
# Performance Investigation Prompt

## 1. Identify Symptoms
- What is slow?
- When does it occur?

## 2. Gather Data
- Profile execution
- Check resource usage

## 3. Hypothesize Root Cause
- Theory 1
- Theory 2

## 4. Test Hypothesis
- Experiment 1
- Experiment 2

## 5. Implement Fix
- Solution
- Verification
```

## Maintenance

### Regular Review
Review prompts quarterly:
- [ ] Are they still relevant?
- [ ] Have best practices changed?
- [ ] Do examples need updating?
- [ ] Are new prompts needed?

### Cleanup Policy
Remove prompts when:
- No longer used for 6+ months
- Superseded by better approach
- Workflow fundamentally changed
- Agent-specific (move to agent docs)

### Versioning
Track major changes to prompts:
```markdown
# Code Review Prompt (v2.0)

**Changelog:**
- v2.0 (2025-11-03): Added security focus
- v1.1 (2025-10-15): Improved checklist
- v1.0 (2025-09-01): Initial version
```

## Examples

### Example 1: Session Tracking Prompt

```markdown
# Session Tracking Prompt

## Purpose
Start and manage work sessions with proper tracking and Slack updates.

## When to Use
- Beginning significant work
- Multi-agent coordination needed
- Council visibility required

## Prompt Template

Start a new session:
/session-start "[Brief task description]" --auto-post --channel #announcements

Log work as you go:
- Code changes
- Analysis performed
- Decisions made

Complete session:
/session-stop --notes "[Summary of work]" --post

## Example Usage

/session-start "Implement OAuth authentication" --auto-post
# ... work happens ...
/session-stop --notes "OAuth implemented with tests, ready for review" --post
```

### Example 2: Code Review Prompt

```markdown
# Code Review Prompt

## Purpose
Systematic code review covering security, quality, and maintainability.

## Checklist

### Security
- [ ] No SQL injection vulnerabilities
- [ ] No XSS vulnerabilities
- [ ] Input validation present
- [ ] Authentication/authorization correct

### Quality
- [ ] Test coverage > 80%
- [ ] Error handling comprehensive
- [ ] Code style consistent
- [ ] No code smells

### Maintainability
- [ ] Documentation updated
- [ ] Complex logic explained
- [ ] Dependencies justified
- [ ] No technical debt added

## Example Usage

Review PR #42:
- Run through checklist
- Document findings
- Suggest improvements
- Approve or request changes
```

## Available Operational Templates

### Reference Audit & Cleanup Template
**File:** `reference-audit-cleanup.md`
**Created:** 2025-11-04
**Type:** Reusable Template
**Estimated Time:** 1-3 hours (depending on scope)

**Purpose:**
Comprehensive template for auditing and updating any type of reference across a codebase (API endpoints, channel IDs, service URLs, config keys, etc.). Includes discovery, validation, surgical updates, artifact archival, and clean reference document creation.

**Key Components:**
- Pattern-based discovery and search
- File categorization (active vs. historical)
- Surgical update strategies
- Historical record preservation
- Artifact management and archival
- Single source of truth creation

**Use when:**
- Migrating API endpoints or service URLs
- Updating channel IDs or integration references
- Rotating authentication tokens or keys
- Cleaning up deprecated configuration
- Consolidating scattered reference documentation
- After major infrastructure changes

**Customization:**
Replace bracketed placeholders (`[REFERENCE_TYPE]`, `[PATTERN]`, etc.) with your specific context. Template is language and framework agnostic.

---

## Available Linear Issue Execution Prompts

### SLHQ-2: Complete Repository Structure & Templates
**File:** `SLHQ-2-complete-repo-structure.md`
**Created:** 2025-11-03
**Status:** Ready for execution
**Estimated Time:** 60 minutes

**Purpose:**
Comprehensive prompt for finalizing slack-hq repository structure, creating missing directories (`/artifacts`, `/agents/prompts`, `/agents/registry`), writing documentation, and updating README with complete directory tree.

**Key Components:**
- Directory creation with .gitignore strategy
- README files for all new directories
- Root README.md enhancement
- Template validation
- Phased execution plan

**Use when:**
- Setting up new project structures
- Organizing documentation systems
- Establishing artifact management
- Creating reusable templates

### SLHQ-4: Enable Linear Integrations (GitHub + Slack)
**File:** `SLHQ-4-enable-linear-integrations.md`
**Created:** 2025-11-03
**Status:** Ready for execution
**Estimated Time:** 95 minutes

**Purpose:**
Complete guide for enabling and configuring Linear's GitHub and Slack integrations, including automated status updates, PR linking, and notification management.

**Key Components:**
- GitHub integration setup (PR → status automation)
- Slack integration setup (notification configuration)
- Channel strategy decision framework
- Comprehensive testing procedures
- Configuration backup documentation

**Use when:**
- Setting up Linear in new workspaces
- Configuring integrations for repositories
- Establishing automation workflows
- Creating team notification systems

**Manual Steps Required:**
- Linear settings UI access
- Slack channel creation (if needed)
- OAuth authorization flows

## Related Documentation

- [agents/agents.md](../agents.md) - Agent coordination guide
- [agents/registry/README.md](../registry/README.md) - Agent registry
- [docs/templates/](../../docs/templates/) - Document templates
- [CLAUDE.md](../../CLAUDE.md) - Project guidelines

---

**Remember:** Great prompts capture best practices and make them reusable. Create prompts for any workflow you repeat more than twice.

**Last Updated:** 2025-11-03
