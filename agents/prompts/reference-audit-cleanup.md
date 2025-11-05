# Reference Audit & Cleanup Template

**Type:** Operational Template
**Created:** 2025-11-04
**Use Case:** Audit and update any reference type across codebase
**Reusable:** Yes - Customize by filling in [BRACKETED] sections

---

## Objective

Audit all [REFERENCE_TYPE] across the codebase, update to current values, clean up outdated artifacts, and create a single source of truth reference document.

---

## Context

**Reference Type:** [e.g., API endpoints, channel IDs, service URLs, config keys]

**Identifier Pattern:** [e.g., regex pattern, format description]

**Issue:** Documentation may contain deprecated/outdated [REFERENCE_TYPE] from previous iterations

---

## Current Valid References

```
[CURRENT_ID_1] - [NAME_1] - [PURPOSE/CONTEXT]
[CURRENT_ID_2] - [NAME_2] - [PURPOSE/CONTEXT]
[CURRENT_ID_3] - [NAME_3] - [PURPOSE/CONTEXT]
...
```

---

## Deprecated References (Remove/Update)

```
[OLD_ID_1] - [OLD_NAME_1] - [REASON: e.g., legacy, renamed, sunset]
[OLD_ID_2] - [OLD_NAME_2] - [REASON]
...
```

---

## Execution Steps

### Phase 1: Discovery (Read-Only)

**1. Define search pattern**

```bash
# Pattern to search for
PATTERN="[REGEX_OR_PATTERN]"

# Example patterns:
# - Slack channels: "C0[0-9A-Z]{9,11}"
# - API endpoints: "https://api\.oldservice\.com/[a-z/]+"
# - Config keys: "OLD_CONFIG_[A-Z_]+"
```

**2. Define search scope**

```bash
# File types to search
FILE_TYPES="*.md *.js *.json *.yml *.yaml *.toml"

# Directories to search
SCOPE="docs/ src/ config/ .claude/"

# Exclusions
EXCLUDE="node_modules .git dist build .archive"
```

**3. Execute discovery**

```bash
# Option 1: grep
grep -r "$PATTERN" $SCOPE --include="$FILE_TYPES" --exclude-dir="$EXCLUDE"

# Option 2: find + grep
find $SCOPE -name "$FILE_PATTERN" \
  -not -path "*/node_modules/*" \
  -not -path "*/.git/*" \
  -exec grep -l "$PATTERN" {} \;

# Option 3: Use Claude Code Grep tool
Use Grep tool with pattern: $PATTERN, path: $SCOPE
```

**4. Categorize findings**

Create initial classification:

- **Critical** 🔴 - User-facing, operational docs, main guides
- **Important** 🟡 - Configuration files, setup instructions, runbooks
- **Historical** 🔵 - ADRs, changelogs, dated records, retrospectives
- **Examples** 🟢 - Code samples, test data, mock responses

---

### Phase 2: Validation

**For each file found, determine:**

1. **Extract all references** matching the pattern
2. **Compare against current valid list**
3. **Assess context:**
   - Is this documentation or historical record?
   - Is this an active example or archived data?
   - Is this user-facing or internal?

4. **Flag for action:**
   - ⚠️ **Update** - Contains deprecated values in active content
   - ℹ️ **Annotate** - Historical record needing context
   - ✅ **Keep** - Already current/correct
   - 🗄️ **Archive** - Entire file is outdated artifact

**Create validation matrix:**

```markdown
| File | References Found | Status | Action |
|------|------------------|--------|--------|
| README.md | [OLD_ID_1] | Active doc | Update |
| docs/adr/001.md | [OLD_ID_2] | Historical | Annotate |
| config.yml | [CURRENT_ID] | Current | Keep ✓ |
```

---

### Phase 3: Surgical Updates

**Update Strategy by File Type**

#### Files That MUST Be Updated

✅ **Active Documentation:**
- Main project docs (README, CLAUDE.md, CONTRIBUTING.md, AGENTS.md)
- User guides and tutorials
- API documentation
- Setup/installation instructions
- Runbooks and operational procedures
- Quick reference guides

✅ **Configuration Files** (verify carefully):
- Environment configs (.env.example, config.yml)
- CI/CD pipelines (.github/workflows/)
- Deployment manifests (manifest.yml, docker-compose.yml)
- Integration configs (.claude/mcp.json)

#### Files That Should Be Annotated (Not Changed)

⚠️ **Historical Records:**
- Architecture Decision Records (docs/adrs/)
- Changelogs and release notes
- Meeting notes with dates
- Incident postmortems
- Test reports from specific dates
- Dated audit reports

#### Update Patterns

**For historical records:**
```markdown
# Add annotation, don't change value
[OLD_VALUE] *(deprecated YYYY-MM-DD - [REASON])*
[OLD_VALUE] # historical response from [DATE]
```

**For active examples:**
```markdown
# Replace directly
[OLD_VALUE] → [NEW_VALUE]

# Or update in context
- Before: Use [OLD_VALUE] for...
- After: Use [NEW_VALUE] for...
```

**For user instructions:**
```markdown
# Clear migration guidance
Use [NEW_VALUE] instead of [OLD_VALUE].
The old value was deprecated on [DATE] due to [REASON].
```

#### Files That Should NOT Be Updated

❌ **Do Not Change:**
- Time-stamped records (accurate to that moment)
- Bug reports with actual execution data
- Test results and logs from specific runs
- Git history references and commit messages
- Audit trails and compliance records
- Screenshots or embedded images with old values

---

### Phase 4: Verification

**Post-update validation checklist:**

```bash
# 1. Re-scan for remaining deprecated values
grep -r "$OLD_PATTERN" docs/ src/ config/

# 2. Check specific file types
grep -r "$OLD_PATTERN" --include="*.md"
grep -r "$OLD_PATTERN" --include="*.yml"
grep -r "$OLD_PATTERN" --include="*.json"

# 3. Verify critical files updated
for file in README.md CLAUDE.md AGENTS.md config.yml; do
  echo "Checking $file..."
  grep "$OLD_PATTERN" "$file" || echo "✓ Clean"
done

# 4. Confirm historical records preserved
ls -la docs/adrs/ docs/changelogs/
```

**Manual verification:**

- [ ] No user-facing docs have deprecated values
- [ ] Historical records maintain integrity
- [ ] Reference tables/mappings are current
- [ ] Examples use current values
- [ ] Configuration files validated

**Testing (if applicable):**

- [ ] Run configs with new values
- [ ] Test API endpoints
- [ ] Verify integrations work
- [ ] Check scripts execute correctly

---

### Phase 5: Artifact Management

**1. Identify audit artifacts**

Look for files matching these patterns:
```
*AUDIT*.md
*VALIDATION*.md
*VERIFICATION*.md
*REFERENCES*.md
*UPDATES*.md
*ANALYSIS*.md
*FINDINGS*.md
*REVIEW*.md
*CHECK*.md
```

**2. Archive strategy (not deletion)**

```bash
# Create dated archive folder
mkdir -p .archive/$(date +%Y-%m-%d)-[AUDIT_TYPE]

# Move audit artifacts
mv *AUDIT*.md .archive/$(date +%Y-%m-%d)-[AUDIT_TYPE]/
mv *VALIDATION*.md .archive/$(date +%Y-%m-%d)-[AUDIT_TYPE]/
mv *FINDINGS*.md .archive/$(date +%Y-%m-%d)-[AUDIT_TYPE]/

# Verify move
ls -la .archive/$(date +%Y-%m-%d)-[AUDIT_TYPE]/
```

**3. Update .gitignore**

```bash
# Add archive directory to gitignore
echo "" >> .gitignore
echo "# Archived audit reports" >> .gitignore
echo ".archive/" >> .gitignore
```

**4. Create archive index**

```markdown
# .archive/README.md

## Archived Audits

### YYYY-MM-DD - [Reference Type] Audit

**Scope:** [What was audited]

**Findings:**
- Scanned: X files
- Deprecated references: Y instances
- Files updated: Z

**Actions Taken:**
- [File 1]: [Changes made]
- [File 2]: [Changes made]

**Artifacts:**
- [AUDIT_FILE_1].md - Discovery report
- [VALIDATION_FILE].md - Validation results
- [FINDINGS_FILE].md - Detailed findings

**Outcome:** All references updated to current values ✓
```

---

### Phase 6: Create Clean Reference Document

**Create:** `[REFERENCE_TYPE]-REFERENCE.md`

**Location:** Project root or `/docs/reference/`

**Structure:**

```markdown
# [Reference Type] Reference

**Last Updated:** YYYY-MM-DD
**Next Review:** YYYY-MM-DD (suggest quarterly)
**Owner:** [Team/Person]

---

## Current Active [References]

| Name/Key | Value/ID | Purpose | Notes |
|----------|----------|---------|-------|
| [NAME_1] | [VALUE_1] | [USE_1] | [INFO_1] |
| [NAME_2] | [VALUE_2] | [USE_2] | [INFO_2] |
| [NAME_3] | [VALUE_3] | [USE_3] | [INFO_3] |

---

## Usage Guidelines

### When to Use [Reference A]
- [Context/scenario 1]
- [Context/scenario 2]
- **Example:** [Concrete use case]

### When to Use [Reference B]
- [Context/scenario 1]
- [Context/scenario 2]
- **Example:** [Concrete use case]

---

## Quick Reference

### [Integration Method 1 - e.g., API/SDK]

```[language]
[code example showing usage]
```

### [Integration Method 2 - e.g., CLI]

```bash
[command examples]
```

### [Integration Method 3 - e.g., Configuration]

```yaml
[config file example]
```

---

## Best Practices

✅ **DO:**
- [Best practice 1]
- [Best practice 2]
- [Best practice 3]

❌ **DON'T:**
- [Anti-pattern 1]
- [Anti-pattern 2]
- [Anti-pattern 3]

---

## Validation

**To verify references are current:**

```bash
[validation command 1]
[validation command 2]
```

**Last verified:** YYYY-MM-DD

**Verification frequency:** [Monthly/Quarterly/As-needed]

---

## Migration Guide (if applicable)

### Migrating from [OLD_REFERENCE] to [NEW_REFERENCE]

**Step 1:** [First migration step]
**Step 2:** [Second migration step]
**Step 3:** [Verification step]

**Common issues:**
- [Issue 1]: [Solution]
- [Issue 2]: [Solution]

---

## Related Documentation

- [Doc 1] - [Purpose/Context]
- [Doc 2] - [Purpose/Context]
- [Doc 3] - [Purpose/Context]

---

## Change Log

**YYYY-MM-DD:**
- Initial reference document created
- All deprecated [X] references updated to [Y]
- Archived audit artifacts to `.archive/YYYY-MM-DD/`
```

---

## Output Format

**Provide structured summary:**

```
✅ [Reference Type] Audit Complete

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📊 DISCOVERY
  • Scanned: X files
  • References found: Y instances
  • Deprecated found: Z instances
  • Categorized: Critical (N), Important (M), Historical (P)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔧 UPDATES
  • Files updated: N
    - [file-1]: [specific changes]
    - [file-2]: [specific changes]
    - [file-3]: [specific changes]

  • Files annotated: M (historical context added)
    - [file-a]: Added deprecation note with date
    - [file-b]: Added historical context annotation

  • Files verified: P (already current)
    - [file-x], [file-y], [file-z]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🗄️ CLEANUP
  • Archived: Q audit artifacts
    - Location: .archive/YYYY-MM-DD-[audit-type]/
    - Files: [list]

  • Created: [REFERENCE_TYPE]-REFERENCE.md
    - Location: [path]
    - Size: [lines/KB]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ VALIDATION
  ✓ User-facing docs: Current
  ✓ Configuration files: Current
  ✓ Historical records: Preserved
  ✓ Examples: Updated
  ✓ Tests: [Passed/N/A]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📝 NEXT STEPS
  • Review cycle: [Quarterly/Bi-annual]
  • Owner: [Person/Team]
  • Automation potential: [Script ideas if applicable]
  • Documentation: Update related docs if needed

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Success Criteria Checklist

Before considering audit complete:

- [ ] All user-facing content uses current references
- [ ] Historical records preserved with proper annotations
- [ ] No deprecated values in active examples/instructions
- [ ] Configuration files validated and updated where needed
- [ ] Audit artifacts archived (not deleted)
- [ ] Single clean reference document created
- [ ] .gitignore updated to exclude archives
- [ ] No information loss or context removed
- [ ] Validation method documented
- [ ] Next review date set
- [ ] Related documentation cross-referenced
- [ ] Change log updated in reference document

---

## Key Principles

### 1. Preserve History
- Add annotations, don't delete context
- Mark deprecated values with dates and reasons
- Keep audit trails intact
- Never alter historical accuracy

### 2. Update Actively
- Fix all user-facing documentation
- Update operational procedures
- Refresh examples and tutorials
- Ensure consistency across all active docs

### 3. Archive Thoroughly
- Move audit artifacts out of main tree
- Create dated archive folders
- Document what was found and fixed
- Maintain archive index

### 4. Create Clarity
- One authoritative reference document
- Clear usage guidelines
- Easy-to-maintain format
- Accessible to all team members

### 5. Verify Completely
- Test updated values where possible
- Re-scan for missed instances
- Set review schedule for future
- Document validation process

### 6. No Assumptions
- Only update confirmed deprecated references
- Document uncertainty clearly
- Ask for validation when unclear
- Preserve context when in doubt

---

## Customization Guide

**Adapt this template by replacing:**

| Placeholder | Your Value | Example |
|-------------|------------|---------|
| `[REFERENCE_TYPE]` | What you're auditing | "Slack Channels", "API Endpoints" |
| `[PATTERN]` | Search regex/pattern | `C0[0-9A-Z]{9,11}` |
| `[SCOPE]` | Directories to search | `docs/ config/ src/` |
| `[FILE_TYPES]` | File extensions | `*.md *.json *.yml` |
| `[CURRENT_ID_X]` | Current valid values | `C09Q8KCGM9C` |
| `[OLD_ID_X]` | Deprecated values | `C0684S1LTLP` |
| `[AUDIT_DATE]` | Execution date | `2025-11-04` |

---

## Common Use Cases

This template works for:

**Infrastructure References:**
- API endpoint migrations
- Service URL updates
- Database connection strings
- CDN endpoints
- Container registry URLs

**Configuration References:**
- Environment variable keys
- Feature flag identifiers
- Configuration section names
- Secret key names
- Service account IDs

**Integration References:**
- OAuth client IDs
- Webhook URLs
- Channel IDs (Slack, Discord, etc.)
- Integration tokens/keys
- Third-party service IDs

**Code References:**
- Deprecated function names
- Old package names
- Legacy class names
- Outdated import paths
- Renamed modules

**Documentation References:**
- Link updates
- Resource URLs
- Documentation site moves
- Repository relocations
- Domain changes

---

## Execution Checklist

Use this checklist during execution:

**Planning Phase:**
- [ ] Define reference type and pattern
- [ ] List current valid values
- [ ] List deprecated values with reasons
- [ ] Determine search scope
- [ ] Identify critical files

**Discovery Phase:**
- [ ] Execute search across codebase
- [ ] Categorize all findings
- [ ] Create validation matrix
- [ ] Document edge cases

**Update Phase:**
- [ ] Update user-facing docs
- [ ] Update configuration files
- [ ] Annotate historical records
- [ ] Preserve all context

**Verification Phase:**
- [ ] Re-scan for deprecated values
- [ ] Test updated configurations
- [ ] Verify critical files clean
- [ ] Confirm historical integrity

**Cleanup Phase:**
- [ ] Archive audit artifacts
- [ ] Update .gitignore
- [ ] Create archive index
- [ ] Remove temporary files

**Documentation Phase:**
- [ ] Create reference document
- [ ] Add usage guidelines
- [ ] Include code examples
- [ ] Set review schedule

**Completion Phase:**
- [ ] Generate summary report
- [ ] Update related docs
- [ ] Commit all changes
- [ ] Notify team/stakeholders

---

## Tips for Success

**Efficiency:**
- Use Claude Code's Grep/Glob tools for fast searching
- Run discovery phase first, report findings before making changes
- Update files in batches by category (all configs, then all docs)
- Use Edit tool for surgical changes to preserve formatting

**Quality:**
- Always read files before updating to understand context
- Preserve indentation and formatting exactly
- Test one file's changes before batch updating
- Keep git history clean with focused commits

**Safety:**
- Never delete historical data
- Archive don't remove
- Commit frequently during updates
- Can roll back if needed

**Communication:**
- Report findings before acting
- Explain what will be updated vs. preserved
- Show examples of planned changes
- Confirm approach with user if uncertain

---

**Template Version:** 1.0
**Created:** 2025-11-04
**Last Updated:** 2025-11-04
**Maintainer:** Claude Code
**Location:** `/agents/prompts/reference-audit-cleanup.md`
