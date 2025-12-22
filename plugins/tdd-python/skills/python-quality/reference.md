# python-quality Reference

## pytest Configuration

### pyproject.toml

```toml
[tool.pytest.ini_options]
testpaths = ["tests"]
python_files = ["test_*.py"]
python_functions = ["test_*"]
addopts = "-v --tb=short"
```

### conftest.py

```python
import pytest

@pytest.fixture
def app():
    """アプリケーションフィクスチャ"""
    pass
```

## mypy Configuration

### pyproject.toml

```toml
[tool.mypy]
python_version = "3.11"
strict = true
warn_return_any = true
warn_unused_configs = true
```

### レベル説明

| オプション | 効果 |
|-----------|------|
| --strict | 全チェック有効 |
| --ignore-missing-imports | 型スタブ無視 |
| --no-implicit-optional | 暗黙Optional禁止 |

## Black/isort Configuration

### pyproject.toml

```toml
[tool.black]
line-length = 88
target-version = ['py311']

[tool.isort]
profile = "black"
line_length = 88
```

## ruff Configuration

### pyproject.toml

```toml
[tool.ruff]
line-length = 88
select = ["E", "F", "I", "N", "W"]
ignore = ["E501"]

[tool.ruff.isort]
known-first-party = ["src"]
```

## Error Handling

### mypy エラー

```
エラー: Incompatible types in assignment

対応:
1. 型アノテーションを追加
2. Optional[T]を使用
3. # type: ignore で一時的に除外
```

### pytest エラー

```
エラー: fixture not found

対応:
1. conftest.pyの場所を確認
2. fixture名のスペルを確認
3. scopeを確認
```
