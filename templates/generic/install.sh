#!/usr/bin/env bash

################################################################################
# ClaudeSkills TDD Framework Installer (Generic)
################################################################################
#
# このスクリプトは、任意のプロジェクトにClaudeSkills TDD環境を導入します。
#
# 使用方法:
#   cd /path/to/your-project
#   bash /path/to/ClaudeSkills/templates/generic/install.sh
#
# MCPインストールをスキップする場合:
#   bash /path/to/ClaudeSkills/templates/generic/install.sh --skip-mcp
#
# または（公開後）:
#   curl -fsSL https://raw.githubusercontent.com/yourname/ClaudeSkills/main/templates/generic/install.sh | bash
#
################################################################################

set -e  # エラー時に即座に終了

# 色定義
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# スクリプトのディレクトリを取得（bash/zsh互換）
if [ -n "${BASH_SOURCE[0]}" ]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
else
    SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
fi

echo "=========================================="
echo "ClaudeSkills TDD Framework Installer"
echo "=========================================="
echo ""

################################################################################
# 1. 環境チェック
################################################################################

echo "環境チェック中..."

# Gitリポジトリか確認（推奨）
if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    echo -e "${YELLOW}⚠ 警告: このディレクトリはGitリポジトリではありません。${NC}"
    echo ""
    echo "ClaudeSkills TDDフレームワークは、Gitリポジトリでの使用を推奨します。"
    echo ""
    read -p "続行しますか？ (y/N): " -n 1 -r || true
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "インストールを中断しました。"
        echo ""
        echo "Gitリポジトリを初期化する場合:"
        echo "  git init"
        echo "  git add ."
        echo "  git commit -m 'Initial commit'"
        echo ""
        exit 0
    fi
else
    echo -e "${GREEN}✓ Gitリポジトリを検出しました。${NC}"
fi

echo ""

################################################################################
# 2. 既存インストールチェック
################################################################################

if [ -d ".claude/skills" ]; then
    echo -e "${YELLOW}⚠ 警告: .claude/skills/ は既に存在します。${NC}"
    echo ""
    echo "既存のSkillsファイルが上書きされます。"
    echo ""
    read -p "上書きしますか？ (y/N): " -n 1 -r || true
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "インストールを中断しました。"
        echo ""
        echo "既存のインストールをバックアップする場合:"
        echo "  mv .claude .claude.backup.\$(date +%Y%m%d_%H%M%S)"
        echo ""
        exit 0
    fi
    echo ""
fi

################################################################################
# 3. ディレクトリ作成
################################################################################

echo "ディレクトリを作成中..."

# .claude/skills/ ディレクトリ作成
mkdir -p .claude/skills

# docs/tdd/ ディレクトリ作成
mkdir -p docs/tdd

echo -e "${GREEN}✓ ディレクトリを作成しました。${NC}"
echo ""

################################################################################
# 4. Skillsファイルコピー
################################################################################

echo "Skillsファイルをコピー中..."

# ソースディレクトリの存在確認
if [ ! -d "$SCRIPT_DIR/.claude/skills" ]; then
    echo -e "${RED}✗ エラー: ソースディレクトリが見つかりません。${NC}"
    echo "期待されるパス: $SCRIPT_DIR/.claude/skills"
    echo ""
    echo "スクリプトが正しい場所に配置されているか確認してください。"
    exit 1
fi

# すべてのSkillsをコピー
SKILLS=("tdd-init" "tdd-plan" "tdd-red" "tdd-green" "tdd-refactor" "tdd-review" "tdd-commit" "ux-design")
for skill in "${SKILLS[@]}"; do
    if [ -d "$SCRIPT_DIR/.claude/skills/$skill" ]; then
        cp -r "$SCRIPT_DIR/.claude/skills/$skill" .claude/skills/
    else
        echo -e "${YELLOW}⚠ 警告: $skill が見つかりません。スキップします。${NC}"
    fi
done

echo -e "${GREEN}✓ Skillsをコピーしました。${NC}"
echo ""

################################################################################
# 4-2. グローバルcode-reviewコマンドのインストール
################################################################################

echo "グローバルcode-reviewコマンドをインストール中..."

GLOBAL_COMMANDS_DIR="$HOME/.claude/commands"
mkdir -p "$GLOBAL_COMMANDS_DIR"

if [ -f "$SCRIPT_DIR/../../.claude/commands/code-review.md" ]; then
    cp "$SCRIPT_DIR/../../.claude/commands/code-review.md" "$GLOBAL_COMMANDS_DIR/"
    echo -e "${GREEN}✓ グローバルcode-reviewコマンドを ~/.claude/commands/ にインストールしました。${NC}"
else
    echo -e "${YELLOW}⚠ 警告: グローバルcode-reviewコマンドが見つかりません。スキップします。${NC}"
fi
echo ""

################################################################################
# 4-3. グローバルux-design Skillのインストール
################################################################################

echo "グローバルux-design Skillをインストール中..."

GLOBAL_SKILLS_DIR="$HOME/.claude/skills"
mkdir -p "$GLOBAL_SKILLS_DIR/ux-design"

if [ -d "$SCRIPT_DIR/.claude/skills/ux-design" ]; then
    cp -r "$SCRIPT_DIR/.claude/skills/ux-design/" "$GLOBAL_SKILLS_DIR/ux-design/"
    echo -e "${GREEN}✓ グローバルux-design Skillを ~/.claude/skills/ux-design/ にインストールしました。${NC}"
else
    echo -e "${YELLOW}⚠ 警告: ux-design Skillが見つかりません。スキップします。${NC}"
fi
echo ""

################################################################################
# 5. docs/tdd/.gitkeep 作成
################################################################################

echo "docs/tdd/.gitkeep を作成中..."

touch docs/tdd/.gitkeep

echo -e "${GREEN}✓ docs/tdd/.gitkeep を作成しました。${NC}"
echo ""

################################################################################
# 6. CLAUDE.md 処理
################################################################################

if [ ! -f "CLAUDE.md" ]; then
    echo "CLAUDE.md を作成中..."

    if [ -f "$SCRIPT_DIR/CLAUDE.md.example" ]; then
        cp "$SCRIPT_DIR/CLAUDE.md.example" CLAUDE.md
        echo -e "${GREEN}✓ CLAUDE.md を作成しました。${NC}"
        echo ""
        echo -e "${YELLOW}重要: CLAUDE.md をプロジェクト固有の設定に編集してください。${NC}"
        echo "  - プロジェクトタイプ、言語、フレームワークを記入"
        echo "  - テストフレームワークと品質ツールを記入"
        echo "  - プロジェクト固有のルールを追加"
    else
        echo -e "${YELLOW}⚠ 警告: CLAUDE.md.example が見つかりません。スキップします。${NC}"
    fi
else
    echo -e "${BLUE}ℹ CLAUDE.md は既に存在するため、スキップしました。${NC}"
fi

echo ""

################################################################################
# 6.5. MCP統合インストール（オプション）
################################################################################

# コマンドライン引数で --skip-mcp が指定されていない場合、MCPをインストール
if [[ "$1" != "--skip-mcp" ]]; then
    echo "=========================================="
    echo "MCP統合のインストール（推奨）"
    echo "=========================================="
    echo ""
    echo "Git/GitHub MCPを使うとコミット操作が自動化されます。"
    echo ""

    # MCPインストールスクリプトのパス
    MCP_SCRIPT="$SCRIPT_DIR/../../scripts/install-mcp.sh"

    if [ -f "$MCP_SCRIPT" ]; then
        # MCPインストール実行
        if bash "$MCP_SCRIPT"; then
            echo ""
            echo -e "${GREEN}✓ MCP統合も完了しました${NC}"
        else
            echo ""
            echo -e "${YELLOW}⚠ MCP統合でエラーが発生しましたが、テンプレートは正常にインストールされています${NC}"
            echo -e "${YELLOW}  後で手動インストール可能: bash $MCP_SCRIPT${NC}"
        fi
    else
        echo -e "${YELLOW}⚠ MCPインストールスクリプトが見つかりません${NC}"
        echo -e "${YELLOW}  期待されるパス: $MCP_SCRIPT${NC}"
        echo ""
        echo "手動でインストールする場合:"
        echo "  bash /path/to/ClaudeSkills/scripts/install-mcp.sh"
        echo ""
        echo "詳細: docs/MCP_INSTALLATION.md"
    fi
    echo ""
else
    echo "=========================================="
    echo "MCPインストールをスキップ"
    echo "=========================================="
    echo ""
    echo -e "${BLUE}ℹ --skip-mcp フラグが指定されたため、MCPインストールをスキップしました${NC}"
    echo ""
    echo "後でインストールする場合:"
    echo "  bash /path/to/ClaudeSkills/scripts/install-mcp.sh"
    echo ""
    echo "詳細: docs/MCP_INSTALLATION.md"
    echo ""
fi

################################################################################
# 7. 完了メッセージ
################################################################################

echo "=========================================="
echo -e "${GREEN}✓ インストール完了！${NC}"
echo "=========================================="
echo ""
echo "インストールされたファイル:"
echo "  - .claude/skills/tdd-init/SKILL.md"
echo "  - .claude/skills/tdd-plan/SKILL.md"
echo "  - .claude/skills/tdd-plan/templates/PLAN.md.template"
echo "  - .claude/skills/tdd-red/SKILL.md"
echo "  - .claude/skills/tdd-green/SKILL.md"
echo "  - .claude/skills/tdd-refactor/SKILL.md"
echo "  - .claude/skills/tdd-review/SKILL.md"
echo "  - .claude/skills/tdd-commit/SKILL.md"
echo "  - docs/tdd/.gitkeep"

if [ ! -f "CLAUDE.md" ]; then
    echo "  - CLAUDE.md (スキップ: 既存ファイルあり)"
else
    echo "  - CLAUDE.md"
fi

echo ""
echo "=========================================="
echo "次のステップ"
echo "=========================================="
echo ""
echo "1. CLAUDE.md をカスタマイズしてください"
echo "   - プロジェクトタイプ、言語、フレームワークを記入"
echo "   - テストコマンド、品質ツールコマンドを記入"
echo "   - プロジェクト固有のルールを追加"
echo ""
echo "2. Skillsをカスタマイズしてください（必要に応じて）"
echo "   - .claude/skills/tdd-init/SKILL.md: プロジェクト検証ルール"
echo "   - .claude/skills/tdd-red/SKILL.md: テストフレームワーク固有ルール"
echo "   - .claude/skills/tdd-review/SKILL.md: 品質チェックコマンド"
echo ""
echo "3. Claude Codeを起動してください"
echo ""
echo "4. 新しい機能開発を開始するには:"
echo "   「init」または「/tdd-init」と入力"
echo ""
echo "5. TDDワークフロー:"
echo "   INIT → PLAN → RED → GREEN → REFACTOR → REVIEW → COMMIT"
echo ""
echo "6. MCP統合（Git/GitHub操作の自動化）:"
if [[ "$1" == "--skip-mcp" ]]; then
echo "   ⊙ MCPはスキップされました"
echo "   後でインストール: bash /path/to/ClaudeSkills/scripts/install-mcp.sh"
else
echo "   ✓ MCP統合が完了しています"
echo "   - Git MCP: コミット操作の自動化"
echo "   - GitHub MCP: PR作成の準備"
fi
echo ""
echo "詳細なドキュメント:"
echo "  - CLAUDE.md: プロジェクト設定とガイドライン"
echo "  - ClaudeSkills/README.md: フレームワークの概要"
echo "  - ClaudeSkills/docs/GENERIC_INSTALLATION.md: 汎用インストールガイド"
if [[ "$1" != "--skip-mcp" ]]; then
echo "  - ClaudeSkills/docs/MCP_INSTALLATION.md: MCP設定とトラブルシューティング"
fi
echo ""
echo "カスタマイズ例:"
echo "  - Laravel: ClaudeSkills/templates/laravel/"
echo "  - Bedrock/WordPress: ClaudeSkills/templates/bedrock/"
echo ""
echo "=========================================="
echo ""
