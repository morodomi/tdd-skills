---
feature: v51-release-docs
cycle: 20260209_v51-release-docs
phase: DONE
created: 2026-02-09
updated: 2026-02-09
---

# v5.1 Socrates Advisor リリースドキュメント

## Scope Definition

### In Scope
- [ ] README.md: v5.1 Socrates Advisor セクション追加
- [ ] README.md: バージョンバナー v5.0.0 → v5.1.0 更新
- [ ] README.md: Migration セクション (v5.0 → v5.1) 追加
- [ ] docs/STATUS.md: 最終更新

### Out of Scope
- コード変更 (全サイクル完了済み)
- README.ja.md 更新 (別Cycle)

### Files to Change (target: 10 or less)
- README.md (edit)
- docs/STATUS.md (edit)

## Environment

### Scope
- Layer: Markdown (Claude Code Plugin definitions)
- Plugin: tdd-core
- Risk: 10 (PASS)

### Runtime
- Claude Code Plugins

### Dependencies (key packages)
- socrates-advisor (commit 76f9fad)
- free-text-input-refinement (commit adbc4fa)
- socrates-protocol-polish (commit d10dc21)
- socrates-fallback (commit c16c880)

## Context & Dependencies

### Reference Documents
- docs/cycles/20260207_v5-release-docs.md (v5.0 リリースドキュメントパターン)
- docs/cycles/20260209_socrates-advisor.md (メイン機能)

### Dependent Features
- socrates-advisor: Socrates Devil's Advocate 常駐 teammate (DONE)
- free-text-input-refinement: skip 除去 + retry 上限 (DONE, Closes #56, #57)
- socrates-protocol-polish: タイムスタンプ + 長さ制約 (DONE, Closes #59, #60)
- socrates-fallback: v5.0 互換フォールバック (DONE, Closes #58)

### Related Issues/PRs
- (新規)

## PLAN

### 設計方針

v5.0 リリースドキュメント (20260207_v5-release-docs.md) のパターンを踏襲。
既存の README.md 構造に v5.1 セクションを追加する。

### 変更箇所

| ファイル | 変更内容 |
|---------|---------|
| README.md line 5 | バージョンバナー v5.0.0 → v5.1.0 更新 |
| README.md line 127-169 | PdM Delegation Model セクションに Socrates Advisor サブセクション追加 |
| README.md line 233-243 | Migration に v5.0 → v5.1.0 セクション追加 (v4.3→v5.0 の前に挿入) |
| docs/STATUS.md | v51-release-docs を Recent Cycles に追加、Cycle docs カウント更新 |

### README.md 追加内容

#### 1. バージョンバナー (line 5)
`> **v5.0.0**: PdM Delegation Model - ...` → `> **v5.1.0**: PdM + Socrates Advisor - Devil's Advocate for critical review decisions`

#### 2. Socrates Advisor サブセクション (### Activation の後、## Parallel Execution の前)
- `### Socrates Advisor (v5.1)` サブセクション
- **価値説明**: なぜ必要か (plan-review/quality-gate の WARN/BLOCK 時に人間の判断精度を上げる)
- **ワークフロー発動タイミング**: plan-review, quality-gate でスコア50以上の時に発動
- **Socrates Protocol フロー図 (ASCII)**:
  ```
  plan-review/quality-gate -> Score 50+ -> Socrates (Devil's Advocate)
                                              |
                                    Objections & Alternatives
                                              |
                                    PdM -> Merit/Demerit -> Human
                                              |
                                    proceed / fix / abort
  ```
- **Score-based judgment table**: スコアの意味を明記
  - 0-49 PASS: 自動進行
  - 50-79 WARN: Socrates Protocol → 人間判断
  - 80-100 BLOCK: Socrates Protocol → 人間判断
- **Free-text input**: proceed (進行) / fix (修正して再実行) / abort (中断)
- **Fallback**: Socrates 無応答時は v5.0 互換 (WARN 自動進行、BLOCK 自動再試行)

#### 3. Migration v5.0 → v5.1.0 (## Migration セクションの先頭、v4.3→v5.0 の前)
- New feature: Socrates Devil's Advocate advisor for Agent Teams
- plan-review/quality-gate の WARN/BLOCK 時に Socrates Protocol 発動
- Free-text human input (proceed/fix/abort)
- Automatic v5.0 fallback when Socrates is unresponsive
- 破壊的変更なし: Agent Teams 有効時のみ動作、無効時は v5.0 動作維持

## Test List

### DONE
- [x] TC-01: [正常系] README.md に v5.1 バージョンバナーがあること
- [x] TC-02: [正常系] README.md に Socrates Advisor セクションがあること
- [x] TC-03: [正常系] README.md に Socrates Protocol の説明があること
- [x] TC-04: [正常系] README.md に PASS/WARN/BLOCK 判定の説明があること
- [x] TC-05: [正常系] README.md に fallback の記述があること
- [x] TC-06: [正常系] README.md に v5.0 → v5.1 Migration セクションがあること
- [x] TC-07: [回帰] scripts/test-plugins-structure.sh が PASS すること

### DISCOVERED
(none)

## Progress Log

- INIT: Cycle doc 作成、スコープ定義完了
- PLAN: 簡易設計完了、Test List 7件作成
- plan-review: WARN (max 72) → v5.1 維持、Usability/Architecture 指摘を PLAN に反映
- RED: テストスクリプト作成、4/7 FAIL 確認
- GREEN: README.md 編集 (バナー + Socrates セクション + Migration)、7/7 PASS
- COMMIT: 完了
