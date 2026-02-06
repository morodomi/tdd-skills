# Plan Review - Subagent Mode

環境変数 `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` が無効時の手順。

## 5エージェント並行起動

Taskツールで5つのエージェントを**並行**起動:

```
tdd-core:scope-reviewer        # スコープ妥当性
tdd-core:architecture-reviewer # 設計整合性
tdd-core:risk-reviewer         # 技術リスク評価
tdd-core:product-reviewer      # プロダクト観点（価値・コスト・優先度）
tdd-core:usability-reviewer    # ユーザビリティ（UX・アクセシビリティ）
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
