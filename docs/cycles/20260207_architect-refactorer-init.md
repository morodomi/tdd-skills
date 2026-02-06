---
feature: architect-refactorer-init
cycle: architect-refactorer-init
phase: DONE
created: 2026-02-07
updated: 2026-02-07
---

# Architect/Refactorer Agent定義 + tdd-init統合

## Scope Definition

### In Scope
- [ ] agents/architect.md 新規作成: PLAN実行専門Agent
- [ ] agents/refactorer.md 新規作成: REFACTOR実行専門Agent
- [ ] tdd-init/SKILL.md: Step 7 に Agent Teams分岐追加
- [ ] CLAUDE.md: Skills table に tdd-orchestrate 追加

### Out of Scope
- tdd-orchestrate の変更 (Cycle 3 #49 で完了)
- v5.0 リリースドキュメント (Cycle 5 #51 で対応)

### Files to Change (target: 10 or less)
- plugins/tdd-core/agents/architect.md (new)
- plugins/tdd-core/agents/refactorer.md (new)
- plugins/tdd-core/skills/tdd-init/SKILL.md (edit)
- CLAUDE.md (edit)
- scripts/test-plugins-structure.sh (edit: TC-AG-* テスト追加)

## Environment

### Scope
- Layer: Plugin (Claude Code Plugin agent/skill definition)
- Plugin: tdd-core
- Risk: 15 (PASS)

### Runtime
- Bash: 3.2.57
- Claude Code: 2.1.33

### Dependencies (key packages)
- docs/20260206_design_v5_pdm_delegation.md: 設計ドキュメント Section 5.3, 5.5
- agents/red-worker.md, agents/green-worker.md: 既存Agent定義の参考
- tdd-orchestrate/SKILL.md: 呼び出し先

## Context & Dependencies

### Reference Documents
- docs/20260206_design_v5_pdm_delegation.md - v5.0 設計ドキュメント Section 5.3, 5.5
- plugins/tdd-core/agents/green-worker.md - Agent定義パターン参考
- plugins/tdd-core/agents/red-worker.md - Agent定義パターン参考
- plugins/tdd-core/skills/tdd-orchestrate/steps-teams.md - architect/refactorer 参照元

### Dependent Features
- tdd-init: plugins/tdd-core/skills/tdd-init/SKILL.md (編集対象)
- tdd-core agents: plugins/tdd-core/agents/ (新規追加)

### Related Issues/PRs
- Issue #50: feat: architect/refactorer agent定義 + tdd-init統合

## Test List

### TODO
- [ ] TC-12: scripts/test-plugins-structure.sh 全テスト PASS

### WIP
(none)

### DISCOVERED
(none)

### DONE
- [x] TC-01: architect.md が存在し、YAML frontmatter に name: architect を含む
- [x] TC-02: architect.md が Skill(tdd-plan) / tdd-core:tdd-plan を参照する
- [x] TC-03: architect.md が Input/Output/Workflow/Principles セクションを含む
- [x] TC-04: refactorer.md が存在し、YAML frontmatter に name: refactorer を含む
- [x] TC-05: refactorer.md が Skill(tdd-refactor) / tdd-core:tdd-refactor を参照する
- [x] TC-06: refactorer.md が Input/Output/Workflow/Principles セクションを含む
- [x] TC-07: tdd-init/SKILL.md が CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS env var 分岐を含む
- [x] TC-08: tdd-init/SKILL.md が tdd-orchestrate を参照する
- [x] TC-09: tdd-init/SKILL.md が tdd-plan を参照する（後方互換）
- [x] TC-10: tdd-init/SKILL.md が 100行以下 (100行)
- [x] TC-11: CLAUDE.md Skills table が tdd-orchestrate を含む
- [x] TC-12: scripts/test-plugins-structure.sh 130 passed, 0 failed

## Implementation Notes

### Goal
tdd-orchestrate が委譲先として使う architect/refactorer Agent を定義し、
tdd-init から tdd-orchestrate を呼び出す統合を完了する。

### Background

v5.0 PdM Delegation Model の Cycle 4。
Cycle 3 (#49) で tdd-orchestrate を作成し、steps-teams.md で architect/refactorer を
`general-purpose` teammate として参照している。本 Cycle で正式な Agent 定義を作成し、
tdd-init から tdd-orchestrate を呼び出す統合を完了する。

### Design Approach

**方針: 既存パターン (green-worker/red-worker) 踏襲 + tdd-init 最小変更**

#### architect.md

green-worker/red-worker と同じ構造 (YAML frontmatter + Input/Output/Workflow/Principles):

- Input: cycle_doc パス
- Output: JSON (status, plan_completed, test_list_count, files)
- Workflow: Cycle doc 読み → Skill(tdd-plan) 実行 → 結果報告
- Principles: 設計に集中 / 実装コード禁止 / Leadに報告重視（直接ユーザー対話しない）

**注**: steps-teams.md の subagent_type は本Cycleでは `general-purpose` のまま維持。
Agent定義の作成のみ行い、steps-teams.md の型切替は後続タスクで対応する。

#### refactorer.md

同じ構造:

- Input: cycle_doc パス + target_files
- Output: JSON (status, files_modified, test_result)
- Workflow: Cycle doc 読み → Skill(tdd-refactor) 実行 → テスト確認 → 結果報告
- Principles: テスト維持 / 新機能禁止 / DRY・命名改善

#### tdd-init/SKILL.md (Step 7 変更)

env var 分岐を追加:

```
Step 7:
  CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1
    → Skill(tdd-core:tdd-orchestrate)
  else
    → Skill(tdd-core:tdd-plan)  (従来通り)
```

**行数戦略**: 現在99行。Step 7 の既存コードブロック(4行: バッククォート囲み + Skill呼び出し)を
インラインに書き換え、env var 分岐テーブル形式にすることで100行以下を維持する。

#### CLAUDE.md Skills table

tdd-orchestrate 行を追加:

```
| tdd-orchestrate | (内部: tdd-initから自動呼び出し) | PdMオーケストレータ（Agent Teams有効時） |
```

## Progress Log

### 2026-02-07 - INIT
- Cycle doc created
- Issue #50 から要件把握
- Risk: 15 (PASS) - 既存パターン踏襲 + tdd-init最小変更
- Files: 4 (2 new, 2 edit)

### 2026-02-07 - PLAN
- green-worker.md / red-worker.md のAgent定義パターン確認
- tdd-init/SKILL.md Step 7 の現状確認（無条件で tdd-plan 呼び出し）
- CLAUDE.md Skills table の現状確認（6スキル、tdd-orchestrate 未掲載）
- architect.md: tdd-plan 委譲Agent、Input/Output/Workflow/Principles 構成
- refactorer.md: tdd-refactor 委譲Agent、同構成
- tdd-init Step 7: env var 分岐 (orchestrate / tdd-plan)
- Test List: 12 cases (TC-01〜TC-12)
- Files: 5 (2 new, 2 edit, 1 test edit)

### 2026-02-07 - plan-review
- Score: 62 (WARN) - usability-reviewer
- 反映:
  - architect.md Principles: 「ユーザー確認重視」→「Leadに報告重視」(PdMモデル整合)
  - steps-teams.md: 本Cycleスコープ外を明記 (general-purpose維持)
  - tdd-init行数戦略: コードブロック→インラインテーブル形式で100行以下維持
  - CLAUDE.md: tdd-orchestrate を「内部スキル」として表記
- 見送り:
  - tdd-init モード表示（tdd-orchestrate Progress Checklistが代替）
  - TC-09 条件分岐コンテキスト強化（grepベースでは困難）
  - language_plugin Input追加（Cycle doc Environmentから取得可能）

### 2026-02-07 - RED
- TC-AG-01〜TC-AG-11 を scripts/test-plugins-structure.sh に追加
- 結果: 121 passed, 9 failed (RED状態確認)

### 2026-02-07 - GREEN
- architect.md: 42行、YAML frontmatter + Input/Output/Workflow/Principles
- refactorer.md: 49行、同構成
- tdd-init/SKILL.md Step 7: env var分岐テーブル形式、100行ちょうど
- CLAUDE.md: tdd-orchestrate を「内部スキル」として Skills table に追加
- テストスクリプト: CLAUDE_MD パス修正 (BASE_DIR→相対パス)
- 結果: 130 passed, 0 failed

### 2026-02-07 - REVIEW
- quality-gate: PASS (max 38)
  - correctness: 28, performance: 25, security: 15, guidelines: 25, product: 28, usability: 38
- 反映: refactorer.md にLead報告原則追加（architect.mdとの対称性）
- テスト: 130 passed, 0 failed

---

## Next Steps

1. [Done] INIT
2. [Done] PLAN
3. [Done] plan-review (WARN 62 → 修正反映済み)
4. [Done] RED (121 passed, 9 failed)
5. [Done] GREEN (130 passed, 0 failed)
6. [Done] REFACTOR (リファクタ不要)
7. [Done] REVIEW (quality-gate PASS 38, 130 passed)
8. [Done] COMMIT
