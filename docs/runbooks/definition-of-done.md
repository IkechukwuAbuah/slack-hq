---
title: "Runbook: Definition of Done (DoD)"
linear_id: SLHQ-12
type: runbook
status: Active
created: 2025-11-02
updated: 2025-11-02
author: Claude
related: [SLHQ-3, SLHQ-10, /agents/agents.md, /agents/claude.md]
on_call: All Contributors
severity_levels: []
---

# Runbook: Definition of Done (DoD)

## Quick Reference

| Property | Value |
|----------|-------|
| **Purpose** | Define completion criteria for all Slack-HQ work items |
| **Applies To** | All Linear issues, specs, ADRs, runbooks, and code changes |
| **Owner** | All Contributors |
| **Version** | 1.0 |
| **Last Review** | 2025-11-02 |

---

## Overview

### Purpose

The Definition of Done ensures consistent quality across all Slack-HQ deliverables. Every Linear issue, documentation artifact, and code change must meet these criteria before being marked "Done".

### Core Principles

1. **Markdown is Source of Truth** - All documentation lives in version-controlled `.md` files
2. **Linear ID Traceability** - Every artifact references its Linear issue
3. **Template Adherence** - Use provided templates for consistency
4. **Quality Over Speed** - Complete work properly the first time
5. **Documentation is Required** - No work is done without documentation

---

## Universal DoD Checklist

**Every item marked "Done" in Linear must satisfy ALL of these:**

### Documentation
- [ ] Linear issue ID included in all artifacts
- [ ] All relevant documentation updated (specs, runbooks, ADRs)
- [ ] Markdown files follow template structure
- [ ] Files saved in correct directory (/docs/specs, /docs/adrs, /docs/runbooks)
- [ ] Cross-references to related documents included
- [ ] Commit messages follow format: `<type>(SLHQ-XXX): description`

### Quality
- [ ] Acceptance criteria (from Linear issue) fully met
- [ ] No placeholder text or TODOs in deliverables
- [ ] Grammar and spelling checked
- [ ] Code blocks include language identifiers for syntax highlighting
- [ ] Links verified and working

### Review
- [ ] Self-reviewed before marking done
- [ ] Peer review completed (if applicable)
- [ ] Feedback addressed and incorporated

### Traceability
- [ ] Linear issue status updated to "Done"
- [ ] Links to deliverables added in Linear comments
- [ ] Related issues cross-referenced
- [ ] Git commits linked to Linear issue

### Cleanup
- [ ] No temporary files left behind
- [ ] Test artifacts removed (unless intentionally kept)
- [ ] Working directory clean (`git status` shows only intended changes)

---

## Type-Specific DoD

### Specifications (docs/specs/SLHQ-XXX-name.md)

**In addition to Universal DoD:**

- [ ] Created from `/docs/templates/spec.md`
- [ ] Filename: `SLHQ-XXX-descriptive-name.md`
- [ ] All template sections completed:
  - [ ] Overview
  - [ ] Requirements
  - [ ] Technical Approach
  - [ ] Implementation Plan
  - [ ] Success Criteria
- [ ] Linear ID in YAML frontmatter
- [ ] Status field indicates: draft | review | approved | implemented
- [ ] Related documents linked in frontmatter
- [ ] Acceptance criteria clearly defined and measurable

**Example**:
```markdown
---
title: User Authentication System
linear_id: SLHQ-123
type: spec
status: approved
created: 2025-11-02
updated: 2025-11-02
author: Claude
related: [SLHQ-100, /docs/adrs/004-use-jwt.md]
---

# User Authentication System

[Fully completed spec following template...]
```

### Architecture Decision Records (docs/adrs/NNN-name.md)

**In addition to Universal DoD:**

- [ ] Created from `/docs/templates/adr.md`
- [ ] Filename: `NNN-decision-title.md` (sequential numbering)
- [ ] All ADR sections completed:
  - [ ] Status (Proposed | Accepted | Deprecated | Superseded)
  - [ ] Context
  - [ ] Decision
  - [ ] Consequences
  - [ ] Alternatives Considered
- [ ] Related Linear issues referenced
- [ ] Decision rationale clearly explained
- [ ] Trade-offs documented
- [ ] Impact assessment included

**Example**:
```markdown
---
title: Use PostgreSQL for Primary Database
linear_id: SLHQ-145
type: adr
status: Accepted
created: 2025-11-02
updated: 2025-11-02
author: Claude
related: [SLHQ-100, SLHQ-102]
---

# ADR 004: Use PostgreSQL for Primary Database

[Fully completed ADR following template...]
```

### Runbooks (docs/runbooks/topic.md)

**In addition to Universal DoD:**

- [ ] Created from `/docs/templates/runbook.md`
- [ ] Filename: `descriptive-topic-name.md`
- [ ] All runbook sections completed:
  - [ ] Quick Reference
  - [ ] Overview
  - [ ] Common Operations (with commands)
  - [ ] Troubleshooting Guide
  - [ ] Related Documents
- [ ] Commands tested and verified
- [ ] Step-by-step procedures clear and actionable
- [ ] Expected outputs documented
- [ ] Rollback procedures included (where applicable)

**Example**:
```markdown
---
title: "Runbook: GitHub Linear Integration Setup"
linear_id: SLHQ-15
type: runbook
status: Active
created: 2025-11-02
updated: 2025-11-02
author: Claude
related: [SLHQ-14, SLHQ-16]
---

# Runbook: GitHub Linear Integration Setup

[Fully completed runbook following template...]
```

### Code Changes (when applicable)

**In addition to Universal DoD:**

- [ ] All tests passing (unit, integration, e2e)
- [ ] Code follows project conventions
- [ ] Comments added for complex logic
- [ ] No console.log or debug statements
- [ ] Error handling implemented
- [ ] Security best practices followed
- [ ] Performance impact considered
- [ ] Commit message: `<type>(SLHQ-XXX): description`
- [ ] Linked spec or ADR exists for significant changes
- [ ] Runbook created for operational changes

**Commit Types**:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `chore`: Maintenance
- `refactor`: Code restructure
- `test`: Test changes
- `style`: Formatting

### Agent Handoffs

**When handing work between agents (Claude → Gemini/Codex/Cursor):**

- [ ] Handoff document includes:
  - [ ] Task description
  - [ ] Linear ID
  - [ ] Context documents linked
  - [ ] Expected output format
  - [ ] Success criteria
  - [ ] Return agent identified
- [ ] Context sufficient for agent to execute independently
- [ ] Success criteria measurable and clear

**When receiving work from agents:**

- [ ] Agent output documented
- [ ] Linear issue updated with summary
- [ ] Implementation artifacts linked
- [ ] Follow-up tasks created if needed

---

## Verification Procedures

### Self-Review Checklist

**Before marking anything "Done", verify:**

```bash
# 1. Check git status
git status

# Expected: Only intended changes staged/committed
# No test files, temporary artifacts, or unintended changes

# 2. Verify Linear ID in files
grep -r "linear_id: SLHQ-" docs/

# Expected: All new docs include Linear ID

# 3. Check commit messages
git log --oneline -5

# Expected: All follow format: type(SLHQ-XXX): description

# 4. Verify file locations
ls docs/specs/SLHQ-*
ls docs/adrs/*
ls docs/runbooks/*

# Expected: Files in correct directories with correct naming

# 5. Check for TODOs or placeholders
grep -r "TODO\|FIXME\|XXX\|placeholder" docs/ --exclude-dir=templates

# Expected: No TODOs in deliverables (only in templates)
```

### Peer Review Checklist

**For significant changes, reviewer should verify:**

- [ ] Acceptance criteria from Linear issue met
- [ ] Template structure followed correctly
- [ ] Writing is clear and understandable
- [ ] Technical accuracy verified
- [ ] All links working
- [ ] No obvious omissions
- [ ] Consistent with project standards

---

## Common DoD Violations

### ❌ Incomplete Work

**Problem**: Marking issue "Done" with sections still TODO or incomplete

**Impact**: Technical debt, confusion, wasted time

**Fix**:
```markdown
# Bad
## Requirements
TODO: Add requirements here

# Good
## Requirements
1. User must be able to authenticate with email/password
2. Session must persist for 24 hours
3. Rate limiting: max 5 login attempts per minute
```

**Prevention**: Use template as checklist, complete all sections before marking done

---

### ❌ Missing Linear ID

**Problem**: Creating documentation without Linear issue reference

**Impact**: Lost traceability, can't track why work was done

**Fix**:
```markdown
# Bad
---
title: User Authentication
type: spec
---

# Good
---
title: User Authentication
linear_id: SLHQ-123
type: spec
---
```

**Prevention**: Never start work without Linear ID, include in frontmatter

---

### ❌ Wrong File Location

**Problem**: Saving files in wrong directory or with wrong naming

**Impact**: Disorganized repository, hard to find documentation

**Fix**:
```bash
# Bad
/docs/user-auth-spec.md
/specs/SLHQ-123.md

# Good
/docs/specs/SLHQ-123-user-auth.md
```

**Prevention**: Follow naming conventions: `/docs/[type]/SLHQ-XXX-description.md`

---

### ❌ Poor Commit Messages

**Problem**: Vague or missing Linear ID in commits

**Impact**: Can't trace commits to requirements, hard to review history

**Fix**:
```bash
# Bad
git commit -m "updated docs"
git commit -m "fixes"

# Good
git commit -m "docs(SLHQ-123): add user authentication specification"
git commit -m "feat(SLHQ-124): implement JWT token generation"
```

**Prevention**: Always use format: `<type>(SLHQ-XXX): clear description`

---

### ❌ Leftover Test Files

**Problem**: Committing temporary test files or artifacts

**Impact**: Repository clutter, confusion about what's important

**Fix**:
```bash
# Check before committing
git status

# If test files present
git reset HEAD test-file.md
rm test-file.md

# Commit only intended changes
git add docs/specs/SLHQ-123-feature.md
git commit -m "docs(SLHQ-123): add feature specification"
```

**Prevention**: Review `git status` before every commit, use `.gitignore`

---

## Integration with Tools

### Linear Integration

**Issue Status Transitions**:

```
Backlog → Todo → In Progress → In Review → Done
                                         → Canceled
```

**DoD applies at**: `In Review → Done` transition

**Before marking Done in Linear**:
1. Verify Universal DoD checklist completed
2. Verify Type-Specific DoD completed
3. Add comment with links to deliverables
4. Update issue description if scope changed
5. Cross-reference related issues

**Linear Comment Template**:
```markdown
## Work Complete

**Deliverables**:
- Spec: /docs/specs/SLHQ-123-feature.md
- Implementation: commit abc123
- Tests: All passing ✓

**DoD Verification**:
- [x] All acceptance criteria met
- [x] Documentation complete
- [x] Tests passing
- [x] Reviewed and approved

**Related Issues**: SLHQ-100, SLHQ-102

Ready for Done ✓
```

### Git Integration

**Branch Naming** (if using branches):
```bash
# Linear suggests format:
kelvin/slhq-123-feature-name
```

**Commit Requirements**:
- Include Linear ID: `feat(SLHQ-123): description`
- Reference issue: `Fixes SLHQ-123` or `Relates to SLHQ-123`
- Keep commits atomic (one logical change)

### GitHub Integration

**Pull Request Requirements**:
- Title includes Linear ID: `feat(SLHQ-123): Add user authentication`
- Description references Linear issue
- All CI checks passing
- DoD checklist in PR description

**PR Template** (if using PRs):
```markdown
## Summary
[Description of changes]

## Linear Issue
Closes SLHQ-123

## Definition of Done
- [ ] Documentation updated
- [ ] Tests added/passing
- [ ] Code reviewed
- [ ] Linear issue updated

## Testing
[How this was tested]
```

---

## Exceptions and Waivers

### When DoD Can Be Relaxed

**Prototypes and Spikes**:
- Mark issue with `prototype` or `spike` label
- Document in Linear: "Prototype - full DoD not required"
- Still require: Linear ID, basic documentation, cleanup

**Emergency Fixes**:
- Mark with `hotfix` label
- Minimal DoD: working fix, basic documentation
- Follow-up issue required for full DoD compliance

**Experiments**:
- Mark with `experiment` label
- Document what was learned
- Can skip full implementation documentation

**Requesting Waiver**:
1. Create comment in Linear explaining why
2. Get approval from team lead
3. Document what's being waived
4. Create follow-up issue for missing items

---

## Maintenance

### Quarterly Review

**Every 3 months, review this DoD runbook**:
- [ ] Are criteria still relevant?
- [ ] Any common violations to address?
- [ ] New types of work needing DoD?
- [ ] Team feedback incorporated?

### Update Process

**To update this DoD**:
1. Create Linear issue: `Update Definition of Done`
2. Draft proposed changes
3. Share with team for feedback
4. Update this document
5. Announce in #team channel
6. Update Linear issue template if needed

### Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2025-11-02 | Initial Definition of Done |

---

## Templates Integration

### Using DoD with Templates

**Workflow**:
1. Copy template: `cp /docs/templates/spec.md /docs/specs/SLHQ-XXX-name.md`
2. Fill in all sections (use template as DoD checklist)
3. Verify Universal DoD
4. Verify Type-Specific DoD
5. Mark Linear issue "Done"

**Template Sections = DoD Requirements**:
- Each template section is a DoD requirement
- All sections must be completed or marked N/A
- No section should be left as placeholder text

---

## Training and Onboarding

### For New Contributors

**First-Time Checklist**:
- [ ] Read this DoD runbook completely
- [ ] Review templates in `/docs/templates/`
- [ ] Review example artifacts in `/docs/`
- [ ] Practice with a small issue
- [ ] Get first contribution reviewed

**Resources**:
- This runbook (you're reading it!)
- `/agents/claude.md` - Claude-specific workflows
- `/agents/agents.md` - Multi-agent coordination
- `/README.md` - SSOT policy and overview

### Common New Contributor Mistakes

1. **Forgetting Linear ID**: Always start with Linear issue
2. **Skipping templates**: Templates ensure completeness
3. **Poor commit messages**: Use format: `type(SLHQ-XXX): description`
4. **Not cleaning up**: Review `git status` before committing
5. **Incomplete sections**: Fill all template sections or mark N/A

---

## Quick Reference Cards

### 5-Second DoD Check
✓ Linear ID in doc?
✓ Template structure followed?
✓ Acceptance criteria met?
✓ `git status` clean?
✓ Linear issue updated?

### 30-Second DoD Check
- [ ] Frontmatter complete with Linear ID
- [ ] All template sections filled
- [ ] No TODOs or placeholders
- [ ] File in correct location
- [ ] Commit message has Linear ID
- [ ] No temp files in repo
- [ ] Linear issue has deliverable links

### 5-Minute Full DoD Audit
1. Run verification commands (see Verification Procedures)
2. Review Universal DoD checklist
3. Review Type-Specific DoD
4. Self-review content for quality
5. Check all links working
6. Verify Linear issue complete
7. Final `git status` check

---

## Related Documents

### Process Documentation
- `/agents/agents.md` - Agent coordination and handoffs
- `/agents/claude.md` - Claude-specific workflows
- `/README.md` - SSOT policy
- `/docs/SETUP-COMPLETE.md` - Initial setup status

### Templates
- `/docs/templates/spec.md` - Specification template
- `/docs/templates/adr.md` - Architecture decision record template
- `/docs/templates/runbook.md` - Runbook template

### Linear Issues
- [SLHQ-12: Define and document Definition of Done](https://linear.app/abuah/issue/SLHQ-12)
- [SLHQ-10: Document ADR for SSOT policy](https://linear.app/abuah/issue/SLHQ-10)
- [SLHQ-3: Configure Linear workflow](https://linear.app/abuah/issue/SLHQ-3)

---

## Appendix

### DoD Checklist for Copy-Paste

```markdown
## Definition of Done Verification

### Universal DoD
- [ ] Linear ID in all artifacts
- [ ] Documentation updated
- [ ] Template structure followed
- [ ] Correct directory and filename
- [ ] Commits follow format
- [ ] Acceptance criteria met
- [ ] Self-reviewed
- [ ] `git status` clean
- [ ] Linear issue updated

### Type-Specific (choose one)
#### Spec
- [ ] Created from template
- [ ] All sections complete
- [ ] Success criteria defined

#### ADR
- [ ] Sequential numbering
- [ ] Decision rationale clear
- [ ] Consequences documented

#### Runbook
- [ ] Commands tested
- [ ] Procedures actionable
- [ ] Troubleshooting included

#### Code
- [ ] Tests passing
- [ ] Code reviewed
- [ ] No debug statements

### Ready for Done ✓
```

---

## Contact and Support

**Questions about DoD?**
- Check this runbook first
- Ask in #team channel
- Reference in Linear issue for clarification

**Proposing DoD Changes?**
- Create Linear issue with `process` label
- Explain current limitation
- Propose specific change
- Gather team feedback

---

**Remember**: The Definition of Done exists to maintain quality. It's not bureaucracy—it's how we ensure every piece of work adds lasting value to Slack-HQ.
