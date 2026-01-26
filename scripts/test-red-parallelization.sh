#!/bin/bash
# Test script for RED parallelization feature (v4.0)
# Tests TC-01 through TC-11

# Continue on error to show all test results

PLUGIN_DIR="plugins/tdd-core"
RED_WORKER="$PLUGIN_DIR/agents/red-worker.md"
TDD_RED_SKILL="$PLUGIN_DIR/skills/tdd-red/SKILL.md"
TDD_RED_REF="$PLUGIN_DIR/skills/tdd-red/reference.md"

PASSED=0
FAILED=0

pass() {
    echo "  PASS: $1"
    ((PASSED++))
}

fail() {
    echo "  FAIL: $1"
    ((FAILED++))
}

echo "=========================================="
echo "Testing RED Parallelization (v4.0)"
echo "=========================================="

# TC-01: red-worker.md exists in plugins/tdd-core/agents/
echo ""
echo "TC-01: red-worker.md exists"
if [ -f "$RED_WORKER" ]; then
    pass "red-worker.md exists"
else
    fail "red-worker.md does not exist"
fi

# TC-02: red-worker.md has frontmatter (name, description)
echo ""
echo "TC-02: red-worker.md has frontmatter"
if [ -f "$RED_WORKER" ]; then
    if grep -q "^name:" "$RED_WORKER" && grep -q "^description:" "$RED_WORKER"; then
        pass "frontmatter has name and description"
    else
        fail "frontmatter missing name or description"
    fi
else
    fail "red-worker.md does not exist"
fi

# TC-03: red-worker.md has Input section with required fields
echo ""
echo "TC-03: red-worker.md has Input section"
if [ -f "$RED_WORKER" ]; then
    if grep -q "## Input" "$RED_WORKER" && \
       grep -q "test_cases" "$RED_WORKER" && \
       grep -q "cycle_doc" "$RED_WORKER" && \
       grep -q "test_files" "$RED_WORKER" && \
       grep -q "language_plugin" "$RED_WORKER"; then
        pass "Input section has all required fields"
    else
        fail "Input section missing required fields"
    fi
else
    fail "red-worker.md does not exist"
fi

# TC-04: red-worker.md has Output section with JSON format
echo ""
echo "TC-04: red-worker.md has Output section"
if [ -f "$RED_WORKER" ]; then
    if grep -q "## Output" "$RED_WORKER" && \
       grep -q '"status"' "$RED_WORKER" && \
       grep -q '"test_cases"' "$RED_WORKER" && \
       grep -q '"files_created"' "$RED_WORKER" && \
       grep -q "red_state_verified" "$RED_WORKER"; then
        pass "Output section has JSON format with red_state_verified"
    else
        fail "Output section missing required fields"
    fi
else
    fail "red-worker.md does not exist"
fi

# TC-05: red-worker.md has Workflow section (4+ steps)
echo ""
echo "TC-05: red-worker.md has Workflow section"
if [ -f "$RED_WORKER" ]; then
    if grep -q "## Workflow" "$RED_WORKER"; then
        STEP_COUNT=$(grep -c "^[0-9]\." "$RED_WORKER" || echo "0")
        if [ "$STEP_COUNT" -ge 4 ]; then
            pass "Workflow has $STEP_COUNT steps"
        else
            fail "Workflow has only $STEP_COUNT steps (need 4+)"
        fi
    else
        fail "Workflow section missing"
    fi
else
    fail "red-worker.md does not exist"
fi

# TC-06: red-worker.md has Principles section
echo ""
echo "TC-06: red-worker.md has Principles section"
if [ -f "$RED_WORKER" ]; then
    if grep -q "## Principles" "$RED_WORKER" && \
       grep -qi "Given.*When.*Then\|Given/When/Then" "$RED_WORKER" && \
       grep -qi "RED\|fail" "$RED_WORKER"; then
        pass "Principles section has Given/When/Then and RED state"
    else
        fail "Principles section missing required content"
    fi
else
    fail "red-worker.md does not exist"
fi

# TC-07: red-worker.md has Verification Gate section
echo ""
echo "TC-07: red-worker.md has Verification Gate"
if [ -f "$RED_WORKER" ]; then
    if grep -qi "Verification Gate\|verification" "$RED_WORKER" && \
       grep -qi "fail\|FAIL\|失敗" "$RED_WORKER"; then
        pass "Verification Gate section exists"
    else
        fail "Verification Gate section missing"
    fi
else
    fail "red-worker.md does not exist"
fi

# TC-08: tdd-red/SKILL.md has parallel in description
echo ""
echo "TC-08: tdd-red/SKILL.md has parallel reference"
if grep -qi "並列\|parallel" "$TDD_RED_SKILL"; then
    pass "SKILL.md references parallel execution"
else
    fail "SKILL.md does not reference parallel execution"
fi

# TC-09: tdd-red/SKILL.md has file grouping step
echo ""
echo "TC-09: tdd-red/SKILL.md has file grouping step"
if grep -qi "ファイル依存関係\|グルーピング\|grouping\|file.*group" "$TDD_RED_SKILL"; then
    pass "SKILL.md has file grouping step"
else
    fail "SKILL.md missing file grouping step"
fi

# TC-10: tdd-red/SKILL.md has red-worker step
echo ""
echo "TC-10: tdd-red/SKILL.md has red-worker step"
if grep -qi "red-worker.*並列\|red-worker.*parallel\|並列.*起動" "$TDD_RED_SKILL"; then
    pass "SKILL.md has red-worker parallel step"
else
    fail "SKILL.md missing red-worker parallel step"
fi

# TC-11: reference.md documents red-worker and shared fixtures
echo ""
echo "TC-11: reference.md documents red-worker"
if grep -qi "red-worker" "$TDD_RED_REF" && \
   grep -qi "fixture\|conftest\|shared" "$TDD_RED_REF"; then
    pass "reference.md documents red-worker and shared fixtures"
else
    fail "reference.md missing red-worker or shared fixtures documentation"
fi

# Summary
echo ""
echo "=========================================="
echo "Results: $PASSED passed, $FAILED failed"
echo "=========================================="

if [ $FAILED -gt 0 ]; then
    exit 1
fi
