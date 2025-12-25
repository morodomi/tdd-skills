# tdd-init Reference

SKILL.mdの詳細情報。必要時のみ参照。

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
