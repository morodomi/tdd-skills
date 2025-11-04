# Phase 4: Bedrock/WordPress用テンプレート作成

**作成日時**: 2025-11-04 00:01
**フェーズ**: Phase 4
**目的**: Bedrock/WordPress環境向けTDDテンプレート作成

---

## TDD INIT: 要件定義

### 背景

TheNewsプロジェクトの環境調査により、以下が判明：

1. **Bedrock構造**: 本体にテストなし、プラグイン/テーマごとに独立したテスト環境
2. **統一ツールセット**: PHPUnit 9.6 + wp-phpunit 6.8 + Laravel Pint + PHPStan
3. **Docker環境**: `docker exec thenews-app-1 bash -c "cd /var/task/web/app/mu-plugins/..."`
4. **Git Subtree**: 各コンポーネントが独立リポジトリ（thenews-theme, thenews-feed-reader, thenews-weather）
5. **Brain Monkey使用**: thenews-weatherでWordPress関数のモックに使用

### 目標

Laravel版テンプレート（`templates/laravel`）を元に、WordPress/Bedrock固有のルールを追加した`templates/bedrock`を作成する。

---

## 機能要件

### FR-01: Laravel版との互換性維持

**要件**: Laravel版の基本構造を維持しつつ、WordPress固有の要素を追加

**詳細**:
- 7つのSkills構成（tdd-init, tdd-plan, tdd-red, tdd-green, tdd-refactor, tdd-review, tdd-commit）
- MCP統合（Git/Filesystem/GitHub）
- install.shによる自動インストール

### FR-02: WordPress固有のテストルール

**要件**: WordPress環境特有のテスト要件に対応

**詳細**:
- **WP_UnitTestCase vs PHPUnit TestCase**の使い分け
- **wp-phpunit**セットアップ（bootstrap.php）
- **Brain Monkey**によるWordPress関数モック
- **テストスイート分離**（Unit/Integration）

**tdd-red Skillに追加**:
```markdown
## WordPress環境での注意事項

### テストクラスの選択

#### WP_UnitTestCase を使うケース
- WordPress関数（get_option, wp_insert_post等）を実行する
- データベース操作を伴う
- WordPressフック/フィルタを使用する

例:
```php
use WP_UnitTestCase;

class IntegrationTest extends WP_UnitTestCase
{
    #[Test]
    public function test_wordpress_function(): void
    {
        // Given: WordPress環境が必要
        $option_value = 'test_value';

        // When: WordPress関数を実行
        update_option('test_key', $option_value);

        // Then: 期待通り保存される
        $this->assertSame($option_value, get_option('test_key'));
    }
}
```

#### PHPUnit\Framework\TestCase を使うケース
- 純粋なPHPロジック（WordPress関数を使わない）
- 高速なユニットテスト
- Brain Monkeyでモック化可能なケース

例:
```php
use PHPUnit\Framework\TestCase;
use Brain\Monkey\Functions;

class UnitTest extends TestCase
{
    #[Test]
    public function test_pure_logic(): void
    {
        // Given: WordPress関数をモック
        Functions\expect('get_option')
            ->once()
            ->with('test_key')
            ->andReturn('mocked_value');

        // When/Then: モックされた値で動作確認
        $result = MyClass::getValue('test_key');
        $this->assertSame('mocked_value', $result);
    }
}
```

### テストディレクトリ構造

```
tests/
├── Unit/              # 純粋なPHPロジック（WordPress環境不要）
│   └── *Test.php      # PHPUnit\Framework\TestCase を継承
├── Integration/       # WordPress環境が必要
│   └── *Test.php      # WP_UnitTestCase を継承
└── bootstrap.php      # wp-phpunitセットアップ
```

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
require_once $_tests_dir . '/includes/bootstrap.php';
```
```

### FR-03: WordPress固有のコーディング規約

**要件**: WordPress Coding Standardsに準拠したコードを生成

**tdd-green Skillに追加**:
```markdown
## WordPress固有の実装ルール

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
```

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
```

#### Nonce検証（フォーム送信時）
CSRF対策としてnonceを必ず検証:

```php
// フォーム生成時
wp_nonce_field('my_action', 'my_nonce');

// フォーム処理時
if (!isset($_POST['my_nonce']) || !wp_verify_nonce($_POST['my_nonce'], 'my_action')) {
    wp_die('Security check failed');
}
```

### WordPress関数の優先使用

直接DBアクセスではなく、WordPress関数を使用:

```php
// ❌ Bad: 直接DBアクセス
global $wpdb;
$wpdb->query("INSERT INTO ...");

// ✅ Good: WordPress関数
wp_insert_post([
    'post_title' => $title,
    'post_content' => $content,
]);
```

### Hooks/Filtersによる拡張性

機能をフック/フィルタで拡張可能にする:

```php
// フィルタで値を変更可能に
$value = apply_filters('my_plugin_value', $default_value);

// アクションで処理を追加可能に
do_action('my_plugin_before_save', $data);
save_data($data);
do_action('my_plugin_after_save', $data);
```
```

### FR-04: WordPress固有の品質基準

**要件**: tdd-reviewでWordPress特有のチェックを実施

**tdd-review Skillに追加**:
```markdown
## WordPress固有の品質チェック

### セキュリティチェックリスト

- [ ] **入力サニタイズ**: すべてのユーザー入力に `sanitize_*` 関数を使用
- [ ] **出力エスケープ**: すべての出力に `esc_*` 関数を使用
- [ ] **Nonce検証**: フォーム送信時に `wp_verify_nonce()` を実装
- [ ] **権限チェック**: 管理機能に `current_user_can()` を実装
- [ ] **SQLインジェクション対策**: `$wpdb->prepare()` を使用（直接クエリ実行時）

### WordPress規約チェックリスト

- [ ] **WordPress関数優先**: 直接DBアクセスを避け、WordPress関数を使用
- [ ] **Hooks/Filters**: 拡張ポイントに `apply_filters()` / `do_action()` を配置
- [ ] **国際化対応**: 文字列に `__()`, `_e()`, `esc_html__()` を使用
- [ ] **Coding Standards**: Laravel Pintで自動チェック（`composer pint`）
- [ ] **後方互換性**: 既存機能を壊さない変更

### 静的解析チェックリスト

- [ ] **PHPStan Level 8**: エラー0件（`composer stan`）
- [ ] **WordPress型定義**: `szepeviktor/phpstan-wordpress` ルール準拠
- [ ] **型安全性**: すべての関数/メソッドに型宣言

### テストカバレッジチェックリスト

- [ ] **カバレッジ90%以上**: `composer test -- --coverage-text`
- [ ] **Unit/Integration分離**: 適切なテストスイートに配置
- [ ] **WordPress関数モック**: Brain Monkeyまたはwp-phpunitで適切にモック
```

### FR-05: Docker環境対応

**要件**: Docker環境でのテスト実行に対応

**install.shに追加**:
```bash
# Docker環境検出
if command -v docker &> /dev/null && docker ps &> /dev/null; then
    echo "Docker環境を検出しました"
    echo "テスト実行例:"
    echo "  docker exec <container> bash -c 'cd /path/to/plugin && composer test'"
fi
```

**CLAUDE.md.exampleに追加**:
```markdown
## Docker環境でのテスト実行

### コンテナ内でテスト実行
```bash
# プラグインのテスト
docker exec <container> bash -c "cd /var/task/web/app/mu-plugins/<plugin> && composer test"

# テーマのテスト
docker exec <container> bash -c "cd /var/task/web/app/themes/<theme> && composer test"

# すべてのコンポーネントをテスト
docker exec <container> bash -c "cd /var/task && bash scripts/test-all.sh"
```
```

### FR-06: Git Subtree対応

**要件**: Git Subtree構造でのワークフローをサポート

**CLAUDE.md.exampleに追加**:
```markdown
## Git Subtree構成の場合

### 開発ワークフロー

1. **親リポジトリで作業**:
   ```bash
   cd /path/to/bedrock-project
   # プラグイン開発
   cd web/app/mu-plugins/my-plugin
   # TDDワークフロー実行
   ```

2. **Subtreeへプッシュ**:
   ```bash
   cd /path/to/bedrock-project
   git subtree push --prefix=web/app/mu-plugins/my-plugin my-plugin main
   ```

3. **Subtreeから更新**:
   ```bash
   git subtree pull --prefix=web/app/mu-plugins/my-plugin my-plugin main
   ```

### 注意事項
- 各コンポーネントは独立したテスト環境を持つ
- Subtreeディレクトリ内で `.claude/skills` を配置可能
- 親リポジトリとSubtreeの両方で Skills を使える
```

---

## 非機能要件

### NFR-01: Laravel版との構造的一貫性

**要件**: Laravel版と同じディレクトリ構造を維持

```
templates/bedrock/
├── install.sh                    # Laravel版と同じインストーラー構造
├── .claude/
│   ├── skills/                   # 7つのSkills（WordPress固有ルール追加）
│   └── commands/                 # スラッシュコマンド（未使用）
└── CLAUDE.md.example             # WordPress固有の設定例
```

### NFR-02: 段階的な導入が可能

**要件**: 既存Bedrockプロジェクトに後から追加可能

- 既存の `.claude/config.json` を保持
- MCP統合は `--skip-mcp` でスキップ可能
- 既存のテスト環境に影響しない

### NFR-03: ドキュメントの充実

**要件**: WordPress開発者にとって分かりやすいドキュメント

- WP_UnitTestCase vs TestCaseの使い分け
- Brain Monkeyの使用例
- Docker環境でのテスト実行方法
- Git Subtree構成での使用方法

---

## 技術仕様

### 対象環境

- **PHP**: 8.1+ (thenews-weatherは8.3+だが、8.1で互換性維持)
- **PHPUnit**: 9.6
- **wp-phpunit**: 6.8
- **WordPress**: 6.8.1+
- **Bedrock**: 最新版

### 依存ツール

- **PHPStan**: ^1.10 + szepeviktor/phpstan-wordpress
- **Laravel Pint**: ^1.13
- **Brain Monkey**: ^2.6 (オプション)
- **Mockery**: ^1.6 (オプション)

### テストフレームワーク構成

**phpunit.xml標準構成**:
```xml
<testsuites>
    <testsuite name="unit">
        <directory suffix="Test.php">./tests/Unit</directory>
    </testsuite>
    <testsuite name="integration">
        <directory suffix="Test.php">./tests/Integration</directory>
    </testsuite>
</testsuites>
```

**composer.json標準スクリプト**:
```json
{
    "scripts": {
        "test": "phpunit",
        "test:unit": "phpunit --testsuite=unit",
        "test:integration": "phpunit --testsuite=integration",
        "pint": "pint . --config=.pint.json",
        "stan": "phpstan analyse --memory-limit=1G",
        "check": ["@pint", "@stan", "@test"]
    }
}
```

---

## テストケース（次フェーズで詳細化）

### TC-01: Laravel版からのコピーとWordPress固有ルール追加
- Laravel版テンプレートをコピー
- WordPress固有のルールを各Skillに追記
- CLAUDE.md.exampleをWordPress向けに調整

### TC-02: install.shの動作確認
- Bedrockプロジェクトで実行
- `.claude/skills/` が正しく配置される
- MCP統合が正しく実行される

### TC-03: WordPress固有ルールの検証
- tdd-red: WP_UnitTestCase使い分けが記載されている
- tdd-green: サニタイズ/エスケープルールが記載されている
- tdd-review: WordPress品質チェックリストが記載されている

### TC-04: ドキュメント検証
- Docker環境でのテスト実行方法が記載されている
- Git Subtree使用方法が記載されている
- bootstrap.phpの例が記載されている

---

## 実装計画（次フェーズで詳細化）

### タスク1: Laravel版のコピーとディレクトリ作成
```bash
cp -r templates/laravel templates/bedrock
```

### タスク2: WordPress固有ルールの追加
- tdd-red Skill修正
- tdd-green Skill修正
- tdd-review Skill修正

### タスク3: CLAUDE.md.exampleの作成
- Docker環境での使用方法
- Git Subtree構成での使用方法
- WordPress固有の設定

### タスク4: ドキュメント作成
- `docs/BEDROCK_INSTALLATION.md` (WordPress版インストールガイド)

---

## 完了条件

- [ ] `templates/bedrock/` ディレクトリが作成されている
- [ ] 7つのSkillsすべてにWordPress固有ルールが追加されている
- [ ] CLAUDE.md.exampleがWordPress向けに調整されている
- [ ] install.shがBedrock構造に対応している
- [ ] すべてのドキュメントが作成されている
- [ ] 既存TheNewsプロジェクトで動作確認できる状態

---

---

## TDD PLAN: 詳細な実装計画

### 実装タスク

#### タスク1: Laravel版のコピーとディレクトリ作成

**目的**: Laravel版テンプレートを元にBedrock版の基礎を作成

**手順**:
```bash
# templates/bedrockディレクトリを作成
cp -r templates/laravel templates/bedrock
```

**確認項目**:
- [ ] `templates/bedrock/.claude/skills/` に7つのSkillsが存在
- [ ] `templates/bedrock/install.sh` が存在
- [ ] ディレクトリ構造がLaravel版と同じ

**所要時間**: 1分

---

#### タスク2: tdd-red Skillの修正

**目的**: WordPress固有のテストルールを追加

**修正ファイル**: `templates/bedrock/.claude/skills/tdd-red/SKILL.md`

**追加内容**:
1. **WordPress環境での注意事項**セクション追加（INIT文書の49-140行目）
   - WP_UnitTestCase vs PHPUnit TestCaseの使い分け
   - テストディレクトリ構造（Unit/Integration）
   - bootstrap.phpの要件

**追加位置**: `## テスト実装のベストプラクティス` セクションの直後

**確認項目**:
- [ ] WP_UnitTestCaseの使い分けが明記されている
- [ ] Brain Monkeyの使用例が記載されている
- [ ] bootstrap.phpのサンプルコードが記載されている

**所要時間**: 5分

---

#### タスク3: tdd-green Skillの修正

**目的**: WordPress固有のコーディング規約を追加

**修正ファイル**: `templates/bedrock/.claude/skills/tdd-green/SKILL.md`

**追加内容**:
1. **WordPress固有の実装ルール**セクション追加（INIT文書の147-231行目）
   - セキュリティ対策（サニタイズ/エスケープ/Nonce）
   - WordPress関数の優先使用
   - Hooks/Filtersによる拡張性

**追加位置**: `## 実装のベストプラクティス` セクションの直後

**確認項目**:
- [ ] サニタイズ関数の使用例が記載されている
- [ ] エスケープ関数の使用例が記載されている
- [ ] Nonce検証の実装例が記載されている
- [ ] WordPress関数優先のルールが記載されている

**所要時間**: 5分

---

#### タスク4: tdd-review Skillの修正

**目的**: WordPress固有の品質チェックリストを追加

**修正ファイル**: `templates/bedrock/.claude/skills/tdd-review/SKILL.md`

**追加内容**:
1. **WordPress固有の品質チェック**セクション追加（INIT文書の238-268行目）
   - セキュリティチェックリスト
   - WordPress規約チェックリスト
   - 静的解析チェックリスト
   - テストカバレッジチェックリスト

**追加位置**: `## 品質チェック` セクションの直後

**確認項目**:
- [ ] セキュリティチェックリスト（5項目）が記載されている
- [ ] WordPress規約チェックリスト（5項目）が記載されている
- [ ] 静的解析チェックリスト（3項目）が記載されている
- [ ] テストカバレッジチェックリスト（3項目）が記載されている

**所要時間**: 5分

---

#### タスク5: install.shの修正

**目的**: Docker環境検出メッセージを追加

**修正ファイル**: `templates/bedrock/install.sh`

**追加内容**:
Docker環境検出メッセージ（INIT文書の275-282行目）

**追加位置**: 最終メッセージの直前（`echo "すべてのインストールが完了しました"` の直前）

**修正内容**:
```bash
# Docker環境検出
if command -v docker &> /dev/null && docker ps &> /dev/null; then
    echo ""
    echo "Docker環境を検出しました"
    echo "テスト実行例:"
    echo "  docker exec <container> bash -c 'cd /path/to/plugin && composer test'"
    echo ""
fi
```

**確認項目**:
- [ ] Docker環境が検出された場合にメッセージが表示される
- [ ] テスト実行例が表示される

**所要時間**: 3分

---

#### タスク6: CLAUDE.md.exampleの作成

**目的**: WordPress/Bedrock固有の設定例を提供

**新規作成ファイル**: `templates/bedrock/CLAUDE.md.example`

**内容**:
1. プロジェクト概要（WordPress/Bedrock向け）
2. TDDワークフロー（7 Skills紹介）
3. 品質基準（PHPStan Level 8, カバレッジ90%, セキュリティ対策）
4. Docker環境でのテスト実行（INIT文書の285-299行目）
5. Git Subtree構成での使用方法（INIT文書の305-334行目）
6. WordPress固有の開発ガイドライン
7. 使用可能なコマンド一覧

**テンプレート構成**:
```markdown
# [Project Name] - WordPress Plugin/Theme

## Project Overview
- **Type**: WordPress Plugin / Theme
- **Framework**: Bedrock
- **PHP**: 8.1+
- **Test Framework**: PHPUnit 9.6 + wp-phpunit 6.8
- **Quality Tools**: PHPStan Level 8, Laravel Pint

## TDD Workflow
[7 Skillsの説明]

## Quality Standards
[品質基準]

## Docker Environment
[Docker環境でのテスト実行方法]

## Git Subtree Configuration
[Git Subtree使用方法]

## WordPress Development Guidelines
[WordPress固有のルール]

## Available Commands
[composer test, pint, stan等]
```

**確認項目**:
- [ ] Docker環境でのテスト実行方法が記載されている
- [ ] Git Subtree構成での使用方法が記載されている
- [ ] WordPress固有の開発ガイドラインが記載されている
- [ ] テストスイート（Unit/Integration）の説明がある

**所要時間**: 10分

---

#### タスク7: BEDROCK_INSTALLATION.mdの作成

**目的**: WordPress/Bedrock向けインストールガイドを提供

**新規作成ファイル**: `docs/BEDROCK_INSTALLATION.md`

**内容**:
1. 前提条件（PHP, Composer, Docker等）
2. 自動インストール手順
3. 手動インストール手順
4. プラグイン/テーマでの使用方法
5. Docker環境での使用方法
6. Git Subtree構成での使用方法
7. トラブルシューティング
8. よくある質問

**テンプレート構成**:
```markdown
# Bedrock/WordPress用 ClaudeSkills インストールガイド

## 前提条件
- PHP 8.1+
- Composer
- Node.js (MCP統合用)
- Docker (オプション)

## 自動インストール（推奨）
```bash
cd /path/to/bedrock-project
bash /path/to/ClaudeSkills/templates/bedrock/install.sh
```

## プラグイン/テーマでの使用
[個別コンポーネントでのインストール方法]

## Docker環境での使用
[docker execでのテスト実行方法]

## Git Subtree構成での使用
[親リポジトリとSubtreeでの使い分け]

## トラブルシューティング
[よくある問題と解決方法]
```

**確認項目**:
- [ ] 自動インストール手順が記載されている
- [ ] Docker環境での使用方法が詳細に記載されている
- [ ] Git Subtree構成での使用方法が記載されている
- [ ] トラブルシューティングが充実している

**所要時間**: 15分

---

#### タスク8: README.mdの更新

**目的**: Phase 4完了を記録

**修正ファイル**: `README.md`

**追加内容**:
```markdown
### Phase 4: Bedrock/WordPress用テンプレート ✓

**完了日**: 2025-11-04
**内容**: WordPress/Bedrock環境向けTDDテンプレート作成

- WordPress固有のテストルール（WP_UnitTestCase, Brain Monkey）
- セキュリティ対策ガイドライン（サニタイズ/エスケープ/Nonce）
- Docker環境対応
- Git Subtree構成対応
- 包括的なドキュメント

**ドキュメント**:
- [Phase 4 TDD Document](docs/20251104_0001_Phase4_Bedrock_WordPress統合.md)
- [Bedrock Installation Guide](docs/BEDROCK_INSTALLATION.md)
```

**確認項目**:
- [ ] Phase 4が完了済みとして記録されている
- [ ] 関連ドキュメントへのリンクが追加されている

**所要時間**: 2分

---

### タスク実行順序

1. **タスク1**: Laravel版のコピー（1分）
2. **タスク2-4**: Skills修正（15分）
   - tdd-red修正
   - tdd-green修正
   - tdd-review修正
3. **タスク5**: install.sh修正（3分）
4. **タスク6-7**: ドキュメント作成（25分）
   - CLAUDE.md.example作成
   - BEDROCK_INSTALLATION.md作成
5. **タスク8**: README.md更新（2分）

**合計所要時間**: 約46分

---

### 品質チェック項目

#### コード品質
- [ ] すべてのBashスクリプト構文が正しい（`bash -n`）
- [ ] Markdown文法が正しい
- [ ] コード例がPHP 8.1+互換

#### ドキュメント品質
- [ ] WordPress固有のルールがすべて記載されている
- [ ] Docker環境での使用方法が明確
- [ ] Git Subtree構成での使用方法が明確
- [ ] トラブルシューティングが充実

#### 機能完全性
- [ ] FR-01: Laravel版との互換性維持
- [ ] FR-02: WordPress固有のテストルール
- [ ] FR-03: WordPress固有のコーディング規約
- [ ] FR-04: WordPress固有の品質基準
- [ ] FR-05: Docker環境対応
- [ ] FR-06: Git Subtree対応

---

---

## TDD RED: テストケース詳細化

### テストケース一覧

#### TC-01: Laravel版のコピー成功

**目的**: Laravel版テンプレートが正しくコピーされる

**前提条件**:
- `templates/laravel/` ディレクトリが存在する
- `templates/bedrock/` ディレクトリが存在しない

**テスト手順**:
```bash
# 1. コピー実行
cp -r templates/laravel templates/bedrock

# 2. 検証
ls -la templates/bedrock/.claude/skills/
ls templates/bedrock/install.sh
```

**期待結果**:
- [ ] `templates/bedrock/` ディレクトリが作成されている
- [ ] `templates/bedrock/.claude/skills/` に7つのディレクトリが存在
  - tdd-init
  - tdd-plan
  - tdd-red
  - tdd-green
  - tdd-refactor
  - tdd-review
  - tdd-commit
- [ ] `templates/bedrock/install.sh` が存在し、実行可能

**検証コマンド**:
```bash
test -d templates/bedrock/.claude/skills/tdd-init && echo "✓ tdd-init exists"
test -d templates/bedrock/.claude/skills/tdd-plan && echo "✓ tdd-plan exists"
test -d templates/bedrock/.claude/skills/tdd-red && echo "✓ tdd-red exists"
test -d templates/bedrock/.claude/skills/tdd-green && echo "✓ tdd-green exists"
test -d templates/bedrock/.claude/skills/tdd-refactor && echo "✓ tdd-refactor exists"
test -d templates/bedrock/.claude/skills/tdd-review && echo "✓ tdd-review exists"
test -d templates/bedrock/.claude/skills/tdd-commit && echo "✓ tdd-commit exists"
test -f templates/bedrock/install.sh && echo "✓ install.sh exists"
```

---

#### TC-02: tdd-red SkillにWordPress固有ルールが追加されている

**目的**: WP_UnitTestCase使い分けガイドが記載されている

**前提条件**:
- `templates/bedrock/.claude/skills/tdd-red/SKILL.md` が存在する

**テスト手順**:
```bash
# 1. WordPress固有セクションの存在確認
grep -q "## WordPress環境での注意事項" templates/bedrock/.claude/skills/tdd-red/SKILL.md

# 2. WP_UnitTestCaseの説明確認
grep -q "WP_UnitTestCase を使うケース" templates/bedrock/.claude/skills/tdd-red/SKILL.md

# 3. Brain Monkeyの説明確認
grep -q "Brain\\\Monkey" templates/bedrock/.claude/skills/tdd-red/SKILL.md

# 4. bootstrap.phpの説明確認
grep -q "bootstrap.phpの要件" templates/bedrock/.claude/skills/tdd-red/SKILL.md
```

**期待結果**:
- [ ] "WordPress環境での注意事項" セクションが存在
- [ ] "WP_UnitTestCase を使うケース" の説明がある
- [ ] "PHPUnit\Framework\TestCase を使うケース" の説明がある
- [ ] Brain Monkeyのコード例がある
- [ ] "テストディレクトリ構造" の説明がある
- [ ] "bootstrap.phpの要件" のコード例がある

**検証コマンド**:
```bash
cat templates/bedrock/.claude/skills/tdd-red/SKILL.md | grep -A 5 "WordPress環境での注意事項"
```

---

#### TC-03: tdd-green SkillにWordPressセキュリティ対策が追加されている

**目的**: サニタイズ/エスケープ/Nonceのルールが記載されている

**前提条件**:
- `templates/bedrock/.claude/skills/tdd-green/SKILL.md` が存在する

**テスト手順**:
```bash
# 1. WordPress固有セクションの存在確認
grep -q "## WordPress固有の実装ルール" templates/bedrock/.claude/skills/tdd-green/SKILL.md

# 2. サニタイズの説明確認
grep -q "入力のサニタイズ" templates/bedrock/.claude/skills/tdd-green/SKILL.md
grep -q "sanitize_text_field" templates/bedrock/.claude/skills/tdd-green/SKILL.md

# 3. エスケープの説明確認
grep -q "出力のエスケープ" templates/bedrock/.claude/skills/tdd-green/SKILL.md
grep -q "esc_html" templates/bedrock/.claude/skills/tdd-green/SKILL.md

# 4. Nonce検証の説明確認
grep -q "Nonce検証" templates/bedrock/.claude/skills/tdd-green/SKILL.md
grep -q "wp_verify_nonce" templates/bedrock/.claude/skills/tdd-green/SKILL.md

# 5. WordPress関数優先の説明確認
grep -q "WordPress関数の優先使用" templates/bedrock/.claude/skills/tdd-green/SKILL.md

# 6. Hooks/Filtersの説明確認
grep -q "Hooks/Filtersによる拡張性" templates/bedrock/.claude/skills/tdd-green/SKILL.md
```

**期待結果**:
- [ ] "WordPress固有の実装ルール" セクションが存在
- [ ] "入力のサニタイズ" の説明とコード例（sanitize_text_field等）
- [ ] "出力のエスケープ" の説明とコード例（esc_html等）
- [ ] "Nonce検証" の説明とコード例（wp_verify_nonce等）
- [ ] "WordPress関数の優先使用" の説明（wp_insert_post等）
- [ ] "Hooks/Filtersによる拡張性" の説明（apply_filters等）

**検証コマンド**:
```bash
cat templates/bedrock/.claude/skills/tdd-green/SKILL.md | grep -A 3 "入力のサニタイズ"
cat templates/bedrock/.claude/skills/tdd-green/SKILL.md | grep -A 3 "出力のエスケープ"
```

---

#### TC-04: tdd-review SkillにWordPress品質チェックリストが追加されている

**目的**: WordPress固有の品質基準が記載されている

**前提条件**:
- `templates/bedrock/.claude/skills/tdd-review/SKILL.md` が存在する

**テスト手順**:
```bash
# 1. WordPress固有セクションの存在確認
grep -q "## WordPress固有の品質チェック" templates/bedrock/.claude/skills/tdd-review/SKILL.md

# 2. セキュリティチェックリスト確認
grep -q "セキュリティチェックリスト" templates/bedrock/.claude/skills/tdd-review/SKILL.md
grep -q "入力サニタイズ" templates/bedrock/.claude/skills/tdd-review/SKILL.md
grep -q "出力エスケープ" templates/bedrock/.claude/skills/tdd-review/SKILL.md

# 3. WordPress規約チェックリスト確認
grep -q "WordPress規約チェックリスト" templates/bedrock/.claude/skills/tdd-review/SKILL.md
grep -q "WordPress関数優先" templates/bedrock/.claude/skills/tdd-review/SKILL.md

# 4. 静的解析チェックリスト確認
grep -q "静的解析チェックリスト" templates/bedrock/.claude/skills/tdd-review/SKILL.md
grep -q "PHPStan Level 8" templates/bedrock/.claude/skills/tdd-review/SKILL.md

# 5. カバレッジチェックリスト確認
grep -q "テストカバレッジチェックリスト" templates/bedrock/.claude/skills/tdd-review/SKILL.md
grep -q "カバレッジ90%以上" templates/bedrock/.claude/skills/tdd-review/SKILL.md
```

**期待結果**:
- [ ] "WordPress固有の品質チェック" セクションが存在
- [ ] セキュリティチェックリスト（5項目）
  - 入力サニタイズ
  - 出力エスケープ
  - Nonce検証
  - 権限チェック
  - SQLインジェクション対策
- [ ] WordPress規約チェックリスト（5項目）
  - WordPress関数優先
  - Hooks/Filters
  - 国際化対応
  - Coding Standards
  - 後方互換性
- [ ] 静的解析チェックリスト（3項目）
  - PHPStan Level 8
  - WordPress型定義
  - 型安全性
- [ ] テストカバレッジチェックリスト（3項目）
  - カバレッジ90%以上
  - Unit/Integration分離
  - WordPress関数モック

**検証コマンド**:
```bash
cat templates/bedrock/.claude/skills/tdd-review/SKILL.md | grep -A 10 "セキュリティチェックリスト"
```

---

#### TC-05: install.shにDocker環境検出が追加されている

**目的**: Docker環境を検出してメッセージを表示する

**前提条件**:
- `templates/bedrock/install.sh` が存在する

**テスト手順**:
```bash
# 1. Docker環境検出コードの存在確認
grep -q "command -v docker" templates/bedrock/install.sh
grep -q "Docker環境を検出しました" templates/bedrock/install.sh

# 2. Bash構文チェック
bash -n templates/bedrock/install.sh
```

**期待結果**:
- [ ] Docker環境検出コードが存在
- [ ] "Docker環境を検出しました" メッセージが存在
- [ ] テスト実行例が表示される
- [ ] Bash構文エラーがない

**検証コマンド**:
```bash
grep -A 5 "Docker環境検出" templates/bedrock/install.sh
bash -n templates/bedrock/install.sh && echo "✓ Syntax OK"
```

---

#### TC-06: CLAUDE.md.exampleが作成されている

**目的**: WordPress/Bedrock向けの設定例が提供されている

**前提条件**:
- なし

**テスト手順**:
```bash
# 1. ファイル存在確認
test -f templates/bedrock/CLAUDE.md.example

# 2. 必須セクション確認
grep -q "## Project Overview" templates/bedrock/CLAUDE.md.example
grep -q "## TDD Workflow" templates/bedrock/CLAUDE.md.example
grep -q "## Quality Standards" templates/bedrock/CLAUDE.md.example
grep -q "## Docker Environment" templates/bedrock/CLAUDE.md.example
grep -q "## Git Subtree Configuration" templates/bedrock/CLAUDE.md.example
grep -q "## WordPress Development Guidelines" templates/bedrock/CLAUDE.md.example
```

**期待結果**:
- [ ] `templates/bedrock/CLAUDE.md.example` が存在
- [ ] "Project Overview" セクションが存在
- [ ] "TDD Workflow" セクションが存在（7 Skills紹介）
- [ ] "Quality Standards" セクションが存在（PHPStan Level 8, カバレッジ90%）
- [ ] "Docker Environment" セクションが存在（docker execでのテスト実行例）
- [ ] "Git Subtree Configuration" セクションが存在（subtree push/pull例）
- [ ] "WordPress Development Guidelines" セクションが存在（セキュリティ対策等）
- [ ] "Available Commands" セクションが存在（composer test, pint, stan等）

**検証コマンド**:
```bash
test -f templates/bedrock/CLAUDE.md.example && echo "✓ File exists"
cat templates/bedrock/CLAUDE.md.example | grep "^## " | head -10
```

---

#### TC-07: BEDROCK_INSTALLATION.mdが作成されている

**目的**: WordPress/Bedrock向けインストールガイドが提供されている

**前提条件**:
- なし

**テスト手順**:
```bash
# 1. ファイル存在確認
test -f docs/BEDROCK_INSTALLATION.md

# 2. 必須セクション確認
grep -q "## 前提条件" docs/BEDROCK_INSTALLATION.md
grep -q "## 自動インストール" docs/BEDROCK_INSTALLATION.md
grep -q "## プラグイン/テーマでの使用" docs/BEDROCK_INSTALLATION.md
grep -q "## Docker環境での使用" docs/BEDROCK_INSTALLATION.md
grep -q "## Git Subtree構成での使用" docs/BEDROCK_INSTALLATION.md
grep -q "## トラブルシューティング" docs/BEDROCK_INSTALLATION.md
```

**期待結果**:
- [ ] `docs/BEDROCK_INSTALLATION.md` が存在
- [ ] "前提条件" セクションが存在（PHP, Composer, Node.js, Docker）
- [ ] "自動インストール" セクションが存在（install.shの実行方法）
- [ ] "手動インストール" セクションが存在
- [ ] "プラグイン/テーマでの使用" セクションが存在
- [ ] "Docker環境での使用" セクションが存在（docker execコマンド例）
- [ ] "Git Subtree構成での使用" セクションが存在（親リポジトリとSubtreeの使い分け）
- [ ] "トラブルシューティング" セクションが存在
- [ ] "よくある質問" セクションが存在

**検証コマンド**:
```bash
test -f docs/BEDROCK_INSTALLATION.md && echo "✓ File exists"
cat docs/BEDROCK_INSTALLATION.md | grep "^## " | head -10
```

---

#### TC-08: README.mdにPhase 4完了が記録されている

**目的**: Phase 4の完了が正しく記録されている

**前提条件**:
- `README.md` が存在する

**テスト手順**:
```bash
# 1. Phase 4セクション確認
grep -q "Phase 4: Bedrock/WordPress用テンプレート" README.md

# 2. 完了日確認
grep -q "完了日.*2025-11-04" README.md

# 3. ドキュメントリンク確認
grep -q "docs/20251104_0001_Phase4_Bedrock_WordPress統合.md" README.md
grep -q "docs/BEDROCK_INSTALLATION.md" README.md
```

**期待結果**:
- [ ] "Phase 4: Bedrock/WordPress用テンプレート" セクションが存在
- [ ] 完了マーク（✓）が付いている
- [ ] 完了日が "2025-11-04" になっている
- [ ] Phase 4の内容が箇条書きで記載されている
  - WordPress固有のテストルール
  - セキュリティ対策ガイドライン
  - Docker環境対応
  - Git Subtree構成対応
  - 包括的なドキュメント
- [ ] TDDドキュメントへのリンクが存在
- [ ] Bedrockインストールガイドへのリンクが存在

**検証コマンド**:
```bash
grep -A 15 "Phase 4:" README.md
```

---

### テストケース実行順序

1. **TC-01**: Laravel版のコピー成功（最初に実行）
2. **TC-02**: tdd-red Skill修正確認
3. **TC-03**: tdd-green Skill修正確認
4. **TC-04**: tdd-review Skill修正確認
5. **TC-05**: install.sh修正確認
6. **TC-06**: CLAUDE.md.example作成確認
7. **TC-07**: BEDROCK_INSTALLATION.md作成確認
8. **TC-08**: README.md更新確認（最後に実行）

---

### テスト成功基準

**すべてのテストケースがPASSすること**:
- TC-01: ✓ 7つのSkillsがコピーされている
- TC-02: ✓ tdd-redにWordPressテストルールが追加されている
- TC-03: ✓ tdd-greenにセキュリティ対策が追加されている
- TC-04: ✓ tdd-reviewにWordPress品質チェックリストが追加されている
- TC-05: ✓ install.shにDocker環境検出が追加されている
- TC-06: ✓ CLAUDE.md.exampleが作成されている
- TC-07: ✓ BEDROCK_INSTALLATION.mdが作成されている
- TC-08: ✓ README.mdにPhase 4完了が記録されている

**品質基準**:
- Bash構文エラー: 0件
- 必須セクション不足: 0件
- コード例不足: 0件

---

## 次フェーズ

**TDD GREEN**: 実装
