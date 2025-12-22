# TDD Skills

Claude Code で厳格な TDD ワークフローを実現するプラグイン

## Installation

```bash
# マーケットプレイスを登録
/plugin marketplace add morodomi/tdd-skills

# TDDワークフローをインストール
/plugin install tdd-core@tdd-skills

# 言語別品質ツール（いずれかを選択）
/plugin install tdd-php@tdd-skills      # PHP
/plugin install tdd-python@tdd-skills   # Python
```

## TDD Workflow

```
INIT → PLAN → RED → GREEN → REFACTOR → REVIEW → COMMIT
```

| Phase | Skill | Description |
|-------|-------|-------------|
| INIT | tdd-init | サイクルドキュメント作成 |
| PLAN | tdd-plan | 設計・計画 |
| RED | tdd-red | 失敗するテスト作成 |
| GREEN | tdd-green | 最小限の実装 |
| REFACTOR | tdd-refactor | コード改善 |
| REVIEW | tdd-review | 品質チェック |
| COMMIT | tdd-commit | Git commit |

## Plugins

| Plugin | Description |
|--------|-------------|
| **tdd-core** | TDD 7フェーズワークフロー（言語非依存） |
| **tdd-php** | PHPStan, Pint, PHPUnit/Pest |
| **tdd-python** | pytest, mypy, Black/isort |

## Usage

```bash
claude

> ログイン機能を追加したい

# Claudeが自動的にTDDサイクルを案内
# 1. docs/cycles/ にサイクルドキュメント作成
# 2. テスト作成 → 実装 → リファクタ → コミット
```

## Quality Standards

| 項目 | 目標 |
|------|------|
| カバレッジ | 90%以上 |
| 静的解析 | エラー0件 |

## License

[MIT](LICENSE)

## References

- [Claude Code Skills](https://docs.anthropic.com/en/docs/claude-code/skills)
- [anthropics/skills](https://github.com/anthropics/skills)
