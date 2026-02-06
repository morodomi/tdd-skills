---
feature: plan-review
cycle: plan-review-agent-teams
phase: DONE
created: 2026-02-07 01:30
updated: 2026-02-07
---

# Plan Review Agent Teams対応

## Scope Definition

### In Scope
- [ ] plan-review/SKILL.md に `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` env var 分岐追加
- [ ] plan-review/steps-teams.md 新規作成（討論型手順、quality-gate踏襲）
- [ ] plan-review/steps-subagent.md 新規作成（既存の並行手順を抽出）

### Out of Scope
- tdd-orchestrate (Cycle 3 #49 で対応)
- tdd-init の変更 (Cycle 4 #50 で対応)
- onboard CLAUDE.md テンプレート変更 (Cycle 2 #48 で対応)

### Files to Change (target: 10 or less)
- plugins/tdd-core/skills/plan-review/SKILL.md (edit)
- plugins/tdd-core/skills/plan-review/steps-teams.md (new)
- plugins/tdd-core/skills/plan-review/steps-subagent.md (new)

## Environment

### Scope
- Layer: Plugin (Claude Code Plugin skill definition)
- Plugin: tdd-core
- Risk: 5 (PASS)

### Runtime
- Bash: 3.2.57
- Claude Code: 2.1.32

### Dependencies (key packages)
- quality-gate/steps-teams.md: 討論パターンの参考
- quality-gate/steps-subagent.md: 並行パターンの参考
- quality-gate/SKILL.md: env var 分岐パターンの参考

## Context & Dependencies

### Reference Documents
- plugins/tdd-core/skills/quality-gate/SKILL.md - env var 分岐パターン
- plugins/tdd-core/skills/quality-gate/steps-teams.md - 討論型手順の参考
- plugins/tdd-core/skills/quality-gate/steps-subagent.md - 並行型手順の参考
- docs/20260206_design_v5_pdm_delegation.md - v5.0 設計ドキュメント

### Dependent Features
- plan-review: plugins/tdd-core/skills/plan-review/SKILL.md (既存、編集対象)
- quality-gate: plugins/tdd-core/skills/quality-gate/ (パターン参考)

### Related Issues/PRs
- Issue #47: feat: plan-review Agent Teams対応（討論型レビュー）

## Test List

### TODO
(none)

### WIP
(none)

### DISCOVERED
- [x] TC-14: 既存テスト TC-02b3, TC-02b7 を SKILL.md 単体 → ディレクトリ再帰検索に修正（steps-*.md 分離に伴う）

### DONE
- [x] TC-01: SKILL.md が env var 分岐を含む（`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` チェック）
- [x] TC-02: SKILL.md が有効時 steps-teams.md、無効時 steps-subagent.md を参照
- [x] TC-03: SKILL.md が 72行（<= 100）
- [x] TC-04: SKILL.md が Progress Checklist を含む
- [x] TC-05: steps-teams.md が Team作成・Teammate起動・討論・合議判定・Cleanupを含む
- [x] TC-06: steps-teams.md が Fallback（失敗時 subagent 切替 + 具体的メッセージ）を含む
- [x] TC-07: steps-teams.md のレビュアーが5名（scope/architecture/risk/product/usability）
- [x] TC-08: steps-teams.md が討論収束条件（新規指摘なし or ラウンド上限）を明示
- [x] TC-09: steps-subagent.md が5エージェント並行起動を含む
- [x] TC-10: steps-subagent.md のレビュアーが5名（scope/architecture/risk/product/usability）
- [x] TC-11: steps-subagent.md が JSON 出力形式を含む
- [x] TC-12: SKILL.md の Progress Checklist がモード非依存表現（「レビュー実行（モード自動選択）」等）
- [x] TC-13: scripts/test-plugins-structure.sh 102 passed, 0 failed
- [x] TC-14: 既存テスト TC-02b3, TC-02b7 をディレクトリ再帰検索に修正

## Implementation Notes

### Goal
plan-review に quality-gate と同じ Agent Teams 対応を追加。
env var 有効時は5 reviewer が Teammate として討論型レビュー、
無効時は既存の Subagent 並行レビューを実施。

### Background

quality-gate は v4.3.0 で Agent Teams 対応済み（steps-teams.md / steps-subagent.md 分岐）。
plan-review は現在 Subagent 並行のみ。同パターンを適用して討論型レビューを可能にする。

### Design Approach

**方針: quality-gate パターンの plan-review 適用**

#### SKILL.md 変更

既存の Step 2 を env var 分岐に変更:

```
Step 2: レビュー実行

CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS 環境変数でモードを選択:

| 環境変数 | モード | 手順 |
|----------|--------|------|
| 有効 (1) | 討論型 (Agent Teams) | steps-teams.md |
| 無効 / 未設定 | 並行型 (Subagent) | steps-subagent.md |
```

#### steps-teams.md（新規）

quality-gate/steps-teams.md を踏襲:
- Phase 1: Team 作成 (`plan-review-team`)
- Phase 2: 5 Reviewer Teammate 起動
- Phase 3: Independent Review
- Phase 4: Debate (討論)
- Phase 5: Lead Synthesis (合議判定)
- Phase 6: Team Cleanup
- Fallback: 失敗時 subagent 切替

差分:
- チーム名: `plan-review-team` (quality-gate は `quality-gate-review`)
- レビュアー5名: scope/architecture/risk/product/usability
  (quality-gate は6名: correctness/performance/security/guidelines/product/usability)
- 渡す情報: Cycle doc の PLAN セクション（設計方針、Test List、変更予定ファイル）
  (quality-gate は対象ファイル一覧 + 言語プラグイン情報)

#### steps-subagent.md（新規）

既存 SKILL.md の Step 2 手順を**忠実に抽出**（rewriteではなくextract）:
- 5エージェント並行起動
- JSON 出力形式
- 結果収集

#### 5名の選定理由

PLANフェーズは設計レビューのため、コードレビュー固有の観点（correctness, performance, security, guidelines）をスコープ・アーキテクチャ・リスクの設計観点に置換。product/usability は共通。

## Progress Log

### 2026-02-07 01:30 - INIT
- Cycle doc created
- Issue #47 から要件把握
- Risk: 5 (PASS) - quality-gate の既存パターン踏襲、スコープ小
- Files: 3 (1 edit, 2 new)

### 2026-02-07 01:30 - PLAN
- quality-gate パターンの差分を整理
- Test List: 11 cases
- 設計: SKILL.md env var分岐 + steps-teams.md 討論型 + steps-subagent.md 並行型

### 2026-02-07 01:30 - plan-review
- Score: 52 (WARN) - usability-reviewer
- 反映:
  - TC-08 追加: 討論収束条件の検証
  - TC-12 追加: Progress Checklist モード非依存表現
  - TC番号リナンバリング (TC-08〜TC-13)
  - steps-subagent.md: 忠実な抽出である旨を明記
  - 5名の選定理由を追記
  - Fallback に具体的メッセージ要件を追加
- 見送り: reference.md 更新（既存の不整合であり本サイクルのスコープ外）

### 2026-02-07 - RED
- TC-PR-01〜TC-PR-12 を scripts/test-plugins-structure.sh に追加
- 結果: 92 passed, 10 failed (RED状態確認)
- PASS済み: TC-PR-03 (100行以下), TC-PR-04 (Progress Checklist) - 既存SKILL.mdで充足
- FAIL: TC-PR-01,02,05,06,07,08,09,10,11,12 - 実装ファイル未作成のため期待通り

### 2026-02-07 - GREEN
- SKILL.md: env var 分岐追加、Progress Checklist モード非依存化 (72行)
- steps-teams.md: 新規作成（6 Phase + Fallback、quality-gate パターン踏襲）
- steps-subagent.md: 新規作成（既存 Step 2 の忠実な抽出）
- DISCOVERED: TC-14 既存テスト TC-02b3, TC-02b7 をディレクトリ再帰検索に修正
- 結果: 102 passed, 0 failed (GREEN状態確認)

### 2026-02-07 - REVIEW
- quality-gate: PASS (max 45)
  - correctness: 45, performance: 28, security: 15, guidelines: 15, product: 28, usability: 38
- 指摘事項: reference.md 既存不整合（スコープ外）、minor な最適化機会のみ
- テスト: 102 passed, 0 failed

---

## Next Steps

1. [Done] INIT
2. [Done] PLAN
3. [Done] plan-review (WARN 52 → 修正反映済み)
4. [Done] RED (92 passed, 10 failed)
5. [Done] GREEN (102 passed, 0 failed)
6. [Done] REFACTOR (リファクタ不要、パターン一貫性確認済み)
7. [Done] REVIEW (quality-gate PASS 45, 102 passed)
8. [Done] COMMIT
