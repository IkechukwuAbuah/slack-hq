# Linear Labels Complete Reference

A comprehensive, searchable reference of all labels used in the SLHQ Linear team.

## Quick Navigation

- [Type Labels](#type-labels)
- [AI Agent Labels](#ai-agent-labels)
- [Team Labels](#team-labels)
- [Phase Labels](#phase-labels)
- [Design Phase Labels](#design-phase-labels)
- [Other Labels](#other-labels)
- [Label Combinations](#label-combinations)
- [How to Apply Labels](#how-to-apply-labels)

---

## Type Labels

**Use**: Every issue gets exactly ONE type label. Indicates the nature of the work.

| Label | Color | ID | Description | Use When |
|-------|-------|----|-|-|
| **Bug** | Red<br>#EB5757 | 80133c8a-34ad-472b-ac9f-171710e0bb32 | Bug reports and fixes | Reporting defects or fixing problems |
| **Feature** | Purple<br>#BB87FC | 9cec5303-1e24-42d0-b663-c931da959c2b | New features and capabilities | Adding new functionality |
| **Improvement** | Blue<br>#4EA7FC | e885ef6a-f7ca-4ae9-98fd-f8e6a6f31bc3 | Enhancements to existing features | Improving existing functionality |
| **Documentation** | Green<br>#4cb782 | 4299fff0-e24d-4231-b215-027966d6a541 | Documentation creation and updates | Writing or updating docs |

---

## AI Agent Labels

**Use**: Apply ALL relevant AI agent labels. Multiple agents can work on one issue.

### Core AI Services

| Label | Color | ID | Description | Best For |
|-------|-------|----|-|-|
| **ai:claude-code** | Bright Blue<br>#0066FF | fab99e28-0f7c-4a48-ba79-bdd684e70ab3 | Documentation, coordination, markdown specialist | Docs, planning, coordination, markdown tasks |
| **ai:claude-desktop** | Light Purple<br>#C084FC | 7f03ad85-df5b-4806-a1ac-1e73c8f6e9cf | Claude Desktop application work | Desktop app specific features |
| **ai:codex** | Medium Blue<br>#0052CC | 7f4a163a-87d0-4c52-880e-41fd11696120 | Autonomous implementation with reasoning (GPT-5) | Complex implementation, autonomous coding |
| **ai:chatgpt** | Purple<br>#8B5CF6 | 3fd90d0d-f57a-472e-9d4e-aed410269424 | ChatGPT tasks - General AI assistance | General AI tasks, various domains |
| **ai:gemini** | Deep Blue<br>#002966 | 9b44ea0e-293c-43a4-a422-51318ae21c85 | Large-scale codebase analysis (2M+ token context) | Large codebase analysis, architecture review |
| **ai:cursor** | Red<br>#FF6B6B | 99193c05-4c04-4502-bffd-9f72cf7f9c70 | Cursor code editor assistant | Interactive development, code editing |
| **claude** | Purple<br>#8B5CF6 | c8edf242-1007-48be-b346-50177d42164c | Claude in every form (generic) | General Claude work (unspecified variant) |

### IDE & Terminal Assistants

| Label | Color | ID | Description | Best For |
|-------|-------|----|-|-|
| **warp** | Blue-Violet<br>#3333FF | dc5c96fe-4c73-4314-b314-13f80d90c5a2 | Warp terminal AI assistant | Terminal automation, shell scripting |
| **windsurf** | Light Blue<br>#4D4DFF | e40ed0fc-3f2c-49e0-a6a3-1caa9029910f | Windsurf code editing assistant | Code editing, IDE features |
| **Devin** | Cyan<br>#26b5ce | bb5e0319-df6a-457f-9cc7-0338d4643384 | Devin AI code assistant | AI-assisted coding tasks |

### Infrastructure & Management

| Label | Color | ID | Description | Best For |
|-------|-------|----|-|-|
| **session-tracker** | Medium Green<br>#009933 | 32a0e172-9364-433a-8381-15f4b2eae820 | Session management and audit trails | Session tracking, activity logging |
| **tool-registry-manager** | Dark Green<br>#008822 | f2a9009c-3f7f-4417-8ee1-ed597b7a27a7 | Tool validation and lifecycle management | Tool management, registry updates |

---

## Team Labels

**Use**: Every issue gets exactly ONE team label (or none for cross-functional work). Indicates ownership area.

| Label | Color | ID | Description | When to Use |
|-------|-------|----|-|-|
| **Engineering Team** | Beige<br>#f7c8c1 | 68dd5186-fb32-4ee1-a7c0-3e3b378e7c60 | Engineering work and development | All development and technical tasks |
| **Design Team** | Beige<br>#f7c8c1 | ed7f2449-af51-4f41-b580-df4874ce9e08 | Design and UX work | Design, UX, user research |
| **Product Team** | Beige<br>#f7c8c1 | eda61c3e-2e2a-467a-ad70-e9e4989fe249 | Product management and strategy | Product planning, roadmapping |

---

## Development Phase Labels

**Use**: Pick the CURRENT development phase. Update as work progresses through phases.

| Label | Color | ID | Purpose | Typical Duration |
|-------|-------|----|-|-|
| **Phase 3.1 - Setup** | Dark Blue<br>#0066CC | d62c5fad-c1b4-44e3-9b05-5004a68049e7 | Project setup and initialization | Initial 1-2 days |
| **Phase 3.2 - TDD Tests** | Red<br>#FF6B6B | 1702c7f7-39bd-4b2c-92a2-3e3fd1a84d39 | Test-driven development phase | 2-3 days |
| **Phase 3.3 - Core Implementation** | Green<br>#4ECB71 | f32491d4-a375-40a2-b574-9383e121949a | Core feature implementation | 3-5 days |
| **Phase 3.4 - API Endpoints** | Yellow<br>#FFD93D | 4c326176-c0da-4687-ad2c-dfd364fd401c | API endpoint development | 2-3 days |
| **Phase 3.5 - Integration** | Purple<br>#9D5CFF | 1ffe30e8-fca1-4cdf-8da9-eb070aa7e855 | System integration work | 2-4 days |
| **Phase 3.6 - Voice/Chat** | Orange<br>#FF9500 | c0ad48c3-9b0e-4c8e-9eed-7a72f15bb8e1 | Voice and chat features | 2-3 days |
| **Phase 3.7 - Polish** | Teal<br>#00BFA5 | cf058ebe-1efb-4339-8b24-8fbb8d41c631 | Polish and refinement | 1-2 days |

---

## Design Phase Labels

**Use**: For design-focused work. Pick the current design phase.

| Label | Color | ID | Purpose |
|-------|-------|----|-|
| **User Research Phase** | Green<br>#4cb782 | 825bc11c-1e7c-411c-b1fe-0ff468ff21e3 | User research and discovery |
| **Ideation Phase** | Green<br>#4cb782 | aa69f380-7e98-42fb-ac7c-7197ac80b0b8 | Brainstorming and ideation |
| **Design Phase** | Green<br>#4cb782 | 4e995035-efa1-471f-ab9a-e42774d0de67 | Design creation and refinement |
| **Prototype Phase** | Green<br>#4cb782 | 8bb2e9d9-b758-4246-9284-131937cae3ee | Prototype development |
| **Handoff Phase** | Green<br>#4cb782 | b3a9c41a-dd61-4306-a767-bbdd38d7c74b | Design handoff to engineering |

---

## Other Labels

**Use**: As appropriate for additional context and categorization.

| Label | Color | ID | Purpose | When to Use |
|-------|-------|----|-|-|
| **Can Run Parallel** | Brown<br>#795548 | 759c6c63-3f50-4389-86f5-5c8ad77b1c11 | Parallelizable work | Work that can be done concurrently |
| **Design** | Blue<br>#5e6ad2 | 82fc4196-f08e-4c56-817f-b1abf60afeff | Design-related work | Design-specific implementation |
| **Engineering** | Orange<br>#f2994a | 718f0544-fa17-4f93-bc97-8ac0114a0c78 | Engineering-related work | Technical implementation |
| **Customer Request** | Beige<br>#f7c8c1 | 0dd59517-0e01-49b1-8fe7-f231d91aece6 | Customer-initiated request | Customer-driven features |

---

## Label Combinations

### Engineering Task

```
+ Feature/Bug/Improvement
+ ai:claude-code (or ai:cursor, ai:codex, ai:gemini)
+ Engineering Team
+ Phase 3.3 (or current phase)
```

Example: Feature + ai:claude-code + ai:cursor + Engineering Team + Phase 3.3

### Documentation Task

```
+ Documentation
+ ai:claude-code (documentation specialist)
+ Engineering Team
```

Example: Documentation + ai:claude-code + Engineering Team

### Design Task

```
+ Improvement (or Feature for new designs)
+ Design Team
+ Design Phase (User Research, Ideation, Design, Prototype, or Handoff)
```

Example: Improvement + Design Team + Design Phase

### Multi-Agent Task

```
+ Feature
+ ai:claude-code + ai:codex + ai:cursor
+ Engineering Team
+ Phase 3.3
```

Example: Feature + ai:claude-code + ai:codex + Engineering Team + Phase 3.3

### Customer Request

```
+ Feature
+ Customer Request
+ Engineering Team (or Design Team)
+ [appropriate phase]
```

Example: Feature + Customer Request + Engineering Team + Phase 3.3

### Parallelizable Work

```
+ [type label]
+ Can Run Parallel
+ [appropriate team and phase]
```

Example: Feature + Can Run Parallel + Engineering Team + Phase 3.3

---

## Label Best Practices

### DO ✅

- ✅ Apply ONE type label (Bug, Feature, Improvement, Documentation)
- ✅ Apply AI agent labels for all agents involved
- ✅ Apply ONE team label (unless cross-functional)
- ✅ Apply development OR design phase (whichever is applicable)
- ✅ Update phase labels as work progresses
- ✅ Add context labels (Customer Request, Can Run Parallel) as needed
- ✅ Review label combinations for consistency

### DON'T ❌

- ❌ Apply multiple type labels (pick ONE)
- ❌ Apply multiple team labels (pick ONE, or none for cross-functional)
- ❌ Apply both development AND design phase labels at same time
- ❌ Leave phase label after work is complete
- ❌ Overload with too many labels (aim for 4-6 max)
- ❌ Forget to update labels as issue progresses

---

## How to Apply Labels

### When Creating an Issue

1. Fill in title and description
2. Scroll to **Labels** section
3. **Click the label field**
4. **Labels appear grouped** by category
5. **Select labels** by clicking them
6. **Add from multiple groups** as needed
7. **Click Create** when done

### When Editing an Issue

1. **Open the issue**
2. **Click the Labels field** (right side of screen)
3. **View grouped labels** in dropdown
4. **Click to add** labels
5. **Click X to remove** labels
6. Changes save automatically

### Label Search

1. **In label picker**, start typing
2. **Linear filters** labels as you type
3. **Select from results**

Example searches:
- Type "claude" to find all Claude-related labels
- Type "phase" to find all phase labels
- Type "engineering" to find team labels

---

## Label Color Legend

### Blues (AI Services - Core)
- 🔵 `#0066FF` - ai:claude-code
- 🔵 `#0052CC` - ai:codex
- 🔵 `#002966` - ai:gemini
- 🔵 `#3333FF` - warp
- 🔵 `#4D4DFF` - windsurf

### Purples (Claude Variants)
- 🟣 `#BB87FC` - Feature
- 🟣 `#8B5CF6` - ai:chatgpt, claude
- 🟣 `#C084FC` - ai:claude-desktop
- 🟣 `#9D5CFF` - Phase 3.5 - Integration

### Greens (Completed/Design)
- 🟢 `#4cb782` - Documentation, Design Phases
- 🟢 `#00AA44` - (subagent)
- 🟢 `#009933` - session-tracker
- 🟢 `#008822` - tool-registry-manager
- 🟢 `#4ECB71` - Phase 3.3 - Core Implementation

### Warm Colors (Progress/Status)
- 🔴 `#EB5757` - Bug
- 🔴 `#FF6B6B` - ai:cursor
- 🟠 `#FF9500` - Phase 3.6 - Voice/Chat
- 🟠 `#f2994a` - Engineering
- 🟡 `#FFD93D` - Phase 3.4 - API Endpoints

### Neutral (Teams/Meta)
- 🟤 `#795548` - Can Run Parallel
- 🟤 `#f7c8c1` - Team Labels, Customer Request
- 🔷 `#5e6ad2` - Design
- 🔷 `#0066CC` - Phase 3.1 - Setup
- 🔆 `#26b5ce` - Devin

### Blues (Improvements)
- 🔵 `#4EA7FC` - Improvement

---

## Troubleshooting Labels

### Can't find a label?

1. **Search by name**: Start typing in label field
2. **Check category**: Labels are grouped, may be in different section
3. **Verify team**: Label must belong to SLHQ team
4. **Refresh page**: Sometimes UI doesn't update immediately

### Label not appearing after creation?

1. **Wait 10-30 seconds** - New labels take time to sync
2. **Refresh page** - Browser cache might be stale
3. **Check Linear UI** - Go to Team Settings → Labels to verify
4. **Check team ID** - Ensure created for `7a15a4a6-7f83-4ead-8d80-3024d6bb7151`

### Need a new label?

1. **Check this guide** - Label might already exist with different name
2. **Propose in #council-core** - Suggest new label to team
3. **Create via linear-bot** - Use MCP to create if approved
4. **Contact admin** - Kelvin Abuah can create labels

---

## Label Statistics

| Category | Count | Notes |
|----------|-------|-------|
| Type Labels | 4 | Bug, Feature, Improvement, Documentation |
| AI Agent Labels | 11 | Core services, IDE/terminal, infrastructure |
| Team Labels | 3 | Engineering, Design, Product |
| Dev Phases | 7 | Phase 3.1 through 3.7 |
| Design Phases | 5 | Research, Ideation, Design, Prototype, Handoff |
| Other Labels | 4 | Can Run Parallel, Design, Engineering, Customer Request |
| **TOTAL** | **32** | Comprehensive label system |

---

## Document Information

- **Last Updated**: November 5, 2025
- **Version**: 1.0
- **Maintained By**: Kelvin Abuah & Council Team
- **Related Docs**: [LINEAR-ONBOARDING.md](./LINEAR-ONBOARDING.md)

For label system changes or additions, create an issue with label "Documentation" and tag @ai:claude-code.
