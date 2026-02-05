# Cycle: skill-md-unification

## Meta

| 項目 | 値 |
|------|-----|
| Created | 2026-02-05 09:26 |
| Issue | #43 |
| Phase | DONE |
| Risk | 20 (PASS) |

## Environment

| 項目 | 値 |
|------|-----|
| OS | macOS (Darwin 25.2.0) |
| Bash | 3.2.57 |
| Project | tdd-skills |

## Goal

SKILL.mdファイルの言語・形式を統一する。

1. 全SKILL.mdを英語に統一
2. Progress Checklistをチェックボックス形式に統一
3. tdd-plan/SKILL.mdの詳細をreference.mdに移動

## Scope

- plugins/tdd-core/skills/*/SKILL.md（全スキル）
- 対象外: reference.md（必要に応じて追記のみ）

## Out of Scope

- 機能変更
- reference.mdの大幅な変更
- 他プラグイン（tdd-php, tdd-python等）

## Decisions

- 英語化: tdd-initを基準とする
- Progress Checklist: チェックボックス形式（```markdown code block）
- 100行制限: 超過時はreference.mdに移動

## PLAN

### 背景

Issue #43で検出された課題。quality-gateのguidelines-reviewer/usability-reviewerが指摘。

### 現状分析

- 言語: 全SKILL.md英語化済み（対応不要）
- Progress Checklist: 6ファイルが未統一

| Status | Skills |
|--------|--------|
| checkbox (OK) | plan-review, tdd-red, tdd-green, quality-gate |
| other (要修正) | tdd-init, tdd-onboard, tdd-plan, tdd-refactor, tdd-review, tdd-commit |

### 設計方針

1. Progress Checklistをチェックボックス形式（`- [ ]`）に統一
2. 既存のcheckbox形式スキルを参照パターンとする
3. 100行制限を維持

### 変更ファイル

| ファイル | 変更内容 |
|----------|----------|
| tdd-init/SKILL.md | Progress Checklist → checkbox形式 |
| tdd-onboard/SKILL.md | Progress Checklist → checkbox形式 |
| tdd-plan/SKILL.md | Progress Checklist → checkbox形式 |
| tdd-refactor/SKILL.md | Progress Checklist → checkbox形式 |
| tdd-review/SKILL.md | Progress Checklist → checkbox形式 |
| tdd-commit/SKILL.md | Progress Checklist → checkbox形式 |

## Test List

### DONE
- [x] TC-01: tdd-init Progress Checklistがcheckbox形式であること
- [x] TC-02: tdd-onboard Progress Checklistがcheckbox形式であること
- [x] TC-03: tdd-plan Progress Checklistがcheckbox形式であること
- [x] TC-04: tdd-refactor Progress Checklistがcheckbox形式であること
- [x] TC-05: tdd-review Progress Checklistがcheckbox形式であること
- [x] TC-06: tdd-commit Progress Checklistがcheckbox形式であること
- [x] TC-07: 全SKILL.mdが100行以下であること
- [x] TC-08: scripts/test-plugins-structure.sh が通ること

## Progress

| Phase | Status | Notes |
|-------|--------|-------|
| INIT | Done | Cycle doc created |
| PLAN | Done | 8 test cases |
| RED | Done | 2 tests failing (TC-01,03) |
| GREEN | Done | All 8 tests passed |
| REFACTOR | Done | Updated Part 1 tests |
| REVIEW | Done | quality-gate PASS (max 42) |
| COMMIT | Done | |
