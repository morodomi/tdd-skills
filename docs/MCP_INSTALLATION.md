# MCP Installation Guide

ClaudeSkills TDDワークフローに必要なMCP（Model Context Protocol）サーバーのインストールガイドです。

## 前提条件

以下がインストール済みであることを確認してください：

| ソフトウェア | 必要バージョン | 確認コマンド |
|------------|--------------|------------|
| Node.js | v18以上 | `node --version` |
| npm | 最新版 | `npm --version` |
| Claude Code | 最新版 | `claude --version` |
| Git | 2.x以上 | `git --version` |

### インストールされていない場合

#### Node.js & npm
```bash
# macOS (Homebrew)
brew install node

# または公式サイトからダウンロード
# https://nodejs.org/
```

#### Claude Code
```bash
# 公式サイトからインストール
# https://claude.ai/download
```

---

## 自動インストール（推奨）

最も簡単な方法は、提供されているインストールスクリプトを使用することです。

### 手順

1. **ClaudeSkillsリポジトリのクローン**（未取得の場合）
   ```bash
   git clone https://github.com/yourusername/ClaudeSkills.git
   cd ClaudeSkills
   ```

2. **インストールスクリプトの実行**
   ```bash
   bash scripts/install-mcp.sh
   ```

3. **インストール確認**
   ```bash
   claude mcp list
   ```

   以下の3つのMCPサーバーが表示されればOKです：
   - `git` - Git操作用
   - `filesystem` - ファイル操作用
   - `github` - GitHub連携用（GITHUB_TOKEN設定時）

### スクリプトの動作

`install-mcp.sh`は以下を自動で行います：

1. 環境チェック（Node.js, npm, claude コマンド）
2. 既存MCPサーバーの確認
3. MCPサーバーの追加（重複回避）
4. インストール結果の表示

---

## 手動インストール

自動スクリプトを使用せず、手動でインストールすることもできます。

### Git MCP

```bash
claude mcp add --transport stdio git -- npx -y @modelcontextprotocol/server-git
```

### Filesystem MCP

```bash
claude mcp add --transport stdio filesystem -- npx -y @modelcontextprotocol/server-filesystem
```

### GitHub MCP

GitHub MCPを使用する場合は、GitHub Personal Access Tokenが必要です。

#### 1. GitHub Tokenの取得

1. GitHubにログイン
2. Settings → Developer settings → Personal access tokens → Tokens (classic)
3. "Generate new token" をクリック
4. 以下のスコープを選択：
   - `repo` (すべてのサブスコープ)
   - `workflow`
5. トークンを生成してコピー

#### 2. 環境変数の設定

```bash
# ~/.zshrc または ~/.bashrc に追加
export GITHUB_TOKEN="your_github_token_here"

# 設定を反映
source ~/.zshrc  # または source ~/.bashrc
```

#### 3. GitHub MCPの追加

```bash
claude mcp add --transport stdio github --env GITHUB_TOKEN=${GITHUB_TOKEN} -- npx -y @modelcontextprotocol/server-github
```

---

## インストール後の確認

### MCPサーバー一覧の表示

```bash
claude mcp list
```

**期待される出力例**:
```
Configured MCP servers:

git (stdio)
  Command: npx -y @modelcontextprotocol/server-git

filesystem (stdio)
  Command: npx -y @modelcontextprotocol/server-filesystem

github (stdio)
  Command: npx -y @modelcontextprotocol/server-github
  Environment:
    GITHUB_TOKEN=***

aws-knowledge (http)
  URL: https://mcp.us-east-1.amazonaws.com/
  (既存のMCPサーバーも表示される)
```

### MCPサーバーの詳細確認

特定のMCPサーバーの詳細を確認：

```bash
claude mcp get git
```

---

## MCPサーバーの管理

### MCPサーバーの削除

```bash
# 特定のMCPサーバーを削除
claude mcp remove git

# 確認
claude mcp list
```

### MCPサーバーの再インストール

```bash
# 削除してから再インストール
claude mcp remove git
claude mcp add --transport stdio git -- npx -y @modelcontextprotocol/server-git
```

---

## トラブルシューティング

### 問題 1: `claude: command not found`

**原因**: Claude Codeがインストールされていない、またはPATHが通っていない

**解決方法**:
```bash
# Claude Codeのインストール確認
which claude

# インストールされていない場合は公式サイトからインストール
# https://claude.ai/download

# PATHを確認
echo $PATH
```

### 問題 2: `npx: command not found`

**原因**: Node.js/npmがインストールされていない

**解決方法**:
```bash
# Node.jsのインストール確認
node --version
npm --version

# インストールされていない場合
brew install node  # macOS
```

### 問題 3: GitHub MCPでエラーが発生

**エラーメッセージ例**:
```
Error: GITHUB_TOKEN environment variable not set
```

**解決方法**:
```bash
# 環境変数が設定されているか確認
echo $GITHUB_TOKEN

# 設定されていない場合
export GITHUB_TOKEN="your_github_token_here"

# 永続化するには ~/.zshrc または ~/.bashrc に追加
echo 'export GITHUB_TOKEN="your_github_token_here"' >> ~/.zshrc
source ~/.zshrc
```

### 問題 4: MCPサーバーが重複してインストールされる

**症状**: `claude mcp list`で同じサーバーが複数表示される

**解決方法**:
```bash
# 重複したMCPサーバーを削除
claude mcp remove git
claude mcp remove git  # 重複分も削除

# 再インストール
claude mcp add --transport stdio git -- npx -y @modelcontextprotocol/server-git

# 確認
claude mcp list
```

### 問題 5: 既存の `.claude/config.json` が上書きされた

**症状**: 既存のMCPサーバー設定が消えた

**解決方法**:

`claude mcp add`コマンドは既存設定を保持するため、通常は発生しません。もし発生した場合：

```bash
# バックアップから復元（もしあれば）
cp .claude/config.json.backup .claude/config.json

# または手動で再設定
claude mcp add --transport stdio your-server -- your-command
```

**予防策**:
```bash
# 重要な設定は事前にバックアップ
cp ~/.claude/config.json ~/.claude/config.json.backup
```

### 問題 6: インストールスクリプトが失敗する

**エラーメッセージを確認**:
```bash
bash scripts/install-mcp.sh 2>&1 | tee install-log.txt
```

**一般的な原因**:
- 権限エラー → スクリプトに実行権限を付与: `chmod +x scripts/install-mcp.sh`
- ネットワークエラー → インターネット接続を確認
- パッケージエラー → npm キャッシュをクリア: `npm cache clean --force`

---

## セキュリティに関する注意事項

### GitHub Tokenの管理

1. **環境変数を使用**: `.claude/config.json`にトークンを直接記述しない
2. **最小権限**: 必要最小限のスコープのみ付与
3. **定期的なローテーション**: トークンを定期的に再生成
4. **リポジトリにコミットしない**: `.gitignore`に`.env`や認証情報を追加

### ファイルアクセス制御

Filesystem MCPは現在のプロジェクトディレクトリ配下のみアクセスできるよう制限されています。

---

## 関連リソース

- [Model Context Protocol 公式サイト](https://modelcontextprotocol.io/)
- [MCP Servers Repository](https://github.com/modelcontextprotocol/servers)
- [Claude Code Documentation](https://docs.claude.com/)
- [ClaudeSkills Project](../README.md)

---

## サポート

問題が解決しない場合は、以下をご確認ください：

1. [GitHub Issues](https://github.com/yourusername/ClaudeSkills/issues)
2. [Claude Code Community](https://community.claude.com/)

---

**最終更新**: 2025-10-31
