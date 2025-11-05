# Council Bot - Quick Start Guide

## ✅ What's Been Set Up

All files and configurations for **Council Bot** (your Slack AI agent connector) have been created in `/Users/x/Downloads/slack-hq`:

```
slack-hq/
├── manifest.yml                         # Slack app manifest with all OAuth scopes
├── scripts/slack-setup.sh               # Automated deployment script
├── docs/slack-cli-capabilities.md       # Complete capabilities reference for AI agents
├── .env.example                         # Environment template
├── README.md                            # Updated with Slack setup instructions
└── AGENTS.md                            # Updated with agent integration patterns
```

## 🚀 Next Steps (Run These Commands)

### 1. Authenticate with Slack CLI

```bash
slack login
```

This will open your browser. Select **"The Council"** workspace when prompted.

### 2. Verify Authentication

```bash
slack auth list
```

Confirm "The Council" appears in the list.

### 3. Deploy Council Bot

```bash
cd /Users/x/Downloads/slack-hq
./scripts/slack-setup.sh
```

The script will:
- ✅ Validate the manifest
- ✅ Deploy the app to your workspace
- ✅ Show you an OAuth install URL

### 4. Complete OAuth Installation

- Click the OAuth URL from step 3
- Review the permissions (all the scopes we configured)
- Click **"Allow"** to install Council Bot into "The Council"

### 5. Get Your Tokens

After installation, go to your Slack app settings:

1. **Bot Token**: https://api.slack.com/apps → Your App → OAuth & Permissions
2. **Signing Secret**: https://api.slack.com/apps → Your App → Basic Information
3. **App Token**: https://api.slack.com/apps → Your App → Basic Information → App-Level Tokens (create one if needed)
4. **Workspace ID**: Visible in your workspace URL or settings

### 6. Configure Environment

```bash
cp .env.example .env
# Edit .env and paste in your actual tokens from step 5
```

### 7. Test the Connection

```bash
source .env  # Load your environment variables
curl -X POST https://slack.com/api/auth.test \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN"
```

Expected output: `"ok": true` with your bot details.

### 8. Test Posting a Message

Use Slack MCP (preferred) or curl as a fallback. Slack CLI v3.9.0 does **not** support `slack api …` commands.

```javascript
mcp__slack__slack_post_message({
  channel_id: "C09Q8KCGM9C",
  text: "Council Bot is online! 🤖"
});
```

```bash
curl -X POST https://slack.com/api/chat.postMessage \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"channel":"#general","text":"Council Bot is online! 🤖"}'
```

## 📚 What Council Bot Can Do

With all confirmed scopes enabled, Council Bot can:

✅ **Channel Management**
- Create, rename, archive channels
- Invite users to channels
- Set channel topics
- Join channels automatically

✅ **Private Channel Operations**
- Same capabilities as public channels
- Read/write in private channels
- Manage group invites

✅ **Messaging**
- Post messages and replies
- Read message history
- Analyze DM conversations (with consent)

✅ **Usergroup Management**
- List usergroups
- Update usergroup memberships
- Manage team structures

✅ **Workflow Integration**
- Trigger Slack workflows
- Automate complex operations

## 🤖 AI Agent Integration

All agents (Claude Code, Codex, ChatGPT, Gemini, Grok, Cursor, Warp, Windsurf) can use Council Bot by:

### Method 1: Slack MCP (Preferred)
```javascript
mcp__slack__slack_post_message({
  channel_id: "C09Q8KCGM9C",
  text: "Update from AI agent"
});
```

### Method 2: Slack Web API (Direct HTTP)
```bash
curl -X POST https://slack.com/api/chat.postMessage \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"channel":"#council-ops","text":"Update from AI agent"}'
```

## 📖 Full Documentation

- **Complete capabilities guide**: `docs/slack-cli-capabilities.md`
- **Agent integration patterns**: `AGENTS.md`
- **Project setup**: `README.md`

## 🔧 Troubleshooting

### Issue: Manifest validation fails
```bash
slack manifest validate --file manifest.yml
```
Check for YAML syntax errors.

### Issue: OAuth install shows "missing permissions"
You need Workspace Admin or App Manager role in "The Council" to install apps with these scopes.

### Issue: 401 errors when calling API
Confirm you're using `SLACK_BOT_TOKEN` (starts with `xoxb-`), not `SLACK_APP_TOKEN`.

### Issue: Cannot post to a channel
Invite the bot: `/invite @Council Bot` in the channel, or use the `channels:join` scope to join automatically.

### Issue: Localhost callbacks don't work
Slack cannot reach `localhost`. Use ngrok during development:
```bash
ngrok http 3000
# Update manifest.yml with the ngrok URL
# Re-run ./scripts/slack-setup.sh
```

## 🎉 You're Ready!

Council Bot is now set up and ready to connect your AI agents to "The Council" workspace.

**Key Files to Remember:**
- `.env` - Keep this secure, never commit to git
- `manifest.yml` - Update scopes here if you need more capabilities
- `scripts/slack-setup.sh` - Re-run anytime you update the manifest

Happy automating! 🚀
