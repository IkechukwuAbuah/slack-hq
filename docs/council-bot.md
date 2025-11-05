# Council Bot Slack Capabilities

**Purpose**: Council Bot is the Slack bridge for The Council workspace, enabling AI agents (Claude Code, Codex, ChatGPT, Gemini, Grok, Cursor, Warp, Windsurf) to perform channel operations, post messages, read history, and manage workspace resources.

## Tool Hierarchy

### PRIMARY: Slack MCP Server ✅

**Status**: Fully operational and pre-configured

The Slack MCP Server is the **recommended primary method** for all Slack operations. It provides:
- Type-safe function calls with parameter validation
- Automatic authentication using configured tokens
- Structured responses optimized for AI processing
- Error handling with clear feedback
- No shell escaping or JSON formatting issues

**Available MCP Functions:**

#### 1. List Channels
```
mcp__slack__slack_list_channels
Parameters:
  - cursor: string (optional) - Pagination cursor
  - limit: number (optional, default: 100, max: 200)
```

Example:
```
List all channels in the workspace
→ Uses: mcp__slack__slack_list_channels with limit=100
```

#### 2. Post Message
```
mcp__slack__slack_post_message
Parameters:
  - channel_id: string (required) - Channel ID (e.g., "C09Q8KCGM9C")
  - text: string (required) - Message content
```

Example:
```
Post "Session completed successfully" to #announcements
→ Uses: mcp__slack__slack_post_message
  channel_id: "C09Q8KCGM9C"
  text: "Session completed successfully"
```

#### 3. Reply to Thread
```
mcp__slack__slack_reply_to_thread
Parameters:
  - channel_id: string (required)
  - thread_ts: string (required) - Parent message timestamp
  - text: string (required) - Reply content
```

Example:
```
Reply to thread 1234567890.123456 in #engineering
→ Uses: mcp__slack__slack_reply_to_thread
  channel_id: "C123ABC456"
  thread_ts: "1234567890.123456"
  text: "Implementation complete"
```

#### 4. Add Reaction
```
mcp__slack__slack_add_reaction
Parameters:
  - channel_id: string (required)
  - timestamp: string (required) - Message timestamp
  - reaction: string (required) - Emoji name without colons (e.g., "thumbsup")
```

Example:
```
Add ✅ reaction to message 1234567890.123456
→ Uses: mcp__slack__slack_add_reaction
  channel_id: "C123ABC456"
  timestamp: "1234567890.123456"
  reaction: "white_check_mark"
```

#### 5. Get Channel History
```
mcp__slack__slack_get_channel_history
Parameters:
  - channel_id: string (required)
  - limit: number (optional, default: 10)
```

Example:
```
Get last 50 messages from #council-ops
→ Uses: mcp__slack__slack_get_channel_history
  channel_id: "C123ABC456"
  limit: 50
```

#### 6. Get Thread Replies
```
mcp__slack__slack_get_thread_replies
Parameters:
  - channel_id: string (required)
  - thread_ts: string (required) - Parent message timestamp
```

Example:
```
Get all replies in thread 1234567890.123456
→ Uses: mcp__slack__slack_get_thread_replies
  channel_id: "C123ABC456"
  thread_ts: "1234567890.123456"
```

#### 7. Get Users
```
mcp__slack__slack_get_users
Parameters:
  - cursor: string (optional) - Pagination cursor
  - limit: number (optional, default: 100, max: 200)
```

Example:
```
List all workspace members
→ Uses: mcp__slack__slack_get_users with limit=200
```

#### 8. Get User Profile
```
mcp__slack__slack_get_user_profile
Parameters:
  - user_id: string (required) - User ID (e.g., "U123ABC456")
```

Example:
```
Get profile for user U123ABC456
→ Uses: mcp__slack__slack_get_user_profile
  user_id: "U123ABC456"
```

yentime Slack operations

### FALLBACK: Direct curl API Calls & Scripts

**Preferred interface:** `./scripts/slack-api-helper.sh` (see [docs/runbooks/slack-direct-api.md](runbooks/slack-direct-api.md))  
The helper script wraps common Slack API endpoints (channel lifecycle, invites, DM handoffs) with consistent error handling. Use it before resorting to raw `curl` so we keep automation predictable and auditable.

**When to Use:**
- MCP Server is unavailable or not configured
- Need operations not exposed by MCP (rare)
- Debugging authentication/permission issues
- Scripting outside of Claude Code environment

**Base URL**: `https://slack.com/api/`

**Authentication**: Pass token in Authorization header or as form parameter

#### List Channels
```bash
curl -X POST https://slack.com/api/conversations.list \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"types":"public_channel,private_channel","limit":100}'
```

#### Post Message
```bash
curl -X POST https://slack.com/api/chat.postMessage \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"channel":"C09Q8KCGM9C","text":"Hello from Council Bot"}'
```

#### Get Channel History
```bash
curl -X POST https://slack.com/api/conversations.history \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"channel":"C09Q8KCGM9C","limit":50}'
```

#### Create Channel
```bash
curl -X POST https://slack.com/api/conversations.create \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"name":"new-channel","is_private":false}'
```

#### Invite Users to Channel
```bash
curl -X POST https://slack.com/api/conversations.invite \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"channel":"C123ABC456","users":"U111,U222"}'
```

#### Set Channel Topic
```bash
curl -X POST https://slack.com/api/conversations.setTopic \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"channel":"C123ABC456","topic":"Channel description"}'
```

#### List Usergroups
```bash
curl -X POST https://slack.com/api/usergroups.list \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN" \
  -H "Content-Type: application/json"
```

#### Update Usergroup Members
```bash
curl -X POST https://slack.com/api/usergroups.users.update \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"usergroup":"S123ABC456","users":"U111,U222,U333"}'
```

## th

Council Bot has comprehensive permissions enabling full workspace operations:

**Channel Operations:**
- `channels:join` - Join public channels
- `channels:manage` - Manage public channels
- `channels:read` - View basic channel info
- `channels:write.invites` - Invite users to channels
- `channels:write.topic` - Set channel topics

**Private Channel/Group Operations:**
- `groups:read` - View private channel info
- `groups:write` - Manage private channels
- `groups:write.invites` - Invite to private channels
- `groups:write.topic` - Set private channel topics

**Messaging:**
- `chat:write` - Post messages as Council Bot
- `chat:write.public` - Post to channels without joining

**Direct Messages:**
- `im:history` - Read DM history (for analysis with proper consent)

**User Management:**
- `usergroups:write` - Manage usergroups

## Common Operations with MCP

### List All Channels
```
Task: "List all channels in The Council workspace"

Implementation:
→ Call mcp__slack__slack_list_channels with limit=200
→ Parse results for channel names and IDs
→ Present formatted list to user
```

### Post Session Summary
```
Task: "Post session summary to #announcements"

Implementation:
→ Format session data as markdown text
→ Call mcp__slack__slack_post_message
  channel_id: "C09Q8KCGM9C" (#announcements)
  text: "[formatted summary]"
→ Confirm successful posting
```

### Read Recent Messages
```
Task: "Read last 20 messages from #engineering"

Implementation:
→ Get channel ID for #engineering (if not known)
→ Call mcp__slack__slack_get_channel_history
  channel_id: "C123ABC456"
  limit: 20
→ Parse messages and present to user
```

### Reply in Thread
```
Task: "Reply to a specific thread about deployment"

Implementation:
→ Locate thread timestamp (from history or user)
→ Call mcp__slack__slack_reply_to_thread
  channel_id: "C123ABC456"
  thread_ts: "1234567890.123456"
  text: "Deployment verified successfully"
```

### Add Acknowledgment Reaction
```
Task: "Add checkmark to confirm message was processed"

Implementation:
→ Get message timestamp
→ Call mcp__slack__slack_add_reaction
  channel_id: "C123ABC456"
  timestamp: "1234567890.123456"
  reaction: "white_check_mark"
```

### Get User Information
```
Task: "Get profile details for @kelvin"

Implementation:
→ Call mcp__slack__slack_get_users to list all users
→ Find user with matching name/display name
→ Call mcp__slack__slack_get_user_profile with user_id
→ Present profile information
```

## Channel ID Reference

**Key Channels in The Council:**
- `C09QAKDHKMG` - #council-core (default for session tracking)
- `C09Q8KCGM9C` - #announcements (major broadcasts)
- Find others via `mcp__slack__slack_list_channels`

**ID Prefixes:**
- `C` - Public channels
- `G` - Private channels/groups
- `D` - Direct messages
- `U` - Users
- `S` - Usergroups

## Environment Variables

Required for authentication:

```bash
# Bot token (required for MCP and API calls)
export SLACK_BOT_TOKEN="xoxb-..."

# App-level token (for Socket Mode, if used)
export SLACK_APP_TOKEN="xapp-..."

# Signing secret (for webhook verification)
export SLACK_SIGNING_SECRET="..."

# Workspace ID (optional, for reference)
export SLACK_WORKSPACE_ID="T..."
```

**Verification:**
```bash
# Check if tokens are configured
test -n "$SLACK_BOT_TOKEN" && echo "✅ Bot token set" || echo "❌ Missing bot token"

# Verify Slack CLI is available
slack version  # Should show v3.9.0 or later
```

## Troubleshooting

### MCP Function Errors

**Problem**: "Channel not found" error
- **Cause**: Invalid channel ID or bot not in channel
- **Solution**:
  - Verify channel ID with `mcp__slack__slack_list_channels`
  - Invite bot to channel: `/invite @Council Bot`
  - Check channel still exists (not archived)

**Problem**: "Missing scope" error
- **Cause**: Required OAuth scope not granted
- **Solution**:
  - Re-run `./scripts/slack-setup.sh`
  - Reinstall app via OAuth flow
  - Verify scopes in Slack app settings

**Problem**: "Invalid authentication" error
- **Cause**: Token expired, revoked, or incorrect
- **Solution**:
  - Verify `SLACK_BOT_TOKEN` starts with `xoxb-`
  - Check token hasn't been revoked in Slack app settings
  - Regenerate token if necessary

**Problem**: Message not posting to public channel
- **Cause**: Bot needs to be in channel or use `chat:write.public` scope
- **Solution**:
  - Council Bot has `chat:write.public` - should work without joining
  - If fails, manually invite: `/invite @Council Bot`

### Slack CLI Issues

**Problem**: `slack api` command not found
- **Cause**: This subcommand doesn't exist in Slack CLI v3.9.0
- **Solution**: Use MCP Server (primary) or curl API (fallback)

**Problem**: Manifest validation fails
- **Cause**: Invalid YAML syntax or unsupported features
- **Solution**:
  - Check YAML formatting in `manifest.yml`
  - Run `slack manifest validate --file manifest.yml`
  - Review error messages for specific issues

**Problem**: Authentication fails
- **Cause**: Expired credentials or workspace mismatch
- **Solution**:
  - Run `slack auth list` to see authenticated workspaces
  - Re-authenticate: `slack login`

### API Rate Limits

**Problem**: `rate_limited` error
- **Cause**: Exceeded Slack API rate limits
- **Solution**:
  - Respect tier-based rate limits (varies by method)
  - Implement exponential backoff
  - Cache responses where possible
  - Reduce request frequency

**Slack API Rate Limit Tiers:**
- Tier 1: 1+ request per minute
- Tier 2: 20+ requests per minute
- Tier 3: 50+ requests per minute
- Tier 4: 100+ requests per minute
(Varies by specific API method)

### Common Mistakes

❌ **Don't**: Try to use `slack api` commands in v3.9.0
✅ **Do**: Use MCP functions or curl commands

❌ **Don't**: Hard-code channel names in MCP calls
✅ **Do**: Use channel IDs (get from `slack_list_channels`)

❌ **Don't**: Forget to set environment variables
✅ **Do**: Verify tokens before operations

❌ **Don't**: Assume bot is in all channels
✅ **Do**: Use `chat:write.public` or invite bot explicitly

## Best Practices

1. **Always use MCP Server first** - Type-safe, validated, easier for AI agents
2. **Cache channel IDs** - Look up once, reuse in subsequent operations
3. **Handle errors gracefully** - Check MCP responses for success/failure
4. **Use thread replies** - Keep related messages organized
5. **Add reactions for acknowledgment** - Confirm processing without noise
6. **Respect rate limits** - Batch operations where possible
7. **Test with manifest validation** - Before deploying app changes
8. **Document custom workflows** - Make them reusable for other agents

## Additional Resources

- **Slack API Methods**: https://api.slack.com/methods
- **OAuth Scopes Reference**: https://api.slack.com/scopes
- **Slack CLI v3 Docs**: https://api.slack.com/automation/cli
- **Rate Limits**: https://api.slack.com/docs/rate-limits
- **Block Kit Builder**: https://app.slack.com/block-kit-builder (for rich message formatting)
- **Council Bot Manifest**: `/Users/x/Downloads/slack-hq/manifest.yml`
