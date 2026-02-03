---
name: plan-review
description: PLANフェーズの設計を5観点で並行レビュー。信頼スコア80以上でBLOCK。
---

# Plan Review

PLANフェーズの設計を5つの専門エージェントで並行レビューする。

## Progress Checklist

```
plan-review Progress:
- [ ] Cycle doc確認
- [ ] 5エージェント並行起動
- [ ] 結果統合・スコア判定
- [ ] 分岐判定（PASS/WARN/BLOCK）
```

## Workflow

### Step 1: Cycle doc確認

```bash
ls -t docs/cycles/*.md 2>/dev/null | head -1
```

PLANセクション（設計方針、Test List、変更予定ファイル）を読み込む。

### Step 2: 5エージェント並行起動

Taskツールで5つのエージェントを**並行**起動:

```
tdd-core:scope-reviewer        # スコープ妥当性
tdd-core:architecture-reviewer # 設計整合性
tdd-core:risk-reviewer         # 技術リスク評価
tdd-core:product-reviewer      # プロダクト観点（価値・コスト・優先度）
tdd-core:usability-reviewer    # ユーザビリティ（UX・アクセシビリティ）
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
→ REDフェーズへ自動進行

#### WARN（スコア50-79）
```
警告があります。確認してください。
1. 警告を確認してREDへ進む
2. PLANに戻って修正
```

#### BLOCK（スコア80以上）
```
重大な問題が検出されました。
→ PLANに戻って修正してください
```

## Reference

- エージェント定義: `../../agents/`
