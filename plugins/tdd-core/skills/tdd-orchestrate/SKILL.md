---
name: tdd-orchestrate
description: TDDサイクル全体をPdMとして管理。Agent Teams有効時にtdd-initから呼ばれ、全Phaseを自律的に委譲・判断する。
---

# TDD Orchestrate (PdM Mode)

TDDサイクル全体をPdM (Product Manager) として管理するオーケストレータ。

## Progress Checklist

```
tdd-orchestrate Progress:
- [ ] Block 1: INIT → PLAN → plan-review → 自律判断
- [ ] Block 2: RED → GREEN → REFACTOR → REVIEW → 自律判断 → DISCOVERED
- [ ] Block 3: COMMIT → 完了
```

## PdM の原則

- 自分で実装・テスト・レビューしない → 専門 Teammate/Subagent に委譲
- PASS/WARN → 自動進行、BLOCK → 再試行 → ユーザーに報告
- 曖昧なまま進まない → AskUserQuestion で確認

## Workflow

### Block 1: Planning

1. **INIT**: Cycle doc 作成（PdM 直接実行）
2. **PLAN**: 設計・Test List 作成を委譲
3. **plan-review**: 5 reviewer で設計レビュー
4. **自律判断**: PASS/WARN → Block 2 へ、BLOCK → PLAN 再実行

### Block 2: Implementation

1. **RED**: red-worker にテスト作成を委譲
2. **GREEN**: green-worker に実装を委譲
3. **REFACTOR**: refactorer にリファクタリングを委譲
4. **REVIEW**: quality-gate で 6 reviewer レビュー
5. **自律判断**: PASS/WARN → DISCOVERED 判断 → Block 3 へ、BLOCK → GREEN 再実行
6. **DISCOVERED**: スコープ外項目を GitHub issue に起票（ユーザー確認後）

### Block 3: Finalization

1. **COMMIT**: git add & commit（PdM 直接実行）
2. **完了報告**: サイクル完了をユーザーに報告

## Mode Selection

`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` 環境変数でモードを選択:

| 環境変数 | モード | 手順 |
|----------|--------|------|
| 有効 (`1`) | Agent Teams (PdM Hub) | [steps-teams.md](steps-teams.md) |
| 無効 / 未設定 | Subagent Chain | [steps-subagent.md](steps-subagent.md) |

## Judgment Criteria

| スコア | 判定 | PdM アクション |
|--------|------|---------------|
| 0-49 | PASS | 次 Block へ自動進行 |
| 50-79 | WARN | 警告ログ、次 Block へ自動進行 |
| 80-100 | BLOCK | 1回目: 自動再試行、2回目: ユーザーに報告 |

詳細: [reference.md](reference.md)

## Reference

- PdM 責務・判断基準: [reference.md](reference.md)
- Agent Teams 手順: [steps-teams.md](steps-teams.md)
- Subagent 手順: [steps-subagent.md](steps-subagent.md)
