# TDD Orchestrate - Agent Teams Mode (Experimental)

環境変数 `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` が有効時の手順。
1つのチームが全 Phase を通して存続し、Phase ごとに Teammate を spawn/shutdown する。

## Phase 1: Team 作成

Teammate ツールでチームを作成（INIT 時に1回のみ）:

```
Teammate(operation: "spawnTeam", team_name: "tdd-cycle")
```

## Phase 2: Block 1 - Planning

### PLAN

architect teammate を起動し、設計・Test List 作成を委譲:

```
Task(subagent_type: "general-purpose", team_name: "tdd-cycle", name: "architect")
→ Skill(tdd-plan) 実行
→ 結果報告
→ SendMessage(type: "shutdown_request", recipient: "architect")
```

### plan-review

5 reviewer teammate を起動し、設計レビューを実施:

```
scope-reviewer, architecture-reviewer, risk-reviewer, product-reviewer, usability-reviewer
→ 独立レビュー → 討論 → 合議判定
→ SendMessage(type: "shutdown_request") → 全 reviewer
```

### 自律判断

- PASS/WARN → Block 2 (Phase 3) へ進行
- BLOCK → architect を再起動して PLAN 再実行（max 1回再試行）

## Phase 3: Block 2 - Implementation

### RED

N 個の red-worker teammate を起動（テストファイル別）:

```
Task(subagent_type: "tdd-core:red-worker", team_name: "tdd-cycle", name: "red-worker-N")
→ テスト作成 → 結果報告 → shutdown
```

PdM がテスト失敗（RED 状態）を確認。

### GREEN

N 個の green-worker teammate を起動（実装ファイル別）:

```
Task(subagent_type: "tdd-core:green-worker", team_name: "tdd-cycle", name: "green-worker-N")
→ 実装 → 結果報告 → shutdown
```

PdM が全テスト成功（GREEN 状態）を確認。

### REFACTOR

refactorer teammate を起動:

```
Task(subagent_type: "general-purpose", team_name: "tdd-cycle", name: "refactorer")
→ Skill(tdd-refactor) 実行 → 結果報告 → shutdown
```

### REVIEW (quality-gate)

6 reviewer teammate を起動し、コードレビューを実施:

```
correctness-reviewer, performance-reviewer, security-reviewer,
guidelines-reviewer, product-reviewer, usability-reviewer
→ 独立レビュー → 討論 → 合議判定
→ SendMessage(type: "shutdown_request") → 全 reviewer
```

### 自律判断

- PASS/WARN → Block 3 (Phase 4) へ進行
- BLOCK → green-worker を再起動して修正（max 1回再試行）

## Phase 4: Block 3 - Finalization

### COMMIT

PdM (Lead) が直接実行:

```
git add <files>
git commit -m "..."
```

### Team Cleanup

```
Teammate(operation: "cleanup")
```

## Fallback

Agent Teams の起動に失敗した場合:
- 警告を表示: 「Agent Teams が利用できません。Subagent Chain にフォールバックします。」
- [steps-subagent.md](steps-subagent.md) の手順に切り替え
