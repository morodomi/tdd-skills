# Cycle: git-safety-rules-template

## Meta

| Key | Value |
|-----|-------|
| Created | 2026-01-22 13:48 |
| Phase | COMMIT |
| Issue | #21 |
| Branch | issue-21 |

## Environment

| Tool | Version |
|------|---------|
| Bash | 3.2.57 (arm64-apple-darwin25) |
| OS | Darwin 25.2.0 |

## Goal

Git安全ルールのテンプレート（`rules/git-safety.md`）を作成する。

## Background

- 親Issue: #19
- 依存: #20（構造変更）完了済み

## Requirements

1. テンプレートファイル `rules/git-safety.md` を作成
2. `reference.md` に追加
3. `SKILL.md` で生成するよう修正

## Test List

### DONE
- [x] TC-01: [正常系] reference.md に git-safety.md テンプレートが存在する
- [x] TC-02: [正常系] テンプレートに「禁止事項」セクションが含まれる
- [x] TC-03: [正常系] テンプレートに「推奨フロー」セクションが含まれる
- [x] TC-04: [正常系] テンプレートに「ブランチ保護」テーブルが含まれる
- [x] TC-05: [正常系] SKILL.md の rules 一覧に git-safety.md が含まれる

## Design

### 変更対象ファイル

| ファイル | 変更内容 |
|---------|----------|
| `plugins/tdd-core/skills/tdd-onboard/reference.md` | git-safety.md テンプレート追加（351行目以降） |
| `plugins/tdd-core/skills/tdd-onboard/SKILL.md` | Step 6 の rules 一覧に追加 |

### テンプレート内容

```markdown
# Git Safety Rules

## 禁止事項
- `--no-verify` の使用禁止
- `main`/`master` への直接push禁止
- `--force` push禁止（force-with-leaseは許可）
- 秘密鍵・認証情報のコミット禁止

## 推奨フロー
1. `develop` or `feature/*` ブランチで作業
2. PR経由で `main` にマージ
3. pre-commit hook を必ず通す

## ブランチ保護
| ブランチ | push | force push | 直接commit |
|---------|------|------------|-----------|
| main    | X    | X          | X         |
| develop | !    | X          | !         |
| feature/* | OK | X          | OK        |
```

### Plan Review

| Reviewer | スコア | 判定 |
|----------|--------|------|
| Scope | 15 | PASS |
| Architecture | 25 | PASS |
| Risk | 15 | PASS |

**関連Issue**: #27 (git-conventions.md 検討)

## Quality Gate

| Reviewer | スコア | 判定 |
|----------|--------|------|
| Security | 5 | PASS |
| Guidelines | 15 | PASS |
| Risk | 15 | PASS |
| Correctness | 15 | PASS |

**最大スコア: 15 → 判定: PASS**

## Progress

| Phase | Status | Note |
|-------|--------|------|
| INIT | DONE | Cycle doc作成 |
| PLAN | DONE | Plan Review PASS (スコア25) |
| RED | DONE | 5テスト作成、全て失敗確認 |
| GREEN | DONE | 2ファイル変更、全テストPASS |
| REFACTOR | DONE | リファクタリング不要 |
| REVIEW | DONE | Quality Gate PASS (スコア15) |
| COMMIT | DONE | 6df2af8 |
