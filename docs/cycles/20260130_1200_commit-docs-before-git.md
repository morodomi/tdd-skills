---
feature: commit-docs-before-git
cycle: 20260130_1200
phase: DONE
created: 2026-01-30 12:00
updated: 2026-01-30 12:00
---

# Update tdd-commit: docs before git commit

## Scope Definition

### In Scope
- [ ] tdd-commit/SKILL.mdのWorkflow順序を変更（ドキュメント更新をgit commitの前に移動）
- [ ] Progress Checklistの順序も合わせて変更

### Out of Scope
- reference.mdの変更 (Reason: SKILL.mdで十分)
- tdd-commit以外のスキル変更 (Reason: 別スコープ)

### Files to Change (target: 10 or less)
- plugins/tdd-core/skills/tdd-commit/SKILL.md (edit)

## Environment

### Scope
- Layer: N/A (documentation only)
- Plugin: N/A
- Risk: 10 (PASS)

### Runtime
- Bash 3.2.57

### Dependencies (key packages)
- None

## Context & Dependencies

### Related Issues/PRs
- Issue #39: tdd-commitでドキュメント更新をコミット前に移動

## Test List

### TODO
(none)

### WIP
(none)

### DISCOVERED
(none)

### DONE
- [x] TC-01: tdd-commit/SKILL.mdでCycle doc更新がgit commitより前のStepであること
- [x] TC-02: tdd-commit/SKILL.mdでSTATUS.md更新がgit commitより前のStepであること
- [x] TC-03: Progress Checklistでドキュメント更新がgit add/commitより前にあること
- [x] TC-04: 既存の構造テストがPASSすること

## Implementation Notes

### Goal
tdd-commitでドキュメント更新をgit commitの前に行い、1回のコミットに全変更を含める。

### Background
現在のtdd-commit/SKILL.mdではgit commit(Step 4)の後にCycle doc更新(Step 5)とSTATUS.md更新(Step 6)がある。
このため、先にコミットしてから後でドキュメント更新の別コミットが発生する。

### Design Approach
- Step 3-4をドキュメント更新に変更（Cycle doc, STATUS.md）
- Step 5をコミットメッセージ生成に変更
- Step 6をgit add & commitに変更
- Step 7をサイクル完了に変更
- Progress Checklistも同じ順序に更新

## Progress Log

### 2026-01-30 12:00 - INIT
- Cycle doc created
- 1 file to change

---

## Next Steps

1. [Done] INIT
2. [Done] PLAN
3. [Done] RED
4. [Done] GREEN
5. [Done] REFACTOR
6. [Done] REVIEW
7. [Done] COMMIT <- Current
3. [ ] RED
4. [ ] GREEN
5. [ ] REFACTOR
6. [ ] REVIEW
7. [ ] COMMIT
