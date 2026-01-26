---
feature: tdd-onboard
cycle: migration-guide-update
phase: DONE
created: 2026-01-26 13:00
updated: 2026-01-26 13:00
---

# Migration Guide Update

## Scope Definition

### In Scope
- [ ] Update docs/MIGRATION.md for current 3-file structure
- [ ] Remove references to non-existent files (tdd-workflow, testing-guide, quality, commands)
- [ ] Simplify migration steps

### Out of Scope
- Auto-migration script (future enhancement)
- CHANGELOG update (already done in v4.0.0)

### Files to Change (target: 10 or less)
- docs/MIGRATION.md (edit)

## Environment

### Scope
- Layer: Documentation
- Plugin: tdd-onboard
- Risk: 20 (PASS)

### Runtime
- Bash: 3.2.57

### Dependencies (key packages)
- None (documentation only)

### Risk Interview (BLOCK only)
N/A (PASS level)

## Context & Dependencies

### Reference Documents
- .claude/rules/ - Actual rules (3 files)
- Issue #24, #25 - Previous cleanup cycles

### Dependent Features
- #24 (CLAUDE.mdテンプレート) - CLOSED
- #25 (SKILL.md/reference.md更新) - CLOSED

### Related Issues/PRs
- Issue #26: docs: マイグレーションガイド作成 (v1.x → v2.0)
- Parent: Issue #19: tdd-onboard v2.0

## Test List

### DONE
- [x] TC-01: MIGRATION.md exists
- [x] TC-02: References .claude/rules/ structure
- [x] TC-03: Lists git-safety.md
- [x] TC-04: Lists security.md
- [x] TC-05: Lists git-conventions.md
- [x] TC-06: Does NOT reference tdd-workflow.md in target
- [x] TC-07: Does NOT reference testing-guide.md in target
- [x] TC-08: Does NOT reference quality.md in target
- [x] TC-09: Does NOT reference commands.md in target
- [x] TC-10: Recommends running tdd-onboard

## Implementation Notes

### Goal
Update MIGRATION.md to reflect current 3-file .claude/rules/ structure.

### Background
MIGRATION.md was created before #24/#25 cleanup. It references 7 rule files
but only 3 exist: git-safety.md, security.md, git-conventions.md.

### Design Approach
**Simplify migration**:
1. Remove specific file mapping table (old files → new files)
2. Recommend running `tdd-onboard` to generate new structure
3. Keep only essential steps: create dirs, run onboard, delete old

## Progress Log

### 2026-01-26 13:00 - INIT
- Cycle doc created
- Scope: Update MIGRATION.md for 3-file structure
- Risk: 20 (PASS)

### 2026-01-26 13:05 - PLAN
- Analyzed current MIGRATION.md (114 lines)
- Problem: Step 2 references non-existent target files
- Solution: Simplify to tdd-onboard recommendation
- Test List: 10 test cases

### 2026-01-26 13:10 - RED/GREEN/REFACTOR/REVIEW/COMMIT
- Created test script (10 test cases)
- Rewrote MIGRATION.md with 3-file structure
- quality-gate: PASS (score 25)
- All tests passed

---

## Next Steps

1. [Done] INIT
2. [Done] PLAN
3. [Done] RED
4. [Done] GREEN
5. [Done] REFACTOR
6. [Done] REVIEW
7. [Done] COMMIT
