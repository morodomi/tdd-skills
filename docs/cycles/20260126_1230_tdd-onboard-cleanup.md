---
feature: tdd-onboard
cycle: tdd-onboard-cleanup
phase: DONE
created: 2026-01-26 12:30
updated: 2026-01-26 12:30
---

# tdd-onboard Cleanup

## Scope Definition

### In Scope
- [ ] Remove unused rule templates from reference.md Step 6
- [ ] Keep only 3 actual templates (git-safety, security, git-conventions)

### Out of Scope
- Migration guide (issue #26)
- Creating new rule files

### Files to Change (target: 10 or less)
- plugins/tdd-core/skills/tdd-onboard/reference.md (edit)

## Environment

### Scope
- Layer: Plugin (Markdown documentation)
- Plugin: tdd-onboard
- Risk: 15 (PASS)

### Runtime
- Bash: 3.2.57

### Dependencies (key packages)
- Claude Code Plugin system

### Risk Interview (BLOCK only)
N/A (PASS level)

## Context & Dependencies

### Reference Documents
- .claude/rules/ - Actual rules (3 files)
- Issue #24 cycle - CLAUDE.md template fix

### Dependent Features
- #24 (CLAUDE.mdテンプレート) - CLOSED

### Related Issues/PRs
- Issue #25: feat: tdd-onboard SKILL.md / reference.md 更新
- Parent: Issue #19: tdd-onboard v2.0

## Test List

### DONE
- [x] TC-01: reference.md Step 6 has git-safety.md template
- [x] TC-02: reference.md Step 6 has security.md template
- [x] TC-03: reference.md Step 6 has git-conventions.md template
- [x] TC-04: reference.md Step 6 does NOT have tdd-workflow.md template
- [x] TC-05: reference.md Step 6 does NOT have testing-guide.md template
- [x] TC-06: reference.md Step 6 does NOT have quality.md template
- [x] TC-07: reference.md Step 6 does NOT have commands.md template
- [x] TC-08: reference.md Step 6 section header exists

## Implementation Notes

### Goal
Remove unused rule file templates from reference.md Step 6 to align with actual .claude/rules/ structure.

### Background
Issue #24でCLAUDE.mdテンプレートを修正したが、reference.md Step 6には依然として7ファイル分のテンプレートが存在。
実際の.claude/rules/には3ファイルのみ: git-safety.md, security.md, git-conventions.md

### Design Approach
**対象**: reference.md Step 6 (lines 279-461)

**削除対象テンプレート**:
- tdd-workflow.md (lines 281-305)
- testing-guide.md (lines 307-325)
- quality.md (lines 327-344)
- commands.md (lines 346-370)

**保持対象テンプレート**:
- security.md
- git-safety.md
- git-conventions.md

## Progress Log

### 2026-01-26 12:30 - INIT
- Cycle doc created
- Scope: Remove unused templates from Step 6
- Risk: 15 (PASS)

### 2026-01-26 12:35 - PLAN
- Analyzed reference.md lines 279-461
- Delete: lines 281-370 (4 templates)
- Keep: lines 372-461 (3 templates)
- Test List: 8 test cases

### 2026-01-26 12:40 - RED/GREEN/REFACTOR/REVIEW/COMMIT
- Created test script (8 test cases)
- Removed 4 unused templates (91 lines deleted)
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
