---
name: tdd-red
description: REDフェーズ用。テストコードのみを作成し、実装コードは一切書かない。ユーザーが「red」「テスト」「テスト作成」と言った時、PLANフェーズ完了後、または /tdd-red コマンド実行時に使用。最新のTDDドキュメント（docs/YYYYMMDD_hhmm_*.md）のテストケース一覧を基にPHPUnit #[Test]属性形式でテストを作成。
allowed-tools: Read, Write, Grep, Glob, Bash
---

# TDD RED Phase

あなたは現在 **REDフェーズ** にいます。

## このフェーズの目的

失敗するテストコードを作成し、実装の要件を明確にすることです。
最新のTDDドキュメントのテストケース一覧を基に、PHPUnit #[Test]属性形式でテストを作成します。

## このフェーズでやること

- [ ] 最新のTDDドキュメントを検索する（`ls -t docs/202*.md | head -1`）
- [ ] TDDドキュメントを読み込む
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
# 最新のTDDドキュメントを検索
ls -t docs/202*.md 2>/dev/null | head -1

# TDDドキュメントの読み込み
Read docs/YYYYMMDD_hhmm_<機能名>.md

# テストディレクトリ構造の確認
Glob tests/Feature/**/*.php
Glob tests/Unit/**/*.php
```

**ドキュメントが見つからない場合**:

```
⚠️ エラー: TDDドキュメントが見つかりません。

まず tdd-init と tdd-plan を実行してください。

手順:
1. /tdd-init を実行
2. /tdd-plan を実行してPLANセクションを完成させる
3. 再度 /tdd-red を実行
```

TDDドキュメントから以下の情報を抽出してください：
- 「## テストケース一覧」セクション
- 「### Feature Tests」サブセクション
- 「### Unit Tests」サブセクション

各テストケースについて、以下を確認：
- テストファイル名（例: `tests/Feature/ProfileControllerTest.php`）
- テストケース概要（例: ユーザーがプロフィールを更新できる）

### 2. テスト作成フェーズ

#### 2.1 Feature Testsから作成開始

TDDドキュメントに記載されたFeature Testsを順番に作成します。

**作成前の確認**：
```
これから以下のFeature Testを作成します：
- tests/Feature/XXXTest.php
  - テストケース1の概要
  - テストケース2の概要

よろしいですか？
```

ユーザーの承認を得てから作成してください。

#### 2.1.1 ディレクトリ構造の決定

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

##### ディレクトリ作成方法

**Bashコマンド使用**:
```bash
mkdir -p tests/Feature/User
mkdir -p tests/Feature/Product
mkdir -p tests/Unit/Services/User
```

**Writeツールで直接作成**:
```php
// tests/Feature/User/UserProfileControllerTest.php
// Writeツールでファイル作成時に自動的にディレクトリが作成される
```

##### 判断基準

- **テストファイルが10個未満**: tests/Feature/ 直下でも可
- **テストファイルが10個以上**: サブディレクトリ推奨
- **複数の機能領域がある**: 必ずサブディレクトリを使用

#### 2.1.5 Laravel固有のテストルール

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

**POSTリクエストの例**:
```php
#[Test]
public function user_can_update_profile(): void
{
    $user = User::factory()->create();

    $response = $this->actingAs($user)
        ->put(route('profile.update'), [
            'name' => 'New Name',
        ]);
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

---

#### 2.1.6 大規模プロジェクト向けテスト高速化（500テスト以上）

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

**XDebug使用（カバレッジ取得）**:

```bash
# coverage modeのみ有効化（debugモードより高速）
XDEBUG_MODE=coverage ./vendor/bin/phpunit -d memory_limit=-1 \
  --testsuite=Unit,Feature \
  --coverage-cobertura coverage-report.xml \
  --log-junit unittest-report.xml
```

**PCOV使用（さらに高速・推奨）**:

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

**問題例**:
```php
use Illuminate\Foundation\Testing\DatabaseTransactions;  // ← 使わない

class ProfileTest extends TestCase
{
    use DatabaseTransactions;  // ← 問題あり

    #[Test]
    public function user_can_view_profile(): void
    {
        // トランザクションA内でユーザー作成
        $user = User::factory()->create();

        // トランザクションB（HTTPリクエスト処理）
        // → トランザクションAのデータが見えない可能性
        $response = $this->actingAs($user)->get(route('profile.show'));
        $response->assertOk();  // 失敗する可能性
    }
}
```

**代替案**: migrate 1回 + Factory で十分高速

##### 高速化オプション: 並列テスト実行（CI/CD環境）

**期待効果**: 2-5倍高速化（1000テスト: 5分 → 1-2分）

**AWS CodeBuild例**:

```yaml
# buildspec.yml
version: 0.2

batch:
  build-fanout:
    parallelism: 4  # 4プロセス並列実行

phases:
  install:
    commands:
      - composer install --no-interaction --prefer-dist
      - pecl install pcov  # PCOV拡張（高速カバレッジ）

  pre_build:
    commands:
      # 各プロセス用のDB作成
      - |
        if [ -n "$CODEBUILD_BATCH_BUILD_IDENTIFIER" ]; then
          export TEST_DB_NAME="test_db_${CODEBUILD_BATCH_BUILD_IDENTIFIER}"
        else
          export TEST_DB_NAME="test_db"
        fi
      - mysql -h $RDS_HOST -u $RDS_USER -p$RDS_PASSWORD \
          -e "CREATE DATABASE IF NOT EXISTS ${TEST_DB_NAME};"

  build:
    commands:
      # 並列テスト実行
      - |
        XDEBUG_MODE=off PCOV_ENABLED=1 \
        codebuild-tests-run \
          --test-command './vendor/bin/phpunit -d memory_limit=-1 --coverage-cobertura coverage-report.xml' \
          --files-search "codebuild-glob-search 'tests/**/*Test.php'" \
          --sharding-strategy 'equal-distribution'

reports:
  test-reports:
    files:
      - 'unittest-report.xml'
    file-format: JUNITXML
  code-coverage:
    files:
      - 'coverage-report.xml'
    file-format: COBERTURAXML
```

**並列実行の注意点**:
- 各プロセスに独立したデータベースが必要
- RDS上に複数のtest DBを作成
- CodeBuildコスト増加（プロセス数分）

##### ローカル並列実行

```bash
# ParaTestインストール
composer require brianium/paratest --dev

# 並列実行（4プロセス）
php artisan test --parallel --processes=4
```

**注意**: 各プロセスに独立したDBが必要（`your_db_test_1`, `your_db_test_2`等）

##### 期待される高速化効果

| 施策 | 効果 | 備考 |
|------|------|------|
| **Hash最適化** | 40-50%削減 | 必須 |
| **PCOV使用** | 50%削減 | XDebugから切り替え |
| **並列実行（4プロセス）** | 70-80%削減 | CI/CD環境推奨 |

**例: 1000テスト、初期5分の場合**:
1. Hash最適化: 5分 → 2.5分
2. +PCOV: 2.5分 → 1.5分
3. +並列4プロセス: 1.5分 → 20-30秒

---

#### 2.2 テストコード構造

**重要**: Laravel 11 / PHPUnit 10-11 の推奨形式である **#[Test]属性形式** を使用してください。

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
- **RefreshDatabaseは使わない（migrate制御については2.1.6参照）**
- **DatabaseTransactionsは使わない（結合テストで問題発生、2.1.6参照）**
- **パスを直接指定しない（route()関数を使用）**
- **テストデータをハードコーディングしない（Factoryを使用）**

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

**重要**:
- Unit Testsも同じLaravel固有のルールに従う
- Factoryでテストデータを生成
- #[Test]属性を使用

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
2. GREENフェーズでは、最小限の実装でテストを通すことが目標です

================================================================================
自動遷移: 次のフェーズ（GREEN）に進みます
================================================================================

GREENフェーズ（実装）を自動的に開始します...
```

完了メッセージを表示したら、Skillツールを使って`tdd-green` Skillを起動してください。

## WordPress環境での注意事項

### テストクラスの選択

WordPress環境では、テストの性質に応じて適切なベースクラスを選択してください。

#### WP_UnitTestCase を使うケース

以下の条件に該当する場合は `WP_UnitTestCase` を継承してください：

- WordPress関数（get_option, wp_insert_post等）を実行する
- データベース操作を伴う
- WordPressフック/フィルタを使用する

**例**:
```php
<?php

namespace TheNews\Plugin\Tests\Integration;

use WP_UnitTestCase;
use PHPUnit\Framework\Attributes\Test;

class WeatherWidgetTest extends WP_UnitTestCase
{
    #[Test]
    public function widget_saves_settings_to_database(): void
    {
        // Given: WordPress環境が必要
        $option_value = 'test_value';

        // When: WordPress関数を実行
        update_option('weather_api_key', $option_value);

        // Then: 期待通り保存される
        $this->assertSame($option_value, get_option('weather_api_key'));
    }
}
```

#### PHPUnit\Framework\TestCase を使うケース

以下の条件に該当する場合は `PHPUnit\Framework\TestCase` を継承してください：

- 純粋なPHPロジック（WordPress関数を使わない）
- 高速なユニットテスト
- Brain Monkeyでモック化可能なケース

**例**:
```php
<?php

namespace TheNews\Plugin\Tests\Unit;

use PHPUnit\Framework\TestCase;
use PHPUnit\Framework\Attributes\Test;
use Brain\Monkey\Functions;
use TheNews\Plugin\WeatherService;

class WeatherServiceTest extends TestCase
{
    protected function setUp(): void
    {
        parent::setUp();
        \Brain\Monkey\setUp();
    }

    protected function tearDown(): void
    {
        \Brain\Monkey\tearDown();
        parent::tearDown();
    }

    #[Test]
    public function get_weather_data_uses_cached_value(): void
    {
        // Given: WordPress関数をモック
        Functions\expect('get_transient')
            ->once()
            ->with('weather_data_tokyo')
            ->andReturn(['temp' => 25, 'condition' => 'sunny']);

        // When/Then: モックされた値で動作確認
        $service = new WeatherService();
        $result = $service->getWeather('tokyo');

        $this->assertSame(25, $result['temp']);
        $this->assertSame('sunny', $result['condition']);
    }
}
```

### テストディレクトリ構造

WordPress プラグイン/テーマでは、以下のディレクトリ構造を推奨します：

```
tests/
├── Unit/              # 純粋なPHPロジック（WordPress環境不要）
│   └── *Test.php      # PHPUnit\Framework\TestCase を継承
├── Integration/       # WordPress環境が必要
│   └── *Test.php      # WP_UnitTestCase を継承
└── bootstrap.php      # wp-phpunitセットアップ
```

**ディレクトリの使い分け**:
- `tests/Unit/`: Brain Monkeyでモック可能な純粋なロジック
- `tests/Integration/`: WordPress環境（データベース、関数等）が必要なテスト

### bootstrap.phpの要件

wp-phpunitを使用する場合の最小構成:

```php
<?php
// Composer autoloader
require_once dirname(__DIR__) . '/vendor/autoload.php';

// Brain Monkey setup (Unit tests用)
\Brain\Monkey\setUp();

// wp-phpunit setup (Integration tests用)
$_tests_dir = getenv('WP_TESTS_DIR');
if (!$_tests_dir) {
    $_tests_dir = '/tmp/wordpress-tests-lib';
}

require_once $_tests_dir . '/includes/functions.php';

// プラグイン/テーマの読み込み設定
function _manually_load_plugin() {
    require dirname(__DIR__) . '/plugin-name.php';
}
tests_add_filter('muplugins_loaded', '_manually_load_plugin');

require_once $_tests_dir . '/includes/bootstrap.php';
```

**重要なポイント**:
- `WP_TESTS_DIR` 環境変数でWordPressテストライブラリを指定
- `tests_add_filter('muplugins_loaded', ...)` でプラグインを手動ロード
- Brain MonkeyとWordPressテスト環境を両立

### WordPress固有のテストルール

#### 1. #[Test]属性を使用する

WordPress環境でも、最新のPHPUnit形式（#[Test]属性）を使用してください：

```php
use PHPUnit\Framework\Attributes\Test;

#[Test]
public function shortcode_renders_weather_widget(): void
{
    // Given/When/Then...
}
```

#### 2. Given/When/Then/Andコメントを含める

テストの意図を明確にするため、構造化コメントを必ず含めてください：

```php
#[Test]
public function widget_displays_temperature(): void
{
    // Given: 天気データがキャッシュされている
    set_transient('weather_data_tokyo', ['temp' => 25], 3600);

    // When: ショートコードをレンダリング
    $output = do_shortcode('[weather city="tokyo"]');

    // Then: 気温が表示される
    $this->assertStringContainsString('25°C', $output);
}
```

#### 3. WordPress関数のモック（Brain Monkey）

Unit Testで WordPress関数をモックする場合は、Brain Monkeyを使用します：

```php
use Brain\Monkey\Functions;

#[Test]
public function api_key_is_retrieved_from_options(): void
{
    // Given: get_optionをモック
    Functions\expect('get_option')
        ->once()
        ->with('weather_api_key')
        ->andReturn('test_api_key');

    // When: サービスがAPIキーを取得
    $service = new WeatherService();
    $key = $service->getApiKey();

    // Then: モックされた値が返される
    $this->assertSame('test_api_key', $key);
}
```

#### 4. WordPress環境が必要なテストはIntegration/に配置

データベース操作やWordPress関数の実行が必要なテストは `tests/Integration/` に配置してください：

```php
<?php

namespace TheNews\Plugin\Tests\Integration;

use WP_UnitTestCase;
use PHPUnit\Framework\Attributes\Test;

class PostMetaTest extends WP_UnitTestCase
{
    #[Test]
    public function weather_meta_is_saved_to_post(): void
    {
        // Given: 投稿を作成
        $post_id = $this->factory()->post->create();

        // When: メタデータを保存
        update_post_meta($post_id, 'weather_condition', 'sunny');

        // Then: 保存されたメタデータを取得できる
        $this->assertSame('sunny', get_post_meta($post_id, 'weather_condition', true));
    }
}
```

---

## 制約の強制

このフェーズでは、`allowed-tools: Read, Write, Grep, Glob` のみ使用可能です。

もしユーザーが以下のような依頼をした場合は、**丁寧に拒否**してください：

- 「ProfileControllerを実装して」→ 「REDフェーズでは実装コードを作成できません。これはGREENフェーズで行います」
- 「テストを通して」→ 「REDフェーズではテストを失敗させたままにします。GREENフェーズで実装してテストを通します」
- 「マイグレーションを実行して」→ 「REDフェーズでは実行できません。TDDドキュメントに記載されていることを確認し、GREENフェーズで実装します」
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

### TDDドキュメントが見つからない場合

```
TDDドキュメントが見つかりません。
REDフェーズを開始する前に、INIT と PLAN フェーズを完了してください。

以下を確認してください：
- docs/YYYYMMDD_hhmm_*.md が存在するか（ls -t docs/202*.md で確認）
- TDDドキュメントに「## PLAN（実装計画）」セクションがあるか
- PLANセクション内に「## テストケース一覧」サブセクションがあるか
```

### テストケース一覧が空の場合

```
TDDドキュメントにテストケース一覧が記載されていません。

PLANフェーズに戻って、テストケースを定義してください。
```

### ユーザーが「どんなテストを書けばいいかわからない」と言った場合

```
TDDドキュメントの「## テストケース一覧」セクションに記載されたテストケースを作成します。

もしTDDドキュメントのテストケースが不明確な場合は、PLANフェーズに戻って見直しましょうか？

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
