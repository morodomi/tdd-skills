#!/bin/bash
# Test: MIGRATION.md content validation
# Issue #26: マイグレーションガイド作成 (v1.x → v2.0)

set -e

MIGRATION_FILE="docs/MIGRATION.md"
FAILED=0
PASSED=0

echo "Testing $MIGRATION_FILE"
echo "=============================================="

# TC-01: MIGRATION.md exists
echo -n "TC-01: MIGRATION.md exists... "
if [ -f "$MIGRATION_FILE" ]; then
    echo "PASS"
    ((PASSED++))
else
    echo "FAIL"
    ((FAILED++))
fi

# TC-02: References .claude/rules/ structure
echo -n "TC-02: References .claude/rules/ structure... "
if grep -q "\.claude/rules/" "$MIGRATION_FILE"; then
    echo "PASS"
    ((PASSED++))
else
    echo "FAIL"
    ((FAILED++))
fi

# TC-03: Lists git-safety.md
echo -n "TC-03: Lists git-safety.md... "
if grep -q "git-safety.md" "$MIGRATION_FILE"; then
    echo "PASS"
    ((PASSED++))
else
    echo "FAIL"
    ((FAILED++))
fi

# TC-04: Lists security.md
echo -n "TC-04: Lists security.md... "
if grep -q "security.md" "$MIGRATION_FILE"; then
    echo "PASS"
    ((PASSED++))
else
    echo "FAIL"
    ((FAILED++))
fi

# TC-05: Lists git-conventions.md
echo -n "TC-05: Lists git-conventions.md... "
if grep -q "git-conventions.md" "$MIGRATION_FILE"; then
    echo "PASS"
    ((PASSED++))
else
    echo "FAIL"
    ((FAILED++))
fi

# TC-06: Does NOT reference tdd-workflow.md as target
echo -n "TC-06: Does NOT reference tdd-workflow.md as target... "
if grep -E "rules/tdd-workflow\.md|→.*tdd-workflow" "$MIGRATION_FILE" | grep -qv "^#"; then
    echo "FAIL (should not exist)"
    ((FAILED++))
else
    echo "PASS"
    ((PASSED++))
fi

# TC-07: Does NOT reference testing-guide.md as target
echo -n "TC-07: Does NOT reference testing-guide.md as target... "
if grep -E "rules/testing-guide\.md|→.*testing-guide" "$MIGRATION_FILE" | grep -qv "^#"; then
    echo "FAIL (should not exist)"
    ((FAILED++))
else
    echo "PASS"
    ((PASSED++))
fi

# TC-08: Does NOT reference quality.md as target
echo -n "TC-08: Does NOT reference quality.md as target... "
if grep -E "rules/quality\.md|→.*quality\.md" "$MIGRATION_FILE" | grep -qv "^#"; then
    echo "FAIL (should not exist)"
    ((FAILED++))
else
    echo "PASS"
    ((PASSED++))
fi

# TC-09: Does NOT reference commands.md as target
echo -n "TC-09: Does NOT reference commands.md as target... "
if grep -E "rules/commands\.md|→.*commands\.md" "$MIGRATION_FILE" | grep -qv "^#"; then
    echo "FAIL (should not exist)"
    ((FAILED++))
else
    echo "PASS"
    ((PASSED++))
fi

# TC-10: Recommends running tdd-onboard
echo -n "TC-10: Recommends running tdd-onboard... "
if grep -q "tdd-onboard" "$MIGRATION_FILE"; then
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
