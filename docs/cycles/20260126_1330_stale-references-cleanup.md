---
feature: maintenance
cycle: stale-references-cleanup
phase: DONE
created: 2026-01-26 13:30
updated: 2026-01-26 13:30
---

# Stale References Cleanup

## Scope Definition

### In Scope
- [ ] Remove/update test-skills-structure.sh (references deleted templates/)
- [ ] Fix tdd-red/SKILL.md line 93 (references non-existent testing-guide.md)

### Out of Scope
- New features
- Other refactoring

### Files to Change (target: 10 or less)
- scripts/test-skills-structure.sh (delete or update)
- plugins/tdd-core/skills/tdd-red/SKILL.md (edit line 93)

## Environment

### Scope
- Layer: Maintenance
- Plugin: tdd-core, scripts
- Risk: 10 (PASS)

### Runtime
- Bash: 3.2.57

### Dependencies (key packages)
- None

### Risk Interview (BLOCK only)
N/A (PASS level)

## Context & Dependencies

### Reference Documents
- Stability review results

### Dependent Features
- None

### Related Issues/PRs
- None (maintenance task)

## Test List

### TODO
- [ ] TC-01: test-skills-structure.sh removed OR updated
- [ ] TC-02: tdd-red/SKILL.md does NOT reference testing-guide.md
- [ ] TC-03: All other test scripts still pass

### WIP
(none)

### DISCOVERED
(none)

### DONE
(none)

## Implementation Notes

### Goal
Clean up stale references detected in stability review.

### Background
1. test-skills-structure.sh references templates/generic (deleted in v1.2.1)
2. tdd-red/SKILL.md line 93 references non-existent testing-guide.md

### Design Approach
1. Delete test-skills-structure.sh (obsolete)
2. Remove line 93 from tdd-red/SKILL.md

## Progress Log

### 2026-01-26 13:30 - INIT
- Cycle doc created
- Scope: 2 stale reference fixes
- Risk: 10 (PASS)

---

## Next Steps

1. [Done] INIT <- Current
2. [Next] PLAN
3. [ ] RED
4. [ ] GREEN
5. [ ] REFACTOR
6. [ ] REVIEW
7. [ ] COMMIT
