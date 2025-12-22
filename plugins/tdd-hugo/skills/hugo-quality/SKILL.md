---
name: hugo-quality
description: Hugo品質チェック。ビルド/リンクチェック/テンプレート解析時に使用。「Hugoの品質チェック」「ビルド検証」で起動。
allowed-tools: Bash, Read, Grep, Glob
---

# Hugo Quality Check

Hugo SSG プロジェクトの品質チェックツール。

## Commands

| ツール | コマンド | 用途 |
|--------|---------|------|
| Hugo Build | `hugo` | ビルド検証 |
| Hugo Server | `hugo server -D` | 開発サーバー |
| htmltest | `htmltest` | リンク切れチェック |
| Template Metrics | `hugo --templateMetrics` | テンプレート解析 |

## Usage

### ビルド検証

```bash
# 基本ビルド
hugo

# 下書き含む
hugo -D

# ビルド先指定
hugo -d public/
```

### リンク切れチェック

```bash
# htmltestインストール（初回のみ）
# macOS: brew install htmltest
# Linux: https://github.com/wjdp/htmltest/releases

# ビルド後にチェック
hugo && htmltest
```

### テンプレート解析

```bash
# テンプレート実行時間
hugo --templateMetrics

# 詳細メトリクス
hugo --templateMetrics --templateMetricsHints
```

### コンテンツ検証

```bash
# Front Matter検証
hugo list drafts     # 下書き一覧
hugo list expired    # 期限切れ一覧
hugo list future     # 未来日付一覧
```

## Quality Standards

| 項目 | 目標 |
|------|------|
| ビルド | エラー0 |
| リンク切れ | 0件 |
| 下書き | 本番デプロイ時は0 |

## Reference

- 詳細: `reference.md`
