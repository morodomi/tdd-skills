---
feature: free-text-input-refinement
cycle: 20260209_free-text-input-refinement
phase: DONE
created: 2026-02-09
updated: 2026-02-09
---

# Free-text Input Refinement

## Scope Definition

### In Scope
- [ ] reference.md: free-text 再試行上限 (max 2回) 追加
- [ ] reference.md: "skip" オプション削除、proceed/fix/abort の3択に統一

### Out of Scope
- steps-teams.md の Socrates Protocol フロー変更 (構造変更なし)
- socrates.md の変更 (agent 定義は変わらない)
- SKILL.md の変更 (参照のみ)

### Files to Change (target: 10 or less)
- plugins/tdd-core/skills/tdd-orchestrate/reference.md (edit)
- plugins/tdd-core/skills/tdd-orchestrate/steps-teams.md (edit: skip 削除のみ)

## Environment

### Scope
- Layer: Markdown (Claude Code Plugin definitions)
- Plugin: tdd-core
- Risk: 20 (PASS)

### Runtime
- Claude Code Plugins

### Dependencies (key packages)
- socrates-advisor feature (commit 76f9fad)

## Context & Dependencies

### Reference Documents
- Design: docs/20260209_design_v5.1_socrates_advisor.md
- Parent cycle: docs/cycles/20260209_socrates-advisor.md

### Related Issues/PRs
- Issue #56: [DISCOVERED] free-text 再試行の上限定義
- Issue #57: [DISCOVERED] skip と proceed の意味的重複整理

## PLAN

### 設計方針

2つの改善を reference.md と steps-teams.md に適用する:

1. **#56 再試行上限**: 不明瞭入力の再確認を max 2回に制限。超過時は proceed をデフォルトとして警告付きで進行。
2. **#57 skip 削除**: "skip" (反論を無視して進行) は "proceed" と実質同義のため削除。有効入力を proceed/fix/abort + 番号選択の4種に統一。

### skip と proceed の意味分析

| 入力 | 現在の定義 | 実際の動作 |
|------|-----------|-----------|
| proceed | 現状のまま次 Phase へ進行 | 次 Phase へ進む |
| skip | Socrates の反論を無視して進行 | 次 Phase へ進む |

どちらも「次 Phase へ進む」という同一動作。「反論を無視して」は意図の違いだが、PdM の動作としては同じ。
よって skip を削除し、proceed に統一する。proceed = 「Socrates の反論を確認した上で、現状のまま進行する」。

### 再試行ロジック詳細

free-text retry (ユーザー入力の曖昧さ) と BLOCK retry (Phase 再実行) は**完全に独立**:

| 再試行種別 | トリガー | 上限 | 超過時 |
|-----------|---------|------|--------|
| free-text retry | 不明瞭な入力 ("hmm", "maybe" 等) | max 2回 | proceed をデフォルトとして警告付き進行 |
| BLOCK retry | Phase の BLOCK 判定 | max 1回 | ユーザーにエスカレーション |

free-text retry カウンタは Socrates Protocol 発動ごとにリセットする。

超過時の警告メッセージ:
```
入力が2回不明瞭でした。デフォルト (proceed) で次 Phase へ進行します。
```

### ファイル別変更内容

| ファイル | 変更箇所 | 変更内容 |
|---------|---------|---------|
| reference.md | line 175 | 入力テーブルから skip 行を削除 |
| reference.md | line 178-185 | 再確認プロンプトに max 2回ルール + 超過時メッセージを追記 |
| steps-teams.md | line 55 | plan-review の自由入力行から "/ skip" を削除 |
| steps-teams.md | line 114 | quality-gate の自由入力行から "/ skip" を削除 |

### plan-review 指摘への対応

| 指摘 | 対応 |
|------|------|
| skip vs proceed 意味不明 (arch BLOCK) | 上記「意味分析」セクションで明確化。同一動作のため統一 |
| retry limit と BLOCK retry の関係 (arch BLOCK) | 上記「再試行ロジック詳細」で独立性を明記 |
| 修正箇所の特定 (arch BLOCK) | ファイル別変更内容に行番号追記 |
| 超過時の警告メッセージ (usability/risk) | 具体的なメッセージテンプレートを定義 |

## Test List

### DONE
- [x] TC-01: [正常系] reference.md の入力テーブルに "skip" がないこと
- [x] TC-02: [正常系] reference.md の入力テーブルに proceed/fix/abort があること
- [x] TC-03: [正常系] reference.md に再試行上限 (max 2) の記述があること
- [x] TC-04: [正常系] reference.md に超過時デフォルト proceed の記述があること
- [x] TC-05: [正常系] steps-teams.md に "skip" がないこと
- [x] TC-06: [正常系] steps-teams.md に proceed/fix/abort があること
- [x] TC-07: [回帰] 既存 test-socrates-advisor.sh が通ること (18/18 PASS)

### DISCOVERED
(none)

## Progress Log

- INIT: Cycle doc 作成、スコープ定義完了
- PLAN: 簡易設計完了、Test List 7件作成
- plan-review: BLOCK (arch 85) → PLAN 補強 (skip 意味分析、retry ロジック詳細、行番号特定)
- RED: テストスクリプト作成、3/7 FAIL 確認
- GREEN: reference.md + steps-teams.md 編集、7/7 PASS
- REFACTOR: Markdown のみ、不要
- REVIEW: quality-gate スキップ (Risk 20 PASS、2ファイル小規模変更)
