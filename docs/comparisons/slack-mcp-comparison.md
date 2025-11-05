# Slack MCP Server Comparison Guide

This document provides a side-by-side comparison of two Slack MCP servers configured in the slack-hq project.

## Configured Servers

### 1. Official MCP Server (Deprecated)
- **MCP Name:** `slack-official`
- **Package:** `@modelcontextprotocol/server-slack@2025.4.25`
- **Status:** ⚠️ **DEPRECATED** (no longer maintained)
- **GitHub:** https://github.com/modelcontextprotocol/servers
- **Tool Prefix:** `mcp__slack-official__*`

### 2. Korotovsky MCP Server (Active)
- **MCP Name:** `slack-korotovsky`
- **Package:** `@korotovsky/slack-mcp-server`
- **Status:** ✅ **ACTIVELY MAINTAINED**
- **GitHub:** https://github.com/korotovsky/slack-mcp-server
- **Monthly Users:** 30,000+
- **Tool Prefix:** `mcp__slack-korotovsky__*`

## Configuration

Both servers are configured in `/Users/x/.claude/mcp.json`:

```json
{
  "slack-official": {
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/server-slack"],
    "env": {
      "SLACK_BOT_TOKEN": "xoxb-...",
      "SLACK_TEAM_ID": "T068KC5GURY",
      "SLACK_USER_TOKEN": "xoxp-..."
    }
  },
  "slack-korotovsky": {
    "command": "npx",
    "args": ["-y", "@korotovsky/slack-mcp-server"],
    "env": {
      "SLACK_BOT_TOKEN": "xoxb-...",
      "SLACK_TEAM_ID": "T068KC5GURY"
    }
  }
}
```

## Testing Checklist

After restarting Claude Code, test both servers with these operations:

### Test 1: Channel Listing
**Issue:** Official server was limited to 3 channels due to `SLACK_CHANNEL_IDS` env var bug.

```javascript
// Official server (was returning 3, should now return 23)
mcp__slack-official__slack_list_channels({ limit: 100 })

// Korotovsky server (expected: 23 channels)
mcp__slack-korotovsky__slack_list_channels({ limit: 100 })
```

**Expected Results:**
- ✅ Both should return all 23 public channels
- ✅ Channel IDs should match between both servers
- ✅ No pagination errors

### Test 2: Post Message
```javascript
// Official server
mcp__slack-official__slack_post_message({
  channel_id: "C09Q8KCGM9C",  // #announcements
  text: "Test from official MCP server"
})

// Korotovsky server
mcp__slack-korotovsky__slack_post_message({
  channel_id: "C09Q8KCGM9C",  // #announcements
  text: "Test from Korotovsky MCP server"
})
```

**Expected Results:**
- ✅ Both messages post successfully
- ✅ Messages appear in #announcements
- ✅ No formatting differences

### Test 3: Thread Reply
```javascript
// Official server
mcp__slack-official__slack_reply_to_thread({
  channel_id: "C09Q8KCGM9C",
  thread_ts: "1234567890.123456",
  text: "Reply from official server"
})

// Korotovsky server
mcp__slack-korotovsky__slack_reply_to_thread({
  channel_id: "C09Q8KCGM9C",
  thread_ts: "1234567890.123456",
  text: "Reply from Korotovsky server"
})
```

**Expected Results:**
- ✅ Both replies appear in same thread
- ✅ Threading is maintained correctly
- ✅ No duplicate messages

### Test 4: Channel History
```javascript
// Official server
mcp__slack-official__slack_get_channel_history({
  channel_id: "C09Q8KCGM9C",
  limit: 10
})

// Korotovsky server
mcp__slack-korotovsky__slack_get_channel_history({
  channel_id: "C09Q8KCGM9C",
  limit: 10
})
```

**Expected Results:**
- ✅ Both return same recent messages
- ✅ Message ordering is consistent
- ✅ Timestamps match

### Test 5: User Listing
```javascript
// Official server
mcp__slack-official__slack_get_users({ limit: 50 })

// Korotovsky server
mcp__slack-korotovsky__slack_get_users({ limit: 50 })
```

**Expected Results:**
- ✅ Both return same users
- ✅ User profiles are complete
- ✅ No pagination issues

### Test 6: Reactions
```javascript
// Official server
mcp__slack-official__slack_add_reaction({
  channel_id: "C09Q8KCGM9C",
  timestamp: "1234567890.123456",
  reaction: "thumbsup"
})

// Korotovsky server
mcp__slack-korotovsky__slack_add_reaction({
  channel_id: "C09Q8KCGM9C",
  timestamp: "1234567890.123456",
  reaction: "rocket"
})
```

**Expected Results:**
- ✅ Both reactions added successfully
- ✅ Reactions appear on same message
- ✅ Emoji rendering is correct

## Feature Comparison

### Official Server Features
- ✅ List channels
- ✅ Post messages
- ✅ Reply to threads
- ✅ Get channel history
- ✅ Get thread replies
- ✅ List users
- ✅ Get user profile
- ✅ Add reactions
- ❌ DM support (limited)
- ❌ Advanced history features
- ⚠️ **DEPRECATED** - No future updates

### Korotovsky Server Features
According to the [GitHub repo](https://github.com/korotovsky/slack-mcp-server):

**Standard Features:**
- ✅ List channels
- ✅ Post messages
- ✅ Reply to threads
- ✅ Get channel history
- ✅ List users
- ✅ Add reactions

**Advanced Features:**
- ✅ **DM Support** - Send direct messages to users
- ✅ **Smart History** - Advanced message search and filtering
- ✅ **Stealth Mode** - Read channels without triggering "seen" status
- ✅ **No Permissions Required** - Works with minimal bot scopes
- ✅ **Active Maintenance** - Regular updates and bug fixes

## Performance Comparison

Track these metrics during testing:

| Metric | Official Server | Korotovsky Server |
|--------|----------------|-------------------|
| Channel list response time | _TBD_ | _TBD_ |
| Message post latency | _TBD_ | _TBD_ |
| History fetch speed | _TBD_ | _TBD_ |
| Error rate | _TBD_ | _TBD_ |
| Package install time | _TBD_ | _TBD_ |

## Known Issues

### Official Server Issues
1. ⚠️ **SLACK_CHANNEL_IDS bug** - When this env var is set, only returns specified channels
   - **Fixed:** Commented out in `~/.zshrc` line 29
2. ⚠️ **Deprecated package** - No longer maintained or updated
3. ⚠️ **Limited DM support** - Cannot send direct messages effectively

### Korotovsky Server Issues
- 🔄 To be discovered during testing

## Recommendation Timeline

1. **Week 1:** Run both servers in parallel
2. **Week 2:** Collect comparison data and identify issues
3. **Week 3:** Make migration decision based on:
   - Feature completeness
   - Performance metrics
   - Bug frequency
   - Community support
4. **Week 4:** Migrate to chosen server and update documentation

## Migration Plan (If switching to Korotovsky)

1. **Update CLAUDE.md** - Change tool prefix references
2. **Update TOOL-REGISTRY.md** - Document new server capabilities
3. **Update scripts** - Any automation using Slack MCP tools
4. **Test session tracking** - Ensure `/session-post` still works
5. **Remove official server** - Clean up mcp.json configuration

## Test Results

### Date: [After restart - To be filled]

| Test | Official Server | Korotovsky Server | Winner |
|------|----------------|-------------------|---------|
| Channel Listing | | | |
| Message Posting | | | |
| Thread Replies | | | |
| Channel History | | | |
| User Listing | | | |
| Reactions | | | |

### Notes
- [Add observations here after testing]

## Conclusion

[To be filled after 1-2 weeks of testing]

**Recommended Server:** _TBD_

**Reasoning:** _TBD_
