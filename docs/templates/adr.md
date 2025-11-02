---
title: ADR-NNN: [Decision Title]
linear_id: LIN-XXX
type: adr
status: [Proposed | Accepted | Deprecated | Superseded]
created: YYYY-MM-DD
updated: YYYY-MM-DD
author: [Your Name]
related: []
supersedes: [ADR-XXX if applicable]
superseded_by: [ADR-YYY if applicable]
---

# ADR-NNN: [Decision Title]

## Status

**[Proposed | Accepted | Deprecated | Superseded]**

*If superseded*: See [ADR-YYY](/docs/adrs/YYY-new-decision.md)

---

## Context

Describe the forces at play, including:
- Technical landscape
- Business requirements
- Constraints (time, resources, technology)
- Current situation that prompted this decision
- Problem statement

**Background**:
Provide any historical context that's relevant to understanding why this decision is needed.

**Problem**:
What specific problem are we solving? What is the impact of not solving it?

---

## Decision

**We will [clear statement of the decision].**

Describe the decision in detail:
- What are we doing?
- How will it be implemented?
- What are the key aspects of this approach?
- What alternatives are we explicitly rejecting?

### Key Points

1. **Point 1**: Detailed explanation
2. **Point 2**: Detailed explanation
3. **Point 3**: Detailed explanation

---

## Rationale

Explain WHY this is the right decision:

### Technical Reasons
- Reason 1: Explanation
- Reason 2: Explanation
- Reason 3: Explanation

### Business Reasons
- Reason 1: Explanation
- Reason 2: Explanation

### Risk Mitigation
- How this decision reduces risk
- What risks it introduces and how we'll manage them

---

## Alternatives Considered

### Alternative 1: [Name]

**Description**: What this alternative entails

**Pros**:
- Advantage 1
- Advantage 2

**Cons**:
- Disadvantage 1
- Disadvantage 2

**Why rejected**: Clear explanation of why we didn't choose this option

---

### Alternative 2: [Name]

**Description**: What this alternative entails

**Pros**:
- Advantage 1
- Advantage 2

**Cons**:
- Disadvantage 1
- Disadvantage 2

**Why rejected**: Clear explanation of why we didn't choose this option

---

### Alternative 3: Do Nothing

**Description**: Continue with current approach

**Pros**:
- No implementation cost
- No risk of change

**Cons**:
- Problem persists
- Technical debt accumulates

**Why rejected**: The cost of inaction outweighs the cost of change

---

## Consequences

### Positive Consequences

**Technical**:
- ✅ Benefit 1
- ✅ Benefit 2
- ✅ Benefit 3

**Business**:
- ✅ Benefit 1
- ✅ Benefit 2

**Team/Process**:
- ✅ Benefit 1
- ✅ Benefit 2

---

### Negative Consequences

**Technical**:
- ⚠️ Trade-off 1 and how we'll mitigate it
- ⚠️ Trade-off 2 and how we'll mitigate it

**Business**:
- ⚠️ Trade-off 1 and how we'll mitigate it

**Team/Process**:
- ⚠️ Learning curve, training needs
- ⚠️ Process changes required

---

### Neutral Consequences

Things that will change but aren't strictly positive or negative:
- Change 1: What this means
- Change 2: What this means

---

## Implementation

### Migration Plan

**Phase 1**: [Description]
- Task 1
- Task 2
- Timeline: X weeks

**Phase 2**: [Description]
- Task 1
- Task 2
- Timeline: Y weeks

### Rollback Strategy

If this decision proves problematic, here's how we can revert:
1. Step 1
2. Step 2
3. Expected rollback time: X hours

### Success Criteria

How we'll know this decision was successful:
- [ ] Metric 1 shows improvement
- [ ] Metric 2 is within acceptable range
- [ ] System stability maintained
- [ ] Team velocity not impacted negatively

---

## Impact Analysis

### Affected Systems
- **System 1**: How it's affected, required changes
- **System 2**: How it's affected, required changes
- **System 3**: How it's affected, required changes

### Affected Teams
- **Team 1**: Impact, training needs, timeline
- **Team 2**: Impact, training needs, timeline

### Affected Processes
- **Process 1**: Changes required
- **Process 2**: Changes required

---

## Dependencies

### Technical Dependencies
- [ ] Dependency 1: What's needed
- [ ] Dependency 2: What's needed

### Decision Dependencies
- [ ] ADR-XXX: Must be implemented first
- [ ] Approval from: [Stakeholder]

### Resource Dependencies
- Budget: $X for [specific need]
- Time: X person-weeks
- Infrastructure: [Requirements]

---

## Timeline

| Milestone | Date | Owner |
|-----------|------|-------|
| Decision proposed | YYYY-MM-DD | [Name] |
| Review period | YYYY-MM-DD to YYYY-MM-DD | [Team] |
| Decision accepted | YYYY-MM-DD | [Decision maker] |
| Implementation start | YYYY-MM-DD | [Team] |
| Implementation complete | YYYY-MM-DD | [Team] |
| Evaluation checkpoint | YYYY-MM-DD | [Name] |

---

## Stakeholders

### Decision Makers
- **[Name/Role]**: Final approval authority

### Consulted
- **[Name/Role]**: Subject matter expert on X
- **[Name/Role]**: Business owner for Y

### Informed
- **[Team/Role]**: Will be affected by implementation
- **[Team/Role]**: Needs to be aware for future work

---

## Risks & Mitigation

| Risk | Probability | Impact | Mitigation Strategy |
|------|-------------|--------|---------------------|
| Risk 1 description | [High/Med/Low] | [High/Med/Low] | How we'll address it |
| Risk 2 description | [High/Med/Low] | [High/Med/Low] | How we'll address it |
| Risk 3 description | [High/Med/Low] | [High/Med/Low] | How we'll address it |

---

## Review & Evaluation

### Review Process
- Review period: [X weeks]
- Reviewers: [Names/Roles]
- Feedback deadline: [Date]

### Post-Implementation Review
- **When**: [X months after implementation]
- **What to evaluate**:
  - Did we achieve the expected benefits?
  - Were the consequences as predicted?
  - Should we adjust or reverse the decision?

### Success Metrics
- **Metric 1**: Target value, Current value, Measurement method
- **Metric 2**: Target value, Current value, Measurement method
- **Metric 3**: Target value, Current value, Measurement method

---

## Related Documents

### Specifications
- [LIN-XXX: Feature Spec](/docs/specs/LIN-XXX-feature.md)

### Other ADRs
- [ADR-XXX: Related Decision](/docs/adrs/XXX-related.md)
- [ADR-YYY: Superseding Decision](/docs/adrs/YYY-new.md) (if applicable)

### Runbooks
- [Runbook: Operation X](/docs/runbooks/operation-x.md)

### External References
- [Link to technology documentation]
- [Link to research paper/article]
- [Link to industry best practices]

---

## Notes

### Discussion Summary
Key points from discussions that led to this decision:
- Point 1 from meeting on [date]
- Point 2 from async discussion
- Point 3 from stakeholder feedback

### Open Questions (if status is Proposed)
1. Question 1: [Details]
2. Question 2: [Details]

### Assumptions
- Assumption 1: Explanation
- Assumption 2: Explanation

---

## Changelog

| Date | Author | Changes |
|------|--------|---------|
| YYYY-MM-DD | [Name] | Initial proposal |
| YYYY-MM-DD | [Name] | Updated based on review feedback |
| YYYY-MM-DD | [Name] | Accepted |
| YYYY-MM-DD | [Name] | Updated with implementation results |

---

## Appendix

### References
- [Citation 1]
- [Citation 2]

### Supporting Data
- Benchmark results
- Performance metrics
- Cost analysis
- Survey results

### Proof of Concept Results
If a POC was conducted:
- Approach taken
- Results observed
- Lessons learned
- Code/repository links
