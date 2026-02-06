# v5.0 Design: PdM Delegation Model

**Status**: Confirmed - Ready for Implementation

## 1. Vision

**v4.3**: メインClaudeがSkill()を読み込み、自分で各フェーズを実行。並列化はSubagent/Agent Teamsで補助。

**v5.0**: メインClaudeは **PdM (Product Manager)** に徹する。計画・ヒアリング・判断のみ。実装・テスト・レビューは全て専門エージェントに委譲。

```
v4.3: Claude ─── 自分でSkill読む ─── 自分で実行 ─── 一部Subagent並列

v5.0: Claude(PdM) ─── AskUserQuestion ─── delegate ─── 自律判断
                        │
                  ┌─────┼─────┐
                Planner  Coder  Reviewer
```

### Why?

1. **Context分離**: 各専門家が自分のフェーズに集中。メインContextは軽量に保たれる
2. **品質向上**: Agent Teams討論で誤検知排除・見逃し発見
3. **スケーラビリティ**: 専門家を増やしてもメインContextに影響しない
4. **ユーザー体験**: PdMが常にユーザーと対話可能。「今どうなってる？」にすぐ答えられる

---

## 2. Design Decisions (Resolved)

### Q1: tdd-orchestrate と tdd-init の関係 → C: 階層化

tdd-init がエントリーポイント（変更なし）。
Agent Teams有効時、tdd-init が tdd-orchestrate を呼び出し、そちらが進行管理。

```
tdd-init → Agent Teams有効? → YES → tdd-orchestrate (PdMモード)
                              → NO  → 従来通り auto-transition
```

### Q2: auto-transition → A: 残す

Agent Teams無効時は既存の auto-transition がそのまま動作（後方互換）。
Agent Teams有効時は tdd-orchestrate がハブ型で制御するため、auto-transition は使われない。

### Q3: PdMモード有効化 → D: Agent Teams有効時に自動有効

別の環境変数は不要。`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` → PdMモード自動有効。

### Q4: Token コスト → 許容

Max x20契約のため許容範囲。

---

## 3. Architecture

### 3.1 モード分岐

| 条件 | モード | 進行管理 |
|------|--------|---------|
| `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` | Agent Teams (PdM) | tdd-orchestrate がハブ型管理 |
| 未設定 / 無効 | 従来モード | auto-transition チェーン型 |

### 3.2 PdM の自律判断フロー

**重要**: PdMはユーザー入力を待たずに自律的に判断する。
ユーザーに聞くのは INIT（要件確認）と BLOCK 時のみ。

```
Block 1: Planning
  INIT → PLAN → PLAN-REVIEW → Lead自律判断
    PASS → Block 2 へ自動進行
    WARN → Block 2 へ自動進行（警告をログ）
    BLOCK → PLANに戻って再試行

Block 2: Implementation
  RED → GREEN → REFACTOR → REVIEW → Lead自律判断
    PASS → Block 3 へ自動進行
    WARN → Block 3 へ自動進行（警告をログ）
    BLOCK → GREENに戻って再試行

Block 3: Finalization
  COMMIT → 完了
```

### 3.3 Agent Teams Mode の流れ

```
Team "tdd-cycle" (INIT時に作成)

Block 1: Planning
  INIT:
    Lead(PdM) ←→ User (AskUserQuestion で要件確定)
    Lead → Cycle doc 作成

  PLAN:
    Lead → spawn "architect" teammate
    architect → Skill(tdd-plan) 実行 → 結果報告 → shutdown

  PLAN-REVIEW:
    Lead → spawn 5 reviewer teammates
    reviewers → 討論型 plan-review → 結果報告 → shutdown
    Lead → 自律判断 (PASS→Block 2, BLOCK→PLAN再実行)

Block 2: Implementation
  RED:
    Lead → spawn N "red-worker" teammates (ファイル別)
    red-workers → 並列テスト作成 → 結果報告 → shutdown
    Lead → 全テスト失敗確認 (RED状態)

  GREEN:
    Lead → spawn N "green-worker" teammates (ファイル別)
    green-workers → 並列実装 → 結果報告 → shutdown
    Lead → 全テスト成功確認 (GREEN状態)

  REFACTOR:
    Lead → spawn "refactorer" teammate
    refactorer → リファクタリング → 結果報告 → shutdown
    Lead → テスト成功維持確認

  REVIEW:
    Lead → spawn 6 reviewer teammates
    reviewers → 討論型 quality-gate → 結果報告 → shutdown
    Lead → 自律判断 (PASS→Block 3, BLOCK→GREEN再実行)

Block 3: Finalization
  COMMIT:
    Lead → git add, commit
    Lead → cleanup team → 完了報告
```

### 3.4 Phase Ownership

| Phase | Owner | 委譲先 |
|-------|-------|--------|
| INIT | PdM (Lead) 直接実行 | - |
| PLAN | PdM → architect teammate/subagent | Skill(tdd-plan) |
| plan-review | PdM → 5 reviewer teammates/subagents | 討論/並列 |
| RED | PdM → N red-worker teammates/subagents | 並列テスト作成 |
| GREEN | PdM → N green-worker teammates/subagents | 並列実装 |
| REFACTOR | PdM → refactorer teammate/subagent | Skill(tdd-refactor) |
| REVIEW | PdM → 6 reviewer teammates/subagents | 討論/並列 |
| COMMIT | PdM (Lead) 直接実行 | - |

---

## 4. PdM (Lead) の責務定義

### 4.1 やること

| 責務 | 詳細 |
|------|------|
| ユーザー対話 | INIT で AskUserQuestion、BLOCK 時のエスカレーション |
| 自律判断 | PASS/WARN/BLOCK を自分で判定し、ユーザーを待たずに次Phase へ |
| Phase orchestration | 専門家の spawn/shutdown、Phase間遷移 |
| Context管理 | Cycle doc 読み書き、Phase状態追跡 |
| Verification Gate | テスト実行、成功/失敗確認 |
| Git操作 | commit, status, diff |

### 4.2 やらないこと

| 禁止 | 委譲先 |
|------|--------|
| 実装コード作成 | green-worker |
| テストコード作成 | red-worker |
| 設計詳細・Test List作成 | architect |
| コードレビュー | reviewer |
| リファクタリング | refactorer |
| 推測で進む | AskUserQuestion |

### 4.3 PdMの判断基準

| 場面 | 自律判断 | ユーザーに聞く |
|------|---------|---------------|
| PASS (0-49) | 次Phaseへ自動進行 | - |
| WARN (50-79) | 次Phaseへ自動進行、警告ログ | - |
| BLOCK (80-100) | 1回目: 自動再試行 | 2回目BLOCK: ユーザーに報告 |
| テスト失敗 (GREEN) | worker再試行 (max 2回) | 3回目失敗: ユーザーに報告 |
| 要件不明確 | - | AskUserQuestion |
| スコープ超過 | 警告表示、続行判断 | AskUserQuestion |

---

## 5. 新規・変更コンポーネント

### 5.1 新規: tdd-orchestrate skill (PdMオーケストレータ)

```
plugins/tdd-core/skills/tdd-orchestrate/
├── SKILL.md              # PdMワークフロー (< 100行)
├── reference.md          # 詳細ガイド（判断基準、再試行ロジック）
├── steps-teams.md        # Agent Teams モード手順
└── steps-subagent.md     # Subagent モード手順（fallback）
```

tdd-init から呼ばれ、TDDサイクル全体をPdMとして管理。

### 5.2 変更: plan-review に Agent Teams 対応追加

```
plugins/tdd-core/skills/plan-review/
├── SKILL.md              # env var分岐追加
├── steps-teams.md        # 新規: 討論型手順
└── steps-subagent.md     # 新規: 既存手順を抽出
```

quality-gate と同じパターン。

### 5.3 変更: tdd-init に orchestrate 呼び出し追加

```
tdd-init/SKILL.md:
  Step 7 変更:
    Agent Teams有効 → Skill(tdd-core:tdd-orchestrate)
    Agent Teams無効 → Skill(tdd-core:tdd-plan)  (従来通り)
```

### 5.4 変更: onboard CLAUDE.md テンプレート

reference.md の CLAUDE.md テンプレートに以下を追加:

```markdown
## AI Behavior Principles

### Role: PdM (Product Manager)

メインClaudeは計画・調整・確認に徹する。
実装・テスト・レビューは専門Subagent/Teammateに委譲する。

### Mandatory: AskUserQuestion

曖昧な要件は全てAskUserQuestion Toolで細分化してヒアリングする。
推測で進めない。確認してから進む。

以下の場面では必ずヒアリング:
- 技術選定（複数の選択肢がある場合）
- スコープ確認（何を含み何を含まないか）
- 優先度判断（何から着手するか）
- 品質基準（最低ラインと目標ライン）

### Delegation Strategy

| 条件 | 戦略 |
|------|------|
| CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1 | Agent Teams (Teammate間通信・討論) |
| 上記以外 | 並行Subagent (独立並列実行) |

### Delegation Rules

- 自分で実装コードを書かない → green-worker に委譲
- 自分でテストを書かない → red-worker に委譲
- 自分で設計詳細を作らない → architect に委譲
- 自分でレビューしない → reviewer に委譲
- 曖昧なまま進まない → AskUserQuestion で確認
```

### 5.5 新規: Agent 定義

| Agent | 役割 | 方式 |
|-------|------|------|
| architect | PLAN実行（Skill(tdd-plan)） | general-purpose teammate/subagent |
| refactorer | REFACTOR実行（Skill(tdd-refactor)） | general-purpose teammate/subagent |

**注**: 専用Agent定義(.md) を作成するか、general-purpose に指示で代替するかは実装時に判断。
既存の red-worker / green-worker / reviewer agents はそのまま使用。

### 5.6 既存Skills の影響範囲

| Skill | 変更 | 内容 |
|-------|------|------|
| tdd-init | 最小変更 | Step 7 に Agent Teams分岐追加 |
| plan-review | 追加 | steps-teams.md, steps-subagent.md |
| tdd-onboard | 追加 | CLAUDE.md テンプレートに AI Behavior Principles |
| tdd-plan | なし | architect が Skill() 経由で実行 |
| tdd-red | なし | orchestrate が red-worker を直接spawn |
| tdd-green | なし | orchestrate が green-worker を直接spawn |
| tdd-refactor | なし | refactorer が Skill() 経由で実行 |
| quality-gate | なし | 既に Teams 対応済み |
| tdd-review | なし | quality-gate を呼ぶだけ |
| tdd-commit | なし | PdM が直接実行 |

---

## 6. Implementation Roadmap

### Phase 1: Foundation (2 cycles)

**Cycle 1: plan-review Agent Teams 対応**
- plan-review/steps-teams.md 新規（討論型、quality-gate踏襲）
- plan-review/steps-subagent.md 新規（既存の並行手順を抽出）
- plan-review/SKILL.md に env var 分岐追加
- 変更ファイル: 3

**Cycle 2: onboard CLAUDE.md テンプレート進化**
- tdd-onboard/reference.md の CLAUDE.md テンプレートに AI Behavior Principles 追加
- 変更ファイル: 1

### Phase 2: Orchestrator (2-3 cycles)

**Cycle 3: tdd-orchestrate skill 基盤**
- tdd-orchestrate/SKILL.md: PdMワークフロー (Block 1/2/3)
- tdd-orchestrate/reference.md: 判断基準、再試行ロジック
- tdd-orchestrate/steps-teams.md: Agent Teams spawn/shutdown手順
- tdd-orchestrate/steps-subagent.md: Subagent fallback手順
- 変更ファイル: 4 (新規)

**Cycle 4: architect / refactorer agent + tdd-init 統合**
- agents/architect.md 新規
- agents/refactorer.md 新規（optional）
- tdd-init/SKILL.md: Step 7 に Agent Teams分岐追加
- CLAUDE.md: Skills table 更新
- 変更ファイル: 3-4

### Phase 3: Polish (1 cycle)

**Cycle 5: ドキュメント・リリース**
- README, STATUS.md 更新
- v5.0 release notes
- 変更ファイル: 2-3

**合計**: 5 cycles, 推定13-15ファイル変更

---

## 7. Trade-offs

### Token Cost

| モード | 推定コスト比 | 理由 |
|--------|-------------|------|
| 現在 (v4.3) | 1x | メインContext + Subagent |
| Agent Teams PdM | 2-3x | PdM + Teammate x N + 討論 |

Max x20契約で許容。

### Complexity vs Benefit

| 追加される複雑さ | 得られる利益 |
|-----------------|-------------|
| tdd-orchestrate (新Skill) | メインContext軽量化、Phase間エラー回復 |
| plan-review Teams対応 | 討論で設計レビュー品質向上 |
| CLAUDE.md PdM原則 | 全プロジェクトで委譲パターン標準化 |
| agent定義 2ファイル | 専門家の再利用性 |

### Risks

| リスク | 対策 |
|--------|------|
| Agent Teams不安定 | auto-transition fallback (Agent Teams無効時は従来動作) |
| PdM判断ミス | Verification Gate + BLOCK時ユーザーエスカレーション |
| Context喪失 | Cycle doc が唯一の情報源。全specialist が毎回読む |
| 後方互換性 | 既存Skillは変更最小限。orchestrate は新規追加 |

---

*Created: 2026-02-06*
*Status: Confirmed - Ready for Implementation*
*Decisions: Q1→C(階層化), Q2→A(残す), Q3→D(自動有効), Q4→許容*
