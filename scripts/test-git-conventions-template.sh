#!/bin/bash
# Git Conventions Template Test
# Issue #27: git-conventions.md テンプレートの検証

PLUGIN_DIR="plugins/tdd-core/skills/tdd-onboard"
REFERENCE_MD="$PLUGIN_DIR/reference.md"
SKILL_MD="$PLUGIN_DIR/SKILL.md"

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
echo "Git Conventions Template Test"
echo "=========================================="
echo ""

# TC-01: reference.md に git-conventions.md テンプレートが存在する
echo "--- TC-01: git-conventions.md template in reference.md ---"
if grep -q "### git-conventions.md" "$REFERENCE_MD" 2>/dev/null; then
    test_pass "git-conventions.md template exists in reference.md"
else
    test_fail "git-conventions.md template not found in reference.md"
fi
echo ""

# TC-02: テンプレートにType一覧が含まれる
echo "--- TC-02: Type一覧 section ---"
if grep -q "## Type" "$REFERENCE_MD" 2>/dev/null; then
    test_pass "Type一覧 section exists"
else
    test_fail "Type一覧 section not found"
fi
echo ""

# TC-03: SKILL.md の rules 一覧に git-conventions.md が含まれる
echo "--- TC-03: git-conventions.md in SKILL.md rules list ---"
if grep -q "git-conventions.md" "$SKILL_MD" 2>/dev/null; then
    test_pass "git-conventions.md in SKILL.md rules list"
else
    test_fail "git-conventions.md not in SKILL.md rules list"
fi
echo ""

echo "=========================================="
echo "Results: $PASS passed, $FAIL failed"
echo "=========================================="

if [ "$FAIL" -gt 0 ]; then
    exit 1
fi
