---
feature: framework-templates
cycle: flask-template-001
phase: GREEN
created: 2025-12-03 13:37
updated: 2025-12-03 14:05
---

# Flask用テンプレート作成

## やりたいこと

Flask/Python プロジェクト用の ClaudeSkills TDD テンプレートを作成する。

**背景**:
- 現在、Laravel/Bedrock/Generic テンプレートのみ存在
- Python/Flask プロジェクトにも TDD 環境を導入したい
- pytest, mypy, black 等の Python ツールチェーンに対応

---

## Scope Definition

### 今回実装する範囲

- [x] `templates/flask/` ディレクトリ作成
- [x] `templates/flask/install.sh` 作成
- [x] `templates/flask/CLAUDE.md.template` 作成
- [x] `templates/flask/agent_docs/` 作成
  - [x] testing_guide.md（pytest）
  - [x] quality_standards.md（mypy, black）
  - [x] commands.md
- [x] `templates/flask/.claude/skills/` 作成（TDD各フェーズ）

### 今回実装しない範囲

- Django テンプレート（別サイクル）
- FastAPI テンプレート（別サイクル）

### 変更予定ファイル

```
templates/flask/
├── install.sh
├── CLAUDE.md.template
├── agent_docs/
│   ├── testing_guide.md
│   ├── quality_standards.md
│   └── commands.md
└── .claude/skills/
    ├── tdd-init/SKILL.md
    ├── tdd-plan/SKILL.md
    ├── tdd-red/SKILL.md
    ├── tdd-green/SKILL.md
    ├── tdd-refactor/SKILL.md
    ├── tdd-review/SKILL.md
    ├── tdd-commit/SKILL.md
    └── ux-design/SKILL.md
```

計: 約15ファイル

---

## Context & Dependencies

### 参照テンプレート

- `templates/laravel/` - PHP用テンプレートの構造参考
- `templates/generic/` - 汎用テンプレートの構造参考
- `templates/_common/agent_docs/tdd_workflow.md` - 共通TDDワークフロー

### Flask/Python ツールチェーン

| カテゴリ | ツール | コマンド |
|---------|--------|---------|
| テスト | pytest | `pytest` |
| カバレッジ | pytest-cov | `pytest --cov=app --cov-report=term-missing` |
| 静的解析 | mypy | `mypy app/` |
| フォーマット | black | `black app/` |
| インポート整理 | isort | `isort app/` |
| リンター | ruff | `ruff check app/` |

### プロジェクト検出条件

Flask プロジェクトの識別:
- `app.py` または `wsgi.py` の存在
- `pyproject.toml` または `requirements.txt` に `flask` が含まれる

---

## Test List

### 実装予定（TODO）

（なし）

### 実装中（WIP）

（なし）

### 実装中に気づいた追加テスト（DISCOVERED）

- [ ] DISC-01: tdd-green, tdd-refactor, tdd-commit も Flask/pytest 固有にカスタマイズ → Issue #2
- [ ] DISC-02: tdd_workflow.md を agent_docs/ に含める（共通ファイル参照が必要） → Issue #3

### 完了（DONE）

- [x] TC-01: templates/flask/ ディレクトリが存在する
- [x] TC-02: install.sh が Flask プロジェクトを検出できる
- [x] TC-03: install.sh が pytest/mypy/black コマンドを表示する
- [x] TC-04: CLAUDE.md.template が100行以下である（110行）
- [x] TC-05: agent_docs/ に3ファイルが存在する
- [x] TC-06: .claude/skills/ に全TDDフェーズが存在する
- [x] TC-07: tdd-init SKILL.md が Flask 固有のチェックを含む

---

## Implementation Notes

### Flask プロジェクト構造（想定）

```
flask-project/
├── app/
│   ├── __init__.py
│   ├── routes.py
│   └── models.py
├── tests/
│   ├── conftest.py
│   ├── unit/
│   └── integration/
├── pyproject.toml
├── requirements.txt
└── app.py
```

### 品質基準（Flask用）

| 指標 | 目標 |
|------|------|
| カバレッジ | 90%以上（最低80%） |
| mypy | strict mode、エラー0件 |
| black | フォーマット準拠 |
| ruff | エラー0件 |

---

## PLAN: 詳細設計

### 1. install.sh

**検出ロジック**:
```bash
# Flask検出
if [ -f "app.py" ] || [ -f "wsgi.py" ]; then
    # pyproject.toml or requirements.txt に flask が含まれるか
    grep -q "flask" pyproject.toml 2>/dev/null || grep -q "flask" requirements.txt 2>/dev/null
fi
```

**パッケージマネージャ検出**:
| ファイル | マネージャ |
|---------|----------|
| poetry.lock | Poetry |
| uv.lock | uv |
| requirements.txt のみ | pip |
| pyproject.toml のみ | ユーザー確認 |

**コピー対象**:
- .claude/skills/ (TDD各フェーズ)
- agent_docs/ (共通 + Flask固有)
- CLAUDE.md.template → CLAUDE.md

### 2. CLAUDE.md.template（約100行）

```markdown
# ${PROJECT_NAME}

## Overview
[プロジェクトの目的]

## Tech Stack
- Language: Python 3.11+
- Framework: Flask
- Test: pytest
- Static Analysis: mypy (strict)
- Formatter: black + isort
- Linter: ruff

## Quick Commands
pytest
pytest --cov=app --cov-report=term-missing
mypy app/
black app/ tests/
ruff check app/

## TDD Workflow
INIT → PLAN → RED → GREEN → REFACTOR → REVIEW → COMMIT
詳細: agent_docs/tdd_workflow.md

## Documentation
- agent_docs/tdd_workflow.md
- agent_docs/testing_guide.md
- agent_docs/quality_standards.md
- agent_docs/commands.md
```

### 3. agent_docs/testing_guide.md

**内容**:
- pytest 基本構造
- conftest.py（fixtures）
- Given/When/Then形式
- Flask test client
- モック（pytest-mock）

**例**:
```python
import pytest
from app import create_app

@pytest.fixture
def client():
    app = create_app()
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client

def test_user_can_login(client):
    # Given: 有効なユーザーが存在
    # When: ログインエンドポイントにPOST
    response = client.post('/login', json={
        'email': 'test@example.com',
        'password': 'password'
    })
    # Then: 200が返る
    assert response.status_code == 200
```

### 4. agent_docs/quality_standards.md

| ツール | 設定 | コマンド |
|-------|------|---------|
| pytest | pytest.ini or pyproject.toml | pytest |
| pytest-cov | --cov=app | pytest --cov=app |
| mypy | strict mode | mypy app/ |
| black | line-length=88 | black app/ |
| isort | profile=black | isort app/ |
| ruff | select=E,F,W | ruff check app/ |

### 5. agent_docs/commands.md

```bash
# テスト
pytest
pytest tests/unit/
pytest -k test_login

# カバレッジ
pytest --cov=app --cov-report=term-missing
pytest --cov=app --cov-report=html

# 静的解析
mypy app/
mypy app/ --strict

# フォーマット
black app/ tests/
isort app/ tests/

# リント
ruff check app/
ruff check app/ --fix
```

### 6. .claude/skills/ 変更点

**tdd-init**: Flask プロジェクト検出
```bash
# app.py または wsgi.py の存在確認
# flask in pyproject.toml/requirements.txt
```

**tdd-red**: pytest形式
- `def test_xxx():` 形式
- Given/When/Then コメント
- fixtures 使用

**tdd-review**: Python品質ツール
```bash
pytest --cov=app
mypy app/
black --check app/
ruff check app/
```

### 7. 実装順序

1. ディレクトリ構造作成
2. agent_docs/ 作成（testing_guide, quality_standards, commands）
3. CLAUDE.md.template 作成
4. .claude/skills/ をgenericからコピー＆Flask対応に修正
5. install.sh 作成
6. 動作確認

---

## Progress Log

### 2025-12-03 13:37 - INIT phase
- TDDサイクルドキュメント作成
- スコープ定義完了
- テストリスト作成

### 2025-12-03 13:40 - PLAN phase
- 既存テンプレート（Laravel/Generic）を分析
- 詳細設計完了
  - install.sh 検出ロジック
  - CLAUDE.md.template 構造
  - agent_docs/ 内容設計
  - Skills 変更点特定
- 実装順序決定

### 2025-12-03 14:05 - GREEN phase
- templates/flask/ ディレクトリ構造作成
- agent_docs/ 作成完了
  - testing_guide.md（pytest基本、fixtures、Flask test client）
  - quality_standards.md（mypy --strict、black、isort、ruff）
  - commands.md（pytest、カバレッジ、静的解析コマンド）
- CLAUDE.md.template 作成（約110行）
- .claude/skills/ をgenericからコピー＆Flask対応に修正
  - tdd-init: Flask検出ロジック追加
  - tdd-red: pytest形式に変更
  - tdd-review: Python品質ツール（mypy、black、ruff）に変更
- install.sh 作成＆実行権限付与
- DISCOVERED追加: 他Skillsの Flask対応、tdd_workflow.md共通ファイル参照

---

## 次のステップ

1. [完了] INIT（初期化）
2. [完了] PLAN（計画）
3. [スキップ] RED（テスト作成）- テンプレート作成のため
4. [完了] GREEN（実装）← 現在ここ
5. [ ] REFACTOR（リファクタリング）
6. [ ] REVIEW（品質検証）
7. [ ] COMMIT（コミット）

---

*作成日時: 2025-12-03 13:37*
*次のフェーズ: PLAN*
