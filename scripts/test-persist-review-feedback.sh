#!/bin/bash
# Test script for persist-review-feedback feature (#53)
# Validates that BLOCK sections include Progress Log write instructions

set -uo pipefail

PLUGINS_DIR="plugins/tdd-core/skills"
PASS=0
FAIL=0
TOTAL=9

pass() { echo "  PASS: $1"; ((PASS++)); }
fail() { echo "  FAIL: $1"; ((FAIL++)); }

echo "=== Persist Review Feedback Tests ==="
echo ""

# --- plan-review ---
echo "## plan-review"

# TC-01: plan-review/SKILL.md の BLOCK セクションに Progress Log 追記指示が存在すること
if grep -q "Progress Log" "$PLUGINS_DIR/plan-review/SKILL.md" 2>/dev/null && \
   grep -qiE "追記|記録" "$PLUGINS_DIR/plan-review/SKILL.md" 2>/dev/null; then
  pass "TC-01: BLOCK セクションに Progress Log 追記指示あり"
else
  fail "TC-01: BLOCK セクションに Progress Log 追記指示なし"
fi

# TC-03: plan-review の BLOCK セクションにフォーマット例が含まれること
if grep -qE "YYYY-MM-DD.*PLAN.*BLOCK.*score" "$PLUGINS_DIR/plan-review/SKILL.md" 2>/dev/null; then
  pass "TC-03: BLOCK セクションにフォーマット例あり"
else
  fail "TC-03: BLOCK セクションにフォーマット例なし"
fi

# TC-05: PASS/WARN セクションには Progress Log 追記指示が存在しないこと
# PASS セクション（「スコア49以下」）と WARN セクション（「スコア50-79」）を抽出して確認
PR_PASS_WARN=$(sed -n '/PASS.*スコア49/,/BLOCK.*スコア80/p' "$PLUGINS_DIR/plan-review/SKILL.md" 2>/dev/null | sed '$d')
if echo "$PR_PASS_WARN" | grep -qi "Progress Log"; then
  fail "TC-05: PASS/WARN セクションに Progress Log 記載あり（不要）"
else
  pass "TC-05: PASS/WARN セクションに Progress Log 記載なし"
fi

# TC-07: plan-review の BLOCK フォーマットにフェーズ名 [PLAN] が含まれること
if grep -q "\[PLAN\]" "$PLUGINS_DIR/plan-review/SKILL.md" 2>/dev/null; then
  pass "TC-07: BLOCK フォーマットに [PLAN] あり"
else
  fail "TC-07: BLOCK フォーマットに [PLAN] なし"
fi

echo ""

# --- quality-gate ---
echo "## quality-gate"

# TC-02: quality-gate/SKILL.md の BLOCK セクションに Progress Log 追記指示が存在すること
if grep -q "Progress Log" "$PLUGINS_DIR/quality-gate/SKILL.md" 2>/dev/null && \
   grep -qiE "追記|記録" "$PLUGINS_DIR/quality-gate/SKILL.md" 2>/dev/null; then
  pass "TC-02: BLOCK セクションに Progress Log 追記指示あり"
else
  fail "TC-02: BLOCK セクションに Progress Log 追記指示なし"
fi

# TC-04: quality-gate の BLOCK セクションにフォーマット例が含まれること
if grep -qE "YYYY-MM-DD.*REVIEW.*BLOCK.*score" "$PLUGINS_DIR/quality-gate/SKILL.md" 2>/dev/null; then
  pass "TC-04: BLOCK セクションにフォーマット例あり"
else
  fail "TC-04: BLOCK セクションにフォーマット例なし"
fi

# TC-06: PASS/WARN セクションには Progress Log 追記指示が存在しないこと
QG_PASS_WARN=$(sed -n '/PASS.*スコア49/,/BLOCK.*スコア80/p' "$PLUGINS_DIR/quality-gate/SKILL.md" 2>/dev/null | sed '$d')
if echo "$QG_PASS_WARN" | grep -qi "Progress Log"; then
  fail "TC-06: PASS/WARN セクションに Progress Log 記載あり（不要）"
else
  pass "TC-06: PASS/WARN セクションに Progress Log 記載なし"
fi

# TC-08: quality-gate の BLOCK フォーマットにフェーズ名 [REVIEW] が含まれること
if grep -q "\[REVIEW\]" "$PLUGINS_DIR/quality-gate/SKILL.md" 2>/dev/null; then
  pass "TC-08: BLOCK フォーマットに [REVIEW] あり"
else
  fail "TC-08: BLOCK フォーマットに [REVIEW] なし"
fi

echo ""

# --- 構造 ---
echo "## structure"

# TC-09: 既存 Plugin 構造テスト (test-plugins-structure.sh) が通ること
# Open Issues数チェック(STATUS.md)は本機能と無関係のため除外して判定
STRUCTURE_RESULT=$(bash scripts/test-plugins-structure.sh 2>&1)
STRUCTURE_FAILURES=$(echo "$STRUCTURE_RESULT" | grep -c "^✗\|FAIL" || true)
STRUCTURE_OPEN_ISSUE=$(echo "$STRUCTURE_RESULT" | grep -c "Open Issues" || true)
RELEVANT_FAILURES=$((STRUCTURE_FAILURES - STRUCTURE_OPEN_ISSUE))
if [ "$RELEVANT_FAILURES" -le 0 ]; then
  pass "TC-09: 既存 Plugin 構造テスト PASS"
else
  fail "TC-09: 既存 Plugin 構造テスト FAIL ($RELEVANT_FAILURES relevant failures)"
fi

echo ""
echo "=== Results: $PASS/$TOTAL PASS, $FAIL/$TOTAL FAIL ==="

if [ "$FAIL" -gt 0 ]; then
  exit 1
fi
