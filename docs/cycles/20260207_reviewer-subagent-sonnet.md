---
feature: reviewer-subagent-sonnet
cycle: 20260207_reviewer-subagent-sonnet
phase: PLAN
created: 2026-02-07 00:00
updated: 2026-02-07 00:20
---

# Reviewer Subagent + Sonnet 統一

## Scope Definition

### In Scope
- [ ] plan-review: Agent Teams有効時でもSubagentモードで実行するよう変更
- [ ] quality-gate: Agent Teams有効時でもSubagentモードで実行するよう変更
- [ ] 両スキルのSubagent起動時に model: sonnet を明示指定
- [ ] tdd-orchestrate steps-teams.md の plan-review / quality-gate 呼び出しを更新

### Out of Scope
- RED/GREEN/REFACTOR のモード変更 (Reason: 別サイクルで検討)
- Agent Teams モードの廃止 (Reason: review以外では引き続き有効)
- steps-teams.md の削除 (Reason: 討論モードは将来的に復活可能)

### Files to Change (target: 10 or less)
- plugins/tdd-core/skills/plan-review/SKILL.md (edit)
- plugins/tdd-core/skills/plan-review/steps-subagent.md (edit)
- plugins/tdd-core/skills/quality-gate/SKILL.md (edit)
- plugins/tdd-core/skills/quality-gate/steps-subagent.md (edit)
- plugins/tdd-core/skills/tdd-orchestrate/steps-teams.md (edit)

## Environment

### Scope
- Layer: N/A (Plugin skill definitions)
- Plugin: tdd-core
- Risk: 45 (WARN)

### Runtime
- Bash: 3.2.57
- Claude Code: 2.1.37

### Dependencies (key packages)
- Claude Code: 2.1.37 (Task tool model parameter)

## Context & Dependencies

### Reference Documents
- plugins/tdd-core/skills/plan-review/SKILL.md - 現行モード選択ロジック
- plugins/tdd-core/skills/quality-gate/SKILL.md - 現行モード選択ロジック
- plugins/tdd-core/skills/tdd-orchestrate/steps-teams.md - Agent Teams手順

### Dependent Features
- plan-review: 設計レビュー（5 reviewer）
- quality-gate: コードレビュー（6 reviewer）
- tdd-orchestrate: PdM オーケストレータ

### Related Issues/PRs
- (none)

## Test List

### TODO
(none)

### WIP
(none)

### DISCOVERED
(none)

### DONE
TC-01 ~ TC-15 (全件 PASS)

## Implementation Notes

### Goal
reviewer系（plan-review, quality-gate）をAgent Teams有効時でもSubagentモードで実行し、
モデルをSonnetに指定することで、トークン消費を大幅に削減する。

### Background
Agent Teamsモードでは各teammateが独自のコンテキストウィンドウを持ち、
討論フェーズ（broadcast + 反証ラウンド）でさらにトークンが増加する。
reviewer系は「独立にレビューし結果を返す」だけなので、
teammateの対話機能は不要。Subagent + Sonnetが最適。

### Design Approach

#### 方針: Review 系は常に Subagent + Sonnet

reviewer は「独立にレビューし JSON 結果を返す」だけで、相互の対話は不要。
Agent Teams の討論フェーズ（broadcast + 反証ラウンド）はトークン効率が悪い。

```
Before: 環境変数 → Agent Teams有効 → steps-teams.md（討論モード）
After:  環境変数に関わらず → steps-subagent.md（並行Subagent + Sonnet）
```

#### plan-review/SKILL.md の変更

モード選択テーブルを削除し、常に Subagent で実行:

```markdown
# Before
| 有効 (`1`) | 討論型 (Agent Teams) | steps-teams.md |
| 無効 / 未設定 | 並行型 (Subagent) | steps-subagent.md |

# After
常に並行型 (Subagent) で実行: [steps-subagent.md](steps-subagent.md)
モデル: Sonnet（トークン効率優先）
```

#### quality-gate/SKILL.md の変更

plan-review と同じパターン。

#### steps-subagent.md の変更（両方）

Task ツール起動時に `model: sonnet` を明示:

```
Task(subagent_type: "tdd-core:scope-reviewer", model: "sonnet")
```

#### tdd-orchestrate/steps-teams.md の変更

plan-review / quality-gate の呼び出しを teammate 起動から Skill 呼び出しに変更:

```markdown
# Before
### plan-review
5 reviewer teammate を起動し、設計レビューを実施:
→ 独立レビュー → 討論 → 合議判定 → shutdown

# After
### plan-review
Skill(tdd-core:plan-review) を実行（内部で Subagent 並行起動）
```

quality-gate も同様。これにより orchestrate は reviewer の実行モードを知らなくてよくなる。

#### steps-teams.md の保持方針

plan-review/steps-teams.md と quality-gate/steps-teams.md は残す。
SKILL.md からの参照を外すだけ。将来の討論モード復活時に再利用可能。

#### steps-teams.md の保持・明示 (plan-review 指摘対応)

SKILL.md にモード選択テーブルは残さないが、参考情報として記載:

```markdown
**注**: 討論型レビュー (Agent Teams) は現在無効（トークン効率優先）。
復活が必要な場合は [steps-teams.md](steps-teams.md) を参照。
```

#### Subagent 失敗時のフォールバック (plan-review 指摘対応)

steps-subagent.md にエラーハンドリングを追記:

```markdown
## エラー時
Subagent 起動失敗時は、順次実行にフォールバック:
1つずつ reviewer を起動し、結果を収集する。
```

#### model 指定の明示 (plan-review 指摘対応)

steps-subagent.md に Task() 呼び出しの具体例を記載:

```
Task(subagent_type: "tdd-core:scope-reviewer", model: "sonnet", prompt: "...")
```

#### 変更ファイル一覧
1. `plan-review/SKILL.md` - モード選択テーブル削除、常に Subagent + Sonnet、steps-teams.md 参考記載
2. `plan-review/steps-subagent.md` - model: sonnet 明示、Task()例、エラー時フォールバック
3. `quality-gate/SKILL.md` - モード選択テーブル削除、常に Subagent + Sonnet、steps-teams.md 参考記載
4. `quality-gate/steps-subagent.md` - model: sonnet 明示、Task()例、エラー時フォールバック
5. `tdd-orchestrate/steps-teams.md` - reviewer を Skill 呼び出しに変更

## Progress Log

### 2026-02-07 00:00 - INIT
- Cycle doc created
- Scope: plan-review + quality-gate のSubagent統一 + Sonnet指定
- Risk: 45 (WARN) - 既存フロー変更だが破壊的変更なし

### 2026-02-07 00:10 - PLAN
- 設計完了: review系は常にSubagent + Sonnet
- 変更ファイル5つ: plan-review(2) + quality-gate(2) + orchestrate(1)
- Test List: 11ケース

### 2026-02-07 00:20 - plan-review (WARN: 75)
- scope: 35, architecture: 65, risk: 75, product: 72, usability: 72
- 反映: steps-teams.md の参考リンク維持、Subagent失敗時フォールバック、model指定の明示
- 却下: A/Bテスト・段階的ロールアウト（過剰）、Sonnet品質懸念（ユーザー判断済み）
- Test List: 15ケースに拡充

---

## Next Steps

1. [Done] INIT
2. [Done] PLAN
3. [Done] plan-review (WARN: 75, 指摘反映済み)
4. [Done] RED (11/15 FAIL confirmed)
5. [Done] GREEN (15/15 PASS)
6. [Done] REFACTOR (Progress Checklist整合性修正、構造テスト更新)
7. [Next] REVIEW
8. [ ] COMMIT
