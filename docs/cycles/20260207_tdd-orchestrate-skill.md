---
feature: tdd-orchestrate
cycle: tdd-orchestrate-skill
phase: DONE
created: 2026-02-07
updated: 2026-02-07
---

# TDD Orchestrate PdMオーケストレータスキル

## Scope Definition

### In Scope
- [ ] tdd-orchestrate/SKILL.md 新規作成 (< 100行): PdMワークフロー (Block 1/2/3)
- [ ] tdd-orchestrate/reference.md 新規作成: 判断基準、再試行ロジック、PdM責務定義
- [ ] tdd-orchestrate/steps-teams.md 新規作成: Agent Teams spawn/shutdown手順
- [ ] tdd-orchestrate/steps-subagent.md 新規作成: Subagent fallback手順

### Out of Scope
- architect/refactorer agent定義 (Cycle 4 #50 で対応)
- tdd-init の変更 (Cycle 4 #50 で対応)
- v5.0 リリースドキュメント (Cycle 5 #51 で対応)

### Files to Change (target: 10 or less)
- plugins/tdd-core/skills/tdd-orchestrate/SKILL.md (new)
- plugins/tdd-core/skills/tdd-orchestrate/reference.md (new)
- plugins/tdd-core/skills/tdd-orchestrate/steps-teams.md (new)
- plugins/tdd-core/skills/tdd-orchestrate/steps-subagent.md (new)
- scripts/test-plugins-structure.sh (edit: TC-OR-* テスト追加)

## Environment

### Scope
- Layer: Plugin (Claude Code Plugin skill definition)
- Plugin: tdd-core
- Risk: 10 (PASS)

### Runtime
- Bash: 3.2.57
- Claude Code: 2.1.33

### Dependencies (key packages)
- docs/20260206_design_v5_pdm_delegation.md: 設計ドキュメント Section 3-4
- quality-gate/steps-teams.md: Agent Teams パターン参考
- plan-review/steps-teams.md: Agent Teams パターン参考

## Context & Dependencies

### Reference Documents
- docs/20260206_design_v5_pdm_delegation.md - v5.0 設計ドキュメント Section 3-4
- plugins/tdd-core/skills/quality-gate/ - Agent Teams / Subagent パターン参考
- plugins/tdd-core/skills/plan-review/ - Agent Teams / Subagent パターン参考

### Dependent Features
- tdd-core: plugins/tdd-core/skills/tdd-orchestrate/ (新規ディレクトリ)

### Related Issues/PRs
- Issue #49: feat: tdd-orchestrate PdMオーケストレータスキル

## Test List

### TODO
(none)

### WIP
(none)

### DISCOVERED
(none)

### DONE
- [x] TC-01: SKILL.md が存在し 70行（<= 100）
- [x] TC-02: SKILL.md が Block 1/2/3 を含む
- [x] TC-03: SKILL.md が CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS env var 分岐を含む
- [x] TC-04: SKILL.md が Progress Checklist を含み、13 Phase refs
- [x] TC-05: SKILL.md が steps-teams.md と steps-subagent.md を参照
- [x] TC-06: reference.md が PdM 判断基準テーブルを含む
- [x] TC-07: reference.md が再試行ロジック（上限回数 + エスカレーション）を含む
- [x] TC-08: reference.md が全 7 Phase を含む
- [x] TC-09: steps-teams.md が spawnTeam/spawn/shutdown/cleanup を含む
- [x] TC-10: steps-teams.md が Fallback（steps-subagent.md 切替）を含む
- [x] TC-11: steps-subagent.md が Skill 呼び出しで 6/6 スキルを参照
- [x] TC-12: SKILL.md が reference.md へのリンクを含む
- [x] TC-13: scripts/test-plugins-structure.sh 119 passed, 0 failed

## Implementation Notes

### Goal
TDDサイクル全体をPdM (Product Manager) として管理するオーケストレータスキル。
Agent Teams有効時にtdd-initから呼ばれ、全Phaseの委譲と自律判断を行う。

### Background

v5.0 PdM Delegation Model の Phase 2 (Orchestrator)。
v4.3 では各 Skill が auto-transition チェーン型で実行されていたが、
Agent Teams 有効時はメインClaudeが PdM に徹し、tdd-orchestrate がハブ型で
全 Phase の委譲・自律判断・エラー回復を行う。

### Design Approach

**方針: 既存パターン踏襲 + 設計ドキュメント Section 3-4 準拠**

#### SKILL.md (< 100行)

3ブロック構成で PdM ワークフローを定義:

```
Block 1: Planning
  INIT → PLAN → plan-review → 自律判断
Block 2: Implementation
  RED → GREEN → REFACTOR → REVIEW → 自律判断
Block 3: Finalization
  COMMIT → 完了
```

env var 分岐で steps-teams.md / steps-subagent.md を参照。
Progress Checklist ドラフト:
```
tdd-orchestrate Progress:
- [ ] Block 1: INIT → PLAN → plan-review → 自律判断
- [ ] Block 2: RED → GREEN → REFACTOR → REVIEW → 自律判断
- [ ] Block 3: COMMIT → 完了
```

#### reference.md

設計ドキュメント Section 4 の内容を整理:
- PdM 責務（やること / やらないこと）
- Phase Ownership テーブル
- 判断基準テーブル（PASS/WARN/BLOCK + スコア範囲 0-49/50-79/80-100）
- 再試行ロジック（BLOCK: max 1回再試行、GREEN失敗: max 2回再試行、超過時ユーザーに報告）
- WARN自動進行の設計理由（PdM自律性、Progress Checklist で警告を可視化）
- Phase遷移時の Progress Checklist 出力（中間ステータス更新）

#### steps-teams.md

quality-gate/plan-review の steps-teams.md を踏襲:
- Team 作成 → Phase別 Teammate spawn → 結果検証 → Cleanup
- Fallback: Agent Teams 失敗時 → steps-subagent.md 切替

差分（既存パターンとの違い）:
- チーム名: `tdd-cycle`（1チームが全Phase を通して存続）
- マルチフェーズライフサイクル: quality-gate/plan-review は単一Phase（spawn→review→shutdown）だが、
  tdd-orchestrate は Phase ごとに Teammate を spawn/shutdown する反復パターン
- Phase別の Teammate 種類が変わる（architect, red-worker, green-worker, reviewer等）
- agent定義未作成の場合は general-purpose teammate に指示で代替（Cycle 4 で正式agent定義）

#### steps-subagent.md

Agent Teams 無効時のフォールバック:
- 既存の Skill() auto-transition チェーンを使用
- tdd-plan → plan-review → tdd-red → tdd-green → tdd-refactor → tdd-review → tdd-commit
- 注: quality-gate/plan-review の steps-subagent.md は並列実行だが、
  tdd-orchestrate は順次実行チェーン。これはオーケストレータの性質上の必然的差異

## Progress Log

### 2026-02-07 - INIT
- Cycle doc created
- Issue #49 から要件把握
- Risk: 10 (PASS) - 全ファイル新規作成、既存パターン踏襲
- Files: 4 (all new)

### 2026-02-07 - PLAN
- 設計ドキュメント Section 3-4 を精読
- quality-gate / plan-review の既存パターン確認
- Test List: 12 cases（TC-01〜TC-12）
- SKILL.md: 3ブロック + env var 分岐 + Progress Checklist
- reference.md: PdM責務 + 判断基準 + 再試行ロジック + Phase Ownership
- steps-teams.md: Team作成 → Phase別spawn → Cleanup + Fallback
- steps-subagent.md: Skill() auto-transition チェーン

### 2026-02-07 - plan-review
- Score: 62 (WARN) - usability-reviewer
- 反映:
  - TC-04 強化: Progress Checklist に 7 Phase を含むことを検証
  - TC-07 強化: 再試行の具体的上限回数を検証
  - TC-11 強化: 6スキル名の具体的参照を検証
  - TC-12 追加: SKILL.md の reference.md リンク検証
  - TC番号リナンバリング（TC-12→TC-13）
  - Progress Checklist ドラフト追加
  - reference.md 設計に再試行上限・WARN自動進行理由・中間ステータス更新を追加
  - steps-teams.md マルチフェーズライフサイクルの差分を明記
  - steps-subagent.md 逐次チェーンのパターン差分を明記
  - Files to Change に test-plugins-structure.sh 追加（5ファイル）
- 見送り:
  - WARN自動進行のUX変更（設計ドキュメントの意図的判断、reference.md で理由記載）

### 2026-02-07 - RED
- TC-OR-01〜TC-OR-12 を scripts/test-plugins-structure.sh に追加
- 結果: 107 passed, 12 failed (RED状態確認)

### 2026-02-07 - GREEN
- SKILL.md: 70行、3ブロック + env var分岐 + Progress Checklist + reference.mdリンク
- reference.md: PdM責務 + Phase Ownership + 判断基準 + 再試行ロジック + エスカレーション
- steps-teams.md: 4 Phase (Team作成/Block 1/Block 2/Block 3) + Fallback
- steps-subagent.md: Skill() 順次チェーン + 判断基準テーブル
- 結果: 119 passed, 0 failed

### 2026-02-07 - REVIEW
- quality-gate: WARN (max 62)
  - correctness: 55, performance: 25, security: 15, guidelines: 28, product: 62, usability: 62
- 反映: wc -l tr修正、reference.md COMMIT記述修正、steps-teams.md (Experimental)追加
- テスト: 119 passed, 0 failed

---

## Next Steps

1. [Done] INIT
2. [Done] PLAN
3. [Done] plan-review (WARN 62 → 修正反映済み)
4. [Done] RED (107 passed, 12 failed)
5. [Done] GREEN (119 passed, 0 failed)
6. [Done] REFACTOR (リファクタ不要)
7. [Done] REVIEW (quality-gate WARN 62, 119 passed)
8. [Done] COMMIT
