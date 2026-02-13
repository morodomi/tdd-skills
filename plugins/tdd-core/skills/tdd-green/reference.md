# tdd-green Reference

SKILL.mdの詳細情報。必要時のみ参照。

## 並列実行アーキテクチャ

### 概要

GREENフェーズはTest Listの複数テストを並列エージェントで実装する。

```
tdd-green（オーケストレーター）
├─ Step 1: Cycle doc確認、WIPテスト抽出
├─ Step 2: ファイル依存関係分析（同一ファイル→同一worker）
├─ Step 3: green-worker並列起動（Taskツール）
├─ Step 4: 結果収集・マージ
└─ Step 5: 全テスト実行→成功確認
```

### ファイル依存関係分析

テストケースが編集するファイルを特定し、同一ファイルは同一workerに集約:

```
TC-01: src/Auth/Login.php を編集
TC-02: src/Auth/Login.php を編集
TC-03: src/User/Profile.php を編集

→ Worker A: TC-01, TC-02 (Login.php担当)
→ Worker B: TC-03 (Profile.php担当)
```

### green-worker起動例

```
Taskツールで並列起動:

Task 1 (tdd-core:green-worker):
  prompt: "TC-01, TC-02を実装。対象: src/Auth/Login.php"

Task 2 (tdd-core:green-worker):
  prompt: "TC-03を実装。対象: src/User/Profile.php"
```

## 競合解決戦略

### ファイル単位分担

**原則**: 同一ファイルを複数workerが同時に編集しない

| シナリオ | 対応 |
|----------|------|
| 同一ファイル | 同一workerに集約 |
| 異なるファイル | 並列実行可能 |
| 共通依存 | 先に依存を実装、後で本体 |

### エラーハンドリング

| 状況 | 対応 |
|------|------|
| 1 worker失敗 | 該当workerのみ再試行 |
| 複数worker失敗 | 依存関係を確認し順次再試行 |
| 全worker失敗 | 設計を見直し（PLANに戻る） |

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

## シーケンシャル実行（フォールバック）

並列実行が不適切な場合（単一ファイル、依存関係複雑）はシーケンシャルに実行:

```
GREEN Progress (Sequential):
- [ ] Cycle doc確認
- [ ] WIPのテストを確認
- [ ] 最小限の実装を作成
- [ ] テスト実行→成功確認
- [ ] Cycle doc更新（WIP→DONE）
```

## Phase Completion

GREENフェーズ完了後の圧縮ガイダンス。

### チェックリスト

- [ ] 全テストが成功（GREEN状態）
- [ ] Cycle doc の WIP が DONE に移動済み

上記が確認できたら、コンテキスト圧縮が可能です。
テストコードと実装コードがファイルに保存済みのため、REFACTOR は差分ベースで再開できます。

## Error Handling

### テストが失敗し続ける場合

```
テストが失敗しています。

確認:
1. REDフェーズのテストが正しいか
2. 実装のロジックが正しいか
3. 環境設定に問題がないか
```

### 過剰実装の警告

```
実装がテストの範囲を超えています。

GREENフェーズでは、テストを通す最小限の実装のみ行ってください。
追加機能はREFACTORフェーズまたは次のサイクルで実装します。
```
