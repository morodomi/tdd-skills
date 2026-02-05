#!/bin/bash
# Test: auto-phase-transition-part2
# Cycle doc: docs/cycles/20260205_0907_auto-phase-transition-part2.md

set -e

PLUGIN_DIR="plugins/tdd-core/skills"
ERRORS=0

echo "=== Auto Phase Transition Part 2 Tests ==="
echo ""

# TC-01: tdd-red Step 6 に tdd-green 自動実行の記述があること
echo -n "TC-01: tdd-red Step 6 has tdd-green auto-execution... "
if grep -q "Skill.*tdd-core:tdd-green\|tdd-green.*自動実行\|auto.*tdd-green" "$PLUGIN_DIR/tdd-red/SKILL.md" 2>/dev/null; then
    echo "PASS"
else
    echo "FAIL"
    ERRORS=$((ERRORS + 1))
fi

# TC-02: tdd-green Step 6 に tdd-refactor 自動実行の記述があること
echo -n "TC-02: tdd-green Step 6 has tdd-refactor auto-execution... "
if grep -q "Skill.*tdd-core:tdd-refactor\|tdd-refactor.*自動実行\|auto.*tdd-refactor" "$PLUGIN_DIR/tdd-green/SKILL.md" 2>/dev/null; then
    echo "PASS"
else
    echo "FAIL"
    ERRORS=$((ERRORS + 1))
fi

# TC-03: tdd-refactor Step 5 に tdd-review 自動実行の記述があること
echo -n "TC-03: tdd-refactor Step 5 has tdd-review auto-execution... "
if grep -q "Skill.*tdd-core:tdd-review\|tdd-review.*自動実行\|auto.*tdd-review" "$PLUGIN_DIR/tdd-refactor/SKILL.md" 2>/dev/null; then
    echo "PASS"
else
    echo "FAIL"
    ERRORS=$((ERRORS + 1))
fi

# TC-04: tdd-review Step 6 が手動判断を維持していること（tdd-commit自動実行がないこと）
echo -n "TC-04: tdd-review Step 6 maintains manual judgment (no tdd-commit auto)... "
if ! grep -q "Skill.*tdd-core:tdd-commit\|tdd-commit.*自動実行\|auto.*tdd-commit" "$PLUGIN_DIR/tdd-review/SKILL.md" 2>/dev/null; then
    echo "PASS"
else
    echo "FAIL (found tdd-commit auto-execution)"
    ERRORS=$((ERRORS + 1))
fi

# TC-05: plan-review Step 4 PASS が手動判断になっていること（tdd-red自動実行がないこと）
echo -n "TC-05: plan-review Step 4 PASS maintains manual judgment (no tdd-red auto)... "
if ! grep -q "Skill.*tdd-core:tdd-red\|tdd-red.*自動実行\|auto.*tdd-red" "$PLUGIN_DIR/plan-review/SKILL.md" 2>/dev/null; then
    echo "PASS"
else
    echo "FAIL (found tdd-red auto-execution)"
    ERRORS=$((ERRORS + 1))
fi

# TC-06: tdd-onboard に allowedTools 推奨設定の記述があること
echo -n "TC-06: tdd-onboard has allowedTools recommendation... "
if grep -q "allowedTools\|Skill.*tdd-core" "$PLUGIN_DIR/tdd-onboard/SKILL.md" 2>/dev/null; then
    echo "PASS"
else
    echo "FAIL"
    ERRORS=$((ERRORS + 1))
fi

# TC-07: 各SKILL.mdが100行以下であること
echo -n "TC-07: All SKILL.md files are under 100 lines... "
TC07_FAIL=0
for skill in tdd-red tdd-green tdd-refactor tdd-review tdd-onboard plan-review; do
    LINES=$(wc -l < "$PLUGIN_DIR/$skill/SKILL.md" 2>/dev/null | tr -d ' ')
    if [ "$LINES" -gt 100 ]; then
        echo ""
        echo "  FAIL: $skill/SKILL.md has $LINES lines (max 100)"
        TC07_FAIL=1
    fi
done
if [ "$TC07_FAIL" -eq 0 ]; then
    echo "PASS"
else
    ERRORS=$((ERRORS + 1))
fi

# TC-08: scripts/test-plugins-structure.sh が通ること
echo -n "TC-08: test-plugins-structure.sh passes... "
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
