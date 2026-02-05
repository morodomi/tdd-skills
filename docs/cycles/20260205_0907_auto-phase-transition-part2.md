# Cycle: auto-phase-transition-part2

## Meta

| 項目 | 値 |
|------|-----|
| Created | 2026-02-05 09:07 |
| Issue | #42 |
| Phase | DONE |
| Risk | 30 (WARN) |

## Environment

| 項目 | 値 |
|------|-----|
| OS | macOS (Darwin 25.2.0) |
| Bash | 3.2.57 |
| Project | tdd-skills |

## Goal

TDDフェーズ自動連携の実装（Part 2: RED → GREEN → REFACTOR → REVIEW → COMMIT）

Issue #42の残タスクを完了し、人間の介入を2箇所（設計OK、品質OK）に集約する。

## Scope

- tdd-red: 完了後tdd-green自動実行
- tdd-green: 完了後tdd-refactor自動実行
- tdd-refactor: 完了後tdd-review自動実行
- tdd-review: quality-gate実行後、結果表示して終了（手動判断）
- tdd-onboard: allowedTools設定の推奨を追加
- **Part 1修正**: plan-reviewのtdd-red自動実行を削除

## Out of Scope

- Part 1（完了済み）: INIT → PLAN → plan-review → RED
- Issue #43: SKILL.md言語・形式の統一

## Decisions

- 一括実装: 4スキル + tdd-onboard を1サイクルで変更
- Part 1と同じパターンを適用（Skillツール呼び出し追加）
- **人間介入ポイント（常に手動判断）**:
  - plan-review完了時: PASS/WARN/BLOCKすべて手動判断
  - quality-gate完了時: PASS/WARN/BLOCKすべて手動判断
- tdd-review: quality-gate実行後、結果表示して終了（tdd-commit自動実行しない）
- Part 1修正: plan-reviewのtdd-red自動実行を削除する必要あり

## PLAN

### 背景

Issue #42のPart 2。人間の介入を2箇所に集約するため、RED以降のフェーズ連携を自動化。

### 設計方針

1. 自動連携: RED → GREEN → REFACTOR → REVIEW の流れを自動化
2. 人間介入ポイント: plan-review完了時とquality-gate完了時は常に手動判断
3. tdd-onboard: allowedTools推奨設定を追加
4. Part 1修正: plan-reviewのtdd-red自動実行を削除

### 変更ファイル

| ファイル | 変更内容 |
|----------|----------|
| plugins/tdd-core/skills/tdd-red/SKILL.md | Step 6: tdd-green自動実行 |
| plugins/tdd-core/skills/tdd-green/SKILL.md | Step 6: tdd-refactor自動実行 |
| plugins/tdd-core/skills/tdd-refactor/SKILL.md | Step 5: tdd-review自動実行 |
| plugins/tdd-core/skills/tdd-review/SKILL.md | 変更なし（手動判断を維持） |
| plugins/tdd-core/skills/tdd-onboard/SKILL.md | Step 6: allowedTools推奨追加 |
| plugins/tdd-core/skills/plan-review/SKILL.md | Step 4 PASS: tdd-red自動実行を削除 |

## Test List

### DONE
- [x] TC-01: tdd-red Step 6 に tdd-green 自動実行の記述があること
- [x] TC-02: tdd-green Step 6 に tdd-refactor 自動実行の記述があること
- [x] TC-03: tdd-refactor Step 5 に tdd-review 自動実行の記述があること
- [x] TC-04: tdd-review Step 6 が手動判断を維持していること（tdd-commit自動実行がないこと）
- [x] TC-05: plan-review Step 4 PASS が手動判断になっていること（tdd-red自動実行がないこと）
- [x] TC-06: tdd-onboard に allowedTools 推奨設定の記述があること
- [x] TC-07: 各SKILL.mdが100行以下であること
- [x] TC-08: scripts/test-plugins-structure.sh が通ること

## Progress

| Phase | Status | Notes |
|-------|--------|-------|
| INIT | Done | Cycle doc created |
| PLAN | Done | Test List 8 cases |
| RED | Done | 5 tests failing (TC-01~03,05,06) |
| GREEN | Done | All 8 tests passed |
| REFACTOR | Done | Progress Checklists updated |
| REVIEW | Done | quality-gate PASS (max 35) |
| COMMIT | Done | |
