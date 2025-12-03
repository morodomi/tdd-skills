# Laravel Testing Guide

## テストディレクトリ構造

```
tests/
├── Unit/           # 純粋なロジック（外部依存なし）
│   └── *Test.php
├── Feature/        # HTTPリクエスト、DB、統合テスト
│   └── *Test.php
└── TestCase.php    # 基底クラス
```

---

## テストの書き方

### 基本構造（PHPUnit）

```php
<?php

namespace Tests\Unit;

use PHPUnit\Framework\TestCase;
use PHPUnit\Framework\Attributes\Test;

class ExampleTest extends TestCase
{
    #[Test]
    public function example_test_case(): void
    {
        // Given: 前提条件
        $value = 1;

        // When: 操作
        $result = $value + 1;

        // Then: 検証
        $this->assertSame(2, $result);
    }
}
```

### Feature テスト

```php
<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use PHPUnit\Framework\Attributes\Test;
use Tests\TestCase;

class UserRegistrationTest extends TestCase
{
    use RefreshDatabase;

    #[Test]
    public function user_can_register_with_valid_data(): void
    {
        // Given: 有効な登録データ
        $data = [
            'name' => 'Test User',
            'email' => 'test@example.com',
            'password' => 'password123',
            'password_confirmation' => 'password123',
        ];

        // When: 登録エンドポイントにPOST
        $response = $this->post('/register', $data);

        // Then: リダイレクトされる
        $response->assertRedirect('/dashboard');

        // And: ユーザーがDBに存在する
        $this->assertDatabaseHas('users', [
            'email' => 'test@example.com',
        ]);
    }
}
```

---

## Pest（オプション）

```php
<?php

use App\Models\User;

test('user can login with valid credentials', function () {
    // Given
    $user = User::factory()->create();

    // When
    $response = $this->post('/login', [
        'email' => $user->email,
        'password' => 'password',
    ]);

    // Then
    $response->assertRedirect('/dashboard');
    $this->assertAuthenticatedAs($user);
});
```

---

## 命名規則

- ファイル名: `*Test.php`
- クラス名: `*Test`
- メソッド名: `snake_case`（例: `user_can_login`）
- `#[Test]` 属性を使用（`test` プレフィックスより推奨）

---

## よく使うアサーション

```php
// 値の検証
$this->assertSame($expected, $actual);
$this->assertTrue($condition);
$this->assertNull($value);

// HTTP レスポンス
$response->assertStatus(200);
$response->assertRedirect('/path');
$response->assertJson(['key' => 'value']);

// データベース
$this->assertDatabaseHas('table', ['column' => 'value']);
$this->assertDatabaseMissing('table', ['column' => 'value']);

// 認証
$this->assertAuthenticated();
$this->assertAuthenticatedAs($user);
```

---

## モック

```php
use Mockery;

#[Test]
public function service_calls_repository(): void
{
    // Given: モックを作成
    $repository = Mockery::mock(UserRepository::class);
    $repository->shouldReceive('find')
        ->once()
        ->with(1)
        ->andReturn(new User(['id' => 1]));

    $service = new UserService($repository);

    // When
    $user = $service->getUser(1);

    // Then
    $this->assertSame(1, $user->id);
}
```

---

*詳細: https://laravel.com/docs/testing*
