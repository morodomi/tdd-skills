---
name: tdd-commit
description: 変更をGitコミットしてTDDサイクルを完了する。REVIEWの次フェーズ。「コミットして」「commit」で起動。
---

# TDD COMMIT Phase

変更をGitコミットしてTDDサイクルを完了する。

## Progress Checklist

コピーして進捗を追跡:

```
COMMIT Progress:
- [ ] git status で変更確認
- [ ] git diff で差分確認
- [ ] コミットメッセージ生成
- [ ] git add & git commit
- [ ] Cycle doc更新（phase: DONE）
- [ ] docs/STATUS.md 更新
- [ ] サイクル完了
```

## Workflow

### Step 1: 変更確認

```bash
git status
git diff --stat
```

### Step 2: コミットメッセージ生成

**Type**: feat / fix / refactor / test

```
<type>: <subject>

<body>

🤖 Generated with Claude Code

Co-Authored-By: Claude <noreply@anthropic.com>
```

### Step 3: コミット実行

```bash
git add -A
git commit -m "..."
```

### Step 4: Cycle doc更新

phase を DONE に変更。

### Step 5: docs/STATUS.md 更新

```bash
gh issue list --limit 10 --json number,title,labels
ls -t docs/cycles/*.md | head -5
```

STATUS.md を最新状態に更新。

### Step 6: サイクル完了

```
================================================================================
TDDサイクル完了
================================================================================
コミット: [hash]
機能: [機能名]

次: git push / tdd-init で新サイクル開始
================================================================================
```

## Reference

- 詳細: [reference.md](reference.md)
- Gitコンベンション: `agent_docs/git_conventions.md`
