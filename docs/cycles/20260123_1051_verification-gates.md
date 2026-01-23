---
feature: tdd-core
cycle: 20260123_1051
phase: DONE
created: 2026-01-23 10:51
updated: 2026-01-23 10:51
---

# Verification Gates

## Scope Definition

### 今回実装する範囲
- [ ] PLAN承認後の自動進行ワークフロー
- [ ] Verification Gate（内部チェック、ユーザー承認不要）
- [ ] REVIEW時のquality-gate自動実行
- [ ] COMMIT前のユーザー承認ポイント

### 今回実装しない範囲
- Phase 4: 微調整・フィードバック反映（別Issue #29）

### 変更予定ファイル（目安: 10以下）
- `plugins/tdd-core/skills/tdd-plan/SKILL.md`（編集）- 自動進行トリガー
- `plugins/tdd-core/skills/tdd-red/SKILL.md`（編集）- Gate追加
- `plugins/tdd-core/skills/tdd-green/SKILL.md`（編集）- Gate追加
- `plugins/tdd-core/skills/tdd-refactor/SKILL.md`（編集）- Gate追加
- `plugins/tdd-core/skills/tdd-review/SKILL.md`（編集）- quality-gate自動実行

## Environment

### Scope
- Layer: Plugin（Claude Code Skills）
- Plugin: tdd-core
- Risk: 30 (WARN)

### Runtime
- Claude Code Plugin: Markdown + Bash

### Dependencies（主要）
- Phase 1（#28）: tdd-init リスク判定（完了済み）
- Phase 2（#30）: tdd-plan リスク連動（完了済み）

## Context & Dependencies

### 参照ドキュメント
- [AgentSkills/docs/20250122_tdd-skills-evolution.md] - 設計元

### 依存する既存機能
- tdd-red: 現行SKILL.md
- tdd-green: 現行SKILL.md
- tdd-refactor: 現行SKILL.md

### 関連Issue/PR
- Issue #31: Verification Gates（Phase 3）

## Test List

### TODO
（なし）

### WIP
（なし）

### DISCOVERED
（なし）

### DONE
- [x] TC-01: tdd-plan完了時に自動進行を案内する記述がある
- [x] TC-02: tdd-red/green/refactorにVerification Gate記述がある
- [x] TC-03: tdd-reviewにquality-gate自動実行の記述がある
- [x] TC-04: tdd-reviewにCOMMIT承認ポイントの記述がある
- [x] TC-05: 各SKILL.mdが100行以下

## Implementation Notes

### やりたいこと
PLAN承認後、RED→GREEN→REFACTOR→REVIEWを自動進行させ、開発スピードを向上させる。

### 背景
現行フローはフェーズごとにユーザー承認が必要で、開発スピードが遅くなる。Verification Gateを内部チェックとして使い、自動進行させることで効率化する。

### 設計方針

#### ワークフロー変更
```
現行: PLAN → [承認] → RED → [承認] → GREEN → [承認] → REFACTOR → [承認] → REVIEW → [承認] → COMMIT
改善: PLAN → [承認] → RED → GREEN → REFACTOR → REVIEW（quality-gate） → [承認] → COMMIT
```

#### tdd-plan: 自動進行トリガー
```
PLAN完了後、ユーザー承認を得たら自動的にRED→GREEN→REFACTOR→REVIEWを実行。
```

#### Verification Gate（内部チェック）
各フェーズ完了時に自己チェック。失敗時は自動修正を試み、解決不能な場合のみユーザーに報告。

| Phase | Gate条件 | 失敗時 |
|-------|---------|--------|
| RED | テスト失敗 | 実装コード削除して再試行 |
| GREEN | テスト成功 | 実装修正して再試行 |
| REFACTOR | テスト+静的解析+フォーマット | 修正して再試行 |

#### tdd-review: quality-gate自動実行
REVIEWフェーズでquality-gateを自動実行し、結果を表示。COMMIT承認はユーザー判断。

## Progress Log

### 2026-01-23 10:51 - INIT
- Cycle doc作成
- Issue #31からスコープ定義
- リスクスコア: 30 (WARN)

### 2026-01-23 10:55 - PLAN
- 設計方針決定: Verification Gateセクション追加
- 行数余裕確認: tdd-red +9, tdd-green +31, tdd-refactor +27

### 2026-01-23 11:00 - PLAN（スコープ変更）
- 自動進行ワークフローに変更
- 5ファイル変更: tdd-plan, tdd-red, tdd-green, tdd-refactor, tdd-review
- Test List更新: 5ケース

### 2026-01-23 11:05 - RED
- テストスクリプト作成: scripts/test-verification-gates.sh
- テスト実行: 6 passed, 5 failed（期待通りのRED状態）
- TC-03, TC-05は既存で通過

### 2026-01-23 11:10 - GREEN
- tdd-plan: Step 7を自動進行に変更
- tdd-red/green/refactor: Verification Gate追加
- tdd-review: COMMIT承認ポイント追加
- テスト: 73 passed (11 + 8 + 7 + 47)

### 2026-01-23 11:15 - REFACTOR
- 構造確認: Verification Gate形式は意図的差異（二値 vs 複数チェック）
- 行数確認: 全て100行以下（最大 tdd-red 98行）
- テスト: 73 passed（変化なし）

### 2026-01-23 11:20 - REVIEW
- テスト: 73 passed
- quality-gate: PASS（最大スコア42）
  - correctness: 42（important 2件、optional 3件）
  - performance: 25（optional 2件）
  - security: 25（optional 3件）
  - guidelines: 25（optional 3件）

### 2026-01-23 11:25 - COMMIT
- コミット: 482509a
- Issue #31 クローズ

---

## 次のステップ

1. [完了] INIT
2. [完了] PLAN
3. [完了] RED
4. [完了] GREEN
5. [完了] REFACTOR
6. [完了] REVIEW
7. [完了] COMMIT
4. [ ] GREEN
5. [ ] REFACTOR
6. [ ] REVIEW
7. [ ] COMMIT
