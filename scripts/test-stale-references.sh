#!/bin/bash
# Test: Stale references cleanup
# Maintenance: stale-references-cleanup

set -e

FAILED=0
PASSED=0

echo "Testing stale references cleanup"
echo "=============================================="

# TC-01: test-skills-structure.sh removed
echo -n "TC-01: test-skills-structure.sh removed... "
if [ ! -f "scripts/test-skills-structure.sh" ]; then
    echo "PASS"
    ((PASSED++))
else
    echo "FAIL (still exists)"
    ((FAILED++))
fi

# TC-02: tdd-red/SKILL.md does NOT reference testing-guide.md
echo -n "TC-02: tdd-red/SKILL.md no testing-guide.md ref... "
if grep -q "testing-guide.md" "plugins/tdd-core/skills/tdd-red/SKILL.md"; then
    echo "FAIL (reference exists)"
    ((FAILED++))
else
    echo "PASS"
    ((PASSED++))
fi

# TC-03: Other test scripts still pass
echo -n "TC-03: test-plugins-structure.sh works... "
if bash scripts/test-plugins-structure.sh > /dev/null 2>&1; then
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
