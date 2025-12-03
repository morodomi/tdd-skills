# Flask Quality Standards

## カバレッジ目標

| 指標 | 目標 | 最低ライン |
|------|------|-----------|
| Line Coverage | 90%以上 | 80% |
| Branch Coverage | 85%以上 | 75% |

---

## 静的解析: mypy

### 設定（pyproject.toml）

```toml
[tool.mypy]
python_version = "3.11"
strict = true
warn_return_any = true
warn_unused_configs = true
disallow_untyped_defs = true

[[tool.mypy.overrides]]
module = "tests.*"
disallow_untyped_defs = false
```

### コマンド

```bash
# 基本実行
mypy app/

# strict モード
mypy app/ --strict

# 特定ファイル
mypy app/services/user_service.py
```

### 目標

- エラー: **0件**
- 警告: 可能な限り0件

---

## フォーマッター: black + isort

### black 設定（pyproject.toml）

```toml
[tool.black]
line-length = 88
target-version = ['py311']
include = '\.pyi?$'
extend-exclude = '''
/(
    \.git
    | \.venv
    | migrations
)/
'''
```

### isort 設定（pyproject.toml）

```toml
[tool.isort]
profile = "black"
line_length = 88
known_first_party = ["app"]
sections = ["FUTURE", "STDLIB", "THIRDPARTY", "FIRSTPARTY", "LOCALFOLDER"]
```

### コマンド

```bash
# フォーマット実行
black app/ tests/
isort app/ tests/

# チェックのみ
black --check app/ tests/
isort --check-only app/ tests/
```

---

## リンター: ruff

### 設定（pyproject.toml）

```toml
[tool.ruff]
line-length = 88
target-version = "py311"

select = [
    "E",      # pycodestyle errors
    "F",      # Pyflakes
    "W",      # pycodestyle warnings
    "I",      # isort
    "UP",     # pyupgrade
    "B",      # flake8-bugbear
    "C4",     # flake8-comprehensions
    "SIM",    # flake8-simplify
]

ignore = [
    "E501",   # line too long (black handles this)
]

[tool.ruff.per-file-ignores]
"tests/*" = ["S101"]  # assert allowed in tests
```

### コマンド

```bash
# チェック
ruff check app/

# 自動修正
ruff check app/ --fix

# フォーマット（ruff format）
ruff format app/
```

---

## テスト: pytest

### 設定（pyproject.toml）

```toml
[tool.pytest.ini_options]
testpaths = ["tests"]
python_files = ["test_*.py", "*_test.py"]
python_functions = ["test_*"]
addopts = [
    "-v",
    "--strict-markers",
    "--tb=short",
]
markers = [
    "slow: marks tests as slow",
    "integration: marks tests as integration tests",
]
```

### カバレッジ設定（pyproject.toml）

```toml
[tool.coverage.run]
source = ["app"]
branch = true
omit = [
    "*/migrations/*",
    "*/__pycache__/*",
    "*/tests/*",
]

[tool.coverage.report]
exclude_lines = [
    "pragma: no cover",
    "if TYPE_CHECKING:",
    "raise NotImplementedError",
]
fail_under = 80
```

---

## 一括品質チェック

### Makefile（推奨）

```makefile
.PHONY: lint test check

lint:
	ruff check app/
	mypy app/
	black --check app/ tests/
	isort --check-only app/ tests/

test:
	pytest --cov=app --cov-report=term-missing

check: lint test
	@echo "All checks passed!"
```

### 実行

```bash
# すべてのチェック
make check

# または個別に
ruff check app/ && mypy app/ && black --check app/ && pytest --cov=app
```

---

## CI/CD 設定例（GitHub Actions）

```yaml
name: CI

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: '3.11'
      - run: pip install -e ".[dev]"
      - run: ruff check app/
      - run: mypy app/
      - run: black --check app/ tests/
      - run: pytest --cov=app --cov-report=xml
```

---

## 依存関係（dev）

```toml
[project.optional-dependencies]
dev = [
    "pytest>=7.0",
    "pytest-cov>=4.0",
    "pytest-mock>=3.0",
    "mypy>=1.0",
    "black>=23.0",
    "isort>=5.0",
    "ruff>=0.1",
    "factory-boy>=3.0",
]
```

---

*すべてのチェックを通過してからコミット*
