---
feature: maintenance
cycle: cleanup-unused-files
phase: DONE
created: 2026-01-26 14:00
updated: 2026-01-26 14:00
---

# Cleanup Unused Files

## Scope Definition

### In Scope
- [ ] Delete install-mcp.sh (MCP不要)
- [ ] Delete failing/stale test scripts (6件)

### Out of Scope
- Test script修正（削除のみ）

### Files to Delete
- scripts/install-mcp.sh
- scripts/test-git-conventions-template.sh
- scripts/test-git-safety-template.sh
- scripts/test-phase4-adjustments.sh
- scripts/test-question-driven-init.sh
- scripts/test-risk-assessment.sh
- scripts/test-v33-green-parallelization.sh

## Environment

### Scope
- Layer: Maintenance
- Risk: 10 (PASS)

## Test List

### TODO
- [ ] TC-01: install-mcp.sh does not exist
- [ ] TC-02: test-git-conventions-template.sh does not exist
- [ ] TC-03: test-git-safety-template.sh does not exist
- [ ] TC-04: test-phase4-adjustments.sh does not exist
- [ ] TC-05: test-question-driven-init.sh does not exist
- [ ] TC-06: test-risk-assessment.sh does not exist
- [ ] TC-07: test-v33-green-parallelization.sh does not exist
- [ ] TC-08: All remaining test scripts pass

## Progress Log

### 2026-01-26 14:00 - INIT
- Cycle doc created
- 7 files to delete
- Risk: 10 (PASS)

---

## Next Steps

1. [Done] INIT
2. [Next] PLAN
3. [ ] RED
4. [ ] GREEN
5. [ ] REFACTOR
6. [ ] REVIEW
7. [ ] COMMIT
