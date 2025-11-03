# Artifacts

This directory stores AI-generated documents and derivative outputs. Artifacts are **not canonical sources** - they are generated from or used to create markdown sources in `/docs`.

## Purpose

The `/artifacts` directory serves as:
- **Temporary storage** for AI-generated documents before conversion to markdown
- **Archive** for generated outputs that complement markdown sources
- **Collaboration space** for documents created by different AI agents
- **Conversion workspace** for documents that need format transformation

## Organization

Artifacts are organized by AI agent to maintain clear provenance:

```
artifacts/
├── README.md           # This file
├── chatgpt/            # ChatGPT-generated documents (.docx, .pdf, .xlsx)
│   └── README.md       # ChatGPT-specific documentation
└── claude/             # Claude-generated documents (.md, .txt, logs)
    └── README.md       # Claude-specific documentation
```

## Policy

### What Gets Stored

**Store in artifacts/ when:**
- AI agent generates a document in non-markdown format (.docx, .pdf)
- Need to preserve generated output for comparison or reference
- Document is part of a conversion workflow (e.g., DOCX → markdown)
- Generated output supplements but doesn't replace markdown source

**Examples:**
- ChatGPT-generated Word documents before conversion to markdown
- PDF exports from AI tools for stakeholder sharing
- Generated diagrams or visualizations
- Session logs and telemetry data

### What Doesn't Get Stored

**Do NOT store in artifacts/ when:**
- The output is already markdown and belongs in `/docs`
- The file is a source document (those go in `/docs`)
- The output is temporary and has no archival value
- The content contains secrets or credentials (use `.env` instead)

## Gitignore Strategy

The directory structure is tracked in Git, but contents are ignored:

```gitignore
# Track structure
!artifacts/README.md
!artifacts/.gitkeep
!artifacts/chatgpt/
!artifacts/chatgpt/README.md
!artifacts/claude/

# Ignore contents
artifacts/**/*
```

**Rationale:** This ensures:
- Repository structure is preserved for new developers
- Generated files don't bloat the repository
- Each developer/agent can generate their own artifacts locally
- No accidental commits of large generated files

## Conversion Workflows

### ChatGPT → Markdown
```bash
# 1. ChatGPT generates DOCX
# (Save to artifacts/chatgpt/draft.docx)

# 2. Convert to markdown
./scripts/convert.sh docx2md artifacts/chatgpt/draft.docx

# 3. Move to appropriate /docs directory
mv artifacts/chatgpt/draft.md docs/specs/feature-spec.md

# 4. Clean up artifact (optional)
rm artifacts/chatgpt/draft.docx
```

### Markdown → DOCX (for sharing)
```bash
# 1. Source is in /docs
# docs/specs/feature-spec.md

# 2. Generate DOCX for stakeholders
./scripts/convert.sh md2docx docs/specs/feature-spec.md

# 3. DOCX is created in artifacts/
# artifacts/chatgpt/feature-spec.docx

# 4. Share with stakeholders, keep markdown as SSOT
```

## Lifecycle Management

### Retention Policy

**Keep artifacts when:**
- Document is actively referenced in workflows
- Provides valuable historical context
- Part of an ongoing conversion/iteration cycle
- Contains unique information not in markdown sources

**Delete artifacts when:**
- Conversion to markdown is complete and verified
- Document is outdated (> 30 days with no updates)
- Space cleanup is needed
- Replaced by updated version

### Cleanup Commands

```bash
# List old artifacts (30+ days)
find artifacts/ -type f -mtime +30 ! -name "README.md" ! -name ".gitkeep"

# Delete old artifacts
find artifacts/ -type f -mtime +30 ! -name "README.md" ! -name ".gitkeep" -delete

# Archive artifacts to external storage
tar -czf artifacts-backup-$(date +%Y%m%d).tar.gz artifacts/
```

## Best Practices

1. **Name clearly** - Use descriptive names with dates if needed
   - `feature-spec-draft-2025-11-03.docx`
   - `session-log-authentication-20251103.txt`

2. **Document provenance** - Note which AI agent generated what
   - ChatGPT outputs → `artifacts/chatgpt/`
   - Claude outputs → `artifacts/claude/`

3. **Convert promptly** - Don't let artifacts accumulate
   - Convert to markdown within 1-2 days
   - Move to `/docs` as soon as verified

4. **Clean regularly** - Remove unnecessary artifacts
   - Weekly cleanup of completed conversions
   - Monthly cleanup of old artifacts

5. **Never commit secrets** - Artifacts are gitignored but stay vigilant
   - Review before sharing any artifact externally
   - Use `.env` for secrets, never artifacts/

## Integration with Documentation

Artifacts complement the documentation system:

- **Source of Truth**: `/docs` (markdown)
- **Working Copies**: `/artifacts` (various formats)
- **Conversion Tool**: `/scripts/convert.sh`
- **Version Control**: Git (tracks `/docs`, ignores `/artifacts`)

**Principle:** Markdown is canonical, artifacts are temporary or derivative.

## Examples

### Example 1: Feature Specification Workflow
```bash
# ChatGPT creates initial draft
# → artifacts/chatgpt/auth-spec.docx

# Convert to markdown
./scripts/convert.sh docx2md artifacts/chatgpt/auth-spec.docx

# Move to specs
mv artifacts/chatgpt/auth-spec.md docs/specs/authentication.md

# Edit and improve in markdown
# docs/specs/authentication.md is now SSOT

# Clean up artifact
rm artifacts/chatgpt/auth-spec.docx
```

### Example 2: Session Logs
```bash
# Claude generates session log
# → artifacts/claude/session-a1b2c3d4.txt

# Reference in session tracking
# (Link preserved, log available locally)

# Archive after 30 days
# (Move to external backup, delete local)
```

### Example 3: Stakeholder Presentation
```bash
# Markdown spec exists
# docs/specs/feature-roadmap.md

# Generate DOCX for executives
./scripts/convert.sh md2docx docs/specs/feature-roadmap.md

# Share artifacts/chatgpt/feature-roadmap.docx externally

# Keep markdown as SSOT, artifact as derivative
```

## Troubleshooting

### Issue: Git keeps trying to commit artifacts
**Solution:** Verify `.gitignore` patterns are correct
```bash
git check-ignore -v artifacts/chatgpt/test.docx
# Should show: .gitignore:58:artifacts/**/* artifacts/chatgpt/test.docx
```

### Issue: Need to share artifact with team
**Solution:** Use external sharing (Slack, Google Drive), not Git
```bash
# Upload to Slack
slack files upload --file artifacts/chatgpt/spec.docx --channels #team

# Or use Google Drive, Notion, etc.
```

### Issue: Artifact conversion failed
**Solution:** Check script dependencies
```bash
# Verify pandoc is installed
which pandoc

# Test conversion manually
pandoc -f docx -t markdown artifacts/chatgpt/doc.docx -o test.md
```

## Related Documentation

- [Root README.md](../README.md) - Project overview and structure
- [CLAUDE.md](../CLAUDE.md) - AI agent instructions
- [/scripts/convert.sh](../scripts/convert.sh) - Conversion utility
- [/docs](../docs/) - Canonical markdown documentation

---

**Remember:** Artifacts are temporary, documentation is permanent. Always convert to markdown for long-term storage.
