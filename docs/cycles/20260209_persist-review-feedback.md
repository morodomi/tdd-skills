---
feature: persist-review-feedback
cycle: 20260209_persist-review-feedback
phase: DONE
created: 2026-02-09
updated: 2026-02-09
---

# Persist Review Feedback in Cycle Doc on BLOCK

## Scope Definition

### In Scope
- [ ] plan-review: BLOCK判定時にCycle doc Progress Logへフィードバック追記
- [ ] quality-gate: BLOCK判定時にCycle doc Progress Logへフィードバック追記

### Out of Scope
- PASS/WARN時の記録 (ノイズになる)
- 新ディレクトリ・新ファイル作成
- Cycle docテンプレート変更

### Files to Change (target: 10 or less)
- plugins/tdd-core/skills/plan-review/SKILL.md (edit)
- plugins/tdd-core/skills/quality-gate/SKILL.md (edit)
- scripts/test-persist-review-feedback.sh (new)

## Environment

### Scope
- Layer: Bash scripts only
- Plugin: なし (Markdown + Bash)
- Risk: 30 (WARN)

### Runtime
- Bash 5.x
- Claude Code Plugins

### Dependencies (key packages)
- gh CLI
- git

## Context & Dependencies

### Reference Documents
- Issue #53: feat: persist review feedback in Cycle doc Progress Log on BLOCK

### Dependent Features
- plan-review: plugins/tdd-core/skills/plan-review/
- quality-gate: plugins/tdd-core/skills/quality-gate/

### Related Issues/PRs
- Issue #53: feat: persist review feedback in Cycle doc Progress Log on BLOCK

## Test List

### TODO
(none)

### WIP
(none)

### DISCOVERED
(none)

### DONE
- [x] TC-01: [正常系] plan-review/SKILL.md の BLOCK セクションに Progress Log 追記指示が存在すること
- [x] TC-02: [正常系] quality-gate/SKILL.md の BLOCK セクションに Progress Log 追記指示が存在すること
- [x] TC-03: [正常系] plan-review の BLOCK セクションにフォーマット例が含まれること（日時・フェーズ・スコア・指摘要約）
- [x] TC-04: [正常系] quality-gate の BLOCK セクションにフォーマット例が含まれること
- [x] TC-05: [境界値] PASS/WARN セクションには Progress Log 追記指示が存在しないこと（plan-review）
- [x] TC-06: [境界値] PASS/WARN セクションには Progress Log 追記指示が存在しないこと（quality-gate）
- [x] TC-07: [エッジケース] plan-review の BLOCK フォーマットにフェーズ名 [PLAN] が含まれること
- [x] TC-08: [エッジケース] quality-gate の BLOCK フォーマットにフェーズ名 [REVIEW] が含まれること
- [x] TC-09: [構造] 既存 Plugin 構造テスト (test-plugins-structure.sh) が通ること

## Implementation Notes

### Goal
BLOCK判定時にreviewフィードバックをCycle docのProgress Logに永続化し、再実行時の効率を改善する。

### Background
plan-review (5エージェント) と quality-gate (6エージェント) の BLOCK 判定時、指摘内容が JSON で返されるだけで永続化されない。BLOCK → 再実行時にフィードバックが消え、同じ指摘が繰り返される可能性がある。

### Design Approach
各SKILL.mdのBLOCKセクションに「Cycle doc Progress Logへの追記」指示を追加する。

- plan-review/SKILL.md: Step 4 BLOCKセクションに追記指示
- quality-gate/SKILL.md: Step 5 BLOCKセクションに追記指示
- steps-subagent.mdは変更不要（判定・追記はSKILL.md側の責務）

フォーマット: `- YYYY-MM-DD HH:MM [PHASE] skill-name BLOCK (score NN): reviewer「指摘要約」`

## Progress Log

### 2026-02-09 - INIT
- Cycle doc created
- Scope: plan-review + quality-gate のBLOCK時Progress Log追記

---

## Next Steps

1. [Done] INIT
2. [Done] PLAN
3. [Done] RED
4. [Done] GREEN
5. [Done] REFACTOR
6. [Done] REVIEW
7. [Done] COMMIT <- Current
