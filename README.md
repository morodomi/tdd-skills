# ClaudeSkills - TDD Framework for Claude Code

Claude Codeを使った開発における厳格なTDD（Test-Driven Development）ワークフローを実現するためのSkills/MCPフレームワーク

## 概要

**ClaudeSkills**は、生成AIとの協働開発において、要望との乖離を防ぎ、厳格なTDDワークフローを強制することで、品質の高いコードを効率的に生成することを目的としたフレームワークです。

### 主な特徴

- **厳格なフェーズ管理**: INIT → PLAN → RED → GREEN → REFACTOR → REVIEW → COMMIT
- **Claude Skillsによる制約**: 各フェーズで「やって良いこと・ダメなこと」を強制
- **複数フレームワーク対応**: Laravel, Django, Flask, WordPress
- **プロジェクト固有インストール**: `.claude/skills/` に配置してgit管理
- **テンプレートベース**: `install.sh` で既存プロジェクトに簡単導入

### 対象ユーザー

- 個人開発者（将来的にチーム展開も視野）
- TDD開発を実践したい開発者
- Claude Codeで生成AIとの協働開発を行う開発者

## プロジェクト構造

```
ClaudeSkills/
├── CLAUDE.md                    # Claude Code用プロジェクト設定
├── README.md                    # このファイル
├── LICENSE                      # ライセンスファイル（未作成）
│
├── docs/                        # 設計ドキュメント
│   ├── 20251022_1328_要件定義.md
│   ├── 20251022_1443_SkillsMCP調査.md
│   ├── 20251022_1609_TDDとSpec駆動比較.md
│   └── 20251023_1124_インストール戦略比較.md
│
├── templates/                   # 配布用テンプレート（開発中）
│   ├── laravel/
│   │   ├── .claude/
│   │   │   ├── skills/
│   │   │   │   ├── tdd-init/
│   │   │   │   │   └── SKILL.md
│   │   │   │   ├── tdd-plan/
│   │   │   │   │   ├── SKILL.md
│   │   │   │   │   └── templates/
│   │   │   │   │       └── PLAN.md.template
│   │   │   │   ├── tdd-red/
│   │   │   │   │   └── SKILL.md
│   │   │   │   ├── tdd-green/
│   │   │   │   │   └── SKILL.md
│   │   │   │   ├── tdd-refactor/
│   │   │   │   │   └── SKILL.md
│   │   │   │   ├── tdd-review/
│   │   │   │   │   └── SKILL.md
│   │   │   │   └── laravel-quality/
│   │   │   │       ├── SKILL.md
│   │   │   │       └── scripts/
│   │   │   │           ├── phpstan.sh
│   │   │   │           └── pest.sh
│   │   │   └── commands/
│   │   │       ├── tdd-init.md
│   │   │       ├── tdd-plan.md
│   │   │       ├── tdd-red.md
│   │   │       ├── tdd-green.md
│   │   │       ├── tdd-refactor.md
│   │   │       └── tdd-review.md
│   │   ├── CLAUDE.md.template
│   │   └── install.sh
│   │
│   ├── django/                  # Django用テンプレート（未作成）
│   ├── flask/                   # Flask用テンプレート（未作成）
│   └── wordpress/               # WordPress用テンプレート（未作成）
│
└── examples/                    # サンプルプロジェクト（未作成）
    ├── laravel-example/
    ├── django-example/
    └── flask-example/
```

## クイックスタート

### インストール（予定）

既存のプロジェクトにTDD環境を導入:

```bash
# Laravelプロジェクトの場合
cd your-laravel-project
curl -fsSL https://raw.githubusercontent.com/yourname/ClaudeSkills/main/install.sh | bash -s laravel

# Django プロジェクトの場合
cd your-django-project
curl -fsSL https://raw.githubusercontent.com/yourname/ClaudeSkills/main/install.sh | bash -s django
```

### 使い方（予定）

```bash
# 新機能の開発開始
/tdd-init "ユーザー認証機能の追加"

# 計画フェーズ（実装コードを書かない）
/tdd-plan

# テスト作成フェーズ（失敗するテストを書く）
/tdd-red

# 実装フェーズ（最小限の実装でテストを通す）
/tdd-green

# リファクタリングフェーズ（テストを維持しながら改善）
/tdd-refactor

# レビューフェーズ（品質チェック）
/tdd-review

# コミット
git add . && git commit -m "feat: ユーザー認証機能を追加"
```

## TDDワークフロー

```
INIT (初期化)
  ↓
PLAN (計画・docs作成)
  ├─ 実装計画ドキュメント作成
  ├─ アーキテクチャ設計
  └─ テストケース設計
  ↓
PLAN REVIEW (計画レビュー)
  └─ ユーザー承認
  ↓
RED (テスト作成)
  ├─ 失敗するテストを作成
  └─ テスト実行（失敗確認）
  ↓
GREEN (実装)
  ├─ 最小限の実装
  └─ テスト実行（成功確認）
  ↓
REFACTOR (リファクタリング)
  ├─ コード改善
  ├─ 品質チェック（PHPStan/Pest等）
  └─ テスト実行（維持確認）
  ↓
REVIEW (品質検証)
  ├─ コードレビュー
  └─ 総合品質チェック
  ↓
DOC (ドキュメント更新)
  └─ PLAN.mdの更新
  ↓
COMMIT
```

### 各フェーズでの制約

Claude Skillsが各フェーズで以下の制約を強制します:

| フェーズ | 制約 | allowed-tools |
|---------|------|---------------|
| **PLAN** | 実装コードを書かない | `Read, Grep, Glob` |
| **RED** | テストコードのみ書く | `Read, Write, Grep, Glob` |
| **GREEN** | 最小限の実装のみ | `Read, Write, Grep, Glob, Bash` |
| **REFACTOR** | テストを維持しながらリファクタ | すべて |
| **REVIEW** | 品質チェックのみ | `Read, Grep, Bash` |

## 開発状況

### 現在のフェーズ: 要件定義・設計

- ✅ 要件定義完了
- ✅ Claude Skills/MCP調査完了
- ✅ TDD vs Spec駆動開発の比較完了
- ✅ インストール戦略決定
- 📝 テンプレート実装準備中

### ロードマップ

#### Phase 1: コアフレームワーク（現在）
- [ ] Laravel用テンプレート作成
  - [ ] tdd-plan Skill実装
  - [ ] 全フェーズのSkills実装
  - [ ] install.sh実装
- [ ] 既存Laravelプロジェクトでテスト

#### Phase 2: 他フレームワーク対応
- [ ] Django用テンプレート
- [ ] Flask用テンプレート
- [ ] WordPress用テンプレート

#### Phase 3: MCP統合
- [ ] PHPStan MCP
- [ ] PHPUnit/Pest MCP
- [ ] pytest MCP
- [ ] mypy MCP

#### Phase 4: 公開
- [ ] ドキュメント整備
- [ ] サンプルプロジェクト作成
- [ ] 公開リポジトリ化

## ドキュメント

### プロジェクト設定
- [CLAUDE.md](CLAUDE.md) - Claude Code用プロジェクト設定

### 設計ドキュメント

詳細な設計ドキュメントは `docs/` ディレクトリを参照してください:

- [要件定義書](docs/20251022_1328_要件定義.md) - プロジェクトの目的、目標、機能要件
- [SkillsMCP調査](docs/20251022_1443_SkillsMCP調査.md) - Claude SkillsとMCPの調査結果
- [TDDとSpec駆動比較](docs/20251022_1609_TDDとSpec駆動比較.md) - TDDとBDD/Spec駆動開発の比較
- [インストール戦略比較](docs/20251023_1124_インストール戦略比較.md) - グローバル vs プロジェクト固有インストールの比較

## 技術スタック

### 配布形式
- Bash scripts
- Markdown (Claude Skills)
- JSON (設定ファイル)

### 対応フレームワーク

| フレームワーク | 言語 | テストツール | 品質ツール |
|-------------|------|------------|-----------|
| Laravel | PHP | PHPUnit/Pest | PHPStan, Laravel Pint |
| Django | Python | pytest | mypy, black |
| Flask | Python | pytest | mypy, black |
| WordPress | PHP | PHPUnit | WordPress Coding Standards |

### Claude Code統合
- **Claude Skills**: ワークフロー制御、フェーズごとの制約
- **Slash Commands**: ユーザー操作のエントリーポイント
- **MCP (将来)**: PHPStan, PHPUnit等の外部ツール統合
- **CLAUDE.md**: プロジェクト固有の設定

## 貢献

現在は個人開発中のため、外部からの貢献は受け付けていません。
公開後、コントリビューションガイドラインを整備予定です。

## ライセンス

未定（現在検討中）

## 参考資料

- [anthropics/skills](https://github.com/anthropics/skills) - 公式Skillsリポジトリ
- [Claude Code Documentation](https://docs.claude.com/en/docs/claude-code)
- [Model Context Protocol](https://modelcontextprotocol.io/)

---

*最終更新: 2025-10-23*
*開発状況: 要件定義・設計フェーズ*
