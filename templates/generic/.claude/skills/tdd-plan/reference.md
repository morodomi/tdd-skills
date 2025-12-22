# tdd-plan Reference

SKILL.mdの詳細情報。必要時のみ参照。

## 実装計画の詳細

### アーキテクチャ確認

プロジェクトの構造を確認:
- Controller/Service/Repository パターン
- Clean Architecture
- MVC

### 品質基準

デフォルト:
- テストカバレッジ: 90%以上
- 静的解析: エラー0件

### Test List設計

**Given/When/Then形式**:

```
TC-01: ユーザーが有効な認証情報でログインできる
  Given: 有効なユーザーが存在する
  When: 正しい認証情報でログイン
  Then: ダッシュボードにリダイレクト
```

**テストカテゴリ**:
- 正常系: 期待通りの動作
- 異常系: エラーハンドリング
- 境界値: 限界値のテスト
- 権限: 認可のテスト

## Error Handling

### Cycle docが見つからない

```
⚠️ Cycle docが見つかりません。

tdd-init を先に実行してください。
```

### INITセクションが不完全

```
⚠️ INITセクションが不完全です。

Scope Definitionを確認してください。
```
