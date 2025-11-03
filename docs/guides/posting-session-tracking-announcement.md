# Posting the Session Tracking Announcement

## Prerequisites

1. **Set up environment variables** by creating a `.env` file:
   ```bash
   cp .env.example .env
   # Edit .env and add your SLACK_BOT_TOKEN
   ```

2. **Verify Slack CLI authentication**:
   ```bash
   slack auth list
   ```

3. **Load environment variables**:
   ```bash
   source .env
   # Or export SLACK_BOT_TOKEN manually
   export SLACK_BOT_TOKEN="xoxb-your-token-here"
   ```

## Posting the Announcement

### Option 1: Using Slack CLI (Recommended)

```bash
# Verify token is set
test -n "$SLACK_BOT_TOKEN" && echo "✓ Token configured" || echo "✗ Token missing"

# Post the announcement
slack api chat.postMessage \
  --data @scripts/slack/session-tracking-announcement.json \
  --token "$SLACK_BOT_TOKEN"
```

### Option 2: Using curl (Alternative)

```bash
curl -X POST https://slack.com/api/chat.postMessage \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN" \
  -H "Content-Type: application/json" \
  --data @scripts/slack/session-tracking-announcement.json
```

## Expected Response

```json
{
  "ok": true,
  "channel": "C123456789",
  "ts": "1234567890.123456",
  "message": {
    "text": "📊 New Feature Proposal: Session Tracking for slack-hq",
    "username": "Council Bot",
    "bot_id": "B123456789"
  }
}
```

## Monitoring Responses

### View thread replies
```bash
slack api conversations.replies \
  --data '{"channel":"#council-ops","ts":"MESSAGE_TS_FROM_RESPONSE"}' \
  --token "$SLACK_BOT_TOKEN"
```

### Check reactions
```bash
slack api reactions.get \
  --data '{"channel":"#council-ops","timestamp":"MESSAGE_TS_FROM_RESPONSE"}' \
  --token "$SLACK_BOT_TOKEN"
```

## Follow-Up Actions

After posting:

1. **Monitor feedback** in the #council-ops thread
2. **Summarize responses** within 24-48 hours
3. **Update the spec** based on Council input
4. **Assign implementation** to volunteering agents
5. **Create Linear tasks** for each phase

## Troubleshooting

### Token Not Found
```bash
# Check if .env exists
ls -la .env

# Check if token is exported
echo $SLACK_BOT_TOKEN
```

### Permission Denied
- Verify Council Bot has `chat:write` scope
- Check channel permissions in Slack workspace settings
- Ensure the bot is invited to #council-ops

### Invalid Channel
```bash
# List available channels
slack api conversations.list \
  --data '{"types":"public_channel,private_channel"}' \
  --token "$SLACK_BOT_TOKEN"
```

### Message Too Large
- Block Kit has a 50 block limit (we use 10)
- Text fields limited to 3000 characters
- Our message is well within limits

## Testing First (Recommended)

Test with a dry-run to a test channel:

```bash
# Copy the JSON
cp scripts/slack/session-tracking-announcement.json /tmp/test-message.json

# Modify channel in the test file
sed -i '' 's/#council-ops/#test-channel/g' /tmp/test-message.json

# Post to test channel
slack api chat.postMessage \
  --data @/tmp/test-message.json \
  --token "$SLACK_BOT_TOKEN"
```

## References

- Slack Block Kit Builder: https://api.slack.com/block-kit/building
- Slack API Methods: https://api.slack.com/methods
- Council Bot Scopes: See `manifest.yml` for configured permissions
