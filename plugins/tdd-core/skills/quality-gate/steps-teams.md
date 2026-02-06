# Quality Gate - Agent Teams Mode (Experimental)

環境変数 `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` が有効時の手順。
レビュアー同士が討論し、誤検知の排除・見逃しの発見を行う。

## Phase 1: Team 作成

Teammate ツールでチームを作成:

```
Teammate(operation: "spawnTeam", team_name: "quality-gate-review")
```

## Phase 2: 6 Reviewer Teammate 起動

Task ツールで6つのレビュアーを **teammate** として起動:

```
tdd-core:correctness-reviewer  # 正確性
tdd-core:performance-reviewer  # パフォーマンス
tdd-core:security-reviewer     # セキュリティ
tdd-core:guidelines-reviewer   # ガイドライン
tdd-core:product-reviewer      # プロダクト観点
tdd-core:usability-reviewer    # ユーザビリティ
```

各 teammate に以下を渡す:

- 対象ファイル一覧（Step 1 で決定）
- 言語プラグイン情報（Step 2 で確認）

## Phase 3: Independent Review

各 reviewer が独立にレビューを実施。
通常の Subagent モードと同じ JSON 出力:

```json
{
  "confidence": 0-100,
  "issues": [...]
}
```

## Phase 4: Debate (討論)

全 reviewer の初回レビュー完了後、討論フェーズを開始:

1. **Findings 共有**: 各 reviewer が発見事項を broadcast
2. **反証・補強** (1-2 ラウンド):
   - 「その指摘は誤検知では？ 理由: ...」
   - 「この観点が漏れている: ...」
   - 「同意。さらに severity を上げるべき」
3. **収束**: 新しい指摘が出なくなった時点で終了

## Phase 5: Lead Synthesis (合議判定)

Lead が討論結果を踏まえて最終スコアを調整:

- 誤検知と判定された issue → confidence 下方修正
- 新規発見の issue → confidence 上方修正
- 討論で補強された issue → severity 据え置きまたは上方修正

最終 JSON を生成し、Step 4（結果統合）へ進む。

## Phase 6: Team Cleanup

```
SendMessage(type: "shutdown_request") → 全 teammate
Teammate(operation: "cleanup")
```

## Fallback

Agent Teams の起動に失敗した場合:
- 警告を表示: 「Agent Teams が利用できません。並行型モードにフォールバックします。」
- [steps-subagent.md](steps-subagent.md) の手順に切り替え
