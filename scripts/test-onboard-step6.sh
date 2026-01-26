#!/bin/bash
# Test: tdd-onboard reference.md Step 6 templates
# Issue #25: tdd-onboard SKILL.md / reference.md 更新

set -e

REFERENCE_FILE="plugins/tdd-core/skills/tdd-onboard/reference.md"
FAILED=0
PASSED=0

echo "Testing Step 6 templates in $REFERENCE_FILE"
echo "=============================================="

# TC-01: reference.md Step 6 has git-safety.md template
echo -n "TC-01: Step 6 has git-safety.md template... "
if grep -q "### git-safety.md" "$REFERENCE_FILE"; then
    echo "PASS"
    ((PASSED++))
else
    echo "FAIL"
    ((FAILED++))
fi

# TC-02: reference.md Step 6 has security.md template
echo -n "TC-02: Step 6 has security.md template... "
if grep -q "### security.md" "$REFERENCE_FILE"; then
    echo "PASS"
    ((PASSED++))
else
    echo "FAIL"
    ((FAILED++))
fi

# TC-03: reference.md Step 6 has git-conventions.md template
echo -n "TC-03: Step 6 has git-conventions.md template... "
if grep -q "### git-conventions.md" "$REFERENCE_FILE"; then
    echo "PASS"
    ((PASSED++))
else
    echo "FAIL"
    ((FAILED++))
fi

# TC-04: reference.md Step 6 does NOT have tdd-workflow.md template
echo -n "TC-04: Step 6 does NOT have tdd-workflow.md... "
if grep -q "### tdd-workflow.md" "$REFERENCE_FILE"; then
    echo "FAIL (should not exist)"
    ((FAILED++))
else
    echo "PASS"
    ((PASSED++))
fi

# TC-05: reference.md Step 6 does NOT have testing-guide.md template
echo -n "TC-05: Step 6 does NOT have testing-guide.md... "
if grep -q "### testing-guide.md" "$REFERENCE_FILE"; then
    echo "FAIL (should not exist)"
    ((FAILED++))
else
    echo "PASS"
    ((PASSED++))
fi

# TC-06: reference.md Step 6 does NOT have quality.md template
echo -n "TC-06: Step 6 does NOT have quality.md... "
if grep -q "### quality.md" "$REFERENCE_FILE"; then
    echo "FAIL (should not exist)"
    ((FAILED++))
else
    echo "PASS"
    ((PASSED++))
fi

# TC-07: reference.md Step 6 does NOT have commands.md template
echo -n "TC-07: Step 6 does NOT have commands.md... "
if grep -q "### commands.md" "$REFERENCE_FILE"; then
    echo "FAIL (should not exist)"
    ((FAILED++))
else
    echo "PASS"
    ((PASSED++))
fi

# TC-08: reference.md Step 6 section header exists
echo -n "TC-08: Step 6 section header exists... "
if grep -q "## Step 6: .claude/rules/" "$REFERENCE_FILE"; then
    echo "PASS"
    ((PASSED++))
else
    echo "FAIL"
    ((FAILED++))
fi

echo ""
echo "=============================================="
echo "Results: $PASSED passed, $FAILED failed"
echo "=============================================="

if [ $FAILED -gt 0 ]; then
    exit 1
fi
