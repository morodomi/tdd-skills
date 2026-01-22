# Git Conventions

## コミットメッセージ形式

```
<type>: <subject>
```

## Type一覧

| Type | 説明 | 例 |
|------|------|-----|
| feat | 新機能 | feat: ログイン機能追加 |
| fix | バグ修正 | fix: パスワード検証エラー修正 |
| docs | ドキュメント | docs: README更新 |
| refactor | リファクタリング | refactor: 認証ロジック整理 |
| test | テスト | test: ログインテスト追加 |
| chore | その他 | chore: 依存関係更新 |

## 良いコミットメッセージ

```
feat: ユーザーログイン機能

- メールアドレスとパスワードでログイン
- セッション管理

Closes #123
```
