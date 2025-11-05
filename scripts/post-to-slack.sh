#!/bin/bash
set -euo pipefail

# Note: Shell scripts use curl for Slack API access.
# For Claude Code operations, use Slack MCP (mcp__slack__*) instead.
# Security: Never hardcode tokens. Always use environment variables.

# Source token from environment
if [ -f .env ]; then
  source .env
fi

if [ -z "${SLACK_BOT_TOKEN:-}" ]; then
  echo "Error: SLACK_BOT_TOKEN not set. Please configure .env file."
  echo "Expected format in .env: SLACK_BOT_TOKEN=\"xoxb-...\""
  exit 1
fi

TOKEN="$SLACK_BOT_TOKEN"

# First, list channels to find the right one
echo "Fetching available channels..."
CHANNELS=$(curl -s -X GET \
  "https://slack.com/api/conversations.list?types=public_channel,private_channel&limit=100" \
  -H "Authorization: Bearer $TOKEN")

echo "$CHANNELS" | jq -r '.channels[]? | "\(.name) - \(.id)"'

# Now post the announcement
echo ""
echo "Posting announcement..."
curl -X POST https://slack.com/api/chat.postMessage \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d @docs/guides/session-tracking-announcement.json