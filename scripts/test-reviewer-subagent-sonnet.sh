#!/bin/bash
# Test script for reviewer-subagent-sonnet feature
# Validates that plan-review/quality-gate use Subagent + Sonnet exclusively

set -uo pipefail

PLUGINS_DIR="plugins/tdd-core/skills"
PASS=0
FAIL=0
TOTAL=13

pass() { echo "  PASS: $1"; ((PASS++)); }
fail() { echo "  FAIL: $1"; ((FAIL++)); }

echo "=== Reviewer Subagent + Sonnet Tests ==="
echo ""

# --- plan-review ---
echo "## plan-review"

# TC-01: SKILL.md に Agent Teams モード選択テーブルが存在しないこと
if ! grep -q "討論型 (Agent Teams)" "$PLUGINS_DIR/plan-review/SKILL.md" 2>/dev/null; then
  pass "TC-01: SKILL.md にモード選択テーブルなし"
else
  fail "TC-01: SKILL.md にモード選択テーブルが残っている"
fi

# TC-02: SKILL.md に「Subagent」「Sonnet」の記載があること
if grep -qi "subagent" "$PLUGINS_DIR/plan-review/SKILL.md" && \
   grep -qi "sonnet" "$PLUGINS_DIR/plan-review/SKILL.md"; then
  pass "TC-02: SKILL.md に Subagent/Sonnet 記載あり"
else
  fail "TC-02: SKILL.md に Subagent/Sonnet 記載なし"
fi

# TC-03: steps-subagent.md に model: sonnet の記載があること
if grep -qiE "model.*sonnet|model: sonnet|model:.*sonnet" "$PLUGINS_DIR/plan-review/steps-subagent.md" 2>/dev/null; then
  pass "TC-03: steps-subagent.md に model: sonnet 記載あり"
else
  fail "TC-03: steps-subagent.md に model: sonnet 記載なし"
fi

echo ""

# --- quality-gate ---
echo "## quality-gate"

# TC-04: SKILL.md に Agent Teams モード選択テーブルが存在しないこと
if ! grep -q "討論型 (Agent Teams)" "$PLUGINS_DIR/quality-gate/SKILL.md" 2>/dev/null; then
  pass "TC-04: SKILL.md にモード選択テーブルなし"
else
  fail "TC-04: SKILL.md にモード選択テーブルが残っている"
fi

# TC-05: SKILL.md に「Subagent」「Sonnet」の記載があること
if grep -qi "subagent" "$PLUGINS_DIR/quality-gate/SKILL.md" && \
   grep -qi "sonnet" "$PLUGINS_DIR/quality-gate/SKILL.md"; then
  pass "TC-05: SKILL.md に Subagent/Sonnet 記載あり"
else
  fail "TC-05: SKILL.md に Subagent/Sonnet 記載なし"
fi

# TC-06: steps-subagent.md に model: sonnet の記載があること
if grep -qiE "model.*sonnet|model: sonnet|model:.*sonnet" "$PLUGINS_DIR/quality-gate/steps-subagent.md" 2>/dev/null; then
  pass "TC-06: steps-subagent.md に model: sonnet 記載あり"
else
  fail "TC-06: steps-subagent.md に model: sonnet 記載なし"
fi

echo ""

# --- tdd-orchestrate ---
echo "## tdd-orchestrate"

ORCH_TEAMS="$PLUGINS_DIR/tdd-orchestrate/steps-teams.md"

# TC-07: steps-teams.md の plan-review が Skill 呼び出し形式であること
if grep -qE "Skill.*plan-review" "$ORCH_TEAMS" 2>/dev/null; then
  pass "TC-07: orchestrate steps-teams.md に plan-review Skill呼び出しあり"
else
  fail "TC-07: orchestrate steps-teams.md に plan-review Skill呼び出しなし"
fi

# TC-08: steps-teams.md の quality-gate が Skill 呼び出し形式であること
if grep -qE "Skill.*quality-gate|Skill.*tdd-review" "$ORCH_TEAMS" 2>/dev/null; then
  pass "TC-08: orchestrate steps-teams.md に quality-gate Skill呼び出しあり"
else
  fail "TC-08: orchestrate steps-teams.md に quality-gate Skill呼び出しなし"
fi

# TC-09: steps-teams.md に reviewer teammate の直接起動が存在しないこと
if ! grep -q "scope-reviewer.*architecture-reviewer" "$ORCH_TEAMS" 2>/dev/null && \
   ! grep -q "correctness-reviewer.*performance-reviewer" "$ORCH_TEAMS" 2>/dev/null; then
  pass "TC-09: orchestrate steps-teams.md に reviewer 直接起動なし"
else
  fail "TC-09: orchestrate steps-teams.md に reviewer 直接起動が残っている"
fi

echo ""

# --- 共通 ---
echo "## common"

# TC-10: steps-teams.md が plan-review/quality-gate から削除されていること
if [ ! -f "$PLUGINS_DIR/plan-review/steps-teams.md" ] && \
   [ ! -f "$PLUGINS_DIR/quality-gate/steps-teams.md" ]; then
  pass "TC-10: steps-teams.md が両スキルから削除済み"
else
  fail "TC-10: steps-teams.md が残っている"
fi

# TC-11: plan-review/steps-subagent.md にエラー時の記載があること
if grep -qiE "エラー時|失敗時|順次実行" "$PLUGINS_DIR/plan-review/steps-subagent.md" 2>/dev/null; then
  pass "TC-11: plan-review/steps-subagent.md にエラー時記載あり"
else
  fail "TC-11: plan-review/steps-subagent.md にエラー時記載なし"
fi

# TC-12: quality-gate/steps-subagent.md にエラー時の記載があること
if grep -qiE "エラー時|失敗時|順次実行" "$PLUGINS_DIR/quality-gate/steps-subagent.md" 2>/dev/null; then
  pass "TC-12: quality-gate/steps-subagent.md にエラー時記載あり"
else
  fail "TC-12: quality-gate/steps-subagent.md にエラー時記載なし"
fi

# TC-13: 既存の Plugin 構造テスト (test-plugins-structure.sh) が通ること
echo ""
echo "## TC-13: existing structure test"
STRUCTURE_RESULT=$(bash scripts/test-plugins-structure.sh 2>&1)
if echo "$STRUCTURE_RESULT" | grep -q "0 failed"; then
  pass "TC-13: 既存 Plugin 構造テスト PASS"
else
  fail "TC-13: 既存 Plugin 構造テスト FAIL"
fi

echo ""
echo "=== Results: $PASS/$TOTAL PASS, $FAIL/$TOTAL FAIL ==="

if [ "$FAIL" -gt 0 ]; then
  exit 1
fi
