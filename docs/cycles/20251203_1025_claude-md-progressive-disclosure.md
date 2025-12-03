---
feature: claude-md-improvement
cycle: progressive-disclosure-001
phase: DONE
created: 2025-12-03 10:25
updated: 2025-12-03 11:30
---

# CLAUDE.md Progressive Disclosure リファクタリング

## やりたいこと

CLAUDE.mdを短縮化し、詳細情報をagent_docs/に分離するProgressive Disclosure方式を導入する。

**背景**:
- 現在のCLAUDE.mdテンプレートは300行を大幅に超過（822行等）
- 記事「Writing a good CLAUDE.md」によると、300行未満が推奨
- 長すぎるとClaudeの命令追従率が低下する

**目標**:
- CLAUDE.md: 100行以下（WHY/WHAT/HOWのコア情報のみ）
- agent_docs/: 詳細情報を格納（必要時に参照）

---

## Scope Definition

### 対象ファイル

**作成するファイル**:
1. `templates/_common/agent_docs/tdd_workflow.md` - 共通TDDワークフロー
2. `templates/generic/agent_docs/testing_guide.md.template` - テストガイド（変数テンプレート）
3. `templates/generic/agent_docs/quality_standards.md.template` - 品質基準
4. `templates/generic/agent_docs/commands.md.template` - コマンド一覧
5. `templates/laravel/agent_docs/` - Laravel固有ファイル
6. `templates/bedrock/agent_docs/` - Bedrock固有ファイル

**更新するファイル**:
1. `templates/generic/CLAUDE.md.example` - 短縮版に書き換え
2. `templates/laravel/CLAUDE.md.template` - 短縮版に書き換え
3. `templates/bedrock/CLAUDE.md.example` - 短縮版に書き換え
4. `CLAUDE.md` - このプロジェクト自体も短縮
5. `.claude/commands/tdd-onboard.md` - agent_docs生成ステップ追加

### スコープ外

- install.shの変更（別サイクルで対応）
- Skills内容の変更（別サイクルで対応）

---

## Context & Dependencies

### 参照資料

- 記事: https://www.humanlayer.dev/blog/writing-a-good-claude-md
- 既存テンプレート: `templates/*/CLAUDE.md*`
- tdd-onboardコマンド: `.claude/commands/tdd-onboard.md`

### ディレクトリ構造（変更後）

```
templates/
├── _common/
│   └── agent_docs/
│       └── tdd_workflow.md           # 共通（全フレームワーク）
├── generic/
│   ├── CLAUDE.md.example             # 短縮版（100行以下）
│   └── agent_docs/
│       ├── testing_guide.md.template
│       ├── quality_standards.md.template
│       └── commands.md.template
├── laravel/
│   ├── CLAUDE.md.template            # 短縮版
│   └── agent_docs/
│       ├── testing_guide.md
│       ├── quality_standards.md
│       └── commands.md
└── bedrock/
    ├── CLAUDE.md.example             # 短縮版
    └── agent_docs/
        ├── testing_guide.md
        ├── quality_standards.md
        └── commands.md
```

---

## Test List

### 実装予定（TODO）

（なし）

### 実装中（WIP）

（なし）

### 実装中に気づいた追加テスト（DISCOVERED）

- [ ] TC-09: install.sh がagent_docs/をコピーする
- [ ] TC-10: tdd-init SKILL.md がagent_docs/への参照を含む

### 完了（DONE）

- [x] TC-01: _common/agent_docs/tdd_workflow.md が存在し、7フェーズが記載されている
- [x] TC-02: generic/agent_docs/*.md.template が変数プレースホルダーを含む
- [x] TC-03: laravel/agent_docs/*.md がLaravel固有コマンドを含む
- [x] TC-04: bedrock/agent_docs/*.md がWordPress固有コマンドを含む
- [x] TC-05: 各CLAUDE.mdが100行以下である
- [x] TC-06: 各CLAUDE.mdがagent_docs/へのポインタを含む
- [x] TC-07: tdd-onboardがagent_docs生成ステップを含む
- [x] TC-08: このプロジェクトのCLAUDE.mdが300行以下である
- [x] TC-09: install.sh がagent_docs/をコピーする（追加対応）
- [x] TC-10: tdd-init SKILL.md がagent_docs/への参照を含む（追加対応）

---

## Implementation Notes

### Phase 1: 共通ファイル作成

1. `templates/_common/` ディレクトリ作成
2. `tdd_workflow.md` 作成（現在のテンプレートからTDD関連を抽出）

### Phase 2: フレームワーク固有ファイル作成

1. Laravel用 agent_docs/ 作成
2. Bedrock用 agent_docs/ 作成
3. Generic用テンプレート作成

### Phase 3: CLAUDE.md短縮化

1. 各テンプレートのCLAUDE.mdを100行以下に短縮
2. agent_docs/へのポインタを追加

### Phase 4: tdd-onboard更新

1. Step 4.5: agent_docs生成を追加

### Phase 5: このプロジェクトのCLAUDE.md更新

1. 300行以下に短縮
2. Progressive Disclosure適用

---

## PLAN: 詳細設計

### 1. _common/agent_docs/tdd_workflow.md（約150行）

```markdown
# TDD Workflow Guide

## 7フェーズ概要
INIT → PLAN → RED → GREEN → REFACTOR → REVIEW → COMMIT

## 各フェーズの詳細
### INIT - 初期化
### PLAN - 計画
### RED - 失敗するテスト
### GREEN - 最小実装
### REFACTOR - リファクタリング
### REVIEW - 品質検証
### COMMIT - コミット

## バグ修正フロー
「エラーを見つけたら、まずテストを書く」

## テストリスト管理（Kent Beck方式）
- TODO / WIP / DISCOVERED / DONE

## フェーズ遷移ルール
```

### 2. laravel/agent_docs/testing_guide.md（約80行）

```markdown
# Laravel Testing Guide

## テスト構造
tests/Unit/, tests/Feature/

## PHPUnit/Pest
- #[Test]属性
- Given/When/Then形式

## 例
```php
#[Test]
public function user_can_login(): void
{
    // Given
    // When
    // Then
}
```
```

### 3. laravel/agent_docs/quality_standards.md（約50行）

```markdown
# Laravel Quality Standards

## カバレッジ
- 目標: 90%
- 最低: 80%
- コマンド: php artisan test --coverage

## 静的解析
- PHPStan Level 8
- コマンド: vendor/bin/phpstan analyse

## コードフォーマット
- Laravel Pint (PSR-12)
- コマンド: vendor/bin/pint
```

### 4. laravel/agent_docs/commands.md（約40行）

```markdown
# Laravel Commands

## テスト
php artisan test
php artisan test --coverage

## 静的解析
vendor/bin/phpstan analyse

## フォーマット
vendor/bin/pint
```

### 5. 新CLAUDE.md構造（約80行）

```markdown
# [Project Name]

## Overview
[プロジェクトの目的を2-3文で]

## Tech Stack
- Framework: Laravel 11.0+
- Test: PHPUnit/Pest
- Static Analysis: PHPStan Level 8
- Formatter: Laravel Pint

## Quick Commands
- Test: `php artisan test`
- Coverage: `php artisan test --coverage`
- Lint: `vendor/bin/phpstan analyse`
- Format: `vendor/bin/pint`

## TDD Workflow
すべての変更はTDDサイクルを通す。
INIT → PLAN → RED → GREEN → REFACTOR → REVIEW → COMMIT

詳細: agent_docs/tdd_workflow.md

## Documentation
- agent_docs/tdd_workflow.md - TDDフェーズ詳細
- agent_docs/testing_guide.md - テスト書き方
- agent_docs/quality_standards.md - 品質基準
- agent_docs/commands.md - コマンド一覧

## Project Structure
[ディレクトリ構造]
```

---

## Progress Log

### 2025-12-03 10:25 - INIT phase
- Cycle doc作成
- スコープ定義完了
- テストリスト作成

### 2025-12-03 10:30 - PLAN phase
- 各ファイルの内容設計完了
- agent_docs構造確定

### 2025-12-03 11:30 - 追加対応完了
- install.sh 3ファイル更新（agent_docs/コピー機能追加）
- tdd-init SKILL.md 3ファイル更新（agent_docs/参照追加）
- tdd-onboard.md Step 4.5 改善（既存チェック追加）
- TC-09, TC-10 追加対応完了
- 全タスク完了
