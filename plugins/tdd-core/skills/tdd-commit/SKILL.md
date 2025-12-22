---
name: tdd-commit
description: REVIEWの次。「コミットして」で起動。変更をGitコミット。
allowed-tools: Read, Write, Grep, Glob, Bash
---

# TDD COMMIT Phase

変更をGitコミットしてTDDサイクルを完了する。

## Checklist

1. [ ] git status で変更確認
2. [ ] git diff で差分確認
3. [ ] コミットメッセージ生成
4. [ ] git add & git commit
5. [ ] Cycle doc更新（phase: DONE）
6. [ ] docs/STATUS.md 更新
7. [ ] サイクル完了

## Workflow

### Step 1: 変更確認

```bash
git status
git diff --stat
```

### Step 2: コミットメッセージ生成

**フォーマット**:
```
<type>: <subject>

<body>

🤖 Generated with Claude Code

Co-Authored-By: Claude <noreply@anthropic.com>
```

**Type**:
- `feat`: 新機能
- `fix`: バグ修正
- `refactor`: リファクタリング
- `test`: テスト追加

### Step 3: コミット実行

```bash
git add -A
git commit -m "$(cat <<'EOF'
feat: [機能名]

- [変更内容1]
- [変更内容2]

🤖 Generated with Claude Code

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
```

### Step 4: Cycle doc更新

```markdown
---
phase: DONE
---

### YYYY-MM-DD HH:MM - COMMIT
- コミット完了: [commit hash]
```

### Step 5: docs/STATUS.md 更新

GitHub Issuesとサイクル状況を取得し、STATUS.mdを更新:

```bash
# Issues取得
gh issue list --limit 10 --json number,title,labels

# 完了したサイクル取得
ls -t docs/cycles/*.md | head -5
```

**STATUS.md フォーマット**:

```markdown
# Project Status

最終更新: YYYY-MM-DD HH:MM

## 進行中

なし（または現在のサイクル名）

## バックログ

| # | タイトル | ラベル |
|---|---------|--------|
| 12 | ユーザー登録機能 | enhancement |
| 15 | パスワードリセット | enhancement |

## 最近完了

- [機能名] (YYYY-MM-DD) - commit hash

---

*このファイルは tdd-commit で自動更新されます*
```

### Step 6: サイクル完了

```
================================================================================
TDDサイクル完了
================================================================================
コミット: [hash]
機能: [機能名]

次のステップ:
- git push（必要に応じて）
- 新しい機能: tdd-init で新サイクル開始
================================================================================
```

## Reference

- 詳細ワークフロー: `reference.md`
- Gitコンベンション: `agent_docs/git_conventions.md`
