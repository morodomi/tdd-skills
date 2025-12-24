# tdd-flask プラグイン

Issue: #14

## Status: DONE

## INIT

### Scope Definition

Flask固有のTDD品質チェックプラグインを作成。

### Target Structure

```
plugins/tdd-flask/
├── .claude-plugin/
│   └── plugin.json
├── skills/
│   └── flask-quality/
│       ├── SKILL.md
│       └── reference.md
└── README.md
```

### Tools

- **テスト**: pytest + pytest-flask
- **静的解析**: mypy
- **フォーマット**: Black, isort

### Dependencies

- tdd-core: TDDワークフロー（必須）
- tdd-python: 汎用Python品質チェック（参考）

### Out of Scope

- pytest-flask自動インストール
- Flask固有のテストヘルパー実装

### Environment

```
Python: 3.10+ (pytest requirement)
pytest: 7.0+
pytest-flask: 1.3.0+
Flask: 2.3+ (Flask 3.x 推奨)
mypy: latest
Black: latest
isort: latest
```

## PLAN

### 設計方針

1. **tdd-pythonベース**: 汎用Python品質チェックをベースに拡張
2. **Flask固有の追加**: pytest-flask、test_client、app_context
3. **最小限の差分**: 共通部分は重複させず、Flask固有のみ記載

### ファイル構成

| ファイル | 内容 |
|----------|------|
| `.claude-plugin/plugin.json` | プラグインメタデータ |
| `skills/flask-quality/SKILL.md` | Flask品質チェックスキル |
| `skills/flask-quality/reference.md` | 詳細リファレンス |
| `README.md` | プラグイン説明 |

### flask-quality SKILL.md 構成

```markdown
# Flask Quality Check

## Commands
- pytest (with pytest-flask)
- mypy --strict
- Black / isort

## Flask-specific Testing
- test_client fixture
- app_context fixture
- App Factory Pattern

## Usage Examples
- API endpoint testing
- Template rendering test
- Form validation test
```

### flask-quality reference.md 構成

```markdown
# Flask-specific Configuration

## pytest-flask Setup
- conftest.py with app fixture
- pytest.ini / pyproject.toml

## Flask 3.x Patterns
- App Factory Pattern (create_app)
- pytest-flask 1.3.0+ (request_ctx廃止)

## Testing Patterns
- GET/POST request testing
- Authentication testing
- Error handling testing

## Common Fixtures
- client, app, app_context

## Testing Security Patterns
- テスト用認証情報の管理
- .env.testing の使用
```

### テストスクリプト追加

`scripts/test-plugins-structure.sh` に以下を追加:
- TC-10: tdd-flask plugin.json exists and is valid
- TC-10b: tdd-flask has flask-quality skill

## Test List

### TODO

### WIP

### DONE
- [x] TC-01: plugin.json が存在し、有効なJSONである
- [x] TC-02: flask-quality/SKILL.md が存在する
- [x] TC-03: flask-quality/reference.md が存在する
- [x] TC-04: README.md が存在する
- [x] TC-05: SKILL.md に pytest-flask の記載がある
- [x] TC-06: SKILL.md に test_client の記載がある
- [x] TC-07: reference.md に conftest.py テンプレートがある
- [x] TC-08: reference.md に Flask 3.x 対応パターンがある
- [x] TC-09: README.md に Installation セクションがある

## Notes

- tdd-pythonとの差分: Flask固有のテストパターン（test_client, app_context等）
- pytest-flaskのfixture活用を推奨

### plan-review反映事項

- [Critical] Python 3.10+ を明記（pytest 7.0+ の要件）
- [Important] Flask 3.x / pytest-flask 1.3.0 対応パターンを追加
- [Important] Test List に README.md / Flask 3.x 検証を追加
- [Important] テストスクリプト番号を TC-10 に修正（TC-09は既存）
