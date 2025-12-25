# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.4.1] - 2025-12-25

### Added

- tdd-plan: エラーメッセージUX設計ガイド追加（reference.md）
  - ポジティブフレーミング、ユーザーを責めない等の4原則
  - 「避ける」→「推奨」パターン表（6例）
  - PHP/Python の適用例

### Changed

- tdd-plan/SKILL.md: Step 5 にエラーメッセージ設計への参照リンク追加

## [1.4.0] - 2025-12-25

### Added

- tdd-init: スコープ（Layer）確認ステップ（Step 5）
  - Backend / Frontend / Both の選択
  - 言語プラグインマッピング（Laravel→tdd-php等）
- tdd-onboard: CLAUDE.mdテンプレートに複数プラグイン対応
  - Backend/Frontend のLayer別テーブル形式
- quality-gate: Cycle docからプラグイン参照ステップ（Step 2）
  - 言語プラグインのTesting Strategy参照
- tdd-php: Testing Strategy追加
  - No RefreshDatabase推奨パターン
  - Factory + `fake()->unique()` で一意性保証
- Cycle docテンプレート: Scopeセクション追加（Layer/Plugin）

### Changed

- tdd-init: ステップ番号整理（Step 5-8）
- quality-gate: ステップ番号整理（Step 2-5）

## [1.3.0] - 2025-12-24

### Added

- tdd-flask プラグイン（pytest-flask, mypy, Black）
  - Flask 3.x / pytest-flask 1.3.0+ 対応
  - App Factory Pattern、セッションテスト等のパターン
- tdd-onboard: 階層CLAUDE.md推奨（Step 5）
  - tests/, src/, docs/ への CLAUDE.md 配置を推奨
  - Context肥大化対策: 第1階層のみ、各30-50行以内
- tdd-onboard: Pre-commit Hook確認（Step 7）
- tdd-commit: Hook確認ステップ（Step 2）
- README.md: Cross-Platform Compatibility セクション
  - GitHub Copilot CLI、OpenAI Codex CLI、Gemini CLI 対応情報

### Changed

- README.md: Plugins テーブルに tdd-flask 追加

## [1.2.1] - 2025-12-24

### Changed

- tdd-plan: Test Listにカテゴリ一覧追加（正常系、境界値、エッジケース、異常系、権限、外部依存、セキュリティ）
- tdd-plan: テスト数の目安追加（5-10ケース/機能）
- tdd-red: Step 1.5を廃止、Step 2「カテゴリ別チェック」に変更
- tdd-red: ステップ番号を整理（1→5の連番）

### Removed

- .claude/skills/ ディレクトリ（plugins/に移行済み）
- templates/ ディレクトリ（plugins/に移行済み）
- tests/ ディレクトリ（scripts/に移行済み）
- examples/ ディレクトリ（不要）
- docs/の古い設計ドキュメント（2025年10月〜11月）
- docs/*_INSTALLATION.md（レガシーインストールガイド）

## [1.2.0] - 2025-12-23

### Added

- plugins/tdd-core/agents/ ディレクトリに7つのレビューエージェント
  - correctness-reviewer: 論理エラー、エッジケース、例外処理
  - performance-reviewer: O記法、N+1問題、メモリ使用
  - security-reviewer: 入力検証、認証・認可、SQLi/XSS
  - guidelines-reviewer: コーディング規約、命名規則
  - scope-reviewer: スコープ妥当性、ファイル数
  - architecture-reviewer: 設計整合性、パターン
  - risk-reviewer: 影響範囲、破壊的変更
- quality-gate スキル: 4エージェント並行レビュー + 信頼スコア
  - 閾値80でBLOCK、50-79でWARN、49以下でPASS

### Changed

- plan-review: 3エージェント並行呼び出し方式に変更
- tdd-review: code-review → quality-gate 参照に変更
- 構造テスト: エージェント/quality-gateテスト追加

### Removed

- code-review スキル（quality-gate に統合）

## [1.1.0] - 2025-12-23

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

## [1.0.1] - 2025-12-23

### Added

- tdd-init: 環境情報収集機能（Python/PHP/Node バージョン・依存関係）
- tdd-plan: 最新ドキュメント確認機能（WebSearch/WebFetch活用）
- Cycle doc テンプレートに Environment セクション追加

### Changed

- tdd-plan: Web検索を条件付き実行に変更（パフォーマンス改善）

### Fixed

- tdd-init: 複数言語環境での環境情報収集の論理エラー修正
- tdd-plan: Progress Checklist と Step 数の整合性修正

## [1.0.0] - 2025-12-22

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
