# tdd-plan Reference

SKILL.mdの詳細情報。必要時のみ参照。

## タスク粒度

### 基準: 2-5分で完了する1アクション

各タスクは「2-5分で完了できる1つのアクション」に分割する。

| 粒度 | 判断 | 対応 |
|------|------|------|
| 2-5分 | 適切 | そのまま |
| 5分超 | 大きすぎ | 分割する |
| 2分未満 | 小さすぎ | 統合を検討 |

### 分割の例

**悪い例（大きすぎ）**:
```
- [ ] TC-01: ユーザー認証機能を実装する
```

**良い例（2-5分に分割）**:
```
- [ ] TC-01: User モデルに password_hash カラムを追加
- [ ] TC-02: AuthService に verifyPassword メソッドを追加
- [ ] TC-03: LoginController に認証ロジックを実装
- [ ] TC-04: 認証失敗時のエラーレスポンスを実装
- [ ] TC-05: 認証成功時のセッション生成を実装
```

### 1アクションの定義

| アクション | 例 |
|-----------|-----|
| テストを書く | `test_user_can_login()` を作成 |
| テストを実行 | `pytest tests/test_auth.py` |
| 最小実装 | `verifyPassword()` を実装 |
| リファクタ | 重複コードを共通化 |
| コミット | `git commit` |

### なぜ2-5分か

- 短すぎる → オーバーヘッドが増える
- 長すぎる → AIが推測で補完し始める
- 2-5分 → 集中力が維持でき、逸脱を防げる

参考: [superpowers/writing-plans](https://github.com/obra/superpowers/blob/main/skills/writing-plans/SKILL.md)

## リスクスコア連動の詳細

### スコア閾値（tdd-init/plan-review/quality-gateと統一）

| スコア | 判定 | 設計深度 | 内容 |
|--------|------|----------|------|
| 0-29 | PASS | 簡易設計 | Test Listのみ、対話省略可 |
| 30-59 | WARN | 標準設計 | 現行通り（対話 + Test List） |
| 60-100 | BLOCK | 詳細設計 | セキュリティ、エラーハンドリング、アーキテクチャ検討 |

### BLOCK時の詳細設計（スコア60以上）

以下の観点を追加で検討:

1. **セキュリティ考慮**
   - 入力検証（SQLi, XSS, パストラバーサル）
   - 認証・認可のチェックポイント
   - 機密データの取り扱い

2. **エラーハンドリング**
   - 外部依存の失敗時の挙動
   - ロールバック戦略
   - ユーザーへのエラーメッセージ

3. **アーキテクチャ検討**
   - 既存コードへの影響範囲
   - 依存関係の方向性
   - テスタビリティ

### PASS時の簡易設計（スコア29以下）

- Step 3（対話）を省略可能
- Test List作成に集中
- plan-reviewもスキップ可能

### Riskフィールドなしの場合

後方互換性のため、WARN（標準設計）として扱う。

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

## クロスレイヤー検出

### Step 5.5: tdd-parallel 提案条件

`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` が有効な場合のみ実行。

| 検出条件 | 判定 |
|---------|------|
| Scope Layer が "Both" | クロスレイヤー |
| In Scope に Backend + Frontend が含まれる | クロスレイヤー |
| Files to Change に 3+ ディレクトリ接頭辞 | クロスレイヤー |

検出時: AskUserQuestion で「tdd-parallel（並列開発）を利用しますか？」と提案。

ユーザーが承認 → Cycle doc に記録。plan-review 後、RED の代わりに `Skill(tdd-core:tdd-parallel)` を実行（tdd-parallel 内で RED→GREEN→REFACTOR→REVIEW を実行）。
ユーザーが拒否 → 通常の tdd-red → tdd-green → tdd-refactor。

## Phase Completion

PLANフェーズ完了後の圧縮ガイダンス。

### チェックリスト

- [ ] Cycle doc の Design Approach が記録済み
- [ ] Test List が Cycle doc に記録済み

上記が確認できたら、コンテキスト圧縮が可能です。
Cycle doc に全情報が記録されているため、圧縮後も安全に再開できます。

## エラーメッセージ設計

異常系テストケース作成時に参照。ユーザーフレンドリーなエラーメッセージを設計する。

### 原則

1. **ポジティブフレーミング**: 否定形より肯定形で表現
2. **ユーザーを責めない**: システム視点で状況を説明
3. **次のアクションを提示**: 何をすべきか明示する
4. **技術用語を避ける**: ユーザー視点の言葉を使用

### パターン表

| 避ける | 推奨 |
|--------|------|
| 0件見つかりました | 該当するデータがありません |
| 入力が間違っています | 有効な形式で入力してください |
| 権限がありません | この操作には管理者権限が必要です |
| エラーが発生しました | 処理を完了できませんでした。再度お試しください |
| 無効な値です | 1以上の数値を入力してください |
| 失敗しました | 保存できませんでした。接続を確認してください |

### 適用例

```php
// Before
throw new Exception('Invalid email format');

// After
throw new ValidationException('有効なメールアドレスを入力してください');
```

```python
# Before
raise ValueError("File not found")

# After
raise FileNotFoundError("指定されたファイルが見つかりません。パスを確認してください。")
```
