---
name: flask-quality
description: Flask品質チェック。pytest-flask/mypy/Black実行時に使用。「Flaskの品質チェック」「Flask テスト」で起動。
allowed-tools: Bash, Read, Grep, Glob
---

# Flask Quality Check

Flask プロジェクトの品質チェックツール。

## Commands

| ツール | コマンド | 用途 |
|--------|---------|------|
| pytest | `pytest` | テスト実行（pytest-flask） |
| mypy | `mypy --strict` | 型チェック |
| Black | `black .` | コードフォーマット |
| isort | `isort .` | import整理 |

## Flask-specific Testing

### Fixtures (pytest-flask)

| Fixture | 用途 |
|---------|------|
| `client` | test_client インスタンス |
| `app` | Flask アプリケーション |
| `app_context` | アプリケーションコンテキスト |

### App Factory Pattern

```python
# conftest.py
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

## Usage

### テスト実行

```bash
# 基本
pytest

# verbose
pytest -v

# 特定ファイル
pytest tests/test_routes.py

# カバレッジ
pytest --cov=src --cov-report=html
```

### API テスト例

```python
def test_get_users(client):
    response = client.get('/api/users')
    assert response.status_code == 200
    assert response.json is not None

def test_create_user(client):
    response = client.post('/api/users', json={
        'name': 'Test User',
        'email': 'test@example.com'
    })
    assert response.status_code == 201
```

### 静的解析

```bash
# 型チェック
mypy --strict src/

# フォーマット
black .
isort .
```

## Quality Standards

| 項目 | 目標 |
|------|------|
| mypy | strict mode |
| カバレッジ | 90%+ |
| black/isort | エラー0 |

## Reference

- 詳細: `reference.md`
