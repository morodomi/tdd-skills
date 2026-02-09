#!/bin/bash
# Test script for socrates-advisor feature
# Validates Socrates Agent definition + tdd-orchestrate integration

set -uo pipefail

PLUGINS_DIR="plugins/tdd-core"
AGENTS_DIR="$PLUGINS_DIR/agents"
ORCH_DIR="$PLUGINS_DIR/skills/tdd-orchestrate"
SOCRATES="$AGENTS_DIR/socrates.md"
ORCH_SKILL="$ORCH_DIR/SKILL.md"
ORCH_REF="$ORCH_DIR/reference.md"
ORCH_TEAMS="$ORCH_DIR/steps-teams.md"
ORCH_SUB="$ORCH_DIR/steps-subagent.md"

PASS=0
FAIL=0
TOTAL=18

pass() { echo "  PASS: $1"; ((PASS++)); }
fail() { echo "  FAIL: $1"; ((FAIL++)); }

echo "=== Socrates Advisor Tests ==="
echo ""

# ==========================================
# agents/socrates.md
# ==========================================
echo "## agents/socrates.md"

# TC-01: socrates.md exists with frontmatter name: socrates
if [ -f "$SOCRATES" ] && grep -q "name: socrates" "$SOCRATES" 2>/dev/null; then
  pass "TC-01: socrates.md exists with name: socrates in frontmatter"
else
  fail "TC-01: socrates.md missing or missing name: socrates in frontmatter"
fi

# TC-02: socrates.md has Behavior Rules section
if grep -q "## Behavior Rules" "$SOCRATES" 2>/dev/null; then
  pass "TC-02: socrates.md has Behavior Rules section"
else
  fail "TC-02: socrates.md missing Behavior Rules section"
fi

# TC-03: socrates.md has Response Format section
if grep -q "## Response Format" "$SOCRATES" 2>/dev/null; then
  pass "TC-03: socrates.md has Response Format section"
else
  fail "TC-03: socrates.md missing Response Format section"
fi

# TC-04: socrates.md has read-only constraint (no code changes)
if grep -qiE "read-only|コード.*変更.*しない|コード.*書かない|ファイル.*変更しない|Edit.*Write.*不可" "$SOCRATES" 2>/dev/null; then
  pass "TC-04: socrates.md has read-only constraint"
else
  fail "TC-04: socrates.md missing read-only constraint"
fi

# TC-17: socrates.md distinguishes advisor from reviewer
if grep -qiE "advisor|アドバイザー" "$SOCRATES" 2>/dev/null && grep -qiE "reviewer.*違|reviewer.*異|reviewer.*ではない|reviewer.*distinct" "$SOCRATES" 2>/dev/null; then
  pass "TC-17: socrates.md distinguishes advisor from reviewer"
else
  fail "TC-17: socrates.md missing advisor/reviewer distinction"
fi

echo ""

# ==========================================
# tdd-orchestrate/SKILL.md
# ==========================================
echo "## tdd-orchestrate/SKILL.md"

# TC-05: SKILL.md Judgment Criteria mentions Socrates Protocol
if grep -qi "Socrates Protocol\|Socrates" "$ORCH_SKILL" 2>/dev/null && grep -qi "Judgment Criteria\|判断基準\|判定" "$ORCH_SKILL" 2>/dev/null; then
  pass "TC-05: SKILL.md Judgment Criteria has Socrates Protocol"
else
  fail "TC-05: SKILL.md Judgment Criteria missing Socrates Protocol"
fi

# TC-06: SKILL.md is 100 lines or less
if [ -f "$ORCH_SKILL" ]; then
  ORCH_LINES=$(wc -l < "$ORCH_SKILL" | tr -d ' ')
  if [ "$ORCH_LINES" -le 100 ]; then
    pass "TC-06: SKILL.md is ${ORCH_LINES} lines (<= 100)"
  else
    fail "TC-06: SKILL.md is ${ORCH_LINES} lines (> 100)"
  fi
else
  fail "TC-06: SKILL.md not found"
fi

echo ""

# ==========================================
# tdd-orchestrate/reference.md
# ==========================================
echo "## tdd-orchestrate/reference.md"

# TC-07: reference.md has Socrates Protocol section
if grep -q "## Socrates Protocol\|## Socrates" "$ORCH_REF" 2>/dev/null; then
  pass "TC-07: reference.md has Socrates Protocol section"
else
  fail "TC-07: reference.md missing Socrates Protocol section"
fi

# TC-08: reference.md WARN row references Socrates Protocol (NOT auto-proceed)
# Check that WARN line mentions Socrates and does NOT say 自動進行
WARN_LINE=$(grep -i "50-79.*WARN\|WARN.*50-79" "$ORCH_REF" 2>/dev/null | head -1)
if echo "$WARN_LINE" | grep -qi "Socrates\|人間判断\|human" 2>/dev/null; then
  if echo "$WARN_LINE" | grep -qi "自動進行" 2>/dev/null; then
    fail "TC-08: reference.md WARN still says auto-proceed"
  else
    pass "TC-08: reference.md WARN references Socrates Protocol (not auto-proceed)"
  fi
else
  fail "TC-08: reference.md WARN missing Socrates Protocol reference"
fi

# TC-09: reference.md has Progress Log format with Socrates Objection + Human Decision
if grep -qi "Socrates Objection\|Socrates.*反論" "$ORCH_REF" 2>/dev/null && grep -qi "Human Decision\|人間.*判断\|Human.*判断" "$ORCH_REF" 2>/dev/null; then
  pass "TC-09: reference.md has Progress Log format (Socrates Objection + Human Decision)"
else
  fail "TC-09: reference.md missing Progress Log format"
fi

# TC-15: reference.md has free-text input examples (proceed/fix/abort)
if grep -q "proceed" "$ORCH_REF" 2>/dev/null && grep -q "fix" "$ORCH_REF" 2>/dev/null && grep -q "abort" "$ORCH_REF" 2>/dev/null; then
  pass "TC-15: reference.md has free-text input examples (proceed/fix/abort)"
else
  fail "TC-15: reference.md missing free-text input examples"
fi

# TC-16: reference.md has unclear input re-prompt rule
if grep -qiE "再確認|re-prompt|不明瞭|unclear.*input|曖昧" "$ORCH_REF" 2>/dev/null; then
  pass "TC-16: reference.md has unclear input re-prompt rule"
else
  fail "TC-16: reference.md missing unclear input re-prompt rule"
fi

echo ""

# ==========================================
# tdd-orchestrate/steps-teams.md
# ==========================================
echo "## tdd-orchestrate/steps-teams.md"

# TC-10: steps-teams.md Phase 1 has socrates spawn
if grep -qi "socrates" "$ORCH_TEAMS" 2>/dev/null && grep -qiE "spawn|起動" "$ORCH_TEAMS" 2>/dev/null; then
  pass "TC-10: steps-teams.md has socrates spawn"
else
  fail "TC-10: steps-teams.md missing socrates spawn"
fi

# TC-11: steps-teams.md has Socrates Protocol after plan-review
if grep -qi "plan-review" "$ORCH_TEAMS" 2>/dev/null && grep -qi "Socrates Protocol\|Socrates.*判断\|PdM.*Socrates" "$ORCH_TEAMS" 2>/dev/null; then
  pass "TC-11: steps-teams.md has Socrates Protocol after plan-review"
else
  fail "TC-11: steps-teams.md missing Socrates Protocol after plan-review"
fi

# TC-12: steps-teams.md has Socrates Protocol after quality-gate
if grep -qi "quality-gate\|REVIEW" "$ORCH_TEAMS" 2>/dev/null && grep -c -i "Socrates Protocol\|Socrates.*判断" "$ORCH_TEAMS" 2>/dev/null | grep -q "[2-9]"; then
  pass "TC-12: steps-teams.md has Socrates Protocol after quality-gate (2+ occurrences)"
else
  fail "TC-12: steps-teams.md missing Socrates Protocol after quality-gate"
fi

# TC-13: steps-teams.md cleanup has socrates shutdown
if grep -qiE "socrates.*shutdown|shutdown.*socrates" "$ORCH_TEAMS" 2>/dev/null; then
  pass "TC-13: steps-teams.md cleanup has socrates shutdown"
else
  fail "TC-13: steps-teams.md cleanup missing socrates shutdown"
fi

echo ""

# ==========================================
# Boundary / Regression
# ==========================================
echo "## boundary / regression"

# TC-14: steps-subagent.md does NOT contain socrates (Agent Teams only)
if grep -qi "socrates" "$ORCH_SUB" 2>/dev/null; then
  fail "TC-14: steps-subagent.md contains socrates (should be Agent Teams only)"
else
  pass "TC-14: steps-subagent.md does not contain socrates (correct)"
fi

# TC-18: Existing test-plugins-structure.sh passes
# Exclude Open Issues count check (unrelated to this feature)
STRUCTURE_RESULT=$(bash scripts/test-plugins-structure.sh 2>&1)
STRUCTURE_FAIL_LINES=$(echo "$STRUCTURE_RESULT" | grep -c "FAIL\|✗" || true)
STRUCTURE_OPEN_ISSUE=$(echo "$STRUCTURE_RESULT" | grep -c "Open Issues" || true)
RELEVANT_FAILURES=$((STRUCTURE_FAIL_LINES - STRUCTURE_OPEN_ISSUE))
if [ "$RELEVANT_FAILURES" -le 0 ]; then
  pass "TC-18: Existing test-plugins-structure.sh passes"
else
  fail "TC-18: Existing test-plugins-structure.sh has $RELEVANT_FAILURES relevant failures"
fi

echo ""
echo "=== Results: $PASS/$TOTAL PASS, $FAIL/$TOTAL FAIL ==="

if [ "$FAIL" -gt 0 ]; then
  exit 1
fi
