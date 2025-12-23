---
name: code-review
description: コード変更をレビューする。3観点で並行レビューを実行し、問題を検出。tdd-reviewで自動実行。「code-review」で手動起動も可能。
---

# Code Review

コード変更を3観点で並行レビューし、問題を検出する。

## Progress Checklist

コピーして進捗を追跡:

```
code-review Progress:
- [ ] 対象確認（git diff or 指定ファイル）
- [ ] 並行レビュー実行（3観点）
- [ ] 結果統合
- [ ] 分岐判定（0件/1件以上、ループ確認）
```

## Workflow

### Step 1: 対象確認

```bash
git diff --stat
```

### Step 2: 並行レビュー実行

3観点で並行レビュー:

| 観点 | チェック内容 |
|------|------------|
| **Correctness** | 論理エラー、エッジケース、例外処理 |
| **Performance** | O記法、N+1問題、メモリ使用 |
| **Security** | 入力バリデーション、認証・認可、SQLi/XSS |

### Step 3: 結果統合

Critical/Important/Optionalで分類して出力。

### Step 4: 分岐判定

#### 0件の場合
→ COMMITフェーズへ自動進行

#### 1件以上の場合（1回目）

```
推奨: GREEN に戻って修正

1. GREEN に戻る（推奨）
2. Issue作成して COMMIT
```

#### 1件以上の場合（2回目以降）

```
⚠️ code-review 2回目 - ループ検出
GREEN に戻る選択肢はありません。

1. Issue作成して COMMIT（推奨）
2. このまま COMMIT（自己責任）
```

## Review Log

Cycle docに記録してループを追跡:

```markdown
## Review Log

| 回数 | 日時 | 問題数 | アクション |
|------|------|--------|------------|
| 1 | YYYY-MM-DD HH:MM | X件 | GREEN戻り / Issue→COMMIT |
```

## Reference

- 詳細: [reference.md](reference.md)
