---
name: tdd-green
description: GREENフェーズ用。REDフェーズで作成したテストを通すための最小限の実装のみを行う。ユーザーが「green」「実装」と言った時、REDフェーズ完了後、または /tdd-green コマンド実行時に使用。過剰な実装を防ぎ、テストを通すことに集中。
allowed-tools: Read, Write, Edit, Grep, Glob, Bash
---

# TDD GREEN Phase

あなたは現在 **GREENフェーズ** にいます。

## このフェーズの目的

REDフェーズで作成したテストを通すための**最小限の実装**を行うことです。
「動くコード」を優先し、「綺麗なコード」はREFACTORフェーズに委ねます。

## このフェーズでやること

- [ ] 最新のTDDドキュメントを検索する（`ls -t docs/202*.md | head -1`）
- [ ] 作成済みのテストファイルを確認する（tests/Feature/, tests/Unit/）
- [ ] テストを実行してエラー内容を確認する
- [ ] TDDドキュメントを参照して実装範囲を確認する
- [ ] テストを通すための最小限のコードを実装する
- [ ] テストが通ることを確認する
- [ ] 次のフェーズ（REFACTOR）を案内する

## このフェーズで絶対にやってはいけないこと

- 過剰な実装を行うこと（テストにない機能の追加）
- リファクタリングを行うこと（REFACTORフェーズで行う）
- パフォーマンス最適化を行うこと（REFACTORフェーズで行う）
- 完璧なコードを書こうとすること
- **依頼された変更のみ実装する**: スコープ外の改善はDISCOVEREDに記録し、今は実装しない
- **ファイルを読まずに変更を提案すること**: 必ず対象ファイルをReadしてから実装する

### なぜこれらの制約があるか（理由）

- **過剰な実装禁止**: テストされていないコードはバグの温床。YAGNI原則（必要になるまで実装しない）
- **依頼された変更のみ**: スコープクリープを防ぎ、予測可能な開発サイクルを維持するため
- **ファイルを読む義務**: 既存コードを理解せずに変更すると、意図しない副作用やパターン違反が発生するため

## ワークフロー

### 1. 準備フェーズ

まず、以下を確認してください：

```bash
# 最新のTDDドキュメントを検索
ls -t docs/202*.md 2>/dev/null | head -1

# TDDドキュメントの確認
Read docs/YYYYMMDD_hhmm_<機能名>.md

# テストファイルの確認
Glob tests/Feature/**/*.php
Glob tests/Unit/**/*.php
```

次に、テストを実行してエラーを確認します：

```bash
# テスト実行
php artisan test
```

エラーメッセージから、何を実装すべきかを判断してください：
- クラスが存在しない → クラスを作成
- メソッドが存在しない → メソッドを追加
- ルートが存在しない → ルート定義を追加
- データベーステーブルが存在しない → マイグレーション実行

### 2. 実装フェーズ

#### 2.0 ディレクトリ構造の確認

実装を開始する前に、app/ディレクトリとtests/ディレクトリの構造を一致させることを確認します。

##### 推奨: tests/とapp/の構造を一致させる

**一致させる例**:
```
tests/Feature/User/UserProfileControllerTest.php
→ app/Http/Controllers/User/UserProfileController.php

tests/Unit/Services/User/UserServiceTest.php
→ app/Services/User/UserService.php
```

##### ディレクトリ配置の推奨

**Controllers**:
```
app/Http/Controllers/
├── User/
│   ├── UserProfileController.php
│   └── UserRegistrationController.php
├── Product/
└── Order/
```

**Services**:
```
app/Services/
├── User/
│   └── UserService.php
├── Product/
│   └── ProductService.php
└── Order/
    └── OrderService.php
```

**Providers**:
```
app/Providers/
├── AppServiceProvider.php
├── AuthServiceProvider.php
└── RouteServiceProvider.php
```
（Providersは通常app/Providers/直下に配置）

##### 実装時の注意点

1. **テストで定義したディレクトリ構造に従う**
   - REDフェーズで作成したテストファイルの配置を確認
   - 同じ構造でapp/ディレクトリを作成

2. **機能単位でまとめる**
   - User機能: Controllers, Services, Models全てUser/配下
   - 関連ファイルが近くにあると保守しやすい

3. **Artisanコマンドでディレクトリ指定**
   ```bash
   # サブディレクトリ付きで生成
   php artisan make:controller User/UserProfileController
   php artisan make:model User/User
   ```

#### 2.1 実装の原則

**最重要**: テストを通すための**最小限のコード**のみを書いてください。

以下の原則に従ってください：

1. **最小限**
   - テストを通すための最低限のコードのみ
   - 不要な機能は追加しない
   - テストされていない機能は実装しない

2. **単純**
   - 複雑なロジックは書かない
   - 早期リターンやハードコードも許容
   - 「動けばOK」の精神

3. **べた書き許容**
   - DRY（Don't Repeat Yourself）は気にしない
   - コピペも許容
   - 共通化はREFACTORフェーズで

4. **ハードコード許容**
   - 定数化しなくてOK
   - マジックナンバーも許容
   - 設定ファイル化はREFACTORフェーズで

#### 2.2 実装順序

以下の順序で実装してください：

1. **マイグレーション**（必要な場合）
   ```bash
   # マイグレーションファイル作成
   php artisan make:migration create_xxx_table

   # マイグレーション実行
   php artisan migrate
   ```

2. **モデル**（必要な場合）
   ```php
   <?php

   namespace App\Models;

   use Illuminate\Database\Eloquent\Model;

   class XXX extends Model
   {
       protected $fillable = ['field1', 'field2'];
   }
   ```

3. **コントローラー**
   ```php
   <?php

   namespace App\Http\Controllers;

   class XXXController extends Controller
   {
       public function index()
       {
           // 最小限の実装
           return view('xxx.index');
       }
   }
   ```

4. **ルート定義**
   ```php
   // routes/web.php または routes/api.php
   Route::get('/xxx', [XXXController::class, 'index']);
   ```

5. **サービスクラス**（必要な場合）
   ```php
   <?php

   namespace App\Services;

   class XXXService
   {
       public function create($data)
       {
           // 最小限の実装
       }
   }
   ```

6. **ビュー**（必要な場合）
   ```blade
   {{-- resources/views/xxx/index.blade.php --}}
   <div>Minimum implementation</div>
   ```

#### 2.3 実装例

**悪い例**（過剰な実装）:
```php
// GREENフェーズでこれは書かない
public function create($data)
{
    // バリデーション（テストされていない）
    $validator = Validator::make($data, [
        'name' => 'required|string|max:255',
        'email' => 'required|email|unique:users',
    ]);

    if ($validator->fails()) {
        throw new ValidationException($validator);
    }

    // トランザクション（テストされていない）
    DB::transaction(function () use ($data) {
        $user = User::create($data);
        event(new UserCreated($user));
        Log::info('User created', ['user_id' => $user->id]);
        return $user;
    });
}
```

**良い例**（最小限の実装）:
```php
// GREENフェーズではこれでOK
public function create($data)
{
    return User::create($data);
}
```

テストが「バリデーションエラーを返す」をテストしている場合のみ、バリデーションを追加します。

### 3. テスト実行フェーズ

実装が完了したら、テストを実行してください：

```bash
# すべてのテストを実行
php artisan test

# 特定のテストのみ実行
php artisan test --filter=XXXTest
```

**テストが通った場合**:
```
すべてのテストが通りました！

GREENフェーズ完了です。
次のREFACTORフェーズでコードを改善しましょう。
```

**テストが失敗した場合**:
```
テストが失敗しました。

エラーメッセージを確認してください：
[エラーメッセージ]

不足している実装を追加します。
```

エラーメッセージから、追加で必要な実装を判断して修正してください。

### 4. 完了フェーズ

すべてのテストが通ったら、以下を伝えてください：

```
GREENフェーズが完了しました。

実装したファイル:
- app/Models/XXX.php
- app/Http/Controllers/XXXController.php
- routes/web.php
- database/migrations/YYYY_MM_DD_HHMMSS_create_xxx_table.php

現在のTDDワークフロー:
[完了] INIT (初期化)
[完了] PLAN (計画)
[完了] RED (テスト作成)
[完了] GREEN (実装) ← 現在ここ
[次] REFACTOR (リファクタリング)
[ ] REVIEW (品質検証)
[ ] COMMIT (コミット)

次のステップ:
1. テストが通ることを確認してください
2. REFACTORフェーズでは、コードの改善・DRY化・最適化を行います
3. 重要: REFACTORフェーズ中もテストは通り続けなければなりません

================================================================================
自動遷移: 次のフェーズ（REFACTOR）に進みます
================================================================================

REFACTORフェーズ（リファクタリング）を自動的に開始します...
```

完了メッセージを表示したら、Skillツールを使って`tdd-refactor` Skillを起動してください。

## 実装の原則（詳細）

### 最小限の実装とは？

- **テストを通すための最低限のコード**
  - テストが「200 OKを返す」だけなら、空のレスポンスでOK
  - テストが「特定のデータを返す」なら、そのデータをハードコードでもOK
  - テストが「データベースに保存する」なら、`Model::create()`だけでOK

### べた書きの例

```php
// GREENフェーズではこれでOK
if ($user->role === 'admin') {
    return true;
}
if ($user->role === 'editor') {
    return true;
}
if ($user->role === 'viewer') {
    return false;
}

// REFACTORフェーズで改善
return in_array($user->role, ['admin', 'editor']);
```

### ハードコードの例

```php
// GREENフェーズではこれでOK
public function getTaxRate()
{
    return 0.1; // 10%
}

// REFACTORフェーズで改善
public function getTaxRate()
{
    return config('tax.rate');
}
```

## WordPress固有の実装ルール

WordPress環境では、セキュリティ対策とベストプラクティスを遵守してください。

### セキュリティ対策（MUST）

#### 入力のサニタイズ

すべてのユーザー入力に対してサニタイズ関数を使用:

```php
// テキスト入力
$text = sanitize_text_field($_POST['input']);

// テキストエリア
$content = sanitize_textarea_field($_POST['content']);

// HTML（限定的なタグのみ許可）
$html = wp_kses_post($_POST['html']);

// URL
$url = esc_url_raw($_POST['url']);

// Email
$email = sanitize_email($_POST['email']);

// スラッグ
$slug = sanitize_title($_POST['slug']);

// ファイル名
$filename = sanitize_file_name($_FILES['upload']['name']);
```

**重要**: サニタイズはデータを保存する**前**に実行してください。

#### 出力のエスケープ

すべての出力に対してエスケープ関数を使用:

```php
// HTML出力
echo esc_html($user_input);

// 属性値
echo '<div data-value="' . esc_attr($value) . '">';

// URL
echo '<a href="' . esc_url($link) . '">';

// JavaScript
echo '<script>var data = ' . wp_json_encode($data) . ';</script>';

// テキストエリア
echo '<textarea>' . esc_textarea($content) . '</textarea>';

// SQL（wpdbを使用する場合）
global $wpdb;
$wpdb->query($wpdb->prepare(
    "SELECT * FROM {$wpdb->posts} WHERE post_title = %s",
    $search_term
));
```

**重要**: エスケープはデータを表示する**直前**に実行してください。

#### Nonce検証（フォーム送信時）

CSRF対策としてnonceを必ず検証:

```php
// フォーム生成時
wp_nonce_field('my_action', 'my_nonce');

// フォーム処理時
if (!isset($_POST['my_nonce']) || !wp_verify_nonce($_POST['my_nonce'], 'my_action')) {
    wp_die('Security check failed');
}

// 処理を続行
$data = sanitize_text_field($_POST['data']);
```

**AJAX処理の場合**:

```php
// JavaScript側
jQuery.post(ajaxurl, {
    action: 'my_ajax_action',
    nonce: myPlugin.nonce,  // wp_localize_scriptで渡す
    data: value
});

// PHP側
function my_ajax_handler() {
    check_ajax_referer('my_ajax_action', 'nonce');

    $data = sanitize_text_field($_POST['data']);
    // 処理を続行
}
```

#### 権限チェック

管理機能には必ず権限チェックを実装:

```php
// 管理画面ページ
function my_admin_page() {
    if (!current_user_can('manage_options')) {
        wp_die('You do not have sufficient permissions');
    }

    // ページ表示
}

// 投稿編集権限
if (!current_user_can('edit_post', $post_id)) {
    wp_die('You cannot edit this post');
}

// カスタム権限
if (!current_user_can('edit_weather_data')) {
    wp_die('You cannot edit weather data');
}
```

### WordPress関数の優先使用

直接DBアクセスではなく、WordPress関数を使用:

```php
// ❌ Bad: 直接DBアクセス
global $wpdb;
$wpdb->query("INSERT INTO {$wpdb->posts} ...");

// ✅ Good: WordPress関数
wp_insert_post([
    'post_title' => sanitize_text_field($title),
    'post_content' => wp_kses_post($content),
    'post_status' => 'publish',
]);

// ❌ Bad: 直接クエリ
$wpdb->get_results("SELECT * FROM {$wpdb->options} WHERE option_name = 'my_option'");

// ✅ Good: WordPress関数
$value = get_option('my_option', 'default_value');

// ❌ Bad: 直接UPDATE
$wpdb->update($wpdb->postmeta, ['meta_value' => $value], ['meta_key' => 'weather']);

// ✅ Good: WordPress関数
update_post_meta($post_id, 'weather', sanitize_text_field($value));
```

**wpdbを使う必要がある場合**:

```php
// prepareを必ず使用（SQLインジェクション対策）
global $wpdb;
$results = $wpdb->get_results($wpdb->prepare(
    "SELECT * FROM {$wpdb->prefix}custom_table WHERE city = %s AND date > %s",
    $city,
    $date
));
```

### Hooks/Filtersによる拡張性

機能をフック/フィルタで拡張可能にする:

```php
// フィルタで値を変更可能に
function get_weather_api_key() {
    $default_key = get_option('weather_api_key');
    return apply_filters('weather_api_key', $default_key);
}

// アクションで処理を追加可能に
function save_weather_data($city, $data) {
    do_action('before_save_weather_data', $city, $data);

    update_option("weather_data_{$city}", $data);

    do_action('after_save_weather_data', $city, $data);
}

// 他のプラグインから拡張可能
add_filter('weather_api_key', function($key) {
    return getenv('CUSTOM_WEATHER_API_KEY') ?: $key;
});

add_action('after_save_weather_data', function($city, $data) {
    // キャッシュを更新
    set_transient("weather_cache_{$city}", $data, HOUR_IN_SECONDS);
});
```

### WordPress Coding Standards準拠

```php
// ✅ Good: WordPress標準の命名規則
function my_plugin_get_weather() { }  // スネークケース関数名
class My_Plugin_Weather { }           // アンダースコア区切りクラス名

// ✅ Good: フック名の命名規則
do_action('my_plugin_weather_updated', $data);
apply_filters('my_plugin_weather_api_url', $url);

// ✅ Good: WordPress関数スタイル
if (is_user_logged_in()) {
    // 処理
}

// ❌ Bad: camelCase（WordPress標準外）
function myPluginGetWeather() { }  // 使わない
```

### 国際化対応（i18n）

文字列を翻訳可能にする:

```php
// テキスト翻訳
echo esc_html__('Weather Information', 'my-plugin');

// テキスト翻訳+エスケープ
echo esc_html__('Temperature', 'my-plugin');

// 複数形対応
printf(
    esc_html(_n('%s degree', '%s degrees', $count, 'my-plugin')),
    number_format_i18n($count)
);

// 変数を含む翻訳
printf(
    esc_html__('Weather in %s', 'my-plugin'),
    esc_html($city)
);
```

**テキストドメイン**: プラグイン/テーマのスラッグと同じにする（例: `my-plugin`）

### GREENフェーズでの WordPress実装例

```php
<?php
// ショートコード実装例（最小限）

function weather_shortcode($atts) {
    // 1. 属性のサニタイズ
    $atts = shortcode_atts([
        'city' => 'tokyo',
    ], $atts);

    $city = sanitize_text_field($atts['city']);

    // 2. データ取得（最小限）
    $data = get_transient("weather_data_{$city}");

    if (!$data) {
        return esc_html__('Weather data not available', 'my-plugin');
    }

    // 3. 出力（エスケープ）
    return sprintf(
        '<div class="weather">%s: %s°C</div>',
        esc_html($city),
        esc_html($data['temp'])
    );
}

add_shortcode('weather', 'weather_shortcode');
```

**GREENフェーズのポイント**:
- テストが通る最小限の実装
- セキュリティ対策は必須（サニタイズ/エスケープ）
- WordPress関数を優先使用
- リファクタリングはREFACTORフェーズで実施

---

## 制約の強制

このフェーズでは、`allowed-tools: Read, Write, Edit, Grep, Glob, Bash` が使用可能です。

REDフェーズと異なり、**実装コードの作成が許可**されています。
また、**Bashツールが許可**されているため、テスト実行やマイグレーション実行が可能です。

もしユーザーが以下のような依頼をした場合は、**丁寧に拒否**してください：

- 「ついでにXXX機能も追加して」→ 「GREENフェーズではテストを通すための最小限の実装のみです。追加機能は別のTDDサイクルで実装しましょう」
- 「このコードをリファクタリングして」→ 「GREENフェーズではリファクタリングを行いません。REFACTORフェーズで改善します」
- 「パフォーマンス最適化して」→ 「GREENフェーズでは最適化を行いません。まずテストを通すことに集中します」

## トラブルシューティング

### テストファイルが見つからない場合

```
テストファイルが見つかりません。
GREENフェーズを開始する前に、REDフェーズを完了してください。

以下を確認してください：
- tests/Feature/ または tests/Unit/ にテストファイルが存在するか
```

### テストがすべて通っている場合

```
すべてのテストがすでに通っています。

GREENフェーズで実装することはありません。
次のREFACTORフェーズに進みますか？
```

### マイグレーション実行エラーの場合

```
マイグレーション実行時にエラーが発生しました：
[エラーメッセージ]

マイグレーションファイルを確認してください。
または、データベース接続設定を確認してください。
```

### 「最小限」の判断が難しい場合

```
最小限の実装の判断基準：

1. テストがチェックしていることだけを実装する
2. テストがチェックしていないことは実装しない
3. 迷ったら「ハードコードで十分か？」と自問する
4. 迷ったら「これはREFACTORフェーズで改善できるか？」と自問する

例：
- テストが「200 OKを返す」のみ → return response()->json();
- テストが「特定のJSONを返す」 → return response()->json(['data' => 'hardcoded']);
- テストが「エラーを返す」 → if ($invalid) { abort(400); }
```

## 参考情報

このSkillは、Laravel開発におけるTDDワークフローの一部です。

- 詳細なワークフロー: README.md参照
- プロジェクト設定: CLAUDE.md参照
- 前のフェーズ: tdd-red Skill（テスト作成）
- 次のフェーズ: tdd-refactor Skill（リファクタリング）

### GREENフェーズの重要性

GREENフェーズは、TDDサイクルの中で最も重要なフェーズの一つです：

- **テストを通す**: 機能が動作することを証明
- **最小限**: 過剰設計を避ける
- **速度**: 素早く動くものを作る

「完璧なコードを書く」のではなく、「動くコードを書く」ことに集中してください。
リファクタリングは次のフェーズで行います。

---

*このSkillはClaudeSkillsプロジェクトの一部です*
