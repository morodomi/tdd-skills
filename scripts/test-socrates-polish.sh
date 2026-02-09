#!/bin/bash
# Test script for socrates-protocol-polish feature
# Validates #59 timestamp + #60 response length constraints

set -uo pipefail

REF="plugins/tdd-core/skills/tdd-orchestrate/reference.md"
SOCRATES="plugins/tdd-core/agents/socrates.md"

PASS=0
FAIL=0
TOTAL=5

pass() { echo "  PASS: $1"; ((PASS++)); }
fail() { echo "  FAIL: $1"; ((FAIL++)); }

echo "=== Socrates Protocol Polish Tests ==="
echo ""

# TC-01: reference.md Progress Log format has HH:MM timestamp
if grep -qE "HH:MM|HH.MM|\[時刻\]" "$REF" 2>/dev/null; then
  pass "TC-01: reference.md Progress Log has timestamp format"
else
  fail "TC-01: reference.md Progress Log missing timestamp"
fi

# TC-02: socrates.md has Objection length constraint
if grep -qiE "2-3文|2〜3文|2-3 sentence|各.*短く|簡潔" "$SOCRATES" 2>/dev/null; then
  pass "TC-02: socrates.md has Objection length constraint"
else
  fail "TC-02: socrates.md missing Objection length constraint"
fi

# TC-03: socrates.md has Alternative count constraint
if grep -qiE "3つまで|最大3|3 alternative|3つ以内" "$SOCRATES" 2>/dev/null; then
  pass "TC-03: socrates.md has Alternative count constraint"
else
  fail "TC-03: socrates.md missing Alternative count constraint"
fi

# TC-04: Regression - test-socrates-advisor.sh passes
SOCRATES_RESULT=$(bash scripts/test-socrates-advisor.sh 2>&1)
SOCRATES_FAILS=$(echo "$SOCRATES_RESULT" | grep "^  FAIL:" | wc -l | tr -d ' ')
if [ "$SOCRATES_FAILS" -eq 0 ]; then
  pass "TC-04: test-socrates-advisor.sh passes (18/18)"
else
  fail "TC-04: test-socrates-advisor.sh has $SOCRATES_FAILS failures"
fi

# TC-05: Regression - test-free-text-input.sh passes
FREETEXT_RESULT=$(bash scripts/test-free-text-input.sh 2>&1)
FREETEXT_FAILS=$(echo "$FREETEXT_RESULT" | grep "^  FAIL:" | wc -l | tr -d ' ')
if [ "$FREETEXT_FAILS" -eq 0 ]; then
  pass "TC-05: test-free-text-input.sh passes (7/7)"
else
  fail "TC-05: test-free-text-input.sh has $FREETEXT_FAILS failures"
fi

echo ""
echo "=== Results: $PASS/$TOTAL PASS, $FAIL/$TOTAL FAIL ==="

if [ "$FAIL" -gt 0 ]; then
  exit 1
fi
