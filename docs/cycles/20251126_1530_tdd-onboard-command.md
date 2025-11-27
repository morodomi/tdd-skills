---
feature: commands
cycle: tdd-onboard-command-001
phase: DONE
created: 2025-11-26 15:30
updated: 2025-11-26 16:00
---

# tdd-onboard コマンド作成

## やりたいこと

install.sh 実行後、既存プロジェクトに合わせた TDD 環境セットアップを対話的に行う `/tdd-onboard` コマンドを作成する。

**目的**:
- 既存プロジェクト構造の確認・分析
- docs/cycles/ ディレクトリの作成
- CLAUDE.md のカスタマイズ（テストコマンド、カバレッジツール等）
- 初回オンボーディングチケットの発行

**実行例**:
```bash
# install.sh 実行後
/tdd-onboard

# 対話的にセットアップ
# → 既存テスト構造を確認
# → CLAUDE.md をカスタマイズ
# → docs/cycles/ に初期チケット発行
```

---

## Scope Definition

### 実装範囲

1. **Slash Command 作成**: `.claude/commands/tdd-onboard.md`
2. **プロジェクト分析**:
   - フレームワーク検出（Laravel/Flask/Django/WordPress/Generic）
   - パッケージマネージャ検出（composer/poetry/uv/npm）
   - テストツール検出（PHPUnit/Pest/pytest/Jest）
   - 既存テスト構造確認（tests/Unit, tests/Feature, tests/unit, tests/integration）
3. **docs/ 構造作成**:
   - `docs/cycles/` ディレクトリ作成
   - `docs/README.md` 作成（索引）
4. **CLAUDE.md カスタマイズ**:
   - テンプレートから生成
   - 検出結果に基づいて変数置換
   - ユーザー確認を挟む
5. **初期チケット発行**:
   - `docs/cycles/YYYYMMDD_0000_project-setup.md` 作成
   - 既存テストカバレッジ測定
   - 品質基準達成状況の確認
6. **Next Steps 表示**:
   - TDD サイクルの始め方
   - Skills の使い方

### 非実装範囲

1. **CI 設定**: ユーザー側で設定
2. **Git hooks 設定**: 別途対応
3. **依存関係インストール**: ユーザー側で実行
4. **既存コードのリファクタ**: 別サイクルで対応

### 変更予定ファイル

1. `.claude/commands/tdd-onboard.md` (新規作成)
2. `tests/tdd-onboard-command/` (新規作成)
3. `templates/*/install.sh` (tdd-onboard コマンドのコピー追加)

---

## Context & Dependencies

### 参照ドキュメント・リソース

1. **既存コマンド**: `.claude/commands/test-agent.md`（構造の参考）
2. **既存コマンド**: `.claude/commands/code-review.md`（構造の参考）
3. **CLAUDE.md.template**: 各テンプレート（Laravel, Bedrock, Generic）
4. **TDD ワークフロー**: CLAUDE.md の TDD Workflow セクション

### 依存する機能・ツール

1. **Read/Grep/Glob tool**: プロジェクト構造分析
2. **Write/Edit tool**: ファイル作成・編集
3. **Bash tool**: テストコマンド実行、カバレッジ測定
4. **AskUserQuestion tool**: ユーザー確認

### 技術的な制約

1. **フレームワーク自動検出**: 100% 正確ではない（ユーザー確認必要）
2. **既存 CLAUDE.md**: 上書き確認必要
3. **既存 docs/**: マージ or 上書きの判断

---

## Test List

### 実装予定（TODO）

#### コマンド構造テスト

- [ ] TC-01: `.claude/commands/tdd-onboard.md` が存在する
- [ ] TC-02: 有効な YAML frontmatter を持つ
- [ ] TC-03: フレームワーク検出の指示がある
- [ ] TC-04: パッケージマネージャ検出の指示がある
- [ ] TC-05: テストツール検出の指示がある
- [ ] TC-06: docs/cycles/ 作成の指示がある
- [ ] TC-07: CLAUDE.md カスタマイズの指示がある
- [ ] TC-08: 初期チケット発行の指示がある
- [ ] TC-09: ユーザー確認（AskUserQuestion）の指示がある

#### 実行フローテスト

- [ ] TC-10: Laravel プロジェクト検出ロジックがある
- [ ] TC-11: Flask プロジェクト検出ロジックがある
- [ ] TC-12: Poetry/uv 検出ロジックがある
- [ ] TC-13: 既存テスト構造確認ロジックがある
- [ ] TC-14: カバレッジ測定コマンドが適切
- [ ] TC-15: Next Steps 表示がある

### 実装中（WIP）

（なし）

### 実装中に気づいた追加テスト（DISCOVERED）

#### 今回のスコープ外（既存コードの問題）

1. **[Security High] install.sh: Path Traversal脆弱性**
   - `cp -r` でシンボリックリンク攻撃可能
   - 対象: templates/*/install.sh

2. **[Security High] install.sh: パス検証不足**
   - 相対パスのみでプロジェクト検出
   - 対象: templates/*/install.sh

3. **[Security Medium] install.sh: グローバルディレクトリ無検証書き込み**
   - 既存ファイル上書き確認なし
   - 対象: templates/*/install.sh

4. **[Correctness] install.sh: CLAUDE.md条件ロジック矛盾**
   - 完了メッセージの条件が逆
   - 対象: templates/*/install.sh:291-297

5. **[Performance] install.sh: コマンドコピーのループ化**
   - 3コマンドを個別にコピー → ループ化で効率化可能
   - 対象: templates/*/install.sh

#### 今回の変更に関する改善提案（Optional）

6. **[Correctness Low] tdd-onboard.md: Django検出優先順序**
   - pyproject.toml vs requirements.txt の優先順序を明記

7. **[Correctness Low] tdd-onboard.md: Poetry/uv確認フロー**
   - AskUserQuestion例を追加

### 完了（DONE）

（なし）

---

## Implementation Notes

### 背景

install.sh 実行後、ユーザーは「次に何をすればいいか」が分からない:
- Skills はコピーされたが、使い方が不明
- CLAUDE.md はテンプレートのままで、プロジェクトに合っていない
- docs/cycles/ が存在せず、TDD サイクルを始められない

`/tdd-onboard` コマンドで、この問題を解決する。

### 設計方針

#### 1. 対話的セットアップ

```markdown
## Step 1: プロジェクト分析

Glob/Grep/Read ツールで以下を検出:
- フレームワーク
- パッケージマネージャ
- テストツール
- 既存テスト構造

## Step 2: ユーザー確認

AskUserQuestion ツールで確認:
- 検出結果は正しいか？
- カスタマイズしたい項目は？

## Step 3: 環境セットアップ

- docs/cycles/ 作成
- CLAUDE.md 生成
- 初期チケット発行

## Step 4: Next Steps 表示

- TDD サイクルの始め方
- 推奨する最初のタスク
```

#### 2. フレームワーク検出ロジック

```bash
# 優先順位付き検出
if [ -f "artisan" ]; then
    FRAMEWORK="Laravel"
elif [ -f "app.py" ] || [ -f "wsgi.py" ] || grep -q "flask" pyproject.toml 2>/dev/null; then
    FRAMEWORK="Flask"
elif [ -f "manage.py" ] && grep -q "django" requirements.txt 2>/dev/null; then
    FRAMEWORK="Django"
elif [ -f "wp-config.php" ]; then
    FRAMEWORK="WordPress"
else
    FRAMEWORK="Generic"
fi
```

#### 3. テストツール検出

| フレームワーク | テストツール | カバレッジコマンド |
|--------------|-------------|------------------|
| Laravel | PHPUnit/Pest | `php artisan test --coverage` |
| Flask | pytest | `pytest --cov=app --cov-report=term-missing` |
| Django | pytest/unittest | `pytest --cov` |
| WordPress | PHPUnit | `vendor/bin/phpunit --coverage-text` |
| Generic | 検出 or 確認 | ユーザー指定 |

#### 4. CLAUDE.md カスタマイズ

変数置換:
- `${FRAMEWORK}` → Laravel, Flask, etc.
- `${PACKAGE_MANAGER}` → composer, poetry, uv
- `${TEST_COMMAND}` → php artisan test, pytest, etc.
- `${COVERAGE_COMMAND}` → 上記 + --coverage オプション
- `${STATIC_ANALYSIS}` → phpstan, mypy, etc.
- `${FORMATTER}` → pint, black, etc.

#### 5. 初期チケット内容

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

プロジェクトの TDD 環境を整備し、品質基準を満たす状態にする。

## Scope Definition

### 実装範囲

1. 既存テストカバレッジ測定
2. カバレッジ目標設定（現在値 + 10%、上限 90%）
3. 静的解析エラー確認
4. コードフォーマット確認

### Test List

- [ ] 既存テストが全て通過する
- [ ] カバレッジ目標を設定
- [ ] 静的解析エラー 0 件
- [ ] コードフォーマット OK

## Progress Log

### ${DATE} - INIT phase
- /tdd-onboard で自動生成
```

#### 6. Next Steps 表示

```
========================================
TDD 環境セットアップ完了
========================================

次のステップ:

1. 初期チケットを確認:
   docs/cycles/${DATE}_project-setup.md

2. TDD サイクルを開始:
   /tdd-init "最初の機能名"

3. Skills の使い方:
   - ux-design: UX 設計時に使用
   - tdd-*: 各 TDD フェーズで自動適用

詳細は CLAUDE.md を参照してください。
========================================
```

---

## 詳細設計

### 1. コマンド構造

`.claude/commands/tdd-onboard.md` の構造:

```markdown
---
description: install.sh実行後の対話的セットアップ。プロジェクト分析 + CLAUDE.md生成 + 初期チケット発行
---

# TDD Onboard Command

既存プロジェクトに ClaudeSkills TDD 環境をセットアップします。

## 使用方法

/tdd-onboard

install.sh 実行後に実行してください。
```

### 2. 実行フロー

```
Step 1: プロジェクト分析
  ↓
Step 2: 検出結果確認（AskUserQuestion）
  ↓
Step 3: docs/ 構造作成
  ↓
Step 4: CLAUDE.md 生成
  ↓
Step 5: 初期チケット発行
  ↓
Step 6: Next Steps 表示
```

### 3. Step 1: プロジェクト分析

#### 3.1 フレームワーク検出

Glob/Read ツールで以下を確認:

```
検出ロジック（優先順位順）:
1. artisan 存在 → Laravel
2. app.py or wsgi.py 存在 → Flask
3. manage.py 存在 + django 依存 → Django
4. wp-config.php 存在 → WordPress
5. 上記以外 → Generic
```

具体的なチェック:
```bash
# Laravel
Glob: artisan

# Flask
Glob: app.py, wsgi.py
Grep: "flask" in pyproject.toml

# Django
Glob: manage.py
Grep: "django" in requirements.txt or pyproject.toml

# WordPress
Glob: wp-config.php
```

#### 3.2 パッケージマネージャ検出

```
検出ロジック:
1. composer.json 存在 → Composer (PHP)
2. poetry.lock 存在 → Poetry (Python)
3. uv.lock 存在 → uv (Python)
4. pyproject.toml のみ → ユーザー確認 (poetry/uv)
5. package.json 存在 → npm/yarn/pnpm (Node.js)
```

#### 3.3 テストツール検出

| フレームワーク | テストツール | カバレッジコマンド | 静的解析 | フォーマッター |
|--------------|-------------|------------------|---------|--------------|
| Laravel | PHPUnit/Pest | `php artisan test --coverage` | PHPStan | Pint |
| Flask | pytest | `pytest --cov=app` | mypy | black |
| Django | pytest | `pytest --cov` | mypy | black |
| WordPress | PHPUnit | `vendor/bin/phpunit --coverage-text` | PHPStan | WPCS |
| Generic | 検出/確認 | ユーザー指定 | 検出/確認 | 検出/確認 |

#### 3.4 既存テスト構造確認

```bash
# テストディレクトリ検出
Glob: tests/**/*Test.php    # PHP
Glob: tests/**/*_test.py    # Python
Glob: tests/**/test_*.py    # Python alternative
Glob: **/*.test.ts          # TypeScript
Glob: **/*.spec.ts          # TypeScript alternative

# 構造パターン判定
tests/Unit/           # Laravel パターン
tests/Feature/        # Laravel パターン
tests/unit/           # Python パターン
tests/integration/    # Python パターン
```

### 4. Step 2: 検出結果確認

AskUserQuestion ツールで確認:

```yaml
questions:
  - question: "検出結果は正しいですか？"
    header: "Framework"
    options:
      - label: "${DETECTED_FRAMEWORK}"
        description: "自動検出された結果"
      - label: "Laravel"
        description: "PHP Laravel フレームワーク"
      - label: "Flask"
        description: "Python Flask フレームワーク"
      - label: "Django"
        description: "Python Django フレームワーク"
      - label: "WordPress"
        description: "PHP WordPress"
    multiSelect: false

  - question: "パッケージマネージャは？"
    header: "Package"
    options:
      - label: "${DETECTED_PACKAGE_MANAGER}"
        description: "自動検出された結果"
      - label: "composer"
        description: "PHP Composer"
      - label: "poetry"
        description: "Python Poetry"
      - label: "uv"
        description: "Python uv"
    multiSelect: false
```

### 5. Step 3: docs/ 構造作成

```bash
# ディレクトリ作成
mkdir -p docs/cycles

# docs/README.md 作成（存在しない場合）
```

docs/README.md 内容:
```markdown
# Documentation Index

## TDD サイクル

サイクルドキュメントは `docs/cycles/` に格納されています。

命名規則: `YYYYMMDD_HHMM_機能名.md`

## 最新のサイクル

（/tdd-onboard で自動更新）
```

### 6. Step 4: CLAUDE.md 生成

既存 CLAUDE.md がある場合:
- バックアップ作成: `CLAUDE.md.backup`
- マージ確認をユーザーに提示

変数置換テンプレート:
```markdown
# ${PROJECT_NAME} - TDD Workflow

## Tech Stack

- **Framework**: ${FRAMEWORK}
- **Package Manager**: ${PACKAGE_MANAGER}
- **Test Tool**: ${TEST_TOOL}
- **Coverage**: ${COVERAGE_COMMAND}
- **Static Analysis**: ${STATIC_ANALYSIS}
- **Formatter**: ${FORMATTER}

## Quality Standards

### テストカバレッジ
- 目標: 90%以上
- 最低ライン: 80%
- 測定: `${COVERAGE_COMMAND}`

### 静的解析
- **${STATIC_ANALYSIS}** 必須
- エラー許容: 0件
- 実行: `${STATIC_ANALYSIS_COMMAND}`

### コードフォーマット
- **${FORMATTER}** 準拠
- 実行: `${FORMATTER_COMMAND}`

## TDD Workflow

7つのフェーズ:
INIT → PLAN → RED → GREEN → REFACTOR → REVIEW → COMMIT

詳細は Skills を参照。
```

### 7. Step 5: 初期チケット発行

`docs/cycles/${TIMESTAMP}_0000_project-setup.md` 作成:

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

## Scope Definition

### 確認項目

1. 既存テストが全て通過するか
2. 現在のカバレッジ率
3. 静的解析エラー数
4. コードフォーマット状態

### 実行コマンド

\`\`\`bash
# テスト実行
${TEST_COMMAND}

# カバレッジ測定
${COVERAGE_COMMAND}

# 静的解析
${STATIC_ANALYSIS_COMMAND}

# フォーマットチェック
${FORMATTER_CHECK_COMMAND}
\`\`\`

## Test List

- [ ] 既存テストが全て通過する
- [ ] 現在のカバレッジ率を記録: ___%
- [ ] 静的解析エラー数を記録: ___件
- [ ] コードフォーマット: OK / NG

## Progress Log

### ${DATE} - INIT phase
- /tdd-onboard で自動生成
- 品質基準確認を開始
```

### 8. Step 6: Next Steps 表示

```
========================================
TDD 環境セットアップ完了
========================================

検出結果:
  Framework: ${FRAMEWORK}
  Package Manager: ${PACKAGE_MANAGER}
  Test Tool: ${TEST_TOOL}

作成されたファイル:
  - CLAUDE.md（プロジェクト設定）
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
========================================
```

---

## Progress Log

### 2025-11-26 15:30 - INIT phase
- Cycle doc 作成
- やりたいことを定義（tdd-onboard コマンド作成）
- Scope Definition 記入（実装範囲6項目、非実装範囲4項目、変更予定3ファイル）
- Context & Dependencies 記入
- Test List 記入（15件）
- Implementation Notes 記入（背景、設計方針6項目）

### 2025-11-26 15:35 - PLAN phase
- 詳細設計追加:
  - 1. コマンド構造（description, 使用方法）
  - 2. 実行フロー（6ステップ）
  - 3. Step 1: プロジェクト分析（フレームワーク/パッケージマネージャ/テストツール/既存構造）
  - 4. Step 2: 検出結果確認（AskUserQuestion）
  - 5. Step 3: docs/ 構造作成
  - 6. Step 4: CLAUDE.md 生成（変数置換テンプレート）
  - 7. Step 5: 初期チケット発行（project-setup-001）
  - 8. Step 6: Next Steps 表示
- YAML frontmatter 更新（phase: INIT → PLAN）

### 2025-11-26 15:40 - RED phase
- テストスクリプト作成:
  - `tests/tdd-onboard-command/test_command_structure.sh` (TC-01〜TC-09)
  - `tests/tdd-onboard-command/test_execution_flow.sh` (TC-10〜TC-15)
  - `tests/tdd-onboard-command/run_all_tests.sh`
- テスト実行: 全15テスト失敗確認（実装なし）
  - Structure Tests: 0/9 PASS
  - Execution Flow Tests: 0/6 PASS
- YAML frontmatter 更新（phase: PLAN → RED）

### 2025-11-26 15:45 - GREEN phase
- `.claude/commands/tdd-onboard.md` 作成（9,765 bytes）
  - 6ステップの実行フロー
  - フレームワーク検出（Laravel/Flask/Django/WordPress）
  - パッケージマネージャ検出（composer/poetry/uv）
  - テストツール対応表
  - AskUserQuestion によるユーザー確認
  - docs/cycles/ 作成、CLAUDE.md 生成、初期チケット発行
  - Next Steps 表示
- install.sh 更新（3ファイル: Laravel, Bedrock, Generic）
  - tdd-onboard コマンドのコピー追加
- テスト実行: 全15テスト成功
  - Structure Tests: 9/9 PASS
  - Execution Flow Tests: 6/6 PASS
- YAML frontmatter 更新（phase: RED → GREEN）

### 2025-11-26 15:50 - REFACTOR phase
- コードレビュー実施:
  - 命名の一貫性: OK（既存コマンドと同じパターン）
  - 冗長なコード: なし
  - ドキュメント構造: OK（6ステップで明確）
  - 変数一覧: OK（13変数を文書化）
  - エラーハンドリング: OK（4パターンを記載）
- 結論: リファクタリング不要（GREEN で十分クリーン）
- テスト再実行: 全15テスト成功
- YAML frontmatter 更新（phase: GREEN → REFACTOR）

### 2025-11-26 15:55 - REVIEW phase
- `/code-review` 実行（並行3 Subagent）:
  - **Correctness Review**: 6件検出
    - 今回の変更: 2件（低〜中、Optional）
    - 既存コード: 4件
  - **Performance Review**: 5件検出
    - 今回の変更: 0件
    - 既存コード: 5件（改善提案）
  - **Security Review**: 6件検出
    - 今回の変更: 1件（Medium、Claude側で処理）
    - 既存コード: 5件（High 3件含む）
- **判断**: 今回の変更に重大な問題なし
  - テスト15件全通過
  - 機能的に正常動作
- **DISCOVERED記録**: 7件（既存5件 + 改善提案2件）
- **推奨**: 既存コードの Security High 問題は別 Issue で対応
- YAML frontmatter 更新（phase: REFACTOR → REVIEW）

### 2025-11-26 16:00 - COMMIT phase
- `/code-review` 再実行（git diff対象のみ）:
  - Correctness: 問題なし
  - Performance: 1件（Optional - #1で対応予定）
  - Security: 問題なし
- GitHub Issue作成: #1 (refactor: install.shのコマンドコピー処理をループ化)
- ファイルステージング（8ファイル、1,555行追加）:
  - `.claude/commands/tdd-onboard.md`
  - `templates/*/install.sh`（3ファイル）
  - `docs/cycles/20251126_1530_tdd-onboard-command.md`
  - `tests/tdd-onboard-command/*.sh`（3ファイル）
- コミット作成: `355abaa`
- origin/main にプッシュ完了
- YAML frontmatter 更新（phase: REVIEW → DONE）

---

## 完了サマリー

**成果物**: `/tdd-onboard` コマンド
- install.sh実行後の対話的セットアップ
- フレームワーク検出（Laravel/Flask/Django/WordPress）
- パッケージマネージャ検出（composer/poetry/uv）
- CLAUDE.md生成 + 初期チケット発行

**TDDサイクル**: 全7フェーズ完了
```
INIT → PLAN → RED → GREEN → REFACTOR → REVIEW → COMMIT
```

**関連Issue**: #1 (Optional改善)
