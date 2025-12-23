---
name: tdd-review
description: 最終的な品質検証を行う。テスト/カバレッジ/静的解析/quality-gateをチェック。REFACTORの次フェーズ。「レビューして」「review」で起動。
---

# TDD REVIEW Phase

最終的な品質検証を行う。

## Progress Checklist

コピーして進捗を追跡:

```
REVIEW Progress:
- [ ] テスト実行（全PASS）
- [ ] カバレッジチェック（目標達成）
- [ ] 静的解析実行（エラー0件）
- [ ] quality-gate 実行
- [ ] コードフォーマッタ実行
- [ ] Cycle doc更新
- [ ] COMMITフェーズへ誘導
```

## 品質基準

| 項目 | 目標 | 最低ライン |
|------|------|----------|
| テスト | 全PASS | 全PASS |
| カバレッジ | 90%+ | 80% |
| 静的解析 | エラー0 | エラー0 |
| quality-gate | PASS | WARN以下 |

## Workflow

### Step 1: テスト実行

```bash
php artisan test  # PHP / pytest  # Python
```

### Step 2: カバレッジ確認

```bash
php artisan test --coverage --min=80  # PHP
pytest --cov=src --cov-fail-under=80  # Python
```

### Step 3: 静的解析

```bash
./vendor/bin/phpstan analyse --level=8  # PHP
mypy --strict src/                       # Python
```

### Step 4: quality-gate（自動実行）

quality-gateスキルを自動実行。4エージェントで並行レビュー。

- PASS（スコア49以下） → Step 5へ
- WARN（スコア50-79） → 警告確認後、Step 5へ
- BLOCK（スコア80以上） → GREENに戻って修正

### Step 5: フォーマッタ

```bash
./vendor/bin/pint   # PHP
black . && isort .  # Python
```

### Step 6: 品質基準クリア確認

```
================================================================================
REVIEW完了
================================================================================
全ての品質基準をクリアしました。
次: COMMITフェーズ（Gitコミット）
================================================================================
```

## Reference

- 詳細: [reference.md](reference.md)
- quality-gate: [../quality-gate/SKILL.md](../quality-gate/SKILL.md)
