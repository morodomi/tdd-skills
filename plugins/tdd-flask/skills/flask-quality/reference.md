# flask-quality Reference

Flask固有のテストパターン。汎用Python設定は `tdd-python` を参照。

## Requirements

```
pytest-flask: 1.3.0+
Flask: 2.3+ (Flask 3.x 推奨)
```

## Flask 3.x Patterns

### App Factory Pattern

```python
def create_app(config=None):
    app = Flask(__name__)
    if config:
        app.config.from_mapping(config)
    return app
```

### pytest-flask 1.3.0+ の変更点

- `request_ctx` fixture は**廃止**
- 代わりに `app.test_request_context()` を使用

```python
def test_with_request_context(app):
    with app.test_request_context():
        pass
```

## conftest.py

```python
import pytest
from myapp import create_app

@pytest.fixture
def app():
    app = create_app()
    app.config.update({"TESTING": True})
    yield app

@pytest.fixture
def client(app):
    return app.test_client()
```

## Testing Patterns

### セッション操作

```python
def test_session(client):
    with client.session_transaction() as session:
        session['user_id'] = 1
    response = client.get('/api/me')
    assert response.status_code == 200
```

### Database Fixture

```python
@pytest.fixture
def db(app):
    from myapp.db import db as _db
    with app.app_context():
        _db.create_all()
        yield _db
        _db.drop_all()
```

## Troubleshooting

| エラー | 対応 |
|--------|------|
| fixture 'app' not found | conftest.py の場所確認 |
| session_transaction 不可 | pytest-flask 1.3.0+ 確認 |
