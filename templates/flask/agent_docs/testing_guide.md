# Flask Testing Guide

## テストディレクトリ構造

```
tests/
├── conftest.py       # 共通fixtures
├── unit/             # 単体テスト
│   └── test_*.py
└── integration/      # 統合テスト
    └── test_*.py
```

---

## pytest 基本構造

### conftest.py（共通fixtures）

```python
import pytest
from app import create_app

@pytest.fixture
def app():
    """テスト用アプリケーションインスタンス"""
    app = create_app()
    app.config.update({
        'TESTING': True,
        'SQLALCHEMY_DATABASE_URI': 'sqlite:///:memory:',
    })
    yield app

@pytest.fixture
def client(app):
    """テストクライアント"""
    return app.test_client()

@pytest.fixture
def runner(app):
    """CLIテストランナー"""
    return app.test_cli_runner()
```

---

## テストの書き方

### 基本構造

```python
def test_example():
    # Given: 前提条件
    value = 1

    # When: 操作
    result = value + 1

    # Then: 検証
    assert result == 2
```

### Feature テスト（HTTPリクエスト）

```python
def test_user_can_login(client):
    # Given: 有効なユーザーが存在する
    # （実際はDBにユーザーを作成）

    # When: ログインエンドポイントにPOST
    response = client.post('/login', json={
        'email': 'test@example.com',
        'password': 'password123',
    })

    # Then: 成功レスポンスが返る
    assert response.status_code == 200

    # And: トークンが含まれる
    data = response.get_json()
    assert 'token' in data
```

### Unit テスト

```python
from app.services.user_service import UserService

def test_password_is_hashed():
    # Given: パスワード
    password = 'password123'

    # When: ハッシュ化
    hashed = UserService.hash_password(password)

    # Then: 元のパスワードと異なる
    assert hashed != password

    # And: 検証が通る
    assert UserService.verify_password(password, hashed)
```

---

## 命名規則

- ファイル名: `test_*.py` または `*_test.py`
- 関数名: `test_` プレフィックス
- クラス名: `Test*`（クラスベースの場合）

```python
# ファイル: tests/unit/test_user_service.py

def test_user_can_register():
    pass

def test_invalid_email_raises_error():
    pass

# クラスベース（オプション）
class TestUserService:
    def test_create_user(self):
        pass
```

---

## Fixtures

### スコープ

```python
@pytest.fixture(scope='function')  # デフォルト、各テストごと
def client():
    pass

@pytest.fixture(scope='module')    # モジュールごと
def db():
    pass

@pytest.fixture(scope='session')   # セッション全体で1回
def app():
    pass
```

### パラメータ化

```python
import pytest

@pytest.mark.parametrize('email,expected', [
    ('valid@example.com', True),
    ('invalid', False),
    ('', False),
])
def test_email_validation(email, expected):
    result = validate_email(email)
    assert result == expected
```

---

## モック（pytest-mock）

```python
def test_service_calls_repository(mocker):
    # Given: リポジトリをモック
    mock_repo = mocker.patch('app.services.user_service.UserRepository')
    mock_repo.find.return_value = {'id': 1, 'name': 'Test'}

    # When: サービスを呼び出し
    service = UserService()
    user = service.get_user(1)

    # Then: リポジトリが呼ばれた
    mock_repo.find.assert_called_once_with(1)
    assert user['name'] == 'Test'
```

---

## よく使うアサーション

```python
# 値の検証
assert result == expected
assert result is not None
assert result in collection
assert len(items) == 3

# 例外
import pytest
with pytest.raises(ValueError):
    raise ValueError('error')

# 近似値（浮動小数点）
assert result == pytest.approx(3.14, rel=1e-2)

# HTTPレスポンス
assert response.status_code == 200
assert response.content_type == 'application/json'
data = response.get_json()
assert data['key'] == 'value'
```

---

## データベーステスト

### トランザクションロールバック

```python
@pytest.fixture
def db_session(app):
    """各テスト後にロールバック"""
    with app.app_context():
        db.session.begin_nested()
        yield db.session
        db.session.rollback()
```

### Factory Boy（推奨）

```python
import factory
from app.models import User

class UserFactory(factory.Factory):
    class Meta:
        model = User

    name = factory.Faker('name')
    email = factory.Faker('email')

# 使用例
def test_user_list(client, db_session):
    # Given: ユーザーが3人存在
    UserFactory.create_batch(3)

    # When: 一覧取得
    response = client.get('/users')

    # Then: 3人返る
    assert len(response.get_json()) == 3
```

---

*詳細: https://docs.pytest.org/*
