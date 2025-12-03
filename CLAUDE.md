# ClaudeSkills - TDD Framework for Claude Code

## Overview

ClaudeSkillsは、Claude Codeを使った開発における厳格なTDD（Test-Driven Development）ワークフローを実現するためのSkills/MCPフレームワークです。

**目的**: 生成AIとの協働開発において、要望との乖離を防ぎ、厳格なTDDワークフローを強制する。

---

## Tech Stack

- **配布形式**: Bash scripts, Markdown (Claude Skills)
- **対象言語**: PHP, Python
- **対象フレームワーク**: Laravel, Django, Flask, WordPress (Bedrock)
- **ツール統合**: PHPStan, PHPUnit/Pest, pytest, mypy

---

## Quick Commands

```bash
# テンプレートを既存プロジェクトにインストール
./install.sh /path/to/project

# インストール後のセットアップ
/tdd-onboard
```

---

## Project Structure

```
ClaudeSkills/
├── templates/
│   ├── _common/agent_docs/    # 共通ドキュメント
│   ├── generic/               # 汎用テンプレート
│   ├── laravel/               # Laravel用
│   └── bedrock/               # WordPress用
├── .claude/
│   ├── commands/              # Slash Commands
│   └── skills/                # Skills
├── docs/
│   └── cycles/                # TDDサイクルドキュメント
├── install.sh                 # インストーラ
└── CLAUDE.md                  # このファイル
```

---

## TDD Workflow

このプロジェクト自体もTDDワークフローで開発する。

```
INIT → PLAN → RED → GREEN → REFACTOR → REVIEW → COMMIT
```

**絶対ルール**: エラーを見つけたら、まずテストを書く

詳細: `docs/` 内のサイクルドキュメント参照

---

## Quality Standards

| 指標 | 目標 |
|------|------|
| カバレッジ | 90%以上（最低80%） |
| 静的解析 | エラー0件 |

---

## Documentation

### 要件・設計

| ドキュメント | 内容 |
|-------------|------|
| `docs/20251022_1328_要件定義.md` | プロジェクト要件定義 |
| `docs/20251022_1443_SkillsMCP調査.md` | Skills/MCP調査 |
| `docs/20251107_0000_Claude_Code統合機構調査.md` | 統合機構調査 |

### Progressive Disclosure

CLAUDE.mdは短く保ち（300行以下推奨）、詳細は`agent_docs/`に分離する方式を採用。

参考: https://www.humanlayer.dev/blog/writing-a-good-claude-md

---

## Key Decisions

1. **TDDワークフロー継続**: 7フェーズ（INIT→COMMIT）
2. **インストール戦略**: プロジェクト固有インストール（`.claude/skills/`）
3. **Progressive Disclosure**: CLAUDE.md短縮 + agent_docs/分離

---

## Development Guidelines

### このプロジェクトの開発ルール

1. **TDDサイクル厳守**: 機能追加・バグ修正は必ずCycle doc作成から
2. **段階的な実装**: 小さく始める（変更ファイル10個以下）
3. **ドキュメント優先**: 設計・調査はドキュメント化してから実装

### ファイル命名規則

- Cycle doc: `docs/cycles/YYYYMMDD_HHMM_機能名.md`
- 設計・調査: `docs/YYYYMMDD_HHMM_内容.md`

---

## Git Conventions

### コミットメッセージ

```
feat: 新機能
fix: バグ修正
docs: ドキュメント
refactor: リファクタリング
test: テスト
chore: その他
```

### コミット前チェック

1. テスト実行（すべて通過）
2. 静的解析（エラー0件）
3. コードフォーマット

---

## Available Commands

- `/tdd-onboard`: 初期セットアップ
- `/test-agent`: カバレッジ向上
- `/code-review`: コードレビュー

---

## Meta Rules for Claude Code

1. **不確実性への対処**: 推測せず、ユーザーに確認
2. **ファイル作成の制限**: 既存ファイルの編集を優先
3. **テストファースト**: 実装前にテストを書く

---

## References

- [anthropics/skills](https://github.com/anthropics/skills)
- [Claude Code Documentation](https://docs.claude.com/en/docs/claude-code)
- [Model Context Protocol](https://modelcontextprotocol.io/)

---

*最終更新: 2025-12-03*
