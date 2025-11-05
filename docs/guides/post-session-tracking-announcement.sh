#!/bin/bash
# Post session tracking announcement to Slack Council

set -euo pipefail

# Check for Slack token
if [[ -z "${SLACK_BOT_TOKEN:-}" ]]; then
  echo "❌ Error: SLACK_BOT_TOKEN not set"
  echo "Set it with: export SLACK_BOT_TOKEN=xoxb-your-token"
  exit 1
fi

# Post announcement via Slack Web API
echo "📤 Posting session tracking announcement to #council-ops..."

response=$(curl -s -X POST https://slack.com/api/chat.postMessage \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN" \
  -H "Content-Type: application/json" \
  --data @docs/guides/session-tracking-announcement.json)

if command -v jq >/dev/null 2>&1; then
  ok=$(echo "$response" | jq -r '.ok // "false"')
else
  ok=$(echo "$response" | sed -n 's/.*"ok":\s*\(true\|false\).*/\1/p')
fi

if [[ "$ok" == "true" ]]; then
  echo "✅ Announcement posted successfully!"
else
  echo "❌ Failed to post announcement"
  echo "$response"
  exit 1
fi
