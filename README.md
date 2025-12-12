# ClaudeSkills

Claude Code で厳格な TDD ワークフローを実現するフレームワーク

## What is this?

**ClaudeSkills** は、Claude Code との協働開発において TDD（Test-Driven Development）サイクルを強制するSkills/Commandsのコレクションです。

- **7フェーズTDD**: INIT → PLAN → RED → GREEN → REFACTOR → REVIEW → COMMIT
- **フェーズごとの制約**: 各フェーズで「やって良いこと・ダメなこと」をSkillsで強制
- **並行開発支援**: `/worktree` コマンドで git worktree + DB分離の環境を自動構築
- **TDD Skills**: `tdd-init`, `tdd-plan`, `tdd-red`, `tdd-green`, `tdd-refactor`, `tdd-review`, `tdd-commit`

## Quick Start

### インストール

```bash
# プロジェクトディレクトリで実行
cd your-project

# テンプレートを選択してインストール
bash /path/to/ClaudeSkills/templates/generic/install.sh   # 汎用
bash /path/to/ClaudeSkills/templates/laravel/install.sh   # Laravel
bash /path/to/ClaudeSkills/templates/flask/install.sh     # Flask
bash /path/to/ClaudeSkills/templates/hugo/install.sh      # Hugo
bash /path/to/ClaudeSkills/templates/bedrock/install.sh   # WordPress (Bedrock)
```

### 基本的な使い方

```bash
# Claude Code を起動
claude

# TDDサイクル開始
> 新しい機能を追加したい

# Claude が自動的に TDD フェーズを案内:
# 1. docs/cycles/ にサイクルドキュメント作成
# 2. RED: テスト作成
# 3. GREEN: 実装
# 4. REFACTOR: 改善
# 5. REVIEW: 品質チェック
# 6. COMMIT: コミット
```

## Templates

| テンプレート | 用途 | 品質ツール |
|-------------|------|-----------|
| **generic** | 任意の言語/FW | カスタマイズ可能 |
| **laravel** | Laravel (PHP) | PHPUnit/Pest, PHPStan, Pint |
| **flask** | Flask (Python) | pytest, mypy, black |
| **hugo** | Hugo (SSG) | hugo build, htmltest |
| **bedrock** | WordPress | PHPUnit, PHPStan |

## Commands

| コマンド | 説明 |
|---------|------|
| `/tdd-onboard` | 初期セットアップ（CLAUDE.md生成、プロジェクト分析） |
| `/worktree` | 並行開発環境のセットアップ（git worktree + DB分離）* |
| `/code-review` | 3観点（正確性/性能/セキュリティ）の並列コードレビュー |
| `/test-agent` | テストカバレッジ向上の自動化 |

\* `/worktree` はテンプレートインストール後に利用可能

### /worktree の使い方

```bash
/worktree 42                    # GitHub issue #42 用の環境作成
/worktree 42 login-api          # issue + ブランチ名指定
/worktree refactor-auth         # ブランチ名のみ
/worktree ログイン機能を追加     # 自然言語 → issue検索
```

## TDD Workflow

```
INIT ──→ PLAN ──→ RED ──→ GREEN ──→ REFACTOR ──→ REVIEW ──→ COMMIT
 │        │        │        │          │           │          │
 │        │        │        │          │           │          └─ git commit
 │        │        │        │          │           └─ 品質チェック
 │        │        │        │          └─ コード改善
 │        │        │        └─ 最小限の実装（テスト通す）
 │        │        └─ 失敗するテスト作成
 │        └─ 設計・計画
 └─ サイクルドキュメント作成
```

## Project Structure

```
ClaudeSkills/
├── templates/
│   ├── generic/          # 汎用テンプレート
│   ├── laravel/          # Laravel用
│   ├── flask/            # Flask用
│   ├── hugo/             # Hugo用
│   └── bedrock/          # WordPress用
├── docs/                 # 設計ドキュメント
└── .claude/
    └── commands/         # グローバルコマンド
```

## Documentation

詳細なドキュメントは `docs/` を参照:

- [汎用インストールガイド](docs/GENERIC_INSTALLATION.md)
- [Bedrock/WordPressインストールガイド](docs/BEDROCK_INSTALLATION.md)
- [MCP統合ガイド](docs/MCP_INSTALLATION.md)

## Contributing

Issue や Pull Request は歓迎します。

## License

[MIT](LICENSE)

## References

- [anthropics/skills](https://github.com/anthropics/skills) - 公式Skillsリポジトリ
- [Claude Code Documentation](https://docs.anthropic.com/en/docs/claude-code)

---

*Made with Claude Code + TDD*
