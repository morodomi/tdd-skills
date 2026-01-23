---
feature: tdd-core
cycle: 20260123_1333
phase: DONE
created: 2026-01-23 13:33
updated: 2026-01-23 13:33
---

# Phase 5: 質問駆動INIT

## Scope Definition

### 今回実装する範囲
- [ ] 高リスク時のAskUserQuestion自動生成
- [ ] リスクタイプ別の質問テンプレート
- [ ] INIT→PLANへの回答引き継ぎ

### 今回実装しない範囲
- PLANフェーズでの追加質問（次フェーズで検討）
- 質問のカスタマイズ機能

### 変更予定ファイル（目安: 10以下）
- `plugins/tdd-core/skills/tdd-init/SKILL.md`（質問生成ロジック）
- `plugins/tdd-core/skills/tdd-init/reference.md`（質問テンプレート）
- `plugins/tdd-core/skills/tdd-init/templates/cycle.md`（回答記録欄）

## Environment

### Scope
- Layer: Plugin（Claude Code Skills）
- Plugin: tdd-core
- Risk: 40 (WARN) - 認証・外部API関連の質問設計

### Runtime
- Claude Code Plugin: Markdown + AskUserQuestion

### Dependencies（主要）
- Phase 1-4 完了済み
- AskUserQuestionツールの仕様理解

## Context & Dependencies

### 参照ドキュメント
- [AgentSkills/docs/20250122_tdd-skills-evolution.md] - 設計元
- Pattern A: Risk-Based Questioning

### 設計の要件（設計書より）
```
高リスク時:
AskUserQuestion:
1. 認証方式: [セッション / JWT / OAuth / 既存拡張]
2. 対象ユーザー: [一般 / 管理者 / 両方]
3. 2FA: [必要 / 不要 / 後で検討]
```

## Test List

### TODO
- [ ] TC-01: BLOCK時（60+）にAskUserQuestionが実行される記述がある
- [ ] TC-02: セキュリティ関連の質問テンプレートがある
- [ ] TC-03: 外部依存関連の質問テンプレートがある
- [ ] TC-04: Cycle docに回答記録欄がある
- [ ] TC-05: 各SKILL.mdが100行以下

### WIP
（現在なし）

### DISCOVERED
（現在なし）

### DONE
（現在なし）

## Implementation Notes

### やりたいこと
高リスク（BLOCK）時に、リスクタイプに応じた質問を自動生成し、設計の精度を上げる。

### 背景
現状のBLOCK時質問は汎用的（影響範囲、外部依存）のみ。設計書では「認証関連なら認証方式を聞く」等のリスクタイプ別質問を要求している。

### 設計方針

#### Step 4.6: リスクタイプ別質問（BLOCK時のみ）
SKILL.mdにStep 4.6を追加。検出キーワードに応じて質問を分岐。

#### リスクタイプ別質問テンプレート（reference.md）

| リスクタイプ | 検出キーワード | 質問 |
|-------------|---------------|------|
| セキュリティ | ログイン, 認証, 権限 | 認証方式, 対象ユーザー, 2FA |
| 外部連携 | API, webhook, 決済 | API認証方式, エラー処理, レート制限 |
| データ変更 | DB, マイグレーション | 既存データ影響, ロールバック方法 |

#### Cycle doc記録形式（templates/cycle.md）
```markdown
### Risk Interview（BLOCK時のみ）
- リスクタイプ: セキュリティ
- 認証方式: JWT
- 対象ユーザー: 一般ユーザー
- 2FA: 後で検討
```

## Progress Log

### 2026-01-23 13:33 - INIT
- Cycle doc作成
- Phase 5としてスコープ定義
- リスクスコア: 40 (WARN)

### 2026-01-23 13:40 - PLAN
- 設計方針決定: Step 4.6追加、リスクタイプ別質問
- 変更ファイル: SKILL.md, reference.md, templates/cycle.md
- Test List: 6ケース

### 2026-01-23 13:50 - RED/GREEN/REFACTOR
- テストスクリプト作成: scripts/test-question-driven-init.sh
- 3ファイル修正、全テスト通過（6 passed）
- SKILL.md: 98行（100行以下）

### 2026-01-23 13:55 - REVIEW
- テスト: 53 passed (47 plugins + 6 phase5)
- quality-gate: PASS（最大スコア42）
  - correctness: 42（important 2件）
  - guidelines: 35
  - scope: 25
  - risk: 25
- important指摘対応:
  1. スコア重複ルール明記（同一カテゴリは1回のみ）
  2. 複数リスクタイプ時は全質問実行を明記
- 追加修正: デフォルト0、計算例6パターン、multiSelect意図明記

### 2026-01-23 14:10 - COMMIT
- コミット: 7c839aa
- Phase 5完了

---

## 次のステップ

1. [完了] INIT
2. [完了] PLAN
3. [完了] RED
4. [完了] GREEN
5. [完了] REFACTOR
6. [完了] REVIEW
7. [完了] COMMIT
