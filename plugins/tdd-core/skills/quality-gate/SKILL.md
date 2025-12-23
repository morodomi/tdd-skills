---
name: quality-gate
description: コード変更を4観点で並行レビュー。信頼スコア80以上でBLOCK。tdd-reviewで自動実行。
---

# Quality Gate

コード変更を4つの専門エージェントで並行レビューする。

## Progress Checklist

```
quality-gate Progress:
- [ ] 対象確認（git diff or 指定ファイル）
- [ ] 4エージェント並行起動
- [ ] 結果統合・スコア判定
- [ ] 分岐判定（PASS/WARN/BLOCK）
```

## Workflow

### Step 1: 対象確認

```bash
git diff --stat
```

### Step 2: 4エージェント並行起動

Taskツールで4つのエージェントを**並行**起動:

```
tdd-core:correctness-reviewer  # 正確性
tdd-core:performance-reviewer  # パフォーマンス
tdd-core:security-reviewer     # セキュリティ
tdd-core:guidelines-reviewer   # ガイドライン
```

### Step 3: 結果統合

各エージェントの信頼スコアを集計:

| 最大スコア | 判定 | アクション |
|-----------|------|-----------|
| 80-100 | BLOCK | 修正必須、進行不可 |
| 50-79 | WARN | 警告表示、継続可能 |
| 0-49 | PASS | 問題なし |

### Step 4: 分岐判定

#### PASS（スコア49以下）
→ COMMITフェーズへ自動進行

#### WARN（スコア50-79）
```
警告があります。確認してください。
1. 警告を確認してCOMMIT
2. GREENに戻って修正
```

#### BLOCK（スコア80以上）
```
重大な問題が検出されました。
→ GREENに戻って修正してください
```

## Reference

- エージェント定義: `../../agents/`
