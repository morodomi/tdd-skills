# Hugo Commands

## 開発サーバー

```bash
# 基本起動
hugo server

# ドラフト含めて起動
hugo server -D

# 将来の日付の記事も表示
hugo server -F

# ドラフト + 将来日付
hugo server -D -F

# 外部アクセス許可（LAN内の他デバイスから確認）
hugo server --bind 0.0.0.0

# ポート指定
hugo server --port 3000

# ライブリロード無効化
hugo server --disableLiveReload

# 高速レンダリング無効（デバッグ用）
hugo server --disableFastRender
```

---

## ビルド

```bash
# 基本ビルド（public/ に出力）
hugo

# 本番ビルド（最適化）
hugo --gc --minify

# ドラフト含めてビルド
hugo -D

# 出力先変更
hugo -d dist/

# ベースURL指定
hugo --baseURL "https://example.com/"

# 環境指定
hugo --environment production

# ビルド情報表示
hugo --verbose
```

---

## コンテンツ作成

```bash
# 新規記事作成
hugo new content/posts/my-new-post.md

# ディレクトリ指定
hugo new content/docs/getting-started/installation.md

# アーキタイプ指定
hugo new --kind post content/posts/another-post.md
hugo new --kind docs content/docs/api-reference.md

# 固定ページ
hugo new content/pages/about.md
hugo new content/pages/contact.md
```

---

## コンテンツ管理

```bash
# 全コンテンツ一覧
hugo list all

# ドラフト一覧
hugo list drafts

# 期限切れコンテンツ
hugo list expired

# 将来公開予定
hugo list future
```

---

## リンク検証（htmltest）

```bash
# インストール（macOS）
brew install htmltest

# インストール（Go）
go install github.com/wjdp/htmltest@latest

# 基本実行
htmltest ./public

# 設定ファイル指定
htmltest --conf .htmltest.yml ./public

# 詳細出力
htmltest -l 3 ./public
```

### .htmltest.yml 設定例

```yaml
DirectoryPath: "public"
CheckExternal: false
CheckInternal: true
CheckMailto: false
CheckTel: false
IgnoreDirs:
  - "tags"
  - "categories"
IgnoreURLs:
  - "localhost"
  - "127.0.0.1"
```

---

## テーマ管理

```bash
# 新規テーマ作成
hugo new theme my-theme

# テーマ指定（コマンドライン）
hugo server --theme my-theme

# Git サブモジュールでテーマ追加
git submodule add https://github.com/user/theme.git themes/theme-name
```

---

## 設定確認

```bash
# Hugo バージョン
hugo version

# 拡張版か確認（SCSS/Sass対応）
hugo version | grep extended

# 設定確認
hugo config

# 環境別設定確認
hugo config --environment production

# マウント確認
hugo config mounts
```

---

## モジュール管理

```bash
# モジュール初期化
hugo mod init github.com/user/my-site

# モジュール追加
hugo mod get github.com/user/some-module

# モジュール更新
hugo mod get -u

# 依存関係確認
hugo mod graph

# キャッシュクリア
hugo mod clean
```

---

## デプロイ

```bash
# ビルド + 特定ディレクトリに出力
hugo --gc --minify -d public/

# GitHub Pages（docs/ フォルダ）
hugo --gc --minify -d docs/

# Netlify/Vercel（自動検出）
# netlify.toml / vercel.json で設定
```

### netlify.toml 例

```toml
[build]
  publish = "public"
  command = "hugo --gc --minify"

[build.environment]
  HUGO_VERSION = "0.121.0"
```

---

## パフォーマンス計測

```bash
# ビルド時間計測
hugo --templateMetrics

# 詳細なメトリクス
hugo --templateMetrics --templateMetricsHints

# メモリ使用量確認
hugo --printMemoryUsage
```

---

## トラブルシューティング

```bash
# 詳細ログ
hugo --verbose
hugo --debug

# キャッシュクリア
hugo --ignoreCache

# リソースキャッシュクリア
rm -rf resources/_gen/

# public/ クリア
rm -rf public/
```

---

## 一括品質チェック

```bash
# ビルド + リンク検証
hugo --gc --minify && htmltest ./public

# CI/CD 向け
hugo --gc --minify --baseURL "$DEPLOY_URL" && htmltest --conf .htmltest.yml ./public
```

---

## 便利なエイリアス

`~/.bashrc` または `~/.zshrc` に追加:

```bash
alias hs="hugo server -D"
alias hb="hugo --gc --minify"
alias hn="hugo new"
alias ht="hugo --gc --minify && htmltest ./public"
```

---

*詳細: https://gohugo.io/commands/*
