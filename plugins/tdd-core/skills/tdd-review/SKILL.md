---
name: tdd-review
description: 最終的な品質検証を行う。テスト/静的解析/カバレッジをチェック。REFACTORの次フェーズ。「レビューして」「review」で起動。
---

# TDD REVIEW Phase

最終的な品質検証を行う。

## Progress Checklist

コピーして進捗を追跡:

```
REVIEW Progress:
- [ ] テスト実行（全PASS）
- [ ] 静的解析実行（エラー0件）
- [ ] カバレッジチェック（目標達成）
- [ ] コードフォーマッタ実行
- [ ] /code-review 実行（オプション）
- [ ] Cycle doc更新
- [ ] COMMITフェーズへ誘導
```

## 品質基準

| 項目 | 目標 | 最低ライン |
|------|------|----------|
| テスト | 全PASS | 全PASS |
| 静的解析 | エラー0 | エラー0 |
| カバレッジ | 90%+ | 80% |

## Workflow

### Step 1: テスト実行

```bash
php artisan test  # PHP
pytest            # Python
```

### Step 2: 静的解析

```bash
./vendor/bin/phpstan analyse --level=8  # PHP
mypy --strict src/                       # Python
```

### Step 3: カバレッジ

```bash
php artisan test --coverage --min=80  # PHP
pytest --cov=src --cov-fail-under=80  # Python
```

### Step 4: フォーマッタ

```bash
./vendor/bin/pint   # PHP
black . && isort .  # Python
```

### Step 5: Code Review（オプション）

`/code-review` で3つのSubagent（正確性/性能/セキュリティ）が並行実行。

### Step 6: 品質基準クリア確認

**全てクリア**:
```
================================================================================
REVIEW完了
================================================================================
全ての品質基準をクリアしました。
次: COMMITフェーズ（Gitコミット）
================================================================================
```

**未クリア**: DISCOVEREDに追加してRED/GREENに戻る。

## Reference

- 詳細: [reference.md](reference.md)
- 品質基準: `agent_docs/quality_standards.md`
