#!/bin/bash
# Test script for tdd-init documentation

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
echo "tdd-init Documentation Test"
echo "=========================================="

SKILL_PATH="plugins/tdd-core/skills/tdd-init/SKILL.md"
REF_PATH="plugins/tdd-core/skills/tdd-init/reference.md"
REF_JA_PATH="plugins/tdd-core/skills/tdd-init/reference.ja.md"
TEMPLATE_PATH="plugins/tdd-core/skills/tdd-init/templates/cycle.md"

# TC-01: SKILL.md is in English
grep -q "# TDD INIT Phase" "$SKILL_PATH"
check "TC-01: SKILL.md has English title"

grep -q "Start a new TDD cycle" "$SKILL_PATH"
check "TC-01: SKILL.md has English description"

# TC-02: reference.md is in English
grep -q "# tdd-init Reference" "$REF_PATH"
check "TC-02: reference.md has English title"

grep -q "Risk Score Assessment Details" "$REF_PATH"
check "TC-02: reference.md has English section headers"

# TC-03: reference.ja.md exists in Japanese
test -f "$REF_JA_PATH"
check "TC-03: reference.ja.md exists"

grep -q "リスクスコア判定の詳細" "$REF_JA_PATH"
check "TC-03: reference.ja.md has Japanese content"

# TC-04: templates/cycle.md is in English
grep -q "# Cycle Doc Template" "$TEMPLATE_PATH"
check "TC-04: templates/cycle.md has English title"

grep -q "Copy and create" "$TEMPLATE_PATH"
check "TC-04: templates/cycle.md has English instructions"

# TC-05: SKILL.md is under 100 lines
LINES=$(wc -l < "$SKILL_PATH")
test "$LINES" -le 100
check "TC-05: SKILL.md is $LINES lines (≤100)"

# Additional checks
grep -q "reference.ja.md" "$SKILL_PATH"
check "SKILL.md links to Japanese reference"

grep -q "Keyword Scores" "$REF_PATH"
check "reference.md has Keyword Scores section"

grep -q "Risk-Type Questions" "$REF_PATH"
check "reference.md has Risk-Type Questions section"

echo ""
echo "=========================================="
echo "Results: $PASSED passed, $FAILED failed"
echo "=========================================="

exit $FAILED
