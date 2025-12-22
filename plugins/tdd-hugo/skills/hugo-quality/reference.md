# hugo-quality Reference

## Hugo Configuration

### hugo.toml (推奨)

```toml
baseURL = 'https://example.com/'
languageCode = 'ja'
title = 'My Site'

[build]
  writeStats = true

[minify]
  disableXML = true
  minifyOutput = true
```

### hugo.yaml

```yaml
baseURL: https://example.com/
languageCode: ja
title: My Site

build:
  writeStats: true

minify:
  disableXML: true
  minifyOutput: true
```

## htmltest Configuration

### .htmltest.yml

```yaml
DirectoryPath: "public"
CheckExternal: true
CheckInternal: true
EnforceHTTPS: true

IgnoreURLs:
  - "localhost"
  - "127.0.0.1"

IgnoreDirs:
  - "fonts"
  - "images"
```

## CI/CD Integration

### GitHub Actions

```yaml
name: Hugo Build

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          submodules: recursive

      - name: Setup Hugo
        uses: peaceiris/actions-hugo@v3
        with:
          hugo-version: 'latest'
          extended: true

      - name: Build
        run: hugo --minify

      - name: htmltest
        uses: wjdp/htmltest-action@master
        with:
          path: public
```

## Common Commands

### 開発

```bash
# 開発サーバー起動
hugo server -D

# ポート指定
hugo server -p 3000

# ライブリロード無効
hugo server --disableLiveReload
```

### ビルド

```bash
# 本番ビルド
hugo --minify

# 環境指定
hugo --environment production

# キャッシュクリア
hugo --gc
```

### デバッグ

```bash
# 詳細ログ
hugo --verbose

# テンプレートデバッグ
hugo --debug
```

## Error Handling

### ビルドエラー

```
エラー: Error building site: ... template: ...

対応:
1. テンプレート構文を確認
2. 変数名のtypoを確認
3. hugo --verbose で詳細確認
```

### htmltestエラー

```
エラー: target does not exist

対応:
1. リンク先URLを確認
2. 内部リンクの場合、ファイルパスを確認
3. .htmltest.yml で除外設定
```

## Performance Tips

1. **画像最適化**: Hugo Pipes の `images.Process` を使用
2. **CSS/JS圧縮**: `resources.Minify` を使用
3. **キャッシュ活用**: `partialCached` を使用
4. **遅延読み込み**: `loading="lazy"` を画像に追加
