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

# TC-02: tdd-plan Step 6 が plan-review「必須」になっていること
echo -n "TC-02: tdd-plan Step 6 has plan-review as required... "
if grep -q "plan-review.*必須\|plan-review.*required\|必ず.*plan-review" "$PLUGIN_DIR/tdd-plan/SKILL.md" 2>/dev/null; then
    echo "PASS"
else
    echo "FAIL"
    ERRORS=$((ERRORS + 1))
fi

# TC-03: tdd-plan Step 7 が plan-review 委譲に変更されていること
echo -n "TC-03: tdd-plan Step 7 delegates to plan-review... "
# Step 7が「plan-review実行」または「plan-review自動実行」の記述を含むこと
# かつ、「ユーザーが続行を確認したら」という手動確認の記述がないこと
if grep -A5 "Step 7" "$PLUGIN_DIR/tdd-plan/SKILL.md" 2>/dev/null | grep -q "plan-review"; then
    # 手動確認の記述がないことを確認
    if ! grep -A5 "Step 7" "$PLUGIN_DIR/tdd-plan/SKILL.md" 2>/dev/null | grep -q "ユーザーが続行を確認"; then
        echo "PASS"
    else
        echo "FAIL (still has manual confirmation)"
        ERRORS=$((ERRORS + 1))
    fi
else
    echo "FAIL (no plan-review reference in Step 7)"
    ERRORS=$((ERRORS + 1))
fi

# TC-04: plan-review Step 4 PASS に tdd-red 自動実行の記述があること
echo -n "TC-04: plan-review Step 4 PASS has tdd-red auto-execution... "
if grep -q "Skill.*tdd-core:tdd-red\|tdd-red.*自動実行\|tdd-red.*auto" "$PLUGIN_DIR/plan-review/SKILL.md" 2>/dev/null; then
    echo "PASS"
else
    echo "FAIL"
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
