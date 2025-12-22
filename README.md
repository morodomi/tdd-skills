# ClaudeSkills

Claude Code で厳格な TDD ワークフローを実現するフレームワーク

## Overview

**ClaudeSkills** は、Claude Code との協働開発において TDD（Test-Driven Development）サイクルを強制する Skills のコレクションです。

```
INIT → PLAN → RED → GREEN → REFACTOR → REVIEW → COMMIT
```

## Installation

### Plugin（推奨）

```bash
# 1. マーケットプレイスを登録（初回のみ）
/plugin marketplace add morodomi/tdd-skills

# 2. プラグインをインストール
/plugin install tdd-core@tdd-skills          # TDDワークフロー（必須）
/plugin install tdd-php@tdd-skills           # PHP: PHPStan, Pint, PHPUnit
/plugin install tdd-python@tdd-skills        # Python: pytest, mypy, Black
```

### Template（レガシー）

```bash
# プロジェクトディレクトリで実行
bash <(curl -s https://raw.githubusercontent.com/morodomi/tdd-skills/main/templates/laravel/install.sh)
```

## Plugins

| Plugin | Description |
|--------|-------------|
| **tdd-core** | TDD 7フェーズワークフロー |
| **tdd-php** | PHP品質ツール（PHPStan, Pint, PHPUnit/Pest） |
| **tdd-python** | Python品質ツール（pytest, mypy, Black/isort） |

## TDD Skills

| Skill | Phase | Description |
|-------|-------|-------------|
| tdd-init | INIT | サイクルドキュメント作成 |
| tdd-plan | PLAN | 設計・計画 |
| tdd-red | RED | 失敗するテスト作成 |
| tdd-green | GREEN | 最小限の実装 |
| tdd-refactor | REFACTOR | コード改善 |
| tdd-review | REVIEW | 品質チェック |
| tdd-commit | COMMIT | Git commit |

## Commands

| Command | Description |
|---------|-------------|
| `/tdd-onboard` | 初期セットアップ |
| `/worktree` | 並行開発環境構築 |
| `/code-review` | 3観点コードレビュー |
| `/test-agent` | カバレッジ向上 |

## Usage

```bash
# Claude Code を起動
claude

# TDDサイクル開始
> ログイン機能を追加したい

# Claude が TDD フェーズを案内:
# 1. INIT: docs/cycles/ にサイクルドキュメント作成
# 2. PLAN: 設計
# 3. RED: テスト作成
# 4. GREEN: 実装
# 5. REFACTOR: 改善
# 6. REVIEW: 品質チェック
# 7. COMMIT: コミット
```

## Project Structure

```
ClaudeSkills/
├── .claude-plugin/       # Marketplace定義
│   └── marketplace.json
├── plugins/              # Claude Code Plugins
│   ├── tdd-core/         # TDDワークフロー
│   ├── tdd-php/          # PHP品質ツール
│   └── tdd-python/       # Python品質ツール
├── templates/            # Legacy templates
└── docs/                 # Documentation
```

## Documentation

- [Plugin README](plugins/README.md)
- [汎用インストールガイド](docs/GENERIC_INSTALLATION.md)
- [Bedrock/WordPress](docs/BEDROCK_INSTALLATION.md)
- [MCP統合](docs/MCP_INSTALLATION.md)

## License

[MIT](LICENSE)

## References

- [anthropics/skills](https://github.com/anthropics/skills)
- [Claude Code Documentation](https://docs.anthropic.com/en/docs/claude-code)

---

*Made with Claude Code + TDD*
