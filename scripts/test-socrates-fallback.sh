#!/bin/bash
# Test script for socrates-fallback feature
# Validates #58 Socrates failure fallback to v5.0 logic

set -uo pipefail

REF="plugins/tdd-core/skills/tdd-orchestrate/reference.md"
TEAMS="plugins/tdd-core/skills/tdd-orchestrate/steps-teams.md"

PASS=0
FAIL=0
TOTAL=6

pass() { echo "  PASS: $1"; ((PASS++)); }
fail() { echo "  FAIL: $1"; ((FAIL++)); }

echo "=== Socrates Fallback Tests ==="
echo ""

# TC-01: reference.md has fallback section
if grep -qiE "障害時フォールバック|fallback|フォールバック" "$REF" 2>/dev/null; then
  pass "TC-01: reference.md has fallback section"
else
  fail "TC-01: reference.md missing fallback section"
fi

# TC-02: reference.md has timeout description
if grep -qiE "タイムアウト|timeout" "$REF" 2>/dev/null; then
  pass "TC-02: reference.md has timeout description"
else
  fail "TC-02: reference.md missing timeout description"
fi

# TC-03: reference.md references v5.0 compatible logic
if grep -qiE "v5.0.*互換|v5.0.*ロジック|自動進行.*自動再試行" "$REF" 2>/dev/null; then
  pass "TC-03: reference.md references v5.0 compatible logic"
else
  fail "TC-03: reference.md missing v5.0 compatible logic reference"
fi

# TC-04: steps-teams.md has fallback description
if grep -qiE "障害|fallback|フォールバック|タイムアウト|timeout" "$TEAMS" 2>/dev/null; then
  pass "TC-04: steps-teams.md has fallback description"
else
  fail "TC-04: steps-teams.md missing fallback description"
fi

# TC-05: Regression - test-socrates-advisor.sh passes
SOCRATES_RESULT=$(bash scripts/test-socrates-advisor.sh 2>&1)
SOCRATES_FAILS=$(echo "$SOCRATES_RESULT" | grep "^  FAIL:" | wc -l | tr -d ' ')
if [ "$SOCRATES_FAILS" -eq 0 ]; then
  pass "TC-05: test-socrates-advisor.sh passes (18/18)"
else
  fail "TC-05: test-socrates-advisor.sh has $SOCRATES_FAILS failures"
fi

# TC-06: Regression - test-free-text-input.sh passes
FREETEXT_RESULT=$(bash scripts/test-free-text-input.sh 2>&1)
FREETEXT_FAILS=$(echo "$FREETEXT_RESULT" | grep "^  FAIL:" | wc -l | tr -d ' ')
if [ "$FREETEXT_FAILS" -eq 0 ]; then
  pass "TC-06: test-free-text-input.sh passes (7/7)"
else
  fail "TC-06: test-free-text-input.sh has $FREETEXT_FAILS failures"
fi

echo ""
echo "=== Results: $PASS/$TOTAL PASS, $FAIL/$TOTAL FAIL ==="

if [ "$FAIL" -gt 0 ]; then
  exit 1
fi
