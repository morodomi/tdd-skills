# TDD Diagnose - Agent Teams Mode (Experimental)

環境変数 `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` が有効時の手順。
調査員同士が討論し、仮説の反証・補強を行う。

## Phase 1: Team 作成

Teammate ツールでチームを作成:

```
Teammate(operation: "spawnTeam", team_name: "diagnose-investigation")
```

## Phase 2: Investigator Teammate 起動

Task ツールで仮説数分の Investigator を **teammate** として起動:

```
Investigator A (subagent_type: Explore): 仮説 H1
Investigator B (subagent_type: Explore): 仮説 H2
Investigator C (subagent_type: Explore): 仮説 H3
```

各 teammate に以下を渡す:

- 担当する仮説と調査方針
- バグの症状・エラーメッセージ
- 関連ファイル一覧

## Phase 3: Independent Investigation

各 Investigator が独立に調査を実施。
仮説テンプレートに沿って evidence_for / evidence_against を収集。

## Phase 4: Debate (討論)

全 Investigator の初回調査完了後、討論フェーズを開始:

1. **Findings 共有**: 各 Investigator が発見事項を broadcast
2. **反証・補強** (最大 2 ラウンド):
   - 「H1 の証拠はこのコードと矛盾する: ...」
   - 「H2 を補強する追加証拠を発見: ...」
   - 「H3 は完全に否定できる。理由: ...」
3. **収束**: 新しい指摘が出なくなった時点、または 2 ラウンドで終了

## Phase 5: Lead Synthesis (合議判定)

Lead が討論結果を踏まえて最終判定:

- 支持された仮説 → verdict: Confirmed
- 否定された仮説 → verdict: Rejected
- 結論が出ない仮説 → verdict: Inconclusive

調査結果を統合し、Step 4（調査結果統合）へ進む。

## Phase 6: Team Cleanup

```
SendMessage(type: "shutdown_request") → 全 teammate
Teammate(operation: "cleanup")
```

## Fallback

Agent Teams の起動に失敗した場合:
- 警告を表示: 「Agent Teams が利用できません。並行型モードにフォールバックします。」
- [steps-subagent.md](steps-subagent.md) の手順に切り替え
