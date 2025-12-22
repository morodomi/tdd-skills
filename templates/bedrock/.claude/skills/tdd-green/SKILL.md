---
name: tdd-green
description: REDの次。「実装して」「green」で起動。テストを通す最小実装のみ。
allowed-tools: Read, Write, Edit, Grep, Glob, Bash
---

# TDD GREEN Phase

テストを通すための最小限の実装を行う。

## Checklist

1. [ ] 最新Cycle doc確認
2. [ ] WIPのテストを確認
3. [ ] 最小限の実装を作成
4. [ ] テスト実行→成功確認
5. [ ] Cycle doc更新（WIP→DONE）
6. [ ] REFACTORフェーズへ誘導

## 禁止事項

- 過剰な実装（テストに必要ない機能）
- リファクタリング（REFACTORで行う）
- 新しいテスト作成（REDで行う）

## Workflow

### Step 1: Cycle doc確認

```bash
ls -t docs/cycles/*.md 2>/dev/null | head -1
```

WIPのテストケースを確認。

### Step 2: 最小実装

**原則**: テストを通すために必要な最小限のコードのみ

```php
// ダメな例: 余計な機能を追加
public function login($email, $password, $rememberMe = false) { ... }

// 良い例: テストに必要な分だけ
public function login($email, $password) { ... }
```

### Step 3: テスト実行→成功確認

```bash
# PHP/Laravel
php artisan test --filter=TestName

# Python
pytest tests/test_xxx.py -v
```

**期待**: テストが**成功**すること（GREEN状態）

### Step 4: Cycle doc更新

```markdown
### DONE
- [x] TC-01: [テストケース名] ← GREEN確認済み
```

### Step 5: 次のテストまたはREFACTOR

**Test Listに残りがある場合**: REDフェーズに戻る
**全テスト完了の場合**: REFACTORフェーズへ

```
================================================================================
GREEN完了
================================================================================
テスト成功を確認しました。

次: REFACTORフェーズ（コード改善）
================================================================================
```

## Reference

- 詳細ワークフロー: `reference.md`
