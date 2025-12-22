---
name: tdd-init
description: 「新機能を開発したい」「TDDを始めたい」で起動。Cycle doc作成→PLANへ誘導。
allowed-tools: Read, Write, Grep, Glob, Bash
---

# TDD INIT Phase

新しいTDDサイクルを開始し、Cycle docを作成する。

## Checklist

1. [ ] プロジェクト状況確認: `docs/STATUS.md` を読む
2. [ ] 既存サイクル確認: `ls -t docs/cycles/*.md | head -1`
3. [ ] ユーザーに「やりたいこと」を質問
4. [ ] 機能名を生成して確認
5. [ ] `docs/cycles/YYYYMMDD_HHMM_<機能名>.md` を作成
6. [ ] PLANフェーズへ誘導

## 禁止事項

- 実装計画の詳細作成（PLANで行う）
- テストコード作成（REDで行う）
- 実装コード作成（GREENで行う）

## Workflow

### Step 1: プロジェクト状況確認

```bash
cat docs/STATUS.md 2>/dev/null
```

存在しない場合は作成を促す（`/tdd-onboard` を推奨）。
存在する場合は現在の状況をユーザーに表示。

### Step 2: 既存サイクル確認

```bash
ls -t docs/cycles/*.md 2>/dev/null | head -1
```

進行中のサイクルがあれば、継続を推奨。新規開始ならStep 3へ。

### Step 3: やりたいことを質問

```
どんな機能を実装しますか？

例: ユーザーがログインできるようにしたい
```

### Step 4: 機能名生成

ユーザーの回答から機能名を生成（10-20文字）。

| やりたいこと | 機能名 |
|------------|--------|
| ログインできるようにしたい | ユーザーログイン機能 |
| CSVエクスポートしたい | CSVエクスポート機能 |

確認: `「[機能名]」でよいですか？`

### Step 5: Cycle doc作成

```bash
date +"%Y%m%d_%H%M"  # → YYYYMMDD_HHMM
mkdir -p docs/cycles
```

テンプレート: `templates/cycle.md` を参照してCycle docを作成。

### Step 6: 完了→PLAN誘導

```
================================================================================
INIT完了
================================================================================
ファイル: docs/cycles/YYYYMMDD_HHMM_<機能名>.md
次: PLANフェーズ（設計・計画）

PLANフェーズに進みます...
================================================================================
```

tdd-plan Skillを起動。

## Error Handling

詳細は `reference.md` を参照。

## Reference

- 詳細ワークフロー: `reference.md`
- Cycle docテンプレート: `templates/cycle.md`
- TDDワークフロー全体: `agent_docs/tdd_workflow.md`
