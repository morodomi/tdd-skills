---
name: php-quality
description: PHP品質チェック。PHPStan/Pint/PHPUnit実行時に使用。「PHPの品質チェック」「静的解析」で起動。
allowed-tools: Bash, Read, Grep, Glob
---

# PHP Quality Check

PHP プロジェクトの品質チェックツール。

## Commands

| ツール | コマンド | 用途 |
|--------|---------|------|
| PHPStan | `./vendor/bin/phpstan analyse --level=8` | 静的解析 |
| Pint | `./vendor/bin/pint` | コードフォーマット |
| PHPUnit | `./vendor/bin/phpunit` | テスト実行 |
| Pest | `./vendor/bin/pest` | テスト実行（Pest） |
| Laravel | `php artisan test` | Laravelテスト |

## Usage

### 静的解析

```bash
# 基本
./vendor/bin/phpstan analyse

# レベル指定（推奨: 8）
./vendor/bin/phpstan analyse --level=8

# 特定ディレクトリ
./vendor/bin/phpstan analyse src/ tests/
```

### コードフォーマット

```bash
# 自動修正
./vendor/bin/pint

# チェックのみ
./vendor/bin/pint --test
```

### テスト実行

```bash
# 全テスト
./vendor/bin/phpunit

# フィルタ
./vendor/bin/phpunit --filter=TestName

# カバレッジ
./vendor/bin/phpunit --coverage-html=coverage/
```

## Quality Standards

| 項目 | 目標 |
|------|------|
| PHPStan Level | 8（最高） |
| カバレッジ | 90%+ |
| Pint | エラー0 |

## Reference

- 詳細: `reference.md`
