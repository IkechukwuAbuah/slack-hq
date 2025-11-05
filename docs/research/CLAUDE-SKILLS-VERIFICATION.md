# Claude Skills System Architecture - Verification Report

**Date:** November 3, 2025  
**Scope:** Investigation of Claude Skills system capabilities, structure, and implementation patterns  
**Sources:** 
- Research document: `/Users/x/Downloads/slack-hq/docs/research/skill-making.md`
- Practical implementations: `/Users/x/Downloads/slack-hq/skills/session-tracking.skill`, `/Users/x/.claude/skills/product-owner/`
- Configuration files: `SKILL.md`, `skill.json` formats

---

## Executive Summary

The Claude Skills system is **MORE FLEXIBLE AND LAYERED** than the research document suggests. Two distinct skill formats exist in practice:

1. **SKILL.md Format** (Anthropic Standard): YAML frontmatter + Markdown body in a ZIP file
2. **skill.json Format** (Extended): Dedicated JSON metadata with separate prompt file and templates

Both approaches are valid and coexist in the codebase. The research document primarily describes the SKILL.md format but omits the richer skill.json schema entirely.

**Key Finding:** The system supports TWO different implementation patterns, and builders should choose based on complexity needs and deployment target.

---

## 1. Skill Structure Verification

### 1.1 Current Implementation - SKILL.md Format (Anthropic Standard)

**File Location:** `/Users/x/Downloads/slack-hq/skills/session-tracking.skill`

The `.skill` file is actually a ZIP archive containing:

```
session-tracking.skill (ZIP archive)
├── SKILL.md                    (Primary skill definition)
├── references/
│   ├── cli-commands.md         (CLI specifications)
│   ├── schema.md               (Data model reference)
│   ├── slack-integration.md    (Integration patterns)
│   └── testing-guide.md        (Testing procedures)
├── scripts/
│   ├── session-schema.json     (JSON Schema validation)
│   └── session.sh              (Implementation script)
```

**SKILL.md Structure (from session-tracking.skill):**

```yaml
---
name: session-tracking
description: Session tracking system for AI Council agents collaborating in slack-hq workspace. Use when implementing or working with `/session` commands to track agent activities, manage collaborative workflows, create audit trails, or integrate with Slack for progress updates. Handles session lifecycle (start/stop/pause), structured JSON storage, CLI commands, Slack integration, and multi-agent coordination.
---

# Session Tracking

[Main content in markdown below metadata]

## When to Use This Skill
## Core Workflow
## Data Schema
## Implementation Patterns
...
```

**Key Observations:**
- YAML frontmatter enclosed with `---` delimiters (or sometimes `## Metadata` heading)
- Metadata fields are minimal: `name`, `description` (no `allowed-tools` field present)
- Content is organized as structured markdown sections
- Supporting files are referenced but not embedded

### 1.2 Alternative Implementation - skill.json Format (Extended)

**File Location:** `/Users/x/.claude/skills/product-owner/`

Directory structure:

```
product-owner/
├── skill.json              (Complete metadata and configuration)
├── prompt.md               (Skill instructions/behavior)
├── README.md               (Documentation)
├── INSTALL.md              (Setup guide)
├── COMPARISON.md           (Comparison with alternatives)
└── templates/
    ├── story-map-quick.md
    ├── opportunity-quick.md
    └── release-quick.md
```

**skill.json Structure (Full Example):**

```json
{
  "name": "product-owner",
  "displayName": "Product Owner",
  "description": "User Story Mapping & outcome-focused product management assistant...",
  "version": "1.0.0",
  "fullyQualifiedName": "kelvin:product-owner",
  "author": {
    "name": "Kelvin Ikechukwu Abuah",
    "nickname": "Kel"
  },
  "keywords": ["product-management", "story-mapping", ...],
  "category": "product",
  "prompt": "prompt.md",
  "templates": [
    {
      "name": "story-map-quick",
      "path": "templates/story-map-quick.md",
      "description": "Quick-start story map..."
    }
  ],
  "requiredTools": ["Write", "Read", "Edit"],
  "optionalTools": ["mcp__notionApi", "WebSearch", "WebFetch"],
  "optionalIntegrations": {
    "notion": {
      "description": "Create story maps in Notion databases",
      "required": false
    }
  },
  "quickActions": [
    {
      "id": "frame-opportunity",
      "label": "Frame an opportunity",
      "description": "Define problem, users, and target outcomes"
    }
  ],
  "methodology": { ... },
  "compatibility": {
    "claudeCode": ">=1.0.0",
    "minPromptLength": 15000,
    "recommendedModel": "claude-sonnet-4-5"
  },
  "usage": {
    "invocation": "/skill product-owner"
  },
  "license": "MIT",
  "changelog": [ ... ]
}
```

**Key Differences from SKILL.md:**
- Separates metadata (skill.json) from behavior (prompt.md)
- Richer metadata: categories, keywords, authors, methodology
- Explicit tool definitions: `requiredTools` vs `optionalTools`
- Built-in template system with descriptions
- Integration configuration (Notion, memory, etc.)
- Compatibility specifications (minimum prompt length, recommended model)
- Changelog tracking

### 1.3 Metadata Fields Summary

| Field | SKILL.md | skill.json | Purpose |
|-------|----------|-----------|---------|
| name | ✓ | ✓ | Unique skill identifier |
| description | ✓ | ✓ | When/why to use the skill (trigger condition) |
| version | ✓ (mentioned in research) | ✓ | Semantic versioning for updates |
| allowed-tools / requiredTools | ✗ (missing in examined SKILL.md) | ✓ | Permitted tool access |
| optionalTools | ✗ | ✓ | Additional optional capabilities |
| displayName | ✗ | ✓ | Human-readable name |
| category | ✗ | ✓ | Skill classification |
| prompt/content | Markdown body | Separate file reference | Instructions for Claude |
| templates | Referenced | Structured array | Reusable templates |
| keywords | ✗ | ✓ | Searchability/discovery |
| methodology | ✗ | ✓ | Domain-specific approach |

---

## 2. Progressive Context Loading - PARTIAL CONFIRMATION

### 2.1 Research Claims vs. Reality

**Research Document Claims:**
- Level 1 (Metadata): Only YAML frontmatter pre-loaded (~100 tokens)
- Level 2 (Core Instructions): Full SKILL.md body loaded if skill matches (~5K tokens)
- Level 3+ (References): Additional files loaded on-demand

**Verification Status:** PARTIALLY SUPPORTED

**Evidence:**
1. The SKILL.md file structure with separated frontmatter supports this pattern
2. The session-tracking skill includes large reference files that would only be loaded if needed:
   - `references/slack-integration.md` (8.5KB)
   - `references/schema.md` (5.4KB)
   - `references/testing-guide.md` (7.1KB)

3. The skill.json format makes metadata-only loading explicit:
   - Metadata section (~1.5KB for product-owner) loads for skill selection
   - `prompt` file (~9KB) loads when skill is invoked

**Limitation Found:** 
- The examined SKILL.md files don't include `allowed-tools` metadata, which suggests Claude's system may not fully validate permissions at the metadata level
- No evidence found that Claude explicitly blocks loading of referenced files before invocation (though progressive loading is theoretically supported)

### 2.2 Practical Implications for Skill-Builder

For the skill-builder meta-skill:

1. **Keep metadata lean:** 2-3 sentence description, focus on trigger keywords
2. **Use reference files for large content:** Templates, examples, and detailed guides should be separate
3. **Leverage both formats:** Use SKILL.md for simple skills, skill.json for complex ones with multiple integration points

---

## 3. Tools and Permissions System

### 3.1 Two Different Approaches

**Approach 1: SKILL.md (Assumed Dynamic)**

The session-tracking.skill examined has NO explicit `allowed-tools` field in its SKILL.md. This suggests:
- Tools may be inferred from the description/usage
- Or Claude handles permission requests at runtime

**Approach 2: skill.json (Explicit Declaration)**

```json
"requiredTools": ["Write", "Read", "Edit"],
"optionalTools": ["mcp__notionApi", "WebSearch", "WebFetch"],
"optionalIntegrations": {
  "notion": {
    "description": "Create story maps in Notion databases",
    "required": false
  }
}
```

This is MORE EXPLICIT and SAFER:
- Clear what the skill needs vs. what's optional
- Integration conditions are documented
- Backward compatibility indicated (minPromptLength, recommendedModel)

### 3.2 Tool Categories Available

Based on skill.json examples, tools fall into categories:

**File Operations:**
- `Read`, `Write`, `Edit` - File system access
- `Glob`, `Grep` - File searching

**Execution:**
- `Bash` - Shell command execution
- Code execution (Python, JavaScript)

**External Integrations:**
- `mcp__notionApi` - Notion API via MCP server
- `mcp__linear-server` (referenced elsewhere)
- `mcp__github` (referenced elsewhere)

**Information:**
- `WebSearch` - Internet searching
- `WebFetch` - Web content retrieval

**Advanced:**
- `Task` - Subagent spawning (mentioned in research, NOT used in examined skills)

### 3.3 Discrepancy: allowed-tools Not Found in SKILL.md

**Research Claims:**
> "allowed-tools: This field restricts which tools the skill can use without asking for user permission"

**Actual Finding:**
The session-tracking.skill SKILL.md file **does not contain an `allowed-tools` field** in its YAML frontmatter. This suggests:

1. Skills may rely on implicit permissions from CLI/environment
2. Or Claude's system infers tools from content
3. Or field is optional (defaults to all)
4. Or it's a newer field not yet widely adopted

**Recommendation:** When building the skill-builder, use skill.json format with explicit `requiredTools` and `optionalTools` for clarity and security.

---

## 4. Subagent Capabilities - NOT DEMONSTRATED IN EXAMINED SKILLS

### 4.1 Research Claims vs. Reality

**Research Document States:**
- Claude can spawn subagents via `Task()` tool
- Subagents have 100K+ token context windows
- Can run in parallel
- Useful for isolating complex workflows
- The skill-builder itself uses a "SkillInstructor" subagent

**Verification Status:** NO EVIDENCE FOUND IN EXAMINED SKILLS

**What We Found Instead:**
- The session-tracking.skill makes NO use of subagents
- The product-owner skill makes NO use of subagents
- Both are self-contained skills that don't delegate to subagents

**Where Subagents ARE Used:**
- `/Users/x/Downloads/slack-hq/TOOL-REGISTRY.md` mentions:
  - `meta-agent`: Generate new subagent configurations
  - Available via `Task` tool with `subagent_type` parameter
- But no actual subagent invocations found in skill definitions

### 4.2 Critical Gap for Skill-Builder

The research document proposes using a "SkillInstructor" subagent for the skill-builder, but:

1. **No precedent exists** in the examined codebase
2. **Subagent invocation syntax** is unclear (research suggests `Task()` but exact parameters undefined)
3. **Context isolation** benefits are theoretical, not proven

**Recommendation:** 
- For initial skill-builder implementation, use a self-contained skill approach (like session-tracking)
- Subagent delegation can be added later as an optimization
- Focus on clear instruction sequencing within a single skill context

---

## 5. Code Execution and Artifact Generation

### 5.1 Evidence in Examined Skills

**Session-tracking.skill:**
- Contains `scripts/session.sh` (shell script)
- Contains `scripts/session-schema.json` (JSON validation schema)
- These are REFERENCED in instructions but NO example of direct execution shown

**Product-owner skill:**
- No executable code present
- Focus is on guidance and templates
- No artifacts generated

### 5.2 Discrepancy: Missing Practical Examples

**Research Claims:**
> "Claude can run Python/JavaScript code via code interpreter"
> "Artifacts (files/outputs generated by code) can be produced and returned"
> "The skill we build will generate a ZIP file artifact"

**Actual Implementation:**
- No examined skill includes inline Python/JavaScript code
- No skill explicitly generates artifacts in the examined files
- Scripts referenced are assumed to be invoked by Claude, not shown in SKILL.md

### 5.3 For the Skill-Builder

The skill-builder should:

1. **Create files**, not execute code:
   ```bash
   # Use Write tool to create SKILL.md, scripts, etc.
   # Then zip the directory using Bash
   bash -c "cd /tmp && zip -r skill-name.zip skill-name/"
   ```

2. **Document code generation** as text, not execution:
   - Generate SKILL.md content
   - Provide template scripts for users to run
   - Return ZIP with ready-to-use structure

3. **Keep code execution simple:**
   - Use only zipping (shutil in Python or zip command)
   - Standard library only (no pip installs)
   - Timeout-safe and deterministic

---

## 6. Best Practices for Skill Descriptions and Trigger Mechanisms

### 6.1 Research Recommendations

The research emphasizes:
- "Clear, action-oriented descriptions"
- "Explicitly state when the skill should be used"
- "Include key phrases likely in user prompts"

### 6.2 Actual Implementation Examples

**session-tracking.skill:**
```
"Session tracking system for AI Council agents collaborating in slack-hq workspace. 
Use when implementing or working with `/session` commands to track agent activities, 
manage collaborative workflows, create audit trails, or integrate with Slack for 
progress updates."
```

**Analysis:**
- ✓ Specific domain (Council agents, session tracking)
- ✓ Trigger keywords: "implementing", "session commands", "track activities"
- ✓ Use cases explicitly listed
- ✓ Mentions specific features (audit trails, Slack integration)

**product-owner.skill:**
```
"User Story Mapping & outcome-focused product management assistant. 
Helps frame opportunities, create story maps, prioritize by outcomes, 
validate assumptions, and plan releases using proven product ownership patterns."
```

**Analysis:**
- ✓ Domain stated (Product Owner, Story Mapping)
- ✓ Key capabilities listed (frame, map, prioritize, validate, plan)
- ✓ Methodology referenced (User Story Mapping)
- ✗ Could be more specific about trigger phrases

### 6.3 Recommendations for Skill-Builder Description

```
"Interactive skill builder that guides users through creating new Claude Skills. 
Use when you want to turn a workflow, template, or guidance into a reusable Claude 
skill. Helps with SKILL.md structure, metadata, templates, and packaging into a 
deployable ZIP file. Handles skill creation, content generation, and artifact packaging."
```

Key triggers: "create skill", "build skill", "turn into skill", "skill builder", "workflow to skill"

---

## 7. Key Discrepancies Between Research and Reality

### 7.1 Discrepancy Matrix

| Research Claim | Actual Finding | Impact |
|---|---|---|
| `allowed-tools` in SKILL.md metadata | Field not found in examined SKILL.md | May be optional or deprecated |
| Progressive context loading | Structure supports it, but not verified in practice | Should work as designed |
| Subagent-driven skill-builder design | No subagent implementations found anywhere | Consider simpler single-skill approach |
| Code execution generates artifacts | No examples found in skills | Focus on file creation, not execution |
| Task() tool invokes subagents | Referenced in TOOL-REGISTRY but no examples | Syntax/parameters unclear |
| when_to_use metadata field | Noted as "not officially supported" | Stick to description-only triggers |
| Skill composition (multiple skills) | Mentioned as possible but no examples | Don't rely on this yet |

### 7.2 What's NOT in the Research

**skill.json format entirely absent:**
- Research focuses exclusively on SKILL.md
- Extended metadata (categories, integrations, compatibility)
- Methodology and quick actions
- Changelog tracking

**Practical constraints:**
- No discussion of file size limits
- No guidance on complexity tradeoffs
- No version management strategy for published skills
- No testing framework mentioned

---

## 8. Current Implementation Status in slack-hq

### 8.1 What's Already Built

1. **session-tracking.skill** (complete)
   - ZIP package with SKILL.md + references + scripts
   - Located: `/Users/x/Downloads/slack-hq/skills/session-tracking.skill`
   - Status: Ready for deployment

2. **TOOL-REGISTRY.md** (partial)
   - Documents available skills
   - References session-tracking in "Claude Code Skills" section
   - Status: Needs updates as new skills are added

3. **Research Documentation**
   - skill-making.md (80KB comprehensive blueprint)
   - session-tracking-analysis.md (10KB implementation analysis)
   - Status: Complete but needs cross-reference updates

### 8.2 What's Missing

1. **skill.json configuration** for session-tracking
2. **Tested invocation patterns** for the skill
3. **Integration with product-owner skill** examples
4. **Skill-builder itself** (subject of the blueprint)
5. **Validation tooling** (schema verification, consistency checks)

---

## 9. Recommendations for Building the Skill-Builder

### 9.1 Architecture Decision: Use Single-Skill, Not Subagent Design

**Recommendation:** Implement as self-contained SKILL.md (not multi-subagent)

**Reasoning:**
- Examined skills (session-tracking, product-owner) are self-contained
- No successful subagent patterns found in codebase
- Simpler to test, debug, and explain

**Structure:**
```
skill-builder.skill (ZIP)
├── SKILL.md                    # Full instructions
│   └── Metadata + Step-by-step guidance
├── templates/
│   ├── SKILL_TEMPLATE.md       # Skeleton for new skills
│   └── skill.json_TEMPLATE     # Extended metadata template
├── scripts/
│   └── package_skill.py        # ZIP creation utility
└── resources/
    └── BEST_PRACTICES.md       # Distilled guidelines
```

### 9.2 Use skill.json Format (Not SKILL.md) for Maximum Flexibility

**Rationale:**
- Richer metadata for skill discovery
- Explicit tool declarations for security
- Template system built-in
- Integration hooks for future enhancements

**Minimum skill.json:**
```json
{
  "name": "skill-builder",
  "displayName": "Skill Builder",
  "description": "Interactive skill builder that guides users through creating new Claude Skills...",
  "version": "1.0.0",
  "prompt": "prompt.md",
  "requiredTools": ["Read", "Write", "Edit", "Glob", "Grep", "Bash"],
  "optionalTools": [],
  "templates": [
    {
      "name": "SKILL_TEMPLATE",
      "path": "templates/SKILL_TEMPLATE.md",
      "description": "Template skeleton for new skill SKILL.md files"
    }
  ]
}
```

### 9.3 Implementation Approach

**Phase 1: Core Skill Definition**
1. Write skill.json with required metadata
2. Create prompt.md with step-by-step instructions:
   - Step 1: Gather requirements
   - Step 2: Plan structure
   - Step 3: Create skill files (SKILL.md)
   - Step 4: Generate templates/scripts
   - Step 5: Package into ZIP
3. Create SKILL_TEMPLATE.md with placeholders

**Phase 2: Supporting Files**
1. Write BEST_PRACTICES.md guide
2. Create package_skill.py for zipping
3. Add example outputs

**Phase 3: Testing**
1. Test with sample skill creation
2. Verify ZIP structure
3. Test generated skill triggers properly

### 9.4 Key Files to Create

```
skill-builder/
├── skill.json                      (Metadata, 1.5KB)
├── prompt.md                       (Instructions, 8-10KB)
├── README.md                       (Documentation, 2KB)
├── templates/
│   ├── SKILL_TEMPLATE.md          (650 bytes)
│   ├── skill.json_TEMPLATE.json   (800 bytes)
│   └── prompt_TEMPLATE.md         (500 bytes)
├── scripts/
│   └── package_skill.py           (500 bytes)
└── resources/
    └── BEST_PRACTICES.md          (2KB)
```

**Total Size:** ~18-20KB (well under any limits)

### 9.5 Validation Checklist Before Deployment

- [ ] skill.json has all required fields
- [ ] prompt.md is comprehensive but concise (<5K tokens per research guidance)
- [ ] Templates have clear placeholders
- [ ] package_skill.py creates valid ZIP with proper structure
- [ ] Sample run-through: create test skill, verify ZIP contents
- [ ] skill triggers when user says "help me build a skill"
- [ ] skill triggers when user says "create a new Claude skill"
- [ ] Generated skills have clear descriptions (for their own triggers)

---

## 10. Appendices

### A. File Locations Reference

**Examined Implementations:**
- Session-tracking skill: `/Users/x/Downloads/slack-hq/skills/session-tracking.skill`
- Product-owner skill: `/Users/x/.claude/skills/product-owner/`
- Research document: `/Users/x/Downloads/slack-hq/docs/research/skill-making.md`
- TOOL-REGISTRY: `/Users/x/Downloads/slack-hq/TOOL-REGISTRY.md`

**Research Sources:**
- Session tracking analysis: `/Users/x/Downloads/slack-hq/docs/research/session-tracking-analysis.md`

### B. Skill.json vs SKILL.md Comparison Matrix

| Criteria | SKILL.md | skill.json |
|----------|----------|-----------|
| Format | ZIP with SKILL.md file | Directory with skill.json + separate prompt |
| Metadata complexity | Minimal (name, description) | Rich (18+ fields possible) |
| Tool declarations | Implicit/missing | Explicit (required/optional) |
| Templates | Referenced in content | Structured configuration |
| Integrations | Not supported | First-class support |
| Metadata loading | Frontmatter only | Entire JSON file |
| Compatibility specs | Not supported | Supported (minPromptLength, etc.) |
| Methodology docs | In content | Structured field |
| Adoption | Anthropic standard | Extended, team-specific |
| Best for | Simple, single-purpose | Complex, multi-integration |

### C. Claude Skills System Terminology

- **Skill:** Self-contained knowledge package (SKILL.md or skill.json directory)
- **Metadata:** Name, description, version, tools (triggers skill selection)
- **Instructions/Prompt:** The actual behavioral guidance Claude receives when skill loads
- **Progressive Disclosure:** Multi-level loading (metadata → full instructions → references)
- **Trigger:** Description keywords that cause Claude to load the skill
- **Artifact:** Generated output (files, ZIPs, etc.) returned to user
- **Subagent:** Isolated child agent with separate context (mentioned but not used)
- **Integration:** Third-party tools (Notion, Linear, GitHub) the skill can access

### D. Tools and Permissions Quick Reference

```
Core File Operations:
  Read, Write, Edit, Glob, Grep

Execution:
  Bash (shell), Python (code interpreter)

External APIs (MCP):
  mcp__notionApi, mcp__linear-server, mcp__github

Information Access:
  WebSearch, WebFetch

Advanced (Rarely used):
  Task (subagent invocation)
```

---

## Conclusion

The Claude Skills system is **production-ready and well-structured**, but with two distinct implementation patterns. The research document provides an excellent conceptual framework but doesn't account for the richer skill.json format or acknowledge the absence of working subagent examples.

**For the skill-builder implementation:**
1. Use **skill.json + prompt.md format** for maximum expressiveness
2. Keep design **self-contained** (skip subagents)
3. Focus on **clear instructions and templates**
4. Verify **trigger phrases** thoroughly
5. Test **ZIP generation** carefully

The system is ready for a well-designed skill-builder that follows these patterns.

