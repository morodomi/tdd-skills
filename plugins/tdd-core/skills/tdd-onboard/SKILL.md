---
name: tdd-onboard
description: 対話的セットアップ。プロジェクト分析 + CLAUDE.md生成 + docs/STATUS.md作成。
allowed-tools: Read, Write, Grep, Glob, Bash, AskUserQuestion
---

# TDD Onboard

既存プロジェクトにTDD環境をセットアップする。

## Checklist

1. [ ] プロジェクト分析（フレームワーク/テストツール検出）
2. [ ] 検出結果をユーザーに確認
3. [ ] docs/ 構造作成（cycles/, README.md, STATUS.md）
4. [ ] CLAUDE.md 生成（既存あればマージ）
5. [ ] agent_docs/ 生成
6. [ ] 初期Cycle doc作成
7. [ ] Next Steps 表示

## Workflow

### Step 1: プロジェクト分析

```bash
# フレームワーク検出
ls artisan 2>/dev/null        # Laravel
ls app.py wsgi.py 2>/dev/null # Flask
ls wp-config.php 2>/dev/null  # WordPress

# パッケージマネージャ検出
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

### Step 4: CLAUDE.md 生成

- 既存あり → マージ or 上書き確認
- 既存なし → テンプレートから生成

### Step 5: agent_docs/ 生成

```
agent_docs/
├── tdd_workflow.md
├── testing_guide.md
├── quality_standards.md
└── commands.md
```

### Step 6: 初期Cycle doc作成

`docs/cycles/YYYYMMDD_0000_project-setup.md` を作成。

### Step 7: 完了

```
==========================================
TDD 環境セットアップ完了
==========================================
検出結果: ${FRAMEWORK} / ${TEST_TOOL}
作成ファイル: CLAUDE.md, docs/, agent_docs/

次: テスト実行 → カバレッジ確認 → tdd-init で開発開始
==========================================
```

## Reference

詳細は `reference.md` を参照。
