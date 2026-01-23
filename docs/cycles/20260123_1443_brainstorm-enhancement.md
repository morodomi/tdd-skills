---
feature: tdd-core
cycle: 20260123_1443
phase: DONE
created: 2026-01-23 14:43
updated: 2026-01-23 14:43
---

# INIT: 高リスク時のBrainstorm強化

## Scope Definition

### In Scope
- [ ] SKILL.md にBrainstorm質問を追加（BLOCK時）
- [ ] reference.md にBrainstorm質問テンプレート追加
- [ ] reference.ja.md にも同様の追加

### Out of Scope
- PASS/WARN時の変更
- 他フェーズへの影響

### Files to Change (target: 10 or less)
- `plugins/tdd-core/skills/tdd-init/SKILL.md`（編集）
- `plugins/tdd-core/skills/tdd-init/reference.md`（編集）
- `plugins/tdd-core/skills/tdd-init/reference.ja.md`（編集）

## Environment

### Scope
- Layer: Plugin（Claude Code Skills）
- Plugin: tdd-core
- Risk: 10 (PASS) - ドキュメント変更のみ

### Runtime
- Claude Code Plugin: Markdown

### Dependencies (key packages)
- superpowers参考: Brainstormingフェーズ

## Context & Dependencies

### Reference Documents
- [superpowers/brainstorming](https://github.com/obra/superpowers/blob/main/skills/brainstorming/SKILL.md)

### Related Issues/PRs
- Issue #33: INIT: 高リスク時のBrainstorm強化

## Test List

### TODO
(none)

### WIP
(none)

### DISCOVERED
(none)

### DONE
- [x] TC-01: SKILL.md にBrainstorm質問への言及がある
- [x] TC-02: reference.md にBrainstorm質問テンプレートがある
- [x] TC-03: reference.ja.md にBrainstorm質問テンプレートがある
- [x] TC-04: 「本当に解決したい問題」の質問がある
- [x] TC-05: SKILL.md が100行以下

## Implementation Notes

### Goal
高リスク（BLOCK）時に「本当に何がしたいか」を深掘りする質問を追加。

### Background
v3.0.0でリスクタイプ別質問（認証方式、API認証等）を追加したが、
「そもそも何を解決したいのか」の深掘りが弱い。
superpowersのBrainstormフェーズを参考に強化。

### Design Approach
1. Step 4.6（リスクタイプ別質問）の前にBrainstorm質問を追加
2. 質問: 問題の本質、代替アプローチ、最小検証
3. reference.md/reference.ja.md にテンプレート追加

## Progress Log

### 2026-01-23 14:43 - INIT
- Cycle doc作成
- Issue #33 に対応
- Risk: 10 (PASS)

---

## Next Steps

1. [Done] INIT
2. [Done] PLAN
3. [Done] RED
4. [Done] GREEN
5. [Done] REFACTOR
6. [Done] REVIEW
7. [Done] COMMIT
