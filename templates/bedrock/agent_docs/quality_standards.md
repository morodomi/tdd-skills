# Bedrock/WordPress Quality Standards

## テストカバレッジ

| 指標 | 値 |
|------|-----|
| 目標 | 90%以上 |
| 最低ライン | 80% |

### 測定コマンド

```bash
# カバレッジレポート（ターミナル）
vendor/bin/phpunit --coverage-text

# カバレッジレポート（HTML）
vendor/bin/phpunit --coverage-html=coverage

# 最低カバレッジを強制
vendor/bin/phpunit --coverage-text --coverage-min=80
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

# WordPress stubs を使用
vendor/bin/phpstan analyse -c phpstan.neon
```

### 設定ファイル（phpstan.neon）

```neon
includes:
    - vendor/szepeviktor/phpstan-wordpress/extension.neon

parameters:
    level: 8
    paths:
        - web/app/themes/theme-name
        - web/app/plugins/plugin-name
    excludePaths:
        - vendor
        - web/wp
    bootstrapFiles:
        - vendor/php-stubs/wordpress-stubs/wordpress-stubs.php
```

---

## コードフォーマット（PHPCS + WPCS）

| 指標 | 値 |
|------|-----|
| 規約 | WordPress Coding Standards |
| プリセット | WordPress-Extra |

### 実行コマンド

```bash
# チェック
vendor/bin/phpcs --standard=WordPress-Extra .

# 自動修正
vendor/bin/phpcbf --standard=WordPress-Extra .

# 特定ディレクトリ
vendor/bin/phpcs --standard=WordPress-Extra web/app/themes/theme-name
```

### 設定ファイル（phpcs.xml）

```xml
<?xml version="1.0"?>
<ruleset name="Project">
    <rule ref="WordPress-Extra"/>
    <rule ref="WordPress-Docs"/>

    <file>web/app/themes/theme-name</file>
    <file>web/app/plugins/plugin-name</file>

    <exclude-pattern>vendor/*</exclude-pattern>
    <exclude-pattern>web/wp/*</exclude-pattern>
</ruleset>
```

---

## セキュリティチェック

### 必須項目

1. **入力のサニタイズ**: `sanitize_text_field()`, `sanitize_email()` 等
2. **出力のエスケープ**: `esc_html()`, `esc_attr()`, `esc_url()` 等
3. **Nonce検証**: `wp_nonce_field()`, `wp_verify_nonce()`
4. **権限チェック**: `current_user_can()`
5. **SQLインジェクション防止**: `$wpdb->prepare()`

### チェックコマンド

```bash
# セキュリティルールのみチェック
vendor/bin/phpcs --standard=WordPress-VIP-Go .
```

---

## 品質チェックの実行順序

```bash
# 1. テスト実行
vendor/bin/phpunit

# 2. カバレッジ確認
vendor/bin/phpunit --coverage-text --coverage-min=80

# 3. 静的解析
vendor/bin/phpstan analyse

# 4. コーディング規約
vendor/bin/phpcs --standard=WordPress-Extra .
```

### Composer スクリプト（推奨）

```json
{
    "scripts": {
        "test": "vendor/bin/phpunit",
        "coverage": "vendor/bin/phpunit --coverage-text --coverage-min=80",
        "stan": "vendor/bin/phpstan analyse",
        "cs": "vendor/bin/phpcs --standard=WordPress-Extra .",
        "cs-fix": "vendor/bin/phpcbf --standard=WordPress-Extra .",
        "check": [
            "@test",
            "@stan",
            "@cs"
        ]
    }
}
```

---

*すべての品質基準を満たしてからコミットしてください*
