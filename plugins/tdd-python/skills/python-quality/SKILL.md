---
name: python-quality
description: Python品質チェック。pytest/mypy/Black実行時に使用。「Pythonの品質チェック」「静的解析」で起動。
allowed-tools: Bash, Read, Grep, Glob
---

# Python Quality Check

Python プロジェクトの品質チェックツール。

## Commands

| ツール | コマンド | 用途 |
|--------|---------|------|
| pytest | `pytest` | テスト実行 |
| mypy | `mypy --strict` | 型チェック |
| Black | `black .` | コードフォーマット |
| isort | `isort .` | import整理 |
| ruff | `ruff check .` | リンター |

## Usage

### テスト実行

```bash
# 基本
pytest

# verbose
pytest -v

# 特定ファイル
pytest tests/test_user.py

# カバレッジ
pytest --cov=src --cov-report=html
```

### 静的解析

```bash
# 型チェック（推奨: strict）
mypy --strict src/

# リンター
ruff check .
ruff check --fix .
```

### コードフォーマット

```bash
# フォーマット
black .
isort .

# チェックのみ
black --check .
isort --check-only .
```

## Quality Standards

| 項目 | 目標 |
|------|------|
| mypy | strict mode |
| カバレッジ | 90%+ |
| ruff/black | エラー0 |

## Reference

- 詳細: `reference.md`
