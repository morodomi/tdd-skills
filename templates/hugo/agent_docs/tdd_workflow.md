# Hugo TDD Workflow Guide

このドキュメントはHugoプロジェクト向けのTDD（Test-Driven Development）ワークフローの詳細を説明します。

---

## 7フェーズ概要

```
INIT → PLAN → RED → GREEN → REFACTOR → REVIEW → COMMIT
```

すべてのコンテンツ作成・テーマ開発は、この順序で進めてください。

---

## Hugo向けTDDの考え方

Hugo は静的サイトジェネレーターのため、従来のユニットテストとは異なるアプローチを取ります。

| 従来のTDD | Hugo TDD |
|----------|----------|
| テストコード | 期待するページ構造の定義 |
| 実装コード | content/ + layouts/ |
| テスト成功 | ビルド成功 + ページ表示確認 |
| 品質検証 | hugo build + htmltest |

---

## 各フェーズの詳細（Hugo向け）

### INIT - 初期化

**目的**: 要件を明確にし、Cycle docを作成する

**やること**:
- `docs/cycles/YYYYMMDD_HHMM_機能名.md` を作成
- 作成したいページ・セクションの背景と目標を記述
- content/ や layouts/ のファイルは作成しない

**完了条件**: Cycle docが作成され、目標が明確になっている

### PLAN - 計画

**目的**: ページ構造一覧と実装計画を作成する

**やること**:
- 作成するページ・セクションの一覧を作成（TODO/WIP/DISCOVERED/DONEセクション）
- URL構造、テンプレート設計を記述
- content/ や layouts/ のファイルは作成しない

**完了条件**: ページ一覧が完成し、実装方針が決まっている

### RED - ページ構造定義

**目的**: 期待するページ構造を先に定義し、まだ存在しないことを確認する

**やること**:
- Cycle doc に期待するページ構造を記述
  - URL パス（例: `/posts/my-first-post/`）
  - ページタイプ（single / list / home）
  - 期待するセクション・コンテンツ
  - 必要なテンプレート（layouts/）
- 現在この構造が存在しないことを確認

**完了条件**: 期待するページ構造が定義され、まだ存在しない

### GREEN - 最小実装

**目的**: 定義したページ構造を実現する最小限の実装を行う

**やること**:
- content/ にMarkdownファイルを作成
- layouts/ にテンプレートファイルを作成
- `hugo server -D` で表示確認
- `hugo build` でビルド成功確認

**原則**:
- YAGNI: 必要になるまで実装しない
- 過度なパーシャル分割をしない（REFACTORで行う）
- まず動くページを作る

**完了条件**: ビルドが成功し、ページが表示される

### REFACTOR - リファクタリング

**目的**: ビルド成功を維持しながらテンプレート品質を改善する

**やること**:
- パーシャル分割（`layouts/partials/` に共通部品を抽出）
- ショートコード化（再利用可能なコンポーネント）
- DRY原則の適用（重複コードの削除）
- 各変更後にビルド実行

**原則**:
- ビルドは常に成功し続けること
- 小さな変更を積み重ねる

**完了条件**: テンプレート品質が改善され、ビルドが成功している

### REVIEW - 品質検証

**目的**: 品質基準を満たしているか確認する

**やること**:
- ビルド確認: `hugo build --gc --minify`
- リンク検証: `htmltest ./public`
- 表示確認: 開発サーバーで目視確認

**完了条件**: ビルドが成功し、リンク切れがない

### COMMIT - コミット

**目的**: 変更をGitにコミットし、ドキュメントを更新する

**やること**:
- Cycle docを更新（Progress Log）
- git commit
- 必要に応じてデプロイ

**完了条件**: コミットが完了し、Cycle docが更新されている

---

## コンテンツ作成フロー

新しいブログ記事やページを作成する場合:

### 手順

1. **INIT**: 記事の目的を記録
2. **RED**: URL構造とメタデータを定義
3. **GREEN**: content/ にMarkdownを作成、表示確認
4. **REFACTOR**: Front matter整理、画像最適化
5. **REVIEW**: ビルド確認、リンク検証
6. **COMMIT**: コミット

### 例: ブログ記事作成

```markdown
## RED: 期待するページ構造

- URL: /posts/2025/12/my-first-post/
- タイプ: single (posts)
- Front matter:
  - title: "初めての記事"
  - date: 2025-12-03
  - tags: ["hugo", "tutorial"]
- 本文: 導入、本文、まとめ
```

---

## テーマ開発フロー

新しいレイアウトやテンプレートを作成する場合:

### 手順

1. **INIT**: レイアウトの目的を記録
2. **RED**: 期待するHTML構造を定義
3. **GREEN**: layouts/ にテンプレートを作成
4. **REFACTOR**: パーシャル分割、共通化
5. **REVIEW**: ビルド確認、複数ページでの表示確認
6. **COMMIT**: コミット

### 例: 新しいリストテンプレート

```markdown
## RED: 期待するテンプレート

- ファイル: layouts/_default/list.html
- 機能:
  - セクション内の記事一覧を表示
  - ページネーション対応
  - タグ・カテゴリ表示
- 使用パーシャル:
  - partials/article-card.html
  - partials/pagination.html
```

---

## テストリスト管理（Hugo向け）

### 4つのセクション

```markdown
## Test List

### 実装予定（TODO）
- [ ] TC-01: トップページにヒーローセクションを追加
- [ ] TC-02: 記事一覧にサムネイル表示

### 実装中（WIP）
- [WIP] TC-01: トップページにヒーローセクションを追加

### 実装中に気づいた追加テスト（DISCOVERED）
- [ ] TC-03: OGP画像の自動生成（GREEN中に気づいた - Priority: Medium）

### 完了（DONE）
- [x] TC-01: トップページにヒーローセクションを追加
```

---

## 品質チェックコマンド

```bash
# ビルド（本番環境向け）
hugo build --gc --minify

# リンク検証
htmltest ./public

# 開発サーバー
hugo server -D

# 一括チェック
hugo build --gc --minify && htmltest ./public
```

---

## フェーズ遷移ルール

1. 各フェーズは順番に実行（スキップ禁止）
2. 前のフェーズが完了するまで次に進まない
3. REVIEWで品質基準を満たさない場合はREFACTORに戻る
4. **REDフェーズ（構造定義）は絶対にスキップしない**

---

## Cycle doc テンプレート（Hugo向け）

```markdown
---
feature: [機能領域]
cycle: [サイクル識別子]
phase: INIT
created: YYYY-MM-DD HH:MM
updated: YYYY-MM-DD HH:MM
---

# [機能名]

## やりたいこと
[背景と目標]

## Scope Definition
[スコープ定義]

## 期待するページ構造（RED）
- URL:
- タイプ: single / list / home
- 必要なテンプレート:
- Front matter:

## Test List
### 実装予定（TODO）
### 実装中（WIP）
### 実装中に気づいた追加テスト（DISCOVERED）
### 完了（DONE）

## Progress Log
### YYYY-MM-DD - [phase]
- [作業内容]
```

---

*このドキュメントはClaudeSkills TDD Framework（Hugo向け）の一部です*
