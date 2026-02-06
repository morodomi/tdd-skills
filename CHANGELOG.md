# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [4.3.0] - 2026-02-06

### Added

- **quality-gate Agent Teams mode**: 環境変数 `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` による討論型レビュー
  - 有効時: 6レビュアーがチーム討論で反証・補強し合う debate mode
  - 無効時: 従来の並行実行 (subagent mode)
  - steps-teams.md / steps-subagent.md にモード別手順を分離
- **tdd-diagnose**: 複雑なバグの並列仮説調査スキル
  - 複数の原因仮説を並行調査し互いに反証
  - Agent Teams 有効時は討論型調査、無効時は Explore エージェント並行調査
  - tdd-init の高リスク時に auto-transition で自動起動
- **tdd-parallel**: クロスレイヤー並列開発オーケストレータ
  - Frontend/Backend/DB 等のレイヤー別に Teammate が並列で RED→GREEN→REFACTOR を実行
  - API 契約変更時のチーム間即時共有、統合テスト実行
  - tdd-plan でレイヤー検出時に自動提案

## [4.2.0] - 2026-02-05

### Added

- **Auto Phase Transition**: TDDフェーズ間のスキル自動実行
  - 各フェーズ完了時に次フェーズへの遷移を自動化
  - ユーザー確認後にスキルを自動呼び出し

### Changed

- Progress Checklistのフォーマットをチェックボックス形式に統一

### Removed

- docs/article/ ディレクトリ削除（外部リポジトリに移行）

## [4.1.0] - 2026-02-03

### Added

- **product-reviewer**: PdM目線のレビューエージェント（価値・コスト・優先度）
- **usability-reviewer**: デザイナー目線のレビューエージェント（UX・アクセシビリティ）

### Changed

- quality-gate: 4エージェント → 6エージェント体制（product-reviewer, usability-reviewer追加）
- plan-review: 3エージェント → 5エージェント体制（product-reviewer, usability-reviewer追加）
- tdd-review: quality-gateを必須・スキップ不可に変更
- tdd-commit: ワークフロー順序修正（docs更新をgit commit前に移動）

### Removed

- 全plugin.jsonからversionフィールド削除
- 未使用スクリプト削除

## [4.0.0] - 2026-01-26

### Added

- **RED Parallelization**: red-worker エージェントによる並列テスト作成
  - tdd-red/SKILL.md: 並列ワークフロー (Steps 2-4)
  - plugins/tdd-core/agents/red-worker.md: ワーカーエージェント定義
  - tdd-red/reference.md: Shared fixtures handling ドキュメント
- リトライ上限 (最大2回) を tdd-red に追加
- Cycle doc 検証エラー処理を red-worker に追加
- scripts/test-red-parallelization.sh: RED並列化テストスクリプト

### Changed

- README.md を英語版に変更、README.ja.md を日本語版として追加
- TDD Philosophy セクションを並列実行 (v3.3 & v4.0) で更新

## [3.3.0] - 2026-01-26

### Added

- **GREEN Parallelization**: green-worker エージェントによる並列実装
  - tdd-green/SKILL.md: 並列ワークフロー
  - plugins/tdd-core/agents/green-worker.md: ワーカーエージェント定義
- ファイル依存関係分析による競合回避戦略

## [3.2.0] - 2026-01-26

### Added

- **WARN-level Quick Questions**: WARN時 (30-59) にも簡易質問を追加
  - INIT: 「本当に解決したい問題は何か」「代替案は検討したか」
  - PLAN: 「この設計で想定外のケースは何か」
- 手戻り削減のためのスコープ確認強化

## [3.1.0] - 2026-01-23

### Added

- **Brainstorm Enhancement**: BLOCK時に問題の本質を深掘り
  - 「本当に解決したい問題は何？」
  - 「代替アプローチは検討した？」
- **Task Granularity**: PLANフェーズで2-5分タスク粒度を推奨

### Changed

- tdd-plan: タスク粒度ガイドを reference.md に追加

## [3.0.0] - 2026-01-23

### Added

- **Question-Driven TDD**: リスクスコアに基づく質問フロー
  - Risk Score: 0-29 (PASS), 30-59 (WARN), 60-100 (BLOCK)
  - Risk Types: Security, External API, Data Changes
- tdd-init: リスクスコア計算 (Step 4.5)
- tdd-init: Brainstorm & Risk Questions (Step 4.6)
- plan-review スキル: 3エージェント並行レビュー (scope, architecture, risk)

### Changed

- tdd-init: ステップ構成を Question-Driven 対応に変更

## [2.0.0] - 2026-01-22

### BREAKING CHANGES

- `agent_docs/` ディレクトリを `.claude/rules/`, `.claude/hooks/` 構造に変更
  - 詳細: [Migration Guide](docs/MIGRATION.md)

### Added

- `.claude/rules/security.md`: セキュリティチェックリスト
- `.claude/rules/git-safety.md`: Git安全規則
- `.claude/rules/git-conventions.md`: Git規約
- `.claude/hooks/recommended.md`: 推奨Hooks設定（Claude Code公式形式）
- CLAUDE.md テンプレートに Configuration セクション追加
- docs/MIGRATION.md: v1.x → v2.0 マイグレーションガイド

### Changed

- tdd-onboard: Step 6 を `.claude/` 構造生成に変更
- tdd-onboard: SKILL.md を Progressive Disclosure パターンで圧縮（87行）
- テストスクリプト: SKILL.md + reference.md 両方をチェックするよう更新

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
