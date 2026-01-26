---
name: tdd-green
description: テストを通すための最小限の実装を行う。REDの次フェーズ。「実装して」「green」で起動。
---

# TDD GREEN Phase

テストを通すための最小限の実装を行う（並列実行がデフォルト）。

## Progress Checklist

```
GREEN Progress:
- [ ] Cycle doc確認、WIPテスト抽出
- [ ] ファイル依存関係分析
- [ ] green-worker並列起動
- [ ] 結果収集・マージ
- [ ] 全テスト実行→成功確認
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

WIPのテストケースを抽出。

### Step 2: ファイル依存関係分析

テストケースを対象ファイル別にグルーピング:

| ファイル | テストケース |
|----------|-------------|
| src/Auth.php | TC-01, TC-02 |
| src/User.php | TC-03 |

**原則**: 同一ファイル→同一workerに割り当て（競合回避）

### Step 3: green-worker並列起動

Taskツールで `tdd-core:green-worker` を並列起動:

```
Task 1: TC-01, TC-02 → src/Auth.php
Task 2: TC-03 → src/User.php
```

### Step 4: 結果収集・マージ

全workerの完了を待ち、結果を統合。失敗時は該当workerのみ再試行。

### Step 5: 全テスト実行→成功確認

```bash
php artisan test  # PHP
pytest            # Python
```

**期待**: 全テストが**成功**すること（GREEN状態）

### Verification Gate

| 結果 | 判定 | アクション |
|------|------|-----------|
| 全テスト成功 | PASS | REFACTORへ自動進行 |
| テスト失敗 | BLOCK | 該当worker再試行 |

### Step 6: 完了→REFACTOR誘導

```
GREEN完了。全テスト成功を確認しました。
次: REFACTORフェーズ（コード改善）
```

## Reference

- 詳細: [reference.md](reference.md)
- green-worker: [../../agents/green-worker.md](../../agents/green-worker.md)
