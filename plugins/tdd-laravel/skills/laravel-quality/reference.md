# laravel-quality Reference

SKILL.md の詳細情報。必要時のみ参照。

## Larastan Configuration

### phpstan.neon

```neon
includes:
    - ./vendor/nunomaduro/larastan/extension.neon

parameters:
    level: 8
    paths:
        - app
        - tests
    excludePaths:
        - vendor
```

### 推奨ルール

| ルール | 説明 |
|--------|------|
| `checkModelProperties` | Eloquent属性の型チェック |
| `checkOctaneCompatibility` | Octane互換性チェック |

## Test Patterns

### Mocking Facades

```php
use Illuminate\Support\Facades\Mail;

it('sends welcome email', function () {
    Mail::fake();

    $this->post('/register', [
        'email' => 'test@example.com',
    ]);

    Mail::assertSent(WelcomeEmail::class);
});
```

### Mocking Eloquent

```php
use Mockery;

it('calculates total', function () {
    $order = Mockery::mock(Order::class);
    $order->shouldReceive('getTotal')->andReturn(1000);

    expect($order->getTotal())->toBe(1000);
});
```

### Queue Testing

```php
use Illuminate\Support\Facades\Queue;

it('dispatches job', function () {
    Queue::fake();

    $this->post('/orders', ['item' => 'test']);

    Queue::assertPushed(ProcessOrder::class);
});
```

### Event Testing

```php
use Illuminate\Support\Facades\Event;

it('fires event on create', function () {
    Event::fake();

    User::factory()->create();

    Event::assertDispatched(UserCreated::class);
});
```

## tdd-php との使い分け

| 観点 | tdd-php | tdd-laravel |
|------|---------|-------------|
| 対象 | 汎用PHP | Laravel固有 |
| 静的解析 | PHPStan基本 | Larastan拡張 |
| テスト | PHPUnit/Pest基本 | Pest Laravel helpers |
| パターン | なし | HTTP, Facade Mock等 |

## Error Handling

### Larastan エラー

```
Property App\Models\User::$name has no type specified.
```

**対応**: Model に `@property` を追加

```php
/**
 * @property string $name
 * @property string $email
 */
class User extends Model
```

### テスト失敗

```
Expected status code 200 but received 401.
```

**対応**: `actingAs()` で認証済みユーザーを設定

```php
$this->actingAs(User::factory()->create())
    ->get('/api/users')
    ->assertStatus(200);
```
