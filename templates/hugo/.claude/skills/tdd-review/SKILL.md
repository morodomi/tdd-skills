---
name: tdd-review
description: REFACTORの次。品質チェック（テスト/静的解析/カバレッジ）実行。
allowed-tools: Read, Grep, Glob, Bash, Edit, Task, SlashCommand
---

# TDD REVIEW Phase

最終的な品質検証を行う。

## Checklist

1. [ ] テスト実行（全PASS）
2. [ ] 静的解析実行（エラー0件）
3. [ ] カバレッジチェック（目標達成）
4. [ ] コードフォーマッタ実行
5. [ ] /code-review 実行（オプション）
6. [ ] Cycle doc更新
7. [ ] COMMITフェーズへ誘導

## 品質基準

| 項目 | 目標 | 最低ライン |
|------|------|----------|
| テスト | 全PASS | 全PASS |
| 静的解析 | エラー0 | エラー0 |
| カバレッジ | 90%+ | 80% |

## Workflow

### Step 1: テスト実行

```bash
# PHP/Laravel
php artisan test

# Python
pytest
```

### Step 2: 静的解析

```bash
# PHP
./vendor/bin/phpstan analyse --level=8

# Python
mypy --strict src/
```

### Step 3: カバレッジ

```bash
# PHP
php artisan test --coverage --min=80

# Python
pytest --cov=src --cov-fail-under=80
```

### Step 4: フォーマッタ

```bash
# PHP
./vendor/bin/pint

# Python
black . && isort .
```

### Step 5: Code Review（オプション）

```
/code-review
```

3つのSubagent（正確性/性能/セキュリティ）が並行実行。

### Step 6: 品質基準クリア確認

**全てクリアの場合**:

```
================================================================================
REVIEW完了
================================================================================
全ての品質基準をクリアしました。

次: COMMITフェーズ（Gitコミット）
================================================================================
```

**未クリアの場合**: DISCOVEREDに追加してRED/GREENに戻る。

## Reference

- 詳細ワークフロー: `reference.md`
- 品質基準: `agent_docs/quality_standards.md`
