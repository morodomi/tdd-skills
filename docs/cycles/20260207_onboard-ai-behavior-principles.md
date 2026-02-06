---
feature: onboard-ai-behavior-principles
cycle: onboard-ai-behavior-principles
phase: DONE
created: 2026-02-07
updated: 2026-02-07
---

# Onboard CLAUDE.md AI Behavior Principles

## Scope Definition

### In Scope
- [ ] tdd-onboard/reference.md の CLAUDE.md テンプレートに AI Behavior Principles セクション追加

### Out of Scope
- tdd-orchestrate (Cycle 3 #49 で対応)
- tdd-init の変更 (Cycle 4 #50 で対応)
- plan-review Agent Teams (Cycle 1 #47 で対応済み)

### Files to Change (target: 10 or less)
- plugins/tdd-core/skills/tdd-onboard/reference.md (edit)

## Environment

### Scope
- Layer: Plugin (Claude Code Plugin skill definition)
- Plugin: tdd-core
- Risk: 5 (PASS)

### Runtime
- Bash: 3.2.57
- Claude Code: 2.1.32

### Dependencies (key packages)
- docs/20260206_design_v5_pdm_delegation.md: Section 5.4 テンプレート内容

## Context & Dependencies

### Reference Documents
- docs/20260206_design_v5_pdm_delegation.md - v5.0 設計ドキュメント Section 5.4
- plugins/tdd-core/skills/tdd-onboard/reference.md - 現在の CLAUDE.md テンプレート

### Dependent Features
- tdd-onboard: plugins/tdd-core/skills/tdd-onboard/reference.md (編集対象)

### Related Issues/PRs
- Issue #48: feat: onboard CLAUDE.mdテンプレートにAI Behavior Principles追加

## Test List

### TODO
(none)

### WIP
(none)

### DISCOVERED
(none)

### DONE
- [x] TC-01: reference.md の CLAUDE.md テンプレートに `## AI Behavior Principles` ヘッダーが含まれる
- [x] TC-02: テンプレートに `### Role: PdM` セクションが含まれる
- [x] TC-03: テンプレートに `### Mandatory: AskUserQuestion` セクションが含まれる
- [x] TC-04: テンプレートに `### Delegation Strategy` + `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` が含まれる
- [x] TC-05: テンプレートに `### Delegation Rules` + 6項目（5 delegation + 1 AskUserQuestion）
- [x] TC-06: scripts/test-plugins-structure.sh 107 passed, 0 failed

## Implementation Notes

### Goal
tdd-onboard が生成する CLAUDE.md テンプレートに AI Behavior Principles セクションを追加し、
全プロジェクトで PdM 委譲パターンと AskUserQuestion 必須原則を標準化する。

### Background

v5.0 PdM Delegation Model の Phase 1 (Foundation)。
メインClaudeが PdM に徹し、実装・テスト・レビューを専門エージェントに委譲するパターンを、
CLAUDE.md テンプレートに組み込むことで、新規プロジェクトで自動的に適用される。

### Design Approach

reference.md の CLAUDE.md テンプレート（line 102-192）内、
Quality Standards セクション（line 162）の `---` 後、
Claude Code Configuration セクション（line 164）の前に
AI Behavior Principles セクションを挿入。

挿入位置:
```
## Quality Standards (既存)
---
## AI Behavior Principles ← ここに挿入
---
## Claude Code Configuration (既存)
```

追加内容（設計ドキュメント Section 5.4 より）:
- Role: PdM (Product Manager)
- Mandatory: AskUserQuestion
- Delegation Strategy (env var 分岐テーブル)
- Delegation Rules (5項目)

## Progress Log

### 2026-02-07 - INIT
- Cycle doc created
- Issue #48 から要件把握
- Risk: 5 (PASS) - 単一ファイルのテンプレート追記
- Files: 1 (edit)

### 2026-02-07 - PLAN
- 挿入位置確定: Quality Standards 後、Claude Code Configuration 前
- Test List: 6 cases
- 設計ドキュメント Section 5.4 の内容をそのまま適用

### 2026-02-07 - plan-review
- Score: 72 (WARN) - usability-reviewer
- 反映:
  - TC-01〜TC-05 のテスト記述を具体化（grep 可能な文字列指定）
- 見送り:
  - 具体的ツール呼び出し手順（各 Skill が担当、テンプレートは方針レベル）
  - セクション配置変更（既存構造の一貫性維持）
  - plugin.json バージョン（Cycle 5 #51 で対応）

---

## Next Steps

1. [Done] INIT
2. [Done] PLAN
3. [Done] plan-review (WARN 72 → 修正反映済み)
4. [Done] RED (102 passed, 5 failed)
5. [Done] GREEN (107 passed, 0 failed)
6. [Done] REFACTOR (リファクタ不要)
7. [Done] REVIEW (quality-gate WARN 72, 107 passed)
8. [Done] COMMIT
3. [ ] plan-review
4. [ ] RED
5. [ ] GREEN
6. [ ] REFACTOR
7. [ ] REVIEW
8. [ ] COMMIT
