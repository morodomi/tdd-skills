---
feature: tdd-hugo-plugin
cycle: tdd-hugo-001
phase: REVIEW
created: 2025-12-22 11:14
updated: 2025-12-22 11:14
---

# tdd-hugo プラグイン追加

## やりたいこと

Hugo SSG向け品質チェックプラグインの追加（Issue #8）

## Scope Definition

### 今回実装する範囲

- [ ] plugins/tdd-hugo/.claude-plugin/plugin.json
- [ ] plugins/tdd-hugo/skills/hugo-quality/SKILL.md
- [ ] plugins/tdd-hugo/skills/hugo-quality/reference.md
- [ ] plugins/tdd-hugo/README.md
- [ ] .claude-plugin/marketplace.json 更新

### 今回実装しない範囲

- Hugo テーマ固有の設定
- Netlify/Vercel デプロイ設定

### 変更予定ファイル

```
plugins/tdd-hugo/
├── .claude-plugin/plugin.json
├── README.md
└── skills/
    └── hugo-quality/
        ├── SKILL.md
        └── reference.md

.claude-plugin/marketplace.json  # tdd-hugo追加
```

計: 5ファイル

## Context

### 対象

- Hugo SSG（静的サイトジェネレーター）
- Markdownコンテンツ
- Go Templates

### ツール

| ツール | 用途 |
|--------|------|
| hugo build | ビルド検証 |
| htmltest | リンク切れチェック |
| hugo --templateMetrics | テンプレート解析 |

### 関連Issue

- Issue #8: feat: tdd-hugo プラグイン追加

## Test List

### TODO

- [ ] TC-01: plugin.json が有効なJSON
- [ ] TC-02: SKILL.md が100行以下
- [ ] TC-03: reference.md が存在
- [ ] TC-04: marketplace.json に tdd-hugo が含まれる
- [ ] TC-05: test-plugins-structure.sh が通過

### DONE

（なし）

## Implementation Notes

### 設計方針

tdd-js/tdd-phpと同様の構造で、Hugo用のツールに置き換え。

### ファイル構成

```
plugins/tdd-hugo/
├── .claude-plugin/
│   └── plugin.json           # プラグイン定義
├── skills/
│   └── hugo-quality/
│       ├── SKILL.md          # 70行以下
│       └── reference.md      # 詳細設定
└── README.md                 # 使い方
```

### hugo-quality SKILL.md 構成

```markdown
---
name: hugo-quality
description: Hugo品質チェック。ビルド/リンクチェック/テンプレート解析時に使用。
allowed-tools: Bash, Read, Grep, Glob
---

# Hugo Quality Check

## Commands
| ツール | コマンド | 用途 |
|--------|---------|------|
| Hugo Build | hugo | ビルド検証 |
| Hugo Server | hugo server -D | 開発サーバー |
| htmltest | htmltest | リンク切れチェック |
| Template Metrics | hugo --templateMetrics | テンプレート解析 |

## Usage
- ビルド検証
- リンク切れチェック
- テンプレート解析

## Quality Standards
| 項目 | 目標 |
|------|------|
| ビルド | エラー0 |
| リンク | 切れ0 |

## Reference
- 詳細: reference.md
```

## Progress Log

### 2025-12-22 11:14 - INIT

- Cycle doc作成
- Issue #8 から要件確認

### 2025-12-22 11:15 - PLAN

- tdd-jsを参考に構造設計
- SKILL.md構成決定

### 2025-12-22 11:16 - RED

- test-plugins-structure.sh にtdd-hugoテスト追加
- テスト実行: 14 passed, 2 failed（期待通り）

### 2025-12-22 11:17 - GREEN

- plugins/tdd-hugo/ 作成
  - plugin.json
  - skills/hugo-quality/SKILL.md (75行)
  - skills/hugo-quality/reference.md
  - README.md
- marketplace.json 更新
- テスト実行: 17 passed, 0 failed

### 2025-12-22 11:18 - REFACTOR

- 構造確認: 問題なし
- SKILL.md: 75行（100行以下 ✓）
- リファクタリング不要

### 2025-12-22 11:19 - REVIEW

- Plugin構造テスト: 17 passed
- Skills構造テスト: 28 passed
- 全品質基準クリア

