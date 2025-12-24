# Pre-commit Hook統合

Issue: #17

## Status: DONE

## INIT

### Scope Definition

tdd-onboardとtdd-commitにpre-commit hook関連機能を追加:

1. **tdd-onboard**: pre-commit hookの有無確認、セットアップ推奨
2. **tdd-commit**: テスト実行確認ステップ追加

### Target Files

- `plugins/tdd-core/skills/tdd-onboard/SKILL.md`
- `plugins/tdd-core/skills/tdd-onboard/reference.md`
- `plugins/tdd-core/skills/tdd-commit/SKILL.md`
- `plugins/tdd-core/skills/tdd-commit/reference.md`

### Out of Scope

- husky/lint-stagedの自動インストール
- 言語固有のhook設定

### Environment

- Claude Code Plugin形式
- Bash scripts for testing

## PLAN

### 設計方針

1. **tdd-reviewとの重複を避ける**: tdd-commitでは「テスト実行」ではなく「hook確認」のみ
2. **エッジケース対応**: .gitがない場合、hookがない場合を考慮
3. **推奨レベル**: 強制ではなく推奨として実装

### tdd-onboard への追加

**Step 6（新規）: Pre-commit Hook確認（推奨）**

```markdown
### Step 6: Pre-commit Hook確認（推奨）

Git環境とpre-commit hookを確認:

```bash
# Git初期化確認
ls -d .git 2>/dev/null

# Hook確認
ls .husky/pre-commit 2>/dev/null
ls .git/hooks/pre-commit 2>/dev/null
```

| 状態 | 対応 |
|------|------|
| .gitなし | 警告表示、スキップ |
| hookあり | 確認メッセージ |
| hookなし | セットアップ推奨 |
```

- 既存Step 6→7、Step 7→8に繰り下げ
- Progress Checklistに項目追加

### tdd-commit への追加

**Step 2（新規）: Pre-commit Hook確認**

```markdown
### Step 2: Pre-commit Hook確認

コミット時のテスト自動実行を確認:

```bash
ls .husky/pre-commit .git/hooks/pre-commit 2>/dev/null
```

| 状態 | メッセージ |
|------|-----------|
| hookあり | 「コミット時に自動実行されます」 |
| hookなし | 「手動でテスト実行を推奨（tdd-reviewで実行済みならOK）」 |
```

- 既存Step 2→3、Step 3→4...に繰り下げ
- Progress Checklistに項目追加

### ファイル変更詳細

| ファイル | 変更内容 |
|----------|----------|
| tdd-onboard/SKILL.md | Step 6追加、既存Step繰り下げ、Checklist更新 |
| tdd-onboard/reference.md | Hook検出の詳細、セットアップ推奨文言 |
| tdd-commit/SKILL.md | Step 2追加、既存Step繰り下げ、Checklist更新 |
| tdd-commit/reference.md | Hook確認の詳細 |

## Test List

### TODO

### WIP

### DONE
- [x] TC-01: tdd-onboard SKILL.mdにStep 6が存在する
- [x] TC-02: tdd-onboard Step 6で.git確認コマンドがある
- [x] TC-03: tdd-onboard Step 6でhook確認コマンドがある
- [x] TC-04: tdd-onboard Progress Checklistにhook確認項目がある
- [x] TC-05: tdd-commit SKILL.mdにStep 2（hook確認）が存在する
- [x] TC-06: tdd-commit Progress Checklistにhook確認項目がある

## Notes

### 背景
Claude Code Meetup Tokyo Q&A (2025/12/22)より:
> 内部で pre-tool-use hook を使って bash コマンドのセキュリティチェックをしている

テスト実行をコミット前に強制することで、品質を担保する。
