# ClaudeSkills

Claude Codeを使った開発における厳格なTDDワークフローを実現するフレームワーク。

## Tech Stack

- **配布形式**: Claude Code Plugins, Bash scripts
- **対象言語**: PHP, Python
- **品質ツール**: PHPStan, PHPUnit/Pest, pytest, mypy, Black

## Project Structure

```
ClaudeSkills/
├── plugins/                  # Claude Code Plugins（推奨）
│   ├── tdd-core/             # TDD 7フェーズワークフロー
│   ├── tdd-php/              # PHP品質ツール
│   └── tdd-python/           # Python品質ツール
├── templates/                # Legacy templates
│   ├── generic/
│   ├── laravel/
│   ├── flask/
│   ├── hugo/
│   └── bedrock/
├── .claude/
│   ├── commands/             # Slash Commands
│   └── skills/               # Project Skills
├── scripts/                  # Test scripts
└── docs/                     # Documentation
    └── cycles/               # TDDサイクルドキュメント
```

## TDD Workflow

```
INIT → PLAN → RED → GREEN → REFACTOR → REVIEW → COMMIT
```

**絶対ルール**: エラーを見つけたら、まずテストを書く

## Quality Standards

| 指標 | 目標 |
|------|------|
| カバレッジ | 90%以上（最低80%） |
| 静的解析 | エラー0件 |

## Development Rules

1. **TDDサイクル厳守**: 機能追加・バグ修正は必ずCycle doc作成から
2. **段階的な実装**: 変更ファイル10個以下
3. **テストファースト**: 実装前にテストを書く

## File Naming

- Cycle doc: `docs/cycles/YYYYMMDD_HHMM_機能名.md`
- 設計・調査: `docs/YYYYMMDD_HHMM_内容.md`

## Git Conventions

```
feat: 新機能
fix: バグ修正
docs: ドキュメント
refactor: リファクタリング
test: テスト
chore: その他
```

## Commands

| Command | Description |
|---------|-------------|
| `/tdd-onboard` | 初期セットアップ |
| `/test-agent` | カバレッジ向上 |
| `/code-review` | コードレビュー |

## Test Scripts

```bash
# Plugin構造テスト
bash scripts/test-plugins-structure.sh

# Skills構造テスト
bash scripts/test-skills-structure.sh
```

## References

- [anthropics/skills](https://github.com/anthropics/skills)
- [Claude Code Documentation](https://docs.anthropic.com/en/docs/claude-code)
