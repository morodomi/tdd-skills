---
feature: tdd-core
cycle: 20260123_1352
phase: DONE
created: 2026-01-23 13:52
updated: 2026-01-23 14:00
---

# tdd-init Documentation Refactoring

## Scope Definition

### 今回実装する範囲
- [ ] SKILL.md を英語化（プロモーション用）
- [ ] reference.md を英語化
- [ ] reference.ja.md 作成（日本語ユーザー向け）
- [ ] templates/cycle.md を英語化
- [ ] 内容の正確性を確認・修正

### 今回実装しない範囲
- 他のスキル（tdd-plan, tdd-red等）のドキュメント整理
- tdd-core全体のREADME変更

### 変更予定ファイル（目安: 10以下）
- `plugins/tdd-core/skills/tdd-init/SKILL.md`（英語化）
- `plugins/tdd-core/skills/tdd-init/reference.md`（英語化）
- `plugins/tdd-core/skills/tdd-init/reference.ja.md`（新規）
- `plugins/tdd-core/skills/tdd-init/templates/cycle.md`（英語化）

## Environment

### Scope
- Layer: Plugin（Claude Code Skills）
- Plugin: tdd-core
- Risk: 10 (PASS) - ドキュメント変更のみ

### Runtime
- Claude Code Plugin: Markdown

### Dependencies（主要）
- Phase 5 (質問駆動INIT) 完了済み

## Context & Dependencies

### 参照ドキュメント
- [docs/cycles/20260123_1333_question-driven-init.md] - Phase 5完了

### 設計の要件
```
- 英語ドキュメントを基本とし、プロモーション可能に
- 日本語ファイル（reference.ja.md）も提供
- 内容の正確性を確保
```

## Test List

### TODO
- [ ] TC-01: SKILL.md が英語で記述されている
- [ ] TC-02: reference.md が英語で記述されている
- [ ] TC-03: reference.ja.md が日本語で存在する
- [ ] TC-04: templates/cycle.md が英語で記述されている
- [ ] TC-05: SKILL.md が100行以下

### WIP
（現在なし）

### DISCOVERED
（現在なし）

### DONE
（現在なし）

## Implementation Notes

### やりたいこと
tdd-initドキュメントを整理し、英語を基本としてプロモーション可能な状態にする。

### 背景
現在のドキュメントは日本語で記述されており、国際的なプロモーションに適していない。

### 設計方針
1. SKILL.md: 英語化（Progressive Disclosure の入口）
2. reference.md: 英語化（詳細リファレンス）
3. reference.ja.md: 日本語版リファレンス（新規作成）
4. templates/cycle.md: 英語化（テンプレート）

## Progress Log

### 2026-01-23 13:52 - INIT
- Cycle doc作成
- スコープ定義完了
- リスクスコア: 10 (PASS)

### 2026-01-23 13:54 - GREEN
- SKILL.md 英語化 (99行)
- reference.md 英語化
- reference.ja.md 新規作成（日本語版）
- templates/cycle.md 英語化

### 2026-01-23 13:58 - REVIEW
- テストスクリプト作成: scripts/test-tdd-init-docs.sh
- 全テスト通過（12 passed）
- プラグイン構造テスト通過（47 passed）

---

## 次のステップ

1. [完了] INIT
2. [完了] PLAN
3. [完了] RED
4. [完了] GREEN
5. [完了] REFACTOR
6. [完了] REVIEW
7. [完了] COMMIT
