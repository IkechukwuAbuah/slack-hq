# Slack MCP Quick Reference Card

**Status:** Both servers configured and ready for comparison testing.

## Server Names & Prefixes

### Official (Deprecated)
```
Server: slack-official
Prefix: mcp__slack-official__*
Status: ⚠️ DEPRECATED
```

### Korotovsky (Maintained)
```
Server: slack-korotovsky
Prefix: mcp__slack-korotovsky__*
Status: ✅ ACTIVE
```

## Quick Commands

### List Channels
```javascript
// Official
mcp__slack-official__slack_list_channels({ limit: 100 })

// Korotovsky
mcp__slack-korotovsky__slack_list_channels({ limit: 100 })
```

### Post Message
```javascript
// Official
mcp__slack-official__slack_post_message({
  channel_id: "C09Q8KCGM9C",
  text: "Your message"
})

// Korotovsky
mcp__slack-korotovsky__slack_post_message({
  channel_id: "C09Q8KCGM9C",
  text: "Your message"
})
```

### Reply to Thread
```javascript
// Official
mcp__slack-official__slack_reply_to_thread({
  channel_id: "C09Q8KCGM9C",
  thread_ts: "1234567890.123456",
  text: "Reply"
})

// Korotovsky
mcp__slack-korotovsky__slack_reply_to_thread({
  channel_id: "C09Q8KCGM9C",
  thread_ts: "1234567890.123456",
  text: "Reply"
})
```

## Key Channels

| Name | ID | Purpose |
|------|-----|---------|
| #general | C068K8VDXGB | General workspace |
| #announcements | C09Q8KCGM9C | Major broadcasts |
| #council-core | C09QAKDHKMG | Session tracking (default), integrations |
| #ai-agents | C09Q73W69GD | Agent coordination |
| #engineering | C09QALF8WD8 | Technical work |

## Testing Checklist

- [ ] Both servers return 23 channels (not 3)
- [ ] Messages post successfully from both
- [ ] Thread replies work correctly
- [ ] Channel history is consistent
- [ ] User listing matches
- [ ] Reactions work on both
- [ ] Performance is acceptable
- [ ] No unexpected errors

## Current Status

**Environment Fix:** ✅ `SLACK_CHANNEL_IDS` removed from `~/.zshrc`

**Next Step:** Restart Claude Code to activate both servers

**Testing:** Pending restart

## After Restart

1. Run: `list slack channels with slack-official mcp`
2. Run: `list slack channels with slack-korotovsky mcp`
3. Compare: Should both return 23 channels
4. Fill in test results in `/docs/comparisons/slack-mcp-comparison.md`

## Decision Point

After 1-2 weeks of testing:
- ✅ Keep both if they serve different use cases
- ✅ Migrate to Korotovsky if it's superior
- ✅ Keep official only if Korotovsky has issues

## Documentation

**Full Guide:** `/docs/comparisons/slack-mcp-comparison.md`
**Tool Registry:** `/TOOL-REGISTRY.md` (to be updated)
