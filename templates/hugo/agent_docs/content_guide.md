# Hugo Content Guide

## Front Matter

すべてのコンテンツファイルは Front Matter で始まります。

### 基本構造（YAML）

```yaml
---
title: "記事タイトル"
date: 2025-12-03T14:00:00+09:00
draft: false
description: "記事の説明（SEO用）"
tags: ["hugo", "tutorial"]
categories: ["development"]
---
```

### 基本構造（TOML）

```toml
+++
title = "記事タイトル"
date = 2025-12-03T14:00:00+09:00
draft = false
description = "記事の説明"
tags = ["hugo", "tutorial"]
categories = ["development"]
+++
```

### 主要なパラメータ

| パラメータ | 説明 | 例 |
|-----------|------|-----|
| title | 記事タイトル | "Getting Started" |
| date | 公開日時 | 2025-12-03T14:00:00+09:00 |
| draft | ドラフトフラグ | true / false |
| description | 説明文（SEO） | "Hugo入門ガイド" |
| tags | タグ（配列） | ["hugo", "ssg"] |
| categories | カテゴリ（配列） | ["tutorial"] |
| weight | 並び順（小さいほど先） | 10 |
| slug | URLスラッグ | "my-custom-url" |
| aliases | リダイレクト元URL | ["/old-url/"] |

---

## セクション構造

### ディレクトリ構造

```
content/
├── _index.md           # ホームページ
├── posts/
│   ├── _index.md       # posts セクションのリスト
│   ├── first-post.md
│   └── second-post.md
├── pages/
│   ├── about.md
│   └── contact.md
└── docs/
    ├── _index.md
    ├── getting-started/
    │   ├── _index.md
    │   └── installation.md
    └── advanced/
        └── configuration.md
```

### _index.md の役割

- セクションのリストページを定義
- セクション全体のメタデータを設定
- カスタムコンテンツを追加可能

```yaml
---
title: "ブログ記事"
description: "技術ブログの記事一覧"
---

このセクションでは技術的な記事を公開しています。
```

---

## ショートコード

### 組み込みショートコード

**figure（画像）**:
```markdown
{{</* figure src="/images/example.png" alt="説明" caption="キャプション" */>}}
```

**highlight（コードハイライト）**:
```markdown
{{</* highlight python */>}}
def hello():
    print("Hello, World!")
{{</* /highlight */>}}
```

**ref / relref（内部リンク）**:
```markdown
[記事へのリンク]({{</* ref "/posts/my-post.md" */>}})
[相対リンク]({{</* relref "other-post.md" */>}})
```

**param（パラメータ参照）**:
```markdown
サイト名: {{</* param "title" */>}}
```

### カスタムショートコード

`layouts/shortcodes/notice.html`:
```html
<div class="notice notice-{{ .Get 0 }}">
  {{ .Inner | markdownify }}
</div>
```

使用方法:
```markdown
{{</* notice warning */>}}
これは警告メッセージです。
{{</* /notice */>}}
```

---

## 画像・アセット管理

### 静的ファイル（static/）

```
static/
├── images/
│   └── logo.png
├── css/
│   └── custom.css
└── js/
    └── main.js
```

参照方法:
```markdown
![ロゴ](/images/logo.png)
```

### ページバンドル（推奨）

```
content/posts/my-post/
├── index.md          # 記事本文
├── cover.jpg         # 記事固有の画像
└── diagram.png
```

参照方法（相対パス）:
```markdown
![カバー画像](cover.jpg)
```

### Hugo Pipes（アセット処理）

`assets/` ディレクトリのファイルを処理:
```html
{{ $style := resources.Get "css/main.scss" | toCSS | minify }}
<link rel="stylesheet" href="{{ $style.Permalink }}">
```

---

## ドラフト管理

### ドラフト記事の作成

```yaml
---
title: "下書き記事"
draft: true
---
```

### ドラフトの確認

```bash
# ドラフト一覧
hugo list drafts

# ドラフト含めてプレビュー
hugo server -D
```

### 公開

```yaml
draft: false
```

または Front Matter から `draft` を削除。

---

## コンテンツ作成コマンド

```bash
# 新規記事作成
hugo new content/posts/my-new-post.md

# アーキタイプを指定
hugo new --kind post content/posts/another-post.md

# 固定ページ作成
hugo new content/pages/about.md
```

### アーキタイプ（テンプレート）

`archetypes/default.md`:
```yaml
---
title: "{{ replace .Name "-" " " | title }}"
date: {{ .Date }}
draft: true
---
```

`archetypes/post.md`:
```yaml
---
title: "{{ replace .Name "-" " " | title }}"
date: {{ .Date }}
draft: true
tags: []
categories: []
---

## 概要

記事の概要をここに書く。

## 本文

本文をここに書く。
```

---

## ベストプラクティス

1. **意味のあるスラッグ**: URLに使われるファイル名は分かりやすく
2. **画像はページバンドル**: 記事と画像を同じディレクトリに
3. **ドラフトを活用**: 完成するまで `draft: true`
4. **日付の統一**: ISO 8601形式 `2025-12-03T14:00:00+09:00`
5. **タグとカテゴリの使い分け**:
   - タグ: 細かいトピック（多数可）
   - カテゴリ: 大きな分類（少数）

---

*詳細: https://gohugo.io/content-management/*
