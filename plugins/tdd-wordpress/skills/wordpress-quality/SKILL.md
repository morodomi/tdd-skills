---
name: wordpress-quality
description: WordPress品質チェック。PHPStan/WPCS/PHPUnit実行時に使用。「WordPressの品質チェック」「WP テスト」で起動。
allowed-tools: Bash, Read, Grep, Glob
---

# WordPress Quality Check

WordPress/Bedrock プロジェクト固有の品質チェックツール。

汎用PHPツールは tdd-php 参照。

## Commands

| ツール | コマンド | 用途 |
|--------|---------|------|
| PHPStan | `./vendor/bin/phpstan analyse` | 静的解析（phpstan-wordpress） |
| WPCS | `./vendor/bin/phpcs --standard=WordPress` | コーディング規約 |
| PHPUnit | `./vendor/bin/phpunit` | テスト実行 |

## WP_UnitTestCase Helpers

| ヘルパー | 用途 |
|---------|------|
| `$this->factory()->user->create()` | ユーザー作成 |
| `$this->factory()->post->create()` | 投稿作成 |
| `$this->go_to($url)` | URL遷移シミュレート |
| `wp_set_current_user($id)` | 現在ユーザー設定 |

## Test Categories

### Unit vs Integration

| カテゴリ | 対象 | 例 |
|---------|------|-----|
| Unit | 単一クラス、フック不使用 | Helper, Utility |
| Integration | WordPress環境依存 | Hook, REST API, CPT |

### テスト配置

```
tests/
├── unit/           # 単体テスト（WP不要）
│   └── HelperTest.php
└── integration/    # 統合テスト（WP必要）
    ├── HookTest.php
    └── RestApiTest.php
```

## Hook Tests

```php
class HookTest extends WP_UnitTestCase
{
    public function test_filter_modifies_content(): void
    {
        add_filter('the_content', 'my_content_filter');
        $result = apply_filters('the_content', 'Hello');
        $this->assertStringContainsString('Modified', $result);
    }
}
```

## REST API Tests

```php
class RestApiTest extends WP_UnitTestCase
{
    public function test_get_items(): void
    {
        $admin = $this->factory()->user->create(['role' => 'administrator']);
        wp_set_current_user($admin);
        $request = new WP_REST_Request('GET', '/wp/v2/posts');
        $response = rest_do_request($request);
        $this->assertEquals(200, $response->get_status());
    }
}
```

## Quality Standards

| 項目 | 目標 |
|------|------|
| PHPStan Level | 6+（phpstan-wordpress） |
| カバレッジ | 90%+ |
| WPCS | エラー0 |

## Reference

- 詳細: [reference.md](reference.md)
- 汎用PHP: tdd-php プラグイン
