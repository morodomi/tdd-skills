#!/bin/bash
# Test: B項目（CLAUDE.md テンプレートへの取り込み）
# TC-06 ~ TC-10

# Don't exit on error - we want to run all tests

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

PASSED=0
FAILED=0

pass() {
    echo -e "${GREEN}PASS${NC}: $1"
    ((PASSED++))
}

fail() {
    echo -e "${RED}FAIL${NC}: $1"
    ((FAILED++))
}

echo "========================================"
echo "Testing B項目: CLAUDE.md テンプレート"
echo "========================================"
echo ""

# Template paths
GENERIC_CLAUDE="$PROJECT_ROOT/templates/generic/CLAUDE.md.example"
LARAVEL_CLAUDE="$PROJECT_ROOT/templates/laravel/CLAUDE.md.template"
BEDROCK_CLAUDE="$PROJECT_ROOT/templates/bedrock/CLAUDE.md.example"

# TC-06: generic CLAUDE.md に B1（出力フォーマット制御）セクションがある
echo "TC-06: generic CLAUDE.md に B1（出力フォーマット制御）セクションがある"
if grep -qE "出力フォーマット|マークダウン.*過多|CLI.*可読性|Output.*Format" "$GENERIC_CLAUDE"; then
    pass "TC-06: generic CLAUDE.md に出力フォーマット制御がある"
else
    fail "TC-06: generic CLAUDE.md に出力フォーマット制御がない"
fi

# TC-07: generic CLAUDE.md に B2（サンプル注意喚起）がある
echo "TC-07: generic CLAUDE.md に B2（サンプル注意喚起）がある"
if grep -qE "例示.*影響|サンプル.*注意|Example.*affect|注意.*動作に影響" "$GENERIC_CLAUDE"; then
    pass "TC-07: generic CLAUDE.md にサンプル注意喚起がある"
else
    fail "TC-07: generic CLAUDE.md にサンプル注意喚起がない"
fi

# TC-08: generic CLAUDE.md に B3（長期タスク管理）セクションがある
echo "TC-08: generic CLAUDE.md に B3（長期タスク管理）セクションがある"
if grep -qE "複数セッション|長期タスク|セッション再開|状態.*追跡" "$GENERIC_CLAUDE"; then
    pass "TC-08: generic CLAUDE.md に長期タスク管理がある"
else
    fail "TC-08: generic CLAUDE.md に長期タスク管理がない"
fi

# TC-09: laravel CLAUDE.md に B1, B2, B3 がある
echo "TC-09: laravel CLAUDE.md に B1, B2, B3 がある"
B1_LARAVEL=$(grep -cE "出力フォーマット|マークダウン.*過多|CLI.*可読性" "$LARAVEL_CLAUDE" 2>/dev/null | tr -d '\n' || echo "0")
B2_LARAVEL=$(grep -cE "例示.*影響|サンプル.*注意|注意.*動作に影響" "$LARAVEL_CLAUDE" 2>/dev/null | tr -d '\n' || echo "0")
B3_LARAVEL=$(grep -cE "複数セッション|長期タスク|セッション再開|状態.*追跡" "$LARAVEL_CLAUDE" 2>/dev/null | tr -d '\n' || echo "0")
if [ "$B1_LARAVEL" -gt 0 ] && [ "$B2_LARAVEL" -gt 0 ] && [ "$B3_LARAVEL" -gt 0 ]; then
    pass "TC-09: laravel CLAUDE.md に B1, B2, B3 がある"
else
    fail "TC-09: laravel CLAUDE.md に B1($B1_LARAVEL), B2($B2_LARAVEL), B3($B3_LARAVEL) が不足"
fi

# TC-10: bedrock CLAUDE.md に B1, B2, B3 がある
echo "TC-10: bedrock CLAUDE.md に B1, B2, B3 がある"
B1_BEDROCK=$(grep -cE "出力フォーマット|マークダウン.*過多|CLI.*可読性" "$BEDROCK_CLAUDE" 2>/dev/null | tr -d '\n' || echo "0")
B2_BEDROCK=$(grep -cE "例示.*影響|サンプル.*注意|注意.*動作に影響" "$BEDROCK_CLAUDE" 2>/dev/null | tr -d '\n' || echo "0")
B3_BEDROCK=$(grep -cE "複数セッション|長期タスク|セッション再開|状態.*追跡" "$BEDROCK_CLAUDE" 2>/dev/null | tr -d '\n' || echo "0")
if [ "$B1_BEDROCK" -gt 0 ] && [ "$B2_BEDROCK" -gt 0 ] && [ "$B3_BEDROCK" -gt 0 ]; then
    pass "TC-10: bedrock CLAUDE.md に B1, B2, B3 がある"
else
    fail "TC-10: bedrock CLAUDE.md に B1($B1_BEDROCK), B2($B2_BEDROCK), B3($B3_BEDROCK) が不足"
fi

echo ""
echo "========================================"
echo "B項目 Results: $PASSED passed, $FAILED failed"
echo "========================================"

exit $FAILED
