# tdd-commit Reference

SKILL.mdの詳細情報。必要時のみ参照。

## コミットメッセージ詳細

### Type一覧

| Type | 説明 | 例 |
|------|------|-----|
| feat | 新機能 | feat: ログイン機能追加 |
| fix | バグ修正 | fix: パスワード検証エラー修正 |
| docs | ドキュメント | docs: README更新 |
| refactor | リファクタリング | refactor: 認証ロジック整理 |
| test | テスト | test: ログインテスト追加 |
| chore | その他 | chore: 依存関係更新 |

### 良いコミットメッセージ

```
feat: ユーザーログイン機能

- メールアドレスとパスワードでログイン
- セッション管理
- ログアウト機能

Closes #123

🤖 Generated with Claude Code

Co-Authored-By: Claude <noreply@anthropic.com>
```

## Error Handling

### コミットが失敗した場合

```
⚠️ コミットが失敗しました。

確認:
1. pre-commit hookのエラー
2. コミットメッセージのフォーマット
3. ステージングされたファイル
```

### pushを求められた場合

```
コミットは完了しました。

pushは明示的に要求された場合のみ実行します。
pushしますか？
```

## Cycle doc完了形式

```markdown
---
feature: auth
cycle: login-implementation
phase: DONE
created: 2025-01-15 10:00
updated: 2025-01-15 15:30
---

# ユーザーログイン機能

## Test List

### DONE
- [x] TC-01: 有効な認証情報でログイン成功
- [x] TC-02: 無効なパスワードでエラー
- [x] TC-03: 存在しないユーザーでエラー

## Progress Log

### 2025-01-15 15:30 - COMMIT
- コミット完了: abc1234
- TDDサイクル完了
```
