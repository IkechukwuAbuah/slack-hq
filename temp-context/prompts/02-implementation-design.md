# Design Task: Session Tracking Slash Command for slack-hq

## Context
Based on your research analysis (attach the previous report), design the complete implementation for session tracking in the slack-hq project.

## Project Details
- **Repository**: https://github.com/IkechukwuAbuah/slack-hq
- **Stack**: Documentation-first, Slack CLI, no runtime code yet
- **Agents**: Claude Code, ChatGPT, Codex, Gemini, Grok, Cursor, Warp, Windsurf
- **Workspace**: "The Council" Slack workspace
- **Bot**: Council Bot (already deployed with comprehensive OAuth scopes)

## Your Role
You are the **Architecture & Design Lead** for the AI Council. Create a complete specification that other agents can implement.

## Design Requirements

### 1. Slash Command Specification
Design a `/session` slash command with subcommands:

```bash
/session status          # Show current session details
/session history         # List recent sessions chronologically  
/session start [name]    # Begin a new named session
/session stop            # End current session and save details
/session show <id>       # Display specific session details
/session post            # Post current session to Slack channel
```

### 2. Session Data Schema
Define the JSON structure for session files:

```json
{
  "session_id": "uuid",
  "agent_name": "string",
  "started_at": "ISO8601",
  "ended_at": "ISO8601 | null",
  "project": "slack-hq",
  "working_directory": "path",
  "activities": [],
  "prompts": [],
  "tools_used": [],
  "files_modified": [],
  "slack_channel": "string | null",
  "tags": [],
  "notes": "string"
}
```

Refine this schema based on your research.

### 3. File Structure
Specify exact files to create:

```
slack-hq/
├── .claude/
│   ├── commands/
│   │   └── session/
│   │       ├── status.md
│   │       ├── history.md
│   │       ├── start.md
│   │       ├── stop.md
│   │       ├── show.md
│   │       └── post.md
│   ├── data/
│   │   └── sessions/
│   │       └── .gitkeep
│   ├── hooks/
│   │   ├── session_start.sh
│   │   └── session_stop.sh
│   └── output-styles/
│       └── session-manager.md
├── docs/
│   └── specs/
│       └── session-tracking.md     # This spec you're creating
└── scripts/
    └── session.sh                   # Main CLI script
```

### 4. Slack Integration Design
Specify how sessions integrate with Council Bot:

- **Auto-posting**: Should session starts/stops post to `#council-ops`?
- **Manual posting**: How does `/session post` format messages?
- **Channel selection**: Should sessions post to project-specific channels?
- **Threading**: Should session updates be threaded conversations?

### 5. Multi-Agent Coordination
Design how multiple agents track sessions concurrently:

- **Session ownership**: How to identify which agent owns a session?
- **Concurrent sessions**: Can multiple agents have active sessions?
- **Session discovery**: How do agents discover each other's sessions?
- **Handoff protocol**: How to transfer session ownership between agents?

## Deliverables

Create a specification document (`docs/specs/session-tracking.md`) with:

### Section 1: Feature Overview
- What problem this solves
- User stories for each agent persona
- Success criteria

### Section 2: Technical Design
- Data schema (with examples)
- File structure
- Command specifications (with exact syntax)
- State machine diagram (session lifecycle)

### Section 3: Slack Integration
- API endpoints used
- Message format templates
- Channel posting rules
- Error handling

### Section 4: Implementation Guide
- Step-by-step instructions for each command
- Testing procedures
- Rollout plan

### Section 5: Usage Examples
- Example session workflows
- CLI command sequences
- Expected output samples

### Section 6: ADRs (Architecture Decision Records)
Document key decisions:
- ADR 001: Why JSON over SQLite for session storage
- ADR 002: Session data gitignore strategy
- ADR 003: Slack auto-posting vs. manual posting
- ADR 004: Multi-agent concurrency model

## Format Requirements
- Use slack-hq's existing template structure (see `docs/templates/spec.md`)
- Include Linear issue references: `SLHQ-XXX`
- Provide complete code examples for all scripts
- Include ASCII diagrams for workflows

## Council Bot Integration
Show exactly how each command uses Slack CLI:

```bash
# Example: /session post implementation
slack api chat.postMessage \
  --data '{
    "channel": "#council-ops",
    "text": "📊 Session Update",
    "blocks": [...]
  }' \
  --token "$SLACK_BOT_TOKEN"
```

## Testing Strategy
Define how to verify each feature works:
- Unit test cases (conceptual - no test framework yet)
- Integration test scenarios
- Manual testing checklist

## Migration Plan
If existing logs need to be migrated to the new session format, provide a migration script design.

## Future Enhancements
List features for v2:
- Session analytics dashboard
- Cross-project session linking
- Session templates for common workflows
- AI-generated session summaries

## Success Metrics
Define how to measure if session tracking is valuable:
- Agent adoption rate
- Sessions created per week
- Slack channel engagement
- Handoff success rate

---

Begin by outlining the specification structure, then fill in each section with complete, implementation-ready details. This spec will be reviewed by the Council and implemented by multiple agents.
