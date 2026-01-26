#!/bin/bash
# Test: CLAUDE.md template in tdd-onboard reference.md
# Issue #24: CLAUDE.mdテンプレート更新

set -e

REFERENCE_FILE="plugins/tdd-core/skills/tdd-onboard/reference.md"
FAILED=0
PASSED=0

echo "Testing CLAUDE.md template in $REFERENCE_FILE"
echo "=============================================="

# TC-01: reference.md has CLAUDE.md template section
echo -n "TC-01: reference.md has CLAUDE.md template section... "
if grep -q "### CLAUDE.md テンプレート" "$REFERENCE_FILE"; then
    echo "PASS"
    ((PASSED++))
else
    echo "FAIL"
    ((FAILED++))
fi

# TC-02: Template has "Claude Code Configuration" section
echo -n "TC-02: Template has 'Claude Code Configuration' section... "
if grep -q "## Claude Code Configuration" "$REFERENCE_FILE"; then
    echo "PASS"
    ((PASSED++))
else
    echo "FAIL"
    ((FAILED++))
fi

# TC-03: Template references .claude/rules/
echo -n "TC-03: Template references .claude/rules/... "
if grep -q "\.claude/rules/" "$REFERENCE_FILE"; then
    echo "PASS"
    ((PASSED++))
else
    echo "FAIL"
    ((FAILED++))
fi

# TC-04: Template references .claude/hooks/
echo -n "TC-04: Template references .claude/hooks/... "
if grep -q "\.claude/hooks/" "$REFERENCE_FILE"; then
    echo "PASS"
    ((PASSED++))
else
    echo "FAIL"
    ((FAILED++))
fi

# TC-05: Template lists git-safety.md
echo -n "TC-05: Template lists git-safety.md... "
if grep -A20 "### Rules" "$REFERENCE_FILE" | grep -q "git-safety.md"; then
    echo "PASS"
    ((PASSED++))
else
    echo "FAIL"
    ((FAILED++))
fi

# TC-06: Template lists security.md
echo -n "TC-06: Template lists security.md... "
if grep -A20 "### Rules" "$REFERENCE_FILE" | grep -q "security.md"; then
    echo "PASS"
    ((PASSED++))
else
    echo "FAIL"
    ((FAILED++))
fi

# TC-07: Template lists git-conventions.md
echo -n "TC-07: Template lists git-conventions.md... "
if grep -A20 "### Rules" "$REFERENCE_FILE" | grep -q "git-conventions.md"; then
    echo "PASS"
    ((PASSED++))
else
    echo "FAIL"
    ((FAILED++))
fi

# TC-08: Template does NOT list tdd-workflow.md (removed)
echo -n "TC-08: Template does NOT list tdd-workflow.md... "
if grep -A20 "### Rules" "$REFERENCE_FILE" | grep -q "tdd-workflow.md"; then
    echo "FAIL (should not exist)"
    ((FAILED++))
else
    echo "PASS"
    ((PASSED++))
fi

# TC-09: Template does NOT list quality.md (removed)
echo -n "TC-09: Template does NOT list quality.md... "
if grep -A20 "### Rules" "$REFERENCE_FILE" | grep -q "quality.md"; then
    echo "FAIL (should not exist)"
    ((FAILED++))
else
    echo "PASS"
    ((PASSED++))
fi

# TC-10: Template lists recommended.md in Hooks section
echo -n "TC-10: Template lists recommended.md in Hooks section... "
if grep -A5 "### Hooks" "$REFERENCE_FILE" | grep -q "recommended.md"; then
    echo "PASS"
    ((PASSED++))
else
    echo "FAIL"
    ((FAILED++))
fi

SKILL_FILE="plugins/tdd-core/skills/tdd-onboard/SKILL.md"

# TC-11: SKILL.md lists only 3 rules (git-safety, security, git-conventions)
echo -n "TC-11: SKILL.md lists only 3 rules... "
if grep -q "rules/: git-safety, security, git-conventions" "$SKILL_FILE"; then
    echo "PASS"
    ((PASSED++))
else
    echo "FAIL"
    ((FAILED++))
fi

# TC-12: SKILL.md does NOT list tdd-workflow
echo -n "TC-12: SKILL.md does NOT list tdd-workflow... "
if grep "Step 6" "$SKILL_FILE" | grep -q "tdd-workflow"; then
    echo "FAIL (should not exist)"
    ((FAILED++))
else
    echo "PASS"
    ((PASSED++))
fi

echo ""
echo "=============================================="
echo "Results: $PASSED passed, $FAILED failed"
echo "=============================================="

if [ $FAILED -gt 0 ]; then
    exit 1
fi
