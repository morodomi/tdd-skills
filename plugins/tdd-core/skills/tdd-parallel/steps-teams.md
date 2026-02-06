# TDD Parallel - Agent Teams Orchestration

Agent Teams でレイヤー別に並列開発を行う手順。

## Phase 1: Team 作成

Teammate ツールでチームを作成:

```
Teammate(operation: "spawnTeam", team_name: "tdd-parallel-dev")
```

## Phase 2: ファイル競合チェック

レイヤー間で共有ファイルがないか確認:

```bash
# 各レイヤーのファイル一覧を比較
# 共有ファイルが存在する場合は警告
```

| 結果 | アクション |
|------|-----------|
| 競合なし | Phase 3 へ |
| 競合あり | 警告表示、該当レイヤーを逐次実行に降格 |

## Phase 3: レイヤー別 Teammate 起動

Task ツールでレイヤー数分の Teammate を起動 (general-purpose 型):

```
Teammate A (Backend):
  → Skill(tdd-core:tdd-red) with backend test cases
  → Skill(tdd-core:tdd-green) with backend implementation
  → Skill(tdd-core:tdd-refactor)

Teammate B (Frontend):
  → Skill(tdd-core:tdd-red) with frontend test cases
  → Skill(tdd-core:tdd-green) with frontend implementation
  → Skill(tdd-core:tdd-refactor)
```

各 Teammate に以下を渡す:

- 担当レイヤーのファイル範囲
- 担当レイヤーのテストケース（Cycle doc の Test List から抽出）
- Cycle doc パス

## Phase 4: Independent Development

各 Teammate が独立に RED → GREEN → REFACTOR を実行。

API 契約変更時は broadcast で即時共有:

```
SendMessage(type: "broadcast", content: "API変更: GET /users → レスポンスに email フィールド追加")
```

## Phase 5: 統合テスト

全 Teammate の完了後、Lead が全テスト一括実行:

```bash
# プロジェクト全体のテスト
pytest            # Python
npm test          # JS/TS
php artisan test  # PHP
```

| 結果 | アクション |
|------|-----------|
| 全テスト成功 | Phase 6 へ |
| 失敗 | テスト出力からレイヤー特定 → 該当 Teammate に修正指示 |

## Phase 6: Team Cleanup

```
SendMessage(type: "shutdown_request") → 全 Teammate
Teammate(operation: "cleanup")
```

## Fallback

Agent Teams が無効（`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` 未設定）の場合:

```
Agent Teams が必要です。以下の手順で通常の逐次実行モードで進めてください:

1. Skill(tdd-core:tdd-red) を実行（全レイヤーのテスト作成）
2. Skill(tdd-core:tdd-green) を実行（全レイヤーの実装）
3. Skill(tdd-core:tdd-refactor) を実行

次のアクション: Skill(tdd-core:tdd-red) を個別実行してください。
```
