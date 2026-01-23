#!/bin/bash

# Phase 5: 質問駆動INITのテスト
# TC-01: BLOCK時にリスクタイプ別質問の記述がある
# TC-02: セキュリティ関連の質問テンプレートがある
# TC-03: 外部連携関連の質問テンプレートがある
# TC-04: データ変更関連の質問テンプレートがある
# TC-05: Cycle docテンプレートに回答記録欄がある
# TC-06: SKILL.mdが100行以下

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
PASSED=0
FAILED=0

pass() { echo "✓ $1"; ((PASSED++)); }
fail() { echo "✗ $1"; ((FAILED++)); }

echo "=== Question-Driven INIT Tests ==="
echo ""

TDD_INIT_SKILL="$PROJECT_ROOT/plugins/tdd-core/skills/tdd-init/SKILL.md"
TDD_INIT_REF="$PROJECT_ROOT/plugins/tdd-core/skills/tdd-init/reference.md"
CYCLE_TEMPLATE="$PROJECT_ROOT/plugins/tdd-core/skills/tdd-init/templates/cycle.md"

# TC-01: BLOCK時にリスクタイプ別質問の記述
echo "--- TC-01: BLOCK時リスクタイプ別質問 ---"
if grep -q "リスクタイプ別質問\|Step 4.6" "$TDD_INIT_SKILL" 2>/dev/null; then
    pass "TC-01: SKILL.md has risk-type question step"
else
    fail "TC-01: SKILL.md missing risk-type question step"
fi

# TC-02: セキュリティ関連の質問テンプレート
echo ""
echo "--- TC-02: セキュリティ質問テンプレート ---"
if grep -q "認証方式" "$TDD_INIT_REF" 2>/dev/null && \
   grep -q "2FA\|二要素" "$TDD_INIT_REF" 2>/dev/null; then
    pass "TC-02: reference.md has security questions"
else
    fail "TC-02: reference.md missing security questions"
fi

# TC-03: 外部連携関連の質問テンプレート
echo ""
echo "--- TC-03: 外部連携質問テンプレート ---"
if grep -q "API認証\|エラー処理\|レート制限" "$TDD_INIT_REF" 2>/dev/null; then
    pass "TC-03: reference.md has API questions"
else
    fail "TC-03: reference.md missing API questions"
fi

# TC-04: データ変更関連の質問テンプレート
echo ""
echo "--- TC-04: データ変更質問テンプレート ---"
if grep -q "既存データ\|ロールバック" "$TDD_INIT_REF" 2>/dev/null; then
    pass "TC-04: reference.md has data questions"
else
    fail "TC-04: reference.md missing data questions"
fi

# TC-05: Cycle docテンプレートに回答記録欄
echo ""
echo "--- TC-05: Cycle doc回答記録欄 ---"
if grep -q "Risk Interview\|リスクインタビュー" "$CYCLE_TEMPLATE" 2>/dev/null; then
    pass "TC-05: cycle.md has Risk Interview section"
else
    fail "TC-05: cycle.md missing Risk Interview section"
fi

# TC-06: SKILL.md行数
echo ""
echo "--- TC-06: SKILL.md行数 ---"
LINE_COUNT=$(wc -l < "$TDD_INIT_SKILL" | tr -d ' ')
if [ "$LINE_COUNT" -le 100 ]; then
    pass "TC-06: SKILL.md is $LINE_COUNT lines (<= 100)"
else
    fail "TC-06: SKILL.md is $LINE_COUNT lines (> 100)"
fi

# Summary
echo ""
echo "=== Summary ==="
echo "Passed: $PASSED"
echo "Failed: $FAILED"

if [ $FAILED -gt 0 ]; then
    exit 1
fi
