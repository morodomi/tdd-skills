#!/bin/bash
# Test: Strategic Compact
# TC-01 ~ TC-11

SCRIPT="scripts/save-tdd-state.sh"
PLUGINS_DIR="plugins"

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

PASS=0
FAIL=0

test_pass() {
    echo -e "${GREEN}✓${NC} $1"
    ((PASS++))
}

test_fail() {
    echo -e "${RED}✗${NC} $1"
    ((FAIL++))
}

echo "=========================================="
echo "Strategic Compact Tests"
echo "=========================================="
echo ""

# ==========================================
# save-tdd-state.sh Tests (TC-01 ~ TC-05)
# ==========================================
echo "--- save-tdd-state.sh ---"

# Setup: create temp directory with fake project structure
TMPDIR=$(mktemp -d)
trap "rm -rf $TMPDIR" EXIT

# TC-01: save-tdd-state.sh detects active Cycle doc path
mkdir -p "$TMPDIR/docs/cycles"
cat > "$TMPDIR/docs/cycles/20260213_1500_test-feature.md" << 'CYCLEDOC'
---
feature: test
cycle: test-feature
phase: GREEN
created: 2026-02-13 15:00
updated: 2026-02-13 15:00
---
# Test Feature
CYCLEDOC

OUTPUT=$("$SCRIPT" "$TMPDIR" 2>&1)
if echo "$OUTPUT" | grep -q "20260213_1500_test-feature.md"; then
    test_pass "TC-01: detects active Cycle doc path"
else
    test_fail "TC-01: expected Cycle doc path in output, got: $OUTPUT"
fi

# TC-02: save-tdd-state.sh extracts phase from frontmatter
if echo "$OUTPUT" | grep -qi "GREEN"; then
    test_pass "TC-02: extracts phase from frontmatter"
else
    test_fail "TC-02: expected phase GREEN in output, got: $OUTPUT"
fi

# TC-03: save-tdd-state.sh output contains both Cycle doc path and phase
if echo "$OUTPUT" | grep -q "20260213_1500_test-feature.md" && echo "$OUTPUT" | grep -qi "GREEN"; then
    test_pass "TC-03: output contains Cycle doc path and phase"
else
    test_fail "TC-03: output missing path or phase, got: $OUTPUT"
fi

# TC-04: save-tdd-state.sh shows error when docs/cycles/ is missing
EMPTY_TMPDIR=$(mktemp -d)
OUTPUT_ERR=$("$SCRIPT" "$EMPTY_TMPDIR" 2>&1)
EXIT_CODE=$?
rm -rf "$EMPTY_TMPDIR"
if echo "$OUTPUT_ERR" | grep -qi "no.*cycle\|not found\|warning"; then
    test_pass "TC-04: error message when docs/cycles/ is missing"
else
    test_fail "TC-04: expected error message, got: $OUTPUT_ERR"
fi
# Should not block (exit 0)
if [ "$EXIT_CODE" -eq 0 ]; then
    test_pass "TC-04b: exit 0 when docs/cycles/ is missing (non-blocking)"
else
    test_fail "TC-04b: expected exit 0, got exit $EXIT_CODE"
fi

# TC-05: save-tdd-state.sh fallback when phase not in frontmatter
cat > "$TMPDIR/docs/cycles/20260214_0000_no-phase.md" << 'CYCLEDOC'
---
feature: test
cycle: no-phase
created: 2026-02-14 00:00
---
# No Phase Feature
CYCLEDOC

OUTPUT_NP=$("$SCRIPT" "$TMPDIR" 2>&1)
if echo "$OUTPUT_NP" | grep -qi "unknown\|N/A\|不明"; then
    test_pass "TC-05: fallback when phase not in frontmatter"
else
    test_fail "TC-05: expected fallback value, got: $OUTPUT_NP"
fi
# Cleanup: remove the no-phase doc to not interfere
rm "$TMPDIR/docs/cycles/20260214_0000_no-phase.md"

echo ""

# ==========================================
# SKILL.md / reference.md Structure Tests (TC-06 ~ TC-09)
# ==========================================
echo "--- SKILL.md / reference.md Structure ---"

PLAN_REF="$PLUGINS_DIR/tdd-core/skills/tdd-plan/reference.md"
GREEN_REF="$PLUGINS_DIR/tdd-core/skills/tdd-green/reference.md"
PLAN_SKILL="$PLUGINS_DIR/tdd-core/skills/tdd-plan/SKILL.md"
GREEN_SKILL="$PLUGINS_DIR/tdd-core/skills/tdd-green/SKILL.md"

# TC-06: tdd-plan reference.md has Phase Completion section
if grep -q "Phase Completion" "$PLAN_REF" 2>/dev/null; then
    test_pass "TC-06: tdd-plan reference.md has Phase Completion section"
else
    test_fail "TC-06: tdd-plan reference.md missing Phase Completion section"
fi

# TC-07: tdd-green reference.md has Phase Completion section
if grep -q "Phase Completion" "$GREEN_REF" 2>/dev/null; then
    test_pass "TC-07: tdd-green reference.md has Phase Completion section"
else
    test_fail "TC-07: tdd-green reference.md missing Phase Completion section"
fi

# TC-08: tdd-plan SKILL.md is 100 lines or less
PLAN_LINES=$(wc -l < "$PLAN_SKILL" 2>/dev/null | tr -d ' ')
if [ -n "$PLAN_LINES" ] && [ "$PLAN_LINES" -le 100 ]; then
    test_pass "TC-08: tdd-plan SKILL.md is ${PLAN_LINES} lines (<= 100)"
else
    test_fail "TC-08: tdd-plan SKILL.md is ${PLAN_LINES:-missing} lines (> 100 or missing)"
fi

# TC-09: tdd-green SKILL.md is 100 lines or less
GREEN_LINES=$(wc -l < "$GREEN_SKILL" 2>/dev/null | tr -d ' ')
if [ -n "$GREEN_LINES" ] && [ "$GREEN_LINES" -le 100 ]; then
    test_pass "TC-09: tdd-green SKILL.md is ${GREEN_LINES} lines (<= 100)"
else
    test_fail "TC-09: tdd-green SKILL.md is ${GREEN_LINES:-missing} lines (> 100 or missing)"
fi

echo ""

# ==========================================
# recommended.md Tests (TC-10 ~ TC-11)
# ==========================================
echo "--- recommended.md ---"

HOOKS_MD=".claude/hooks/recommended.md"

# TC-10: recommended.md has PreCompact hook
if grep -q "PreCompact" "$HOOKS_MD" 2>/dev/null; then
    test_pass "TC-10: recommended.md has PreCompact hook"
else
    test_fail "TC-10: recommended.md missing PreCompact hook"
fi

# TC-11: PreCompact hook references save-tdd-state.sh
if grep -q "save-tdd-state" "$HOOKS_MD" 2>/dev/null; then
    test_pass "TC-11: PreCompact hook references save-tdd-state.sh"
else
    test_fail "TC-11: PreCompact hook missing save-tdd-state.sh reference"
fi

echo ""

echo "=========================================="
echo "Results: $PASS passed, $FAIL failed"
echo "=========================================="

if [ "$FAIL" -gt 0 ]; then
    exit 1
fi
