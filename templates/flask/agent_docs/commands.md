# Flask Commands

## テスト

```bash
# すべてのテスト実行
pytest

# 詳細出力
pytest -v

# 特定のディレクトリ
pytest tests/unit/
pytest tests/integration/

# 特定のファイル
pytest tests/unit/test_user_service.py

# 特定のテスト関数
pytest -k test_user_can_login

# マーカーでフィルタ
pytest -m "not slow"
pytest -m integration

# 失敗時に停止
pytest -x

# 最後に失敗したテストのみ
pytest --lf

# 並列実行（pytest-xdist）
pytest -n auto
```

## カバレッジ

```bash
# ターミナル表示
pytest --cov=app --cov-report=term-missing

# HTML レポート
pytest --cov=app --cov-report=html
open htmlcov/index.html

# XML レポート（CI用）
pytest --cov=app --cov-report=xml

# 最低カバレッジを強制
pytest --cov=app --cov-fail-under=80
```

## 静的解析

```bash
# mypy 実行
mypy app/

# strict モード
mypy app/ --strict

# 設定ファイル指定
mypy app/ --config-file pyproject.toml

# キャッシュクリア
mypy app/ --no-incremental
```

## フォーマット

```bash
# black（自動修正）
black app/ tests/

# チェックのみ
black --check app/ tests/

# 差分表示
black --diff app/ tests/

# isort（インポート整理）
isort app/ tests/

# チェックのみ
isort --check-only app/ tests/
```

## リンター

```bash
# ruff チェック
ruff check app/

# 自動修正
ruff check app/ --fix

# 詳細表示
ruff check app/ --show-fixes

# ruff フォーマット
ruff format app/
```

## Flask CLI

```bash
# 開発サーバー起動
flask run

# デバッグモード
flask run --debug

# ポート指定
flask run --port 5001

# シェル
flask shell

# ルート一覧
flask routes
```

## データベース（Flask-Migrate）

```bash
# マイグレーション初期化
flask db init

# マイグレーション作成
flask db migrate -m "Add users table"

# マイグレーション適用
flask db upgrade

# ロールバック
flask db downgrade

# 現在のバージョン
flask db current
```

## 依存関係

```bash
# pip
pip install -r requirements.txt
pip install -e ".[dev]"

# Poetry
poetry install
poetry add flask
poetry add --group dev pytest

# uv（高速）
uv pip install -r requirements.txt
uv pip install -e ".[dev]"
```

## 一括品質チェック

```bash
# すべてのチェックを実行
ruff check app/ && \
mypy app/ && \
black --check app/ tests/ && \
isort --check-only app/ tests/ && \
pytest --cov=app --cov-fail-under=80

# Makefile使用（推奨）
make check
```

## 環境変数

```bash
# .env ファイルから読み込み
export FLASK_APP=app
export FLASK_ENV=development
export DATABASE_URL=sqlite:///dev.db

# python-dotenv 使用時は自動読み込み
```

## Docker

```bash
# ビルド
docker build -t flask-app .

# 実行
docker run -p 5000:5000 flask-app

# docker-compose
docker-compose up -d
docker-compose exec web pytest
```

---

*よく使うコマンドは Makefile にまとめることを推奨*
