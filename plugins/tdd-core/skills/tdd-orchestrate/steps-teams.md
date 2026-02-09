# TDD Orchestrate - Agent Teams Mode (Experimental)

環境変数 `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` が有効時の手順。
1つのチームが全 Phase を通して存続し、Phase ごとに Teammate を spawn/shutdown する。

## Phase 1: Team 作成

Teammate ツールでチームを作成（INIT 時に1回のみ）:

```
Teammate(operation: "spawnTeam", team_name: "tdd-cycle")
```

### socrates 起動（常駐 advisor）

Team 作成直後に socrates を spawn する。全 Phase を通じて常駐し、PdM の判断に反論する:

```
Task(subagent_type: "general-purpose", team_name: "tdd-cycle", name: "socrates", mode: "plan")
```

socrates は read-only advisor であり、reviewer ではない。詳細: [../../agents/socrates.md](../../agents/socrates.md)

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

```
Skill(tdd-core:plan-review)
```

### 自律判断

スコアベース判定:

- PASS (0-49) → Block 2 (Phase 3) へ自動進行
- WARN (50-79) / BLOCK (80+) → Socrates Protocol 発動:

#### Socrates Protocol (plan-review)

1. PdM → socrates に判断提案を SendMessage（Phase名, スコア, reviewer サマリ, 提案）
2. socrates → PdM に反論を返答（Objections + Alternative 形式）
3. PdM → 人間にメリデメを構造化してテキスト出力（自由入力を求める）
4. 人間 → 自由入力で判断（proceed / fix / abort / 番号選択）

初回発動時のみユーザー案内を表示（[reference.md](reference.md#初回発動時のユーザー案内) 参照）。

- proceed → Block 2 へ進行
- fix → architect を再起動して PLAN 再実行（max 1回再試行）
- abort → サイクル中断

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

```
Skill(tdd-core:quality-gate)
```

### 自律判断

スコアベース判定:

- PASS (0-49) → DISCOVERED 判断へ自動進行
- WARN (50-79) / BLOCK (80+) → Socrates Protocol 発動:

#### Socrates Protocol (quality-gate)

1. PdM → socrates に判断提案を SendMessage（Phase名, スコア, reviewer サマリ, 提案）
2. socrates → PdM に反論を返答（Objections + Alternative 形式）
3. PdM → 人間にメリデメを構造化してテキスト出力（自由入力を求める）
4. 人間 → 自由入力で判断（proceed / fix / abort / 番号選択）

- proceed → DISCOVERED 判断へ進行
- fix → green-worker を再起動して修正（max 1回再試行）
- abort → サイクル中断

### DISCOVERED 判断

REVIEW が PASS/WARN の場合、Cycle doc の DISCOVERED セクションを確認:

1. DISCOVERED が空 → スキップして Block 3 へ
2. 起票済み（`→ #` 付き）の項目 → スキップ
3. 未起票の項目がある場合:

```bash
# 事前チェック
gh auth status 2>/dev/null || echo "gh CLI未認証。issue起票をスキップします。"
```

ユーザーに確認:
```
DISCOVERED items found:
1. [項目の要約]
GitHub issue を作成しますか? (Y/n)
```

承認後、各項目に対して:
```bash
gh issue create --title "[DISCOVERED] <要約>" --body "$(cat <<'EOF'
## 発見元
- Cycle: docs/cycles/<cycle-doc>.md
- Phase: REVIEW
- Reviewer: <reviewer名 or 手動>

## 内容
<DISCOVERED セクションの記載内容>
EOF
)" --label "discovered"
```

起票後、Cycle doc の DISCOVERED セクションに `→ #<issue番号>` を付記。

## Phase 4: Block 3 - Finalization

### COMMIT

PdM (Lead) が直接実行:

```
git add <files>
git commit -m "..."
```

### Team Cleanup

socrates を shutdown してからチームを解散:

```
SendMessage(type: "shutdown_request", recipient: "socrates")
Teammate(operation: "cleanup")
```

## Fallback

Agent Teams の起動に失敗した場合:
- 警告を表示: 「Agent Teams が利用できません。Subagent Chain にフォールバックします。」
- [steps-subagent.md](steps-subagent.md) の手順に切り替え
