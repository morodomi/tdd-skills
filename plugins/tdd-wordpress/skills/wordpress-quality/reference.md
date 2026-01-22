# wordpress-quality Reference

SKILL.md の詳細情報。必要時のみ参照。

## PHPStan for WordPress

### phpstan.neon

```neon
includes:
    - vendor/szepeviktor/phpstan-wordpress/extension.neon

parameters:
    level: 6
    paths:
        - wp-content/plugins/my-plugin
        - wp-content/themes/my-theme
    excludePaths:
        - vendor
    bootstrapFiles:
        - vendor/php-stubs/wordpress-stubs/wordpress-stubs.php
```

### 推奨パッケージ

```bash
composer require --dev szepeviktor/phpstan-wordpress php-stubs/wordpress-stubs
```

## WPCS Rules

### phpcs.xml

```xml
<?xml version="1.0"?>
<ruleset name="My Project">
    <description>WordPress Coding Standards</description>

    <rule ref="WordPress">
        <exclude name="WordPress.Files.FileName.InvalidClassFileName"/>
    </rule>

    <rule ref="WordPress-Extra"/>
    <rule ref="WordPress-Docs"/>

    <config name="minimum_supported_wp_version" value="6.0"/>
    <config name="testVersion" value="8.0-"/>

    <file>./wp-content/plugins/my-plugin</file>
    <file>./wp-content/themes/my-theme</file>

    <exclude-pattern>*/vendor/*</exclude-pattern>
    <exclude-pattern>*/node_modules/*</exclude-pattern>
</ruleset>
```

### 推奨パッケージ

```bash
composer require --dev wp-coding-standards/wpcs dealerdirect/phpcodesniffer-composer-installer
```

## Test Patterns

### Custom Post Type Tests

```php
class CPTTest extends WP_UnitTestCase
{
    public function test_cpt_is_registered(): void
    {
        // Given: CPT登録済み
        do_action('init');

        // Then: post_type が存在する
        $this->assertTrue(post_type_exists('my_cpt'));
    }

    public function test_cpt_supports_title(): void
    {
        $supports = get_all_post_type_supports('my_cpt');

        $this->assertArrayHasKey('title', $supports);
    }
}
```

### Shortcode Tests

```php
class ShortcodeTest extends WP_UnitTestCase
{
    public function test_shortcode_output(): void
    {
        // When: ショートコード実行
        $output = do_shortcode('[my_shortcode attr="value"]');

        // Then: 期待する出力
        $this->assertStringContainsString('expected', $output);
    }
}
```

### Admin Notice Tests

```php
class AdminNoticeTest extends WP_UnitTestCase
{
    public function test_notice_displayed_for_admin(): void
    {
        // Given: 管理者としてログイン
        $admin = $this->factory()->user->create(['role' => 'administrator']);
        wp_set_current_user($admin);
        set_current_screen('dashboard');

        // When: admin_notices を実行
        ob_start();
        do_action('admin_notices');
        $output = ob_get_clean();

        // Then: 通知が表示される
        $this->assertStringContainsString('notice', $output);
    }
}
```

## tdd-php との使い分け

| 観点 | tdd-php | tdd-wordpress |
|------|---------|---------------|
| 対象 | 汎用PHP | WordPress固有 |
| 静的解析 | PHPStan基本 | phpstan-wordpress |
| コーディング規約 | PSR-12 | WPCS |
| テスト | PHPUnit基本 | WP_UnitTestCase |
| パターン | なし | Hook, REST API, CPT等 |

## Error Handling

### PHPStan エラー

```
Function get_option not found.
```

**対応**: wordpress-stubs を追加

```bash
composer require --dev php-stubs/wordpress-stubs
```

### WPCS エラー

```
Missing file doc comment
```

**対応**: ファイル先頭にドキュメントブロックを追加

```php
<?php
/**
 * Plugin Name: My Plugin
 *
 * @package MyPlugin
 */
```

### テスト失敗

```
WP_UnitTestCase not found
```

**対応**: wp-phpunit パッケージを追加

```bash
composer require --dev wp-phpunit/wp-phpunit
```
