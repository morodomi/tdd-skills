# Bedrock/WordPress Testing Guide

## テストディレクトリ構造

```
tests/
├── Unit/              # 純粋なロジック（WordPress非依存）
│   └── *Test.php
├── Integration/       # WordPress統合テスト
│   └── *Test.php
├── bootstrap.php      # テスト初期化
└── wp-tests-config.php # WordPress テスト設定
```

---

## テストの書き方

### Unit テスト（WordPress非依存）

```php
<?php

namespace Tests\Unit;

use PHPUnit\Framework\TestCase;
use PHPUnit\Framework\Attributes\Test;

class HelperFunctionTest extends TestCase
{
    #[Test]
    public function format_price_returns_formatted_string(): void
    {
        // Given: 価格
        $price = 1000;

        // When: フォーマット
        $result = format_price($price);

        // Then: 正しいフォーマット
        $this->assertSame('$1,000', $result);
    }
}
```

### Integration テスト（WordPress依存）

```php
<?php

namespace Tests\Integration;

use WP_UnitTestCase;
use PHPUnit\Framework\Attributes\Test;

class PostMetaTest extends WP_UnitTestCase
{
    #[Test]
    public function can_save_custom_meta(): void
    {
        // Given: 投稿を作成
        $post_id = $this->factory->post->create();

        // When: メタデータを保存
        update_post_meta($post_id, 'custom_key', 'custom_value');

        // Then: メタデータが取得できる
        $this->assertSame(
            'custom_value',
            get_post_meta($post_id, 'custom_key', true)
        );
    }
}
```

---

## Brain Monkey（モック）

```php
<?php

namespace Tests\Unit;

use Brain\Monkey;
use Brain\Monkey\Functions;
use PHPUnit\Framework\TestCase;
use PHPUnit\Framework\Attributes\Test;

class PluginTest extends TestCase
{
    protected function setUp(): void
    {
        parent::setUp();
        Monkey\setUp();
    }

    protected function tearDown(): void
    {
        Monkey\tearDown();
        parent::tearDown();
    }

    #[Test]
    public function get_option_returns_default(): void
    {
        // Given: get_option をモック
        Functions\when('get_option')
            ->justReturn('default_value');

        // When
        $result = get_option('my_option');

        // Then
        $this->assertSame('default_value', $result);
    }
}
```

---

## 命名規則

- ファイル名: `*Test.php`
- クラス名: `*Test`
- メソッド名: `snake_case`
- `#[Test]` 属性を使用

---

## よく使うアサーション

```php
// 値の検証
$this->assertSame($expected, $actual);
$this->assertTrue($condition);
$this->assertNull($value);

// WordPress固有
$this->assertSame($expected, get_option('option_name'));
$this->assertNotEmpty(get_post_meta($post_id, 'key', true));

// ファクトリ
$post_id = $this->factory->post->create();
$user_id = $this->factory->user->create(['role' => 'administrator']);
```

---

## セキュリティテスト

```php
#[Test]
public function input_is_sanitized(): void
{
    // Given: 悪意のある入力
    $input = '<script>alert("xss")</script>';

    // When: サニタイズ
    $result = sanitize_text_field($input);

    // Then: スクリプトが除去される
    $this->assertSame('alert("xss")', $result);
}

#[Test]
public function nonce_is_verified(): void
{
    // Given: 無効なnonce
    $_POST['_wpnonce'] = 'invalid';

    // When & Then: 検証失敗
    $this->assertFalse(wp_verify_nonce($_POST['_wpnonce'], 'my_action'));
}
```

---

*詳細: https://developer.wordpress.org/plugins/testing/*
