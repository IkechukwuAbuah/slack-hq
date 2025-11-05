# COMPREHENSIVE PROMPT: Complete SLHQ-2 - Repository Structure & Templates

**Issue:** [SLHQ-2](https://linear.app/abuah/issue/SLHQ-2/add-repo-structure-templates)
**Author:** Claude Code (session-tracker-2)
**Created:** 2025-11-03
**Status:** Ready for execution
**Estimated Time:** 60 minutes
**Branch:** `kelvin/slhq-2-add-repo-structure-templates`

## 🎯 OBJECTIVE

Complete Linear issue **SLHQ-2** by finalizing the slack-hq repository structure, ensuring all required directories exist, templates are usable, and documentation accurately reflects the organization system.

## 📋 CONTEXT

**Issue:** [SLHQ-2](https://linear.app/abuah/issue/SLHQ-2/add-repo-structure-templates)
**Branch:** `kelvin/slhq-2-add-repo-structure-templates`
**Status:** Backlog → In Progress → Done
**Project:** Slack-HQ Foundation & Setup

**Current State Analysis:**
- ✅ `/docs` directory exists with comprehensive subdirectories (specs/, adrs/, runbooks/, guides/, templates/)
- ✅ `/agents` directory exists with agents.md, claude.md, council-bot-reference.md
- ✅ `/scripts` directory exists with convert.sh, slack-setup.sh, post-to-slack.sh
- ✅ Templates exist and are high-quality: spec.md, adr.md, runbook.md
- ✅ README.md has basic structure documentation
- ❌ `/artifacts` directory is **MISSING** (required for generated outputs)
- ⚠️ `/agents` lacks subdirectories: `prompts/` and `registry/`
- ⚠️ README structure documentation could be more comprehensive

## 📦 REQUIRED DELIVERABLES

### 1. Directory Structure Completion

Create the following missing components:

```
slack-hq/
├── agents/
│   ├── agents.md              ✅ EXISTS
│   ├── claude.md              ✅ EXISTS
│   ├── council-bot-reference.md ✅ EXISTS
│   ├── prompts/               ❌ CREATE THIS
│   │   ├── README.md          → Document prompts collection purpose
│   │   └── .gitkeep           → Ensure directory is tracked
│   └── registry/              ❌ CREATE THIS
│       ├── README.md          → Document agent registry purpose
│       └── .gitkeep           → Ensure directory is tracked
│
├── artifacts/                 ❌ CREATE THIS
│   ├── README.md              → Document artifacts policy
│   ├── chatgpt/               → Generated .docx/.pdf from ChatGPT
│   │   ├── README.md          → ChatGPT artifacts info
│   │   └── .gitkeep
│   ├── claude/                → Generated .md from Claude
│   │   ├── README.md          → Claude artifacts info
│   │   └── .gitkeep
│   └── .gitignore             → Ignore generated files but track structure
│
└── (existing directories remain unchanged)
```

### 2. Documentation Updates

**A. Create `agents/prompts/README.md`**
- Purpose: Store reusable prompts for common workflows
- Usage: How agents should use prompts
- Organization: Categorization system (by task type, agent, domain)
- Examples: Link to sample prompts when they exist

**B. Create `agents/registry/README.md`**
- Purpose: Central registry of all available agents
- Structure: Agent metadata format
- Discovery: How to find the right agent for a task
- Integration: How agents register themselves

**C. Create `artifacts/README.md`**
- Purpose: Storage for AI-generated documents
- Policy: What gets stored vs. ignored
- Organization: By AI agent (chatgpt/, claude/, gemini/, etc.)
- Lifecycle: Retention and cleanup policies
- Gitignore strategy: Structure tracked, contents ignored

**D. Create `artifacts/chatgpt/README.md`**
- Specific to ChatGPT-generated files
- Formats: .docx, .pdf, .xlsx
- Conversion workflow: How these relate to markdown sources

**E. Create `artifacts/claude/README.md`**
- Specific to Claude-generated files
- Formats: .md (for comparison with source), .txt (for logs)
- Integration: How these tie into session tracking

**F. Update root `README.md`**

Enhance the "Directory Structure" section (lines 34-56) to include:

```markdown
## Directory Structure

```
slack-hq/
├── README.md                 # This file
├── CLAUDE.md                 # Claude Code instructions
├── TOOL-REGISTRY.md          # Comprehensive tool and API catalog
├── AGENTS.md                 # AI agent configuration
├── manifest.yml              # Slack app configuration (Council Bot)
├── .env.example              # Environment variables template
│
├── agents/                   # AI agent coordination
│   ├── agents.md            # Worker registry and handoff rules
│   ├── claude.md            # Claude-specific instructions
│   ├── council-bot-reference.md # Council Bot integration guide
│   ├── prompts/             # Reusable prompt library
│   │   └── README.md        # Prompts usage guide
│   └── registry/            # Agent metadata registry
│       └── README.md        # Registry documentation
│
├── docs/                     # Documentation (markdown SSOT)
│   ├── templates/           # Document templates
│   │   ├── spec.md          # Feature specification template
│   │   ├── adr.md           # Architecture Decision Record template
│   │   └── runbook.md       # Operational runbook template
│   ├── specs/               # Feature specifications
│   ├── adrs/                # Architecture Decision Records
│   ├── runbooks/            # Operational procedures
│   ├── guides/              # Implementation guides
│   ├── setup/               # Setup documentation
│   ├── testing/             # Testing documentation
│   └── research/            # Research and explorations
│
├── artifacts/                # AI-generated documents (gitignored)
│   ├── README.md            # Artifacts policy and usage
│   ├── chatgpt/             # ChatGPT outputs (.docx, .pdf)
│   │   └── README.md
│   └── claude/              # Claude outputs (.md, .txt)
│       └── README.md
│
├── scripts/                  # Automation utilities
│   ├── convert.sh           # Markdown ↔ DOCX conversion
│   ├── slack-setup.sh       # Council Bot deployment
│   └── post-to-slack.sh     # Slack messaging utility
│
├── .claude/                  # Claude Code configuration
│   ├── commands/            # Custom slash commands
│   ├── skills/              # Project-specific skills
│   ├── agents/              # Subagent definitions
│   └── data/                # Runtime data (gitignored)
│
└── logs/                     # Session logs and telemetry (gitignored)
```

**Key Principles:**
- **Markdown is source** - All canonical documentation in `.md`
- **Artifacts are derivatives** - Generated files live in `/artifacts`
- **Structure is tracked** - Directories committed, most contents gitignored
- **Templates are reusable** - Use `/docs/templates` for new documents
```

### 3. .gitignore Updates

Update `.gitignore` to handle artifacts properly:

```gitignore
# Artifacts - track structure, ignore contents
artifacts/**/*
!artifacts/README.md
!artifacts/.gitkeep
!artifacts/chatgpt/
!artifacts/chatgpt/README.md
!artifacts/chatgpt/.gitkeep
!artifacts/claude/
!artifacts/claude/README.md
!artifacts/claude/.gitkeep

# Exception: Allow specific artifact types if needed for examples
# artifacts/**/example-*.md
```

### 4. Template Validation

Verify all three templates are complete and usable:

**A. Check `docs/templates/spec.md`**
- Has clear sections and instructions
- Includes examples or placeholders
- References Linear issue integration
- Shows how to link to ADRs and runbooks

**B. Check `docs/templates/adr.md`**
- Follows standard ADR format
- Has decision status workflow
- Includes consequences section
- Shows numbering convention

**C. Check `docs/templates/runbook.md`**
- Has operational procedures structure
- Includes troubleshooting sections
- Shows prerequisite documentation
- Links to relevant specs/ADRs

## ✅ ACCEPTANCE CRITERIA

### Primary Requirements (from SLHQ-2)

1. **✓ Directory tree matches required structure**
   - [ ] `/docs` exists with templates/, specs/, adrs/, runbooks/
   - [ ] `/agents` exists with agents.md, claude.md, prompts/, registry/
   - [ ] `/artifacts` exists with chatgpt/, claude/ subdirectories
   - [ ] `/scripts` exists with conversion and sync utilities

2. **✓ Templates exist and are usable**
   - [ ] spec.md template is complete with examples
   - [ ] adr.md template follows standard format
   - [ ] runbook.md template includes all standard sections
   - [ ] Each template has clear instructions for use

3. **✓ README documents the structure**
   - [ ] Directory tree diagram is comprehensive
   - [ ] All major directories are explained
   - [ ] Key principles are documented
   - [ ] Usage examples are provided

### Quality Standards

4. **✓ All new READMEs are informative**
   - [ ] Purpose clearly stated
   - [ ] Usage instructions provided
   - [ ] Examples or links to examples included
   - [ ] Integration with other systems explained

5. **✓ .gitignore properly configured**
   - [ ] Artifact contents are ignored
   - [ ] Directory structure is tracked
   - [ ] No accidental exposure of generated files
   - [ ] Clear comments explain ignore patterns

6. **✓ Consistency with SSOT policy**
   - [ ] Markdown documented as source of truth
   - [ ] Artifacts marked as derivative/generated
   - [ ] Clear conversion workflows documented
   - [ ] No confusion about canonical sources

## 🔍 VALIDATION STEPS

After implementation, verify:

```bash
# 1. Directory structure is correct
tree -L 3 -a | grep -A 50 "slack-hq"

# 2. All READMEs exist
find . -name "README.md" -not -path "./.claude/*" | sort

# 3. Templates are present
ls -lh docs/templates/

# 4. .gitignore works correctly
git check-ignore artifacts/chatgpt/test.docx  # Should be ignored
git check-ignore artifacts/README.md          # Should NOT be ignored

# 5. No unintended files staged
git status --short

# 6. Validate with Linear
linear issue update SLHQ-2 --status "In Review"
```

## 📝 IMPLEMENTATION NOTES

### Best Practices

1. **Create directories with .gitkeep files** to ensure empty directories are tracked
2. **Write READMEs before creating subdirectories** to maintain clarity
3. **Test .gitignore patterns** before committing to avoid mistakes
4. **Reference existing documentation** to maintain consistency
5. **Use session tracking** to log this structural work (`/session-start`)

### Potential Issues & Solutions

| Issue | Solution |
|-------|----------|
| Git won't track empty directories | Add .gitkeep files |
| .gitignore too permissive | Test with `git check-ignore -v <path>` |
| README becomes too large | Keep focused on structure, link to detailed docs |
| Unclear artifact organization | Use agent-based subdirectories (chatgpt/, claude/, etc.) |

### Testing Strategy

1. **Create test files** in artifacts/ to verify gitignore
2. **Generate sample artifacts** using convert.sh
3. **Verify directory permissions** for script execution
4. **Test template usage** by creating a sample spec from template
5. **Cross-reference CLAUDE.md** to ensure alignment

## 🎨 STYLE GUIDELINES

### README.md Updates
- Use consistent formatting (match existing style)
- Include visual hierarchy with proper heading levels
- Add code blocks with syntax highlighting
- Keep line length reasonable (80-100 chars preferred)
- Use emoji sparingly and only where they add clarity

### Directory READMEs
- Start with clear purpose statement
- Include usage examples
- Link to related documentation
- Keep concise (< 200 lines preferred)
- Use tables for structured information

### .gitignore Patterns
- Group related patterns with comments
- Use `!` negation for exceptions (structure vs. contents)
- Test patterns with `git check-ignore -v`
- Document complex patterns with inline comments

## 🚀 EXECUTION PLAN

### Phase 1: Structure Creation (10 min)
1. Create `/artifacts` with subdirectories
2. Create `/agents/prompts` and `/agents/registry`
3. Add .gitkeep files to empty directories
4. Update .gitignore with artifact patterns

### Phase 2: Documentation (20 min)
5. Write artifacts/README.md (policy + organization)
6. Write artifacts/chatgpt/README.md (ChatGPT specifics)
7. Write artifacts/claude/README.md (Claude specifics)
8. Write agents/prompts/README.md (prompt library)
9. Write agents/registry/README.md (agent registry)

### Phase 3: README Enhancement (15 min)
10. Update root README.md with comprehensive directory tree
11. Add key principles section
12. Enhance usage examples
13. Verify all links work

### Phase 4: Validation (10 min)
14. Run validation commands
15. Test .gitignore patterns
16. Verify template usability
17. Cross-check against acceptance criteria

### Phase 5: Finalization (5 min)
18. Git status review
19. Stage changes selectively
20. Commit with proper message
21. Update Linear issue status

**Total Estimated Time: 60 minutes**

## 📤 COMPLETION CHECKLIST

Before marking SLHQ-2 as complete:

- [ ] All directories created with proper structure
- [ ] All READMEs written and reviewed
- [ ] .gitignore tested and working correctly
- [ ] Root README.md updated with full directory tree
- [ ] Templates validated for usability
- [ ] Git status shows only intended changes
- [ ] Commit message references SLHQ-2
- [ ] Linear issue updated with completion notes
- [ ] Session logged and posted to Slack (if using session tracking)

## 🎯 SUCCESS METRICS

This issue is complete when:
1. ✅ A new developer can understand the repository structure from README alone
2. ✅ All required directories exist and are documented
3. ✅ Templates can be copied and used immediately
4. ✅ Artifacts can be generated without Git conflicts
5. ✅ Structure aligns with Single Source of Truth (SSOT) policy

---

## 🤖 AGENT INSTRUCTIONS

**When executing this prompt:**

1. **Use TodoWrite** to track phases and create accountability
2. **Start a session** if this represents significant work (`/session-start "Complete SLHQ-2 repository structure"`)
3. **Read existing files** before writing to maintain consistency
4. **Test as you go** (don't wait until the end to validate)
5. **Be thorough** - this is foundational infrastructure
6. **Document decisions** - if you make choices, explain them in READMEs
7. **Think ownership** - this is YOUR project structure to perfect

**Expected behavior:**
- Use Write tool for new files
- Use Edit tool for README.md updates
- Use Bash for directory creation and validation
- Verify git status before committing
- Reference CLAUDE.md and existing patterns for consistency

---

**END OF PROMPT**

This prompt is comprehensive, actionable, and follows best practices for:
- Clear objectives and context
- Detailed requirements with acceptance criteria
- Step-by-step execution plan
- Validation and testing strategies
- Quality standards and style guidelines
- Success metrics and completion checklist
