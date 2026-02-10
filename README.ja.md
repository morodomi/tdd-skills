# TDD Skills

Claude Code で厳格な TDD ワークフローを実現するプラグイン

> **v5.1.1**: Agent Memory - レビューエージェントがプロジェクト固有の知識をセッション跨ぎで蓄積

[English](README.md)

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

# 言語別品質ツール（プロジェクトに合わせて選択）
/plugin install tdd-php@tdd-skills       # PHP
/plugin install tdd-laravel@tdd-skills   # Laravel
/plugin install tdd-wordpress@tdd-skills # WordPress / Bedrock
/plugin install tdd-python@tdd-skills    # Python
/plugin install tdd-flask@tdd-skills     # Flask
/plugin install tdd-ts@tdd-skills        # TypeScript
/plugin install tdd-js@tdd-skills        # JavaScript
/plugin install tdd-hugo@tdd-skills      # Hugo SSG
/plugin install tdd-flutter@tdd-skills   # Flutter / Dart

# 複数言語プロジェクト（例: Laravel + Alpine.js）
/plugin install tdd-php@tdd-skills
/plugin install tdd-js@tdd-skills
```

## Migration

### v5.1.0 → v5.1.1

**新機能**: Agent Memory
- 6エージェント (security/performance/correctness/guidelines-reviewer + socrates + architect) に `memory: project` を追加
- エージェントがプロジェクト固有のドメイン知識をセッション跨ぎで蓄積（脆弱性パターン、パフォーマンスボトルネック、コーディング規約等）
- `.claude/agent-memory/<name>/` に保存、Git共有可能
- ワーカーエージェント (red-worker, green-worker, refactorer) と scope-reviewer はクリーンな状態維持のため除外
- 破壊的変更なし

### v5.0 → v5.1.0

**新機能**: Socrates Devil's Advocate Advisor
- plan-review/quality-gate で WARN/BLOCK 時に Socrates Advisor が反論・代替案を提示
- ユーザーは自由入力で判断（proceed/fix/abort）
- Socrates 無応答時は v5.0 ロジックに自動フォールバック

### v4.3 → v5.0.0

**新機能**: PdM Delegation Model
- Claude が PdM として振る舞い、設計・実装・レビューを専門エージェントに委譲
- `tdd-orchestrate`: フルサイクル自律管理の内部スキル
- Agent Teams 有効時に `tdd-init` から自動ルーティング

### v4.2 → v4.3.0

**新機能**: Agent Teams Integration
- quality-gate: `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` による討論型レビュー
- tdd-diagnose: 並列バグ仮説調査（tdd-init 高リスク時に自動起動）
- tdd-parallel: クロスレイヤー並列開発オーケストレータ
- 破壊的変更なし、全機能は追加のみ

### v4.0 → v4.2.0

**新機能**: Auto Phase Transition, Multi-Perspective Review
- TDDフェーズ間の自動スキル実行
- plan-review: 5エージェント並行レビュー
- quality-gate: 6エージェント並行レビュー（必須化）

### v3.x → v4.0.0

**新機能**: RED Parallelization
- red-workerエージェントによる並列テスト作成
- 追加設定不要、自動的に有効化

### v2.x → v3.0.0

**新機能**: Question-Driven TDD（リスクベース質問フロー）
- 追加設定不要、自動的に有効化

### v1.x → v2.0

[Migration Guide](docs/MIGRATION.md) を参照。
**主な変更**: `agent_docs/` → `.claude/rules/`, `.claude/hooks/` 構造に変更

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
| INIT | tdd-init | サイクルドキュメント作成、スコープ確認 |
| PLAN | tdd-plan | 設計・計画 |
| RED | tdd-red | 失敗するテスト作成（並列実行） |
| GREEN | tdd-green | 最小限の実装（並列実行） |
| REFACTOR | tdd-refactor | コード改善 |
| REVIEW | tdd-review | 品質チェック |
| COMMIT | tdd-commit | Git commit |

## Agent Teams Integration (v4.3.0)

`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` 有効時:

| 機能 | Agent Teams 無効時 | Agent Teams 有効時 |
|------|-------------------|-------------------|
| **quality-gate** | 6エージェント並行 (subagent) | 討論モード (反証・補強) |
| **tdd-diagnose** | Explore エージェント並行調査 | チーム討論型調査 |
| **tdd-parallel** | 利用不可 (逐次実行にフォールバック) | クロスレイヤー並列開発 |

### tdd-diagnose (バグ調査)

```
バグ報告 → 仮説生成 → 並列調査 → 根本原因特定
                         |
          調査員 1: 「認証の競合状態」
          調査員 2: 「キャッシュ無効化の問題」
          調査員 3: 「DB接続タイムアウト」
                         |
                    討論・反証 → 根本原因特定
```

### tdd-parallel (クロスレイヤー開発)

```
INIT → PLAN → [tdd-parallel] → REVIEW → COMMIT
                    |
         Teammate A: Backend  (RED→GREEN→REFACTOR)
         Teammate B: Frontend (RED→GREEN→REFACTOR)
         Teammate C: Database (RED→GREEN→REFACTOR)
                    |
             統合テスト → 全て GREEN
```

## Parallel Execution (v3.3 & v4.0)

```
Test List: TC-01, TC-02, TC-03, TC-04
  |
  v
REDフェーズ (v4.0):
  Worker 1: TC-01, TC-02 → tests/AuthTest.php
  Worker 2: TC-03, TC-04 → tests/UserTest.php
  |
  v
GREENフェーズ (v3.3):
  Worker 1: TC-01, TC-02 → src/Auth.php
  Worker 2: TC-03, TC-04 → src/User.php
```

## Question-Driven TDD (v3.0.0)

リスクスコアに基づいて、適切な質問を自動生成:

```
ユーザー入力 → リスク判定 → 質問フロー → 設計精度向上
```

### Risk Score

| Score | Result | Action |
|-------|--------|--------|
| 0-29 | PASS | 自動進行 |
| 30-59 | WARN | スコープ確認 |
| 60-100 | BLOCK | リスクタイプ別質問 |

### Risk Types (BLOCK時の質問)

| Type | Keywords | Questions |
|------|----------|-----------|
| Security | 認証, ログイン, 権限 | 認証方式, 2FA, 対象ユーザー |
| External API | API, webhook, 決済 | API認証, エラー処理, レート制限 |
| Data Changes | DB, マイグレーション | 既存データ影響, ロールバック |

## Brainstorm Enhancement (v3.1.0)

高リスク時（BLOCK）に問題の本質を深掘り:

### Brainstorm Questions

BLOCK時、リスクタイプ別質問の**前に**問題を明確化:

| Question | Purpose |
|----------|---------|
| 本当に解決したい問題は何？ | 過剰設計の防止 |
| 代替アプローチは検討した？ | 最適解の選択 |

### Task Granularity (PLAN Phase)

各タスクは「2-5分で完了する1アクション」に分割:

| 粒度 | 判断 | 対応 |
|------|------|------|
| 2-5分 | 適切 | そのまま |
| 5分超 | 大きすぎ | 分割する |
| 2分未満 | 小さすぎ | 統合を検討 |

Reference: [superpowers](https://github.com/obra/superpowers)

## Roadmap

次のバージョンは検討中です。フィードバックや要望は [GitHub Issues](https://github.com/morodomi/tdd-skills/issues) へ。

## Plugins

| Plugin | Target | Tools |
|--------|--------|-------|
| **tdd-core** | 全言語共通 | TDD 7フェーズワークフロー |
| **tdd-php** | PHP | PHPStan, Pint, PHPUnit/Pest |
| **tdd-laravel** | Laravel | Larastan, Pint, Pest |
| **tdd-wordpress** | WordPress / Bedrock | phpstan-wordpress, WPCS, PHPUnit |
| **tdd-python** | Python | pytest, mypy, Black |
| **tdd-flask** | Flask | pytest-flask, mypy, Black |
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

## Cross-Platform Compatibility

これらのスキルは Claude Code 以外の AI コーディングツールでも利用可能です。

| CLI Tool | Compatibility | Notes |
|----------|---------------|-------|
| **Claude Code** | Native | `.claude/skills/` |
| **GitHub Copilot CLI** | Auto-detect | `.claude/skills/` を自動認識 |
| **OpenAI Codex CLI** | Compatible | 同じ SKILL.md 形式 |
| **Gemini CLI** | Via Extensions | 変換ツールで対応可能 |

### GitHub Copilot CLI

```bash
# .claude/skills/ を自動で認識
# 追加設定不要
```

### OpenAI Codex CLI

```bash
codex --enable skills
# ~/.codex/skills/ にスキルを配置
```

### Gemini CLI

```bash
# GEMINI.md または Extensions として利用
# Claude Skills → Gemini Extensions 変換ツールあり
```

**参考:**
- [GitHub Copilot Agent Skills](https://github.blog/changelog/2025-12-18-github-copilot-now-supports-agent-skills/)
- [OpenAI Codex Skills](https://developers.openai.com/codex/skills/)
- [Gemini CLI Extensions](https://blog.google/technology/developers/gemini-cli-extensions/)

## License

[MIT](LICENSE)

## Related Projects

- [redteam-skills](https://github.com/morodomi/redteam-skills) - セキュリティ監査自動化プラグイン（Red Team）

## Links

- [紹介記事（note.com）](https://note.com/morodomi/n/n5b089a48fe7b)
- [Claude Code Skills](https://docs.anthropic.com/en/docs/claude-code/skills)
- [anthropics/skills](https://github.com/anthropics/skills)
