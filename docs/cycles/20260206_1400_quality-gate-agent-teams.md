---
feature: quality-gate
cycle: quality-gate-agent-teams
phase: DONE
created: 2026-02-06 14:00
updated: 2026-02-06 14:00
---

# Quality Gate Agent Teams Mode

## Scope Definition

### In Scope
- [ ] quality-gate/SKILL.md に環境変数チェック分岐を追加
- [ ] steps-subagent.md 作成（現行の並行実行手順を抽出）
- [ ] steps-teams.md 作成（Agent Teams 討論モード手順）
- [ ] reference.md 更新（共通情報のみ残す）

### Out of Scope
- plan-review への適用 (別サイクルで対応)
- 新規エージェント定義の追加 (既存6エージェントを再利用)
- Agent Teams の実行基盤の実装 (Claude Code本体の機能)

### Files to Change (target: 10 or less)
- plugins/tdd-core/skills/quality-gate/SKILL.md (edit)
- plugins/tdd-core/skills/quality-gate/reference.md (edit)
- plugins/tdd-core/skills/quality-gate/steps-subagent.md (new)
- plugins/tdd-core/skills/quality-gate/steps-teams.md (new)

## Environment

### Scope
- Layer: Plugin (Claude Code Plugin skill definition)
- Plugin: tdd-core
- Risk: 10 (PASS)

### Runtime
- Bash: 3.2.57
- Claude Code: 2.1.32

### Dependencies (key packages)
- Claude Code Agent Teams: experimental (CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS)

## Context & Dependencies

### Reference Documents
- plugins/tdd-core/skills/quality-gate/SKILL.md - 現行実装
- plugins/tdd-core/skills/quality-gate/reference.md - 現行リファレンス
- https://code.claude.com/docs/en/agent-teams - Agent Teams公式ドキュメント

### Dependent Features
- quality-gate: plugins/tdd-core/skills/quality-gate/
- 既存reviewer agents: plugins/tdd-core/agents/*-reviewer.md

### Related Issues/PRs
- Issue #44: feat: team-review - Agent Teams based adversarial review

## Test List

### TODO
(none)

### WIP
(none)

### DISCOVERED
(none)

### DONE
- [x] TC-01: SKILL.md が CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS 分岐を含むこと
- [x] TC-02: SKILL.md が 100行以下であること (94行)
- [x] TC-03: steps-subagent.md が存在し、6エージェント並行起動手順を含むこと
- [x] TC-04: steps-teams.md が存在し、Team作成・討論・合議判定手順を含むこと
- [x] TC-05: reference.md が共通情報（スコープ、スコア、出力形式）を含むこと
- [x] TC-06: scripts/test-plugins-structure.sh 66 passed, 0 failed

## Implementation Notes

### Goal
quality-gate に Agent Teams 討論モードを追加する。環境変数で分岐し、有効時はチーム討論、無効時は従来の並行実行を行う。参照ファイルを分離して SKILL.md を 100行以内に維持する。

### Background

現行 quality-gate は Subagent (Task tool) で6レビュアーを並行起動し、各自が独立に
confidence + issues の JSON を返す。レビュアー間のコミュニケーションがないため、
誤検知の排除や見逃しの発見ができない。

Agent Teams (実験的機能) はエージェント間メッセージングを提供する。
これを活用し、レビュアー同士が反証し合う「討論型レビュー」を実現する。

### Design Approach

**方針: 既存 SKILL.md に環境変数分岐を追加し、手順を参照ファイルに分離**

#### SKILL.md の変更 (Step 3 のみ)

現行 Step 3 (6エージェント並行起動) を以下に置き換え:

```
Step 3: レビュー実行

CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS を確認:
- 有効 → steps-teams.md (討論型)
- 無効 → steps-subagent.md (並行型)
```

Step 1, 2, 4, 5 は変更なし。

#### steps-subagent.md (現行手順の抽出)

現行 Step 3 の内容をそのまま移動:
- Task ツールで6エージェント並行起動
- エージェントリスト

#### steps-teams.md (新規: Agent Teams 討論モード)

```
Phase 1: Team作成 + 6 reviewer teammate 起動
Phase 2: Independent Review (各自独立レビュー)
Phase 3: Debate (findings broadcast → 反証・補強)
Phase 4: Lead Synthesis (討論結果の合議判定)
Phase 5: Team shutdown + cleanup
```

#### reference.md

変更なし（共通情報: スコープ指定、スコア、出力形式は既にここにある）

#### ファイル構成 (変更後)

```
quality-gate/
├── SKILL.md              # Step 3 に分岐追加 (< 100行)
├── reference.md          # 共通詳細 (変更なし)
├── steps-subagent.md     # 無効時: 6エージェント並行手順
└── steps-teams.md        # 有効時: Team討論手順
```

## Progress Log

### 2026-02-06 14:00 - INIT
- Cycle doc created
- Scope: 4 files (2 edit, 2 new)
- Risk: 10 (PASS)

### 2026-02-06 14:00 - PLAN
- Design: env var branching + reference file separation
- Test List: 6 test cases

### 2026-02-06 14:00 - plan-review
- Score: 75 (WARN)
- 反映: 環境変数チェック方法明記、モード表示、フォールバック追加
- 見送り: エージェント数縮小、コスト定量化、価値仮説TC

---

## Next Steps

1. [Done] INIT
2. [Done] PLAN
3. [Done] plan-review (WARN → proceed)
4. [Done] RED (3 tests failing)
5. [Done] GREEN (66 passed, 0 failed)
6. [Done] REFACTOR (Progress Checklist更新)
7. [Done] REVIEW (quality-gate PASS: max 45)
8. [Done] COMMIT
