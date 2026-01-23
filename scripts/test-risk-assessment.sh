#!/bin/bash
# Test: tdd-init Risk Assessment Feature
# TC-01 ~ TC-06: リスク判定ロジックの検証

# set -e  # Disabled to see all test results

SKILL_FILE="plugins/tdd-core/skills/tdd-init/SKILL.md"
REF_FILE="plugins/tdd-core/skills/tdd-init/reference.md"

echo "================================"
echo "Risk Assessment Test Suite"
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

assert_not_contains() {
    local file="$1"
    local pattern="$2"
    local test_name="$3"

    if ! grep -qi "$pattern" "$file" 2>/dev/null; then
        echo "[PASS] $test_name"
        ((PASSED++))
    else
        echo "[FAIL] $test_name"
        echo "       Pattern '$pattern' should NOT exist in $file"
        ((FAILED++))
    fi
}

echo ""
echo "--- TC-01~06: Risk Keywords Check ---"

# TC-01, TC-02: 低リスクキーワード
assert_contains "$SKILL_FILE" "低リスク\|Low" "TC-01/02: Low risk category exists"
assert_contains "$REF_FILE" "テスト\|ドキュメント\|UI\|色\|文言" "TC-01/02: Low risk keywords defined"

# TC-03: 中リスク（デフォルト）
assert_contains "$SKILL_FILE" "中リスク\|Medium\|デフォルト" "TC-03: Medium risk (default) exists"

# TC-04, TC-05, TC-06: 高リスクキーワード
assert_contains "$SKILL_FILE" "高リスク\|High" "TC-04~06: High risk category exists"
assert_contains "$REF_FILE" "ログイン\|認証\|API\|DB\|マイグレーション" "TC-04~06: High risk keywords defined"

echo ""
echo "--- Step 4.5: Risk Assessment Step Check ---"

# Step 4.5 が存在するか
assert_contains "$SKILL_FILE" "Step 4.5\|リスク判定" "Step 4.5: Risk assessment step exists"

echo ""
echo "--- Risk Level Output Check ---"

# リスクレベルの出力形式
assert_contains "$SKILL_FILE" "Risk:\|リスク:" "Risk level output format exists"

echo ""
echo "================================"
echo "Results: $PASSED passed, $FAILED failed"
echo "================================"

if [ $FAILED -gt 0 ]; then
    exit 1
fi
