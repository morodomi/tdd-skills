# TDD Diagnose - Subagent Mode

環境変数 `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` が無効時の手順。

## Explore エージェント並行調査

Task ツールで仮説数分の Explore エージェント（Claude Code 組み込み read-only 型）を **並行** 起動:

```
Task 1 (subagent_type: Explore): 仮説 H1 の検証
Task 2 (subagent_type: Explore): 仮説 H2 の検証
Task 3 (subagent_type: Explore): 仮説 H3 の検証
```

各エージェントに以下を渡す:

- 担当する仮説と調査方針
- バグの症状・エラーメッセージ
- 関連ファイル一覧

## 各エージェントの調査内容

1. **コード検索**: Grep/Glob で関連コードを特定
2. **コード読解**: Read で詳細を確認
3. **証拠収集**: 仮説を支持/否定する証拠を記録

## 結果収集

各エージェントが調査結果を返す:

```markdown
### Hypothesis H[n]: [仮説名]
- hypothesis: [原因の仮説]
- evidence_for: [支持する証拠]
- evidence_against: [反する証拠]
- verdict: Confirmed / Rejected / Inconclusive
- confidence: 0-100
```

全エージェントの完了を待ち、Step 4（調査結果統合）へ進む。

## 注意事項

- Explore エージェントは **read-only**（ファイル読取・検索のみ）
- コマンド実行が必要な場合は Lead エージェントが実施
- 再現テストの実行は Lead が担当
