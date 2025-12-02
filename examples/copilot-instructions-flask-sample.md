# GitHub Copilot Instructions

## 前提条件

- 回答は必ず日本語で行う
- 200行を超える変更は事前に確認を求める
- コード生成時は必ずdocstringとコメントを含める
- PEP 8に準拠したコードを生成する

## プロジェクト概要

このプロジェクトは、Flask + Jinja2 + AlpineJS + Tailwind CSSで構築されたWebアプリケーションです。

主な機能：
- ユーザー認証（ログイン・登録）
- RESTful API
- リアルタイムUI更新（AlpineJS）
- レスポンシブデザイン（Tailwind CSS）

## 技術スタック

### バックエンド
- **言語**: Python 3.12
- **フレームワーク**: Flask 3.0
- **テンプレートエンジン**: Jinja2 3.1
- **データベース**: SQLAlchemy 2.0（ORM）
- **マイグレーション**: Flask-Migrate 4.0
- **認証**: Flask-Login 0.6

### フロントエンド
- **JavaScript**: AlpineJS 3.x
- **CSS**: Tailwind CSS 3.4
- **ビルドツール**: Vite 5.0

### 開発ツール
- **テスト**: pytest 8.0, pytest-flask 1.3
- **静的解析**:
  - mypy 1.8（型チェック）
  - ruff 0.1（リンター・フォーマッター）
- **カバレッジ**: pytest-cov 4.1
- **環境管理**: Poetry 1.7

## ディレクトリ構成

```
project/
├── app/
│   ├── __init__.py           # Flaskアプリケーションファクトリ
│   ├── models/               # SQLAlchemyモデル
│   │   ├── __init__.py
│   │   ├── user.py
│   │   └── post.py
│   ├── views/                # ビューハンドラー（Blueprint）
│   │   ├── __init__.py
│   │   ├── auth.py
│   │   └── main.py
│   ├── api/                  # REST API エンドポイント
│   │   ├── __init__.py
│   │   └── v1/
│   ├── forms/                # WTForms フォーム定義
│   │   ├── __init__.py
│   │   └── auth.py
│   ├── services/             # ビジネスロジック
│   │   ├── __init__.py
│   │   └── user_service.py
│   ├── templates/            # Jinja2テンプレート
│   │   ├── base.html
│   │   ├── auth/
│   │   └── main/
│   ├── static/               # 静的ファイル
│   │   ├── css/
│   │   ├── js/
│   │   └── images/
│   └── utils/                # ユーティリティ関数
│       ├── __init__.py
│       └── validators.py
├── tests/                    # テストコード
│   ├── conftest.py           # pytest設定・フィクスチャ
│   ├── unit/                 # 単体テスト
│   │   ├── test_models.py
│   │   └── test_services.py
│   ├── integration/          # 統合テスト
│   │   ├── test_views.py
│   │   └── test_api.py
│   └── e2e/                  # E2Eテスト（Playwright）
│       └── test_user_flow.py
├── migrations/               # データベースマイグレーション
├── docs/                     # TDDドキュメント
│   └── YYYYMMDD_hhmm_機能名.md
├── config.py                 # アプリケーション設定
├── pyproject.toml            # Poetry設定
└── .env.example              # 環境変数テンプレート
```

### 配置方針

- **モデル**: `app/models/` 配下、1ファイル1モデル
- **ビュー**: `app/views/` 配下、機能ごとにBlueprintを分割
- **API**: `app/api/` 配下、バージョンごとにディレクトリ分割
- **サービス層**: `app/services/` 配下、ビジネスロジックを集約
- **テンプレート**: `app/templates/` 配下、機能ごとにディレクトリ分割
- **テスト**: `tests/` 配下、`unit/`, `integration/`, `e2e/` で分類

## アーキテクチャ・設計指針

### レイヤー構造

```
View (Blueprint) → Service → Model → Database
                     ↓
                   Form (WTForms)
```

- **View**: HTTPリクエストのハンドリング、テンプレートレンダリング
- **Service**: ビジネスロジックの実装
- **Model**: データベーステーブルの定義
- **Form**: バリデーションルール

### 主要な設計原則

- **Application Factory パターン**: `create_app()` でFlaskインスタンス生成
- **Blueprint**: 機能ごとにモジュール分割
- **依存性注入**: サービス層でDBセッションを注入
- **型ヒント**: すべての関数・メソッドに型ヒントを付与
- **Single Responsibility**: 各モジュールは単一の責務を持つ

### データベース設計

- **ORM**: SQLAlchemy declarative style
- **マイグレーション**: Flask-Migrate（Alembic）を使用
- **命名規則**:
  - テーブル名: スネークケース（例: `user_profiles`）
  - カラム名: スネークケース（例: `created_at`）
  - 外部キー: `{table}_id`（例: `user_id`）

### フロントエンド設計

- **AlpineJS**: インラインでリアクティブな動作を記述
- **Tailwind CSS**: ユーティリティクラスでスタイリング
- **Jinja2**: サーバーサイドレンダリング
- **HTMX**: 部分的なページ更新（オプション）

## テスト方針

### テストフレームワーク

- **単体テスト**: pytest + pytest-flask
- **統合テスト**: pytest + Flask test client
- **E2Eテスト**: Playwright（オプション）
- **カバレッジ目標**: 90%以上

### テストディレクトリ構造

```
tests/
├── conftest.py              # pytest設定・共通フィクスチャ
├── unit/                    # 単体テスト
│   ├── test_models.py       # モデルのテスト
│   ├── test_services.py     # サービス層のテスト
│   └── test_utils.py        # ユーティリティのテスト
├── integration/             # 統合テスト
│   ├── test_views.py        # ビューのテスト
│   ├── test_api.py          # APIエンドポイントのテスト
│   └── test_forms.py        # フォームバリデーションのテスト
└── e2e/                     # E2Eテスト
    └── test_user_flow.py    # ユーザーフローのテスト
```

### テスト命名規則

- **ファイル名**: `test_*.py`
- **テスト関数**: `test_<機能>_<条件>_<期待結果>`
- **例**: `test_user_login_with_valid_credentials_returns_200`

### テスト記述パターン

すべてのテストは **Given/When/Then** 形式でコメントを記載：

```python
def test_user_can_register_with_valid_data():
    """正常なデータでユーザー登録ができる"""
    # Given: 有効なユーザーデータが用意されている
    user_data = {
        "username": "testuser",
        "email": "test@example.com",
        "password": "SecurePass123!"
    }

    # When: ユーザー登録APIを呼び出す
    response = client.post("/api/v1/users", json=user_data)

    # Then: 201 Createdが返される
    assert response.status_code == 201

    # And: ユーザーがデータベースに保存されている
    user = User.query.filter_by(username="testuser").first()
    assert user is not None
    assert user.email == "test@example.com"
```

### フィクスチャ

共通フィクスチャは `tests/conftest.py` に定義：

```python
@pytest.fixture
def app():
    """Flaskアプリケーションのテスト用インスタンス"""
    app = create_app("testing")
    yield app

@pytest.fixture
def client(app):
    """Flaskテストクライアント"""
    return app.test_client()

@pytest.fixture
def db(app):
    """テスト用データベース"""
    with app.app_context():
        _db.create_all()
        yield _db
        _db.session.remove()
        _db.drop_all()
```

### テスト実行コマンド

```bash
# すべてのテストを実行
pytest

# カバレッジ付きで実行
pytest --cov=app --cov-report=html

# 特定のディレクトリのみ実行
pytest tests/unit/

# マーカー付きテスト実行
pytest -m "not slow"

# 並列実行
pytest -n auto
```

## コーディング規約

### Python コーディングスタイル

- **PEP 8**: Pythonの標準コーディング規約に準拠
- **フォーマッター**: ruff format（自動整形）
- **リンター**: ruff check（構文チェック）
- **インポート順序**: 標準ライブラリ → サードパーティ → ローカル
- **行の長さ**: 最大88文字（Black互換）

### 型ヒント

すべての関数・メソッドに型ヒントを付与：

```python
from typing import Optional, List
from flask import Response

def create_user(username: str, email: str, password: str) -> User:
    """ユーザーを作成する"""
    user = User(username=username, email=email)
    user.set_password(password)
    db.session.add(user)
    db.session.commit()
    return user

def get_users(page: int = 1, per_page: int = 20) -> List[User]:
    """ユーザー一覧を取得する"""
    return User.query.paginate(page=page, per_page=per_page).items
```

### Docstring

すべての関数・クラスにdocstringを記載（Google Style）：

```python
def validate_email(email: str) -> bool:
    """メールアドレスの形式を検証する

    Args:
        email: 検証するメールアドレス

    Returns:
        bool: 有効なメールアドレスの場合True

    Raises:
        ValueError: メールアドレスが空文字の場合
    """
    if not email:
        raise ValueError("Email cannot be empty")
    return re.match(r"[^@]+@[^@]+\.[^@]+", email) is not None
```

### Flask固有の規約

- **Blueprintの登録**: `app/__init__.py` の `create_app()` 内で実施
- **環境変数**: `.env` ファイルで管理、`python-dotenv` で読み込み
- **設定クラス**: `config.py` で環境ごとに分割（Development, Testing, Production）
- **データベースセッション**: `flask-sqlalchemy` のセッション管理を使用

### Jinja2テンプレート

- **継承**: `base.html` を基底テンプレートとして使用
- **ブロック**: `{% block content %}` で内容を上書き
- **変数展開**: `{{ variable }}` で変数を展開
- **制御構文**: `{% if %}`, `{% for %}` で制御フロー

```html
{% extends "base.html" %}

{% block title %}ユーザー一覧{% endblock %}

{% block content %}
<div class="container mx-auto px-4" x-data="{ users: [] }">
    <h1 class="text-3xl font-bold mb-6">ユーザー一覧</h1>

    {% for user in users %}
    <div class="bg-white shadow-md rounded-lg p-4 mb-4">
        <h2 class="text-xl font-semibold">{{ user.username }}</h2>
        <p class="text-gray-600">{{ user.email }}</p>
    </div>
    {% endfor %}
</div>
{% endblock %}
```

### AlpineJS の使用方針

- **x-data**: コンポーネントの状態を定義
- **x-show/x-if**: 条件付き表示
- **x-on**: イベントハンドラ
- **x-bind**: 属性バインディング
- **@click**, **@submit**: イベントショートハンド

```html
<div x-data="{ open: false }">
    <button @click="open = !open" class="btn btn-primary">
        トグル
    </button>

    <div x-show="open" class="mt-4">
        表示内容
    </div>
</div>
```

### Tailwind CSS の使用方針

- **ユーティリティクラス**: `px-4`, `py-2`, `bg-blue-500` 等を使用
- **カスタムCSS**: 最小限に抑える（`@apply` ディレクティブ使用時のみ）
- **レスポンシブ**: `sm:`, `md:`, `lg:` プレフィックス使用
- **ダークモード**: `dark:` プレフィックス使用

```html
<div class="container mx-auto px-4 sm:px-6 lg:px-8">
    <button class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">
        ボタン
    </button>
</div>
```

## 静的解析とコード品質

### mypy（型チェック）

- **設定**: `pyproject.toml` の `[tool.mypy]` セクション
- **厳格モード**: `strict = true`
- **エラー許容**: 0件（すべてのエラーを解決）

```toml
[tool.mypy]
python_version = "3.12"
strict = true
warn_return_any = true
warn_unused_configs = true
disallow_untyped_defs = true
```

実行コマンド：
```bash
mypy app/
```

### ruff（リンター・フォーマッター）

- **リント**: コードの問題を検出
- **フォーマット**: コードを自動整形
- **ルールセット**: `E`, `F`, `I`, `N`, `W`（Flake8互換）

```toml
[tool.ruff]
line-length = 88
target-version = "py312"

[tool.ruff.lint]
select = ["E", "F", "I", "N", "W", "B", "C90"]
ignore = ["E501"]  # 行の長さはruff formatに任せる
```

実行コマンド：
```bash
# リント
ruff check app/

# フォーマット
ruff format app/
```

### pytest-cov（カバレッジ）

- **目標**: 90%以上
- **除外**: `tests/`, `migrations/`, `config.py`
- **レポート**: HTML形式で生成

```toml
[tool.coverage.run]
source = ["app"]
omit = ["tests/*", "migrations/*", "config.py"]

[tool.coverage.report]
fail_under = 90
```

実行コマンド：
```bash
pytest --cov=app --cov-report=html --cov-report=term
```

## TDDワークフロー

このプロジェクトは厳格なTDDワークフローを採用しています。

### 7つのフェーズ

```
INIT → PLAN → RED → GREEN → REFACTOR → REVIEW → COMMIT
```

1. **INIT**: 要件定義、TDDドキュメント作成
2. **PLAN**: 実装計画、テストケース一覧作成
3. **RED**: 失敗するテストを作成
4. **GREEN**: 最小限の実装でテストを通す
5. **REFACTOR**: コードを改善（テストは維持）
6. **REVIEW**: 品質検証（カバレッジ、静的解析）
7. **COMMIT**: 変更をコミット

### TDDドキュメント管理

すべての機能開発は `docs/` ディレクトリにTDDドキュメントを作成：

**ファイル命名規則**: `docs/YYYYMMDD_hhmm_機能名.md`

**例**: `docs/20251105_1430_ユーザー登録機能.md`

**ドキュメント構成**:
```markdown
# 機能名: ユーザー登録機能

## INIT: 要件定義

### 背景
...

### 目標
...

## PLAN: 実装計画

### テストケース一覧

#### 実装予定（TODO）
- [ ] TC-01: ユーザー登録：正常系
- [ ] TC-02: ユーザー登録：メールアドレス重複エラー

#### 実装中（WIP）
（まだなし）

#### 実装中に気づいた追加テスト（DISCOVERED）
（実装中に追加される）

#### 完了（DONE）
（まだなし）

## RED: テストコード

...

## GREEN: 実装

...

## REFACTOR: リファクタリング

...

## REVIEW: 品質検証

...

## COMMIT: コミット情報

...
```

### テストリストの管理

実装中に気づいたことは**今すぐ対応せず、テストリストに追加**：

```markdown
### 実装中に気づいた追加テスト（DISCOVERED）
- [ ] TC-04: パスワードリセット機能（GREEN中に気づいた - Priority: High）
- [ ] TC-05: セッション有効期限（REFACTOR中に気づいた - Priority: Medium）
```

## アンチパターン

以下のパターンは使用禁止：

### Python全般

- ❌ `import *`（ワイルドカードインポート）
- ❌ 型ヒントなしの関数定義
- ❌ `Any` 型の多用（`unknown` や具体的な型を使用）
- ❌ ミュータブルなデフォルト引数（`def func(items=[])` → `def func(items=None)`）
- ❌ グローバル変数の使用
- ❌ `print()` によるデバッグ（`logging` を使用）

### Flask固有

- ❌ アプリケーションコンテキスト外でのDB操作
- ❌ グローバルな `app` インスタンス（Application Factoryを使用）
- ❌ ハードコードされた設定値（環境変数または `config.py` を使用）
- ❌ `@app.route` デコレータの多用（Blueprintを使用）

### データベース

- ❌ 生のSQL文の実行（SQLAlchemy ORMを使用）
- ❌ N+1クエリ問題（`joinedload`, `selectinload` で解決）
- ❌ マイグレーションファイルの手動編集（`flask db migrate` を使用）

### テンプレート

- ❌ テンプレート内でのビジネスロジック実装
- ❌ インラインスタイル（Tailwind CSSを使用）
- ❌ 大量のJavaScript（AlpineJSで簡潔に記述）

### セキュリティ

- ❌ パスワードの平文保存（`werkzeug.security` でハッシュ化）
- ❌ SQLインジェクション脆弱性（ORMのパラメータバインディング使用）
- ❌ XSS脆弱性（Jinja2の自動エスケープを活用）
- ❌ CSRF保護なしのフォーム（Flask-WTFを使用）
- ❌ シークレットキーのハードコード（環境変数で管理）

## 環境変数

環境変数は `.env` ファイルで管理：

```.env
# Flask設定
FLASK_APP=app
FLASK_ENV=development
SECRET_KEY=your-secret-key-here

# データベース
DATABASE_URL=postgresql://user:password@localhost/dbname

# メール設定（オプション）
MAIL_SERVER=smtp.gmail.com
MAIL_PORT=587
MAIL_USERNAME=your-email@gmail.com
MAIL_PASSWORD=your-password

# 外部API（オプション）
EXTERNAL_API_KEY=your-api-key
```

**重要**: `.env` ファイルは `.gitignore` に追加し、`.env.example` をテンプレートとして提供する。

---

*このファイルはTDD開発のためのGitHub Copilot設定です*
