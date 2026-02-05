#!/bin/bash
# Test: skill-md-unification
# Cycle doc: docs/cycles/20260205_0926_skill-md-unification.md

set -e

PLUGIN_DIR="plugins/tdd-core/skills"
ERRORS=0

echo "=== SKILL.md Unification Tests ==="
echo ""

# TC-01: tdd-init Progress Checklistがcheckbox形式であること
echo -n "TC-01: tdd-init Progress Checklist is checkbox format... "
if grep -A10 "Progress Checklist" "$PLUGIN_DIR/tdd-init/SKILL.md" 2>/dev/null | grep -q "\- \[ \]"; then
    echo "PASS"
else
    echo "FAIL"
    ERRORS=$((ERRORS + 1))
fi

# TC-02: tdd-onboard Progress Checklistがcheckbox形式であること
echo -n "TC-02: tdd-onboard Progress Checklist is checkbox format... "
if grep -A10 "Progress Checklist" "$PLUGIN_DIR/tdd-onboard/SKILL.md" 2>/dev/null | grep -q "\- \[ \]"; then
    echo "PASS"
else
    echo "FAIL"
    ERRORS=$((ERRORS + 1))
fi

# TC-03: tdd-plan Progress Checklistがcheckbox形式であること
echo -n "TC-03: tdd-plan Progress Checklist is checkbox format... "
if grep -A10 "Progress Checklist" "$PLUGIN_DIR/tdd-plan/SKILL.md" 2>/dev/null | grep -q "\- \[ \]"; then
    echo "PASS"
else
    echo "FAIL"
    ERRORS=$((ERRORS + 1))
fi

# TC-04: tdd-refactor Progress Checklistがcheckbox形式であること
echo -n "TC-04: tdd-refactor Progress Checklist is checkbox format... "
if grep -A10 "Progress Checklist" "$PLUGIN_DIR/tdd-refactor/SKILL.md" 2>/dev/null | grep -q "\- \[ \]"; then
    echo "PASS"
else
    echo "FAIL"
    ERRORS=$((ERRORS + 1))
fi

# TC-05: tdd-review Progress Checklistがcheckbox形式であること
echo -n "TC-05: tdd-review Progress Checklist is checkbox format... "
if grep -A10 "Progress Checklist" "$PLUGIN_DIR/tdd-review/SKILL.md" 2>/dev/null | grep -q "\- \[ \]"; then
    echo "PASS"
else
    echo "FAIL"
    ERRORS=$((ERRORS + 1))
fi

# TC-06: tdd-commit Progress Checklistがcheckbox形式であること
echo -n "TC-06: tdd-commit Progress Checklist is checkbox format... "
if grep -A10 "Progress Checklist" "$PLUGIN_DIR/tdd-commit/SKILL.md" 2>/dev/null | grep -q "\- \[ \]"; then
    echo "PASS"
else
    echo "FAIL"
    ERRORS=$((ERRORS + 1))
fi

# TC-07: 全SKILL.mdが100行以下であること
echo -n "TC-07: All SKILL.md files are under 100 lines... "
TC07_FAIL=0
for skill in tdd-init tdd-onboard tdd-plan plan-review tdd-red tdd-green tdd-refactor tdd-review quality-gate tdd-commit; do
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
