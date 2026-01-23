---
feature: tdd-core
cycle: 20260123_1440
phase: DONE
created: 2026-01-23 14:40
updated: 2026-01-23 14:40
---

# PLAN: タスク粒度の明確化（2-5分基準）

## Scope Definition

### In Scope
- [ ] SKILL.md に2-5分タスク粒度のガイダンス追加
- [ ] reference.md にタスク分割の詳細基準追加

### Out of Scope
- Test Listのフォーマット変更
- 他スキルへの影響

### Files to Change (target: 10 or less)
- `plugins/tdd-core/skills/tdd-plan/SKILL.md`（編集）
- `plugins/tdd-core/skills/tdd-plan/reference.md`（編集）

## Environment

### Scope
- Layer: Plugin（Claude Code Skills）
- Plugin: tdd-core
- Risk: 10 (PASS) - ドキュメント変更のみ

### Runtime
- Claude Code Plugin: Markdown

### Dependencies (key packages)
- superpowers参考: 2-5分タスク粒度

## Context & Dependencies

### Reference Documents
- [superpowers/writing-plans](https://github.com/obra/superpowers/blob/main/skills/writing-plans/SKILL.md)

### Related Issues/PRs
- Issue #32: PLAN: タスク粒度の明確化（2-5分基準）

## Test List

### TODO
- [ ] TC-01: SKILL.md に「2-5分」の基準が記載されている
- [ ] TC-02: SKILL.md にタスク分割の促しが記載されている
- [ ] TC-03: reference.md にタスク粒度の詳細説明がある
- [ ] TC-04: reference.md に具体例がある
- [ ] TC-05: SKILL.md が100行以下

### WIP
(none)

### DISCOVERED
(none)

### DONE
(none)

## Implementation Notes

### Goal
Test Listの各タスクを「2-5分で完了する1アクション」に分割する基準を追加する。

### Background
superpowersの「2-5分タスク粒度」アプローチを参考に、PLANフェーズのタスク分割を改善。
大きすぎるタスクが混在すると、AIが推測で補完しやすくなる。

### Design Approach
1. SKILL.md Step 5に粒度基準を追加
2. reference.mdにタスク分割の詳細ルールを追加
3. 具体例を提示

## Progress Log

### 2026-01-23 14:40 - INIT
- Cycle doc作成
- Issue #32 に対応
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
