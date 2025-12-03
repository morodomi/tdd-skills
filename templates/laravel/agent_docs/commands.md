# Laravel Commands

## テスト

```bash
# すべてのテスト実行
php artisan test

# 特定のテストファイル
php artisan test tests/Feature/UserTest.php

# 特定のテストメソッド
php artisan test --filter=user_can_login

# 失敗時に停止
php artisan test --stop-on-failure

# 並列実行
php artisan test --parallel
```

## カバレッジ

```bash
# ターミナル表示
php artisan test --coverage

# HTML レポート
php artisan test --coverage-html=coverage

# 最低カバレッジを強制
php artisan test --coverage --min=80
```

## 静的解析

```bash
# PHPStan 実行
vendor/bin/phpstan analyse

# 特定ディレクトリ
vendor/bin/phpstan analyse app tests

# メモリ制限
vendor/bin/phpstan analyse --memory-limit=1G
```

## コードフォーマット

```bash
# 自動修正
vendor/bin/pint

# チェックのみ
vendor/bin/pint --test

# 変更ファイルのみ
vendor/bin/pint --dirty
```

## Artisan（よく使うもの）

```bash
# モデル作成
php artisan make:model User -mfc

# コントローラ作成
php artisan make:controller UserController --resource

# マイグレーション
php artisan migrate
php artisan migrate:fresh --seed

# キャッシュクリア
php artisan cache:clear
php artisan config:clear
php artisan route:clear
```

## Composer

```bash
# 依存関係インストール
composer install

# 開発依存のみ更新
composer update --dev

# オートロード再生成
composer dump-autoload
```

## 一括品質チェック

```bash
# すべてのチェックを実行
composer check

# または個別に
php artisan test && vendor/bin/phpstan analyse && vendor/bin/pint --test
```
