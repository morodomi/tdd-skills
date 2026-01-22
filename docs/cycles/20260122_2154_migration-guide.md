---
feature: マイグレーションガイド作成 (v1.x → v2.0)
cycle: migration-guide-001
phase: INIT
created: 2026-01-22
updated: 2026-01-22
issue: "#26"
---

# マイグレーションガイド作成

## Status: DONE

## やりたいこと

既存ユーザー向けのマイグレーションガイドを作成する。
- `agent_docs/` → `.claude/` 構造変更の説明
- 手動マイグレーション手順
- CHANGELOG.md / README.md 更新

---

## Test List

- [x] TC-01: docs/MIGRATION.md が存在する
- [x] TC-02: MIGRATION.md に "Breaking Changes" または "破壊的変更" がある
- [x] TC-03: MIGRATION.md に手動マイグレーション手順（mkdir, mv等）がある
- [x] TC-04: CHANGELOG.md に "[2.0.0]" エントリがある
- [x] TC-05: README.md に "Migration" または "MIGRATION.md" リンクがある

---

## 設計

### 1. docs/MIGRATION.md

```markdown
# Migration Guide: v1.x → v2.0

## Breaking Changes

v2.0 では `agent_docs/` が `.claude/` 構造に変更されました。

| v1.x | v2.0 |
|------|------|
| agent_docs/ | .claude/rules/, .claude/hooks/ |

## Manual Migration

### Step 1: 新ディレクトリ作成
mkdir -p .claude/{rules,hooks}

### Step 2: ファイル移動/リネーム
（テーブル形式で対応表）

### Step 3: 新規ファイル追加
git-safety.md, security.md, hooks/recommended.md

### Step 4: CLAUDE.md 更新
Configuration セクション追加

### Step 5: 旧ディレクトリ削除
rm -rf agent_docs/

## Alternative: Re-run tdd-onboard
既存プロジェクトで `tdd-onboard` を再実行
```

### 2. CHANGELOG.md 更新

```markdown
## [2.0.0] - 2026-01-22

### BREAKING CHANGES

- `agent_docs/` → `.claude/rules/`, `.claude/hooks/` 構造に変更
  - 詳細: [Migration Guide](docs/MIGRATION.md)

### Added

- .claude/rules/git-safety.md: Git安全規則
- .claude/rules/git-conventions.md: Git規約
- .claude/rules/security.md: セキュリティチェックリスト
- .claude/hooks/recommended.md: 推奨Hooks設定
- CLAUDE.mdテンプレートに Configuration セクション追加

### Changed

- tdd-onboard: Step 6 を `.claude/` 構造生成に変更
- テストスクリプト: Progressive Disclosure パターン対応
```

### 3. README.md 更新

```markdown
## Migration

v1.x から v2.0 へのアップグレードは [Migration Guide](docs/MIGRATION.md) を参照してください。
```

（Installation セクションの後に追加）

### スコープ

| 項目 | 値 |
|------|-----|
| 変更ファイル | 3（MIGRATION.md新規, CHANGELOG.md, README.md） |
| ドキュメントのみ | はい |

---

## 実装メモ

- CHANGELOG.md の既存フォーマット（Keep a Changelog）に従う
- README.md は Installation の後に Migration セクション追加
