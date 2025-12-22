# tdd-refactor Reference

SKILL.mdの詳細情報。必要時のみ参照。

## リファクタリングパターン

### DRY (Don't Repeat Yourself)

```php
// Before: 重複
$user->name = ucfirst(strtolower($input['name']));
$user->email = strtolower($input['email']);

// After: 共通化
private function normalize(string $value): string {
    return ucfirst(strtolower($value));
}
```

### 定数化

```php
// Before: マジックナンバー
if ($attempts > 5) { ... }

// After: 定数
const MAX_LOGIN_ATTEMPTS = 5;
if ($attempts > self::MAX_LOGIN_ATTEMPTS) { ... }
```

### メソッド分割

```php
// Before: 長いメソッド
public function processOrder() {
    // 50行のコード...
}

// After: 分割
public function processOrder() {
    $this->validateOrder();
    $this->calculateTotal();
    $this->applyDiscounts();
    $this->saveOrder();
}
```

## Error Handling

### テストが壊れた場合

```
⚠️ リファクタリング後、テストが失敗しました。

対応:
1. 変更を元に戻す (git checkout)
2. 小さな単位でリファクタリングをやり直す
3. 各変更後にテストを実行
```

### リファクタリング範囲が大きすぎる場合

```
⚠️ リファクタリングの範囲が大きすぎます。

推奨:
1. 1つの改善項目に絞る
2. テストを実行して確認
3. 次の改善項目へ
```
