---
feature: tdd-plan
cycle: 20260123_1007
phase: DONE
created: 2026-01-23 10:07
updated: 2026-01-23 10:07
---

# tdd-plan リスク連動機能

## Scope Definition

### 今回実装する範囲
- [ ] Cycle docからリスクレベル読み取り
- [ ] リスク連動の質問設計（高リスク時のみ詳細質問）
- [ ] 設計テンプレート分岐

### 今回実装しない範囲
- Phase 3: Verification Gates（別Issue #31）
- Phase 4: 全体調整（別Issue #29）

### 変更予定ファイル（目安: 10以下）
- `plugins/tdd-core/skills/tdd-plan/SKILL.md`（編集）
- `plugins/tdd-core/skills/tdd-plan/reference.md`（編集）

## Environment

### Scope
- Layer: Plugin（Claude Code Skills）
- Plugin: tdd-core
- Risk: Low（Phase 1と同様パターン、2ファイル変更）

### Runtime
- Claude Code Plugin: Markdown + Bash

### Dependencies（主要）
- Phase 1（#28）: tdd-init リスク判定（完了済み）

## Context & Dependencies

### 参照ドキュメント
- [AgentSkills/docs/20250122_tdd-skills-evolution.md] - 設計元

### 依存する既存機能
- tdd-plan: 現行SKILL.md
- tdd-init: Risk フィールド（Phase 1で追加済み）

### 関連Issue/PR
- Issue #30: tdd-plan 質問連動（Question-Driven Design Phase 2）
- Issue #28: tdd-init リスク判定（完了）

## Test List

### TODO
- [ ] TC-01: Cycle docからRisk: 65 (BLOCK)を読み取れる
- [ ] TC-02: Cycle docからRisk: 20 (PASS)を読み取れる
- [ ] TC-03: BLOCK(60-100) → 詳細設計（セキュリティ、エラーハンドリング）
- [ ] TC-04: PASS(0-29) → 簡易設計（Test List中心）
- [ ] TC-05: WARN(30-59) → 標準設計
- [ ] TC-06: Riskフィールドなし → 標準設計（デフォルト: 30 WARN扱い）

### WIP
（現在なし）

### DISCOVERED
（現在なし）

### DONE
（現在なし）

## Implementation Notes

### やりたいこと
Phase 1で判定したリスクレベルに応じて、PLANフェーズの設計深度を調整する。

### 背景

Phase 1でtdd-initにリスク判定を追加した。PLANフェーズでもこのリスク情報を活用し、設計深度を調整する。

### 設計方針

**Step 1.5: リスクレベル確認**をStep 1の後に追加。

```
現行: Step 1 → Step 2 → Step 3（対話）
改善: Step 1 → Step 1.5（リスク確認）→ リスク連動分岐
```

#### リスク連動の設計深度

| リスク | 設計深度 | 内容 |
|--------|---------|------|
| High | 詳細設計 | セキュリティ考慮、エラーハンドリング、アーキテクチャ検討 |
| Medium | 標準設計 | 現行通り（対話 + Test List） |
| Low | 簡易設計 | Test Listのみ、対話省略可 |

#### 行数対策

- 現行: 99行
- Step 1.5追加後: 約109行（超過）
- 対策: Step 7の完了メッセージを圧縮、詳細をreference.mdに移動

## Progress Log

### 2026-01-23 10:07 - INIT
- Cycle doc作成
- Issue #30からスコープ定義

### 2026-01-23 10:15 - PLAN
- 設計方針決定: Step 1.5（リスク確認・分岐）追加
- Test List確定: 6ケース
- 行数対策: 完了メッセージ圧縮、詳細をreference.mdに移動

### 2026-01-23 10:25 - PLAN（スコープ変更）
- plan-review後、リスク判定をスコア形式に統一することを決定
- Phase 1（tdd-init）を先に修正してからPhase 2を実装
- スコア閾値: 0-29 PASS / 30-59 WARN / 60-100 BLOCK

### 2026-01-23 10:35 - RED/GREEN（統合）
- Phase 1修正:
  - tdd-init SKILL.md: スコア形式に変更
  - tdd-init reference.md: キーワード別スコア追加
  - templates/cycle.md: スコア形式に変更
  - test-risk-assessment.sh: スコア形式テストに更新
- Phase 2実装:
  - tdd-plan SKILL.md: Step 1.5追加（94行）
  - tdd-plan reference.md: BLOCK時詳細設計追加
  - test-plan-risk-integration.sh: 新規作成
- テスト: 62 passed (8 + 7 + 47)

### 2026-01-23 10:40 - REFACTOR
- test-plan-risk-integration.sh: 実行権限追加
- スコア閾値の一貫性確認: OK
- テスト: 62 passed（変化なし）

### 2026-01-23 10:45 - REVIEW
- テスト: 62 passed
- quality-gate: PASS（最大スコア35）
  - correctness: 35（optional指摘5件）
  - performance: 15（optional指摘2件）
  - security: 15（optional指摘3件）
  - guidelines: 25（optional指摘6件）

### 2026-01-23 10:50 - COMMIT
- コミット: 07ab6e6
- Issue #30 クローズ

---

## 次のステップ

1. [完了] INIT
2. [完了] PLAN
3. [完了] RED
4. [完了] GREEN
5. [完了] REFACTOR
6. [完了] REVIEW
7. [完了] COMMIT
