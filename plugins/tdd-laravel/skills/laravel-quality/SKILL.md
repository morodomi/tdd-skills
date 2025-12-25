---
name: laravel-quality
description: Laravel品質チェック。Pest/Larastan/Pint実行時に使用。「Laravelの品質チェック」「Laravel テスト」で起動。
allowed-tools: Bash, Read, Grep, Glob
---

# Laravel Quality Check

Laravel プロジェクト固有の品質チェックツール。

汎用PHPツールは tdd-php 参照。

## Commands

| ツール | コマンド | 用途 |
|--------|---------|------|
| Pest | `php artisan test` | テスト実行 |
| PHPStan | `./vendor/bin/phpstan analyse` | 静的解析（Larastan） |
| Pint | `./vendor/bin/pint` | コードフォーマット |

## Pest Laravel Helpers

| ヘルパー | 用途 |
|---------|------|
| `actingAs($user)` | 認証ユーザーとして実行 |
| `assertDatabaseHas()` | DB レコード存在確認 |
| `assertDatabaseMissing()` | DB レコード不在確認 |
| `assertRedirect()` | リダイレクト確認 |
| `assertStatus()` | HTTPステータス確認 |

## Test Categories

### Feature vs Unit

| カテゴリ | 対象 | 例 |
|---------|------|-----|
| Feature | HTTPリクエスト、統合 | Controller, API |
| Unit | 単一クラス | Model, Service |

### テスト配置

```
tests/
├── Feature/        # HTTP, 統合テスト
│   ├── Auth/
│   └── Api/
└── Unit/           # 単体テスト
    ├── Models/
    └── Services/
```

## HTTP Tests

```php
it('can list users', function () {
    $user = User::factory()->create();

    $this->actingAs($user)
        ->get('/api/users')
        ->assertStatus(200)
        ->assertJsonStructure(['data' => [['id', 'name']]]);
});
```

## Database Tests

```php
it('can create user', function () {
    $this->post('/api/users', [
        'name' => 'Test',
        'email' => 'test@example.com',
    ])->assertStatus(201);

    $this->assertDatabaseHas('users', [
        'email' => 'test@example.com',
    ]);
});
```

## Quality Standards

| 項目 | 目標 |
|------|------|
| PHPStan Level | 8（Larastan） |
| カバレッジ | 90%+ |
| Pint | エラー0 |

## Reference

- 詳細: [reference.md](reference.md)
- 汎用PHP: tdd-php プラグイン
