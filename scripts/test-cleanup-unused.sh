#!/bin/bash
# Test: Cleanup unused files
# Maintenance: cleanup-unused-files

set -e

FAILED=0
PASSED=0

echo "Testing cleanup of unused files"
echo "=============================================="

# TC-01: install-mcp.sh does not exist
echo -n "TC-01: install-mcp.sh removed... "
if [ ! -f "scripts/install-mcp.sh" ]; then
    echo "PASS"
    ((PASSED++))
else
    echo "FAIL"
    ((FAILED++))
fi

# TC-02: test-git-conventions-template.sh does not exist
echo -n "TC-02: test-git-conventions-template.sh removed... "
if [ ! -f "scripts/test-git-conventions-template.sh" ]; then
    echo "PASS"
    ((PASSED++))
else
    echo "FAIL"
    ((FAILED++))
fi

# TC-03: test-git-safety-template.sh does not exist
echo -n "TC-03: test-git-safety-template.sh removed... "
if [ ! -f "scripts/test-git-safety-template.sh" ]; then
    echo "PASS"
    ((PASSED++))
else
    echo "FAIL"
    ((FAILED++))
fi

# TC-04: test-phase4-adjustments.sh does not exist
echo -n "TC-04: test-phase4-adjustments.sh removed... "
if [ ! -f "scripts/test-phase4-adjustments.sh" ]; then
    echo "PASS"
    ((PASSED++))
else
    echo "FAIL"
    ((FAILED++))
fi

# TC-05: test-question-driven-init.sh does not exist
echo -n "TC-05: test-question-driven-init.sh removed... "
if [ ! -f "scripts/test-question-driven-init.sh" ]; then
    echo "PASS"
    ((PASSED++))
else
    echo "FAIL"
    ((FAILED++))
fi

# TC-06: test-risk-assessment.sh does not exist
echo -n "TC-06: test-risk-assessment.sh removed... "
if [ ! -f "scripts/test-risk-assessment.sh" ]; then
    echo "PASS"
    ((PASSED++))
else
    echo "FAIL"
    ((FAILED++))
fi

# TC-07: test-v33-green-parallelization.sh does not exist
echo -n "TC-07: test-v33-green-parallelization.sh removed... "
if [ ! -f "scripts/test-v33-green-parallelization.sh" ]; then
    echo "PASS"
    ((PASSED++))
else
    echo "FAIL"
    ((FAILED++))
fi

# TC-08: All remaining test scripts pass
echo -n "TC-08: All remaining tests pass... "
ALL_PASS=true
for f in scripts/test-*.sh; do
    [ "$(basename $f)" = "test-cleanup-unused.sh" ] && continue
    if ! bash "$f" > /dev/null 2>&1; then
        ALL_PASS=false
        break
    fi
done
if $ALL_PASS; then
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
