#!/bin/bash
# Test: Verification Gates (Phase 3)
# TC-01 ~ TC-05: 自動進行ワークフローの検証

PLAN_FILE="plugins/tdd-core/skills/tdd-plan/SKILL.md"
RED_FILE="plugins/tdd-core/skills/tdd-red/SKILL.md"
GREEN_FILE="plugins/tdd-core/skills/tdd-green/SKILL.md"
REFACTOR_FILE="plugins/tdd-core/skills/tdd-refactor/SKILL.md"
REVIEW_FILE="plugins/tdd-core/skills/tdd-review/SKILL.md"

echo "================================"
echo "Verification Gates Test Suite"
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

assert_line_limit() {
    local file="$1"
    local limit="$2"
    local test_name="$3"

    local lines=$(wc -l < "$file" | tr -d ' ')
    if [ "$lines" -le "$limit" ]; then
        echo "[PASS] $test_name ($lines lines)"
        ((PASSED++))
    else
        echo "[FAIL] $test_name ($lines lines, limit: $limit)"
        ((FAILED++))
    fi
}

echo ""
echo "--- TC-01: tdd-plan 自動進行 ---"
assert_contains "$PLAN_FILE" "自動進行\|自動的に\|RED.*GREEN.*REFACTOR" "TC-01: Auto-proceed trigger in tdd-plan"

echo ""
echo "--- TC-02: Verification Gate ---"
assert_contains "$RED_FILE" "Verification Gate\|Gate" "TC-02a: Verification Gate in tdd-red"
assert_contains "$GREEN_FILE" "Verification Gate\|Gate" "TC-02b: Verification Gate in tdd-green"
assert_contains "$REFACTOR_FILE" "Verification Gate\|Gate" "TC-02c: Verification Gate in tdd-refactor"

echo ""
echo "--- TC-03: quality-gate 自動実行 ---"
assert_contains "$REVIEW_FILE" "quality-gate.*自動\|自動.*quality-gate\|自動実行" "TC-03: quality-gate auto-execution in tdd-review"

echo ""
echo "--- TC-04: COMMIT 承認ポイント ---"
assert_contains "$REVIEW_FILE" "COMMIT.*承認\|承認.*COMMIT\|ユーザー.*判断\|確認.*COMMIT" "TC-04: COMMIT approval point in tdd-review"

echo ""
echo "--- TC-05: Line Count Check ---"
assert_line_limit "$PLAN_FILE" 100 "TC-05a: tdd-plan <= 100 lines"
assert_line_limit "$RED_FILE" 100 "TC-05b: tdd-red <= 100 lines"
assert_line_limit "$GREEN_FILE" 100 "TC-05c: tdd-green <= 100 lines"
assert_line_limit "$REFACTOR_FILE" 100 "TC-05d: tdd-refactor <= 100 lines"
assert_line_limit "$REVIEW_FILE" 100 "TC-05e: tdd-review <= 100 lines"

echo ""
echo "================================"
echo "Results: $PASSED passed, $FAILED failed"
echo "================================"

if [ $FAILED -gt 0 ]; then
    exit 1
fi
