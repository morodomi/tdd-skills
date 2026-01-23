# tdd-init Reference

SKILL.mdの詳細情報。必要時のみ参照。

## リスクスコア判定の詳細

### スコア閾値（plan-review/quality-gateと統一）

| スコア | 判定 | アクション |
|--------|------|-----------|
| 0-29 | PASS | 確認表示のみで自動進行 |
| 30-59 | WARN | スコープ確認（Step 5） |
| 60-100 | BLOCK | 詳細質問で深掘り |

### キーワード別スコア

| カテゴリ | キーワード | スコア |
|----------|-----------|--------|
| セキュリティ | ログイン, 認証, 認可, パスワード, セッション, 権限, トークン | +60 |
| 外部依存 | API, 外部連携, 決済, webhook, サードパーティ | +60 |
| データ影響 | DB変更, マイグレーション, スキーマ, テーブル追加 | +60 |
| 影響範囲 | リファクタリング, 大規模, 全体, アーキテクチャ | +40 |
| 限定的 | テスト追加, ドキュメント, コメント, README | +10 |
| 見た目のみ | UI修正, 色, 文言, typo, CSS, スタイル | +10 |
| デフォルト | 上記以外 | +30 |

### 判定ロジック

```
1. ユーザー入力をキーワードで部分一致検索
2. 該当キーワードのスコアを合算（上限100）
3. 該当なしはデフォルト30（WARN）
```

### BLOCK（60以上）時の詳細質問

AskUserQuestion で以下を確認:

```yaml
questions:
  - question: "影響範囲はどの程度ですか？"
    header: "Scope"
    options:
      - label: "1-2ファイル"
        description: "小規模な変更"
      - label: "3-5ファイル"
        description: "中規模な変更"
      - label: "6ファイル以上"
        description: "大規模な変更"
    multiSelect: false
  - question: "外部依存はありますか？"
    header: "Dependencies"
    options:
      - label: "なし"
        description: "内部コードのみ"
      - label: "DB変更あり"
        description: "マイグレーション必要"
      - label: "外部API連携"
        description: "サードパーティAPI使用"
    multiSelect: true
```

### Cycle docへの記録形式

```markdown
## Environment

### Scope
- Layer: Backend
- Plugin: tdd-php
- Risk: 65 (BLOCK)  # ← スコア形式

### Risk Details（BLOCK時のみ）
- 検出キーワード: 認証, API
- 合計スコア: 65（認証+60, 重複なし）
- 影響範囲: 3-5ファイル
- 外部依存: DB変更あり
```

## 詳細ワークフロー

### 既存サイクル確認の詳細

```bash
# 最新のCycle docを検索
ls -t docs/cycles/*.md 2>/dev/null | head -1
```

**進行中サイクルがある場合**:

```
⚠️ 既存のTDDサイクルが進行中です。

最新: docs/cycles/20251028_1530_XXX.md

選択肢:
1. [推奨] 既存サイクルを継続
2. 新規サイクルを開始（並行開発）

どうしますか？
```

### スコープ（Layer）確認の詳細

AskUserQuestion で確認:

```
この機能のスコープを選択してください:
1. Backend（PHP/Python サーバーサイド）
2. Frontend（JavaScript/TypeScript クライアントサイド）
3. Both（フルスタック）
```

**プラグインマッピング:**

| Layer | Framework | Plugin |
|-------|-----------|--------|
| Backend | Laravel | tdd-php |
| Backend | Flask | tdd-flask |
| Backend | Django | tdd-python |
| Backend | WordPress | tdd-php |
| Backend | Generic PHP | tdd-php |
| Backend | Generic Python | tdd-python |
| Frontend | JavaScript | tdd-js |
| Frontend | TypeScript | tdd-ts |
| Frontend | Alpine.js | tdd-js |
| Both | Laravel + JS | tdd-php, tdd-js |

**Cycle doc への記録:**

```markdown
## Environment

### Scope
- Layer: Backend
- Plugin: tdd-php
```

### 機能名生成の詳細

**ガイドライン**:
- 10〜20文字程度
- 「〜機能」「〜追加」などの接尾辞

**例**:
| やりたいこと | 機能名 |
|------------|--------|
| ユーザーがログインできるようにしたい | ユーザーログイン機能 |
| データをCSV形式でエクスポートしたい | CSVエクスポート機能 |
| 検索機能を追加したい | 検索機能追加 |
| パスワードリセットメールを送信する | パスワードリセット機能 |

**不明確な場合**:

```
機能名をより具体的に教えてください。

良い例: ユーザー認証機能、データ検索機能
悪い例: 機能、新しいやつ、あれ
```

## Error Handling

### Gitリポジトリでない場合

```
⚠️ このディレクトリはGitリポジトリではありません。

TDDサイクルの完了時にコミット操作が必要になるため、
Gitリポジトリでの使用を推奨します。

続行しますか？
```

### ディレクトリ作成失敗

```
エラー: docs/cycles ディレクトリの作成に失敗しました。

対応:
1. 権限確認: ls -la ./
2. 手動作成: mkdir -p docs/cycles
```

## プロジェクト固有のカスタマイズ

### 検証の追加例

```bash
# Node.js
if [ ! -f "package.json" ]; then
  echo "警告: package.json が見つかりません"
fi

# Python
if [ ! -f "requirements.txt" ]; then
  echo "警告: requirements.txt が見つかりません"
fi
```

### Cycle docテンプレートの拡張

プロジェクト固有のセクションを `templates/cycle.md` に追加可能。
