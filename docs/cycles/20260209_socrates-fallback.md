---
feature: socrates-fallback
cycle: 20260209_socrates-fallback
phase: DONE
created: 2026-02-09
updated: 2026-02-09
---

# Socrates Fallback on Failure

## Scope Definition

### In Scope
- [ ] reference.md: Socrates Protocol セクションに障害時フォールバックルール追加
- [ ] steps-teams.md: Socrates Protocol (plan-review / quality-gate) に障害時分岐追加

### Out of Scope
- socrates.md の変更 (agent 定義は変わらない)
- SKILL.md の変更
- Socrates Protocol の正常フロー変更

### Files to Change (target: 10 or less)
- plugins/tdd-core/skills/tdd-orchestrate/reference.md (edit)
- plugins/tdd-core/skills/tdd-orchestrate/steps-teams.md (edit)

## Environment

### Scope
- Layer: Markdown (Claude Code Plugin definitions)
- Plugin: tdd-core
- Risk: 25 (PASS)

### Runtime
- Claude Code Plugins

### Dependencies (key packages)
- socrates-advisor feature (commit 76f9fad)

## Context & Dependencies

### Reference Documents
- Parent cycle: docs/cycles/20260209_socrates-advisor.md

### Related Issues/PRs
- Issue #58: [DISCOVERED] Socrates 障害時のフォールバック

## PLAN

### 設計方針

Socrates が無応答/タイムアウト/異常応答の場合、v5.0 互換ロジックにフォールバック:
- WARN → 自動進行 (v5.0 互換)
- BLOCK → 自動再試行 (v5.0 互換)

フォールバック時は警告メッセージをユーザーに表示する。

### ファイル別変更内容

| ファイル | 変更内容 |
|---------|---------|
| reference.md | Socrates Protocol セクションに「### 障害時フォールバック」サブセクション追加 |
| steps-teams.md | plan-review / quality-gate の Socrates Protocol に障害時分岐を追記 (2箇所) |

## Test List

### DONE
- [x] TC-01: [正常系] reference.md に「障害時フォールバック」or「fallback」記述があること
- [x] TC-02: [正常系] reference.md にタイムアウト記述があること
- [x] TC-03: [正常系] reference.md に v5.0 互換ロジックへの参照があること
- [x] TC-04: [正常系] steps-teams.md に障害時/fallback の記述があること
- [x] TC-05: [回帰] 既存 test-socrates-advisor.sh が通ること
- [x] TC-06: [回帰] 既存 test-free-text-input.sh が通ること

### DISCOVERED
(none)

## Progress Log

- INIT: Cycle doc 作成、スコープ定義完了
- PLAN: 簡易設計完了、Test List 6件作成
- RED: テストスクリプト作成、2/6 FAIL 確認
- GREEN: reference.md にフォールバックセクション追加、6/6 PASS
- COMMIT: 完了
