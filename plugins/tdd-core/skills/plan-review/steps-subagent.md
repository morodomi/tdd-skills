# Plan Review - Subagent Mode

常に Subagent モードで実行する（環境変数に関わらず）。

## 5エージェント並行起動

Taskツールで5つのエージェントを **model: sonnet** で**並行**起動:

```
Task(subagent_type: "tdd-core:scope-reviewer", model: "sonnet", prompt: "...")
Task(subagent_type: "tdd-core:architecture-reviewer", model: "sonnet", prompt: "...")
Task(subagent_type: "tdd-core:risk-reviewer", model: "sonnet", prompt: "...")
Task(subagent_type: "tdd-core:product-reviewer", model: "sonnet", prompt: "...")
Task(subagent_type: "tdd-core:usability-reviewer", model: "sonnet", prompt: "...")
```

各エージェントに以下を渡す:

- Cycle doc の PLAN セクション（設計方針、Test List、変更予定ファイル）

## 結果収集

各エージェントが独立に JSON を返す:

```json
{
  "confidence": 0-100,
  "issues": [...]
}
```

全エージェントの完了を待ち、Step 3（結果統合）へ進む。

## エラー時

並行起動失敗時は順次実行する。
