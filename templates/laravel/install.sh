#!/bin/bash

################################################################################
# ClaudeSkills TDD Framework Installer for Laravel
################################################################################
#
# このスクリプトは、既存のLaravelプロジェクトにClaudeSkills TDD環境を導入します。
#
# 使用方法:
#   cd /path/to/your-laravel-project
#   bash /path/to/ClaudeSkills/templates/laravel/install.sh
#
# または（公開後）:
#   curl -fsSL https://raw.githubusercontent.com/yourname/ClaudeSkills/main/templates/laravel/install.sh | bash
#
################################################################################

set -e  # エラー時に即座に終了

# 色定義
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# スクリプトのディレクトリを取得
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=========================================="
echo "ClaudeSkills TDD Framework Installer"
echo "=========================================="
echo ""

################################################################################
# 1. 環境チェック
################################################################################

echo "環境チェック中..."

# Laravelプロジェクトか確認
if [ ! -f "artisan" ]; then
    echo -e "${RED}✗ エラー: このスクリプトはLaravelプロジェクトのルートディレクトリで実行してください。${NC}"
    echo ""
    echo "確認方法:"
    echo "  - artisanファイルが存在するか"
    echo "  - composer.jsonに\"laravel/framework\"があるか"
    echo ""
    exit 1
fi

if [ ! -f "composer.json" ]; then
    echo -e "${RED}✗ エラー: composer.jsonが見つかりません。${NC}"
    exit 1
fi

# composer.jsonにlaravelが含まれているか確認
if ! grep -q "laravel/framework" composer.json; then
    echo -e "${YELLOW}⚠ 警告: composer.jsonに\"laravel/framework\"が見つかりません。${NC}"
    echo -e "${YELLOW}   Laravelプロジェクトでない可能性があります。${NC}"
    read -p "続行しますか？ (y/N): " -n 1 -r || true
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "インストールを中断しました。"
        exit 0
    fi
fi

echo -e "${GREEN}✓ Laravelプロジェクトを検出しました。${NC}"
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
SKILLS=("tdd-init" "tdd-plan" "tdd-red" "tdd-green" "tdd-refactor" "tdd-review")
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

    if [ -f "$SCRIPT_DIR/CLAUDE.md.template" ]; then
        cp "$SCRIPT_DIR/CLAUDE.md.template" CLAUDE.md
        echo -e "${GREEN}✓ CLAUDE.md を作成しました。${NC}"
    else
        echo -e "${YELLOW}⚠ 警告: CLAUDE.md.template が見つかりません。スキップします。${NC}"
    fi
else
    echo -e "${BLUE}ℹ CLAUDE.md は既に存在するため、スキップしました。${NC}"
fi

echo ""

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
echo "1. Claude Codeを起動してください"
echo ""
echo "2. 新しい機能開発を開始するには:"
echo "   「init」または「/tdd-init」と入力"
echo ""
echo "3. TDDワークフロー:"
echo "   INIT → PLAN → RED → GREEN → REFACTOR → REVIEW → COMMIT"
echo ""
echo "詳細なドキュメント:"
echo "  - CLAUDE.md: プロジェクト設定とガイドライン"
echo "  - README.md: フレームワークの概要（ClaudeSkillsリポジトリ）"
echo ""
echo "=========================================="
echo ""
