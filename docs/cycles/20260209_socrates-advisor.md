---
feature: socrates-advisor
cycle: 20260209_socrates-advisor
phase: DONE
created: 2026-02-09
updated: 2026-02-09
---

# Socrates Advisor - Devil's Advocate Teammate

## Scope Definition

### In Scope
- [ ] agents/socrates.md: Socrates Agent 定義 (新規)
- [ ] tdd-orchestrate/SKILL.md: Socrates spawn + Protocol ステップ追加
- [ ] tdd-orchestrate/reference.md: 判断基準更新 + Socrates Protocol 詳細
- [ ] tdd-orchestrate/steps-teams.md: Socrates メッセージフロー追加

### Out of Scope
- Subagent Chain Mode での Socrates (Agent Teams 専用)
- socrates_mode 切り替え (将来拡張)
- plan-review / quality-gate Skill 自体の変更
- steps-subagent.md の変更

### Files to Change (target: 10 or less)
- plugins/tdd-core/agents/socrates.md (new)
- plugins/tdd-core/skills/tdd-orchestrate/SKILL.md (edit)
- plugins/tdd-core/skills/tdd-orchestrate/reference.md (edit)
- plugins/tdd-core/skills/tdd-orchestrate/steps-teams.md (edit)

## Environment

### Scope
- Layer: Markdown (Claude Code Plugin definitions)
- Plugin: tdd-core
- Risk: 40 (WARN)

### Runtime
- Claude Code Plugins
- Agent Teams (experimental)

### Dependencies (key packages)
- CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1

## Context & Dependencies

### Reference Documents
- Design: docs/20260209_design_v5.1_socrates_advisor.md
- Base: docs/20260206_design_v5_pdm_delegation.md

### Dependent Features
- tdd-orchestrate: plugins/tdd-core/skills/tdd-orchestrate/
- Agent Teams: teammate spawn/shutdown/SendMessage

## Design Decisions

| 決定事項 | 選択 | 理由 |
|---------|------|------|
| 発動タイミング | WARN/BLOCK のみ (PASS は自動進行) | 判断疲れ防止 |
| 発動Phase | plan-review 後 + quality-gate 後 | 判断ポイントが2箇所 |
| ライフサイクル | Team作成時 spawn → cleanup時 shutdown | 文脈蓄積のため常駐 |
| Agent Type | Plan (read-only) | コードに触れない |
| 人間への提示 | テキスト出力 + 自由入力 | AskUserQuestion の選択肢制約を回避 |
| Cycle doc 記録 | Progress Log に追記 | 既存フォーマット活用 |

## PLAN

### 設計方針

Socrates は Agent Teams 有効時のみ常駐する read-only **advisor** (reviewer ではない)。
plan-review / quality-gate のスコアが WARN (50-79) または BLOCK (80+) のとき、
PdM の判断提案に反論し、メリデメを構造化して人間にテキスト出力する。
人間は自由入力で判断を返す。PASS (0-49) は従来通り自動進行。

**v5.0 との関係**: v5.0 では WARN は自動進行だった。v5.1 では WARN でも人間判断を求める。
これは意図的な変更であり、自律性より判断精度を優先する設計判断。

### ファイル別変更内容

| ファイル | 変更内容 |
|---------|---------|
| agents/socrates.md | 新規: frontmatter + Behavior Rules + Response Format + Context。**reviewer との違いを明記** (advisor = 判断助言、reviewer = コード検証) |
| tdd-orchestrate/SKILL.md | Judgment Criteria テーブル WARN/BLOCK 更新 + Socrates 参照。**行数バジェット: 現72行 → 目標80行以内** (詳細は reference.md に委譲) |
| tdd-orchestrate/reference.md | Socrates Protocol セクション新規 + 判断基準更新 + Progress Log フォーマット。**WARN自動進行の設計理由セクション (現 line 53-59) を v5.1 理由に書き換え**。**人間の自由入力ハンドリング定義** (有効な入力例 + 不明瞭入力時の再確認ルール) |
| tdd-orchestrate/steps-teams.md | Phase 1 に socrates spawn + 判断ポイント2箇所に Protocol フロー + cleanup。**初回 Socrates 発動時のユーザー案内文追加**

### plan-review 指摘への対応方針

| 指摘 | 対応 |
|------|------|
| free-text 入力の曖昧さ (usability critical) | reference.md に有効入力例 + 不明瞭時の再確認ルールを追加 |
| WARN 設計理由セクション矛盾 (scope/risk) | reference.md の該当セクションを v5.1 理由に全面書き換え |
| SKILL.md 行数バジェット (risk) | 詳細を reference.md に委譲、SKILL.md は参照のみ |
| Socrates vs reviewer の区別 (architecture) | socrates.md に「advisor であり reviewer ではない」を明記 |
| 初見ユーザーへの案内 (usability) | steps-teams.md の初回発動時に説明テキスト追加 |
| opt-in 方式 (product) | **不採用**: ユーザー判断によりデフォルト ON を維持 |
| 初回案内の表示タイミング (usability) | **初回 WARN/BLOCK 発生時** (Team作成時ではない)。1サイクル1回のみ |
| reference.md WARN 設計理由の置換 (risk/scope) | 「WARN (50-79) は判断が分かれるゾーン。Socrates Protocol で人間の知見を入れることが最も ROI が高い。自律性 (v5.0) より判断精度 (v5.1) を優先する意図的な設計変更。」 |
| free-text 有効入力 (usability) | proceed, fix, abort, skip + 数字選択 (1,2,3)。不明瞭時は再確認プロンプト |

## Test List

### DONE
- [x] TC-01: [正常系] socrates.md が存在し frontmatter に name: socrates があること
- [x] TC-02: [正常系] socrates.md に Behavior Rules セクションがあること
- [x] TC-03: [正常系] socrates.md に Response Format セクションがあること
- [x] TC-04: [正常系] socrates.md に read-only 制約記述があること (コード変更禁止)
- [x] TC-05: [正常系] SKILL.md の Judgment Criteria に Socrates Protocol 記述があること
- [x] TC-06: [正常系] SKILL.md が 100 行以下であること
- [x] TC-07: [正常系] reference.md に Socrates Protocol セクションがあること
- [x] TC-08: [正常系] reference.md の WARN 行が Socrates Protocol を参照していること (自動進行でないこと)
- [x] TC-09: [正常系] reference.md に Progress Log フォーマット (Socrates Objection + Human Decision) があること
- [x] TC-10: [正常系] steps-teams.md Phase 1 に socrates spawn があること
- [x] TC-11: [正常系] steps-teams.md に plan-review 後の Socrates Protocol があること
- [x] TC-12: [正常系] steps-teams.md に quality-gate 後の Socrates Protocol があること
- [x] TC-13: [正常系] steps-teams.md の cleanup に socrates shutdown があること
- [x] TC-14: [境界値] steps-subagent.md に socrates 記述がないこと (Agent Teams 専用)
- [x] TC-15: [正常系] reference.md に自由入力の有効例 (proceed/fix/abort 等) があること
- [x] TC-16: [異常系] reference.md に不明瞭入力時の再確認ルールがあること
- [x] TC-17: [正常系] socrates.md に reviewer との違い (advisor) が明記されていること
- [x] TC-18: [回帰] 既存 test-plugins-structure.sh が通ること

## DISCOVERED

- free-text 再試行の上限定義 (max 2回 → proceed デフォルト) → #56
- "skip" と "proceed" の意味的重複の整理 → #57
- Socrates 障害時のフォールバック (タイムアウト → v5.0 ロジック) → #58
- Progress Log にタイムスタンプ追加 → #59
- Socrates 応答の長さ制約 (各 objection 2-3文以内) → #60

## Progress Log

- PLAN: 設計完了、Test List 18件作成
- plan-review (1st): WARN (max 72) → ユーザー判断: fix (PLAN 再実行)
- plan-review (2nd): WARN (max 72) → 実装内容は妥当、RED へ進行
- RED: テストスクリプト作成、15/18 FAIL 確認 (正常な RED 状態)
- GREEN: 4ファイル実装完了、18/18 PASS
- REFACTOR: Markdown のみ、リファクタリング不要
- quality-gate: WARN (max 75) → ユーザー判断: proceed (COMMIT へ)
