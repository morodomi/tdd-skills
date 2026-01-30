---
feature: add-product-reviewer
cycle: 20260130_1300
phase: DONE
created: 2026-01-30 13:00
updated: 2026-01-30 13:00
---

# Add product-reviewer agent

## Scope Definition

### In Scope
- [ ] product-reviewer.mdエージェント定義の新規作成
- [ ] plan-review/SKILL.mdを3→4エージェントに拡張
- [ ] quality-gate/SKILL.mdを4→5エージェントに拡張
- [ ] risk-reviewerからビジネス影響観点を削除し技術リスクに特化

### Out of Scope
- usability-reviewer追加 (Reason: #41で対応)
- 既存エージェントの大幅な書き換え (Reason: 最小限の変更)

### Files to Change (target: 10 or less)
- plugins/tdd-core/agents/product-reviewer.md (new)
- plugins/tdd-core/agents/risk-reviewer.md (edit)
- plugins/tdd-core/skills/plan-review/SKILL.md (edit)
- plugins/tdd-core/skills/quality-gate/SKILL.md (edit)

## Environment

### Scope
- Layer: N/A (documentation/agent definition)
- Plugin: N/A
- Risk: 35 (WARN)

### Runtime
- Bash 3.2.57

### Dependencies (key packages)
- None

## Context & Dependencies

### Related Issues/PRs
- Issue #40: plan-reviewにproduct-reviewerエージェントを追加

### Design Decisions
- product-reviewerはplan-reviewとquality-gateの両方で使用
- ビジネス影響観点はproduct-reviewerに集約、risk-reviewerは技術リスク特化

## Test List

### TODO
(none)

### WIP
(none)

### DISCOVERED
(none)

### DONE
- [x] TC-01: product-reviewer.mdが存在すること
- [x] TC-02: plan-review/SKILL.mdにproduct-reviewerが含まれること
- [x] TC-03: quality-gate/SKILL.mdにproduct-reviewerが含まれること
- [x] TC-04: risk-reviewer.mdからビジネス影響観点が削除されていること
- [x] TC-05: 既存の構造テストがPASSすること

## Implementation Notes

### Goal
PdM目線のレビューをplan-reviewとquality-gateに追加し、Marty Caganの4リスク（Value, Usability, Feasibility, Viability）のうちValue/Viabilityをカバーする。

### Background
plan-reviewは3エージェント(scope, architecture, risk)でエンジニア目線のみ。
Marty Caganの4リスク(Value, Usability, Feasibility, Viability)のうちFeasibilityのみカバー。
PdM目線(Value, Viability)が欠如している。

### Design Approach
- product-reviewer.mdを既存エージェント(correctness-reviewer.md等)と同じフォーマットで作成
- 検証観点: ユーザー価値、ビジネスインパクト、コスト妥当性、優先度/ROI、受入条件、ステークホルダー影響
- plan-review: 3→4エージェント、quality-gate: 4→5エージェント
- risk-reviewer: descriptionと検証観点からビジネス影響を削除し技術リスクに特化

## Progress Log

### 2026-01-30 13:00 - INIT
- Cycle doc created
- 4 files to change
- WARN questions answered: both plan-review + quality-gate, consolidate to product-reviewer

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
