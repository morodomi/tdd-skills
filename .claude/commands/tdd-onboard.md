---
description: install.sh実行後の対話的セットアップ。プロジェクト分析 + CLAUDE.md生成 + 初期チケット発行
---

# TDD Onboard Command

既存プロジェクトに ClaudeSkills TDD 環境をセットアップします。

## 使用方法

```bash
/tdd-onboard
```

install.sh 実行後に実行してください。

---

## 実行フロー概要

```
Step 1: プロジェクト分析（フレームワーク/パッケージマネージャ/テストツール検出）
  ↓
Step 2: 検出結果確認（AskUserQuestion で対話的に確認）
  ↓
Step 3: docs/ 構造作成（docs/cycles/, docs/README.md）
  ↓
Step 4: CLAUDE.md 生成（短縮版テンプレート、約100行）
  ↓
Step 4.5: agent_docs/ 生成（Progressive Disclosure用詳細ドキュメント）
  ↓
Step 5: 初期チケット発行（project-setup Cycle doc）
  ↓
Step 6: Next Steps 表示
```

---

## Step 1: プロジェクト分析

### 1.1 フレームワーク検出

Glob ツールで以下のファイルを確認し、フレームワークを検出してください:

| 検出対象 | フレームワーク |
|---------|--------------|
| `artisan` | Laravel |
| `app.py` または `wsgi.py` | Flask |
| `manage.py` + django依存 | Django |
| `wp-config.php` | WordPress |
| 上記以外 | Generic |

**検出ロジック**:

```bash
# Laravel検出
Glob: artisan
→ 存在すれば Laravel

# Flask検出
Glob: app.py, wsgi.py
Grep: "flask" in pyproject.toml
→ いずれか該当すれば Flask

# Django検出
Glob: manage.py
Grep: "django" in requirements.txt or pyproject.toml
→ 両方該当すれば Django

# WordPress検出
Glob: wp-config.php
→ 存在すれば WordPress
```

### 1.2 パッケージマネージャ検出

| 検出対象 | パッケージマネージャ |
|---------|-------------------|
| `composer.json` | Composer (PHP) |
| `poetry.lock` | Poetry (Python) |
| `uv.lock` | uv (Python) |
| `pyproject.toml` のみ | ユーザー確認 |
| `package.json` | npm/yarn/pnpm |

### 1.3 テストツール検出

フレームワークに基づいてデフォルトを設定:

| フレームワーク | テストツール | カバレッジコマンド | 静的解析 | フォーマッター |
|--------------|-------------|------------------|---------|--------------|
| Laravel | PHPUnit/Pest | `php artisan test --coverage` | PHPStan | Pint |
| Flask | pytest | `pytest --cov=app --cov-report=term-missing` | mypy | black |
| Django | pytest | `pytest --cov` | mypy | black |
| WordPress | PHPUnit | `vendor/bin/phpunit --coverage-text` | PHPStan | WPCS |
| Generic | 検出/確認 | ユーザー指定 | 検出/確認 | 検出/確認 |

### 1.4 既存テスト構造確認

Glob ツールで既存のテスト構造を確認:

```bash
# PHP テスト
Glob: tests/**/*Test.php
Glob: tests/Unit/**/*.php
Glob: tests/Feature/**/*.php

# Python テスト
Glob: tests/**/*_test.py
Glob: tests/**/test_*.py
Glob: tests/unit/**/*.py
Glob: tests/integration/**/*.py
```

---

## Step 2: 検出結果確認

AskUserQuestion ツールで検出結果を確認してください。

### 確認項目

1. **フレームワーク**: 検出結果が正しいか
2. **パッケージマネージャ**: 検出結果が正しいか（poetry/uv の判断）
3. **既存 CLAUDE.md**: 上書き or マージの確認

**AskUserQuestion 例**:

```yaml
questions:
  - question: "検出したフレームワークは正しいですか？"
    header: "Framework"
    options:
      - label: "${DETECTED_FRAMEWORK}"
        description: "自動検出された結果を使用"
      - label: "Laravel"
        description: "PHP Laravel フレームワーク"
      - label: "Flask"
        description: "Python Flask フレームワーク"
      - label: "Django"
        description: "Python Django フレームワーク"
    multiSelect: false
```

---

## Step 3: docs/ 構造作成

### 3.1 ディレクトリ作成

Bash ツールで以下を実行:

```bash
mkdir -p docs/cycles
```

### 3.2 docs/README.md 作成

docs/README.md が存在しない場合、Write ツールで作成:

```markdown
# Documentation Index

## プロジェクト状況

現在の状況は [STATUS.md](STATUS.md) を参照。

## TDD サイクル

サイクルドキュメントは `docs/cycles/` に格納されています。

**命名規則**: `YYYYMMDD_HHMM_機能名.md`

## ドキュメント一覧

- 設計・調査は `docs/` 直下に格納
- TDD サイクルは `docs/cycles/` に格納
```

### 3.3 docs/STATUS.md 作成

docs/STATUS.md が存在しない場合、Write ツールで作成:

```markdown
# Project Status

最終更新: ${DATE}

## 進行中

なし

## バックログ

GitHub Issues を参照: `gh issue list`

## 最近完了

なし

---

*このファイルは tdd-commit で自動更新されます*
```

---

## Step 4: CLAUDE.md 生成（マージ機能付き）

### 4.1 既存 CLAUDE.md の確認

```bash
ls CLAUDE.md 2>/dev/null
```

**CLAUDE.md が存在しない場合** → 4.3 へ（新規作成）

**CLAUDE.md が存在する場合** → 4.2 へ（マージ処理）

---

### 4.2 マージ処理（既存CLAUDE.mdがある場合）

#### 4.2.1 バックアップ作成

```bash
cp CLAUDE.md CLAUDE.md.backup.$(date +%Y%m%d_%H%M%S)
```

#### 4.2.2 既存CLAUDE.mdのセクション解析

Read ツールで既存 CLAUDE.md を読み込み、以下のセクションを識別:

**標準セクション**（`##` で始まるHeading2）:
- Overview
- Tech Stack
- Quick Commands
- TDD Workflow
- Quality Standards
- Documentation
- Project Structure
- Available Commands

**カスタムセクション**: 上記以外のすべての `##` セクション

#### 4.2.3 マージ戦略

| セクション | 戦略 | 処理 |
|-----------|------|------|
| **Overview** | 既存を保持 | 既存内容をそのまま使用 |
| **Tech Stack** | 新規で上書き | 検出結果で置換 |
| **Quick Commands** | 新規で上書き | 検出結果で置換 |
| **TDD Workflow** | 新規で上書き | 最新テンプレート |
| **Quality Standards** | 新規で上書き | 最新テンプレート |
| **Documentation** | 新規で上書き | agent_docs/参照 |
| **Project Structure** | 既存を保持 | 既存内容をそのまま使用 |
| **Available Commands** | 新規で上書き | 最新テンプレート |
| **カスタムセクション** | 既存を保持 | ファイル末尾に追加 |

#### 4.2.4 差分表示

マージ結果をユーザーに表示:

```
================================================================================
CLAUDE.md マージプレビュー
================================================================================

【保持されるセクション】
- Overview: [既存の内容を表示]
- Project Structure: [既存の内容を表示]
- カスタムセクション: [セクション名一覧]

【更新されるセクション】
- Tech Stack: ${FRAMEWORK} 検出結果を反映
- Quick Commands: 検出コマンドを反映
- TDD Workflow: 最新テンプレート
- Quality Standards: 最新テンプレート
- Documentation: agent_docs/参照を追加
- Available Commands: 最新テンプレート

================================================================================
```

#### 4.2.5 ユーザー確認

AskUserQuestion で確認:

```yaml
questions:
  - question: "上記のマージ内容で CLAUDE.md を更新しますか？"
    header: "Merge"
    options:
      - label: "はい、マージする"
        description: "既存のOverview/Project Structure/カスタムセクションを保持"
      - label: "いいえ、全て新規作成"
        description: "既存内容を破棄し、テンプレートから新規作成"
      - label: "キャンセル"
        description: "CLAUDE.md を変更しない"
    multiSelect: false
```

**「はい、マージする」** → マージしたCLAUDE.mdを生成
**「いいえ、全て新規作成」** → 4.3 へ
**「キャンセル」** → Step 4.5 へスキップ

---

### 4.3 テンプレートから生成（短縮版、約100行）

検出結果に基づいて変数を置換し、CLAUDE.md を生成:

```markdown
# ${PROJECT_NAME}

## Overview

[プロジェクトの目的を2-3文で記述]

---

## Tech Stack

- **Language**: ${LANGUAGE}
- **Framework**: ${FRAMEWORK}
- **Test**: ${TEST_TOOL}
- **Static Analysis**: ${STATIC_ANALYSIS}
- **Formatter**: ${FORMATTER}

---

## Quick Commands

```bash
# テスト
${TEST_COMMAND}

# カバレッジ
${COVERAGE_COMMAND}

# 静的解析
${STATIC_ANALYSIS_COMMAND}

# フォーマット
${FORMATTER_COMMAND}
```

---

## TDD Workflow

すべての機能開発・バグ修正はTDDサイクルを通す。

```
INIT → PLAN → RED → GREEN → REFACTOR → REVIEW → COMMIT
```

**絶対ルール**: エラーを見つけたら、まずテストを書く

詳細: `agent_docs/tdd_workflow.md`

---

## Quality Standards

| 指標 | 目標 |
|------|------|
| カバレッジ | 90%以上（最低80%） |
| 静的解析 | エラー0件 |
| フォーマット | 規約準拠 |

詳細: `agent_docs/quality_standards.md`

---

## Documentation

| ファイル | 内容 |
|---------|------|
| `agent_docs/tdd_workflow.md` | TDDフェーズ詳細、バグ修正フロー |
| `agent_docs/testing_guide.md` | テストの書き方 |
| `agent_docs/quality_standards.md` | 品質基準、ツール設定 |
| `agent_docs/commands.md` | コマンド一覧 |

---

## Project Structure

```
${PROJECT_STRUCTURE}
```

---

## Available Commands

- `/tdd-onboard`: 初期セットアップ
- `/test-agent`: カバレッジ向上
- `/code-review`: コードレビュー

---

*Generated by /tdd-onboard*
```

---

## Step 4.5: agent_docs/ 生成

### 4.5.0 既存チェック

まず、agent_docs/ が既に存在するか確認:

```bash
ls agent_docs/*.md 2>/dev/null | head -5
```

**agent_docs/ が存在する場合**:
```
agent_docs/ は既にインストールされています。スキップします。
```
→ Step 5 へ進む

**agent_docs/ が存在しない場合**:
→ 以下の手順で生成

### 4.5.1 ディレクトリ作成

```bash
mkdir -p agent_docs
```

### 4.5.2 ファイル生成方法

agent_docs/ のファイルは、フレームワーク検出結果に基づいて Write ツールで直接生成します。

#### tdd_workflow.md（共通）

以下の内容で `agent_docs/tdd_workflow.md` を作成:

```markdown
# TDD Workflow Guide

## 7フェーズ概要

INIT → PLAN → RED → GREEN → REFACTOR → REVIEW → COMMIT

## 各フェーズの詳細

### INIT（初期化）
- TDDサイクルの開始宣言
- Cycle doc作成

### PLAN（計画）
- スコープ定義
- テストリスト作成

### RED（失敗するテスト）
- テストコード作成
- 失敗を確認

### GREEN（最小実装）
- テストを通す最小限のコード

### REFACTOR（リファクタリング）
- コード品質改善
- テスト維持

### REVIEW（品質検証）
- 品質チェック実行
- DISCOVERED管理

### COMMIT（コミット）
- Git commit
- ドキュメント更新

## 絶対ルール

「エラーを見つけたら、まずテストを書く」
```

#### testing_guide.md（フレームワーク固有）

検出したフレームワークに応じた内容で `agent_docs/testing_guide.md` を作成。

**Laravel の場合**: PHPUnit/Pest、#[Test]属性、Given/When/Then形式
**Bedrock/WordPress の場合**: PHPUnit、Brain Monkey、WordPress Test
**Generic の場合**: プロジェクト固有のテストフレームワーク

#### quality_standards.md（フレームワーク固有）

検出した品質ツールに応じた内容で `agent_docs/quality_standards.md` を作成。

| フレームワーク | カバレッジ目標 | 静的解析 | フォーマッター |
|--------------|--------------|---------|--------------|
| Laravel | 90% | PHPStan Level 8 | Pint |
| Bedrock | 90% | PHPStan Level 8 | PHPCS |
| Generic | 90% | 検出ツール | 検出ツール |

#### commands.md（フレームワーク固有）

検出したコマンドで `agent_docs/commands.md` を作成。

### 4.5.3 生成されるファイル

```
agent_docs/
├── tdd_workflow.md        # 共通：TDDフェーズ詳細
├── testing_guide.md       # 固有：テストの書き方
├── quality_standards.md   # 固有：品質基準
└── commands.md            # 固有：コマンド一覧
```

---

## Step 5: 初期チケット発行

Write ツールで `docs/cycles/${TIMESTAMP}_0000_project-setup.md` を作成:

```markdown
---
feature: setup
cycle: project-setup-001
phase: INIT
created: ${DATE}
updated: ${DATE}
---

# プロジェクト TDD セットアップ

## やりたいこと

プロジェクトの TDD 環境を確認し、品質基準を満たす状態を把握する。

---

## Scope Definition

### 確認項目

1. 既存テストが全て通過するか
2. 現在のカバレッジ率
3. 静的解析エラー数
4. コードフォーマット状態

---

## 実行コマンド

```bash
# テスト実行
${TEST_COMMAND}

# カバレッジ測定
${COVERAGE_COMMAND}

# 静的解析
${STATIC_ANALYSIS_COMMAND}

# フォーマットチェック
${FORMATTER_CHECK_COMMAND}
```

---

## Test List

### 実装予定（TODO）

- [ ] 既存テストが全て通過する
- [ ] 現在のカバレッジ率を記録: ___%
- [ ] 静的解析エラー数を記録: ___件
- [ ] コードフォーマット: OK / NG

### 完了（DONE）

（なし）

---

## Progress Log

### ${DATE} - INIT phase
- /tdd-onboard で自動生成
- 品質基準確認を開始
```

---

## Step 6: Next Steps 表示

セットアップ完了後、以下を表示:

```
==========================================
TDD 環境セットアップ完了
==========================================

検出結果:
  Framework: ${FRAMEWORK}
  Package Manager: ${PACKAGE_MANAGER}
  Test Tool: ${TEST_TOOL}

作成されたファイル:
  - CLAUDE.md（プロジェクト設定、約100行）
  - agent_docs/（Progressive Disclosure用詳細ドキュメント）
    - tdd_workflow.md
    - testing_guide.md
    - quality_standards.md
    - commands.md
  - docs/cycles/${TIMESTAMP}_0000_project-setup.md（初期チケット）
  - docs/README.md（ドキュメント索引）

次のステップ:

1. 初期チケットで品質状態を確認:
   cat docs/cycles/${TIMESTAMP}_0000_project-setup.md

2. テスト実行:
   ${TEST_COMMAND}

3. カバレッジ測定:
   ${COVERAGE_COMMAND}

4. 新機能開発時:
   "tdd-init 機能名" と入力

5. Skills の使い方:
   - ux-design: UX 設計時に使用
   - tdd-*: 各 TDD フェーズで自動適用

詳細は CLAUDE.md を参照してください。
==========================================
```

---

## 変数一覧

| 変数名 | 説明 | 例 |
|--------|------|-----|
| `${PROJECT_NAME}` | プロジェクト名（ディレクトリ名） | my-app |
| `${FRAMEWORK}` | フレームワーク | Laravel, Flask |
| `${PACKAGE_MANAGER}` | パッケージマネージャ | composer, poetry, uv |
| `${TEST_TOOL}` | テストツール | PHPUnit, pytest |
| `${TEST_COMMAND}` | テスト実行コマンド | php artisan test |
| `${COVERAGE_COMMAND}` | カバレッジ測定コマンド | php artisan test --coverage |
| `${STATIC_ANALYSIS}` | 静的解析ツール | PHPStan, mypy |
| `${STATIC_ANALYSIS_COMMAND}` | 静的解析コマンド | vendor/bin/phpstan analyse |
| `${FORMATTER}` | フォーマッター | Pint, black |
| `${FORMATTER_COMMAND}` | フォーマットコマンド | vendor/bin/pint |
| `${FORMATTER_CHECK_COMMAND}` | フォーマットチェック | vendor/bin/pint --test |
| `${TIMESTAMP}` | タイムスタンプ | 20251126_1540 |
| `${DATE}` | 日付 | 2025-11-26 |
| `${PROJECT_STRUCTURE}` | プロジェクト構造 | （自動検出） |

---

## エラーハンドリング

| 状況 | 対応 |
|------|------|
| フレームワーク検出失敗 | ユーザーに確認（AskUserQuestion） |
| 既存 CLAUDE.md あり | バックアップ + 上書き確認 |
| docs/ 既存 | マージ or 上書き確認 |
| poetry/uv 判別不可 | ユーザーに確認 |
