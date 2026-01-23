#!/bin/bash
# Test script for brainstorm enhancement (#33)

PASSED=0
FAILED=0

check() {
    if [ $? -eq 0 ]; then
        echo -e "\033[0;32m✓\033[0m $1"
        ((PASSED++))
    else
        echo -e "\033[0;31m✗\033[0m $1"
        ((FAILED++))
    fi
}

echo "=========================================="
echo "Brainstorm Enhancement Test (#33)"
echo "=========================================="

SKILL_PATH="plugins/tdd-core/skills/tdd-init/SKILL.md"
REF_PATH="plugins/tdd-core/skills/tdd-init/reference.md"
REF_JA_PATH="plugins/tdd-core/skills/tdd-init/reference.ja.md"

# TC-01: SKILL.md mentions Brainstorm
grep -qi "brainstorm\|深掘り\|problem" "$SKILL_PATH"
check "TC-01: SKILL.md mentions Brainstorm/深掘り"

# TC-02: reference.md has Brainstorm template
grep -qi "brainstorm" "$REF_PATH"
check "TC-02: reference.md has Brainstorm section"

# TC-03: reference.ja.md has Brainstorm template
grep -qi "brainstorm\|深掘り" "$REF_JA_PATH"
check "TC-03: reference.ja.md has Brainstorm section"

# TC-04: Has "what problem" question
grep -qi "problem\|問題" "$REF_PATH"
check "TC-04: reference.md has problem clarification question"

# TC-05: SKILL.md is under 100 lines
LINES=$(wc -l < "$SKILL_PATH")
test "$LINES" -le 100
check "TC-05: SKILL.md is $LINES lines (≤100)"

echo ""
echo "=========================================="
echo "Results: $PASSED passed, $FAILED failed"
echo "=========================================="

exit $FAILED
