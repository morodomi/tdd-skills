# TDD Orchestrate - Subagent Chain Mode

環境変数 `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` が無効時の手順。
既存の Skill() auto-transition チェーンを使用して順次実行する。

注: quality-gate/plan-review の steps-subagent.md は並列実行だが、
tdd-orchestrate は順次実行チェーン。これはオーケストレータの性質上の必然的差異。

## Block 1: Planning

```
Skill(tdd-core:tdd-plan)
→ 自動的に plan-review を実行
→ PASS/WARN → Block 2 へ
→ BLOCK → tdd-plan を再実行
```

## Block 2: Implementation

```
Skill(tdd-core:tdd-red)
→ 自動的に tdd-green を実行
→ 自動的に tdd-refactor を実行
→ 自動的に tdd-review (quality-gate) を実行
→ PASS/WARN → DISCOVERED 判断へ
→ BLOCK → tdd-green を再実行
```

### DISCOVERED 判断

REVIEW が PASS/WARN の場合、Cycle doc の DISCOVERED セクションを確認し、
スコープ外の未起票項目を GitHub issue に起票する。
詳細は [reference.md](reference.md#discovered-issue-起票) を参照。

## Block 3: Finalization

```
Skill(tdd-core:tdd-commit)
→ サイクル完了
```

## 判断基準

Subagent Chain モードでも PdM の判断基準は同一:

| スコア | 判定 | アクション |
|--------|------|-----------|
| 0-49 | PASS | 次 Block へ自動進行 |
| 50-79 | WARN | 警告ログ、次 Block へ自動進行 |
| 80-100 | BLOCK | 1回目: 自動再試行、2回目: ユーザーに報告 |
