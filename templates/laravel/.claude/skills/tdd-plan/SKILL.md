---
name: tdd-plan
description: INITの次。「設計して」「計画して」で起動。実装計画を作成、テストは書かない。
allowed-tools: Read, Grep, Glob, Write, Edit, Bash
---

# TDD PLAN Phase

実装計画を作成し、Cycle docのPLANセクションを更新する。

## Checklist

1. [ ] 最新Cycle doc確認: `ls -t docs/cycles/*.md | head -1`
2. [ ] INITセクション読み込み
3. [ ] ユーザーと実装計画を対話で作成
4. [ ] PLANセクションを更新
5. [ ] Test Listを作成
6. [ ] REDフェーズへ誘導

## 禁止事項

- 実装コード作成（GREENで行う）
- テストコード作成（REDで行う）
- ユーザー承認なしの次フェーズ移行

## Workflow

### Step 1: Cycle doc確認

```bash
ls -t docs/cycles/*.md 2>/dev/null | head -1
```

Readツールで読み込み、Scope/Contextを把握。

### Step 2: 実装計画の対話

ユーザーに質問:

```
実装方針について確認させてください。

1. アーキテクチャ: どのレイヤーに実装？
2. 依存関係: 既存機能との連携は？
3. 品質基準: カバレッジ目標は？
```

### Step 3: PLANセクション更新

Cycle docに以下を追記:

```markdown
## Implementation Notes

### 背景
[ユーザー回答から]

### 設計方針
[ユーザー回答から]

### ファイル構成
- [ファイル1]: [役割]
- [ファイル2]: [役割]
```

### Step 4: Test List作成

```markdown
## Test List

### TODO
- [ ] TC-01: [正常系テスト]
- [ ] TC-02: [異常系テスト]
- [ ] TC-03: [境界値テスト]
```

### Step 5: 完了→RED誘導

```
================================================================================
PLAN完了
================================================================================
実装計画とTest Listを作成しました。

次: REDフェーズ（テスト作成）
================================================================================
```

tdd-red Skillを起動。

## Reference

- 詳細ワークフロー: `reference.md`
- TDDワークフロー全体: `agent_docs/tdd_workflow.md`
