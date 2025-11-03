# Session Tracking Skill - Testing Guide

Quick reference for testing and validating the session tracking implementation.

## Prerequisites

- Bash 4.0+
- jq (JSON processor)
- Node.js + npx (for ajv-cli schema validation)
- Slack Bot Token (for Slack integration tests)

## Quick Start

### 1. Initialize Environment

```bash
# Create required directories
mkdir -p .claude/data/sessions
mkdir -p .claude/hooks
mkdir -p config/schemas
mkdir -p logs

# Copy schema to config
cp scripts/session-schema.json config/schemas/session.json

# Make script executable
chmod +x scripts/session.sh
```

### 2. Basic Smoke Test

```bash
# Start a session
./scripts/session.sh start "Test Session"

# Should output:
# {
#   "session_id": "<uuid>",
#   "started_at": "2025-...",
#   "working_directory": "/path/to/dir"
# }

# Get session ID
SESSION_ID=$(./scripts/session.sh current)
echo "Active session: $SESSION_ID"

# Validate session
./scripts/session.sh validate "$SESSION_ID"

# Stop session
./scripts/session.sh stop "$SESSION_ID" --notes "Test completed"
```

### 3. Schema Validation Test

```bash
# Test valid session
cat > test-session.json << 'EOF'
{
  "session_id": "3f12b5d4-a6b7-4521-9f42-2b9f06fb8d6a",
  "agent_name": "TestAgent",
  "started_at": "2025-01-17T18:20:00Z",
  "ended_at": null,
  "project": "slack-hq",
  "working_directory": "/workspace",
  "status": "active",
  "auto_post": false,
  "slack_channel": null,
  "slack_message_ts": null,
  "slack_thread_ts": null,
  "activities": [],
  "prompts": [],
  "tools_used": [],
  "files_modified": [],
  "tags": [],
  "notes": "",
  "handoff_status": {
    "state": "none",
    "assignee": null,
    "notes": ""
  }
}
EOF

npx --yes ajv-cli validate -s config/schemas/session.json -d test-session.json
```

### 4. Activity Logging Test

```bash
# Start session
SESSION_ID=$(./scripts/session.sh start "Activity Test" | jq -r .session_id)

# Manually add activity
jq '.activities += [{
  "timestamp": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'",
  "type": "code",
  "summary": "Test activity",
  "files": ["test.txt"],
  "tools": ["filesystem"]
}]' .claude/data/sessions/$SESSION_ID.json > temp.json

mv temp.json .claude/data/sessions/$SESSION_ID.json

# Validate modified session
./scripts/session.sh validate "$SESSION_ID"
```

## Test Scenarios

### Scenario 1: Standard Workflow

```bash
# Complete workflow test
SESSION=$(./scripts/session.sh start "Standard Test" --auto-post --channel "#test")
ID=$(echo "$SESSION" | jq -r .session_id)

# Simulate work
sleep 2

# Stop with notes
./scripts/session.sh stop "$ID" --notes "Workflow test completed"

# Verify end state
./scripts/session.sh show "$ID" | jq '.status, .ended_at, .notes'
```

### Scenario 2: Multi-Agent Session

```bash
# Agent 1 starts
SESSION1=$(./scripts/session.sh start "Agent1 Work" | jq -r .session_id)

# Agent 2 starts (concurrent)
SESSION2=$(./scripts/session.sh start "Agent2 Work" | jq -r .session_id)

# Verify both active
./scripts/session.sh history --status active

# Agent 1 completes
./scripts/session.sh stop "$SESSION1"

# Verify only one active
./scripts/session.sh history --status active
```

### Scenario 3: Handoff Test

```bash
# Agent A starts and requests handoff
SESSION=$(./scripts/session.sh start "Handoff Test" | jq -r .session_id)

# Manually set handoff (would be done via separate command)
jq '.handoff_status = {
  "state": "requested",
  "assignee": "AgentB",
  "notes": "Please continue with deployment"
}' .claude/data/sessions/$SESSION.json > temp.json

mv temp.json .claude/data/sessions/$SESSION.json

# Verify handoff status
./scripts/session.sh show "$SESSION" | jq .handoff_status
```

## Slack Integration Testing

### Setup

```bash
# Set Slack token
export SLACK_BOT_TOKEN="xoxb-your-token-here"

# Verify token
curl -s -X POST https://slack.com/api/auth.test \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN" | jq .ok
```

### Dry Run Test

```bash
# Start session with auto-post
SESSION=$(./scripts/session.sh start "Slack Test" --auto-post | jq -r .session_id)

# Test post (dry run)
./scripts/session.sh post --id "$SESSION" --dry-run

# Should show payload without posting
```

### Actual Post Test

```bash
# Post to test channel
./scripts/session.sh post --id "$SESSION"

# Verify message_ts stored
./scripts/session.sh show "$SESSION" | jq '.slack_message_ts'
```

## Error Handling Tests

### Invalid UUID

```bash
# Should fail with clear error
./scripts/session.sh stop "not-a-uuid" 2>&1
# Expected: "Error: Session not found: not-a-uuid"
```

### Invalid Status

```bash
# Create session with invalid status
cat > bad-session.json << 'EOF'
{
  "session_id": "3f12b5d4-a6b7-4521-9f42-2b9f06fb8d6a",
  "agent_name": "Test",
  "started_at": "2025-01-17T18:20:00Z",
  "ended_at": null,
  "project": "slack-hq",
  "working_directory": "/workspace",
  "status": "running"
}
EOF

# Should fail validation
npx --yes ajv-cli validate -s config/schemas/session.json -d bad-session.json 2>&1
# Expected: validation error about enum
```

### Missing Token

```bash
# Unset token
unset SLACK_BOT_TOKEN

# Try to post
./scripts/session.sh post --id "$SESSION" 2>&1
# Expected: "Error: SLACK_BOT_TOKEN not set"
```

## Performance Tests

### Bulk Session Creation

```bash
# Create 100 sessions
for i in {1..100}; do
  ./scripts/session.sh start "Session $i" >/dev/null
done

# List all
time ./scripts/session.sh history --limit 100

# Cleanup
rm -rf .claude/data/sessions/*.json
```

### Large Activity Log

```bash
# Create session
SESSION=$(./scripts/session.sh start "Activity Stress" | jq -r .session_id)

# Add 1000 activities
for i in {1..1000}; do
  jq --arg i "$i" '.activities += [{
    "timestamp": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'",
    "type": "code",
    "summary": ("Activity " + $i)
  }]' .claude/data/sessions/$SESSION.json > temp.json
  mv temp.json .claude/data/sessions/$SESSION.json
done

# Test show performance
time ./scripts/session.sh show "$SESSION" >/dev/null
```

## Integration Checklist

- [ ] Scripts are executable (`chmod +x`)
- [ ] Directories exist (`.claude/data/sessions/`, etc.)
- [ ] Schema validates correctly
- [ ] Sessions can be created
- [ ] Sessions can be stopped
- [ ] Current session can be retrieved
- [ ] History lists sessions
- [ ] Show displays details
- [ ] Validation catches errors
- [ ] Slack posts work (with token)
- [ ] Auto-post flag respected
- [ ] Concurrent sessions supported
- [ ] Handoff status updates work

## Troubleshooting

### jq not found

```bash
# macOS
brew install jq

# Ubuntu/Debian
apt-get install jq
```

### npx not found

```bash
# Install Node.js + npm
# macOS
brew install node

# Ubuntu/Debian
curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
apt-get install -y nodejs
```

### sponge command missing

Used in session.sh for atomic file updates:

```bash
# macOS
brew install moreutils

# Ubuntu/Debian
apt-get install moreutils
```

Or replace `sponge` with:
```bash
jq '...' file.json > temp.json && mv temp.json file.json
```

## Cleanup

```bash
# Remove all test sessions
rm -rf .claude/data/sessions/*.json

# Remove test files
rm -f test-session.json bad-session.json temp.json
```
