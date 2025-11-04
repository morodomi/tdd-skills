# Bedrock/WordPress用 ClaudeSkills インストールガイド

**最終更新**: 2025-11-04
**対象**: WordPress Bedrock環境

---

## 前提条件

### 必須

- **PHP**: 8.1以上
- **Composer**: 最新版
- **Node.js**: 18以上 (MCP統合用)
- **Git**: バージョン管理用

### 推奨

- **Docker**: コンテナ環境でのテスト実行
- **Claude Code**: CLI環境

---

## 自動インストール（推奨）

### Bedrockプロジェクトのルートでインストール

```bash
cd /path/to/bedrock-project
bash /path/to/ClaudeSkills/templates/bedrock/install.sh
```

### 実行内容

1. `.claude/skills/` ディレクトリ作成
2. 7つのSkills配置（tdd-init, tdd-plan, tdd-red, tdd-green, tdd-refactor, tdd-review, tdd-commit）
3. MCP統合（Git/Filesystem/GitHub）

### MCPをスキップする場合

```bash
bash /path/to/ClaudeSkills/templates/bedrock/install.sh --skip-mcp
```

---

## 手動インストール

### 1. Skillsのコピー

```bash
cd /path/to/bedrock-project
mkdir -p .claude/skills
cp -r /path/to/ClaudeSkills/templates/bedrock/.claude/skills/* .claude/skills/
```

### 2. MCP統合（オプション）

```bash
bash /path/to/ClaudeSkills/scripts/install-mcp.sh
```

---

## プラグイン/テーマでの使用

### プラグインディレクトリでインストール

```bash
cd /path/to/bedrock/web/app/mu-plugins/my-plugin
bash /path/to/ClaudeSkills/templates/bedrock/install.sh
```

### テーマディレクトリでインストール

```bash
cd /path/to/bedrock/web/app/themes/my-theme
bash /path/to/ClaudeSkills/templates/bedrock/install.sh
```

### 個別コンポーネントでの開発

各プラグイン/テーマは独立したテスト環境を持ちます：

```
bedrock/
├── web/
│   ├── app/
│   │   ├── mu-plugins/
│   │   │   ├── my-plugin/
│   │   │   │   ├── .claude/skills/  ← プラグイン固有
│   │   │   │   ├── tests/
│   │   │   │   ├── composer.json
│   │   │   │   └── phpunit.xml
│   │   ├── themes/
│   │   │   ├── my-theme/
│   │   │   │   ├── .claude/skills/  ← テーマ固有
│   │   │   │   ├── tests/
│   │   │   │   ├── composer.json
│   │   │   │   └── phpunit.xml
```

---

## Docker環境での使用

### 基本的なテスト実行

```bash
# プラグインのテスト
docker exec <container> bash -c "cd /var/task/web/app/mu-plugins/<plugin> && composer test"

# テーマのテスト
docker exec <container> bash -c "cd /var/task/web/app/themes/<theme> && composer test"
```

### 実際の使用例

```bash
# thenews-weatherプラグインのテスト
docker exec thenews-app-1 bash -c "cd /var/task/web/app/mu-plugins/thenews-weather && composer test"

# カバレッジ付き
docker exec thenews-app-1 bash -c "cd /var/task/web/app/mu-plugins/thenews-weather && composer test -- --coverage-text"

# PHPStan実行
docker exec thenews-app-1 bash -c "cd /var/task/web/app/mu-plugins/thenews-weather && composer stan"

# Pint実行
docker exec thenews-app-1 bash -c "cd /var/task/web/app/mu-plugins/thenews-weather && composer pint"
```

### すべてのコンポーネントをテスト

```bash
# スクリプト例（scripts/test-all.sh）
#!/bin/bash
echo "Testing all components..."

# Theme
docker exec app bash -c "cd /var/task/web/app/themes/my-theme && composer test"
THEME_EXIT=$?

# Plugin 1
docker exec app bash -c "cd /var/task/web/app/mu-plugins/plugin1 && composer test"
PLUGIN1_EXIT=$?

# Plugin 2
docker exec app bash -c "cd /var/task/web/app/mu-plugins/plugin2 && composer test"
PLUGIN2_EXIT=$?

if [ $THEME_EXIT -eq 0 ] && [ $PLUGIN1_EXIT -eq 0 ] && [ $PLUGIN2_EXIT -eq 0 ]; then
    echo "✓ All component tests passed"
    exit 0
else
    echo "✗ Some tests failed"
    exit 1
fi
```

---

## Git Subtree構成での使用

### 親リポジトリとSubtreeの使い分け

#### パターン1: 親リポジトリにインストール

```bash
cd /path/to/bedrock-project
bash /path/to/ClaudeSkills/templates/bedrock/install.sh

# すべてのコンポーネントで共通のSkillsを使用
```

#### パターン2: Subtreeごとにインストール

```bash
# プラグインSubtreeにインストール
cd /path/to/bedrock/web/app/mu-plugins/my-plugin
bash /path/to/ClaudeSkills/templates/bedrock/install.sh

# テーマSubtreeにインストール
cd /path/to/bedrock/web/app/themes/my-theme
bash /path/to/ClaudeSkills/templates/bedrock/install.sh
```

### Subtreeでの開発ワークフロー

#### 1. 親リポジトリで作業

```bash
cd /path/to/bedrock-project

# プラグイン開発
cd web/app/mu-plugins/my-plugin

# Claude Codeで「init」と入力してTDD開始
```

#### 2. Subtreeへプッシュ

```bash
# 親リポジトリのルートに戻る
cd /path/to/bedrock-project

# Subtreeにプッシュ
git subtree push --prefix=web/app/mu-plugins/my-plugin my-plugin main
```

#### 3. Subtreeから更新を取得

```bash
# 親リポジトリのルートで実行
git subtree pull --prefix=web/app/mu-plugins/my-plugin my-plugin main
```

### Subtreeの初回セットアップ

```bash
# リモート追加
git remote add my-plugin git@github.com:username/my-plugin.git

# Subtree追加
git subtree add --prefix=web/app/mu-plugins/my-plugin my-plugin main --squash
```

---

## トラブルシューティング

### Skills が認識されない

**症状**: Claude Codeで「init」と入力しても反応がない

**解決策**:
```bash
# Skillsディレクトリが存在するか確認
ls -la .claude/skills/

# tdd-initが存在するか確認
ls .claude/skills/tdd-init/SKILL.md

# Claude Codeを再起動
```

### MCP統合が動作しない

**症状**: Git操作が自動化されない

**解決策**:
```bash
# MCPが正しくインストールされているか確認
claude mcp list

# Git MCPが表示されるはず:
# git
# filesystem
# github

# 表示されない場合は再インストール
bash /path/to/ClaudeSkills/scripts/install-mcp.sh
```

### Docker環境でテストが実行できない

**症状**: `docker exec` コマンドでエラー

**解決策**:
```bash
# コンテナが起動しているか確認
docker ps

# コンテナ名を確認
docker ps --format "{{.Names}}"

# パスが正しいか確認
docker exec <container> ls /var/task/web/app/mu-plugins/<plugin>

# コンテナ内に入って確認
docker exec -it <container> bash
cd /var/task/web/app/mu-plugins/<plugin>
composer test
```

### wp-phpunit が見つからない

**症状**: `WP_TESTS_DIR` が設定されていない

**解決策**:
```bash
# 環境変数を設定
export WP_TESTS_DIR=/tmp/wordpress-tests-lib

# または .env に追加
echo "WP_TESTS_DIR=/tmp/wordpress-tests-lib" >> .env

# WordPress テストライブラリをインストール
bash bin/install-wp-tests.sh wordpress_test root '' localhost latest
```

### Brain Monkey でエラー

**症状**: Unit Testで Brain Monkey が動作しない

**解決策**:
```bash
# Brain Monkeyがインストールされているか確認
composer show brain/monkey

# インストールされていない場合
composer require --dev brain/monkey

# setUp/tearDown が正しく実装されているか確認
```

---

## よくある質問

### Q1: BedrockとWordPress標準の違いは？

**A**: Bedrockは以下の点で異なります：
- Composer依存管理
- 環境変数で設定管理（`.env`）
- セキュアなディレクトリ構造（`web/wp/`にWordPressコア）
- mu-plugins自動読み込み

### Q2: 親リポジトリとSubtreeのどちらにSkillsをインストールすべき？

**A**: プロジェクトの規模によります：
- **小規模**: 親リポジトリにインストール（共通Skills）
- **大規模**: Subtreeごとにインストール（独立した開発）

### Q3: Docker環境は必須？

**A**: 必須ではありませんが、推奨します：
- 環境の一貫性
- WordPressテスト環境の簡単なセットアップ
- チーム開発での統一環境

### Q4: wp-phpunit と Brain Monkey の使い分けは？

**A**: テストの性質で使い分けます：
- **wp-phpunit (WP_UnitTestCase)**: WordPress環境が必要な統合テスト
- **Brain Monkey (TestCase)**: WordPress関数をモックする高速ユニットテスト

### Q5: 既存プロジェクトに後から追加できる？

**A**: はい、可能です：
```bash
cd /path/to/existing-bedrock-project
bash /path/to/ClaudeSkills/templates/bedrock/install.sh
```

既存の `.claude/config.json` は保持されます。

---

## 次のステップ

### 1. CLAUDE.md を作成

```bash
cp .claude/CLAUDE.md.example CLAUDE.md
# プロジェクト固有の設定に編集
```

### 2. TDD開発を開始

```bash
# Claude Code起動
# 「init」と入力してTDD開始
```

### 3. ドキュメントを確認

- `CLAUDE.md`: プロジェクト設定とガイドライン
- `README.md`: フレームワークの概要（ClaudeSkillsリポジトリ）
- `docs/MCP_INSTALLATION.md`: MCP設定とトラブルシューティング

---

## サポート

問題が発生した場合:
1. このドキュメントのトラブルシューティングセクションを確認
2. ClaudeSkillsリポジトリのIssuesを検索
3. 新しいIssueを作成

---

*このガイドは ClaudeSkills Phase 4 の一部です*
