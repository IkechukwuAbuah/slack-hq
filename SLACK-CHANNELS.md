# Slack Channels Reference

**Workspace:** The Council
**Team ID:** T068KC5GURY
**Last Updated:** 2025-11-04

---

## Current Active Channels

| Channel Name | Channel ID | Primary Use |
|--------------|------------|-------------|
| #announcements | C09Q8KCGM9C | General updates and broadcasts |
| #council-core | C09QAKDHKMG | Automation notifications (Linear, GitHub) |
| #council-ops | C09Q761LJUD | Operations and deployment default |
| #ai-agents | C09Q73W69GD | AI agent coordination |
| #project-updates | C09QAHNAFL2 | Project milestone updates |
| #council-bot | C09R4SBU4JU | Council Bot specific |
| #automation | C09R4SCGR24 | CI/CD and automation logs |
| #documentation | C09R4SCJ108 | Documentation updates |
| #engineering | C09QAL92HFC | Engineering work |
| #design-lab | C09QALF8WD8 | Design and UX work |
| #docs | C09Q76ULRHB | Documentation (alternate) |
| #briefings | C09QPHJR517 | Brief status updates |
| #general | C068K8VDXGB | Workspace general discussion |

---

## Usage Guidelines

### When to Post Where

**#announcements** (C09Q8KCGM9C)
- Major feature completions (human-initiated)
- System-wide updates for the entire Council
- Important announcements for all agents
- **NOT used for:** Automated session tracking (use #council-core instead)

**#council-core** (C09QAKDHKMG)
- Session tracking summaries (default channel for automated session posts)
- Linear issue updates (automated)
- GitHub PR events (automated)
- Integration notifications

**#council-ops** (C09Q761LJUD)
- Operational procedures and runbooks
- Manual deployment coordination
- Crisis management and incidents

**#engineering** (C09QAL92HFC)
- Technical implementation work
- Code reviews
- Engineering milestones

**#design-lab** (C09QALF8WD8)
- UI/UX work
- Design reviews
- Visual assets

**#automation** (C09R4SCGR24)
- CI/CD pipelines
- Automated tests
- Build notifications

**#docs** / **#documentation** (C09Q76ULRHB / C09R4SCJ108)
- Documentation updates
- Spec reviews
- Writing status

---

## Quick Reference

### Slack MCP (Primary Method)

```javascript
// Post to announcements
mcp__slack__slack_post_message({
  channel_id: "C09Q8KCGM9C",
  text: "Your message"
});

// Reply to thread
mcp__slack__slack_reply_to_thread({
  channel_id: "C09Q8KCGM9C",
  thread_ts: "1234567890.123456",
  text: "Thread reply"
});

// List all channels
mcp__slack__slack_list_channels({ limit: 100 });
```

### Direct API (Fallback)

```bash
# Post message
curl -X POST https://slack.com/api/chat.postMessage \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"channel":"C09Q8KCGM9C","text":"Message"}'

# List channels
curl -X GET "https://slack.com/api/conversations.list?types=public_channel" \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN"
```

---

## Best Practices

✅ **DO:**
- Use channel IDs (C09...), not names (#channel-name)
- Post to appropriate channel based on content type
- Use threads for related discussions
- Include context in notifications

❌ **DON'T:**
- Spam channels with frequent updates
- Cross-post same message to multiple channels
- Use deprecated/old channel IDs

---

## Channel ID Validation

All channel IDs in this document are verified current as of 2025-11-04.

To verify channels are still active:
```bash
# Via Slack MCP
mcp__slack__slack_list_channels({ limit: 100 })

# Via API
curl -X GET "https://slack.com/api/conversations.list" \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN"
```

---

## Related Documentation

- **CLAUDE.md** - Session tracking and broadcast requirements
- **AGENTS.md** - Agent-specific channel guidelines
- **TOOL-REGISTRY.md** - Slack MCP and API documentation
