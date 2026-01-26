---
feature: tdd-core
cycle: 20260126_0940
phase: REVIEW
created: 2026-01-26 09:40
updated: 2026-01-26 09:40
---

# v3.2: 質問駆動強化 (WARN時の簡易質問)

## Scope Definition

### In Scope
- [ ] SKILL.md にWARN時の簡易質問ステップを追加
- [ ] reference.md にWARN時の質問テンプレート追加
- [ ] reference.ja.md にも同様の追加

### Out of Scope
- PASS時の変更（自動進行を維持）
- BLOCK時の変更（既存のBrainstorm質問を維持）
- PLANフェーズへの質問追加（別サイクルで検討）

### Files to Change (target: 10 or less)
- `plugins/tdd-core/skills/tdd-init/SKILL.md`（編集）
- `plugins/tdd-core/skills/tdd-init/reference.md`（編集）
- `plugins/tdd-core/skills/tdd-init/reference.ja.md`（編集）

## Environment

### Scope
- Layer: Plugin（Claude Code Skills）
- Plugin: tdd-core
- Risk: 15 (PASS) - ドキュメント変更のみ

### Runtime
- Claude Code Plugin: Markdown

### Dependencies (key packages)
- Issue #34: v3.2 質問駆動強化

## Context & Dependencies

### Reference Documents
- README.md Roadmap section
- 前回サイクル: 20260123_1443_brainstorm-enhancement.md

### Related Issues/PRs
- Issue #34: v3.2: 質問駆動強化 (WARN時の簡易質問追加)

## Test List

### TODO
(none)

### WIP
(none)

### DISCOVERED
(none)

### DONE
- [x] TC-01: SKILL.md に Step 4.6 (WARN Questions) がある
- [x] TC-02: SKILL.md の既存 Step 4.6 が Step 4.7 にリナンバーされている
- [x] TC-03: SKILL.md のテーブルに WARN → Step 4.6 参照がある
- [x] TC-04: reference.md に "WARN Questions" セクションがある
- [x] TC-05: reference.md に「代替アプローチ」質問テンプレートがある
- [x] TC-06: reference.md に「影響範囲」質問テンプレートがある
- [x] TC-07: reference.ja.md に "WARN質問" セクションがある
- [x] TC-08: reference.ja.md に「代替アプローチ」質問テンプレートがある
- [x] TC-09: reference.ja.md に「影響範囲」質問テンプレートがある
- [x] TC-10: SKILL.md が92行（100行以下）

## Implementation Notes

### Goal
WARN時（30-59）にも簡易質問を追加し、PLANフェーズ前に要件を固めることで手戻りを削減。

### Background
- v3.0.0: Risk Score + BLOCK時のリスクタイプ別質問を導入
- v3.1.0: BLOCK時のBrainstorm質問を追加
- v3.2.0: WARN時にも簡易質問を追加（今回）

### Design Approach
1. Step 4.6（WARN Questions）を新設、既存4.6→4.7にリナンバー
2. Step 4.5で WARN判定後、Step 5（スコープ確認）の前に実行
3. 質問は2問のみ（BLOCKの4問より軽量）:
   - 「代替アプローチは検討したか？」
   - 「影響範囲は把握しているか？」
4. WARN質問の結果はCycle docに記録しない（確認のみ）

### File Changes
1. **SKILL.md**: Step 4.6を追加、既存4.6→4.7にリナンバー
2. **reference.md**: WARN Questions セクションを追加
3. **reference.ja.md**: WARN質問セクションを追加

## Progress Log

### 2026-01-26 09:40 - INIT
- Cycle doc作成
- Issue #34 に対応
- Risk: 15 (PASS)

---

## Next Steps

1. [Done] INIT
2. [Done] PLAN
3. [Done] RED
4. [Done] GREEN
5. [Done] REFACTOR
6. [Done] REVIEW <- Current
7. [ ] COMMIT
