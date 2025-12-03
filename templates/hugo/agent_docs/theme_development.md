# Hugo Theme Development Guide

## ディレクトリ構造

```
layouts/
├── _default/
│   ├── baseof.html      # ベーステンプレート
│   ├── list.html        # 一覧ページ
│   └── single.html      # 個別ページ
├── partials/
│   ├── head.html        # <head> セクション
│   ├── header.html      # ヘッダー
│   ├── footer.html      # フッター
│   └── meta.html        # メタタグ
├── shortcodes/
│   └── notice.html      # カスタムショートコード
├── index.html           # ホームページ
└── 404.html             # 404ページ
```

---

## ベーステンプレート

### baseof.html

すべてのページの基盤となるテンプレート:

```html
<!DOCTYPE html>
<html lang="{{ .Site.Language.Lang }}">
<head>
  {{- partial "head.html" . -}}
</head>
<body>
  {{- partial "header.html" . -}}

  <main>
    {{- block "main" . }}{{- end }}
  </main>

  {{- partial "footer.html" . -}}
</body>
</html>
```

### Block の定義と使用

**baseof.html で定義**:
```html
{{- block "main" . }}
  <!-- デフォルトコンテンツ -->
{{- end }}

{{- block "sidebar" . }}
  <!-- オプショナル -->
{{- end }}
```

**single.html で上書き**:
```html
{{ define "main" }}
<article>
  <h1>{{ .Title }}</h1>
  {{ .Content }}
</article>
{{ end }}
```

---

## テンプレートの種類

### list.html（一覧ページ）

セクションの記事一覧を表示:

```html
{{ define "main" }}
<h1>{{ .Title }}</h1>

{{ .Content }}

<ul>
  {{ range .Pages }}
  <li>
    <a href="{{ .Permalink }}">{{ .Title }}</a>
    <time>{{ .Date.Format "2006-01-02" }}</time>
  </li>
  {{ end }}
</ul>

{{ template "_internal/pagination.html" . }}
{{ end }}
```

### single.html（個別ページ）

個々の記事を表示:

```html
{{ define "main" }}
<article>
  <header>
    <h1>{{ .Title }}</h1>
    <time datetime="{{ .Date.Format "2006-01-02" }}">
      {{ .Date.Format "January 2, 2006" }}
    </time>
  </header>

  <div class="content">
    {{ .Content }}
  </div>

  {{ if .Params.tags }}
  <footer>
    <ul class="tags">
      {{ range .Params.tags }}
      <li><a href="{{ "/tags/" | relLangURL }}{{ . | urlize }}">{{ . }}</a></li>
      {{ end }}
    </ul>
  </footer>
  {{ end }}
</article>
{{ end }}
```

### index.html（ホームページ）

```html
{{ define "main" }}
<h1>{{ .Site.Title }}</h1>

<section class="recent-posts">
  <h2>最新記事</h2>
  {{ range first 5 .Site.RegularPages }}
  <article>
    <h3><a href="{{ .Permalink }}">{{ .Title }}</a></h3>
    <p>{{ .Summary }}</p>
  </article>
  {{ end }}
</section>
{{ end }}
```

---

## Partials

### 基本的な使用

```html
{{- partial "header.html" . -}}
```

### コンテキストの受け渡し

```html
{{- partial "article-card.html" (dict "page" . "showDate" true) -}}
```

`partials/article-card.html`:
```html
<article>
  <h3>{{ .page.Title }}</h3>
  {{ if .showDate }}
  <time>{{ .page.Date.Format "2006-01-02" }}</time>
  {{ end }}
</article>
```

### partials/head.html の例

```html
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>{{ if .IsHome }}{{ .Site.Title }}{{ else }}{{ .Title }} | {{ .Site.Title }}{{ end }}</title>
<meta name="description" content="{{ with .Description }}{{ . }}{{ else }}{{ .Site.Params.description }}{{ end }}">

{{ $style := resources.Get "css/main.css" | minify | fingerprint }}
<link rel="stylesheet" href="{{ $style.Permalink }}">

{{ partial "meta.html" . }}
```

---

## ショートコード開発

### 基本構造

`layouts/shortcodes/youtube.html`:
```html
<div class="video-container">
  <iframe
    src="https://www.youtube.com/embed/{{ .Get 0 }}"
    allowfullscreen>
  </iframe>
</div>
```

使用:
```markdown
{{</* youtube "dQw4w9WgXcQ" */>}}
```

### 名前付きパラメータ

`layouts/shortcodes/figure.html`:
```html
<figure{{ with .Get "class" }} class="{{ . }}"{{ end }}>
  <img src="{{ .Get "src" }}" alt="{{ .Get "alt" }}">
  {{ with .Get "caption" }}
  <figcaption>{{ . }}</figcaption>
  {{ end }}
</figure>
```

使用:
```markdown
{{</* figure src="/images/photo.jpg" alt="写真" caption="キャプション" class="wide" */>}}
```

### Inner コンテンツ

`layouts/shortcodes/callout.html`:
```html
<div class="callout callout-{{ .Get 0 | default "info" }}">
  {{ .Inner | markdownify }}
</div>
```

使用:
```markdown
{{</* callout warning */>}}
**注意**: これは重要なメッセージです。
{{</* /callout */>}}
```

---

## アセット管理

### Hugo Pipes

**CSS処理**:
```html
{{ $style := resources.Get "css/main.scss" }}
{{ $style = $style | toCSS | minify | fingerprint }}
<link rel="stylesheet" href="{{ $style.Permalink }}">
```

**JavaScript処理**:
```html
{{ $js := resources.Get "js/main.js" }}
{{ $js = $js | js.Build | minify | fingerprint }}
<script src="{{ $js.Permalink }}"></script>
```

### ディレクトリ構造

```
assets/           # Hugo Pipes で処理
├── css/
│   └── main.scss
└── js/
    └── main.js

static/           # そのままコピー
├── images/
└── fonts/
```

---

## テンプレート関数

### よく使う関数

| 関数 | 説明 | 例 |
|------|------|-----|
| `range` | ループ | `{{ range .Pages }}` |
| `with` | nil チェック付きスコープ | `{{ with .Params.author }}` |
| `if` | 条件分岐 | `{{ if .IsHome }}` |
| `partial` | パーシャル呼び出し | `{{ partial "header.html" . }}` |
| `first` | 先頭N件取得 | `{{ range first 5 .Pages }}` |
| `where` | フィルタ | `{{ where .Pages "Section" "posts" }}` |
| `sort` | ソート | `{{ range sort .Pages "Date" "desc" }}` |

### 文字列操作

```html
{{ .Title | upper }}          <!-- 大文字 -->
{{ .Title | lower }}          <!-- 小文字 -->
{{ .Title | title }}          <!-- タイトルケース -->
{{ .Summary | truncate 100 }} <!-- 切り詰め -->
{{ .Content | plainify }}     <!-- HTMLタグ除去 -->
```

### 日付フォーマット

```html
{{ .Date.Format "2006-01-02" }}           <!-- 2025-12-03 -->
{{ .Date.Format "January 2, 2006" }}      <!-- December 3, 2025 -->
{{ .Date.Format "2006年1月2日" }}          <!-- 2025年12月3日 -->
```

---

## デバッグ

### 変数の確認

```html
<pre>{{ debug.Dump . }}</pre>
<pre>{{ printf "%#v" .Params }}</pre>
```

### 条件付き表示

```html
{{ if .Site.IsServer }}
<div class="debug">開発モード</div>
{{ end }}
```

---

## ベストプラクティス

1. **baseof.html を活用**: 共通レイアウトはベーステンプレートに
2. **Partials で分割**: 再利用可能な部品に分ける
3. **with を使う**: nil チェックを忘れない
4. **Hugo Pipes**: CSS/JS は assets/ で処理
5. **セマンティックHTML**: アクセシビリティを意識
6. **モバイルファースト**: レスポンシブデザイン

---

*詳細: https://gohugo.io/templates/*
