---
feature: review-skills
cycle: 20251223_1359
phase: DONE
created: 2024-12-23 13:59
updated: 2024-12-23
---

# レビュー・品質強化

## Scope Definition

### 今回実装する範囲
- [ ] plan-review スキル新規作成
- [ ] code-review スキル汎用化・移動
- [ ] tdd-red エッジケースチェックリスト追加
- [ ] test-agent.md 削除

### 今回実装しない範囲
- ❌ tdd-plan の変更（エッジケースはREDに委譲）
- ❌ tdd-green の変更（REDでテストがあれば自然に対応）
- ❌ 言語別プラグインの変更

### 変更予定ファイル（目安: 10以下）
- `plugins/tdd-core/skills/plan-review/SKILL.md`（新規）
- `plugins/tdd-core/skills/code-review/SKILL.md`（新規）
- `plugins/tdd-core/skills/tdd-red/SKILL.md`（編集）
- `.claude/commands/code-review.md`（削除）
- `.claude/commands/test-agent.md`（削除）

## Environment

### Runtime
- Claude Code CLI

### Dependencies（主要）
- tdd-skills v1.0.1

## Context & Dependencies

### 参照ドキュメント
- [Vibe Coding - Wikipedia](https://en.wikipedia.org/wiki/Vibe_coding)
- [Veracode - AI Generated Code Security](https://www.veracode.com/blog/ai-generated-code-security-risks/)

### 依存する既存機能
- tdd-core: TDD 7フェーズワークフロー
- tdd-red: テスト作成フェーズ

### 関連Issue/PR
- なし

## Test List

### TODO
（現在なし）

### WIP
（現在なし）

### DISCOVERED
（現在なし）

### DONE
- [x] TC-01: plan-review が並行レビュー（3観点）を実行できる
- [x] TC-02: plan-review が 0件で RED へ自動進行
- [x] TC-03: plan-review が 1件以上で PLAN戻り/RED進行を選択可能
- [x] TC-04: code-review が並行レビュー（3観点）を実行できる
- [x] TC-05: code-review が 0件で COMMIT へ自動進行
- [x] TC-06: code-review が 1件以上で GREEN戻り/Issue→COMMITを選択可能
- [x] TC-07: code-review が 2回目以降で GREEN戻り不可
- [x] TC-08: tdd-plan に plan-review 推奨表示が追加されている
- [x] TC-09: tdd-review の Step順序が正しい（テスト→カバレッジ→静的解析→code-review）
- [x] TC-10: tdd-red でエッジケースチェックリストが表示される
- [x] TC-11: .claude/commands/code-review.md が削除されている
- [x] TC-12: .claude/commands/test-agent.md が削除されている

## Implementation Notes

### やりたいこと
- Vibe Coding時代に対応したAIレビュアースキルの追加
- エッジケース・バリデーション漏れの早期発見
- code-reviewでCritical発見時の手戻り削減

### 背景
Vibe Codingでは45%のAI生成コードにセキュリティ欠陥があるとされる。
レビューを設計段階（plan-review）と実装段階（code-review）で行うことで、
品質を担保しつつ、手戻りを最小化する。

### 設計方針

#### plan-review
- tdd-plan の Step 5.5 で推奨実行
- 並行レビュー（設計整合性、セキュリティ設計、依存関係）
- 0件 → RED へ自動進行
- 1件以上 → PLAN戻り推奨、ユーザー選択でRED進行可

#### code-review
- tdd-review の Step 4 で自動実行（カバレッジ確認・静的解析の後）
- 並行レビュー（Correctness、Performance、Security）
- 0件 → COMMIT へ自動進行
- 1件以上 → GREEN戻り推奨、ユーザー選択でIssue作成→COMMIT可
- ループ対策: 2回目以降はGREEN戻り不可、Issue作成またはCOMMIT強制

#### tdd-review Step順序
1. テスト実行
2. カバレッジ確認
3. 静的解析
4. code-review
5. 結果判定→分岐

#### tdd-red
- Step 1.5 にエッジケースチェックリスト追加
- null/空文字、境界値、不正入力、権限エラー、外部依存エラー

## Review結果の戻り先

### plan-review
| 結果 | 戻り先 |
|------|--------|
| Critical | PLAN に戻る（設計やり直し） |
| Important | 修正後 RED へ進む |
| Optional | 記録して RED へ進む |

### code-review
| 結果 | 戻り先 |
|------|--------|
| Critical | GREEN に戻る（実装修正） |
| Important | REFACTOR で対応 |
| Optional | DISCOVERED に記録 |

## Progress Log

### 2024-12-23 13:59 - INIT
- Cycle doc作成
- Scope定義完了
- Vibe Coding調査完了

### 2024-12-23 14:15 - PLAN
- 設計方針決定
- plan-review: 並行レビュー、推奨実行、0件/1件以上で分岐
- code-review: 並行レビュー、自動実行、ループ対策追加
- tdd-review: Step順序変更（カバレッジ→静的解析→code-review）
- tdd-red: エッジケースチェックリスト追加
- Test List更新（12件）

### 2024-12-23 - RED/GREEN/REFACTOR
- plan-review スキル作成（SKILL.md + reference.md）
- code-review スキル作成（SKILL.md + reference.md）
- tdd-plan に plan-review 推奨表示追加
- tdd-review の Step順序変更 + code-review統合
- tdd-red にエッジケースチェックリスト追加
- 古いコマンド削除（code-review.md, test-agent.md）
- 全スキルを100行以下にリファクタリング
- 構造テスト: 30 passed, 0 failed

### 2024-12-23 - REVIEW/COMMIT
- code-review実行: Critical 0件、Important 0件、Optional 1件
- コミット: 3b9364f

---

## 次のステップ

1. [完了] INIT
2. [完了] PLAN
3. [完了] RED/GREEN/REFACTOR
4. [完了] REVIEW
5. [完了] COMMIT

**サイクル完了**
