#!/bin/bash
# Git Safety Template Test
# Issue #21: git-safety.md テンプレートの検証

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
echo "Git Safety Template Test"
echo "=========================================="
echo ""

# TC-01: reference.md に git-safety.md テンプレートが存在する
echo "--- TC-01: git-safety.md template in reference.md ---"
if grep -q "### git-safety.md" "$REFERENCE_MD" 2>/dev/null; then
    test_pass "git-safety.md template exists in reference.md"
else
    test_fail "git-safety.md template not found in reference.md"
fi
echo ""

# TC-02: テンプレートに「禁止事項」セクションが含まれる
echo "--- TC-02: 禁止事項 section ---"
if grep -q "## 禁止事項" "$REFERENCE_MD" 2>/dev/null; then
    test_pass "禁止事項 section exists"
else
    test_fail "禁止事項 section not found"
fi
echo ""

# TC-03: テンプレートに「推奨フロー」セクションが含まれる
echo "--- TC-03: 推奨フロー section ---"
if grep -q "## 推奨フロー" "$REFERENCE_MD" 2>/dev/null; then
    test_pass "推奨フロー section exists"
else
    test_fail "推奨フロー section not found"
fi
echo ""

# TC-04: テンプレートに「ブランチ保護」テーブルが含まれる
echo "--- TC-04: ブランチ保護 table ---"
if grep -q "## ブランチ保護" "$REFERENCE_MD" 2>/dev/null; then
    test_pass "ブランチ保護 section exists"
else
    test_fail "ブランチ保護 section not found"
fi
echo ""

# TC-05: SKILL.md の rules 一覧に git-safety.md が含まれる
echo "--- TC-05: git-safety.md in SKILL.md rules list ---"
if grep -q "git-safety.md" "$SKILL_MD" 2>/dev/null; then
    test_pass "git-safety.md in SKILL.md rules list"
else
    test_fail "git-safety.md not in SKILL.md rules list"
fi
echo ""

echo "=========================================="
echo "Results: $PASS passed, $FAIL failed"
echo "=========================================="

if [ "$FAIL" -gt 0 ]; then
    exit 1
fi
