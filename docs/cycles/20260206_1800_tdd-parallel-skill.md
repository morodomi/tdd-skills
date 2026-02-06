---
feature: tdd-parallel
cycle: tdd-parallel-skill
phase: DONE
created: 2026-02-06 18:00
updated: 2026-02-06 18:00
---

# TDD Parallel Skill

## Scope Definition

### In Scope
- [ ] tdd-parallel/SKILL.md 新規作成（< 100行）
- [ ] tdd-parallel/reference.md 新規作成
- [ ] tdd-parallel/steps-teams.md 新規作成（Agent Teams オーケストレーション手順）
- [ ] tdd-plan/SKILL.md 編集（レイヤー検出時の tdd-parallel 自動提案追加）
- [ ] CLAUDE.md 編集（Skills table に tdd-parallel 追加）

### Out of Scope
- tdd-red / tdd-green / tdd-refactor の変更（既存をラップするのみ）
- Contract Freeze Checkpoint（Phase 2 で対応）
- ROI 計測機能（Phase 2 で対応）

### Files to Change (target: 10 or less)
- plugins/tdd-core/skills/tdd-parallel/SKILL.md (new)
- plugins/tdd-core/skills/tdd-parallel/reference.md (new)
- plugins/tdd-core/skills/tdd-parallel/steps-teams.md (new)
- plugins/tdd-core/skills/tdd-plan/SKILL.md (edit)
- plugins/tdd-core/skills/tdd-plan/reference.md (edit)
- CLAUDE.md (edit)

## Environment

### Scope
- Layer: Plugin (Claude Code Plugin skill definition)
- Plugin: tdd-core
- Risk: 5 (PASS)

### Runtime
- Bash: 3.2.57
- Claude Code: 2.1.32

### Dependencies (key packages)
- Claude Code Agent Teams: experimental (CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS)
- tdd-red, tdd-green, tdd-refactor: 各 Teammate がラップ実行
- quality-gate steps-teams.md, tdd-diagnose steps-teams.md: 参考パターン

## Context & Dependencies

### Reference Documents
- plugins/tdd-core/skills/quality-gate/SKILL.md - 環境変数分岐の参考
- plugins/tdd-core/skills/quality-gate/steps-teams.md - Agent Teams 討論パターンの参考
- plugins/tdd-core/skills/tdd-diagnose/SKILL.md - auto-transition の参考
- plugins/tdd-core/skills/tdd-diagnose/steps-teams.md - Teams 調査パターンの参考
- docs/cycles/20260206_1400_quality-gate-agent-teams.md - #44 実装の参考
- docs/cycles/20260206_1600_tdd-diagnose-skill.md - #45 実装の参考

### Dependent Features
- tdd-plan: plugins/tdd-core/skills/tdd-plan/SKILL.md (auto-transition 追加先)
- tdd-red, tdd-green, tdd-refactor: 各 Teammate が Skill() で実行
- quality-gate, tdd-diagnose: Agent Teams パターンの既存実装

### Related Issues/PRs
- Issue #46: feat: tdd-parallel - cross-layer parallel development orchestrator

## Test List

### TODO
(none)

### WIP
(none)

### DISCOVERED
(none)

### DONE
- [x] TC-01: tdd-parallel/SKILL.md が存在し 93行（<= 100）
- [x] TC-02: SKILL.md が CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS チェック + 無効時フォールバック
- [x] TC-03: SKILL.md が Progress Checklist を含む
- [x] TC-04: SKILL.md が Architecture Note（合成パターン）を含む
- [x] TC-05: SKILL.md が When to Use セクションを含む
- [x] TC-06: SKILL.md が統合テスト実行ステップを含む
- [x] TC-07: steps-teams.md が Team作成・Teammate起動・ファイル競合チェック・統合テストを含む
- [x] TC-08: steps-teams.md が Fallback + 具体的 next action を含む
- [x] TC-09: reference.md がレイヤー分割ガイド・Why Agent Teams Only・2-4推奨を含む
- [x] TC-10: tdd-plan/SKILL.md がレイヤー検出 tdd-parallel 提案（env var チェック付き）を含む
- [x] TC-11: tdd-plan/SKILL.md が 97行（<= 100）を維持
- [x] TC-12: CLAUDE.md Skills table に tdd-parallel が登録済み
- [x] TC-13: scripts/test-plugins-structure.sh 90 passed, 0 failed

## Implementation Notes

### Goal
クロスレイヤー（Frontend/Backend/DB等）の大規模機能を、Agent Teams でレイヤー別に並列開発するオーケストレータスキル tdd-parallel を作成する。PLAN フェーズからの自動提案も含む。

### Background

現在の tdd-red/tdd-green は「同一ファイル=同一ワーカー」で Subagent 並列化しているが、
ワーカー間通信ができない。クロスレイヤー機能で API 契約が変更された場合、
他レイヤーへの即時通知ができず、逐次処理に戻る。

Agent Teams (#44 quality-gate, #45 tdd-diagnose) でチーム間メッセージングパターンを確立済み。
同パターンを開発フェーズに適用し、レイヤー別並列開発を実現する。

### Design Approach

**方針: 既存スキルをラップする新オーケストレータ + tdd-plan への最小統合**

#### Architecture Note

このスキルは例外的に複数フェーズ(RED/GREEN/REFACTOR)をまたぐが、
内部では既存の単一フェーズ Skill(tdd-red, tdd-green, tdd-refactor) を
Teammate が順次実行する。7フェーズモデル自体は維持される。

#### SKILL.md のフロー (< 100行)

```
Architecture Note: 合成パターン（複数フェーズラップ）の位置づけ明記

When to Use:
  - 推奨: 3+ レイヤー、API契約変更あり
  - 非推奨: 単一レイヤー、2ファイル以下

Step 1: Agent Teams 確認
  - CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS チェック
  - 有効 → Step 2 へ
  - 無効 → 「Agent Teams が必要です。Skill(tdd-core:tdd-red) を
    個別実行してください。」と表示して終了

Step 2: レイヤー定義確認
  - Cycle doc から In Scope のレイヤー情報を読取
  - レイヤーごとのファイル・テスト範囲を整理

Step 3: 並列開発実行
  - steps-teams.md の手順に従い実行

Step 4: 統合テスト
  - 全レイヤーの GREEN 確認後、全テスト一括実行
  - 失敗時: テスト出力からレイヤー特定 → 該当 Teammate に修正指示

Step 5: 完了 → REVIEW 自動実行
```

#### steps-teams.md (Agent Teams オーケストレーション)

```
Phase 1: Team 作成
Phase 2: ファイル競合チェック
  - レイヤー間で共有ファイルがないか確認
  - 共有ファイル検出時: 警告 + 該当レイヤーを逐次実行に降格
Phase 3: レイヤー別 Teammate 起動 (general-purpose 型)
  - 各 Teammate が Skill(tdd-red) → Skill(tdd-green) → Skill(tdd-refactor) を実行
Phase 4: Independent Development (各自が担当レイヤーを実装)
Phase 5: API Contract Sync (変更時に broadcast で即時共有)
Phase 6: Integration Test (Lead が全テスト一括実行)
Phase 7: Team cleanup
Fallback: Agent Teams 無効時は Step 1 でブロック、具体的 next action を提示
```

#### tdd-plan 変更 (最小限)

Step 5.5 としてレイヤー検出提案を追加:
- env var チェック: CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS が有効な場合のみ提案
- In Scope で複数レイヤー検出時に AskUserQuestion
- レイヤー検出ロジック詳細は reference.md に委譲
- tdd-plan は 94行 → SKILL.md に 2-3行追加 + reference.md に詳細

#### ファイル構成

```
tdd-parallel/
├── SKILL.md              # メインフロー (< 100行)
├── reference.md          # レイヤー分割ガイド、Why Agent Teams Only、推奨レイヤー数
└── steps-teams.md        # Agent Teams オーケストレーション手順

tdd-plan/
├── SKILL.md              # Step 5.5 に 2-3行追加（レイヤー検出 → reference.md 参照）
└── reference.md          # レイヤー検出ロジック詳細を追加
```

## Scope Debate Log

### 討論テーマ
tdd-plan 統合を含めるか（A: スキルのみ vs B: スキル + tdd-plan 統合）

### 結果: B を推奨（2:1）

| 専門家 | 推奨 | 理由 |
|--------|------|------|
| architect | B | 既存パターン（diagnose, quality-gate）との一貫性。A だと孤立スキル |
| scope-expert | A | tdd-plan は中核スキル、編集リスク最小化。統合は別サイクルで |
| product-expert | B | 発見可能性が決定的。知らないスキルは使われない |

### 反映
- B 採用: tdd-parallel + tdd-plan 統合
- scope-expert の指摘を反映: tdd-plan 変更は最小限（提案文追加のみ）

## Progress Log

### 2026-02-06 18:00 - INIT
- Cycle doc created
- Scope: 5 files (3 new, 2 edit)
- Risk: 5 (PASS)
- Agent Teams 討論でスコープ決定（B: tdd-plan 統合込み、2:1）
- Reference: #44, #45 の実装パターンを踏襲

### 2026-02-06 18:00 - PLAN
- Design: 既存スキルラップ + tdd-plan 最小統合
- Test List: 13 test cases
- tdd-parallel は Agent Teams 必須（無効時は通常TDD逐次実行にフォールバック）
- tdd-plan 変更は Step 5.5 追加（2-3行 + reference.md に詳細委譲）

### 2026-02-06 18:00 - plan-review
- Score: 85 (BLOCK) - architecture-reviewer
- BLOCK原因: Phase Transitionパターンとの不整合
- 反映:
  - Architecture Note 追加（合成パターンの位置づけ明示）
  - env var 無効時のフォールバック追加（通常TDD逐次実行）
  - tdd-plan レイヤー検出ロジックを reference.md に委譲
  - When to Use セクション追加
  - ファイル競合チェック追加（steps-teams.md）
  - tdd-plan 提案に env var チェック条件追加
  - Why Agent Teams Only を reference.md に追加
- 見送り: ROI計測（Phase2）、Contract Freeze Checkpoint（Phase2）

### 2026-02-06 18:00 - REVIEW
- quality-gate 初回: 82 (BLOCK) - correctness-reviewer
- BLOCK原因:
  1. tdd-plan/reference.md 実行順序の矛盾
  2. レイヤー数1のガード漏れ
  3. フォールバックメッセージ重複（DRY違反）
- 修正後: 90 passed, 0 failed 維持

---

## Next Steps

1. [Done] INIT
2. [Done] PLAN
3. [Done] plan-review (BLOCK 85 → 修正済み)
4. [Done] RED (79 passed, 11 failed)
5. [Done] GREEN (90 passed, 0 failed)
6. [Done] REFACTOR (パターン統一確認、リファクタ不要)
7. [Done] REVIEW (quality-gate BLOCK 82 → 修正済み、90 passed)
8. [Done] COMMIT
