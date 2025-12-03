# Laravel Quality Standards

## テストカバレッジ

| 指標 | 値 |
|------|-----|
| 目標 | 90%以上 |
| 最低ライン | 80% |

### 測定コマンド

```bash
# カバレッジレポート（ターミナル）
php artisan test --coverage

# カバレッジレポート（HTML）
php artisan test --coverage-html=coverage

# 最低カバレッジを強制
php artisan test --coverage --min=80
```

---

## 静的解析（PHPStan）

| 指標 | 値 |
|------|-----|
| レベル | Level 8（最高） |
| エラー許容 | 0件 |

### 実行コマンド

```bash
# 解析実行
vendor/bin/phpstan analyse

# 特定ディレクトリのみ
vendor/bin/phpstan analyse app tests

# ベースライン生成（既存エラーを無視）
vendor/bin/phpstan analyse --generate-baseline
```

### 設定ファイル（phpstan.neon）

```neon
parameters:
    level: 8
    paths:
        - app
        - tests
    excludePaths:
        - vendor
```

---

## コードフォーマット（Laravel Pint）

| 指標 | 値 |
|------|-----|
| 規約 | PSR-12 |
| プリセット | Laravel |

### 実行コマンド

```bash
# フォーマット実行
vendor/bin/pint

# チェックのみ（修正しない）
vendor/bin/pint --test

# 変更されたファイルのみ
vendor/bin/pint --dirty
```

### 設定ファイル（pint.json）

```json
{
    "preset": "laravel",
    "rules": {
        "simplified_null_return": true,
        "blank_line_before_statement": {
            "statements": ["return"]
        }
    }
}
```

---

## 品質チェックの実行順序

```bash
# 1. テスト実行
php artisan test

# 2. カバレッジ確認
php artisan test --coverage --min=80

# 3. 静的解析
vendor/bin/phpstan analyse

# 4. フォーマットチェック
vendor/bin/pint --test
```

### Composer スクリプト（推奨）

```json
{
    "scripts": {
        "test": "php artisan test",
        "coverage": "php artisan test --coverage --min=80",
        "stan": "vendor/bin/phpstan analyse",
        "pint": "vendor/bin/pint",
        "check": [
            "@test",
            "@stan",
            "@pint --test"
        ]
    }
}
```

実行: `composer check`

---

*すべての品質基準を満たしてからコミットしてください*
