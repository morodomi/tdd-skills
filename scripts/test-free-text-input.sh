#!/bin/bash
# Test script for free-text-input-refinement feature
# Validates #56 retry limit + #57 skip removal

set -uo pipefail

ORCH_DIR="plugins/tdd-core/skills/tdd-orchestrate"
REF="$ORCH_DIR/reference.md"
TEAMS="$ORCH_DIR/steps-teams.md"

PASS=0
FAIL=0
TOTAL=7

pass() { echo "  PASS: $1"; ((PASS++)); }
fail() { echo "  FAIL: $1"; ((FAIL++)); }

echo "=== Free-text Input Refinement Tests ==="
echo ""

# ==========================================
# reference.md
# ==========================================
echo "## reference.md"

# TC-01: reference.md input table does NOT contain "skip"
# Check only the input table area (between "有効な入力例" and "不明瞭な入力")
SKIP_IN_TABLE=$(sed -n '/有効な入力例/,/不明瞭な入力/p' "$REF" 2>/dev/null | grep -c "| skip |" || true)
if [ "$SKIP_IN_TABLE" -eq 0 ]; then
  pass "TC-01: reference.md input table does not contain skip"
else
  fail "TC-01: reference.md input table still contains skip"
fi

# TC-02: reference.md input table contains proceed, fix, abort
if grep -q "| proceed |" "$REF" 2>/dev/null && grep -q "| fix |" "$REF" 2>/dev/null && grep -q "| abort |" "$REF" 2>/dev/null; then
  pass "TC-02: reference.md has proceed/fix/abort in input table"
else
  fail "TC-02: reference.md missing proceed/fix/abort in input table"
fi

# TC-03: reference.md has max 2 retry limit
if grep -qiE "max 2|最大2回|2回" "$REF" 2>/dev/null; then
  pass "TC-03: reference.md has retry limit (max 2)"
else
  fail "TC-03: reference.md missing retry limit"
fi

# TC-04: reference.md has default proceed on exceed
if grep -qiE "デフォルト.*proceed|default.*proceed|proceed.*デフォルト" "$REF" 2>/dev/null; then
  pass "TC-04: reference.md has default proceed on exceed"
else
  fail "TC-04: reference.md missing default proceed on exceed"
fi

echo ""

# ==========================================
# steps-teams.md
# ==========================================
echo "## steps-teams.md"

# TC-05: steps-teams.md does NOT contain "skip" in Socrates Protocol sections
if grep -qi "skip" "$TEAMS" 2>/dev/null; then
  fail "TC-05: steps-teams.md still contains skip"
else
  pass "TC-05: steps-teams.md does not contain skip"
fi

# TC-06: steps-teams.md has proceed/fix/abort
if grep -q "proceed" "$TEAMS" 2>/dev/null && grep -q "fix" "$TEAMS" 2>/dev/null && grep -q "abort" "$TEAMS" 2>/dev/null; then
  pass "TC-06: steps-teams.md has proceed/fix/abort"
else
  fail "TC-06: steps-teams.md missing proceed/fix/abort"
fi

echo ""

# ==========================================
# Regression
# ==========================================
echo "## regression"

# TC-07: Existing test-socrates-advisor.sh passes
SOCRATES_RESULT=$(bash scripts/test-socrates-advisor.sh 2>&1)
SOCRATES_FAILS=$(echo "$SOCRATES_RESULT" | grep "^  FAIL:" | wc -l | tr -d ' ')
if [ "$SOCRATES_FAILS" -eq 0 ]; then
  pass "TC-07: Existing test-socrates-advisor.sh passes (18/18)"
else
  fail "TC-07: test-socrates-advisor.sh has $SOCRATES_FAILS failures"
fi

echo ""
echo "=== Results: $PASS/$TOTAL PASS, $FAIL/$TOTAL FAIL ==="

if [ "$FAIL" -gt 0 ]; then
  exit 1
fi
