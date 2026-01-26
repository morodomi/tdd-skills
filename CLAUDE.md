# ClaudeSkills

Claude Codeを使った開発における厳格なTDDワークフローを実現するフレームワーク。

## Tech Stack

- **配布形式**: Claude Code Plugins, Bash scripts
- **対象言語**: PHP, Python, TypeScript, JavaScript, Flutter, Hugo
- **品質ツール**: PHPStan, PHPUnit/Pest, pytest, mypy, Black, ESLint, Jest

## Project Structure

```
tdd-skills/
├── plugins/                  # Claude Code Plugins
│   ├── tdd-core/             # TDD 7フェーズワークフロー + エージェント
│   │   ├── agents/           # green-worker, red-worker, reviewers
│   │   └── skills/           # tdd-init, tdd-plan, tdd-red, etc.
│   ├── tdd-php/              # PHP (PHPStan, Pint, PHPUnit)
│   ├── tdd-laravel/          # Laravel (Larastan, Pest)
│   ├── tdd-wordpress/        # WordPress (phpstan-wordpress, WPCS)
│   ├── tdd-python/           # Python (pytest, mypy, Black)
│   ├── tdd-flask/            # Flask (pytest-flask)
│   ├── tdd-ts/               # TypeScript (tsc, ESLint, Jest)
│   ├── tdd-js/               # JavaScript (ESLint, Prettier, Jest)
│   ├── tdd-hugo/             # Hugo SSG (hugo build, htmltest)
│   └── tdd-flutter/          # Flutter (dart analyze, flutter test)
├── .claude/
│   └── rules/                # 常時適用ルール (security, git-safety)
├── scripts/                  # テストスクリプト
└── docs/                     # Documentation
    └── cycles/               # TDDサイクルドキュメント
```

## TDD Workflow

```
INIT → PLAN → RED → GREEN → REFACTOR → REVIEW → COMMIT
```

**絶対ルール**: エラーを見つけたら、まずテストを書く

## TDD Philosophy (AI-Optimized)

### Ticket-Based RED-GREEN-REFACTOR

従来のTDD（Kent Beck）は「1テストずつRED→GREEN→REFACTOR」を推奨するが、
tdd-skillsは**チケット（Cycle）単位**でRED→GREEN→REFACTORを回す。

```
従来TDD:  test1→impl1→refactor → test2→impl2→refactor → ...
tdd-skills: [test1,test2,test3] → [impl1,impl2,impl3] → refactor
```

### Why Batch Approach for AI?

| 観点 | 人間 | AIエージェント |
|------|------|---------------|
| モチベーション | 早くグリーンを見たい | 関係なし |
| デバッグ | 変更が多いと難しい | ログで追跡可能 |
| 並列化 | 1人では不可能 | 複数エージェント並列実行可能 |
| コンテキスト | 忘れる | Cycle docで維持 |

### References

- [Canon TDD - Kent Beck](https://tidyfirst.substack.com/p/canon-tdd)
- [Programmer Test Principles - Kent Beck](https://medium.com/@kentbeck_7670/programmer-test-principles-d01c064d7934)

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

## Skills（トリガーワード）

| Skill | トリガー | Description |
|-------|---------|-------------|
| tdd-onboard | 「TDDセットアップ」「onboard」 | 初期セットアップ |
| tdd-init | 「機能追加」「TDDを始めたい」 | サイクル開始 |
| quality-gate | 「quality-gate」 | 4エージェント並行レビュー |

## Test Scripts

```bash
# Plugin構造テスト
bash scripts/test-plugins-structure.sh

# Skills構造テスト
bash scripts/test-skills-structure.sh
```

## Claude Code Configuration

| ディレクトリ | 内容 |
|-------------|------|
| .claude/rules/ | 常時適用ルール |
| .claude/hooks/ | 推奨Hooks設定 |

### Rules

- security.md - セキュリティチェック
- git-safety.md - Git安全規則
- git-conventions.md - Git規約

### Hooks

- recommended.md - 推奨フック設定

## References

- [anthropics/skills](https://github.com/anthropics/skills)
- [Claude Code Documentation](https://docs.anthropic.com/en/docs/claude-code)
