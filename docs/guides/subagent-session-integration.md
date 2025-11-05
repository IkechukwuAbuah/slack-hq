# Subagent Session Integration Guide

This guide explains how any subagent can log activities to parent sessions for comprehensive tracking and Slack updates.

## Architecture Overview

**Session tracking agents (session-tracker-2) CAN access Slack MCP tools directly** and handle all session operations including posting to Slack.

**Architecture:**
- **session-tracker-2**: Handles ALL session operations including Slack posting via `mcp__slack__*` tools
- **Other Subagents**: Log activities by calling session-tracker-2
- **Data Flow**: Subagent → session-tracker-2 → JSON file → Slack (all in one agent)

The session-tracker-2 agent has direct access to Slack MCP tools and posts session updates without requiring the main agent.

## Overview

When the main Claude Code agent launches a subagent via the Task tool, the subagent should:

1. **Receive parent session context** in its prompt
2. **Log its activities** by calling the session-tracker-2 subagent
3. **Track handoffs** when transferring work
4. **Session-tracker-2 handles Slack posting** directly when needed

## Integration Pattern

### Step 1: Parent Agent Passes Session Context

When launching a subagent, include session context in the prompt:

```javascript
// In main Claude Code agent
Task({
  subagent_type: "test-writer-fixer",
  prompt: `
    PARENT_SESSION_ID: ${current_session_id}
    PARENT_SESSION_CHANNEL: C09Q8KCGM9C
    PARENT_SESSION_THREAD_TS: ${session.slack_message_ts}

    Task: Write comprehensive tests for authentication module

    IMPORTANT: When you complete work, log your activity to the parent session.
  `,
  description: "Write authentication tests"
})
```

### Step 2: Subagent Receives Context

The subagent should extract session context from its prompt:

```javascript
// In subagent prompt parsing
const SESSION_ID = extractFromPrompt("PARENT_SESSION_ID");
const CHANNEL = extractFromPrompt("PARENT_SESSION_CHANNEL");
const THREAD_TS = extractFromPrompt("PARENT_SESSION_THREAD_TS");
```

### Step 3: Subagent Logs Activity

After completing work, the subagent calls session-tracker-2 to log the activity:

```javascript
// Launch session-tracker-2 to log activity
Task({
  subagent_type: "session-tracker-2",
  prompt: `
    Operation: log_activity
    Session ID: ${SESSION_ID}
    Activity Type: code
    Summary: Created 15 unit tests with 100% coverage for JWT authentication
    Files: [
      "tests/auth/jwt.test.ts",
      "tests/auth/middleware.test.ts",
      "tests/auth/validation.test.ts"
    ]
    Tools: ["Write", "Edit", "Bash"]
    Subagent: test-writer-fixer
  `,
  description: "Log test-writer-fixer activity"
})
```

**Note:** session-tracker-2 can optionally post Slack updates directly if needed (it has Slack MCP tools).

## Complete Example: test-writer-fixer

### Parent Agent Launch

```javascript
// Before launching subagent
const session_id = "a1b2c3d4-e5f6-7890-abcd-ef1234567890";

// Track handoff in session
Task({
  subagent_type: "session-tracker-2",
  prompt: `
    Operation: track_handoff
    Session ID: ${session_id}
    Assignee: test-writer-fixer
    Notes: Implementing comprehensive test suite for authentication module
  `,
  description: "Track handoff to test-writer"
});

// Launch subagent with context
Task({
  subagent_type: "test-writer-fixer",
  prompt: `
    PARENT_SESSION_ID: ${session_id}
    PARENT_SESSION_CHANNEL: C09Q8KCGM9C
    PARENT_SESSION_THREAD_TS: 1730659852.123456

    Task: Write comprehensive tests for the authentication module
    Focus on: JWT validation, middleware integration, error handling

    Requirements:
    - Unit tests for all public functions
    - Integration tests for middleware
    - Edge case coverage
    - 100% code coverage goal

    When complete, log your activity to the parent session using session-tracker-2.
  `,
  description: "Write authentication tests"
});
```

### Subagent Implementation

```javascript
// In test-writer-fixer execution

// 1. Extract session context
const SESSION_ID = "a1b2c3d4-e5f6-7890-abcd-ef1234567890";
const CHANNEL = "C09Q8KCGM9C";
const THREAD_TS = "1730659852.123456";

// 2. Do the work
// ... write tests, run tests, verify coverage ...

// 3. Log activity when complete
Task({
  subagent_type: "session-tracker-2",
  prompt: `
    Operation: log_activity
    Session ID: ${SESSION_ID}
    Activity Type: code
    Summary: Created comprehensive test suite for authentication module with 15 tests and 100% coverage
    Files: [
      "tests/auth/jwt.test.ts",
      "tests/auth/middleware.test.ts",
      "tests/auth/validation.test.ts",
      "tests/auth/errors.test.ts"
    ]
    Tools: ["Write", "Edit", "Bash"]
    Subagent: test-writer-fixer
    Additional Details: All tests passing, coverage report generated

    Post to Slack Thread: true (optional - posts milestone update to thread)
    Channel: ${CHANNEL}
    Thread TS: ${THREAD_TS}
    Slack Message: "✅ test-writer-fixer: 15 unit tests created with 100% coverage"
  `,
  description: "Log test-writer activity"
});

// 4. Return to parent agent with results
return {
  status: "success",
  tests_created: 15,
  coverage: 100,
  files: ["tests/auth/jwt.test.ts", "tests/auth/middleware.test.ts", ...]
};
```

**Note:** session-tracker-2 can directly post Slack thread updates if requested (it has mcp__slack__slack_reply_to_thread).

## Session Tracker Operations

All subagent operations go through the **session-tracker-2** subagent, which manages session JSON files AND handles Slack posting directly.

### log_activity

```
Operation: log_activity
Session ID: {uuid}
Activity Type: code | analysis | meeting | deployment
Summary: Brief description of what was done
Files: [array of file paths]
Tools: [array of tool names]
Subagent: {subagent-name}
Additional Details: Optional longer description

# Optional Slack posting (session-tracker-2 posts directly)
Post to Slack Thread: true/false
Channel: {channel_id}
Thread TS: {thread_ts}
Slack Message: {message text}
```

### track_handoff

```
Operation: track_handoff
Session ID: {uuid}
Assignee: {subagent-name}
Notes: Context about what the subagent should do

# session-tracker-2 can post handoff notification to Slack thread
Auto Post: true/false (optional)
```

### update_handoff_complete

```
Operation: update_handoff_complete
Session ID: {uuid}
Subagent: {subagent-name}
Status: success | failed | partial
Notes: What was accomplished
```

**session-tracker-2 has Slack MCP tools and can post updates directly. No main agent intervention needed.**

## Slack Integration Patterns

### Pattern 1: Silent Logging (Default)

Subagent logs to session without posting to Slack:

```javascript
// Subagent: Just log activity to session
Task({
  subagent_type: "session-tracker-2",
  prompt: `
    Operation: log_activity
    Session ID: ${SESSION_ID}
    Activity Type: code
    Summary: Completed authentication module
    Files: [...]
    Tools: [...]
    Subagent: my-subagent
  `
});

// No Slack posting - session update only
// Session will be posted when user runs /session-stop --post
```

### Pattern 2: Milestone Updates via session-tracker-2

session-tracker-2 posts milestone updates directly to Slack thread:

```javascript
// Subagent: Log activity AND post to Slack thread
Task({
  subagent_type: "session-tracker-2",
  prompt: `
    Operation: log_activity
    Session ID: ${SESSION_ID}
    Activity Type: code
    Summary: Phase 1 complete: Tests written and passing
    Files: [...]
    Tools: [...]
    Subagent: my-subagent

    Post to Slack Thread: true
    Channel: ${CHANNEL}
    Thread TS: ${THREAD_TS}
    Slack Message: "✅ Phase 1 complete: Tests written and passing"
  `
});

// session-tracker-2 handles the Slack posting directly using mcp__slack__slack_reply_to_thread
```

### Pattern 3: Real-time Progress via session-tracker-2

For long-running tasks, session-tracker-2 posts progress updates directly:

```javascript
// Launch subagent for long-running task
const result = Task({
  subagent_type: "security-auditor",
  prompt: `
    PARENT_SESSION_ID: ${SESSION_ID}
    PARENT_SESSION_CHANNEL: ${CHANNEL}
    PARENT_SESSION_THREAD_TS: ${THREAD_TS}

    Task: Run security audit scan

    Post progress updates using session-tracker-2:
    - At start: Log activity with "Starting scan" + post to thread
    - During: Log progress milestones + post to thread
    - At end: Log completion + post final summary to thread
  `
});

// security-auditor calls session-tracker-2 multiple times:
// 1. Task({ subagent_type: "session-tracker-2", ... Post to Slack: "🔄 Starting scan" })
// 2. Task({ subagent_type: "session-tracker-2", ... Post to Slack: "📊 50% complete" })
// 3. Task({ subagent_type: "session-tracker-2", ... Post to Slack: "✅ Audit complete: 3 issues" })
```

**Key Principle:** session-tracker-2 has Slack MCP tools and can post directly. Other subagents call session-tracker-2 to log AND post simultaneously.

## Error Handling

### Missing Session Context

```javascript
if (!SESSION_ID) {
  console.log("⚠️ No parent session ID provided - working independently");
  // Continue work but don't log to session
  return;
}
```

### Session Not Found

```javascript
// session-tracker-2 will handle gracefully
Task({
  subagent_type: "session-tracker-2",
  prompt: `Operation: log_activity...`,
  description: "Log activity"
});

// If session doesn't exist, session-tracker-2 returns error
// Subagent can continue without failing
```

### Slack Posting Failure

When session-tracker-2 encounters Slack posting errors:

```javascript
// session-tracker-2 handles Slack errors internally
Task({
  subagent_type: "session-tracker-2",
  prompt: `
    Operation: log_activity
    ...
    Post to Slack Thread: true
    ...
  `
});

// If Slack posting fails:
// - session-tracker-2 logs the error
// - Session JSON is still saved successfully
// - Returns error message but doesn't crash
// - Session data preserved even if Slack fails
```

**Note:** session-tracker-2 handles Slack errors internally since it has direct MCP access.

## Subagent Configuration Template

Add this section to any subagent's markdown configuration:

```markdown
## Session Integration

This subagent supports session tracking integration.

**Expected Context Variables:**
- `PARENT_SESSION_ID`: UUID of parent session
- `PARENT_SESSION_CHANNEL`: Slack channel ID
- `PARENT_SESSION_THREAD_TS`: Slack thread timestamp

**Activity Logging:**
When work is complete, this subagent will:
1. Log activities to parent session via session-tracker-2 subagent
2. Update handoff status in session JSON
3. Optionally post Slack thread updates via session-tracker-2

**Handoff Tracking:**
This subagent automatically updates handoff status in session JSON:
- On start: Mark as "transferred" to this subagent
- On completion: Mark handoff complete with status
- On error: Mark handoff failed with error details

**Slack Updates:**
This subagent can request session-tracker-2 to post Slack updates directly:
```javascript
Task({
  subagent_type: "session-tracker-2",
  prompt: `
    Operation: log_activity
    Session ID: ${PARENT_SESSION_ID}
    ...
    Post to Slack Thread: true
    Channel: ${PARENT_SESSION_CHANNEL}
    Thread TS: ${PARENT_SESSION_THREAD_TS}
    Slack Message: "✅ Work completed"
  `
})
```

**Note:** session-tracker-2 has Slack MCP tools and posts directly (no main agent needed).
```

## Testing Session Integration

### Manual Test

```bash
# 1. Start a session
/session-start "Test subagent integration"

# 2. Get session ID from output
SESSION_ID="..."

# 3. Manually launch subagent with context
# (In your test prompt to Claude)
"Launch test-writer-fixer with session context:
PARENT_SESSION_ID: {SESSION_ID}
Task: Write a simple test file"

# 4. Check session file for logged activity
cat .claude/data/sessions/${SESSION_ID}.json

# 5. Stop session and verify
/session-stop --post
```

### Automated Test Pattern

```javascript
// Create test session
const test_session = await createTestSession();

// Launch subagent with test context
const result = await launchSubagent({
  type: "test-writer-fixer",
  session_id: test_session.id,
  task: "Write simple test"
});

// Verify activity was logged
const session = await loadSession(test_session.id);
assert(session.activities.length > 0);
assert(session.activities[0].subagent === "test-writer-fixer");

// Cleanup
await deleteSession(test_session.id);
```

## Benefits

**For Parent Agent:**
- ✅ Complete visibility into subagent work
- ✅ Accurate activity timeline
- ✅ Proper handoff tracking
- ✅ Automated Slack updates

**For Subagents:**
- ✅ Simple integration pattern
- ✅ Optional (graceful degradation if no session)
- ✅ Minimal code changes needed
- ✅ Real-time progress sharing

**For Users:**
- ✅ Transparent agent coordination
- ✅ Real-time Slack updates
- ✅ Complete audit trails
- ✅ Accurate session summaries

## Next Steps

1. **Update existing subagents** - Add session integration to frequently used subagents
2. **Test integration** - Verify session logging works end-to-end
3. **Monitor Slack posts** - Ensure formatting and threading work correctly
4. **Gather feedback** - Adjust patterns based on actual usage
5. **Automate with hooks** - Consider automatic session context passing via hooks

## Related Documentation

- [Session Tracker 2 Agent](/.claude/agents/session-tracker-2.md) - Core subagent for session management with Slack MCP
- [Session Commands](/.claude/commands/) - User-facing slash commands (session-start, session-stop, session-post)
- [Slack MCP Tools](/TOOL-REGISTRY.md#slack-mcp) - session-tracker-2's Slack integration
- [Project Architecture](/CLAUDE.md#session-tracking) - Overall session tracking architecture
- [Subagent Best Practices](~/.claude/CLAUDE.md#subagent-best-practices)
