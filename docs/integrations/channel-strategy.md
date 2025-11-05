# Slack Channel Strategy for Linear Integrations

**Issue:** [SLHQ-4](https://linear.app/abuah/issue/SLHQ-4)
**Decision Date:** 2025-11-03
**Status:** Decided - Pending Implementation
**Owner:** Kelvin Abuah

---

## Context

Linear integrations with Slack require a designated channel for posting notifications about issue updates, PR events, and team activities. This decision determines which channel pattern to use for optimal team coordination.

---

## Current Slack Channels

**Active in "The Council" workspace (2025-11-04):**
- `#announcements` (C09Q8KCGM9C) - General updates and broadcasts
- `#council-core` (C09QAKDHKMG) - Linear and automation notifications
- `#council-ops` (C09Q761LJUD) - Operations and deployment coordination
- `#engineering` (C09QAL92HFC) - Engineering workstreams
- `#general` (C068K8VDXGB) - Workspace discussion (use sparingly for ops chatter)

**Historical / deprecated:**
- `#2nd-brain` (C0684S1LTLP) - Knowledge base archive (no longer used for broadcasts)
- `#random` (C0684RPSHCP) - Legacy social channel; superseded by #general guidance

---

## Decision: Create `#council-core` for Linear Notifications

### Rationale

**1. Dedicated Purpose**
- Clear signal: automation and issue tracking notifications only
- Team knows exactly what to expect from this channel
- Separates automated updates from human conversation

**2. Noise Management**
- Linear can be configured to post status changes, assignments, comments, and PR events
- Without dedicated channel, these updates would clutter general discussion
- Easy to mute for team members who want less real-time notifications
- Can subscribe for digest-style updates instead of real-time

**3. Scalability**
- Sets precedent for automation channels (#ci-cd, #automation, etc.)
- Follows industry patterns (most teams separate bots from humans)
- Allows fine-grained notification preferences per team member
- Room to add other automation integrations (GitHub Actions, monitoring alerts)

**4. Discoverability**
- Name follows "council-*" pattern for workspace consistency
- "core" signals essential/foundational workspace operations
- Public visibility ensures transparency for all team members

**5. Integration Features**
- Linear posts issue state changes, comments, assignments
- GitHub integration posts PR opened/merged events
- Creates single source of truth for issue activity stream
- Supports threaded conversations about specific issues

### Alternative Considered: Use `#general`

**Pros:**
- No channel creation needed
- Everything in one place for small team

**Cons:**
- Mixes automation with human conversation
- Hard to filter/search for issue updates
- No clear separation of concerns
- Noise level increases as team/projects grow
- Can't customize notification preferences per channel

**Verdict:** ❌ Rejected - Doesn't scale, creates notification fatigue

---

## Implementation Plan

### Step 1: Confirm #council-core Channel (Manual)

**Owner:** Kelvin Abuah
**Estimated Time:** 2 minutes

**Actions:**
1. Open Slack workspace "The Council"
2. Verify `#council-core` exists and is public
3. If missing, create with description: `Linear issue tracking and automation notifications. Status changes, assignments, and PR updates from SLHQ workspace.`
4. Confirm Council Bot is a member (`/invite @Council Bot` if needed)
5. Capture channel ID (format: C############)

### Step 2: Configure Linear Slack Integration (Manual)

**Owner:** Kelvin Abuah
**Estimated Time:** 5 minutes

**Actions:**
1. Install Linear Slack app via Linear Settings → Integrations
2. Authorize for "The Council" workspace
3. Connect SLHQ team
4. Select `#council-core` as notification channel
5. Configure event types (see setup guide for details)

### Step 3: Test and Verify (Manual)

**Owner:** Kelvin Abuah
**Estimated Time:** 5 minutes

**Actions:**
1. Change issue status in Linear → Verify notification in #council-core
2. Add comment to issue → Verify notification
3. Assign issue → Verify notification
4. Create new issue → Verify NO notification (per configuration)

### Step 4: Document Channel ID (Automated by Claude Code)

**Actions:**
- Update `docs/LINEAR-INTEGRATION-STATUS.md` with channel ID
- Update `CLAUDE.md` with channel reference
- Create configuration backup in `docs/integrations/linear-config-backup.md`

---

## Notification Configuration

### Events Enabled in #council-core

| Event Type | Enabled | Rationale |
|------------|---------|-----------|
| Issue status changed | ✅ | Track progress visibility |
| Issue commented | ✅ | Foster collaboration |
| Issue assigned | ✅ | Alert assignees immediately |
| Issue priority changed | ✅ | Highlight urgency shifts |
| PR opened (from GitHub) | ✅ | Code review awareness |
| PR merged (from GitHub) | ✅ | Celebrate completions |

### Events Disabled (Too Noisy)

| Event Type | Enabled | Rationale |
|------------|---------|-----------|
| Issue created | ❌ | Per SLHQ-4 spec: "too noisy" |
| Issue updated (general) | ❌ | Too granular for channel |
| Issue labeled | ❌ | Low priority event |
| Issue description changed | ❌ | Low priority event |

---

## Usage Guidelines

### For Team Members

**When to check #council-core:**
- Daily check for issue activity overview
- Before standup to see what changed
- When @mentioned (direct assignment or reply)
- When investigating issue history/timeline

**Notification preferences:**
- Default: All messages
- Focused: Only @mentions
- Digest: Once daily summary (Slack setting)
- Mute: No notifications (check manually)

### For Claude Code and AI Agents

**Posting to #council-core:**
- Use `mcp__slack__slack_post_message` with channel ID
- Include Linear issue link when relevant
- Use thread replies for follow-up context
- Format: "[Agent Name]: Brief update | [Issue Link]"

**When to post:**
- Completing work on Linear issues
- Handoff between agents
- Significant milestones
- Status updates during long-running tasks

**When NOT to post:**
- Trivial file changes
- Internal agent coordination
- Debug/diagnostic messages
- Repetitive status updates (< 15 min apart)

---

## Future Considerations

### Additional Channels

As the workspace grows, consider:

- **#council-ops** - Operational/deployment notifications
- **#engineering** - Engineering-specific discussions
- **#design-lab** - Design work and feedback
- **#announcements** - Important team announcements only

### Integration Expansion

Potential future integrations for #council-core:

- **GitHub Actions**: CI/CD status updates
- **Monitoring Alerts**: Production issues (if critical)
- **Deployment Notifications**: Release tracking
- **Analytics Events**: Key metric changes

### Channel Hierarchy

Proposed structure:

```
#general              → Team-wide human conversation
#council-core         → Automation & issue tracking
#council-ops          → Deployments & operations
#engineering          → Technical discussions
#design-lab           → Design work
#random               → Off-topic
```

---

## Success Metrics

**Measure effectiveness by:**
1. Team sentiment: Notifications helpful or noisy?
2. Engagement: Are people checking #council-core?
3. Response time: Faster awareness of assignments?
4. Issue visibility: Better team coordination?

**Review quarterly:**
- Adjust notification types if too noisy
- Add/remove channels as team scales
- Survey team for feedback on channel usefulness

---

## References

- **SLHQ-4:** https://linear.app/abuah/issue/SLHQ-4
- **Setup Guide:** /docs/LINEAR-INTEGRATION-SETUP.md
- **Linear Slack Docs:** https://linear.app/docs/slack
- **Council Bot Config:** /manifest.yml

---

**Status:** Decided, pending manual implementation
**Next Step:** Create #council-core channel in Slack
**After Creation:** Update with channel ID and complete SLHQ-4
