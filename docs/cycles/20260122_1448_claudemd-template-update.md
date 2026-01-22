# CLAUDE.md テンプレート更新

## Status: DONE

## INIT

### Scope Definition

tdd-onboard が生成する CLAUDE.md テンプレートを更新する。
agent_docs/ 参照を .claude/ 構造に変更。

Issue: #24
親Issue: #19

### Target

reference.md 内の CLAUDE.md テンプレートを更新:
- agent_docs/ → .claude/rules/, .claude/hooks/
- Documentation セクション → Claude Code Configuration セクション

### Tasks

- [ ] reference.md の CLAUDE.md テンプレート更新
- [ ] agent_docs 参照を .claude/ 構造に変更
- [ ] Rules セクション追加

### Out of Scope

- SKILL.md の変更（テンプレートは reference.md のみ）
- 既存プロジェクトのマイグレーション（#26で対応）

### Environment

#### Scope
- Layer: tdd-core プラグイン
- Plugin: tdd-core/skills/tdd-onboard

#### Runtime
- Claude Code Plugins

### Dependencies

- #20 完了済み（.claude/rules/ 構造への変更）
- #21 rules/git-safety.md（別worktreeで対応中）
- #22 完了済み（security.md テンプレート）
- #23 完了済み（hooks/recommended.md テンプレート）

## PLAN

### 設計方針

CLAUDE.md テンプレートに「Claude Code Configuration」セクションを追加。
.claude/rules/ と .claude/hooks/ の構造を明示し、各ルールファイルを一覧表示。

### 変更ファイル

| ファイル | 変更内容 |
|----------|----------|
| tdd-onboard/reference.md | CLAUDE.md テンプレートに Configuration セクション追加 |

### 追加するセクション

Quality Standards セクションの後に追加:

```markdown
---

## Claude Code Configuration

| ディレクトリ | 内容 |
|-------------|------|
| .claude/rules/ | 常時適用ルール |
| .claude/hooks/ | 推奨Hooks設定 |

### Rules

- tdd-workflow.md - TDDサイクル必須
- quality.md - 品質基準
- security.md - セキュリティチェック
- testing-guide.md - テストガイド
- commands.md - クイックコマンド

### Hooks

- recommended.md - 推奨フック設定（~/.claude/settings.json）
```

### 制約

- テンプレートは簡潔に保つ（詳細は各ルールファイル参照）
- agent_docs の記述がないことを確認

## Test List

### TODO

（なし）

### WIP

（なし）

### DONE

- [x] TC-01: CLAUDE.md テンプレートに `Claude Code Configuration` セクションがある
- [x] TC-02: テンプレートに `.claude/rules/` の記述がある
- [x] TC-03: テンプレートに `.claude/hooks/` の記述がある
- [x] TC-04: テンプレートに `agent_docs` の記述がない
- [x] TC-05: Rules 一覧に security.md が含まれている

## Notes

- everything-claude-code 互換構造
- 親Issue #19 の子タスク
