---
name: tdd-green
description: テストを通すための最小限の実装を行う。REDの次フェーズ。「実装して」「green」で起動。
---

# TDD GREEN Phase

テストを通すための最小限の実装を行う。

## Progress Checklist

コピーして進捗を追跡:

```
GREEN Progress:
- [ ] 最新Cycle doc確認
- [ ] WIPのテストを確認
- [ ] 最小限の実装を作成
- [ ] テスト実行→成功確認
- [ ] Cycle doc更新（WIP→DONE）
- [ ] REFACTORフェーズへ誘導
```

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

### Step 3: テスト実行→成功確認

```bash
php artisan test --filter=TestName  # PHP
pytest tests/test_xxx.py -v          # Python
```

**期待**: テストが**成功**すること（GREEN状態）

### Step 4: 次のテストまたはREFACTOR

- Test Listに残りあり → REDフェーズに戻る
- 全テスト完了 → REFACTORフェーズへ

```
================================================================================
GREEN完了
================================================================================
テスト成功を確認しました。
次: REFACTORフェーズ（コード改善）
================================================================================
```

## Reference

- 詳細: [reference.md](reference.md)
