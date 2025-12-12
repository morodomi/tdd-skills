#!/usr/bin/env bash

################################################################################
# ClaudeSkills TDD Framework Installer for Hugo
################################################################################
#
# このスクリプトは、既存のHugoプロジェクトにClaudeSkills TDD環境を導入します。
#
# 使用方法:
#   cd /path/to/your-hugo-project
#   bash /path/to/ClaudeSkills/templates/hugo/install.sh
#
# MCPインストールをスキップする場合:
#   bash /path/to/ClaudeSkills/templates/hugo/install.sh --skip-mcp
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
echo "for Hugo"
echo "=========================================="
echo ""

################################################################################
# 1. 環境チェック
################################################################################

echo "環境チェック中..."

# Hugoプロジェクトか確認
IS_HUGO=false

# hugo.toml / config.toml / config.yaml が存在するか
if [ -f "hugo.toml" ] || [ -f "config.toml" ] || [ -f "config.yaml" ] || [ -f "config.json" ]; then
    IS_HUGO=true
fi

# content/ ディレクトリが存在するか
if [ -d "content" ]; then
    IS_HUGO=true
fi

if [ "$IS_HUGO" = false ]; then
    echo -e "${RED}✗ エラー: Hugoプロジェクトが検出されませんでした。${NC}"
    echo ""
    echo "確認方法:"
    echo "  - hugo.toml / config.toml / config.yaml が存在するか"
    echo "  - content/ ディレクトリが存在するか"
    echo ""
    read -p "Hugoプロジェクトでなくても続行しますか？ (y/N): " -n 1 -r || true
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "インストールを中断しました。"
        exit 0
    fi
    echo ""
fi

echo -e "${GREEN}✓ Hugoプロジェクトを検出しました。${NC}"

# Hugo コマンドの確認
if command -v hugo &> /dev/null; then
    HUGO_VERSION=$(hugo version | head -1)
    echo -e "${GREEN}✓ Hugo: $HUGO_VERSION${NC}"
else
    echo -e "${YELLOW}⚠ 警告: hugo コマンドが見つかりません。${NC}"
    echo "  インストール: https://gohugo.io/installation/"
fi

# htmltest コマンドの確認
if command -v htmltest &> /dev/null; then
    echo -e "${GREEN}✓ htmltest: インストール済み${NC}"
else
    echo -e "${YELLOW}⚠ 警告: htmltest コマンドが見つかりません。${NC}"
    echo "  リンク検証を使用する場合はインストールしてください:"
    echo "  - brew install htmltest"
    echo "  - go install github.com/wjdp/htmltest@latest"
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

# docs/cycles/ ディレクトリ作成
mkdir -p docs/cycles

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
# 4-2. グローバルコマンドのインストール
################################################################################

echo "グローバルコマンドをインストール中..."

GLOBAL_COMMANDS_DIR="$HOME/.claude/commands"
mkdir -p "$GLOBAL_COMMANDS_DIR"

if [ -f "$SCRIPT_DIR/../../.claude/commands/code-review.md" ]; then
    cp "$SCRIPT_DIR/../../.claude/commands/code-review.md" "$GLOBAL_COMMANDS_DIR/"
    echo -e "${GREEN}✓ グローバルcode-reviewコマンドをインストールしました。${NC}"
else
    echo -e "${YELLOW}⚠ 警告: code-reviewコマンドが見つかりません。スキップします。${NC}"
fi

if [ -f "$SCRIPT_DIR/../../.claude/commands/test-agent.md" ]; then
    cp "$SCRIPT_DIR/../../.claude/commands/test-agent.md" "$GLOBAL_COMMANDS_DIR/"
    echo -e "${GREEN}✓ グローバルtest-agentコマンドをインストールしました。${NC}"
else
    echo -e "${YELLOW}⚠ 警告: test-agentコマンドが見つかりません。スキップします。${NC}"
fi

if [ -f "$SCRIPT_DIR/../../.claude/commands/tdd-onboard.md" ]; then
    cp "$SCRIPT_DIR/../../.claude/commands/tdd-onboard.md" "$GLOBAL_COMMANDS_DIR/"
    echo -e "${GREEN}✓ グローバルtdd-onboardコマンドをインストールしました。${NC}"
else
    echo -e "${YELLOW}⚠ 警告: tdd-onboardコマンドが見つかりません。スキップします。${NC}"
fi

# プロジェクト固有のworktreeコマンドをインストール
echo "プロジェクト固有のコマンドをインストール中..."
mkdir -p .claude/commands
if [ -f "$SCRIPT_DIR/.claude/commands/worktree.md" ]; then
    cp "$SCRIPT_DIR/.claude/commands/worktree.md" .claude/commands/
    echo -e "${GREEN}✓ /worktree コマンドを .claude/commands/ にインストールしました。${NC}"
else
    echo -e "${YELLOW}⚠ 警告: worktree.md が見つかりません。スキップします。${NC}"
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
    echo -e "${GREEN}✓ グローバルux-design Skillをインストールしました。${NC}"
else
    echo -e "${YELLOW}⚠ 警告: ux-design Skillが見つかりません。スキップします。${NC}"
fi
echo ""

################################################################################
# 5. agent_docs/ コピー
################################################################################

echo "agent_docs/ を作成中..."

mkdir -p agent_docs

# 共通ファイルのコピー（tdd_workflow.md）
COMMON_AGENT_DOCS="$SCRIPT_DIR/../_common/agent_docs"
if [ -d "$COMMON_AGENT_DOCS" ]; then
    cp "$COMMON_AGENT_DOCS/tdd_workflow.md" agent_docs/ 2>/dev/null || true
fi

# Hugo固有ファイルのコピー
HUGO_AGENT_DOCS="$SCRIPT_DIR/agent_docs"
if [ -d "$HUGO_AGENT_DOCS" ]; then
    cp "$HUGO_AGENT_DOCS"/*.md agent_docs/ 2>/dev/null || true
fi

echo -e "${GREEN}✓ agent_docs/ を作成しました。${NC}"
echo "  - tdd_workflow.md（TDDワークフロー詳細）"
echo "  - content_guide.md（コンテンツ作成ガイド）"
echo "  - theme_development.md（テーマ開発ガイド）"
echo "  - commands.md（Hugo コマンド一覧）"
echo ""

################################################################################
# 5-2. .htmltest.yml コピー
################################################################################

echo ".htmltest.yml を作成中..."

if [ ! -f ".htmltest.yml" ]; then
    if [ -f "$SCRIPT_DIR/.htmltest.yml" ]; then
        cp "$SCRIPT_DIR/.htmltest.yml" .htmltest.yml
        echo -e "${GREEN}✓ .htmltest.yml を作成しました。${NC}"
    else
        echo -e "${YELLOW}⚠ 警告: .htmltest.yml テンプレートが見つかりません。スキップします。${NC}"
    fi
else
    echo -e "${BLUE}ℹ .htmltest.yml は既に存在するため、スキップしました。${NC}"
fi
echo ""

################################################################################
# 5-3. docs/cycles/.gitkeep 作成
################################################################################

echo "docs/cycles/.gitkeep を作成中..."

touch docs/cycles/.gitkeep

echo -e "${GREEN}✓ docs/cycles/.gitkeep を作成しました。${NC}"
echo ""

################################################################################
# 6. CLAUDE.md 処理
################################################################################

if [ ! -f "CLAUDE.md" ]; then
    echo "CLAUDE.md を作成中..."

    if [ -f "$SCRIPT_DIR/CLAUDE.md.example" ]; then
        cp "$SCRIPT_DIR/CLAUDE.md.example" CLAUDE.md
        echo -e "${GREEN}✓ CLAUDE.md を作成しました。${NC}"
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

if [[ "$1" != "--skip-mcp" ]]; then
    echo "=========================================="
    echo "MCP統合のインストール（推奨）"
    echo "=========================================="
    echo ""
    echo "Git/GitHub MCPを使うとコミット操作が自動化されます。"
    echo ""

    MCP_SCRIPT="$SCRIPT_DIR/../../scripts/install-mcp.sh"

    if [ -f "$MCP_SCRIPT" ]; then
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
    fi
    echo ""
else
    echo "=========================================="
    echo "MCPインストールをスキップ"
    echo "=========================================="
    echo ""
    echo -e "${BLUE}ℹ --skip-mcp フラグが指定されたため、MCPインストールをスキップしました${NC}"
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
echo "  - .claude/skills/tdd-*/SKILL.md（TDD各フェーズ）"
echo "  - agent_docs/（詳細ドキュメント）"
echo "    - tdd_workflow.md"
echo "    - content_guide.md"
echo "    - theme_development.md"
echo "    - commands.md"
echo "  - .htmltest.yml（リンク検証設定）"
echo "  - docs/cycles/.gitkeep"

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
echo "1. Claude Codeを起動してください"
echo ""
echo "2. 新しいコンテンツ・テーマ開発を開始するには:"
echo "   「init」または「/tdd-init」と入力"
echo ""
echo "3. TDDワークフロー（Hugo向け）:"
echo "   INIT → PLAN → RED → GREEN → REFACTOR → REVIEW → COMMIT"
echo ""
echo "   | フェーズ  | 内容                          |"
echo "   |----------|-------------------------------|"
echo "   | RED      | 期待するページ構造を定義       |"
echo "   | GREEN    | content/, layouts/ 作成       |"
echo "   | REFACTOR | パーシャル分割                |"
echo "   | REVIEW   | hugo build + htmltest        |"
echo ""
echo "4. 品質チェックコマンド:"
echo "   hugo server -D               # 開発サーバー"
echo "   hugo build --gc --minify     # 本番ビルド"
echo "   htmltest ./public            # リンク検証"
echo ""
echo "詳細なドキュメント:"
echo "  - CLAUDE.md: プロジェクト設定とガイドライン"
echo "  - agent_docs/: 詳細なガイド"
echo ""
echo "=========================================="
echo ""
