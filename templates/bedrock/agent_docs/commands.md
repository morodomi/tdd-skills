# Bedrock/WordPress Commands

## テスト

```bash
# すべてのテスト実行
vendor/bin/phpunit

# 特定のテストファイル
vendor/bin/phpunit tests/Unit/HelperTest.php

# 特定のテストメソッド
vendor/bin/phpunit --filter=test_format_price

# 失敗時に停止
vendor/bin/phpunit --stop-on-failure
```

## カバレッジ

```bash
# ターミナル表示
vendor/bin/phpunit --coverage-text

# HTML レポート
vendor/bin/phpunit --coverage-html=coverage

# 最低カバレッジを強制
vendor/bin/phpunit --coverage-text --coverage-min=80
```

## 静的解析

```bash
# PHPStan 実行
vendor/bin/phpstan analyse

# メモリ制限
vendor/bin/phpstan analyse --memory-limit=1G

# ベースライン生成
vendor/bin/phpstan analyse --generate-baseline
```

## コーディング規約

```bash
# PHPCS チェック
vendor/bin/phpcs --standard=WordPress-Extra .

# 自動修正
vendor/bin/phpcbf --standard=WordPress-Extra .

# 特定ディレクトリ
vendor/bin/phpcs --standard=WordPress-Extra web/app/themes/theme-name
```

## WP-CLI（よく使うもの）

```bash
# プラグイン管理
wp plugin list
wp plugin activate plugin-name
wp plugin deactivate plugin-name

# テーマ管理
wp theme list
wp theme activate theme-name

# データベース
wp db export backup.sql
wp db import backup.sql

# キャッシュクリア
wp cache flush
wp transient delete --all

# リライトルール
wp rewrite flush
```

## Composer

```bash
# 依存関係インストール
composer install

# WordPress更新
composer update roots/wordpress

# プラグイン追加（wpackagist）
composer require wpackagist-plugin/plugin-name

# オートロード再生成
composer dump-autoload
```

## 一括品質チェック

```bash
# すべてのチェックを実行
composer check

# または個別に
vendor/bin/phpunit && vendor/bin/phpstan analyse && vendor/bin/phpcs --standard=WordPress-Extra .
```

## 開発環境

```bash
# Bedrockサーバー起動（Valet使用時）
valet link project-name
valet secure project-name

# ローカルサーバー
php -S localhost:8000 -t web
```
