#!/bin/bash
# Test script for task granularity feature (#32)

PASSED=0
FAILED=0

check() {
    if [ $? -eq 0 ]; then
        echo -e "\033[0;32m✓\033[0m $1"
        ((PASSED++))
    else
        echo -e "\033[0;31m✗\033[0m $1"
        ((FAILED++))
    fi
}

echo "=========================================="
echo "Task Granularity Test (#32)"
echo "=========================================="

SKILL_PATH="plugins/tdd-core/skills/tdd-plan/SKILL.md"
REF_PATH="plugins/tdd-core/skills/tdd-plan/reference.md"

# TC-01: SKILL.md has "2-5 minutes" criteria
grep -q "2-5" "$SKILL_PATH"
check "TC-01: SKILL.md has 2-5 minute criteria"

# TC-02: SKILL.md has task split guidance
grep -qi "分割\|split" "$SKILL_PATH"
check "TC-02: SKILL.md has task split guidance"

# TC-03: reference.md has detailed task granularity section
grep -q "タスク粒度\|Task Granularity" "$REF_PATH"
check "TC-03: reference.md has task granularity section"

# TC-04: reference.md has examples
grep -q "例\|Example" "$REF_PATH"
check "TC-04: reference.md has examples"

# TC-05: SKILL.md is under 100 lines
LINES=$(wc -l < "$SKILL_PATH")
test "$LINES" -le 100
check "TC-05: SKILL.md is $LINES lines (≤100)"

echo ""
echo "=========================================="
echo "Results: $PASSED passed, $FAILED failed"
echo "=========================================="

exit $FAILED
