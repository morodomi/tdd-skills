# tdd-wordpress

WordPress/Bedrock プロジェクト向けの TDD 品質チェックプラグイン。

## Installation

```bash
claude plugins:add github:morodomi/tdd-skills/plugins/tdd-wordpress
```

## Skills

### wordpress-quality

WordPress 固有の品質チェックツール。

**トリガー**: 「WordPressの品質チェック」「WP テスト」

**ツール**:
- PHPStan + phpstan-wordpress
- WordPress Coding Standards (WPCS)
- PHPUnit + WP_UnitTestCase

## 依存

- **tdd-core**: TDD ワークフロー（必須）
- **tdd-php**: 汎用 PHP 品質チェック（推奨）

## 関連

- [tdd-core](../tdd-core/README.md)
- [tdd-php](../tdd-php/README.md)
