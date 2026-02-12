---
feature: onboard-reference
cycle: onboard-reference-token-compression
phase: DONE
created: 2026-02-12 10:00
updated: 2026-02-12 10:00
---

# Onboard Reference Token Compression

## Scope Definition

### In Scope
- [ ] reference.md: 埋め込みテンプレート (CLAUDE.md, security.md, git-safety.md, git-conventions.md, recommended.md) を参照リンクに置換
- [ ] reference.md: docs テンプレート群 (README.md, STATUS.md, src/CLAUDE.md, tests/CLAUDE.md, docs/CLAUDE.md) を簡略化
- [ ] reference.md: Cycle doc テンプレート埋め込みを templates/cycle.md 参照に置換
- [ ] テストスクリプトが圧縮後も通ること確認

### Out of Scope
- SKILL.md の変更 (Reason: 既に100行以内、変更不要)
- 他のスキルの reference.md 圧縮 (Reason: 別サイクルで対応)
- テンプレート元ファイル (.claude/rules/, .claude/hooks/) の変更 (Reason: 参照先は変えない)

### Files to Change (target: 10 or less)
- plugins/tdd-core/skills/tdd-onboard/reference.md (edit)

## Environment

### Scope
- Layer: N/A (Markdown only)
- Plugin: tdd-core
- Risk: 15 (PASS)

### Runtime
- Bash 3.2.57

### Dependencies (key packages)
- N/A (Markdown files only)

## Context & Dependencies

### Reference Documents
- plugins/tdd-core/skills/tdd-onboard/reference.md - 圧縮対象 (12,163 bytes)
- plugins/tdd-core/skills/tdd-onboard/SKILL.md - 参照元 (変更なし)
- .claude/rules/security.md - テンプレート参照先
- .claude/rules/git-safety.md - テンプレート参照先
- .claude/rules/git-conventions.md - テンプレート参照先
- .claude/hooks/recommended.md - テンプレート参照先

### Dependent Features
- tdd-onboard スキル全体

### Related Issues/PRs
- (none)

## Test List

### TODO
- [ ] TC-01: reference.md のバイト数が 4,000 bytes 以下
- [ ] TC-02: reference.md に参照パスが含まれる (.claude/rules/security.md, .claude/rules/git-safety.md, .claude/rules/git-conventions.md, .claude/hooks/recommended.md)
- [ ] TC-03: reference.md に security.md の全文埋め込み (「ハードコードされた秘密鍵」等の本文) が含まれない
- [ ] TC-04: reference.md に git-safety.md の全文埋め込み (「force-with-leaseは許可」等の本文) が含まれない
- [ ] TC-05: reference.md に recommended.md の全文埋め込み (settings.json のJSON構造) が含まれない
- [ ] TC-06: reference.md にフレームワーク検出テーブルが残っている (artisan, app.py 等)
- [ ] TC-07: reference.md に変数一覧テーブルが残っている (${PROJECT_NAME} 等)
- [ ] TC-08: test-plugins-structure.sh が通る
- [ ] TC-09: test-skills-structure.sh が通る

### WIP
(none)

### DISCOVERED
(none)

### DONE
(none)

## Implementation Notes

### Goal
tdd-onboard/reference.md のテンプレート埋め込みを参照リンクに置換し、12,163 bytes → ~2,400 bytes に圧縮する。

### Background
tdd-onboard/reference.md (12,163 bytes) は、.claude/rules/ や .claude/hooks/ に既に存在するテンプレートを丸ごと埋め込んでいる。これはスキル実行時に全文ロードされるためトークンを無駄に消費する。埋め込みを参照リンクに置換することで ~9,700 bytes 削減可能。

### Design Approach
1. **REPLACE**: rules/hooks テンプレート埋め込み → 「Read で参照」指示に置換
   - security.md, git-safety.md, git-conventions.md → `.claude/rules/` 参照
   - recommended.md → `.claude/hooks/` 参照
   - 初期Cycle doc → `templates/cycle.md` 参照
2. **COMPRESS**: docs/ テンプレート、CLAUDE.md テンプレート → マージ戦略テーブル + 変数置換表のみ残す
   - tests/src/docs CLAUDE.md テンプレート → 1行サマリーに圧縮
3. **KEEP**: フレームワーク検出テーブル、変数一覧、エラーハンドリング (ランタイム必須)

## Progress Log

### 2026-02-12 10:00 - INIT
- Cycle doc created
- Scope definition ready
- 単一ファイル (reference.md) のリファクタ、Risk 15 (PASS)

---

## Next Steps

1. [Done] INIT
2. [Done] PLAN
3. [Done] RED
4. [Done] GREEN
5. [Done] REFACTOR
6. [Done] REVIEW
7. [Done] COMMIT
