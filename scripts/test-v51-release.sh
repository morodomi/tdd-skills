#!/bin/bash
# Test script for v5.1 release documentation
# Validates README.md updates for Socrates Advisor release

set -uo pipefail

README="README.md"

PASS=0
FAIL=0
TOTAL=7

pass() { echo "  PASS: $1"; ((PASS++)); }
fail() { echo "  FAIL: $1"; ((FAIL++)); }

echo "=== v5.1 Release Documentation Tests ==="
echo ""

# TC-01: README.md has v5.1 version banner
if grep -qiE "v5\.1" "$README" 2>/dev/null; then
  pass "TC-01: README.md has v5.1 version banner"
else
  fail "TC-01: README.md missing v5.1 version banner"
fi

# TC-02: README.md has Socrates Advisor section
if grep -qiE "Socrates Advisor" "$README" 2>/dev/null; then
  pass "TC-02: README.md has Socrates Advisor section"
else
  fail "TC-02: README.md missing Socrates Advisor section"
fi

# TC-03: README.md has Socrates Protocol description
if grep -qiE "Socrates Protocol|Devil.*Advocate" "$README" 2>/dev/null; then
  pass "TC-03: README.md has Socrates Protocol description"
else
  fail "TC-03: README.md missing Socrates Protocol description"
fi

# TC-04: README.md has PASS/WARN/BLOCK judgment description
if grep -qiE "PASS.*WARN.*BLOCK|WARN.*BLOCK|50-79.*WARN|80-100.*BLOCK" "$README" 2>/dev/null; then
  pass "TC-04: README.md has PASS/WARN/BLOCK judgment description"
else
  fail "TC-04: README.md missing PASS/WARN/BLOCK judgment description"
fi

# TC-05: README.md has fallback description
if grep -qiE "fallback|フォールバック" "$README" 2>/dev/null; then
  pass "TC-05: README.md has fallback description"
else
  fail "TC-05: README.md missing fallback description"
fi

# TC-06: README.md has v5.0 -> v5.1 Migration section
if grep -qiE "v5\.0.*v5\.1|v5\.0\.0.*v5\.1" "$README" 2>/dev/null; then
  pass "TC-06: README.md has v5.0 -> v5.1 Migration section"
else
  fail "TC-06: README.md missing v5.0 -> v5.1 Migration section"
fi

# TC-07: Regression - test-plugins-structure.sh passes
STRUCTURE_RESULT=$(bash scripts/test-plugins-structure.sh 2>&1)
STRUCTURE_FAILS=$(echo "$STRUCTURE_RESULT" | grep "^  FAIL:" | wc -l | tr -d ' ')
if [ "$STRUCTURE_FAILS" -eq 0 ]; then
  pass "TC-07: test-plugins-structure.sh passes"
else
  fail "TC-07: test-plugins-structure.sh has $STRUCTURE_FAILS failures"
fi

echo ""
echo "=== Results: $PASS/$TOTAL PASS, $FAIL/$TOTAL FAIL ==="

if [ "$FAIL" -gt 0 ]; then
  exit 1
fi
