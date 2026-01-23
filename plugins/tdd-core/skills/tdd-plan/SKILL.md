---
name: tdd-plan
description: 実装計画を作成し、Test Listを定義する。INITの次フェーズ。「設計して」「計画して」で起動。
---

# TDD PLAN Phase

実装計画を作成し、Cycle docのPLANセクションを更新する。

## Progress Checklist

```
PLAN: Cycle doc確認 → リスク確認 → ドキュメント確認 → 対話 → PLAN更新 → Test List → plan-review → RED誘導
```

## 禁止事項

- 実装コード作成（GREENで行う）
- テストコード作成（REDで行う）
- ユーザー承認なしの次フェーズ移行

## Workflow

### Step 1: Cycle doc確認

```bash
ls -t docs/cycles/*.md 2>/dev/null | head -1
```

Environmentセクションでバージョン情報を把握。

### Step 1.5: リスクスコア確認

Cycle docの `Risk: [スコア] ([判定])` を読み取り、設計深度を決定:

| スコア | 判定 | 設計深度 |
|--------|------|----------|
| 0-29 | PASS | 簡易設計（Test List中心、対話省略可） |
| 30-59 | WARN | 標準設計（現行通り） |
| 60-100 | BLOCK | 詳細設計（[reference.md](reference.md)参照） |

Riskフィールドなし → WARN（標準設計）として扱う。

### Step 2: 最新ドキュメント確認（必要な場合）

メジャーバージョンや破壊的変更が疑われる場合、WebSearch/WebFetchで確認。

### Step 3: 実装計画の対話

アーキテクチャ、依存関係、品質基準をユーザーに確認。

### Step 4: PLANセクション更新

背景・設計方針・ファイル構成をCycle docに追記。

### Step 5: Test List作成

以下のカテゴリを網羅してTest Listを作成:

| カテゴリ | 必須 |
|----------|------|
| 正常系 | ✅ |
| 境界値 | ✅ |
| エッジケース | ✅ |
| 異常系 | ✅ |
| 権限 | △ 認証機能時 |
| 外部依存 | △ API/DB連携時 |
| セキュリティ | △ 入力処理時 |

目安: 機能1つにつき5-10ケース

異常系は [エラーメッセージ設計](reference.md#エラーメッセージ設計) を参照。

```markdown
## Test List

### TODO
- [ ] TC-01: [正常系]
- [ ] TC-02: [境界値]
- [ ] TC-03: [エッジケース]
- [ ] TC-04: [異常系]
```

### Step 6: plan-review（推奨）

変更5ファイル以上/新規ライブラリ/セキュリティ関連の場合に推奨。

### Step 7: 完了→自動進行

`PLAN完了` を表示。ユーザーが続行を確認したら、RED→GREEN→REFACTOR→REVIEWを自動実行。

## Reference

- 詳細: [reference.md](reference.md)
