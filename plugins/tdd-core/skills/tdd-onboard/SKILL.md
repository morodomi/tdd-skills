---
name: tdd-onboard
description: 既存プロジェクトにTDD環境をセットアップする。フレームワーク検出、CLAUDE.md生成、docs/STATUS.md作成を行う。「TDDセットアップ」「onboard」「プロジェクト初期化」で起動。
---

# TDD Onboard

既存プロジェクトにTDD環境をセットアップする。

## Progress Checklist

コピーして進捗を追跡:

```
Onboard Progress:
- [ ] プロジェクト分析（フレームワーク/テストツール検出）
- [ ] 検出結果をユーザーに確認
- [ ] docs/ 構造作成（cycles/, README.md, STATUS.md）
- [ ] CLAUDE.md 生成（既存あればマージ）
- [ ] 階層CLAUDE.md推奨（任意）
- [ ] .claude/rules/ 生成
- [ ] Pre-commit Hook確認（推奨）
- [ ] 初期Cycle doc作成
- [ ] Next Steps 表示
```

## Workflow

### Step 1: プロジェクト分析

フレームワークとツールを検出:

```bash
ls artisan 2>/dev/null          # Laravel
ls app.py wsgi.py 2>/dev/null   # Flask
ls wp-config.php 2>/dev/null    # WordPress
ls composer.json package.json pyproject.toml 2>/dev/null
```

### Step 2: 検出結果確認

AskUserQuestion で確認:
- フレームワーク
- パッケージマネージャ
- 既存CLAUDE.mdの処理方法

### Step 3: docs/ 構造作成

```bash
mkdir -p docs/cycles
```

作成ファイル:
- `docs/README.md` - ドキュメント索引
- `docs/STATUS.md` - プロジェクト状況（tdd-commitで自動更新）

テンプレートは [reference.md](reference.md) を参照。

### Step 4: CLAUDE.md 生成

- 既存あり → マージ or 上書き確認
- 既存なし → テンプレートから生成

テンプレートとマージ戦略は [reference.md](reference.md) を参照。

### Step 5: 階層CLAUDE.md推奨（任意）

tests/, src/, docs/ に CLAUDE.md 配置を推奨（各30-50行）。
詳細は [reference.md](reference.md) を参照。

### Step 6: .claude/rules/ 生成

存在しない場合に作成:

```
.claude/
└── rules/
    ├── tdd-workflow.md
    ├── testing-guide.md
    ├── quality.md
    ├── commands.md
    └── security.md
```

### Step 7: Pre-commit Hook確認（推奨）

hookなし → セットアップ推奨。詳細は [reference.md](reference.md) を参照。

### Step 8: 初期Cycle doc作成

`docs/cycles/YYYYMMDD_0000_project-setup.md` を作成。

### Step 9: 完了

セットアップ完了メッセージを表示。次: tdd-init で開発開始。

## Reference

テンプレートと詳細手順: [reference.md](reference.md)
