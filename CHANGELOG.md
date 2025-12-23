# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2024-12-23

### Added

- plan-review スキル: PLANフェーズの設計を3観点で並行レビュー
  - 設計整合性、セキュリティ設計、バージョン互換性
- code-review スキル: コード変更を3観点で並行レビュー
  - Correctness、Performance、Security
  - ループ対策（2回目以降はGREEN戻り不可）
- tdd-red: エッジケースチェックリスト追加
  - null/空値、境界値、不正入力、権限、外部依存

### Changed

- tdd-plan: plan-review 推奨表示を追加（Step 6）
- tdd-review: code-review 自動実行を統合（Step 4）
- 全スキルを100行以下にリファクタリング（Progressive Disclosure対応）

### Removed

- .claude/commands/code-review.md（code-review スキルに移行）
- .claude/commands/test-agent.md（Laravel固有のため削除）

## [1.0.1] - 2024-12-23

### Added

- tdd-init: 環境情報収集機能（Python/PHP/Node バージョン・依存関係）
- tdd-plan: 最新ドキュメント確認機能（WebSearch/WebFetch活用）
- Cycle doc テンプレートに Environment セクション追加

### Changed

- tdd-plan: Web検索を条件付き実行に変更（パフォーマンス改善）

### Fixed

- tdd-init: 複数言語環境での環境情報収集の論理エラー修正
- tdd-plan: Progress Checklist と Step 数の整合性修正

## [1.0.0] - 2024-12-22

### Added

- TDD 7フェーズワークフロー（INIT → PLAN → RED → GREEN → REFACTOR → REVIEW → COMMIT）
- tdd-core プラグイン（全言語共通）
- tdd-php プラグイン（PHPStan, Pint, PHPUnit/Pest）
- tdd-python プラグイン（pytest, mypy, Black）
- tdd-ts プラグイン（tsc, ESLint, Jest/Vitest）
- tdd-js プラグイン（ESLint, Prettier, Jest）
- tdd-hugo プラグイン（hugo build, htmltest）
- tdd-flutter プラグイン（dart analyze, flutter test）
- docs/STATUS.md によるプロジェクト状況管理
- Claude Code Skills ベストプラクティス準拠の構造
