# Quality Gate - Subagent Mode

環境変数 `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` が無効時の手順。

## 6エージェント並行起動

Taskツールで6つのエージェントを**並行**起動:

```
tdd-core:correctness-reviewer  # 正確性
tdd-core:performance-reviewer  # パフォーマンス
tdd-core:security-reviewer     # セキュリティ
tdd-core:guidelines-reviewer   # ガイドライン
tdd-core:product-reviewer      # プロダクト観点（価値・コスト・優先度）
tdd-core:usability-reviewer    # ユーザビリティ（UX・アクセシビリティ）
```

各エージェントに以下を渡す:

- 対象ファイル一覧（Step 1 で決定）
- 言語プラグイン情報（Step 2 で確認）

## 結果収集

各エージェントが独立に JSON を返す:

```json
{
  "confidence": 0-100,
  "issues": [...]
}
```

全エージェントの完了を待ち、Step 4（結果統合）へ進む。
