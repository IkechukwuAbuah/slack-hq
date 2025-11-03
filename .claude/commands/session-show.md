---
description: Display detailed information about a specific session
tags: [session, tracking, project]
---

# Show Session Details

Display comprehensive details about a specific session including all activities, files changed, and metadata.

## Task

1. **Load the session-tracking skill** - Use for implementation details

2. **Execute show script**:
   ```bash
   ~/.claude/skills/session-tracking/scripts/session.sh show <session-id>
   ```

3. **Load session data**:
   - Read JSON from `.claude/data/sessions/<session-id>.json`
   - Validate session exists
   - Parse and validate against schema

4. **Display comprehensive details**:

   **Header Section:**
   - Session ID (full UUID)
   - Task name
   - Agent name
   - Project name
   - Working directory
   - Status with visual indicator
   - Started/ended timestamps
   - Total duration

   **Activities Section:**
   - List all activities chronologically
   - For each activity show:
     - Timestamp (relative and absolute)
     - Activity type (code, analysis, meeting, deployment)
     - Summary/description
     - Files affected (with paths)
     - Tools used
     - Linked issue (if any)

   **Metadata Section:**
   - Tags
   - Handoff status (if applicable)
   - Slack integration details (channel, message_ts)
   - Notes
   - Related sessions

   **Statistics:**
   - Total activities count
   - Files changed count
   - Activity type breakdown
   - Time per activity type

5. **Format output** with:
   - Clear visual hierarchy
   - Syntax highlighting for file paths
   - Emoji indicators for activity types
   - Collapsible sections for large data

## Parameters

- Session ID (required): Full UUID or first 8 characters

## Examples

```bash
/session-show a1b2c3d4
/session-show a1b2c3d4-5678-90ef-ghij-klmnopqrstuv
```

## Example Output

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📋 SESSION DETAILS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

ID: a1b2c3d4-5678-90ef-ghij-klmnopqrstuv
Task: Implement user authentication with JWT
Agent: Claude Code
Project: slack-hq
Status: ✅ Completed
Duration: 2h 15m (Jan 15, 09:30 - 11:45)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📊 ACTIVITIES (5)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[09:35] 💻 Code
  Created authentication middleware
  Files: src/middleware/auth.ts, src/types/auth.d.ts
  Tools: Write, Edit
  Issue: SLHQ-42

[10:10] 💻 Code
  Implemented JWT token generation and validation
  Files: src/utils/jwt.ts, tests/jwt.spec.ts
  Tools: Write

[10:45] 🧪 Testing
  Added comprehensive test coverage for auth flow
  Files: tests/auth.spec.ts
  Tools: Write, Bash

[11:20] 📝 Analysis
  Reviewed security best practices
  Files: docs/security/auth-review.md
  Tools: WebFetch, Write

[11:40] 🚀 Deployment
  Updated environment configuration
  Files: .env.example, config/default.yml
  Tools: Edit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📈 STATISTICS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Total Activities: 5
Files Changed: 8
Linked Issue: SLHQ-42

Activity Breakdown:
  💻 Code: 2 activities (40%)
  🧪 Testing: 1 activity (20%)
  📝 Analysis: 1 activity (20%)
  🚀 Deployment: 1 activity (20%)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📎 METADATA
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Tags: authentication, security, backend
Slack: #council-ops (ts: 1234567890.123456)
Working Directory: /Users/x/slack-hq

Notes:
Implemented JWT-based authentication with refresh tokens.
All tests passing. Ready for code review.
```

## Success Criteria

- Session details displayed completely
- All activities shown with proper formatting
- Statistics calculated correctly
- File paths are readable and properly formatted
- Error message if session ID not found
- Performance acceptable for sessions with many activities
