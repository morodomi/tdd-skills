#!/usr/bin/env bash
################################################################################
# UX Design Skill Tests - Template Placement Validation
################################################################################

set -e

# 色定義
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

PASS_COUNT=0
FAIL_COUNT=0

# テスト結果表示
pass() {
    echo -e "${GREEN}✓ PASS${NC}: $1"
    ((PASS_COUNT++)) || true
}

fail() {
    echo -e "${RED}✗ FAIL${NC}: $1"
    ((FAIL_COUNT++)) || true
}

echo "=========================================="
echo "UX Design Skill - Template Placement Tests"
echo "=========================================="
echo ""

################################################################################
# TC-07: Laravel版が正しいパスに配置される
################################################################################
echo "TC-07: Laravel版が正しいパスに配置される"

LARAVEL_SKILL="$PROJECT_ROOT/templates/laravel/.claude/skills/ux-design/SKILL.md"

if [ -f "$LARAVEL_SKILL" ]; then
    # ファイルサイズが妥当か確認（最低1KB）
    FILE_SIZE=$(stat -f%z "$LARAVEL_SKILL" 2>/dev/null || stat -c%s "$LARAVEL_SKILL" 2>/dev/null || echo "0")
    if [ "$FILE_SIZE" -ge 1000 ]; then
        pass "TC-07: Laravel版が正しいパスに配置（$FILE_SIZE bytes）"
    else
        fail "TC-07: Laravel版ファイルが小さすぎる（$FILE_SIZE bytes）"
    fi
else
    fail "TC-07: Laravel版が存在しない: $LARAVEL_SKILL"
fi

################################################################################
# TC-08: Bedrock版が正しいパスに配置される
################################################################################
echo "TC-08: Bedrock版が正しいパスに配置される"

BEDROCK_SKILL="$PROJECT_ROOT/templates/bedrock/.claude/skills/ux-design/SKILL.md"

if [ -f "$BEDROCK_SKILL" ]; then
    FILE_SIZE=$(stat -f%z "$BEDROCK_SKILL" 2>/dev/null || stat -c%s "$BEDROCK_SKILL" 2>/dev/null || echo "0")
    if [ "$FILE_SIZE" -ge 1000 ]; then
        pass "TC-08: Bedrock版が正しいパスに配置（$FILE_SIZE bytes）"
    else
        fail "TC-08: Bedrock版ファイルが小さすぎる（$FILE_SIZE bytes）"
    fi
else
    fail "TC-08: Bedrock版が存在しない: $BEDROCK_SKILL"
fi

################################################################################
# TC-09: Generic版が正しいパスに配置される
################################################################################
echo "TC-09: Generic版が正しいパスに配置される"

GENERIC_SKILL="$PROJECT_ROOT/templates/generic/.claude/skills/ux-design/SKILL.md"

if [ -f "$GENERIC_SKILL" ]; then
    FILE_SIZE=$(stat -f%z "$GENERIC_SKILL" 2>/dev/null || stat -c%s "$GENERIC_SKILL" 2>/dev/null || echo "0")
    if [ "$FILE_SIZE" -ge 1000 ]; then
        pass "TC-09: Generic版が正しいパスに配置（$FILE_SIZE bytes）"
    else
        fail "TC-09: Generic版ファイルが小さすぎる（$FILE_SIZE bytes）"
    fi
else
    fail "TC-09: Generic版が存在しない: $GENERIC_SKILL"
fi

################################################################################
# TC-10: install.shがグローバルインストールオプションを持つ
################################################################################
echo "TC-10: install.shがグローバルインストールオプションを持つ"

LARAVEL_INSTALL="$PROJECT_ROOT/templates/laravel/install.sh"

if [ -f "$LARAVEL_INSTALL" ]; then
    # グローバルインストール関連のコードが含まれているか確認
    if grep -q "ux-design" "$LARAVEL_INSTALL"; then
        if grep -q "\~/.claude/skills\|HOME.*/.claude/skills" "$LARAVEL_INSTALL"; then
            pass "TC-10: install.shがux-designのグローバルインストールオプションを持つ"
        else
            fail "TC-10: install.shにグローバルインストールパス（~/.claude/skills）が見つからない"
        fi
    else
        fail "TC-10: install.shにux-designが含まれていない"
    fi
else
    fail "TC-10: install.shが存在しない: $LARAVEL_INSTALL"
fi

################################################################################
# TC-11: install.sh実行後に~/.claude/skills/ux-design/が存在する
################################################################################
echo "TC-11: install.sh実行後に~/.claude/skills/ux-design/が存在する（シミュレーション）"

# 実際のインストールは行わず、install.shの内容を検証
if [ -f "$LARAVEL_INSTALL" ]; then
    # ux-designディレクトリのコピーコマンドが含まれているか
    if grep -q "cp.*ux-design\|mkdir.*ux-design" "$LARAVEL_INSTALL"; then
        pass "TC-11: install.shにux-designディレクトリコピーコマンドが含まれている"
    else
        fail "TC-11: install.shにux-designディレクトリコピーコマンドが見つからない"
    fi
else
    fail "TC-11: install.shが存在しない"
fi

################################################################################
# 結果サマリー
################################################################################
echo ""
echo "=========================================="
echo "Test Results Summary"
echo "=========================================="
echo -e "PASS: ${GREEN}$PASS_COUNT${NC}"
echo -e "FAIL: ${RED}$FAIL_COUNT${NC}"
echo ""

if [ "$FAIL_COUNT" -eq 0 ]; then
    echo -e "${GREEN}All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}Some tests failed.${NC}"
    exit 1
fi
