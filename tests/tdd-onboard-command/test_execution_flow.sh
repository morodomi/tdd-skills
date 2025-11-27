#!/usr/bin/env bash

################################################################################
# TDD Onboard Command - Execution Flow Tests (TC-10 to TC-15)
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
echo "TDD Onboard Command - Execution Flow Tests"
echo "=========================================="
echo ""

COMMAND_FILE="$PROJECT_ROOT/.claude/commands/tdd-onboard.md"

################################################################################
# TC-10: Laravel プロジェクト検出ロジックがある
################################################################################
echo "TC-10: Laravel プロジェクト検出ロジックがある"

if [ -f "$COMMAND_FILE" ]; then
    if grep -qE "artisan|Laravel.*検出|php artisan" "$COMMAND_FILE"; then
        pass "TC-10: Laravel プロジェクト検出ロジックがある"
    else
        fail "TC-10: Laravel プロジェクト検出ロジックが見つからない"
    fi
else
    fail "TC-10: ファイルが存在しない"
fi

################################################################################
# TC-11: Flask プロジェクト検出ロジックがある
################################################################################
echo "TC-11: Flask プロジェクト検出ロジックがある"

if [ -f "$COMMAND_FILE" ]; then
    if grep -qE "app\.py|wsgi\.py|Flask.*検出|flask" "$COMMAND_FILE"; then
        pass "TC-11: Flask プロジェクト検出ロジックがある"
    else
        fail "TC-11: Flask プロジェクト検出ロジックが見つからない"
    fi
else
    fail "TC-11: ファイルが存在しない"
fi

################################################################################
# TC-12: Poetry/uv 検出ロジックがある
################################################################################
echo "TC-12: Poetry/uv 検出ロジックがある"

if [ -f "$COMMAND_FILE" ]; then
    if grep -qE "poetry\.lock|uv\.lock|poetry|uv" "$COMMAND_FILE"; then
        pass "TC-12: Poetry/uv 検出ロジックがある"
    else
        fail "TC-12: Poetry/uv 検出ロジックが見つからない"
    fi
else
    fail "TC-12: ファイルが存在しない"
fi

################################################################################
# TC-13: 既存テスト構造確認ロジックがある
################################################################################
echo "TC-13: 既存テスト構造確認ロジックがある"

if [ -f "$COMMAND_FILE" ]; then
    if grep -qE "tests/|テスト.*構造|Unit|Feature|integration|既存.*テスト" "$COMMAND_FILE"; then
        pass "TC-13: 既存テスト構造確認ロジックがある"
    else
        fail "TC-13: 既存テスト構造確認ロジックが見つからない"
    fi
else
    fail "TC-13: ファイルが存在しない"
fi

################################################################################
# TC-14: カバレッジ測定コマンドが適切
################################################################################
echo "TC-14: カバレッジ測定コマンドが適切"

if [ -f "$COMMAND_FILE" ]; then
    if grep -qE "coverage|--cov|カバレッジ.*測定|php artisan test --coverage|pytest --cov" "$COMMAND_FILE"; then
        pass "TC-14: カバレッジ測定コマンドが適切"
    else
        fail "TC-14: カバレッジ測定コマンドが見つからない"
    fi
else
    fail "TC-14: ファイルが存在しない"
fi

################################################################################
# TC-15: Next Steps 表示がある
################################################################################
echo "TC-15: Next Steps 表示がある"

if [ -f "$COMMAND_FILE" ]; then
    if grep -qE "Next Steps|次のステップ|セットアップ.*完了|tdd-init" "$COMMAND_FILE"; then
        pass "TC-15: Next Steps 表示がある"
    else
        fail "TC-15: Next Steps 表示が見つからない"
    fi
else
    fail "TC-15: ファイルが存在しない"
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
