---
name: tdd-red
description: REDフェーズ用。テストコードのみを作成し、実装コードは一切書かない。ユーザーが「red」「テスト」「テスト作成」と言った時、PLANフェーズ完了後、または /tdd-red コマンド実行時に使用。PLAN.mdのテストケース一覧を基にPHPUnit #[Test]属性形式でテストを作成。
allowed-tools: Read, Write, Grep, Glob
---

# TDD RED Phase

あなたは現在 **REDフェーズ** にいます。

## このフェーズの目的

失敗するテストコードを作成し、実装の要件を明確にすることです。
PLAN.mdのテストケース一覧を基に、PHPUnit #[Test]属性形式でテストを作成します。

## このフェーズでやること

- [ ] PLAN.mdを読み込む（`docs/tdd/PLAN.md`）
- [ ] テストケース一覧セクションを抽出する
- [ ] 既存のテストディレクトリ構造を確認する
- [ ] Feature Testsを作成する（tests/Feature/）
- [ ] Unit Testsを作成する（tests/Unit/）
- [ ] すべてのテストが失敗することを確認するよう促す
- [ ] 次のフェーズ（GREEN）を案内する

## このフェーズで絶対にやってはいけないこと

- 実装コードを書くこと（`app/`, `database/`, `routes/` 等への書き込み禁止）
- テストを通すためのコードを書くこと
- データベースマイグレーションを実行すること
- ユーザーの承認なしに実装を始めること
- テストを通す（成功させる）こと

## ワークフロー

### 1. 準備フェーズ

まず、以下を確認してください：

```bash
# PLAN.mdの読み込み
Read docs/tdd/PLAN.md

# テストディレクトリ構造の確認
Glob tests/Feature/**/*.php
Glob tests/Unit/**/*.php
```

PLAN.mdから以下の情報を抽出してください：
- 「## テストケース一覧」セクション
- 「### Feature Tests」サブセクション
- 「### Unit Tests」サブセクション

各テストケースについて、以下を確認：
- テストファイル名（例: `tests/Feature/ProfileControllerTest.php`）
- テストケース概要（例: ユーザーがプロフィールを更新できる）

### 2. テスト作成フェーズ

#### 2.1 Feature Testsから作成開始

PLAN.mdに記載されたFeature Testsを順番に作成します。

**作成前の確認**：
```
これから以下のFeature Testを作成します：
- tests/Feature/XXXTest.php
  - テストケース1の概要
  - テストケース2の概要

よろしいですか？
```

ユーザーの承認を得てから作成してください。

#### 2.2 テストコード構造

**重要**: Laravel 11 / PHPUnit 10-11 の推奨形式である **#[Test]属性形式** を使用してください。

**テンプレート**:

```php
<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use PHPUnit\Framework\Attributes\Test;
use Tests\TestCase;

class ProfileControllerTest extends TestCase
{
    use RefreshDatabase;

    #[Test]
    public function user_can_update_their_profile(): void
    {
        // Given: ログイン済みユーザーがいる
        $user = User::factory()->create(['name' => 'Old Name']);
        $this->actingAs($user);

        // When: プロフィールを更新する
        $response = $this->post('/profile', ['name' => 'New Name']);

        // Then: 成功メッセージが表示される
        $response->assertSessionHas('success');

        // And: 名前が更新されている
        $this->assertEquals('New Name', $user->fresh()->name);
    }

    #[Test]
    public function validation_error_is_shown_when_name_is_empty(): void
    {
        // Given: ログイン済みユーザーがいる
        $user = User::factory()->create();
        $this->actingAs($user);

        // When: 空の名前で更新する
        $response = $this->post('/profile', ['name' => '']);

        // Then: バリデーションエラーが表示される
        $response->assertSessionHasErrors('name');
    }
}
```

**必須要素**:
- `use PHPUnit\Framework\Attributes\Test;` をインポート
- `#[Test]` 属性で各テストメソッドをマーク
- メソッド名は `snake_case` 形式（**test_プレフィックス不要**）
- 戻り値の型は `: void` を明示
- Given/When/Then/Andコメントで構造を明確化
- テスト対象に応じて適切な use 文を追加

**禁止事項**:
- `/** @test */` アノテーション形式は使わない（PHPUnit 11で非推奨）
- `test_` プレフィックス付きメソッド名は使わない
- Pest形式（`it()`, `test()`）は使わない
- 実装コードを含めない

#### 2.3 Unit Testsの作成

Feature Testsの作成が完了したら、Unit Testsを作成します。

**Unit Test用テンプレート**:

```php
<?php

namespace Tests\Unit;

use App\Models\User;
use PHPUnit\Framework\Attributes\Test;
use Tests\TestCase;

class UserTest extends TestCase
{
    #[Test]
    public function user_has_profile_relation(): void
    {
        // Given: ユーザーがいる
        $user = User::factory()->create();

        // When: profileリレーションにアクセスする
        $profile = $user->profile;

        // Then: Profileインスタンスが返される
        $this->assertInstanceOf(\App\Models\Profile::class, $profile);
    }
}
```

Unit Testsも同じ形式（#[Test]属性）を使用してください。

### 3. テスト実行フェーズ

すべてのテストを作成したら、テスト実行を促してください：

```
すべてのテストを作成しました。

次のステップ:
1. テストを実行してください:
   php artisan test

2. すべてのテストが失敗することを確認してください
   （これは正常です。まだ実装がないためです）

3. 失敗メッセージを確認してください:
   - 存在しないクラスやメソッドのエラー
   - 未定義のルートのエラー
   - 等

これらのエラーが、次のGREENフェーズで実装すべき内容を示しています。
```

**重要**: この時点では、テストが失敗するのが正しい状態です。実装がないためです。

### 4. 完了フェーズ

テスト作成完了後、以下を伝えてください：

```
REDフェーズが完了しました。

作成したテストファイル:
- tests/Feature/XXXTest.php
  - テストケース1
  - テストケース2
- tests/Unit/YYYTest.php
  - テストケース1

現在のTDDワークフロー:
[完了] INIT (初期化)
[完了] PLAN (計画)
[完了] RED (テスト作成) ← 現在ここ
[次] GREEN (実装)
[ ] REFACTOR (リファクタリング)
[ ] REVIEW (品質検証)
[ ] COMMIT (コミット)

次のステップ:
1. php artisan test を実行して、すべてのテストが失敗することを確認
2. 準備ができたら、GREENフェーズ（実装）に進んでください
3. GREENフェーズでは、最小限の実装でテストを通すことが目標です
```

## 制約の強制

このフェーズでは、`allowed-tools: Read, Write, Grep, Glob` のみ使用可能です。

もしユーザーが以下のような依頼をした場合は、**丁寧に拒否**してください：

- 「ProfileControllerを実装して」→ 「REDフェーズでは実装コードを作成できません。これはGREENフェーズで行います」
- 「テストを通して」→ 「REDフェーズではテストを失敗させたままにします。GREENフェーズで実装してテストを通します」
- 「マイグレーションを実行して」→ 「REDフェーズでは実行できません。PLAN.mdに記載されていることを確認し、GREENフェーズで実装します」
- 「ルートを追加して」→ 「REDフェーズではルート定義は追加できません。GREENフェーズで実装します」

## テストケースの優先順位

テストケースが多い場合、以下の順序で作成してください：

1. **Feature Tests（E2E的なテスト）**
   - ユーザーの主要な操作フロー
   - ハッピーパス（正常系）から作成
   - エラーハンドリング（異常系）

2. **Unit Tests（単体テスト）**
   - モデルのリレーション
   - ビジネスロジック
   - ヘルパーメソッド

## トラブルシューティング

### PLAN.mdが見つからない場合

```
PLAN.mdが見つかりません。
REDフェーズを開始する前に、PLANフェーズを完了してください。

以下を確認してください：
- docs/tdd/PLAN.md が存在するか
- PLAN.mdに「## テストケース一覧」セクションがあるか
```

### テストケース一覧が空の場合

```
PLAN.mdにテストケース一覧が記載されていません。

PLANフェーズに戻って、テストケースを定義してください。
```

### ユーザーが「どんなテストを書けばいいかわからない」と言った場合

```
PLAN.mdの「## テストケース一覧」セクションに記載されたテストケースを作成します。

もしPLAN.mdのテストケースが不明確な場合は、PLANフェーズに戻って見直しましょうか？

または、以下のような質問で具体化できます：
- この機能で、ユーザーは何ができるべきですか？
- どんな入力を受け付けますか？
- どんな出力が期待されますか？
- どんなエラーケースがありますか？
```

### PHPUnitのバージョンが古い場合

```
PHPUnit 9以下では #[Test] 属性が使えません。

以下のいずれかを選択してください：
1. PHPUnit 10以上にアップグレード（推奨）
2. test_ プレフィックス形式にフォールバック

どちらにしますか？
```

フォールバック時のテンプレート:

```php
<?php

namespace Tests\Feature;

use Tests\TestCase;

class ProfileControllerTest extends TestCase
{
    public function test_user_can_update_their_profile(): void
    {
        // Given: ログイン済みユーザーがいる
        // ...
    }
}
```

## 参考情報

このSkillは、Laravel開発におけるTDDワークフローの一部です。

- 詳細なワークフロー: README.md参照
- プロジェクト設定: CLAUDE.md参照
- 前のフェーズ: tdd-plan Skill（計画作成）
- 次のフェーズ: tdd-green Skill（実装）

### Given/When/Then/Andコメントについて

テストの意図を明確にするため、各テストメソッドに構造化コメントを含めてください：

- **Given**: 前提条件（テスト実行前の状態）
- **When**: アクション（何をするか）
- **Then**: 期待結果（何が起きるべきか）
- **And**: 追加の期待結果

これにより、テストの可読性が向上し、レビューしやすくなります。

---

*このSkillはClaudeSkillsプロジェクトの一部です*
