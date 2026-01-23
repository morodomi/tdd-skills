#!/bin/bash

# Phase 4: 全体調整・フィードバック反映のテスト
# TC-01: 既存テスト通過
# TC-02: plugin.json バージョン 3.0.0
# TC-03: tdd-plan「ユーザーが続行を確認したら」
# TC-04: tdd-red「テスト条件を見直して再試行」

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
PASSED=0
FAILED=0

pass() { echo "✓ $1"; ((PASSED++)); }
fail() { echo "✗ $1"; ((FAILED++)); }

echo "=== Phase 4 Adjustments Tests ==="
echo ""

# TC-01: 既存テスト通過（plugins構造テスト）
echo "--- TC-01: 既存テスト通過 ---"
cd "$PROJECT_ROOT"
if bash scripts/test-plugins-structure.sh > /dev/null 2>&1; then
    pass "TC-01: 既存テストが全て通過"
else
    fail "TC-01: 既存テストが失敗"
fi

# TC-02: plugin.json バージョン
echo ""
echo "--- TC-02: plugin.json バージョン ---"
PLUGIN_JSON="$PROJECT_ROOT/plugins/tdd-core/.claude-plugin/plugin.json"
if grep -q '"version": "3.0.0"' "$PLUGIN_JSON" 2>/dev/null; then
    pass "TC-02: plugin.json version is 3.0.0"
else
    fail "TC-02: plugin.json version is not 3.0.0"
fi

# TC-03: tdd-plan 表現修正
echo ""
echo "--- TC-03: tdd-plan 表現修正 ---"
TDD_PLAN="$PROJECT_ROOT/plugins/tdd-core/skills/tdd-plan/SKILL.md"
if grep -q "ユーザーが続行を確認したら" "$TDD_PLAN" 2>/dev/null; then
    pass "TC-03: tdd-plan has updated wording"
else
    fail "TC-03: tdd-plan missing updated wording"
fi

# TC-04: tdd-red 表現修正
echo ""
echo "--- TC-04: tdd-red 表現修正 ---"
TDD_RED="$PROJECT_ROOT/plugins/tdd-core/skills/tdd-red/SKILL.md"
if grep -q "テスト条件を見直して再試行" "$TDD_RED" 2>/dev/null; then
    pass "TC-04: tdd-red has updated wording"
else
    fail "TC-04: tdd-red missing updated wording"
fi

# Summary
echo ""
echo "=== Summary ==="
echo "Passed: $PASSED"
echo "Failed: $FAILED"

if [ $FAILED -gt 0 ]; then
    exit 1
fi
