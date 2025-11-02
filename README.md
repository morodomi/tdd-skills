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

### インストール

既存のプロジェクトにTDD環境を導入:

#### Laravelプロジェクト

**ローカルインストール（開発中）**:
```bash
cd /path/to/your-laravel-project
bash /path/to/ClaudeSkills/templates/laravel/install.sh
```

**リモートインストール（公開後）**:
```bash
cd your-laravel-project
curl -fsSL https://raw.githubusercontent.com/yourname/ClaudeSkills/main/templates/laravel/install.sh | bash
```

#### その他のフレームワーク（未実装）

```bash
# Django プロジェクトの場合（未実装）
cd your-django-project
curl -fsSL https://raw.githubusercontent.com/yourname/ClaudeSkills/main/templates/django/install.sh | bash

# Flask プロジェクトの場合（未実装）
cd your-flask-project
curl -fsSL https://raw.githubusercontent.com/yourname/ClaudeSkills/main/templates/flask/install.sh | bash
```

### 使い方

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

### 現在のフェーズ: 継続改善フェーズ

- [完了] 要件定義完了
- [完了] Claude Skills/MCP調査完了
- [完了] TDD vs Spec駆動開発の比較完了
- [完了] インストール戦略決定
- [完了] tdd-plan Skill実装完了
- [完了] tdd-red Skill実装完了
- [完了] tdd-green Skill実装完了
- [完了] tdd-refactor Skill実装完了
- [完了] tdd-review Skill実装完了
- [完了] tdd-init Skill実装完了
- [完了] Laravel用TDD Skills全て実装完了
- [完了] install.sh実装完了
- [完了] Phase 1: コアフレームワーク完了
- [完了] tdd-red Skill改善: Laravel固有ルール追加（2025-10-28）
- [完了] tdd-red Skill改善: 大規模プロジェクト向け高速化ガイド追加（2025-10-28）
- [完了] TDDドキュメントファイル形式変更: 時系列管理 + 機能名自動生成（2025-10-28）
- [完了] テストディレクトリ構造ガイド追加: tdd-plan/red/greenにディレクトリ配置推奨を追加（2025-10-29）
- [完了] フェーズ自動遷移機能追加: 各Skill完了時に次のフェーズを自動起動（2025-10-31）
- [完了] Phase 3A: 基盤MCP統合（Git, Filesystem, GitHub MCP）（2025-10-31）

### ロードマップ

#### Phase 1: コアフレームワーク ✅ **完了**
- [完了] Laravel用テンプレート作成
  - [完了] tdd-init Skill実装
  - [完了] tdd-plan Skill実装
  - [完了] tdd-red Skill実装
  - [完了] tdd-green Skill実装
  - [完了] tdd-refactor Skill実装
  - [完了] tdd-review Skill実装
  - [完了] install.sh実装
- [完了] tdd-red Skill改善（Laravel固有ルール + 大規模プロジェクト高速化）
- [完了] TDDドキュメントファイル形式変更
  - [完了] 時系列ファイル名形式（docs/YYYYMMDD_hhmm_<機能名>.md）
  - [完了] 機能名自動生成機能
  - [完了] 統合ドキュメント（1機能 = 1ファイル）
  - [完了] 複数機能並行開発対応
- [完了] テストディレクトリ構造ガイド追加
  - [完了] tdd-planにセクション7追加（ディレクトリ構造の計画）
  - [完了] tdd-redにセクション2.1.1追加（ディレクトリ構造の決定）
  - [完了] tdd-greenにセクション2.0追加（ディレクトリ構造の確認）
  - [完了] 機能領域別サブディレクトリ推奨（User/, Product/, Order/）
  - [完了] 小規模 vs 大規模プロジェクト判断基準（10ファイル）
- [完了] フェーズ自動遷移機能追加
  - [完了] tdd-init完了時にtdd-planを自動起動
  - [完了] tdd-plan完了時にtdd-redを自動起動
  - [完了] tdd-red完了時にtdd-greenを自動起動
  - [完了] tdd-green完了時にtdd-refactorを自動起動
  - [完了] tdd-refactor完了時にtdd-reviewを自動起動
  - [完了] ユーザーによる手動コマンド入力が不要に
- [完了] 既存Laravelプロジェクトでテスト（フェーズ自動遷移の検証）完了

#### Phase 2: 他フレームワーク対応
- [未] Django用テンプレート
- [未] Flask用テンプレート
- [未] WordPress用テンプレート

#### Phase 3: MCP統合
- [完了] Phase 3A: 基盤MCP統合
  - [完了] Git MCP統合（コミット操作自動化）
  - [完了] Filesystem MCP統合（ファイル操作の安全性向上）
  - [完了] GitHub MCP統合（PR作成準備）
  - [完了] MCPインストールスクリプト作成（scripts/install-mcp.sh）
  - [完了] MCPインストールガイド作成（docs/MCP_INSTALLATION.md）
  - [完了] tdd-commit Skill実装（Git MCP活用）
- [未] Phase 3B: 言語別MCP統合
  - [未] Python (uv環境): Ruff MCP + pytest MCP
  - [未] PHP (Laravel環境): PHPStan MCP + PHPUnit/Pest MCP（オプション）

#### Phase 4: 公開
- [未] ドキュメント整備
- [未] サンプルプロジェクト作成
- [未] 公開リポジトリ化

## ドキュメント

### プロジェクト設定
- [CLAUDE.md](CLAUDE.md) - Claude Code用プロジェクト設定

### 設計ドキュメント

詳細な設計ドキュメントは `docs/` ディレクトリを参照してください:

- [要件定義書](docs/20251022_1328_要件定義.md) - プロジェクトの目的、目標、機能要件
- [SkillsMCP調査](docs/20251022_1443_SkillsMCP調査.md) - Claude SkillsとMCPの調査結果
- [TDDとSpec駆動比較](docs/20251022_1609_TDDとSpec駆動比較.md) - TDDとBDD/Spec駆動開発の比較
- [インストール戦略比較](docs/20251023_1124_インストール戦略比較.md) - グローバル vs プロジェクト固有インストールの比較
- [tdd-plan実装計画](docs/20251023_1432_tdd-plan実装計画.md) - tdd-plan Skillの実装計画
- [tdd-planテストケース](docs/20251023_1627_tdd-planテストケース.md) - tdd-plan Skillの手動テストケース
- [tdd-red実装計画](docs/20251024_1641_tdd-red実装計画.md) - tdd-red Skillの実装計画
- [tdd-redテストケース](docs/20251024_1700_tdd-redテストケース.md) - tdd-red Skillの手動テストケース
- [品質基準追加実装計画](docs/20251026_0000_品質基準追加実装計画.md) - 諸富氏の判断基準に基づく品質基準の追加
- [tdd-green実装計画](docs/20251027_0000_tdd-green実装計画.md) - tdd-green Skillの実装計画
- [tdd-greenテストケース](docs/20251027_0015_tdd-greenテストケース.md) - tdd-green Skillの手動テストケース
- [tdd-refactor実装計画](docs/20251027_0030_tdd-refactor実装計画.md) - tdd-refactor Skillの実装計画
- [tdd-refactorテストケース](docs/20251027_0045_tdd-refactorテストケース.md) - tdd-refactor Skillの手動テストケース
- [tdd-review実装計画](docs/20251027_0100_tdd-review実装計画.md) - tdd-review Skillの実装計画
- [tdd-reviewテストケース](docs/20251027_0115_tdd-reviewテストケース.md) - tdd-review Skillの手動テストケース
- [tdd-init実装計画](docs/20251027_0130_tdd-init実装計画.md) - tdd-init Skillの実装計画
- [tdd-initテストケース](docs/20251027_0145_tdd-initテストケース.md) - tdd-init Skillの手動テストケース
- [install実装計画](docs/20251027_0200_install実装計画.md) - install.shの実装計画
- [installテストケース](docs/20251027_0215_installテストケース.md) - install.shの手動テストケース
- [Laravel固有ルール追加実装計画](docs/tdd/PLAN.md) - tdd-red SkillへのLaravel固有ルールと大規模プロジェクト高速化ガイド追加
- [MCP統合調査](docs/20251031_1500_MCP統合調査.md) - uv, Ruff, pytest等のベストプラクティスとMCPサーバー調査
- [Phase 3A基盤MCP統合](docs/20251031_2251_Phase3A基盤MCP統合.md) - Git/Filesystem/GitHub MCP統合の実装ドキュメント

### MCPインストールガイド
- [MCP Installation Guide](docs/MCP_INSTALLATION.md) - MCPサーバーのインストール・設定手順

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

*最終更新: 2025-10-31*
*開発状況: ✅ Phase 1完了 + 改善継続中 - Laravel用コアフレームワーク実装完了（Skills 6/6 + install.sh）+ tdd-red Skill改善（Laravel固有ルール + 大規模プロジェクト高速化）+ TDDドキュメントファイル形式変更（時系列管理 + 機能名自動生成）+ テストディレクトリ構造ガイド追加（3 Skills改善）+ フェーズ自動遷移機能追加（5 Skills改善）*
