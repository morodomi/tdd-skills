---
feature: claude-md-improvement
cycle: merge-feature-001
phase: DONE
created: 2025-12-03 11:30
updated: 2025-12-03 11:35
---

# CLAUDE.md マージ機能

## やりたいこと

tdd-onboardで既存CLAUDE.mdを更新する際、ユーザーのカスタマイズを保持しながらテンプレートを更新する。

**背景**:
- 既存プロジェクトでCLAUDE.mdを更新すると、ユーザーのカスタマイズが消える
- 全上書きは危険で、ユーザー体験が悪い
- マージ機能があれば安心してアップデートできる

---

## Scope Definition

### 今回実装する範囲

- [x] tdd-onboard Step 4 にマージロジック追加
- [x] セクション解析の指示を追加
- [x] マージ戦略のドキュメント化
- [x] 差分表示とユーザー確認フロー

### 今回実装しない範囲

- 自動マージツール（シェルスクリプト）の作成
- install.sh への --update オプション追加

---

## Test List

### 実装予定（TODO）

（なし）

### 完了（DONE）

- [x] TC-01: tdd-onboard Step 4 にマージロジックが含まれる
- [x] TC-02: セクション解析手順が明確
- [x] TC-03: マージ戦略テーブルが存在
- [x] TC-04: 差分表示フローが存在

---

## Implementation Notes

### マージ戦略

| セクション | 戦略 | 理由 |
|-----------|------|------|
| Overview | 既存を保持 | プロジェクト固有の説明 |
| Tech Stack | 新規で上書き | 検出結果を反映 |
| Quick Commands | 新規で上書き | 検出結果を反映 |
| TDD Workflow | 新規で上書き | 最新テンプレート |
| Quality Standards | 新規で上書き | 最新テンプレート |
| Documentation | 新規で上書き | agent_docs/参照 |
| Project Structure | 既存を保持 | プロジェクト固有 |
| Available Commands | 新規で上書き | 最新テンプレート |
| カスタムセクション | 既存を保持 | ユーザー追加分 |

---

## Progress Log

### 2025-12-03 11:30 - 実装開始
- Cycle doc作成
- tdd-onboard Step 4 マージ機能実装

### 2025-12-03 11:35 - 実装完了
- Step 4.1: 既存CLAUDE.md確認ロジック追加
- Step 4.2: マージ処理フロー追加
  - 4.2.1 バックアップ作成
  - 4.2.2 セクション解析指示
  - 4.2.3 マージ戦略テーブル
  - 4.2.4 差分表示フォーマット
  - 4.2.5 ユーザー確認（AskUserQuestion）
- 全テストケース完了
