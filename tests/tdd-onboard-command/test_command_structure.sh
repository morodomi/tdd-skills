#!/usr/bin/env bash

################################################################################
# TDD Onboard Command - Structure Tests (TC-01 to TC-09)
################################################################################

set -e

# プロジェクトルートを取得
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# 色定義
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# テスト結果カウンター
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
echo "TDD Onboard Command - Structure Tests"
echo "=========================================="
echo ""

COMMAND_FILE="$PROJECT_ROOT/.claude/commands/tdd-onboard.md"

################################################################################
# TC-01: .claude/commands/tdd-onboard.mdが存在する
################################################################################
echo "TC-01: .claude/commands/tdd-onboard.mdが存在する"

if [ -f "$COMMAND_FILE" ]; then
    FILE_SIZE=$(stat -f%z "$COMMAND_FILE" 2>/dev/null || stat -c%s "$COMMAND_FILE" 2>/dev/null)
    if [ "$FILE_SIZE" -ge 1000 ]; then
        pass "TC-01: tdd-onboard.mdが存在する（$FILE_SIZE bytes）"
    else
        fail "TC-01: tdd-onboard.mdが小さすぎる（$FILE_SIZE bytes）"
    fi
else
    fail "TC-01: tdd-onboard.mdが存在しない: $COMMAND_FILE"
fi

################################################################################
# TC-02: 有効なYAML frontmatterを持つ
################################################################################
echo "TC-02: 有効なYAML frontmatterを持つ（description等）"

if [ -f "$COMMAND_FILE" ]; then
    if head -1 "$COMMAND_FILE" | grep -q "^---$"; then
        if grep -q "^description:" "$COMMAND_FILE"; then
            pass "TC-02: 有効なYAML frontmatter（description）"
        else
            fail "TC-02: descriptionが見つからない"
        fi
    else
        fail "TC-02: YAML frontmatterが見つからない"
    fi
else
    fail "TC-02: ファイルが存在しない"
fi

################################################################################
# TC-03: フレームワーク検出の指示がある
################################################################################
echo "TC-03: フレームワーク検出の指示がある（Laravel/Flask/Django/WordPress）"

if [ -f "$COMMAND_FILE" ]; then
    if grep -qE "フレームワーク.*検出|Laravel|Flask|Django|WordPress|artisan|app\.py|manage\.py|wp-config" "$COMMAND_FILE"; then
        pass "TC-03: フレームワーク検出の指示がある"
    else
        fail "TC-03: フレームワーク検出の指示が見つからない"
    fi
else
    fail "TC-03: ファイルが存在しない"
fi

################################################################################
# TC-04: パッケージマネージャ検出の指示がある
################################################################################
echo "TC-04: パッケージマネージャ検出の指示がある（composer/poetry/uv）"

if [ -f "$COMMAND_FILE" ]; then
    if grep -qE "パッケージ.*マネージャ|composer|poetry|uv\.lock|poetry\.lock" "$COMMAND_FILE"; then
        pass "TC-04: パッケージマネージャ検出の指示がある"
    else
        fail "TC-04: パッケージマネージャ検出の指示が見つからない"
    fi
else
    fail "TC-04: ファイルが存在しない"
fi

################################################################################
# TC-05: テストツール検出の指示がある
################################################################################
echo "TC-05: テストツール検出の指示がある（PHPUnit/Pest/pytest）"

if [ -f "$COMMAND_FILE" ]; then
    if grep -qE "テスト.*ツール|PHPUnit|Pest|pytest|テスト.*検出" "$COMMAND_FILE"; then
        pass "TC-05: テストツール検出の指示がある"
    else
        fail "TC-05: テストツール検出の指示が見つからない"
    fi
else
    fail "TC-05: ファイルが存在しない"
fi

################################################################################
# TC-06: docs/cycles/ 作成の指示がある
################################################################################
echo "TC-06: docs/cycles/ 作成の指示がある"

if [ -f "$COMMAND_FILE" ]; then
    if grep -qE "docs/cycles|ディレクトリ.*作成|mkdir.*docs" "$COMMAND_FILE"; then
        pass "TC-06: docs/cycles/ 作成の指示がある"
    else
        fail "TC-06: docs/cycles/ 作成の指示が見つからない"
    fi
else
    fail "TC-06: ファイルが存在しない"
fi

################################################################################
# TC-07: CLAUDE.md カスタマイズの指示がある
################################################################################
echo "TC-07: CLAUDE.md カスタマイズの指示がある"

if [ -f "$COMMAND_FILE" ]; then
    if grep -qE "CLAUDE\.md|カスタマイズ|テンプレート|変数.*置換" "$COMMAND_FILE"; then
        pass "TC-07: CLAUDE.md カスタマイズの指示がある"
    else
        fail "TC-07: CLAUDE.md カスタマイズの指示が見つからない"
    fi
else
    fail "TC-07: ファイルが存在しない"
fi

################################################################################
# TC-08: 初期チケット発行の指示がある
################################################################################
echo "TC-08: 初期チケット発行の指示がある（project-setup）"

if [ -f "$COMMAND_FILE" ]; then
    if grep -qE "初期.*チケット|project-setup|チケット.*発行|Cycle.*doc" "$COMMAND_FILE"; then
        pass "TC-08: 初期チケット発行の指示がある"
    else
        fail "TC-08: 初期チケット発行の指示が見つからない"
    fi
else
    fail "TC-08: ファイルが存在しない"
fi

################################################################################
# TC-09: ユーザー確認（AskUserQuestion）の指示がある
################################################################################
echo "TC-09: ユーザー確認（AskUserQuestion）の指示がある"

if [ -f "$COMMAND_FILE" ]; then
    if grep -qE "AskUserQuestion|ユーザー.*確認|確認.*ユーザー|対話的" "$COMMAND_FILE"; then
        pass "TC-09: ユーザー確認の指示がある"
    else
        fail "TC-09: ユーザー確認の指示が見つからない"
    fi
else
    fail "TC-09: ファイルが存在しない"
fi

################################################################################
# テスト結果サマリー
################################################################################
echo ""
echo "=========================================="
echo "Test Results Summary"
echo "=========================================="
echo -e "PASS: ${GREEN}${PASS_COUNT}${NC}"
echo -e "FAIL: ${RED}${FAIL_COUNT}${NC}"
echo ""

if [ $FAIL_COUNT -eq 0 ]; then
    echo -e "${GREEN}All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}Some tests failed.${NC}"
    exit 1
fi
