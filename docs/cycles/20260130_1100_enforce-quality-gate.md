---
feature: enforce-quality-gate
cycle: 20260130_1100
phase: DONE
created: 2026-01-30 11:00
updated: 2026-01-30 11:00
---

# Enforce quality-gate in tdd-review

## Scope Definition

### In Scope
- [ ] tdd-review/SKILL.mdでquality-gateを必須・スキップ不可と明記
- [ ] Progress Checklistでquality-gateの必須性を強調

### Out of Scope
- quality-gateスキル自体の変更 (Reason: 別スコープ)
- reference.mdの変更 (Reason: SKILL.mdの変更で十分)

### Files to Change (target: 10 or less)
- plugins/tdd-core/skills/tdd-review/SKILL.md (edit)

## Environment

### Scope
- Layer: N/A (documentation only)
- Plugin: N/A
- Risk: 5 (PASS)

### Runtime
- Bash 3.2.57

### Dependencies (key packages)
- None

## Context & Dependencies

### Related Issues/PRs
- Issue #38: tdd-reviewでquality-gateを必須実行にする

## Test List

### TODO
(none)

### WIP
(none)

### DISCOVERED
(none)

### DONE
- [x] TC-01: tdd-review/SKILL.mdにquality-gateが「必須」と記載されていること
- [x] TC-02: tdd-review/SKILL.mdにquality-gateが「スキップ不可」と記載されていること
- [x] TC-03: 既存の構造テストがPASSすること

## Implementation Notes

### Goal
tdd-reviewフェーズでquality-gateが必ず実行されるよう、SKILL.mdの記述を強化する。

### Background
現在のtdd-review/SKILL.mdではStep 4に「quality-gateスキルを自動実行」と書いてあるが、
「自動実行」という表現が曖昧で、スキップされることがある。

### Design Approach
- Step 4の見出しを「quality-gate（必須）」に変更
- 「スキップ不可」を明記
- Progress Checklistのquality-gate行に「必須」を追加

## Progress Log

### 2026-01-30 11:00 - INIT
- Cycle doc created
- 1 file to change

---

## Next Steps

1. [Done] INIT
2. [Done] PLAN
3. [Done] RED
4. [Done] GREEN
5. [Done] REFACTOR
6. [Done] REVIEW
7. [Done] COMMIT <- Current
3. [ ] RED
4. [ ] GREEN
5. [ ] REFACTOR
6. [ ] REVIEW
7. [ ] COMMIT
