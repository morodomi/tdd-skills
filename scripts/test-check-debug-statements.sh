#!/bin/bash
# Test: check-debug-statements.sh
# TC-02, TC-03, TC-04 のテスト

SCRIPT="scripts/check-debug-statements.sh"

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

PASS=0
FAIL=0

test_pass() {
    echo -e "${GREEN}✓${NC} $1"
    ((PASS++))
}

test_fail() {
    echo -e "${RED}✗${NC} $1"
    ((FAIL++))
}

echo "=========================================="
echo "check-debug-statements.sh Tests"
echo "=========================================="
echo ""

# Setup: create temp directory for test files
TMPDIR=$(mktemp -d)
trap "rm -rf $TMPDIR" EXIT

# TC-02: debug文のないファイルで exit 0
echo "clean code without debug statements" > "$TMPDIR/clean.js"
if "$SCRIPT" "$TMPDIR/clean.js" > /dev/null 2>&1; then
    test_pass "TC-02: exit 0 for file without debug statements"
else
    test_fail "TC-02: expected exit 0 for clean file, got exit $?"
fi

# TC-03: console.logを含むファイルで exit 1 + メッセージ
echo "console.log('debug');" > "$TMPDIR/debug.js"
OUTPUT=$("$SCRIPT" "$TMPDIR/debug.js" 2>&1)
EXIT_CODE=$?
if [ "$EXIT_CODE" -eq 1 ] && echo "$OUTPUT" | grep -qi "console.log"; then
    test_pass "TC-03: exit 1 + message for console.log"
else
    test_fail "TC-03: expected exit 1 + console.log message, got exit $EXIT_CODE"
fi

# TC-04: var_dumpを含むファイルで exit 1
echo "<?php var_dump(\$data);" > "$TMPDIR/debug.php"
if ! "$SCRIPT" "$TMPDIR/debug.php" > /dev/null 2>&1; then
    test_pass "TC-04: exit 1 for var_dump"
else
    test_fail "TC-04: expected exit 1 for var_dump file"
fi

echo ""
echo "=========================================="
echo "Results: $PASS passed, $FAIL failed"
echo "=========================================="

if [ "$FAIL" -gt 0 ]; then
    exit 1
fi
