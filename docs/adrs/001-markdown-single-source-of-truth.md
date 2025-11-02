---
title: "ADR-001: Markdown as Single Source of Truth"
linear_id: SLHQ-10
type: adr
status: Accepted
created: 2025-11-02
updated: 2025-11-02
author: Claude
related: [SLHQ-2, SLHQ-6, SLHQ-7, SLHQ-12]
supersedes: []
superseded_by: []
---

# ADR-001: Markdown as Single Source of Truth

## Status

**Accepted** (2025-11-02)

---

## Context

### Background

Slack-HQ is a documentation-first project management system that coordinates AI agents, human workers, and processes across multiple tools (Linear, GitHub, Notion, Slack). The system needs a clear policy for where information lives and how artifacts are managed.

### Problem

**Without a Single Source of Truth (SSOT) policy, we face:**

1. **Version Fragmentation**: Same document in multiple formats (`.md`, `.docx`, `.pdf`) falling out of sync
2. **Tool Lock-In**: Proprietary formats (`.docx`, `.pdf`) require specific software and don't version well
3. **Merge Conflicts**: Binary formats can't be meaningfully diffed or merged in git
4. **AI Agent Challenges**: Different agents producing incompatible formats
5. **Search and Discovery**: Hard to find information scattered across formats and locations
6. **Maintenance Burden**: Updating information in multiple places creates overhead and errors

### Current Situation

The project uses:
- **Linear**: Task management and issue tracking
- **GitHub**: Code and version control
- **Notion**: Knowledge base and long-term documentation
- **Slack**: Real-time communication

Each tool serves a purpose, but without clear rules about **where definitive information lives** and **what formats are canonical**, the system becomes chaotic.

---

## Decision

**We will use Markdown (`.md`) as the Single Source of Truth for all project documentation.**

### Key Principles

1. **Markdown is Canonical**: All documentation originates and is maintained as `.md` files
2. **Version-Controlled**: All markdown files live in Git (GitHub repository)
3. **Other Formats are Derivatives**: `.docx`, `.pdf`, and other formats are generated from markdown only when needed for sharing
4. **One-Way Conversion**: External documents (`.docx`, `.pdf`) are converted TO markdown and then maintained as markdown
5. **Linear for Tasks**: Linear issues are the canonical source for work items and task status
6. **Notion for Discovery**: Notion serves as a searchable knowledge base, synced from markdown
7. **No Proprietary Formats in Source Control**: Binary formats (`.docx`, `.pdf`) are not committed to the repository

### Implementation Details

**File Structure**:
```
slack-hq/
├── docs/
│   ├── specs/          # Feature specifications (.md only)
│   ├── adrs/           # Architecture decisions (.md only)
│   ├── runbooks/       # Operational procedures (.md only)
│   └── templates/      # Document templates (.md only)
├── scripts/
│   └── convert.sh      # Markdown ↔ DOCX conversion utility
└── .gitignore          # Excludes *.docx, *.pdf from source control
```

**Agent Output Rules**:
- **Claude**: Always outputs markdown (`.md`)
- **Gemini**: Returns analysis as markdown
- **Codex**: Produces markdown documentation alongside code
- **Cursor**: Creates markdown artifacts

**Conversion Workflow**:
```bash
# When external DOCX arrives
./scripts/convert.sh docx2md external-doc.docx docs/specs/imported-spec.md

# When sharing requires DOCX
./scripts/convert.sh md2docx docs/specs/feature.md output/feature.docx
```

---

## Rationale

### Technical Reasons

**1. Version Control Excellence**
- Markdown is plain text, enabling meaningful diffs
- Git can merge markdown changes from multiple contributors
- Full history visible: who changed what, when, and why
- Can revert to any previous version easily

**2. Tool Independence**
- Any text editor can open markdown
- No Microsoft Word, Google Docs, or Adobe Acrobat required
- Future-proof: markdown will outlive proprietary formats
- Platform-agnostic: works on macOS, Linux, Windows

**3. AI Agent Compatibility**
- All AI agents (Claude, ChatGPT, Gemini, Codex, Cursor) understand markdown
- Agents can read, write, and modify markdown programmatically
- No format conversion needed between agent handoffs
- Consistent output format reduces integration complexity

**4. Developer Workflow Integration**
- Markdown lives alongside code in the repository
- Same git commands manage code and docs
- IDEs and code editors have excellent markdown support
- CI/CD can validate, lint, and generate docs from markdown

### Business Reasons

**1. Cost Reduction**
- No Microsoft Office licenses required
- No Adobe Acrobat subscriptions needed
- Free tools (VSCode, Typora, Obsidian) available
- Lower barrier to entry for contributors

**2. Collaboration Efficiency**
- Multiple people can edit simultaneously (via git branches)
- Code review workflows apply to documentation
- Asynchronous collaboration through pull requests
- Comments and feedback via GitHub discussions

**3. Consistency and Quality**
- Templates ensure uniform structure
- Linters enforce style guidelines
- Automated quality checks in CI/CD
- Easier to maintain documentation standards

**4. Audit and Compliance**
- Complete history of all changes
- Attribution for every modification
- Can prove when requirements were documented
- Supports compliance requirements

### Risk Mitigation

**Mitigates**:
- ✅ Documentation drift (single version, version-controlled)
- ✅ Format lock-in (plain text, universal compatibility)
- ✅ Loss of information (git history preserves everything)
- ✅ Access barriers (any tool can read markdown)
- ✅ Sync overhead (one canonical source)

**Introduces**:
- ⚠️ Learning curve for non-technical stakeholders (mitigated with training and conversion scripts)
- ⚠️ Sharing friction when executives expect `.docx` (mitigated with automated conversion)
- ⚠️ Limited formatting options compared to Word (mitigated with pandoc templates)

---

## Alternatives Considered

### Alternative 1: Confluence/Notion as Source of Truth

**Description**: Use Confluence or Notion wiki as primary documentation location

**Pros**:
- Rich editing interface
- Easy for non-technical users
- Built-in collaboration features
- Search and organization built-in

**Cons**:
- Proprietary platform lock-in
- Poor version control (limited history)
- Can't diff changes meaningfully
- Export/backup requires special tools
- AI agents need API integration
- Vendor outage impacts access
- Costs scale with users

**Why rejected**:
Version control and tool independence are non-negotiable requirements. Proprietary platforms create long-term risk and don't integrate well with AI agent workflows.

---

### Alternative 2: Microsoft Word/Google Docs

**Description**: Use `.docx` or Google Docs as primary format

**Pros**:
- Familiar to most users
- Rich formatting options
- Track changes feature
- Comments and suggestions
- Industry standard for many contexts

**Cons**:
- Binary format (can't diff meaningfully)
- Requires specific software/licenses
- Poor git integration
- AI agents struggle with proprietary formats
- Merge conflicts are painful
- Version history is limited
- Platform-dependent

**Why rejected**:
Binary formats are fundamentally incompatible with git-based version control and AI agent workflows. The formatting benefits don't outweigh the collaboration and tooling costs.

---

### Alternative 3: Mixed Format Approach

**Description**: Allow each agent/contributor to use their preferred format

**Pros**:
- Flexibility for contributors
- Use best tool for each job
- No one forced to learn new tools

**Cons**:
- No single source of truth
- Multiple versions quickly diverge
- Conversion overhead between formats
- Hard to know which version is authoritative
- Maintenance nightmare
- Tool compatibility issues
- Information gets lost in conversion

**Why rejected**:
This is the chaos we're explicitly trying to avoid. The short-term flexibility creates long-term technical debt and organizational confusion.

---

### Alternative 4: Do Nothing (Status Quo)

**Description**: Continue without explicit format policy

**Pros**:
- No change management required
- No learning curve
- No tooling investment

**Cons**:
- Documentation fragmentation continues
- Version conflicts multiply
- Information gets lost or outdated
- Agent coordination becomes impossible
- Technical debt accumulates
- Team wastes time on format issues

**Why rejected**:
The cost of inaction far exceeds the cost of establishing clear standards. Without SSOT, the entire Slack-HQ system cannot function effectively.

---

## Consequences

### Positive Consequences

**Technical**:
- ✅ Perfect git integration: meaningful diffs, clean merges, full history
- ✅ AI agents produce compatible outputs without conversion
- ✅ Automation-friendly: scripts can parse and generate markdown easily
- ✅ Search and discovery: grep, ripgrep, and IDE search work perfectly
- ✅ CI/CD integration: can validate, lint, and generate docs automatically
- ✅ Future-proof: markdown is 20+ years old and still going strong

**Business**:
- ✅ Zero licensing costs for documentation tools
- ✅ Lower barrier to contribution (any text editor works)
- ✅ Faster collaboration (git workflows proven at scale)
- ✅ Better audit trail (every change tracked)
- ✅ Vendor independence (not locked into any platform)

**Team/Process**:
- ✅ One canonical version eliminates "which doc is current?" questions
- ✅ Code and docs follow same workflow (familiar to engineers)
- ✅ Templates ensure consistency across all documentation
- ✅ Reduced context switching (docs live with code)

---

### Negative Consequences

**Technical**:
- ⚠️ Limited formatting: No fancy fonts, complex tables, embedded videos
  - **Mitigation**: Pandoc supports advanced markdown; link to external media when needed
- ⚠️ Conversion required for stakeholders expecting Word docs
  - **Mitigation**: Automated `convert.sh` script makes this one command
- ⚠️ Images must be managed separately (not embedded)
  - **Mitigation**: Standard `/media` directory pattern; git LFS for large images

**Business**:
- ⚠️ Executives may expect `.docx` format for formal documents
  - **Mitigation**: Convert to `.docx` for final delivery; maintain markdown as source
- ⚠️ External collaborators may not know markdown
  - **Mitigation**: Provide markdown cheat sheet; offer to convert their docs

**Team/Process**:
- ⚠️ Learning curve for non-technical team members
  - **Mitigation**: Training session; templates with examples; pair with technical mentor
- ⚠️ Process change required for those accustomed to Word/Docs
  - **Mitigation**: Phase-in period; support during transition; highlight benefits early
- ⚠️ Review process different from Word track changes
  - **Mitigation**: GitHub PR reviews are more powerful; visual diff tools available

---

### Neutral Consequences

- 📝 File extensions change from `.docx` to `.md`
- 📝 Preview tools different (VSCode, GitHub, Typora vs Word)
- 📝 Formatting syntax visible (Markdown symbols) instead of WYSIWYG
- 📝 Collaboration moves from email attachments to git pull requests

---

## Implementation

### Migration Plan

**Phase 1: Foundation** (Completed 2025-11-02)
- ✅ Create `/docs` structure with templates
- ✅ Implement `scripts/convert.sh` for conversions
- ✅ Update `.gitignore` to exclude binary formats
- ✅ Document SSOT policy in `README.md`
- ✅ Create ADR (this document)

**Phase 2: Agent Configuration** (Completed 2025-11-02)
- ✅ Document Claude output contract (`/agents/claude.md`)
- ✅ Define agent coordination rules (`/agents/agents.md`)
- ✅ Establish Linear ID naming convention
- ✅ Create Definition of Done with SSOT requirements

**Phase 3: Adoption** (Ongoing)
- [ ] All new documentation created as markdown
- [ ] Existing docs converted on an as-needed basis
- [ ] Team trained on markdown basics
- [ ] Conversion workflow demonstrated

**Phase 4: Automation** (Future)
- [ ] Pre-commit hooks validate markdown
- [ ] CI checks for Linear ID presence
- [ ] Automated syncing to Notion
- [ ] Documentation linting in CI/CD

### Rollback Strategy

If markdown proves unworkable (unlikely):

1. **Create new `.docx` templates** based on current markdown templates
2. **Update agent contracts** to produce DOCX via LibreOffice/pandoc
3. **Move existing markdown** to `/archive` directory
4. **Update workflows** to use Word/Docs collaboration
5. **Accept consequences**: loss of git integration, binary diffs, tool lock-in

**Rollback complexity**: High
**Rollback time**: 2-3 weeks
**Likelihood needed**: <5%

### Success Criteria

How we'll know this decision was successful:

- [ ] **6 months**: All new documentation in markdown format
- [ ] **6 months**: No version conflicts or "which is current?" confusion
- [ ] **6 months**: AI agents producing compatible outputs
- [ ] **12 months**: Team prefers markdown workflow over Word
- [ ] **12 months**: Zero proprietary formats in git repository
- [ ] **12 months**: Documentation quality and consistency improved

---

## Impact Analysis

### Affected Systems

- **Git Repository**: Primary beneficiary; clean diffs, mergeable docs
- **Linear**: No direct impact; issues reference markdown docs
- **Notion**: Requires sync strategy (markdown → Notion)
- **CI/CD**: New validation steps for markdown
- **Agents (Claude, Gemini, Codex, Cursor)**: Must output markdown

### Affected Teams

- **Engineering**: Minimal impact; already use markdown
- **Product/Design**: Learning curve; will need markdown training
- **Executives**: May request DOCX for presentations (conversion provided)
- **External Collaborators**: May send DOCX; conversion workflow available

### Affected Processes

- **Documentation Creation**: Use templates, write markdown
- **Review Process**: GitHub PR reviews instead of Word track changes
- **Sharing Externally**: Convert markdown to DOCX/PDF before sending
- **Archiving**: Git history is archive; no separate document vault needed

---

## Dependencies

### Technical Dependencies

- [x] Pandoc installed for markdown ↔ DOCX conversion
- [x] GitHub repository set up
- [x] `.gitignore` configured to exclude binary formats
- [x] Templates created for all document types

### Decision Dependencies

- [x] Repository structure decided (SLHQ-2)
- [x] Agent roles defined (SLHQ-6)
- [x] Output contracts documented (SLHQ-7)

### Resource Dependencies

- **Budget**: $0 (all open source tools)
- **Time**: 2 weeks for full team adoption
- **Training**: 1-hour markdown workshop for non-technical team

---

## Timeline

| Milestone | Date | Owner | Status |
|-----------|------|-------|--------|
| Decision proposed | 2025-11-01 | Kelvin | ✅ Complete |
| Foundation implemented | 2025-11-02 | Claude | ✅ Complete |
| Agent contracts documented | 2025-11-02 | Claude | ✅ Complete |
| Decision accepted | 2025-11-02 | Kelvin | ✅ Complete |
| Team training | 2025-11-03 | Kelvin | Planned |
| Full adoption checkpoint | 2026-05-02 | Team | Planned |

---

## Stakeholders

### Decision Makers
- **Kelvin Abuah**: Project owner, final approval authority

### Consulted
- **Claude (AI)**: Agent coordination requirements
- **GitHub Community**: Best practices for docs-as-code

### Informed
- **All AI Agents**: Must follow markdown output rules
- **All Contributors**: Must use markdown for documentation

---

## Risks & Mitigation

| Risk | Probability | Impact | Mitigation Strategy |
|------|-------------|--------|---------------------|
| Team rejects markdown workflow | Low | High | Training, show benefits early, provide support |
| Executive pushback on format | Medium | Low | Automated conversion to DOCX, no visible impact |
| Lost formatting in complex docs | Low | Medium | Use pandoc templates, accept limitations |
| External collaborators send DOCX | High | Low | Convert to markdown, document workflow |
| Notion sync becomes manual | Medium | Medium | Build automation, or accept one-way sync |

---

## Review & Evaluation

### Review Process
- **Review period**: 1 week (2025-11-01 to 2025-11-08)
- **Reviewers**: Kelvin Abuah (project owner)
- **Feedback**: None (decision accepted immediately for greenfield project)

### Post-Implementation Review

**6-Month Checkpoint (2026-05-02)**:
- Are all new docs in markdown?
- Has version conflict problem been solved?
- Is team satisfied with workflow?
- Any unexpected issues?

**12-Month Checkpoint (2026-11-02)**:
- Review all success criteria
- Evaluate team productivity impact
- Assess documentation quality trend
- Decide if any adjustments needed

### Success Metrics

| Metric | Target | Measurement Method |
|--------|--------|-------------------|
| % of docs in markdown | 100% | Count files in `/docs` |
| Version conflicts | 0 | Git merge issues per month |
| Documentation updates/month | >10 | Git commits to `/docs` |
| Team satisfaction | >4/5 | Quarterly survey |
| Time to create doc | <30min | Self-reported average |

---

## Related Documents

### Specifications
- [SLHQ-2: Repository Structure](/docs/tasks/initial-setup.md)
- [README.md: SSOT Policy](/README.md#single-source-of-truth-ssot-policy)

### Other ADRs
- None yet (this is ADR-001)

### Runbooks
- [Definition of Done](/docs/runbooks/definition-of-done.md)
- [Document Conversion Workflow](planned)

### External References
- [Markdown Guide](https://www.markdownguide.org/)
- [GitHub Flavored Markdown Spec](https://github.github.com/gfm/)
- [Pandoc User's Guide](https://pandoc.org/MANUAL.html)
- [Docs as Code Movement](https://www.writethedocs.org/guide/docs-as-code/)

---

## Notes

### Discussion Summary

**Decision made in inaugural project setup**:
- Problem: Need clear documentation strategy for AI agent coordination
- Solution: Markdown as SSOT, with conversion scripts for compatibility
- Rationale: Version control, AI agent compatibility, tool independence
- Trade-off: Learning curve for non-technical users vs. long-term benefits

### Assumptions

- **Git proficiency**: Contributors have basic git knowledge or can learn
- **Text editor access**: Everyone can install VSCode, Vim, or similar
- **Conversion acceptable**: Stakeholders OK receiving converted DOCX when needed
- **Markdown sufficient**: Markdown formatting adequate for all documentation needs
- **Pandoc available**: Conversion tool can be installed on all systems

### Key Insights

1. **Markdown is 80/20**: Covers 80% of formatting needs with 20% of complexity
2. **Version control is non-negotiable**: Binary formats fundamentally don't work with git
3. **AI agents need plain text**: Markdown is lingua franca for AI collaboration
4. **Long-term wins short-term pain**: Initial learning curve pays off quickly

---

## Changelog

| Date | Author | Changes |
|------|--------|---------|
| 2025-11-02 | Claude | Initial ADR created and accepted |

---

## Appendix

### Markdown Quick Reference

**Headers**:
```markdown
# H1 - Document Title
## H2 - Major Section
### H3 - Subsection
```

**Emphasis**:
```markdown
*italic* or _italic_
**bold** or __bold__
***bold italic***
```

**Lists**:
```markdown
- Bullet point
- Another point
  - Nested point

1. Numbered item
2. Another numbered item
```

**Links**:
```markdown
[Link text](https://url)
[Relative link](/docs/specs/feature.md)
```

**Code**:
```markdown
Inline `code` with backticks

```language
Code block with syntax highlighting
```
```

**Tables**:
```markdown
| Header 1 | Header 2 |
|----------|----------|
| Cell 1   | Cell 2   |
```

### Conversion Examples

**Convert DOCX to Markdown**:
```bash
./scripts/convert.sh docx2md external-doc.docx docs/specs/imported-spec.md
```

**Convert Markdown to DOCX**:
```bash
./scripts/convert.sh md2docx docs/specs/feature-spec.md output/feature-spec.docx
```

**Batch Convert All Specs**:
```bash
for md in docs/specs/*.md; do
  ./scripts/convert.sh md2docx "$md" "output/$(basename "$md" .md).docx"
done
```

### Recommended Tools

**Editors**:
- **VSCode**: Free, excellent markdown support, preview, extensions
- **Typora**: WYSIWYG markdown editor (paid but affordable)
- **Obsidian**: Free, great for linked notes and knowledge bases
- **Vim/Neovim**: For power users, excellent markdown plugins

**Preview**:
- **VSCode Preview**: Built-in, live preview with `Ctrl+Shift+V`
- **GitHub**: Native markdown rendering
- **Marked 2 (macOS)**: Advanced preview with export options

**Linters**:
- **markdownlint**: Style checking and consistency
- **vale**: Prose linting for documentation quality

### Training Resources

- **Markdown Guide**: https://www.markdownguide.org/
- **GitHub Markdown**: https://guides.github.com/features/mastering-markdown/
- **Interactive Tutorial**: https://www.markdowntutorial.com/
- **Cheat Sheet**: https://www.markdownguide.org/cheat-sheet/

---

**This decision establishes the foundation for all documentation practices in Slack-HQ. All contributors must follow the markdown-first approach.**
