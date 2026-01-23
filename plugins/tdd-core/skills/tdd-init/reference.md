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
| デフォルト | 上記以外 | 0 |

### 判定ロジック

```
1. ユーザー入力をキーワードで部分一致検索
2. 同一カテゴリ内は最大1回のみ加算（重複なし）
3. 異なるカテゴリは合算（上限100）
4. 該当なしはデフォルト0（PASS）

計算例:
- 「typo修正」= +10 → PASS
- 「バグ修正」= 0 → PASS（キーワードなし）
- 「リファクタリング」= +40 → WARN
- 「認証機能」= +60 → BLOCK
- 「認証+パスワード」= +60 → BLOCK（同一カテゴリ）
- 「認証+API」= +100 → BLOCK（異カテゴリ合算、上限）
```

### 複数リスクタイプ該当時の処理

複数カテゴリに該当する場合、**全てのリスクタイプの質問を順次実行**する。

```
例: 「ログイン機能でAPI連携してDBも変更」
→ セキュリティ質問（認証方式、2FA等）
→ 外部連携質問（API認証、エラー処理等）
→ データ変更質問（既存データ影響、ロールバック等）
```

Cycle docには全ての回答を記録する。

### BLOCK（60以上）時のリスクタイプ別質問

検出キーワードに応じて、以下のAskUserQuestionを実行:

#### セキュリティ関連（ログイン, 認証, 権限, パスワード）

```yaml
questions:
  - question: "認証方式はどれを使用しますか？"
    header: "Auth"
    options:
      - label: "セッション"
        description: "サーバーサイドセッション管理"
      - label: "JWT"
        description: "トークンベース認証"
      - label: "OAuth"
        description: "外部プロバイダ連携"
      - label: "既存拡張"
        description: "現行認証システムを拡張"
    multiSelect: false
  - question: "対象ユーザーは？"
    header: "Users"
    options:
      - label: "一般ユーザー"
        description: "通常の利用者"
      - label: "管理者"
        description: "管理機能を持つユーザー"
      - label: "両方"
        description: "権限レベルで分離"
    multiSelect: false
  - question: "2FA（二要素認証）は必要ですか？"
    header: "2FA"
    options:
      - label: "必要"
        description: "初期リリースから実装"
      - label: "不要"
        description: "パスワードのみ"
      - label: "後で検討"
        description: "将来的に追加予定"
    multiSelect: false
```

#### 外部連携関連（API, webhook, 決済, サードパーティ）

```yaml
questions:
  - question: "API認証方式は？"
    header: "API Auth"
    options:
      - label: "APIキー"
        description: "静的なキーで認証"
      - label: "OAuth2"
        description: "トークンベース"
      - label: "署名付きリクエスト"
        description: "HMAC等で署名"
    multiSelect: false
  - question: "エラー処理の方針は？"
    header: "Errors"
    options:
      - label: "リトライ"
        description: "失敗時に再試行"
      - label: "フォールバック"
        description: "代替処理に切り替え"
      - label: "即時エラー"
        description: "ユーザーに通知"
    multiSelect: true  # リトライ+フォールバック併用が一般的なため
  - question: "レート制限への対応は？"
    header: "Rate Limit"
    options:
      - label: "キューイング"
        description: "リクエストをキューで管理"
      - label: "バックオフ"
        description: "指数バックオフで再試行"
      - label: "不要"
        description: "制限に達しない想定"
    multiSelect: false
```

#### データ変更関連（DB, マイグレーション, スキーマ）

```yaml
questions:
  - question: "既存データへの影響は？"
    header: "Data Impact"
    options:
      - label: "影響なし"
        description: "新規テーブル/カラムのみ"
      - label: "データ変換必要"
        description: "既存データのマイグレーション"
      - label: "データ削除あり"
        description: "一部データの削除・統合"
    multiSelect: false
  - question: "ロールバック方法は？"
    header: "Rollback"
    options:
      - label: "自動ロールバック"
        description: "ダウンマイグレーション対応"
      - label: "手動復旧"
        description: "バックアップから復元"
      - label: "前方互換"
        description: "新旧両方で動作"
    multiSelect: false
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
