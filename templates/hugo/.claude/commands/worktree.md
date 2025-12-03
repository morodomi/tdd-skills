---
description: 並行開発環境のセットアップ。git worktree + DB分離で独立した開発環境を作成。issue番号/ブランチ名/自然言語に対応。
---

# Worktree Setup - 並行開発環境

ユーザー入力: $ARGUMENTS

---

## 概要

git worktreeを使用して並行開発環境をセットアップします。

**自動で行うこと**: git worktree作成、DB作成、環境ファイルコピー
**手動で行うこと**: 新しいターミナルでClaude Code起動

---

## Step 1: 入力の解析

「$ARGUMENTS」を解析:

| 入力例 | 判定 | 処理 |
|--------|------|------|
| `42` | issue番号 | GitHub issue #42 を取得 |
| `42 login-api` | issue番号 + 説明 | issue #42、説明をブランチ名に |
| `login-api` | ブランチ名 | そのまま使用 |
| `ログイン機能を追加` | 自然言語 | GitHub issue検索 |
| (空) | なし | ユーザーに質問 |

**判定ロジック**:
- 空 → 目的を質問
- 数字のみ → issue番号
- 数字 + スペース + 英数字 → issue + 説明
- 英数字・ハイフン・アンダースコアのみ → ブランチ名
- それ以外 → 自然言語検索

---

## Step 2: 環境調査

```bash
# Git状態
git branch --show-current
git worktree list
git remote get-url origin 2>/dev/null || echo "no-remote"

# プロジェクト情報
basename $(pwd)
dirname $(pwd)

# Docker構成
ls docker-compose.yml docker-compose.yaml 2>/dev/null
grep -E "mysql|mariadb|postgres" docker-compose.yml 2>/dev/null
```

---

## Step 3: Issue処理

### Issue番号指定時

```bash
gh issue view <番号> --json number,title,state
```

タイトルからブランチ名生成: `feature/42-add-login-endpoint`

### 自然言語検索時

```bash
gh issue list --search "<キーワード>" --json number,title,state --limit 5
```

結果をユーザーに提示して選択させる:

```
以下のissueが見つかりました:
1. #42 ログインページのデザイン変更 (open)
2. #38 ダッシュボードUI改善 (open)
3. 該当なし - 新規ブランチを作成

どれを使用しますか？
```

### ブランチ名直接指定時

そのまま使用: `feature/<指定名>`

---

## Step 4: Worktree作成

```bash
# 例: issue #42, 説明 login-api
BRANCH_NAME="feature/42-login-api"
WORKTREE_DIR="../$(basename $(pwd))-42-login-api"

git worktree add "$WORKTREE_DIR" -b "$BRANCH_NAME"
```

---

## Step 5: DB作成

### MySQL/MariaDB

```bash
DB_NAME="db_42_login_api"
docker compose up -d db
docker compose exec db mysql -uroot -p${MYSQL_ROOT_PASSWORD:-root} \
  -e "CREATE DATABASE IF NOT EXISTS ${DB_NAME};"
```

### PostgreSQL

```bash
DB_NAME="db_42_login_api"
docker compose exec db psql -U ${POSTGRES_USER:-postgres} \
  -c "CREATE DATABASE ${DB_NAME};"
```

### DBなし

スキップ。

---

## Step 6: 環境ファイルコピー

```bash
# .envが存在する場合
if [ -f .env ]; then
  cp .env "$WORKTREE_DIR/.env"
fi

# 他の環境ファイル
for f in .env.local .env.development; do
  [ -f "$f" ] && cp "$f" "$WORKTREE_DIR/$f"
done
```

---

## Step 7: 完了報告

```
================================================
並行開発環境のセットアップ完了
================================================

【環境情報】
  ディレクトリ: /path/to/project-42-login-api
  ブランチ: feature/42-login-api
  DB: db_42_login_api
  Issue: #42 ログインページのデザイン変更

【次のステップ】
  新しいターミナルで:

  cd /path/to/project-42-login-api && claude

  Claude Code起動後:
  /tdd-init

【クリーンアップ（完了後）】
  git checkout main
  git merge feature/42-login-api
  git worktree remove ../project-42-login-api
  docker compose exec db mysql -uroot -proot -e "DROP DATABASE db_42_login_api;"
================================================
```

---

## エラーハンドリング

### gh未インストール

```
警告: gh (GitHub CLI) が必要です。
brew install gh && gh auth login

または、ブランチ名を直接指定:
/worktree login-api
```

### Worktree既存

```
エラー: worktreeが既に存在します。

1. 既存を使用（cd ../project-42 && claude）
2. 削除して再作成
3. 別名で作成

どうしますか？
```

### DB未起動

```
警告: DBコンテナ未起動。

docker compose up -d db

後でDB作成:
docker compose exec db mysql -uroot -proot -e "CREATE DATABASE db_xxx;"
```

---

## 使用例

```bash
/worktree 42                    # issue #42
/worktree 42 login-api          # issue #42 + 説明
/worktree refactor-auth         # ブランチ名直接
/worktree ログイン機能を追加     # 自然言語検索
```

---

*ClaudeSkills - 並行開発支援コマンド*
