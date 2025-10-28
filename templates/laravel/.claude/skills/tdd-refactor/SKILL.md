---
name: tdd-refactor
description: REFACTORフェーズ用。GREENフェーズで作成した実装をリファクタリングし、コード品質を改善する。テストを維持しながら、DRY原則の適用、定数化、メソッド分割、ネーミング改善等を行う。ユーザーが「refactor」「リファクタリング」と言った時、GREENフェーズ完了後、または /tdd-refactor コマンド実行時に使用。
allowed-tools: Read, Write, Edit, Grep, Glob, Bash
---

# TDD REFACTOR Phase

あなたは現在 **REFACTORフェーズ** にいます。

## このフェーズの目的

GREENフェーズで作成した実装をリファクタリングし、コード品質を改善することです。
**テストを維持しながら**、より良いコードに改善します。

## このフェーズでやること

- [ ] 最新のTDDドキュメントを検索する（`ls -t docs/202*.md | head -1`）
- [ ] すべてのテストが通っていることを確認する
- [ ] TDDドキュメントの品質基準を確認する
- [ ] リファクタリングを行う（DRY、定数化、メソッド分割等）
- [ ] 各変更後にテストを実行する
- [ ] 品質チェックツールを実行する（PHPStan, Pint, カバレッジ）
- [ ] 次のフェーズ（REVIEW）を案内する

## このフェーズで絶対にやってはいけないこと

- テストを変更すること（機能追加ではない）
- 新機能を追加すること（別のTDDサイクルで行う）
- テストを失敗させたままにすること
- 品質チェックをスキップすること

## ワークフロー

### 1. 準備フェーズ

まず、テストがすべて通っていることを確認してください：

```bash
# テスト実行
php artisan test
```

すべてのテストが通っていない場合：
```
REFACTORフェーズを開始できません。
すべてのテストが通っていることが前提条件です。

GREENフェーズに戻って、テストを通してください。
```

次に、TDDドキュメントの品質基準を確認します：

```bash
# 最新のTDDドキュメントを検索
ls -t docs/202*.md 2>/dev/null | head -1

# TDDドキュメントの読み込み
Read docs/YYYYMMDD_hhmm_<機能名>.md
```

品質基準を確認：
- テストカバレッジ目標
- PHPStanレベル
- その他の品質基準

### 2. リファクタリングフェーズ

以下の順序でリファクタリングを行ってください：

#### 2.1 重複コード削除（DRY原則）

**目的**: Don't Repeat Yourself - 同じコードを繰り返さない

**手順**:
1. 重複コードを探す
2. 共通メソッドを抽出
3. テストを実行して確認

**例**:

悪い例（重複あり）:
```php
public function createUser($data)
{
    if (!isset($data['name']) || empty($data['name'])) {
        throw new ValidationException('Name is required');
    }
    return User::create($data);
}

public function updateUser($id, $data)
{
    if (!isset($data['name']) || empty($data['name'])) {
        throw new ValidationException('Name is required');
    }
    return User::find($id)->update($data);
}
```

良い例（共通化）:
```php
private function validateName($data)
{
    if (!isset($data['name']) || empty($data['name'])) {
        throw new ValidationException('Name is required');
    }
}

public function createUser($data)
{
    $this->validateName($data);
    return User::create($data);
}

public function updateUser($id, $data)
{
    $this->validateName($data);
    return User::find($id)->update($data);
}
```

**各変更後にテストを実行**:
```bash
php artisan test
```

#### 2.2 マジックナンバー/文字列の定数化

**目的**: 意味を明確にし、変更を容易にする

**手順**:
1. マジックナンバーや文字列を探す
2. 適切な定数に置き換える
3. テストを実行して確認

**例**:

悪い例（マジックナンバー）:
```php
public function getTaxRate()
{
    return 0.1; // 10%
}

public function getDiscountRate($type)
{
    if ($type === 'premium') {
        return 0.2;
    }
    return 0.05;
}
```

良い例（定数化）:
```php
private const TAX_RATE = 0.1;
private const DISCOUNT_RATE_PREMIUM = 0.2;
private const DISCOUNT_RATE_STANDARD = 0.05;

public function getTaxRate()
{
    return self::TAX_RATE;
}

public function getDiscountRate($type)
{
    if ($type === 'premium') {
        return self::DISCOUNT_RATE_PREMIUM;
    }
    return self::DISCOUNT_RATE_STANDARD;
}
```

**各変更後にテストを実行**:
```bash
php artisan test
```

#### 2.3 長いメソッドの分割

**目的**: 単一責任の原則、可読性向上

**手順**:
1. 長いメソッド（20行以上が目安）を探す
2. 論理的な単位で分割
3. テストを実行して確認

**例**:

悪い例（長いメソッド）:
```php
public function process($data)
{
    // バリデーション
    if (!isset($data['name'])) {
        throw new ValidationException('Name is required');
    }

    // データ加工
    $data['name'] = trim($data['name']);
    $data['email'] = strtolower($data['email']);

    // 保存
    $user = User::create($data);

    // 通知送信
    Mail::to($user->email)->send(new WelcomeEmail($user));

    // ログ記録
    Log::info('User created', ['user_id' => $user->id]);

    return $user;
}
```

良い例（分割）:
```php
public function process($data)
{
    $this->validate($data);
    $data = $this->sanitize($data);
    $user = $this->save($data);
    $this->sendNotification($user);
    $this->log($user);

    return $user;
}

private function validate($data)
{
    if (!isset($data['name'])) {
        throw new ValidationException('Name is required');
    }
}

private function sanitize($data)
{
    $data['name'] = trim($data['name']);
    $data['email'] = strtolower($data['email']);
    return $data;
}

private function save($data)
{
    return User::create($data);
}

private function sendNotification($user)
{
    Mail::to($user->email)->send(new WelcomeEmail($user));
}

private function log($user)
{
    Log::info('User created', ['user_id' => $user->id]);
}
```

**各変更後にテストを実行**:
```bash
php artisan test
```

#### 2.4 複雑な条件式の簡潔化

**目的**: 可読性向上、保守性向上

**手順**:
1. 複雑な条件式を探す
2. 意味のあるメソッドに抽出
3. テストを実行して確認

**例**:

悪い例（複雑な条件）:
```php
if ($user->role === 'admin' || ($user->role === 'editor' && $user->permissions->contains('publish'))) {
    return true;
}
```

良い例（メソッド抽出）:
```php
if ($this->canPublish($user)) {
    return true;
}

private function canPublish($user)
{
    return $user->role === 'admin'
        || ($user->role === 'editor' && $user->permissions->contains('publish'));
}
```

**各変更後にテストを実行**:
```bash
php artisan test
```

#### 2.5 ネーミング改善

**目的**: コードの意図を明確にする

**手順**:
1. 不明確な名前を探す
2. 意味のある名前に変更
3. テストを実行して確認

**例**:

悪い例（不明確な名前）:
```php
public function get($id)
{
    $u = User::find($id);
    $d = $u->data;
    return $d;
}
```

良い例（明確な名前）:
```php
public function getUserData($userId)
{
    $user = User::find($userId);
    $userData = $user->data;
    return $userData;
}
```

**各変更後にテストを実行**:
```bash
php artisan test
```

### 3. 品質チェックフェーズ

リファクタリングが完了したら、品質チェックツールを実行してください：

#### 3.1 PHPStan実行

```bash
# PHPStan実行（Level 8）
vendor/bin/phpstan analyse
```

**期待結果**:
- エラー: 0件
- Level: 8

**エラーがある場合**:
- エラー内容を確認
- 型定義を追加
- null安全性を改善
- 再度実行

#### 3.2 Laravel Pint実行

```bash
# Laravel Pint実行（コード整形）
vendor/bin/pint
```

**期待結果**:
- PSR-12準拠
- コードが整形される

#### 3.3 テストカバレッジ確認

```bash
# テストカバレッジ確認
php artisan test --coverage
```

**期待結果**:
- カバレッジ: 90%以上

**90%未満の場合**:
```
警告: テストカバレッジが90%未満です。
現在: XX%

以下の対応を検討してください：
1. 未テストのコードを確認
2. 必要に応じてテストを追加（次のTDDサイクルで）
3. または品質基準を見直し
```

### 4. 完了フェーズ

すべての品質チェックが完了したら、以下を伝えてください：

```
REFACTORフェーズが完了しました。

リファクタリング内容:
- DRY原則適用: XX箇所
- 定数化: XX箇所
- メソッド分割: XX箇所
- 条件式簡潔化: XX箇所
- ネーミング改善: XX箇所

品質チェック結果:
- PHPStan (Level 8): エラー 0件 ✓
- Laravel Pint: PSR-12準拠 ✓
- テストカバレッジ: XX% ✓

現在のTDDワークフロー:
[完了] INIT (初期化)
[完了] PLAN (計画)
[完了] RED (テスト作成)
[完了] GREEN (実装)
[完了] REFACTOR (リファクタリング) ← 現在ここ
[次] REVIEW (品質検証)
[ ] COMMIT (コミット)

次のステップ:
1. すべてのテストが通っていることを最終確認してください
2. 準備ができたら、REVIEWフェーズ（品質検証）に進んでください
3. REVIEWフェーズでは、コード全体のレビューと最終チェックを行います
```

## リファクタリングの原則

### 重要な原則

1. **テストを維持する**
   - 各変更後にテストを実行
   - テストが失敗したら変更を戻す
   - テストが通り続けることが最優先

2. **小さく変更する**
   - 一度に大きな変更をしない
   - 1つの改善を実施 → テスト → 次の改善
   - 段階的に改善

3. **必要最小限**
   - 過剰なリファクタリングはしない
   - テストが通れば十分
   - 完璧を求めない

4. **可読性を優先**
   - パフォーマンス最適化は後回し
   - まずは読みやすいコード
   - 保守しやすいコード

### やらないこと

- **機能追加**: 新しい機能は別のTDDサイクルで
- **テスト変更**: リファクタリングは実装コードのみ
- **大規模な変更**: アーキテクチャ変更は別途計画
- **過剰最適化**: 早すぎる最適化は悪

## 制約の強制

このフェーズでは、`allowed-tools: Read, Write, Edit, Grep, Glob, Bash` が使用可能です。

GREENフェーズと同様に、**実装コードの変更**と**Bashツールの使用**が許可されています。

もしユーザーが以下のような依頼をした場合は、**丁寧に拒否**してください：

- 「新しい機能XXXを追加して」→ 「REFACTORフェーズでは機能追加を行いません。別のTDDサイクルで実装しましょう」
- 「テストを変更して」→ 「REFACTORフェーズではテストを変更しません。実装コードのみをリファクタリングします」
- 「全体的にアーキテクチャを見直して」→ 「大規模な変更は別途計画が必要です。REFACTORフェーズでは必要最小限の改善のみ行います」

## トラブルシューティング

### テストが失敗した場合

```
リファクタリング中にテストが失敗しました。

失敗したテスト:
[テスト名]

エラーメッセージ:
[エラー内容]

対応:
1. 最後の変更を取り消します
2. より小さい単位で変更を試みます
3. または、この変更はスキップします
```

### PHPStanでエラーが多数発生する場合

```
PHPStan (Level 8) でエラーが発生しました。
エラー件数: XX件

段階的に修正します：
1. まずは重要なエラーから修正
2. 各修正後にテストを実行
3. 修正が困難な場合はTDDドキュメントの品質基準を見直し
```

### テストカバレッジが目標に達しない場合

```
テストカバレッジ: XX% (目標: 90%)

このREFACTORフェーズでは、既存のテストを維持します。
カバレッジ向上は次のTDDサイクルで行いましょう。

ただし、以下を確認します：
- リファクタリングでカバレッジが下がっていないか
- 下がっている場合は原因を調査
```

## 参考情報

このSkillは、Laravel開発におけるTDDワークフローの一部です。

- 詳細なワークフロー: README.md参照
- プロジェクト設定: CLAUDE.md参照
- 前のフェーズ: tdd-green Skill（実装）
- 次のフェーズ: tdd-review Skill（品質検証）

### REFACTORフェーズの重要性

REFACTORフェーズは、TDDサイクルの中で「綺麗なコード」を作る唯一のフェーズです：

- **テスト維持**: 動作を保証しながら改善
- **品質向上**: 可読性、保守性を向上
- **技術的負債の削減**: 早期に問題を解決

「動くコード」（GREEN）から「綺麗なコード」（REFACTOR）への昇華が、このフェーズの目的です。

---

*このSkillはClaudeSkillsプロジェクトの一部です*
