# ChatGPT Prompts for Session Tracking Implementation

This directory contains three sequential prompts for ChatGPT Pro to design and implement session tracking for the slack-hq project.

## Overview

**Goal**: Implement chronological session tracking in slack-hq similar to the claude md project's sophisticated session management system.

**ChatGPT's Role**: 
- Research & Analysis Lead
- Architecture & Design Lead  
- Council Reporter & Communicator

## Prompt Sequence

### 1. Research & Analysis (Codex)
**File**: `01-research-analysis-codex.md`

**Purpose**: Use Codex to analyze both the slack-hq GitHub repository and the local claude md reference implementation to create a comprehensive research report.

**Key Deliverables**:
- Current state analysis of slack-hq
- Deep-dive review of claude md session tracking
- Gap analysis (what's missing)
- Architecture design (how to adapt)
- Implementation roadmap (phased approach)

**Prerequisites**:
- Access to https://github.com/IkechukwuAbuah/slack-hq via Codex
- Reference files from `/Users/x/Downloads/claude md/.claude` (to be provided)

---

### 2. Implementation Design
**File**: `02-implementation-design.md`

**Purpose**: Based on the research, create a complete specification document that other agents can implement.

**Key Deliverables**:
- `/session` slash command specification
- Session data schema (JSON structure)
- File structure proposal
- Slack integration design
- Multi-agent coordination strategy
- Complete spec in `docs/specs/session-tracking.md` format

**Prerequisites**:
- Completed research report from Prompt 1
- Familiarity with slack-hq's existing structure

---

### 3. Council Communication
**File**: `03-council-communication.md`

**Purpose**: Announce the session tracking feature to the AI Council in "The Council" Slack workspace and gather feedback.

**Key Deliverables**:
- GitHub issue creation
- Slack Block Kit formatted announcement
- Council feedback collection plan
- Implementation coordination strategy

**Prerequisites**:
- Completed specification from Prompt 2
- Access to Council Bot Slack credentials
- `gh` CLI or GitHub web access

---

## How to Use These Prompts

### Step 1: Research Phase
1. Open ChatGPT Pro
2. Copy the entire contents of `01-research-analysis-codex.md`
3. Paste into ChatGPT
4. Provide additional context when requested (claude md reference files)
5. Wait for comprehensive research report

### Step 2: Design Phase
1. Attach the research report from Step 1
2. Copy the entire contents of `02-implementation-design.md`
3. Paste into ChatGPT
4. Review the generated specification
5. Iterate if needed based on your requirements

### Step 3: Communication Phase
1. Attach the specification from Step 2
2. Copy the entire contents of `03-council-communication.md`
3. Paste into ChatGPT
4. Use the generated GitHub issue and Slack message
5. Post to the Council and gather feedback

---

## Reference: claude md Session Tracking

The reference implementation has these components:

### Session Data Storage
- Location: `.claude/data/sessions/*.json`
- Format: `{session_id, prompts[], agent_name, timestamp}`

### Session Manager Output Style
- Location: `.claude/output-styles/session-manager.md`
- Features: session status, history, context management, task continuity

### Session Lifecycle Hooks
- `session_start.py` - Initializes development context
- `stop.py` - Saves session insights

### Status Line Integration
- Multiple versions: `status_line_v*.py`
- Shows: session ID, duration, context usage

---

## Expected Timeline

- **Research Phase**: 1-2 hours (thorough analysis)
- **Design Phase**: 2-3 hours (complete specification)
- **Communication Phase**: 30 minutes (posting and monitoring)
- **Total**: ~4-6 hours for complete research, design, and announcement

---

## Success Criteria

### Research Success
✅ Comprehensive understanding of both slack-hq and claude md architectures
✅ Clear gap analysis identifying what needs to be built
✅ Phased implementation roadmap with effort estimates

### Design Success
✅ Complete specification ready for implementation
✅ All ADRs documented with rationale
✅ Clear integration points with Council Bot
✅ Multi-agent coordination strategy defined

### Communication Success
✅ GitHub issue created and linked
✅ Slack announcement posted to #council-ops
✅ At least 3 Council members engaged
✅ Clear next steps and ownership assigned

---

## Notes

- These prompts are designed to be used sequentially
- Each prompt builds on the previous one
- ChatGPT should have access to Codex for GitHub repository analysis
- The final deliverables will be used by multiple AI agents (Claude, Cursor, Windsurf, etc.)
- Focus on documentation-first approach (slack-hq philosophy)

---

## Contact & Feedback

Project: https://github.com/IkechukwuAbuah/slack-hq
Workspace: "The Council" Slack workspace
Bot: Council Bot (for Slack integration)

For questions or feedback on these prompts, update this README or post in #council-ops.
