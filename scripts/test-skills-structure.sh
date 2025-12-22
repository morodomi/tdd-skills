#!/bin/bash
# Skills Structure Test
# Progressive Disclosure対応の検証

TEMPLATE_DIR="${1:-templates/generic}"
SKILLS_DIR="$TEMPLATE_DIR/.claude/skills"
MAX_SKILL_LINES=100

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

PASS=0
FAIL=0

# テスト関数
test_pass() {
    echo -e "${GREEN}✓${NC} $1"
    ((PASS++))
}

test_fail() {
    echo -e "${RED}✗${NC} $1"
    ((FAIL++))
}

echo "=========================================="
echo "Skills Structure Test"
echo "Template: $TEMPLATE_DIR"
echo "=========================================="
echo ""

# TDD Skills
TDD_SKILLS="tdd-init tdd-plan tdd-red tdd-green tdd-refactor tdd-review tdd-commit"

for skill in $TDD_SKILLS; do
    echo "--- $skill ---"
    SKILL_PATH="$SKILLS_DIR/$skill"
    SKILL_MD="$SKILL_PATH/SKILL.md"
    REF_MD="$SKILL_PATH/reference.md"

    # TC-01: SKILL.md exists
    if [ -f "$SKILL_MD" ]; then
        test_pass "SKILL.md exists"
    else
        test_fail "SKILL.md not found"
        continue
    fi

    # TC-02: SKILL.md < 100 lines
    LINES=$(wc -l < "$SKILL_MD" | tr -d ' ')
    if [ "$LINES" -lt "$MAX_SKILL_LINES" ]; then
        test_pass "SKILL.md has $LINES lines (< $MAX_SKILL_LINES)"
    else
        test_fail "SKILL.md has $LINES lines (>= $MAX_SKILL_LINES)"
    fi

    # TC-03: reference.md exists (Progressive Disclosure)
    if [ -f "$REF_MD" ]; then
        test_pass "reference.md exists"
    else
        test_fail "reference.md not found"
    fi

    # TC-04: description is concise (< 200 chars)
    DESC=$(grep "^description:" "$SKILL_MD" 2>/dev/null | head -1)
    DESC_LEN=${#DESC}
    if [ "$DESC_LEN" -lt 200 ]; then
        test_pass "description is concise ($DESC_LEN chars)"
    else
        test_fail "description too long ($DESC_LEN chars)"
    fi

    echo ""
done

echo "=========================================="
echo "Results: $PASS passed, $FAIL failed"
echo "=========================================="

if [ "$FAIL" -gt 0 ]; then
    exit 1
fi
