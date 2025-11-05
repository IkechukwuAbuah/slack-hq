# Slack MCP Server Setup

## Overview

This project uses the Model Context Protocol (MCP) to enable Claude Code to interact directly with the Slack workspace "The Council" via programmatic API access.

## Configuration

### MCP Server Configuration

**File**: `.claude/mcp.json`

```json
{
  "mcpServers": {
    "slack": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-slack"],
      "env": {
        "SLACK_BOT_TOKEN": "xoxb-...",
        "SLACK_TEAM_ID": "T..."
      }
    }
  }
}
```

⚠️ **Security**: This file contains sensitive credentials and is gitignored.

### Required Credentials

Credentials are stored in `temp-context/secrets.md` (gitignored):

- **SLACK_BOT_TOKEN**: Bot User OAuth Token (xoxb-...)
- **SLACK_TEAM_ID**: Workspace identifier (T...)

### Slack App Configuration

**App Name**: Council Bot

**Required OAuth Scopes**:
- `channels:history` - View messages in channels
- `channels:read` - View channel details
- `chat:write` - Send messages
- `reactions:write` - Add emoji reactions
- `users:read` - View user profiles

## Usage

### After Configuration

1. **Restart Claude Code** to load the MCP server
2. **Verify connection** by checking for `mcp__slack__*` tools
3. **Test access** by listing channels or posting a test message

### Available Tools (After Restart)

Once the MCP server loads, you'll have access to tools like:
- `mcp__slack__list_channels` - List workspace channels
- `mcp__slack__post_message` - Send messages to channels
- `mcp__slack__get_history` - Fetch channel message history
- `mcp__slack__list_users` - List workspace members
- (and more depending on the MCP server version)

## Testing

### Verify MCP Server is Loaded

After restarting Claude Code, test with:
```
List all channels in the Slack workspace
```

Claude should be able to access Slack directly without using curl or the Slack CLI.

### Test Message Posting

```
Post a test message to #announcements: "Testing Slack MCP integration"
```

## Troubleshooting

### No `mcp__slack__*` Tools Available

**Cause**: MCP server not loaded
**Solution**: Restart Claude Code to pick up the configuration

### Authentication Errors

**Cause**: Invalid or expired bot token
**Solution**: Regenerate token from https://api.slack.com/apps → Council Bot → OAuth & Permissions

### Permission Errors

**Cause**: Missing OAuth scopes
**Solution**: Add required scopes in Slack App settings and reinstall the app to workspace

## Alternative: Direct API Access

If MCP is unavailable, you can use direct curl commands with the bot token:

```bash
# List channels
curl -X GET 'https://slack.com/api/conversations.list' \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN"

# Post message
curl -X POST 'https://slack.com/api/chat.postMessage' \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"channel":"C09Q8KCGM9C","text":"Hello from curl"}'
```

## References

- [MCP Slack Server NPM](https://www.npmjs.com/package/@modelcontextprotocol/server-slack)
- [Slack API Documentation](https://api.slack.com/)
- [Model Context Protocol Docs](https://modelcontextprotocol.io/)
