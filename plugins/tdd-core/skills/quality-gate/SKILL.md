---
name: quality-gate
description: コード変更を6観点で並行レビュー。信頼スコア80以上でBLOCK。tdd-reviewで自動実行。
---

# Quality Gate

コード変更を6つの専門エージェントで並行レビューする。

## Progress Checklist

```
quality-gate Progress:
- [ ] 対象範囲決定（引数解釈）
- [ ] スコープ/プラグイン確認
- [ ] レビュー実行（Subagent + Sonnet）
- [ ] 結果統合・スコア判定
- [ ] 分岐判定（PASS/WARN/BLOCK）
```

## Workflow

### Step 1: 対象範囲決定

引数に応じて対象範囲を決定:

| 引数 | 対象 |
|------|------|
| なし | 差分のみ（`git diff HEAD`） |
| `全部` `--all` | 全ファイル |
| ディレクトリ名 | 特定ディレクトリ |

```bash
# デフォルト
git diff HEAD --name-only
```

詳細: [reference.md](reference.md#対象範囲指定step-1)

### Step 2: スコープ/プラグイン確認

Cycle doc から言語プラグインを確認:

```bash
ls -t docs/cycles/*.md 2>/dev/null | head -1 | xargs grep -A2 "### Scope"
```

| Plugin | 参照内容 |
|--------|---------|
| tdd-php | Testing Strategy（No RefreshDatabase等） |
| tdd-flask | Flask固有パターン |
| tdd-python | pytest/mypy設定 |
| tdd-js | ESLint/Jest設定 |

### Step 3: レビュー実行

Subagent + Sonnet で並行実行。手順: [steps-subagent.md](steps-subagent.md)

### Step 4: 結果統合

各エージェントの信頼スコアを集計:

| 最大スコア | 判定 | アクション |
|-----------|------|-----------|
| 80-100 | BLOCK | 修正必須、進行不可 |
| 50-79 | WARN | 警告表示、継続可能 |
| 0-49 | PASS | 問題なし |

### Step 5: 分岐判定

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
