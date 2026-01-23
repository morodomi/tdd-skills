#!/bin/bash
# Test: tdd-plan Risk Score Integration
# TC-01 ~ TC-06: リスクスコア連動の検証

SKILL_FILE="plugins/tdd-core/skills/tdd-plan/SKILL.md"
REF_FILE="plugins/tdd-core/skills/tdd-plan/reference.md"

echo "================================"
echo "tdd-plan Risk Integration Test"
echo "================================"

PASSED=0
FAILED=0

# Helper function
assert_contains() {
    local file="$1"
    local pattern="$2"
    local test_name="$3"

    if grep -qi "$pattern" "$file" 2>/dev/null; then
        echo "[PASS] $test_name"
        ((PASSED++))
    else
        echo "[FAIL] $test_name"
        echo "       Expected pattern '$pattern' in $file"
        ((FAILED++))
    fi
}

echo ""
echo "--- Step 1.5 Check ---"

# TC-01: Step 1.5が存在するか
assert_contains "$SKILL_FILE" "Step 1.5\|リスクスコア" "TC-01: Step 1.5 exists"

echo ""
echo "--- Score Threshold Check ---"

# TC-02, TC-03, TC-04: スコア閾値の設計深度
assert_contains "$SKILL_FILE" "0-29.*PASS\|PASS.*簡易" "TC-02: PASS -> simple design"
assert_contains "$SKILL_FILE" "30-59.*WARN\|WARN.*標準" "TC-03: WARN -> standard design"
assert_contains "$SKILL_FILE" "60-100.*BLOCK\|BLOCK.*詳細" "TC-04: BLOCK -> detailed design"

echo ""
echo "--- Reference Check ---"

# TC-05: reference.mdに詳細設計の内容
assert_contains "$REF_FILE" "BLOCK.*詳細設計\|セキュリティ考慮\|エラーハンドリング" "TC-05: BLOCK detailed design in reference"

# TC-06: デフォルト動作
assert_contains "$REF_FILE" "Riskフィールドなし.*WARN\|後方互換" "TC-06: Default to WARN"

echo ""
echo "--- Line Count Check ---"

LINE_COUNT=$(wc -l < "$SKILL_FILE")
if [ "$LINE_COUNT" -le 100 ]; then
    echo "[PASS] TC-07: SKILL.md <= 100 lines ($LINE_COUNT lines)"
    ((PASSED++))
else
    echo "[FAIL] TC-07: SKILL.md <= 100 lines ($LINE_COUNT lines)"
    ((FAILED++))
fi

echo ""
echo "================================"
echo "Results: $PASSED passed, $FAILED failed"
echo "================================"

if [ $FAILED -gt 0 ]; then
    exit 1
fi
