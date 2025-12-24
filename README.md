# TDD Skills

Claude Code で厳格な TDD ワークフローを実現するプラグイン

## Why?

AIにコードを任せると、こんな問題が起きがち：

- テストは「書いて」と言わないと書かない
- 品質チェックは人間が手動で実行
- セッションが切れると何をやっていたか忘れる

**tdd-skills** は、Claude Code に TDD を「強制」することでこれらを解決します。

## Getting Started

### 1. プラグインインストール

```bash
claude

> /plugin marketplace add morodomi/tdd-skills
> /plugin install tdd-core@tdd-skills
> /plugin install tdd-php@tdd-skills  # 言語に合わせて選択
```

### 2. プロジェクトセットアップ

```bash
> TDDセットアップ
# または「onboard」

# 自動で以下を実行:
# - フレームワーク検出
# - CLAUDE.md 生成
# - docs/ 構造作成
```

### 3. 開発開始

```bash
> ログイン機能を追加したい

# 自動的にTDDサイクルが始まる:
# INIT → PLAN → RED → GREEN → REFACTOR → REVIEW → COMMIT
```

## Installation

```bash
# マーケットプレイスを登録
/plugin marketplace add morodomi/tdd-skills

# TDDワークフローをインストール
/plugin install tdd-core@tdd-skills

# 言語別品質ツール（いずれかを選択）
/plugin install tdd-php@tdd-skills      # PHP / Laravel
/plugin install tdd-python@tdd-skills   # Python
/plugin install tdd-ts@tdd-skills       # TypeScript
/plugin install tdd-js@tdd-skills       # JavaScript
/plugin install tdd-hugo@tdd-skills     # Hugo SSG
/plugin install tdd-flutter@tdd-skills  # Flutter / Dart
```

## Update

```bash
/plugin marketplace update tdd-skills
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

| Plugin | Target | Tools |
|--------|--------|-------|
| **tdd-core** | 全言語共通 | TDD 7フェーズワークフロー |
| **tdd-php** | PHP / Laravel | PHPStan, Pint, PHPUnit/Pest |
| **tdd-python** | Python | pytest, mypy, Black |
| **tdd-ts** | TypeScript | tsc, ESLint, Jest/Vitest |
| **tdd-js** | JavaScript | ESLint, Prettier, Jest |
| **tdd-hugo** | Hugo SSG | hugo build, htmltest |
| **tdd-flutter** | Flutter / Dart | dart analyze, flutter test |

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

## Links

- [紹介記事（note.com）](https://note.com/morodomi/n/n5b089a48fe7b)
- [Claude Code Skills](https://docs.anthropic.com/en/docs/claude-code/skills)
- [anthropics/skills](https://github.com/anthropics/skills)
