#!/usr/bin/env bash

################################################################################
# ClaudeSkills TDD Framework Installer for Flask
################################################################################
#
# このスクリプトは、既存のFlaskプロジェクトにClaudeSkills TDD環境を導入します。
#
# 使用方法:
#   cd /path/to/your-flask-project
#   bash /path/to/ClaudeSkills/templates/flask/install.sh
#
# MCPインストールをスキップする場合:
#   bash /path/to/ClaudeSkills/templates/flask/install.sh --skip-mcp
#
# または（公開後）:
#   curl -fsSL https://raw.githubusercontent.com/yourname/ClaudeSkills/main/templates/flask/install.sh | bash
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
echo "for Flask/Python"
echo "=========================================="
echo ""

################################################################################
# 1. 環境チェック
################################################################################

echo "環境チェック中..."

# Flaskプロジェクトか確認
IS_FLASK=false

# app.py または wsgi.py が存在するか
if [ -f "app.py" ] || [ -f "wsgi.py" ]; then
    IS_FLASK=true
fi

# requirements.txt に flask が含まれているか
if [ -f "requirements.txt" ] && grep -qi "flask" requirements.txt; then
    IS_FLASK=true
fi

# pyproject.toml に flask が含まれているか
if [ -f "pyproject.toml" ] && grep -qi "flask" pyproject.toml; then
    IS_FLASK=true
fi

if [ "$IS_FLASK" = false ]; then
    echo -e "${RED}✗ エラー: Flaskプロジェクトが検出されませんでした。${NC}"
    echo ""
    echo "確認方法:"
    echo "  - app.py または wsgi.py が存在するか"
    echo "  - requirements.txt または pyproject.toml に flask が含まれるか"
    echo ""
    read -p "Flaskプロジェクトでなくても続行しますか？ (y/N): " -n 1 -r || true
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "インストールを中断しました。"
        exit 0
    fi
    echo ""
fi

echo -e "${GREEN}✓ Flaskプロジェクトを検出しました。${NC}"
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
    echo -e "${GREEN}✓ グローバルcode-reviewコマンドを ~/.claude/commands/ にインストールしました。${NC}"
else
    echo -e "${YELLOW}⚠ 警告: グローバルcode-reviewコマンドが見つかりません。スキップします。${NC}"
fi

# test-agentコマンドもインストール
if [ -f "$SCRIPT_DIR/../../.claude/commands/test-agent.md" ]; then
    cp "$SCRIPT_DIR/../../.claude/commands/test-agent.md" "$GLOBAL_COMMANDS_DIR/"
    echo -e "${GREEN}✓ グローバルtest-agentコマンドを ~/.claude/commands/ にインストールしました。${NC}"
else
    echo -e "${YELLOW}⚠ 警告: グローバルtest-agentコマンドが見つかりません。スキップします。${NC}"
fi

# tdd-onboardコマンドもインストール
if [ -f "$SCRIPT_DIR/../../.claude/commands/tdd-onboard.md" ]; then
    cp "$SCRIPT_DIR/../../.claude/commands/tdd-onboard.md" "$GLOBAL_COMMANDS_DIR/"
    echo -e "${GREEN}✓ グローバルtdd-onboardコマンドを ~/.claude/commands/ にインストールしました。${NC}"
else
    echo -e "${YELLOW}⚠ 警告: グローバルtdd-onboardコマンドが見つかりません。スキップします。${NC}"
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
    echo -e "${GREEN}✓ グローバルux-design Skillを ~/.claude/skills/ux-design/ にインストールしました。${NC}"
else
    echo -e "${YELLOW}⚠ 警告: ux-design Skillが見つかりません。スキップします。${NC}"
fi
echo ""

################################################################################
# 5. agent_docs/ コピー（Progressive Disclosure）
################################################################################

echo "agent_docs/ を作成中..."

mkdir -p agent_docs

# 共通ファイルのコピー（tdd_workflow.md）
COMMON_AGENT_DOCS="$SCRIPT_DIR/../_common/agent_docs"
if [ -d "$COMMON_AGENT_DOCS" ]; then
    cp "$COMMON_AGENT_DOCS/tdd_workflow.md" agent_docs/ 2>/dev/null || true
fi

# Flask固有ファイルのコピー
FLASK_AGENT_DOCS="$SCRIPT_DIR/agent_docs"
if [ -d "$FLASK_AGENT_DOCS" ]; then
    cp "$FLASK_AGENT_DOCS"/*.md agent_docs/ 2>/dev/null || true
fi

echo -e "${GREEN}✓ agent_docs/ を作成しました。${NC}"
echo "  - tdd_workflow.md（TDDワークフロー詳細）"
echo "  - testing_guide.md（pytestテストガイド）"
echo "  - quality_standards.md（mypy, black, ruff品質基準）"
echo "  - commands.md（pytest, mypy, black, ruffコマンド一覧）"
echo ""

################################################################################
# 5-2. docs/cycles/.gitkeep 作成
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
echo "  - .claude/skills/tdd-*/SKILL.md（TDD各フェーズ）"
echo "  - agent_docs/（Progressive Disclosure用詳細ドキュメント）"
echo "    - tdd_workflow.md"
echo "    - testing_guide.md"
echo "    - quality_standards.md"
echo "    - commands.md"
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
echo "2. 新しい機能開発を開始するには:"
echo "   「init」または「/tdd-init」と入力"
echo ""
echo "3. TDDワークフロー:"
echo "   INIT → PLAN → RED → GREEN → REFACTOR → REVIEW → COMMIT"
echo ""
echo "4. 品質チェックコマンド:"
echo "   pytest -v                           # テスト実行"
echo "   pytest --cov=app --cov-report=term  # カバレッジ"
echo "   mypy app/ --strict                  # 静的解析"
echo "   black app/ tests/                   # フォーマット"
echo "   ruff check app/                     # リント"
echo ""
echo "5. MCP統合（Git/GitHub操作の自動化）:"
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
echo "  - README.md: フレームワークの概要（ClaudeSkillsリポジトリ）"
if [[ "$1" != "--skip-mcp" ]]; then
echo "  - docs/MCP_INSTALLATION.md: MCP設定とトラブルシューティング"
fi
echo ""
echo "=========================================="
echo ""
