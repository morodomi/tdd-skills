# Cycle: auto-phase-transition-part1

## Meta

| 項目 | 値 |
|------|-----|
| Created | 2026-02-04 23:56 |
| Issue | #42 |
| Phase | DONE |
| Risk | 55 (WARN) |

## Environment

| 項目 | 値 |
|------|-----|
| OS | macOS (Darwin 25.2.0) |
| Bash | 3.2.57 |
| Project | tdd-skills |

## Goal

TDDフェーズ自動連携の実装（Part 1: INIT → PLAN → RED）

人間の介入を2箇所（設計OK、品質OK）に集約し、TDDワークフローをスムーズにする。

## Scope

- tdd-init: Step 7でtdd-plan自動実行を追加
- tdd-plan: Step 6のplan-review「推奨」を「必須・自動実行」に変更
- plan-review: OK判定後のtdd-red自動実行を明確化
- allowedToolsにSkill追加可能かの調査

## Out of Scope (Part 2)

- tdd-red: 完了後tdd-green自動実行
- tdd-green: 完了後tdd-refactor自動実行
- tdd-refactor: 完了後tdd-review自動実行
- tdd-review: OK判定後tdd-commit自動実行

## Decisions

- 分割実装: Part 1 (INIT-PLAN-RED連携) → Part 2 (GREEN-REFACTOR-REVIEW-COMMIT連携)
- 実装前にallowedTools調査を実施 → 完了: `Skill(tdd-core:*)` 形式で許可可能
- 手動実行オプションは維持（自動連携は追加機能）
- tdd-plan Step 7: 「削除」ではなく「plan-review必須実行に変更」

## PLAN

### 背景

Issue #42の要件: 人間の介入を2箇所（設計OK、品質OK）に集約。
Part 1では INIT → PLAN → plan-review → RED の自動連携を実装。

### 設計方針

1. 各スキルの最終ステップに `Skill` ツール呼び出しを追加
2. allowedToolsは `Skill(tdd-core:*)` 形式で許可可能（調査済み）
3. plan-reviewでの人間介入ポイントは維持（PASS/WARN/BLOCK判定）

### 変更ファイル

| ファイル | 変更内容 |
|----------|----------|
| plugins/tdd-core/skills/tdd-init/SKILL.md | Step 7: tdd-plan自動実行追加 |
| plugins/tdd-core/skills/tdd-plan/SKILL.md | Step 6: plan-review必須化、Step 7削除 |
| plugins/tdd-core/skills/plan-review/SKILL.md | Step 4 PASS: tdd-red自動実行明確化 |

### allowedTools推奨設定

```json
{
  "permissions": {
    "allow": ["Skill(tdd-core:*)"]
  }
}
```

## Test List

### DONE
- [x] TC-01: tdd-init Step 7 に tdd-plan 自動実行の記述があること
- [x] TC-02: tdd-plan Step 6 が plan-review「必須」になっていること
- [x] TC-03: tdd-plan Step 7 が plan-review 委譲に変更されていること
- [x] TC-04: plan-review Step 4 PASS に tdd-red 自動実行の記述があること
- [x] TC-05: 各SKILL.mdが100行以下であること（品質基準）
- [x] TC-06: scripts/test-plugins-structure.sh が通ること

## Progress

| Phase | Status | Notes |
|-------|--------|-------|
| INIT | Done | Cycle doc created |
| PLAN | Done | Test List defined |
| RED | Done | 4 tests failing (TC-01~04) |
| GREEN | Done | All 6 tests passed |
| REFACTOR | Done | Progress Checklist updated, removed obsolete restriction |
| REVIEW | Done | quality-gate PASS (max 42) |
| COMMIT | Done | |

## Next Steps

- Part 2: GREEN → REFACTOR → REVIEW → COMMIT の自動連携（Issue #42の残タスク）
