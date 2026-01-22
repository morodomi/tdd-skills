# Cycle: git-conventions-template

## Meta

| Key | Value |
|-----|-------|
| Created | 2026-01-22 14:43 |
| Phase | COMMIT |
| Issue | #27 |
| Branch | issue-21 |

## Environment

| Tool | Version |
|------|---------|
| Bash | 3.2.57 (arm64-apple-darwin25) |
| OS | Darwin 25.2.0 |

## Goal

git-conventions.md テンプレートを tdd-onboard に追加する。

## Background

- #21 の plan-review で発見
- tdd-commit の SKILL.md:98 で `.claude/rules/git-conventions.md` を参照
- しかし tdd-onboard のテンプレート一覧には未登録
- 結果、tdd-onboard 実行時に git-conventions.md が生成されない

## Requirements

1. git-conventions.md テンプレートを reference.md に追加
2. SKILL.md の rules 一覧に追加
3. git-safety.md との責務分担を明確化

## Test List

### DONE
- [x] TC-01: [正常系] reference.md に git-conventions.md テンプレートが存在する
- [x] TC-02: [正常系] テンプレートにコミットメッセージ形式（Type一覧）が含まれる
- [x] TC-03: [正常系] SKILL.md の rules 一覧に git-conventions.md が含まれる

## Design

### 変更対象ファイル

| ファイル | 変更内容 |
|---------|----------|
| `plugins/tdd-core/skills/tdd-onboard/reference.md` | git-conventions.md テンプレート追加 |
| `plugins/tdd-core/skills/tdd-onboard/SKILL.md` | rules 一覧に追加 |

### 責務分担

| ファイル | 責務 |
|---------|------|
| git-safety.md | 破壊的操作の禁止 |
| git-conventions.md | コミットメッセージ形式 |

### テンプレート内容

```markdown
# Git Conventions

## コミットメッセージ形式

<type>: <subject>

## Type一覧

| Type | 説明 |
|------|------|
| feat | 新機能 |
| fix | バグ修正 |
| docs | ドキュメント |
| refactor | リファクタリング |
| test | テスト |
| chore | その他 |
```

### Plan Review

| Reviewer | スコア | 判定 |
|----------|--------|------|
| Scope | 25 | PASS |
| Architecture | 25 | PASS |
| Risk | 15 | PASS |

## Quality Gate

| Reviewer | スコア | 判定 |
|----------|--------|------|
| Security | 2 | PASS |
| Guidelines | 15 | PASS |
| Risk | 15 | PASS |
| Correctness | 15 | PASS (修正後) |

**修正**: ネストしたコードブロックのエスケープ追加

## Progress

| Phase | Status | Note |
|-------|--------|------|
| INIT | DONE | Cycle doc作成 |
| PLAN | DONE | Plan Review PASS (スコア25) |
| RED | DONE | 3テスト作成、全て失敗確認 |
| GREEN | DONE | 2ファイル変更、全テストPASS |
| REFACTOR | DONE | リファクタリング不要 |
| REVIEW | DONE | Quality Gate PASS、構文修正 |
| COMMIT | DONE | c59cf05 |
