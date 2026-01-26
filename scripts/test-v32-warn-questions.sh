#!/bin/bash
# v3.2 WARN Questions Test
# Test List verification for question-driven-warn cycle

PLUGIN_DIR="plugins/tdd-core/skills/tdd-init"
SKILL_MD="$PLUGIN_DIR/SKILL.md"
REF_MD="$PLUGIN_DIR/reference.md"
REF_JA_MD="$PLUGIN_DIR/reference.ja.md"
MAX_SKILL_LINES=100

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
echo "v3.2 WARN Questions Test"
echo "=========================================="
echo ""

# TC-01: SKILL.md に Step 4.6 (WARN Questions) がある
if grep -q "Step 4.6" "$SKILL_MD" && grep -qi "WARN" "$SKILL_MD"; then
    test_pass "TC-01: SKILL.md has Step 4.6 (WARN Questions)"
else
    test_fail "TC-01: SKILL.md missing Step 4.6 (WARN Questions)"
fi

# TC-02: SKILL.md の既存 Step 4.6 が Step 4.7 にリナンバーされている
if grep -q "Step 4.7" "$SKILL_MD"; then
    test_pass "TC-02: SKILL.md has Step 4.7 (renumbered from 4.6)"
else
    test_fail "TC-02: SKILL.md missing Step 4.7 (renumber needed)"
fi

# TC-03: SKILL.md のテーブルに WARN → "Quick questions (Step 4.6)" がある
if grep -q "WARN" "$SKILL_MD" && grep -qi "4.6" "$SKILL_MD"; then
    test_pass "TC-03: SKILL.md table has WARN -> Step 4.6 reference"
else
    test_fail "TC-03: SKILL.md table missing WARN -> Step 4.6 reference"
fi

# TC-04: reference.md に "WARN Questions" セクションがある
if grep -qi "WARN Questions\|WARN.*Questions" "$REF_MD"; then
    test_pass "TC-04: reference.md has WARN Questions section"
else
    test_fail "TC-04: reference.md missing WARN Questions section"
fi

# TC-05: reference.md に「代替アプローチ」質問テンプレートがある
if grep -qi "alternative\|代替" "$REF_MD"; then
    test_pass "TC-05: reference.md has alternative approach question"
else
    test_fail "TC-05: reference.md missing alternative approach question"
fi

# TC-06: reference.md に「影響範囲」質問テンプレートがある
if grep -qi "impact\|scope\|影響" "$REF_MD"; then
    test_pass "TC-06: reference.md has impact scope question"
else
    test_fail "TC-06: reference.md missing impact scope question"
fi

# TC-07: reference.ja.md に "WARN質問" セクションがある
if grep -q "WARN質問\|WARN.*質問" "$REF_JA_MD"; then
    test_pass "TC-07: reference.ja.md has WARN Questions section"
else
    test_fail "TC-07: reference.ja.md missing WARN Questions section"
fi

# TC-08: reference.ja.md に「代替アプローチ」質問テンプレートがある
if grep -q "代替アプローチ\|代替案" "$REF_JA_MD"; then
    test_pass "TC-08: reference.ja.md has alternative approach question"
else
    test_fail "TC-08: reference.ja.md missing alternative approach question"
fi

# TC-09: reference.ja.md に「影響範囲」質問テンプレートがある
if grep -q "影響範囲" "$REF_JA_MD"; then
    test_pass "TC-09: reference.ja.md has impact scope question"
else
    test_fail "TC-09: reference.ja.md missing impact scope question"
fi

# TC-10: SKILL.md が100行以下
LINE_COUNT=$(wc -l < "$SKILL_MD" | tr -d ' ')
if [ "$LINE_COUNT" -le "$MAX_SKILL_LINES" ]; then
    test_pass "TC-10: SKILL.md is $LINE_COUNT lines (<= $MAX_SKILL_LINES)"
else
    test_fail "TC-10: SKILL.md is $LINE_COUNT lines (> $MAX_SKILL_LINES)"
fi

echo ""
echo "=========================================="
echo "Results: $PASS passed, $FAIL failed"
echo "=========================================="

exit $FAIL
