#!/bin/bash
# Test: tdd-init Risk Assessment Feature (Score Format)
# TC-01 ~ TC-07: リスクスコア判定ロジックの検証

SKILL_FILE="plugins/tdd-core/skills/tdd-init/SKILL.md"
REF_FILE="plugins/tdd-core/skills/tdd-init/reference.md"
TPL_FILE="plugins/tdd-core/skills/tdd-init/templates/cycle.md"

echo "================================"
echo "Risk Assessment Test Suite"
echo "(Score Format)"
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
echo "--- Score Threshold Check ---"

# TC-01: スコア閾値の定義
assert_contains "$SKILL_FILE" "0-29\|PASS" "TC-01: PASS threshold (0-29) defined"
assert_contains "$SKILL_FILE" "30-59\|WARN" "TC-02: WARN threshold (30-59) defined"
assert_contains "$SKILL_FILE" "60-100\|BLOCK" "TC-03: BLOCK threshold (60-100) defined"

echo ""
echo "--- Keyword Score Check ---"

# TC-04: キーワード別スコア
assert_contains "$REF_FILE" "+60\|セキュリティ\|認証" "TC-04: High score keywords (+60) defined"
assert_contains "$REF_FILE" "+10\|限定的\|見た目" "TC-05: Low score keywords (+10) defined"
assert_contains "$REF_FILE" "+30\|デフォルト" "TC-06: Default score (+30) defined"

echo ""
echo "--- Step 4.5 Check ---"

# TC-07: Step 4.5 スコア判定
assert_contains "$SKILL_FILE" "Step 4.5\|リスクスコア" "TC-07: Risk score step exists"

echo ""
echo "--- Cycle doc Template Check ---"

# TC-08: テンプレートのスコア形式
assert_contains "$TPL_FILE" "0-100\|PASS.*WARN.*BLOCK" "TC-08: Template uses score format"

echo ""
echo "================================"
echo "Results: $PASSED passed, $FAILED failed"
echo "================================"

if [ $FAILED -gt 0 ]; then
    exit 1
fi
