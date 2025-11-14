---
name: tdd-red
description: REDフェーズ用。テストコードのみを作成し、実装コードは一切書かない。ユーザーが「red」「テスト」「テスト作成」と言った時、PLANフェーズ完了後、または /tdd-red コマンド実行時に使用。最新のCycle doc（docs/cycles/）のTest ListからTODOを1つWIPに移動してテストを作成。Laravel/PHPUnit向け。
allowed-tools: Read, Write, Edit, Grep, Glob, Bash
---

# TDD RED Phase

あなたは現在 **REDフェーズ** にいます。

## このフェーズの目的

失敗するテストコードを作成し、実装の要件を明確にすることです。
最新のCycle docのTest ListからTODO項目を1つずつWIPに移動し、PHPUnit #[Test]属性形式でテストを作成します。

## このフェーズでやること

- [ ] 最新のCycle docを検索する（`ls -t docs/cycles/202*.md | head -1`）
- [ ] Cycle docを読み込む
- [ ] Test ListのTODO項目を1つWIPに移動する
- [ ] 既存のテストディレクトリ構造を確認する
- [ ] そのテストケースのテストコードを作成（Feature/Unit Tests）
- [ ] テストを実行して失敗することを確認（RED状態）
- [ ] Progress Logに記録（RED phase）
- [ ] YAML frontmatterのphaseを"RED"に、updatedを更新
- [ ] 次のアクションを案内する

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
# 最新のCycle docを検索
ls -t docs/cycles/202*.md 2>/dev/null | head -1

# Cycle docの読み込み
Read docs/cycles/YYYYMMDD_hhmm_<機能名>.md

# テストディレクトリ構造の確認
Glob tests/Feature/**/*.php
Glob tests/Unit/**/*.php
```

**ドキュメントが見つからない場合**:

```
エラー: Cycle docが見つかりません。

まず tdd-init と tdd-plan を実行してください。

手順:
1. /tdd-init を実行
2. /tdd-plan を実行してPLANセクションを完成させる
3. 再度 /tdd-red を実行
```

Cycle docから以下の情報を抽出してください：
- YAML frontmatter（feature, cycle, phase, created, updated）
- 「## Test List（テストリスト）」セクション
  - 実装予定（TODO）
  - 実装中（WIP）
  - 実装中に気づいた追加テスト（DISCOVERED）
  - 完了（DONE）

### 2. Test List更新フェーズ

#### 2.1 TODO項目を1つ選択

Test ListのTODO項目から、最初の1つを選択します。

**選択例**：
```
Test Listの実装予定（TODO）:
- [ ] TC-01: ログインページが表示される
- [ ] TC-02: 正しい認証情報でログインできる
- [ ] TC-03: 誤った認証情報でログインできない

次に実装するテストケースを選んでください（TC-01を推奨）：
```

ユーザーが選択したテストケース（例: TC-01）を次に進めます。

#### 2.2 WIPに移動

選択したTODO項目をWIPセクションに移動します。

Editツールを使用してCycle docを更新：

**更新前**:
```markdown
### 実装予定（TODO）
- [ ] TC-01: ログインページが表示される
- [ ] TC-02: 正しい認証情報でログインできる
- [ ] TC-03: 誤った認証情報でログインできない

### 実装中（WIP）
（現在なし）
```

**更新後**:
```markdown
### 実装予定（TODO）
- [ ] TC-02: 正しい認証情報でログインできる
- [ ] TC-03: 誤った認証情報でログインできない

### 実装中（WIP）
- [ ] TC-01: ログインページが表示される
```

### 3. テスト作成フェーズ

#### 3.1 ディレクトリ構造の決定

テストファイルを作成する前に、適切なディレクトリ構造を決定します。

##### 推奨: 機能領域別（ドメイン別）のサブディレクトリ

**小規模プロジェクト**:
```
tests/
├── Feature/
│   ├── UserControllerTest.php
│   └── ProductControllerTest.php
└── Unit/
    └── UserServiceTest.php
```

**中〜大規模プロジェクト（推奨）**:
```
tests/
├── Feature/
│   ├── User/
│   │   ├── UserProfileControllerTest.php
│   │   └── UserRegistrationControllerTest.php
│   ├── Product/
│   │   ├── ProductControllerTest.php
│   │   └── ProductSearchTest.php
│   └── Order/
│       └── OrderControllerTest.php
└── Unit/
    ├── Services/
    │   ├── User/
    │   │   └── UserServiceTest.php
    │   └── Product/
    │       └── ProductServiceTest.php
    └── Providers/
        └── AppServiceProviderTest.php
```

##### 重要な原則

1. **app/ディレクトリと構造を一致させる**
   ```
   app/Http/Controllers/User/UserProfileController.php
   → tests/Feature/User/UserProfileControllerTest.php

   app/Services/User/UserService.php
   → tests/Unit/Services/User/UserServiceTest.php
   ```

2. **機能単位でまとめる**
   - User機能: 認証、プロフィール、退会など
   - Product機能: 一覧、詳細、検索など
   - Order機能: 注文、決済、キャンセルなど

3. **PHPUnit/Pestは自動的にサブディレクトリを検出**
   - phpunit.xmlの設定で再帰的にスキャン
   - サブディレクトリがあっても問題なく実行される

#### 3.2 Laravel固有のテストルール

以下のLaravel固有のルールに**必ず従ってください**。

##### ルール1: RefreshDatabaseは使わない

❌ **使用禁止**:
```php
use Illuminate\Foundation\Testing\RefreshDatabase;

class UserTest extends TestCase
{
    use RefreshDatabase;  // ← 使わない
}
```

✅ **推奨**:
```php
use Illuminate\Foundation\Testing\DatabaseTransactions;

class UserTest extends TestCase
{
    use DatabaseTransactions;  // ← こちらを使う
}
```

**理由**:
- RefreshDatabaseは全データベースを再構築するため遅い
- DatabaseTransactionsはトランザクションをロールバックするため高速
- テスト間のデータ分離も確保される

##### ルール2: Factoryを必ず使用する

❌ **悪い例** - ハードコーディング:
```php
#[Test]
public function user_can_login(): void
{
    // 仮のデータを直接作成（重複の可能性）
    $user = User::create([
        'name' => 'Test User',  // ← 重複の可能性
        'email' => 'test@example.com',  // ← 重複の可能性
        'password' => Hash::make('password'),
    ]);
}
```

✅ **良い例** - Factory使用:
```php
#[Test]
public function user_can_login(): void
{
    // Factoryでユニークなデータを生成
    $user = User::factory()->create();
}
```

**特定の値が必要な場合**:
```php
#[Test]
public function admin_can_access_dashboard(): void
{
    // 必要な属性のみ上書き
    $admin = User::factory()->create([
        'role' => 'admin',
    ]);
}
```

**理由**:
- テスト実行の順序に依存しない
- データの重複を避ける
- ユニークな値が自動生成される

##### ルール3: route()関数を使用する

❌ **悪い例** - パス直接指定:
```php
#[Test]
public function user_can_view_profile(): void
{
    $user = User::factory()->create();

    $response = $this->actingAs($user)
        ->get('/profile');  // ← パスを直接指定
}
```

✅ **良い例** - route()関数使用:
```php
#[Test]
public function user_can_view_profile(): void
{
    $user = User::factory()->create();

    $response = $this->actingAs($user)
        ->get(route('profile.show'));  // ← ルート名を使用
}
```

**パラメータが必要な場合**:
```php
#[Test]
public function user_can_view_other_profile(): void
{
    $viewer = User::factory()->create();
    $target = User::factory()->create();

    $response = $this->actingAs($viewer)
        ->get(route('profile.show', ['user' => $target->id]));
}
```

**理由**:
- ルート定義が変更されてもテストが壊れない
- ルート名で意図が明確になる
- パラメータのバインディングが安全

##### ルール4: #[Test]アノテーションを使用する

✅ **正しい形式**:
```php
use PHPUnit\Framework\Attributes\Test;

#[Test]
public function user_can_update_profile(): void
{
    // テストコード
}
```

❌ **使わない形式**:
```php
// test_プレフィックスは使わない
public function test_user_can_update_profile(): void
{
    // テストコード
}
```

**理由**:
- Laravel 11 / PHPUnit 10-11の推奨形式
- メソッド名がより自然な英語表現になる
- IDEのサポートが向上

#### 3.3 大規模プロジェクト向けテスト高速化（500テスト以上）

テストが500を超える大規模プロジェクトでは、以下の高速化アプローチを検討してください。

##### 推奨アプローチ: migrate制御 + Hash最適化 + Factory

**基底TestCaseクラスの実装例**:

```php
<?php

namespace Tests;

use Illuminate\Foundation\Testing\TestCase as BaseTestCase;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\Hash;

abstract class TestCase extends BaseTestCase
{
    use CreatesApplication;

    public static $migrated = false;

    public function setUp(): void
    {
        parent::setUp();

        if (!$this->app) {
            $this->refreshApplication();
        }

        // パスワードハッシュ最適化（期待効果: 約50%高速化）
        Hash::setRounds(4);  // デフォルト10 → 4

        // migrate:freshを1回だけ実行
        if (!self::$migrated) {
            Artisan::call('migrate:fresh', ['--seed' => true]);
            Artisan::call('config:clear');
            Artisan::call('view:clear');
            self::$migrated = true;
        }
    }

    public function tearDown(): void
    {
        // DB接続を切断（max_connections対策）
        try {
            \DB::connection()->disconnect();
        } catch (\Exception $e) {
            // 接続エラーは無視
        }

        parent::tearDown();
    }
}
```

**ポイント**:
- ✅ `self::$migrated`フラグでmigrate:freshを1回だけ実行
- ✅ `Hash::setRounds(4)`でパスワードハッシュを高速化
- ✅ Factoryでユニークなデータを生成（ID重複防止）
- ✅ tearDownでDB接続を切断（max_connections対策）
- ✅ トランザクション不使用（結合テスト対応）

##### 推奨テスト実行コマンド

**PCOV使用（推奨・高速）**:

```bash
# PCOVインストール
pecl install pcov

# XDebug無効化、PCOV使用（約2倍高速）
XDEBUG_MODE=off PCOV_ENABLED=1 ./vendor/bin/phpunit -d memory_limit=-1 \
  --testsuite=Unit,Feature \
  --coverage-cobertura coverage-report.xml \
  --log-junit unittest-report.xml
```

##### DatabaseTransactionsの注意事項

⚠️ **DatabaseTransactionsトレイトは使用しない（非推奨）**

**理由**:
- 結合テスト（Feature Test）でトランザクション分離問題が発生
- HTTPリクエスト内のDB操作が別トランザクションとなり、テストで作成したデータが見えない
- テスト間でデータ共有が必要な場合に不適切

**代替案**: migrate 1回 + Factory で十分高速

#### 3.4 テストコード作成

選択したテストケースのテストコードを作成します。

**テンプレート**:

```php
<?php

namespace Tests\Feature;

use App\Models\User;
use PHPUnit\Framework\Attributes\Test;
use Tests\TestCase;

class ProfileControllerTest extends TestCase
{
    #[Test]
    public function user_can_update_their_profile(): void
    {
        // Given: ログイン済みユーザーがいる
        $user = User::factory()->create(['name' => 'Old Name']);
        $this->actingAs($user);

        // When: プロフィールを更新する
        $response = $this->put(route('profile.update'), ['name' => 'New Name']);

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
        $response = $this->put(route('profile.update'), ['name' => '']);

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
- **HTTPリクエストは必ず`route()`関数を使用**
- **テストデータは必ずFactoryで生成**

**禁止事項**:
- `/** @test */` アノテーション形式は使わない（PHPUnit 11で非推奨）
- `test_` プレフィックス付きメソッド名は使わない
- Pest形式（`it()`, `test()`）は使わない
- 実装コードを含めない
- **RefreshDatabaseは使わない（migrate制御については3.3参照）**
- **DatabaseTransactionsは使わない（結合テストで問題発生）**
- **パスを直接指定しない（route()関数を使用）**
- **テストデータをハードコーディングしない（Factoryを使用）**

### 4. テスト実行フェーズ

テストを作成したら、テスト実行を促してください：

```
テストを作成しました。

次のステップ:
1. テストを実行してください:
   php artisan test

2. テストが失敗することを確認してください
   （これは正常です。まだ実装がないためです）

3. 失敗メッセージを確認してください:
   - 存在しないクラスやメソッドのエラー
   - 未定義のルートのエラー
   - 等

これらのエラーが、次のGREENフェーズで実装すべき内容を示しています。
```

**重要**: この時点では、テストが失敗するのが正しい状態です。実装がないためです。

### 5. Progress Log記録フェーズ

Progress Logセクションに記録を追加します。

Editツールを使用してProgress Logに追記：
```markdown
### YYYY-MM-DD HH:MM - RED phase
- TC-XX: [テストケース名] のテストを作成
  ファイル: tests/Feature/XXX/XXXTest.php
  状態: RED（失敗確認済み）
- Test List更新（TODO→WIP: TC-XX）
- YAML frontmatter更新（phase: PLAN → RED）
```

### 6. YAML frontmatter更新フェーズ

Cycle docのYAML frontmatterを更新します。

Editツールを使用して更新：
```markdown
---
feature: [機能領域]
cycle: [サイクル識別子]
phase: RED  # PLAN から RED に更新
created: YYYY-MM-DD HH:MM
updated: YYYY-MM-DD HH:MM  # 現在日時に更新
---
```

### 7. 完了フェーズ

テスト作成完了後、以下を伝えてください：

```
REDフェーズが完了しました。

作成したテスト:
- tests/Feature/XXXTest.php
  - TC-XX: [テストケース名]
  状態: RED（失敗確認済み）

Test List更新:
- TODO → WIP: TC-XX

現在のTDDワークフロー:
[完了] INIT (初期化)
[完了] PLAN (計画)
[完了] RED (テスト作成) ← 現在ここ
[次] GREEN (実装)
[ ] REFACTOR (リファクタリング)
[ ] REVIEW (品質検証)
[ ] COMMIT (コミット)

次のステップ:
選択肢:
1. [推奨★★★★★] GREENフェーズで実装する（テストを通す）
   理由: TDDサイクルを完了させる。最も一般的なフロー

2. [推奨★★★☆☆] さらにテストを追加する（別のTODO項目をREDにする）
   理由: 複数テストをまとめて実装したい場合。管理コスト増加

3. [推奨★★☆☆☆] PLANフェーズに戻る（テストケースを見直し）
   理由: テスト設計に問題があった場合のみ。手戻りコスト大

どうしますか？
```

ユーザーが選択1（GREENフェーズで実装）を選んだ場合：

```
================================================================================
自動遷移: 次のフェーズ（GREEN）に進みます
================================================================================

GREENフェーズ（実装）を自動的に開始します...
```

その後、Skillツールを使って`tdd-green` Skillを起動してください。

## 制約の強制

このフェーズでは、`allowed-tools: Read, Write, Edit, Grep, Glob, Bash` が使用可能です。

もしユーザーが以下のような依頼をした場合は、**丁寧に拒否**してください：

- 「ProfileControllerを実装して」→ 「REDフェーズでは実装コードを作成できません。これはGREENフェーズで行います」
- 「テストを通して」→ 「REDフェーズではテストを失敗させたままにします。GREENフェーズで実装してテストを通します」
- 「マイグレーションを実行して」→ 「REDフェーズでは実行できません。Cycle docに記載されていることを確認し、GREENフェーズで実装します」
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

### Cycle docが見つからない場合

```
Cycle docが見つかりません。
REDフェーズを開始する前に、INIT と PLAN フェーズを完了してください。

以下を確認してください：
- docs/cycles/YYYYMMDD_hhmm_*.md が存在するか（ls -t docs/cycles/202*.md で確認）
- Cycle docに「## PLAN（実装計画）」セクションがあるか
- PLANセクション内に「## Test List」サブセクションがあるか
```

### Test Listが空の場合

```
Cycle docにTest Listが記載されていません。

PLANフェーズに戻って、テストケースを定義してください。
```

### PHPUnitのバージョンが古い場合

```
PHPUnit 9以下では #[Test] 属性が使えません。

以下のいずれかを選択してください：
1. [推奨★★★★★] PHPUnit 10以上にアップグレード
   理由: 最新機能が使える。Laravel 11推奨

2. [推奨★★☆☆☆] test_ プレフィックス形式にフォールバック
   理由: 古いPHPUnitでも動く。非推奨形式

どちらにしますか？
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
