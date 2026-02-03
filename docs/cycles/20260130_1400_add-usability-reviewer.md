---
feature: add-usability-reviewer
cycle: 20260130_1400
phase: DONE
created: 2026-01-30 14:00
updated: 2026-01-30 14:00
---

# Add usability-reviewer agent

## Scope Definition

### In Scope
- [ ] usability-reviewer.mdエージェント定義の新規作成
- [ ] plan-review/SKILL.mdを4→5エージェントに拡張
- [ ] quality-gate/SKILL.mdを5→6エージェントに拡張

### Out of Scope
- 既存エージェントの変更 (Reason: 不要)

### Files to Change (target: 10 or less)
- plugins/tdd-core/agents/usability-reviewer.md (new)
- plugins/tdd-core/skills/plan-review/SKILL.md (edit)
- plugins/tdd-core/skills/quality-gate/SKILL.md (edit)

## Environment

### Scope
- Layer: N/A (documentation/agent definition)
- Plugin: N/A
- Risk: 15 (PASS)

### Runtime
- Bash 3.2.57

### Dependencies (key packages)
- None

## Context & Dependencies

### Related Issues/PRs
- Issue #41: plan-reviewにusability-reviewerエージェントを追加
- Issue #40: product-reviewer追加（完了済み、同パターン）

## Test List

### TODO
(none)

### WIP
(none)

### DISCOVERED
(none)

### DONE
- [x] TC-01: usability-reviewer.mdが存在すること
- [x] TC-02: plan-review/SKILL.mdにusability-reviewerが含まれること
- [x] TC-03: quality-gate/SKILL.mdにusability-reviewerが含まれること
- [x] TC-04: 既存の構造テストがPASSすること

## Implementation Notes

### Goal
デザイナー目線のレビューをplan-reviewとquality-gateに追加し、Marty Caganの4リスクのうちUsabilityをカバーする。

### Background
plan-review/quality-gateにデザイナー目線がない。
Marty Caganの4リスクのうちUsabilityが未カバー。

### Design Approach
- usability-reviewer.mdを既存エージェントと同じフォーマットで作成
- 検証観点: UX/UI、アクセシビリティ、一貫性、ユーザーフロー、エラー体験、状態デザイン
- plan-review: 4→5エージェント、quality-gate: 5→6エージェント
- Nielsen Norman Groupの10ヒューリスティクスを基盤とする

## Progress Log

### 2026-01-30 14:00 - INIT
- Cycle doc created
- 3 files to change
- Same pattern as #40 (product-reviewer)

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
