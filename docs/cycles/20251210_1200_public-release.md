---
feature: public-release
cycle: public-release-001
phase: PLAN
created: 2025-12-10 12:00
updated: 2025-12-10 12:10
---

# 公開準備

## やりたいこと

ClaudeSkillsプロジェクトをGitHub公開リポジトリとして公開する準備を行う。

**背景**:
- Claude Code + TDD の実践的な事例として公開したい
- 日本語のSkills/Commands例として価値がある
- 並列実行パターン（/worktree, /code-review）の参考事例

---

## Scope Definition

### 今回実装する範囲

- [ ] LICENSE ファイル追加（MIT）
- [ ] README.md 改善
  - [ ] 概要・目的
  - [ ] インストール方法
  - [ ] 使い方（Quick Start）
  - [ ] テンプレート一覧
  - [ ] コマンド一覧
- [ ] 機密情報チェック
- [ ] 不要ファイル整理

### 今回実装しない範囲

- Contributing guide（後で追加可能）
- GitHub Actions（CI/CD）
- デモ動画・スクリーンショット

### 変更予定ファイル

```
LICENSE          # 新規
README.md        # 大幅改善
.gitignore       # 確認・更新
```

計: 約3ファイル

---

## Context & Dependencies

### 現在のREADME状態

確認が必要

### 参照プロジェクト

- https://github.com/anthropics/skills
- 他のClaude Code関連リポジトリ

---

## Test List

### 実装予定（TODO）

- [ ] TC-01: LICENSE ファイルが存在する
- [ ] TC-02: README.md に概要セクションがある
- [ ] TC-03: README.md にインストール方法がある
- [ ] TC-04: README.md に使い方がある
- [ ] TC-05: 機密情報が含まれていない
- [ ] TC-06: .gitignore が適切

### 実装中（WIP）

（なし）

### 実装中に気づいた追加テスト（DISCOVERED）

（なし）

### 完了（DONE）

（なし）

---

## Progress Log

### 2025-12-10 12:00 - INIT phase
- TDDサイクルドキュメント作成
- スコープ定義

### 2025-12-10 12:10 - PLAN phase
- 現状分析完了
  - LICENSE: なし → MIT作成
  - README.md: 400行 → 簡潔化必要
  - .gitignore: settings.local.json追加必要
- 詳細計画策定

---

## PLAN: 詳細設計

### 1. LICENSE (MIT)

```
MIT License

Copyright (c) 2025 morodomi

Permission is hereby granted, free of charge, to any person obtaining a copy
...
```

### 2. README.md 構成（公開向け・簡潔版）

**目標**: 100-150行程度

```markdown
# ClaudeSkills

Claude Code + TDD のフレームワーク

## What is this?
- 説明（3-5行）

## Quick Start
- インストールコマンド（5行）
- 基本的な使い方（10行）

## Templates
- generic, laravel, flask, hugo, bedrock（テーブル形式）

## Commands
- /tdd-init, /worktree, /code-review（テーブル形式）

## TDD Workflow
- 7フェーズの簡易図

## Documentation
- docs/へのリンク

## License
MIT
```

### 3. .gitignore 追加

```
.claude/settings.local.json
```

### 4. 機密情報チェック

確認対象:
- [ ] APIキー、トークン
- [ ] パスワード
- [ ] 個人メールアドレス
- [ ] 内部URL

---

## 次のステップ

1. [完了] INIT（初期化）
2. [実行中] PLAN（計画）← 現在ここ
3. [スキップ] RED（テスト作成）
4. [ ] GREEN（実装）
5. [スキップ] REFACTOR
6. [ ] REVIEW（品質検証）
7. [ ] COMMIT（コミット）

---

*作成日時: 2025-12-10 12:00*
