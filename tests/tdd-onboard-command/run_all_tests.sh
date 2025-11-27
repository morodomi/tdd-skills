#!/usr/bin/env bash

################################################################################
# TDD Onboard Command - Run All Tests
################################################################################

set -e

# スクリプトのディレクトリを取得
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 色定義
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "=========================================="
echo "Running All TDD Onboard Command Tests"
echo "=========================================="
echo ""

TOTAL_PASS=0
TOTAL_FAIL=0

################################################################################
# Test Suite 1: Command Structure (TC-01 to TC-09)
################################################################################
echo -e "${BLUE}--- Test Suite 1: Command Structure ---${NC}"
echo ""

if bash "$SCRIPT_DIR/test_command_structure.sh"; then
    ((TOTAL_PASS += 9)) || true
else
    # エラー時もカウント（部分的な失敗の場合）
    ((TOTAL_FAIL += 1)) || true
fi

echo ""

################################################################################
# Test Suite 2: Execution Flow (TC-10 to TC-15)
################################################################################
echo -e "${BLUE}--- Test Suite 2: Execution Flow ---${NC}"
echo ""

if bash "$SCRIPT_DIR/test_execution_flow.sh"; then
    ((TOTAL_PASS += 6)) || true
else
    ((TOTAL_FAIL += 1)) || true
fi

echo ""

################################################################################
# Final Summary
################################################################################
echo "=========================================="
echo "Final Test Results"
echo "=========================================="

if [ $TOTAL_FAIL -eq 0 ]; then
    echo -e "${GREEN}All test suites passed!${NC}"
    echo "Total: 15 tests (9 structure + 6 execution flow)"
    exit 0
else
    echo -e "${RED}Some test suites failed.${NC}"
    exit 1
fi
