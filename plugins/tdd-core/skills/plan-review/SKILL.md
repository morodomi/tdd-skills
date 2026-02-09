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
- [ ] レビュー実行（Subagent + Sonnet）
- [ ] 結果統合・スコア判定
- [ ] 分岐判定（PASS/WARN/BLOCK）
```

## Workflow

### Step 1: Cycle doc確認

```bash
ls -t docs/cycles/*.md 2>/dev/null | head -1
```

PLANセクション（設計方針、Test List、変更予定ファイル）を読み込む。

### Step 2: レビュー実行

Subagent + Sonnet で並行実行。手順: [steps-subagent.md](steps-subagent.md)

### Step 3: 結果統合

各エージェントの信頼スコアを集計:

| 最大スコア | 判定 | アクション |
|-----------|------|-----------|
| 80-100 | BLOCK | 修正必須、進行不可 |
| 50-79 | WARN | 警告表示、継続可能 |
| 0-49 | PASS | 問題なし |

### Step 4: 分岐判定

#### PASS（スコア49以下）
```
設計レビュー完了。問題ありません。
→ REDフェーズへ進んでください
```

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
（Progress Logに記録済み）
```

Cycle docのProgress Logに以下の形式で追記する:
```
- YYYY-MM-DD HH:MM [PLAN] plan-review BLOCK (score NN): reviewer「指摘要約」
```

## Reference

- エージェント定義: `../../agents/`
- スコアリング・出力形式: [reference.md](reference.md)
