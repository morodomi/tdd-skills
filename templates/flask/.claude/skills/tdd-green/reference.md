# tdd-green Reference

SKILL.mdの詳細情報。必要時のみ参照。

## 最小実装の原則

### YAGNI (You Aren't Gonna Need It)

テストが要求していない機能は実装しない。

**ダメな例**:
```php
// テストはログインのみ要求
public function login($email, $password, $rememberMe = false, $twoFactor = null) {
    // 2FAの実装... ← テストが要求していない
}
```

**良い例**:
```php
public function login($email, $password) {
    // テストを通すために必要な最小限の実装
}
```

### ハードコード許容

初期実装ではハードコードも許容。REFACTORで改善。

```php
// GREEN段階: ハードコードでOK
public function getWelcomeMessage() {
    return "Welcome!";  // テストを通すだけ
}

// REFACTOR段階: 改善
public function getWelcomeMessage() {
    return $this->translator->get('welcome');
}
```

## Error Handling

### テストが失敗し続ける場合

```
⚠️ テストが失敗しています。

確認:
1. REDフェーズのテストが正しいか
2. 実装のロジックが正しいか
3. 環境設定に問題がないか
```

### 過剰実装の警告

```
⚠️ 実装がテストの範囲を超えています。

GREENフェーズでは、テストを通す最小限の実装のみ行ってください。
追加機能はREFACTORフェーズまたは次のサイクルで実装します。
```
