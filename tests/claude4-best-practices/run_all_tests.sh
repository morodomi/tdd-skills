#!/bin/bash
# Run all tests for Claude 4 Best Practices Integration

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "========================================"
echo "Claude 4 Best Practices Integration Tests"
echo "========================================"
echo ""

TOTAL_PASSED=0
TOTAL_FAILED=0

run_test() {
    local test_file="$1"
    local test_name="$2"

    echo -e "${YELLOW}Running: $test_name${NC}"
    echo ""

    if bash "$test_file"; then
        echo ""
    else
        TOTAL_FAILED=$((TOTAL_FAILED + $?))
    fi
    echo ""
}

# Run all test suites
run_test "$SCRIPT_DIR/test_skills_a_items.sh" "A項目: Skills テスト"
run_test "$SCRIPT_DIR/test_claudemd_b_items.sh" "B項目: CLAUDE.md テスト"
run_test "$SCRIPT_DIR/test_consistency.sh" "一貫性チェック"

echo "========================================"
echo "ALL TESTS COMPLETE"
echo "========================================"

if [ $TOTAL_FAILED -eq 0 ]; then
    echo -e "${GREEN}All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}Some tests failed. Total failures: $TOTAL_FAILED${NC}"
    exit 1
fi
