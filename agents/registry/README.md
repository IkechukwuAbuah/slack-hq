# Agent Registry

This directory provides a central registry of all AI agents available in The Council workspace, their capabilities, and how to invoke them.

## Purpose

The agent registry serves as:
- **Discovery system** - Find the right agent for your task
- **Capability catalog** - Understand what each agent can do
- **Integration guide** - Learn how to work with each agent
- **Metadata store** - Track agent versions, status, and ownership

**Key principle:** One place to discover all available agents and their capabilities.

## Registry Structure

```
agents/registry/
├── README.md               # This file
├── claude-code.md          # Claude Code agent profile
├── chatgpt.md              # ChatGPT agent profile
├── gemini.md               # Gemini CLI agent profile
├── cursor.md               # Cursor CLI agent profile
├── codex.md                # Codex CLI agent profile
└── council-bot.md          # Council Bot (Slack integration)
```

Each agent has a profile documenting its capabilities and usage.

## Agent Profile Template

When adding a new agent to the registry, use this template:

```markdown
# [Agent Name]

## Overview
- **Type:** [CLI / Web / Integrated]
- **Version:** [Current version]
- **Status:** [Active / Experimental / Deprecated]
- **Owner:** [Team or person responsible]
- **Documentation:** [Link to official docs]

## Capabilities

### Primary Strengths
- Capability 1
- Capability 2
- Capability 3

### Use Cases
- Use case 1
- Use case 2
- Use case 3

## Access

### Authentication
[How to authenticate]

### Environment Setup
[Required environment variables or configuration]

### Installation
[How to install/enable]

## Usage

### Basic Usage
[Simple example]

### Common Patterns
[Frequently used workflows]

### Integration Points
[How this agent connects with others]

## Limitations

### Known Constraints
- Constraint 1
- Constraint 2

### When NOT to Use
- Scenario 1
- Scenario 2

## Examples

### Example 1: [Task Name]
[Detailed example with code/commands]

### Example 2: [Task Name]
[Another detailed example]

## Related Agents
- [Agent 1] - [Relationship]
- [Agent 2] - [Relationship]

## Changelog
- [Date]: [Change description]
```

## How to Use the Registry

### For Finding Agents

**By Capability:**
```bash
# Search for specific capability
grep -r "codebase analysis" agents/registry/

# Result: gemini.md matches
```

**By Task Type:**
- Code review → Claude Code, Codex
- Large context analysis → Gemini CLI
- Interactive development → Cursor CLI
- Autonomous implementation → Codex CLI
- Documentation → Claude Code, ChatGPT
- Slack operations → Council Bot

### For Integration Planning

**Check compatibility:**
1. Read agent profiles
2. Identify integration points
3. Plan handoff workflows
4. Test integration

**Example:**
```
Task: Security audit of large codebase

Plan:
1. Gemini CLI - Analyze entire codebase for patterns
2. Claude Code - Generate detailed security report
3. Council Bot - Post findings to #security channel
4. Codex CLI - Implement fixes autonomously
```

## Core Agents

### Claude Code (Primary)
**Profile:** `claude-code.md`

**Key capabilities:**
- Code analysis and review
- Documentation generation
- Session tracking
- Multi-agent coordination
- Slack integration via Council Bot

**When to use:**
- Default agent for most tasks
- Coordination hub for multi-agent workflows
- Session tracking and progress updates

### ChatGPT (Document Generation)
**Profile:** `chatgpt.md`

**Key capabilities:**
- DOCX/PDF generation
- Formal documentation
- Stakeholder presentations
- Rich text formatting

**When to use:**
- Need formatted documents (DOCX, PDF)
- Stakeholder-facing materials
- Initial drafts before markdown conversion

### Gemini CLI (Large Context)
**Profile:** `gemini.md`

**Key capabilities:**
- Massive context window
- Entire codebase analysis
- Cross-file pattern detection
- Architecture understanding

**When to use:**
- Analyzing 100+ files at once
- Understanding system architecture
- Finding patterns across codebase

### Cursor CLI (Interactive)
**Profile:** `cursor.md`

**Key capabilities:**
- Interactive conversations with memory
- Project-specific rules (`.cursor/rules`)
- Iterative development
- Context-aware assistance

**When to use:**
- Iterative development workflows
- Need conversation history
- Project has specific coding standards

### Codex CLI (Autonomous)
**Profile:** `codex.md`

**Key capabilities:**
- Autonomous reasoning and implementation
- Built-in sandboxing
- Progressive approval workflows
- AGENTS.md integration

**When to use:**
- Autonomous implementation needed
- Want to see reasoning process
- Need sandboxed execution
- Complex debugging with AI assistance

### Council Bot (Slack)
**Profile:** `council-bot.md`

**Key capabilities:**
- Slack workspace integration
- Message posting and threading
- Channel management
- User coordination

**When to use:**
- Posting to Slack channels
- Council updates and notifications
- Multi-agent coordination via Slack

## Discovery Patterns

### Pattern 1: By Task Type

```
Task: Code Review
→ Check registry for "code review" capability
→ Found: claude-code.md, codex.md
→ Choose: claude-code for interactive, codex for autonomous
```

### Pattern 2: By Scale

```
Task: Large codebase analysis
→ Check registry for "context window" or "scale"
→ Found: gemini.md (massive context)
→ Use: Gemini CLI for initial analysis
→ Then: Claude Code for detailed follow-up
```

### Pattern 3: By Output Format

```
Task: Stakeholder presentation
→ Check registry for "DOCX" or "PDF"
→ Found: chatgpt.md
→ Use: ChatGPT for formatted document
→ Then: Convert to markdown for SSOT
```

## Integration Workflows

### Multi-Agent Workflows

**Example: Feature Implementation**
```
1. Gemini CLI - Analyze existing patterns
2. Claude Code - Design architecture
3. Codex CLI - Implement autonomously
4. Claude Code - Review and refine
5. Council Bot - Post completion update
```

**Example: Documentation**
```
1. Claude Code - Generate markdown spec
2. ChatGPT - Create DOCX for stakeholders
3. Claude Code - Store markdown in /docs
4. Council Bot - Share with team
```

### Handoff Protocol

**When handing off between agents:**

1. **Document context**
   ```markdown
   ## Context for [Next Agent]
   - Task: [What needs to be done]
   - Current state: [What's been completed]
   - Next steps: [What to do next]
   - Files: [Relevant file paths]
   ```

2. **Specify in Slack**
   ```
   Task handed off from Claude to Codex:
   - Context: Authentication implementation
   - Files: src/auth/*.ts
   - Next: Implement OAuth flow
   - Thread: [Link to discussion]
   ```

3. **Update session tracking**
   ```bash
   /session-stop --notes "Handed off to Codex for implementation"
   ```

## Maintenance

### Adding New Agents

When a new agent joins The Council:

1. **Create profile**
   ```bash
   touch agents/registry/new-agent.md
   # Use template above
   ```

2. **Document capabilities**
   - What it does well
   - What it doesn't do well
   - Integration points

3. **Update registry README**
   - Add to core agents list
   - Update discovery patterns
   - Add integration examples

4. **Test integration**
   - Verify agent works as expected
   - Test with existing agents
   - Document any issues

### Updating Agent Profiles

Update profiles when:
- Agent version changes
- New capabilities added
- Limitations discovered
- Integration patterns change

### Deprecating Agents

When an agent is no longer used:

1. Mark as **Deprecated** in profile
2. Document replacement agent
3. Add migration guide
4. Keep profile for historical reference

## Best Practices

### 1. Keep Profiles Current
Update profiles when agent capabilities change:
```bash
# After agent update
# Edit agents/registry/agent-name.md
# Update version, capabilities, examples
```

### 2. Document Integration Points
Show how agents work together:
```markdown
## Integration Points
- Hands off to Claude Code for refinement
- Receives context from Gemini CLI
- Posts updates via Council Bot
```

### 3. Provide Concrete Examples
Always include real-world usage examples:
```markdown
## Example: Security Audit
gemini -p "@./ Find all authentication code" > analysis.txt
# Then use Claude Code to generate report
```

### 4. Track Changes
Document significant changes to agents:
```markdown
## Changelog
- 2025-11-03: Added Slack integration
- 2025-10-15: Improved context handling
- 2025-09-01: Initial version
```

## Registry Queries

### Find Agent by Capability
```bash
# Search for specific capability
grep -r "autonomous" agents/registry/
# Returns: codex.md

grep -r "large context" agents/registry/
# Returns: gemini.md
```

### List All Active Agents
```bash
# Find agents marked as "Active"
grep -l "Status: Active" agents/registry/*.md
```

### Find Integration Examples
```bash
# Search for integration patterns
grep -A 10 "Integration" agents/registry/*.md
```

## Related Documentation

- [agents/agents.md](../agents.md) - Agent coordination guide
- [agents/claude.md](../claude.md) - Claude-specific instructions
- [agents/council-bot-reference.md](../council-bot-reference.md) - Council Bot details
- [TOOL-REGISTRY.md](../../TOOL-REGISTRY.md) - Comprehensive tool catalog
- [AGENTS.md](../../AGENTS.md) - AI agent configuration

---

**Remember:** The registry is your map to The Council's capabilities. Keep it current, and use it to plan multi-agent workflows effectively.
