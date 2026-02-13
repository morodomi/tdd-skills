---
feature: tdd-core
cycle: strategic-compact
phase: DONE
created: 2026-02-13 15:00
updated: 2026-02-13 15:00
---

# Strategic Compact（戦略的コンテキスト圧縮）

## Scope Definition

### In Scope
- [ ] tdd-plan reference.md に Phase Completion ガイダンス追加 + SKILL.md に1行リンク
- [ ] tdd-green reference.md に Phase Completion ガイダンス追加 + SKILL.md に1行リンク
- [ ] PreCompact フック用スクリプト作成（scripts/save-tdd-state.sh）
- [ ] 推奨Hooks設定にPreCompactフック追加

### Out of Scope
- Iterative Retrieval（次サイクルで実装）
- Continuous Learning v2（将来検討）
- 自動圧縮トリガー（手動提案のみ）
- redteam-core への適用（tdd-core のみ）

### Files to Change (target: 10 or less)
- plugins/tdd-core/skills/tdd-plan/SKILL.md (edit: 1行リンク追加)
- plugins/tdd-core/skills/tdd-plan/reference.md (edit: Phase Completionセクション追加)
- plugins/tdd-core/skills/tdd-green/SKILL.md (edit: 1行リンク追加)
- plugins/tdd-core/skills/tdd-green/reference.md (edit: Phase Completionセクション追加)
- scripts/save-tdd-state.sh (new)
- .claude/hooks/recommended.md (edit)
- scripts/test-strategic-compact.sh (new)

## Environment

### Scope
- Layer: Backend (Plugin system)
- Plugin: tdd-core (Bash scripts)
- Risk: 20 (PASS)

### Runtime
- Bash 3.2.57 (macOS default)

### Dependencies (key packages)
- Claude Code: Hooks API (PreCompact event - stderrはユーザーに表示、ブロック不可)

## Context & Dependencies

### Reference Documents
- [docs/20260212_strategic_compact.md] - 企画書
- [everything-claude-code](https://github.com/affaan-m/everything-claude-code) - 参考実装

### Dependent Features
- tdd-plan: SKILL.md にガイダンス追加
- tdd-green: SKILL.md にガイダンス追加
- Hooks recommended: PreCompact設定追加

### Related Issues/PRs
- (none)

## Test List

### TODO
(none)

### WIP
(none)

### DISCOVERED
(none)

### DONE
- [x] TC-01: save-tdd-state.sh がアクティブなCycle docのパスを検出できる
- [x] TC-02: save-tdd-state.sh が現在のフェーズをCycle docのfrontmatterから抽出できる
- [x] TC-03: save-tdd-state.sh の出力がCycle docパスとフェーズを含む
- [x] TC-04: save-tdd-state.sh がdocs/cycles/不在時にエラーメッセージを出力する
- [x] TC-05: save-tdd-state.sh がフェーズ未記載のCycle docでfallback動作する
- [x] TC-06: tdd-plan reference.md に Phase Completion セクションが存在する
- [x] TC-07: tdd-green reference.md に Phase Completion セクションが存在する
- [x] TC-08: tdd-plan SKILL.md が100行以下（98行）
- [x] TC-09: tdd-green SKILL.md が100行以下（92行）
- [x] TC-10: recommended.md に PreCompact フックが存在する
- [x] TC-11: PreCompact フックが save-tdd-state.sh を参照する

## Implementation Notes

### Goal
TDDフェーズ境界（PLAN完了後、GREEN完了後）でコンテキスト圧縮を提案し、
Cycle docに全情報が記録された状態で安全に圧縮できるようにする。

### Background
Claude Codeは長いセッションでコンテキスト窓が逼迫すると自動圧縮するが、
タイミングが任意のため作業中の重要な文脈が失われることがある。
TDDの7フェーズが自然な圧縮境界を提供する。

### Design Approach

**3つの変更レイヤー（役割分担）**:

| レイヤー | 役割 | タイミング |
|---------|------|-----------|
| Phase Completion（SKILL.md） | Claudeに圧縮可能タイミングを提案 | フェーズ完了時 |
| save-tdd-state.sh（PreCompact） | ユーザーにTDD状態を通知 | 圧縮直前（自動） |

1. **Phase Completion ガイダンス** (tdd-plan, tdd-green)
   - reference.mdにガイダンス本体を追加（Progressive Disclosure）
   - SKILL.mdには1行リンクのみ追加（100行制限回避）
   - Claudeへの提案: 「Cycle doc記録済みのため圧縮可能」

2. **save-tdd-state.sh** (新規)
   - PreCompactフックから呼ばれるスクリプト
   - 最新のdocs/cycles/*.mdを検出しフェーズを抽出
   - stderrにTDD状態を出力（ユーザーへの通知、Claudeには届かない）
   - docs/cycles/不在時は警告メッセージ出力（exit 0で続行許可）
   - jq不使用（grep/sedでfrontmatter解析、Bash 3.2互換）

3. **recommended.md PreCompact追加**
   - PreCompactイベントにsave-tdd-state.sh呼び出しを追加
   - Hook一覧テーブルにPreCompact行を追加

## Progress Log

### 2026-02-13 15:00 - INIT
- Cycle doc created
- 企画書 docs/20260212_strategic_compact.md を参照
- everything-claude-code リポジトリを調査済み
- Scope: Strategic Compact のみ（Iterative Retrieval は次サイクル）

### 2026-02-13 15:10 - PLAN
- 設計方針策定: 3レイヤー（SKILL.md編集 + スクリプト新規 + Hooks追加）
- Test List: 11ケース（正常系5 + 異常系2 + 構造検証4）
- jq依存を排除（grepベースでfrontmatter解析）

### 2026-02-13 15:20 - plan-review WARN (72)
- 共通指摘3件を反映:
  1. Phase Completionをreference.mdに移動（100行制限回避）
  2. save-tdd-state.sh出力先を「ユーザーへの通知」に修正（PreCompactはClaude不可視）
  3. Phase CompletionとPreCompactの役割分担テーブル追加

### 2026-02-13 15:30 - RED
- scripts/test-strategic-compact.sh 作成（11テストケース）
- 10件失敗確認（RED状態）

### 2026-02-13 15:35 - GREEN
- scripts/save-tdd-state.sh 作成（28行）
- tdd-plan/tdd-green reference.md に Phase Completion 追加
- recommended.md に PreCompact フック追加
- 全12テストPASS + 既存163テストPASS = 175 PASS

### 2026-02-13 15:40 - REFACTOR
- リファクタ不要と判断（最小限の実装で品質十分）

### 2026-02-13 15:45 - REVIEW
- quality-gate WARN (75): セキュリティ（パストラバーサル低リスク）、プロダクト（ROI未検証）
- 全テスト175 PASS維持

---

## Next Steps

1. [Done] INIT
2. [Done] PLAN
3. [Done] RED
4. [Done] GREEN
5. [Done] REFACTOR
6. [Done] REVIEW <- Current
7. [Next] COMMIT
