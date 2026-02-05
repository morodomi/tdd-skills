#!/bin/bash
# Test: auto-phase-transition-part1
# Cycle doc: docs/cycles/20260204_2356_auto-phase-transition-part1.md

set -e

PLUGIN_DIR="plugins/tdd-core/skills"
ERRORS=0

echo "=== Auto Phase Transition Tests ==="
echo ""

# TC-01: tdd-init Step 7 に tdd-plan 自動実行の記述があること
echo -n "TC-01: tdd-init Step 7 has tdd-plan auto-execution... "
if grep -q "Skill.*tdd-core:tdd-plan\|tdd-plan.*自動実行\|auto.*tdd-plan" "$PLUGIN_DIR/tdd-init/SKILL.md" 2>/dev/null; then
    echo "PASS"
else
    echo "FAIL"
    ERRORS=$((ERRORS + 1))
fi

# TC-02: tdd-plan に plan-review 自動実行の記述があること
echo -n "TC-02: tdd-plan has plan-review auto-execution... "
if grep -q "plan-review.*自動実行\|Skill.*plan-review" "$PLUGIN_DIR/tdd-plan/SKILL.md" 2>/dev/null; then
    echo "PASS"
else
    echo "FAIL"
    ERRORS=$((ERRORS + 1))
fi

# TC-03: tdd-plan が plan-review に制御を委譲していること
echo -n "TC-03: tdd-plan delegates control to plan-review... "
# plan-reviewがRED以降を制御する記述があること
if grep -q "plan-review.*制御\|plan-review.*RED" "$PLUGIN_DIR/tdd-plan/SKILL.md" 2>/dev/null; then
    echo "PASS"
else
    echo "FAIL"
    ERRORS=$((ERRORS + 1))
fi

# TC-04: plan-review Step 4 PASS が手動判断になっていること（Part 2で修正）
echo -n "TC-04: plan-review Step 4 PASS maintains manual judgment... "
if ! grep -q "Skill.*tdd-core:tdd-red\|tdd-red.*自動実行" "$PLUGIN_DIR/plan-review/SKILL.md" 2>/dev/null; then
    echo "PASS"
else
    echo "FAIL (found tdd-red auto-execution)"
    ERRORS=$((ERRORS + 1))
fi

# TC-05: 各SKILL.mdが100行以下であること
echo -n "TC-05: All SKILL.md files are under 100 lines... "
TC05_FAIL=0
for skill in tdd-init tdd-plan plan-review; do
    LINES=$(wc -l < "$PLUGIN_DIR/$skill/SKILL.md" 2>/dev/null | tr -d ' ')
    if [ "$LINES" -gt 100 ]; then
        echo ""
        echo "  FAIL: $skill/SKILL.md has $LINES lines (max 100)"
        TC05_FAIL=1
    fi
done
if [ "$TC05_FAIL" -eq 0 ]; then
    echo "PASS"
else
    ERRORS=$((ERRORS + 1))
fi

# TC-06: scripts/test-plugins-structure.sh が通ること
echo -n "TC-06: test-plugins-structure.sh passes... "
if bash scripts/test-plugins-structure.sh >/dev/null 2>&1; then
    echo "PASS"
else
    echo "FAIL"
    ERRORS=$((ERRORS + 1))
fi

echo ""
echo "=== Results ==="
if [ "$ERRORS" -eq 0 ]; then
    echo "All tests passed!"
    exit 0
else
    echo "$ERRORS test(s) failed"
    exit 1
fi
