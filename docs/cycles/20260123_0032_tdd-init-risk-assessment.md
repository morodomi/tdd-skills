---
feature: tdd-init
cycle: 20260123_0032
phase: REVIEW
created: 2026-01-23 00:32
updated: 2026-01-23 00:32
---

# tdd-init リスク判定機能

## Scope Definition

### 今回実装する範囲
- [ ] リスク判定ロジック（キーワードベース）
- [ ] 分岐処理（低リスク→自動進行、高リスク→詳細質問）
- [ ] Cycle docへのリスクレベル記録

### 今回実装しない範囲
- Phase 2: tdd-plan質問連動（別Issue #30）
- Phase 3: Verification Gates（別Issue #31）
- Phase 4: 全体調整（別Issue #29）

### 変更予定ファイル（目安: 10以下）
- `plugins/tdd-core/skills/tdd-init/SKILL.md`（編集）
- `plugins/tdd-core/skills/tdd-init/reference.md`（編集）
- `plugins/tdd-core/skills/tdd-init/templates/cycle.md`（編集）

## Environment

### Scope
- Layer: Plugin（Claude Code Skills）
- Plugin: tdd-core

### Runtime
- Claude Code Plugin: Markdown + Bash

### Dependencies（主要）
- なし（Markdown/Bashのみ）

## Context & Dependencies

### 参照ドキュメント
- [AgentSkills/docs/20250122_tdd-skills-evolution.md] - 設計元

### 依存する既存機能
- tdd-init: 現行SKILL.md（Step 4-6付近を変更）

### 関連Issue/PR
- Issue #28: tdd-init リスク判定（Question-Driven Design Phase 1）

## Test List

### TODO

**分岐処理**
- [ ] TC-07: 低リスク → 確認表示のみで自動進行
- [ ] TC-08: 中リスク → デフォルト提示 + スコープ確認
- [ ] TC-09: 高リスク → AskUserQuestion で詳細質問

**Cycle doc記録**
- [ ] TC-10: Environmentセクションに Risk レベルが記録される

**エッジケース**
- [ ] TC-11: 複数キーワード該当時、最高リスクを採用
- [ ] TC-12: キーワードなし → 中リスク（デフォルト）

### WIP

**正常系（リスク判定）**
- [ ] TC-01: 「ボタンの色を変えたい」→ 低リスク判定
- [ ] TC-02: 「テスト追加したい」→ 低リスク判定
- [ ] TC-03: 「新機能を追加したい」→ 中リスク判定
- [ ] TC-04: 「ログイン機能を追加したい」→ 高リスク判定
- [ ] TC-05: 「APIと連携したい」→ 高リスク判定
- [ ] TC-06: 「DB構造を変更したい」→ 高リスク判定

### DISCOVERED
（現在なし）

### DONE
（現在なし）

## Implementation Notes

### やりたいこと
INITフェーズで「やりたいこと」を聞いた後、自動でリスク判定し、質問の深さを調整する。

### 背景

質問が多すぎると開発が進まない。質問が少なすぎると間違った方向に進む。
リスクベースで質問の深さを自動調整することで、速度と品質のバランスを取る。

### 設計方針

**Pattern A + D の組み合わせ**（リスクベース + 段階的開示）

```
現行: Step 4 → Step 5（スコープ確認）→ Step 6（機能名生成）
改善: Step 4 → Step 4.5（リスク判定）→ Step 5（条件付き詳細質問）
```

#### リスク判定ロジック（キーワードベース）

| キーワード | リスク | 理由 |
|-----------|--------|------|
| ログイン/認証/認可/パスワード/セッション | 高 | セキュリティ |
| API/外部連携/決済/webhook | 高 | 外部依存 |
| DB変更/マイグレーション/スキーマ | 高 | データ影響 |
| リファクタリング/大規模/全体 | 高 | 影響範囲 |
| テスト追加/ドキュメント/コメント | 低 | 限定的 |
| UI修正/色/文言/typo | 低 | 見た目のみ |
| その他 | 中 | デフォルト |

#### 分岐処理

- **低リスク**: 確認表示のみで自動進行
- **中リスク**: デフォルト提示 + スコープ確認
- **高リスク**: AskUserQuestionで詳細質問
  - 認証方式（セッション/JWT/OAuth等）
  - 影響範囲（ファイル数）
  - 外部依存（API/DB等）

#### Cycle docへの記録

Environmentセクションに `Risk: High/Medium/Low` を追加

## Progress Log

### 2026-01-23 00:32 - INIT
- Cycle doc作成
- Issue #28からスコープ定義

### 2026-01-23 00:45 - PLAN
- 設計方針決定（Pattern A + D）
- リスク判定ロジック設計
- Test List作成（12ケース）

### 2026-01-23 00:55 - RED
- テストスクリプト作成: scripts/test-risk-assessment.sh
- テスト実行: 3 passed, 4 failed（期待通りのRED状態）

### 2026-01-23 01:05 - GREEN
- SKILL.md: Step 4.5（リスク判定）追加
- reference.md: キーワードテーブル、詳細質問追加
- templates/cycle.md: Risk フィールド追加
- テスト実行: 7 passed, 0 failed
- 注意: SKILL.md 130行（100行制限超過）→ REFACTOR で対応

### 2026-01-23 01:10 - REFACTOR
- SKILL.md: 130行 → 100行に圧縮
  - Step 2 環境情報収集: 詳細をreference.mdに移動
  - Progress Checklist: 1行形式に圧縮
  - Step 8 完了メッセージ: 簡略化
- テスト実行: 7 passed（risk-assessment）+ 47 passed（plugins）

### 2026-01-23 01:15 - REVIEW
- テスト: 54 passed, 0 failed
- quality-gate: PASS（最大スコア35）
  - correctness: 35（optional指摘3件）
  - performance: 25
  - security: 25
  - guidelines: 25

---

## 次のステップ

1. [完了] INIT
2. [完了] PLAN
3. [ ] RED
4. [ ] GREEN
5. [ ] REFACTOR
6. [ ] REVIEW
7. [ ] COMMIT
