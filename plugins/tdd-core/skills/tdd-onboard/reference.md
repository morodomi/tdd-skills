# TDD Onboard Reference

## Step 1: プロジェクト分析

### 1.1 フレームワーク検出

| 検出対象 | フレームワーク |
|---------|--------------|
| `artisan` | Laravel |
| `app.py` または `wsgi.py` | Flask |
| `manage.py` + django依存 | Django |
| `wp-config.php` | WordPress |
| 上記以外 | Generic |

### 1.2 パッケージマネージャ検出

| 検出対象 | パッケージマネージャ |
|---------|-------------------|
| `composer.json` | Composer (PHP) |
| `poetry.lock` | Poetry (Python) |
| `uv.lock` | uv (Python) |
| `package.json` | npm/yarn/pnpm |

### 1.3 テストツール検出

| FW | Test | Coverage | Lint | Fmt |
|----|------|----------|------|-----|
| Laravel | PHPUnit/Pest | `php artisan test --coverage` | PHPStan | Pint |
| Flask | pytest | `pytest --cov` | mypy | black |
| Django | pytest | `pytest --cov` | mypy | black |
| WordPress | PHPUnit | `phpunit --coverage-text` | PHPStan | WPCS |

---

## Step 3: docs/ 構造

`docs/README.md` と `docs/STATUS.md` を作成。STATUS.md は tdd-commit で自動更新される。

---

## Step 4: CLAUDE.md 生成

### マージ戦略

| セクション | 戦略 |
|-----------|------|
| Overview | 既存を保持 |
| Tech Stack | 新規で上書き |
| Quick Commands | 新規で上書き |
| TDD Workflow | 新規で上書き |
| Quality Standards | 新規で上書き |
| Project Structure | 既存を保持 |
| カスタムセクション | 既存を保持 |

### CLAUDE.md 必須セクション

${PROJECT_NAME}, Overview, Tech Stack, Quick Commands (${TEST_COMMAND}, ${COVERAGE_COMMAND}), TDD Workflow, Quality Standards, Project Structure, 以下の AI Behavior Principles:

## AI Behavior Principles

### Role: PdM (Product Manager)

計画・調整・確認に徹し、実装は委譲。

### Mandatory: AskUserQuestion

曖昧な要件は全てヒアリング。

### Delegation Strategy

CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1 → Agent Teams、それ以外 → 並行Subagent。

### Delegation Rules

- 実装 → green-worker に委譲
- テスト → red-worker に委譲
- 設計 → architect に委譲
- レビュー → reviewer に委譲
- 曖昧 → AskUserQuestion で確認

---

## Step 5: 階層CLAUDE.md推奨

| 制約 | 基準 |
|------|------|
| 深さ制限 | 第1階層まで（tests/, src/, docs/） |
| サイズ制限 | 各30-50行以内 |
| 合計予算 | 全CLAUDE.md合計 500行以内目安 |

推奨: tests/CLAUDE.md, src/CLAUDE.md, docs/CLAUDE.md。サブディレクトリは非推奨。

---

## Step 6: .claude/ 構造

tdd-core の `.claude/` から Read してコピー: `.claude/rules/security.md`, `.claude/rules/git-safety.md`, `.claude/rules/git-conventions.md`, `.claude/hooks/recommended.md` (--no-verify + rm -rf ブロック)。

---

## Step 7: Pre-commit Hook確認

| ツール | パス |
|--------|------|
| husky | `.husky/pre-commit` |
| native | `.git/hooks/pre-commit` |
| pre-commit framework | `.pre-commit-config.yaml` |

hookなし → セットアップ推奨。

---

## Step 8: 初期Cycle doc

tdd-init スキルの [templates/cycle.md](../tdd-init/templates/cycle.md) をベースに `docs/cycles/YYYYMMDD_0000_project-setup.md` を作成。

---

## 変数一覧

| 変数名 | 例 |
|--------|-----|
| `${PROJECT_NAME}` | my-app |
| `${BACKEND_LANGUAGE}`, `${BACKEND_FRAMEWORK}`, `${BACKEND_PLUGIN}` | PHP, Laravel, tdd-php |
| `${FRONTEND_LANGUAGE}`, `${FRONTEND_FRAMEWORK}`, `${FRONTEND_PLUGIN}` | TypeScript, Vue, tdd-ts |
| `${TEST_TOOL}`, `${TEST_COMMAND}` | PHPUnit, `php artisan test` |
| `${COVERAGE_COMMAND}` | `php artisan test --coverage` |
| `${STATIC_ANALYSIS}`, `${FORMATTER}` | PHPStan, Pint |

---

## エラーハンドリング

| 状況 | 対応 |
|------|------|
| フレームワーク検出失敗 | AskUserQuestion で確認 |
| 既存 CLAUDE.md あり | バックアップ + マージ確認 |
| poetry/uv 判別不可 | ユーザーに確認 |
