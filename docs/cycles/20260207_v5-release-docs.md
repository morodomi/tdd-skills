---
feature: v5-release-docs
cycle: v5-release-docs
phase: DONE
created: 2026-02-07
updated: 2026-02-07
---

# v5.0 PdM Delegation Model リリースドキュメント

## Scope Definition

### In Scope
- [ ] README.md: v5.0 PdM Delegation Model セクション追加
- [ ] README.md: Migration セクション (v4.3 -> v5.0) 追加
- [ ] README.md: バージョンバナー更新
- [ ] docs/STATUS.md: 全Issue反映・最終更新

### Out of Scope
- コード変更 (Cycle 1-4 で完了)
- README.ja.md 更新 (別Cycle)

### Files to Change (target: 10 or less)
- README.md (edit)
- docs/STATUS.md (edit)

## Environment

### Scope
- Layer: Plugin (Claude Code Plugin documentation)
- Plugin: tdd-core
- Risk: 10 (PASS)

### Runtime
- Bash: 3.2.57
- Claude Code: 2.1.33

### Dependencies (key packages)
- docs/20260206_design_v5_pdm_delegation.md: 設計ドキュメント
- Issue #47-#50: 全依存Cycle完了済み

## Context & Dependencies

### Reference Documents
- docs/20260206_design_v5_pdm_delegation.md - v5.0 設計ドキュメント
- README.md - 現在のREADME (v4.3.0)

### Dependent Features
- #47 plan-review Agent Teams対応 (DONE)
- #48 onboard AI Behavior Principles (DONE)
- #49 tdd-orchestrate PdMオーケストレータ (DONE)
- #50 architect/refactorer + tdd-init統合 (DONE)

### Related Issues/PRs
- Issue #51: docs: v5.0 PdM Delegation Model リリース

## Test List

### TODO
- [ ] TC-07: scripts/test-plugins-structure.sh 全テスト PASS

### WIP
(none)

### DISCOVERED
(none)

### DONE
- [x] TC-01: README.md に PdM Delegation Model の説明がある
- [x] TC-02: README.md に tdd-orchestrate の説明がある
- [x] TC-03: README.md に v5.0 バージョンバナーがある
- [x] TC-04: README.md に v4.3 -> v5.0 Migration セクションがある
- [x] TC-05: README.md に architect/refactorer の記載がある
- [x] TC-06: docs/STATUS.md の Open Issues が 0

## Implementation Notes

### Goal
v5.0 PdM Delegation Model の全機能実装完了を反映し、
README.md にリリースドキュメントを追加する。

### Background

v5.0 PdM Delegation Model の全機能実装が Cycle 1-4 (#47-#50) で完了。
README.md は v4.3.0 の記述のままで、v5.0 の主要機能が未反映:
- tdd-orchestrate: PdMオーケストレータ（全Phase自律委譲）
- architect/refactorer: 専門Agent定義
- tdd-init Agent Teams統合: env var分岐で自動PdMモード

### Design Approach

**方針: 既存README構造を踏襲し、v5.0セクション追加**

#### README.md 変更箇所

1. **バージョンバナー**: v4.3.0 → v5.0.0 に更新
2. **`## PdM Delegation Model (v5.0)` セクション新設** (Agent Teams Integration の後、`##` レベル):
   - PdM概念説明パラグラフ: 「Claude が PdM (Product Manager) として計画・判断に集中し、
     実装・テスト・レビューを専門エージェントに委譲する」
   - 概要図（v4.3 vs v5.0 のASCIIダイアグラム）
   - 3ブロックフロー: Planning / Implementation / Finalization
   - 専門Agent: architect (PLAN), refactorer (REFACTOR) + 既存 red-worker, green-worker
   - tdd-orchestrate: PdMオーケストレータ（内部スキル、tdd-init から自動呼び出し）
3. **TDD Workflow テーブル**: tdd-orchestrate は Phase スキルではないため行追加しない。
   PdM セクション内で説明する
4. **Migration セクション (v4.3 -> v5.0)** 追加:
   - 新機能: PdM Delegation Model
   - 破壊的変更なし（全機能 opt-in）
   - 有効化方法: `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` で自動有効
   - 未設定時: v4.3 動作が完全に維持される（後方互換）

#### docs/STATUS.md 変更箇所

- Open Issues: #51 削除 → 0件
- Recent Cycles: v5-release-docs 追加
- Cycle docs カウント更新

## Progress Log

### 2026-02-07 - INIT
- Cycle doc created
- Issue #51 から要件把握
- Risk: 10 (PASS) - ドキュメントのみ
- Files: 2 (edit only)
- 依存: #47-#50 全完了

### 2026-02-07 - PLAN
- 現在のREADME.md確認（v4.3.0記述）
- v5.0 設計ドキュメント確認
- README変更箇所: バナー + PdMセクション + Workflow更新 + Migration
- STATUS.md変更箇所: Issues 0 + Cycle追加
- Test List: 7 cases (TC-01〜TC-07)

### 2026-02-07 - plan-review
- Score: 72 (WARN) - architecture/usability
- 反映:
  - PdM概念説明パラグラフ追加（usability: critical）
  - セクション階層明確化: `##` レベル（architecture: important）
  - TDD Workflow テーブル: tdd-orchestrate 行追加せず PdM セクション内で説明
  - Migration: opt-in/後方互換の明記
- 見送り:
  - README.ja.md (Out of Scope)
  - リリースタイムライン (別管理)
  - Why セクション更新 (PdMセクションに集約)

### 2026-02-07 - REVIEW
- quality-gate: WARN (max 73)
  - correctness: 8, performance: 5, security: 5, guidelines: 5, product: 73, usability: 62
- 反映:
  - tdd-orchestrate: 内部スキル説明を明確化（ユーザーは直接呼び出さない旨追記）
  - Activation: 具体的なコマンド例追加 (export + claude)
  - Migration: 後方互換の明示 (env var未設定=v4.3動作維持, revert方法追記)
- 見送り:
  - PdM命名変更 (設計ドキュメントで確立済み)
  - Tokenコスト記載 (README範囲外)
  - Getting Started更新 (別スコープ)
- テスト: 136 passed, 0 failed

### 2026-02-07 - GREEN
- README.md: バージョンバナー v4.3.0 → v5.0.0
- README.md: PdM Delegation Model セクション追加 (概念説明、ASCII図、3ブロック、専門Agent、tdd-orchestrate)
- README.md: Migration v4.3 → v5.0 セクション追加 (opt-in/後方互換明記)
- docs/STATUS.md: #51 削除→0件、v5-release-docs追加、65 cycle docs
- 結果: 136 passed, 0 failed

### 2026-02-07 - RED
- TC-V5-01〜TC-V5-06 を scripts/test-plugins-structure.sh に追加
- TC-V5-06 false positive修正 (sed section extraction + grep -c)
- 結果: 130 passed, 6 failed (RED状態確認)

---

## Next Steps

1. [Done] INIT
2. [Done] PLAN
3. [Done] plan-review (WARN 72 → 修正反映済み)
4. [Done] RED (130 passed, 6 failed)
5. [Done] GREEN (136 passed, 0 failed)
6. [Done] REFACTOR (リファクタ不要)
7. [Done] REVIEW (quality-gate WARN 73, 反映済み, 136 passed)
8. [Done] COMMIT
