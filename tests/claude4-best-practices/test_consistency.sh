#!/bin/bash
# Test: 一貫性チェック
# TC-11 ~ TC-12

# Don't exit on error - we want to run all tests

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

PASSED=0
FAILED=0

pass() {
    echo -e "${GREEN}PASS${NC}: $1"
    ((PASSED++))
}

fail() {
    echo -e "${RED}FAIL${NC}: $1"
    ((FAILED++))
}

echo "========================================"
echo "Testing 一貫性チェック"
echo "========================================"
echo ""

# TC-11: 3テンプレートで A項目の内容が一致（tdd-green を比較）
echo "TC-11: 3テンプレートで A項目のSkills内容が一致"

GENERIC_GREEN="$PROJECT_ROOT/templates/generic/.claude/skills/tdd-green/SKILL.md"
LARAVEL_GREEN="$PROJECT_ROOT/templates/laravel/.claude/skills/tdd-green/SKILL.md"
BEDROCK_GREEN="$PROJECT_ROOT/templates/bedrock/.claude/skills/tdd-green/SKILL.md"

# Check if A2 pattern exists in all three
A2_GENERIC=$(grep -cE "依頼された変更のみ|スコープ外.*DISCOVERED" "$GENERIC_GREEN" 2>/dev/null | tr -d '\n' || echo "0")
A2_LARAVEL=$(grep -cE "依頼された変更のみ|スコープ外.*DISCOVERED" "$LARAVEL_GREEN" 2>/dev/null | tr -d '\n' || echo "0")
A2_BEDROCK=$(grep -cE "依頼された変更のみ|スコープ外.*DISCOVERED" "$BEDROCK_GREEN" 2>/dev/null | tr -d '\n' || echo "0")

if [ "$A2_GENERIC" -gt 0 ] && [ "$A2_LARAVEL" -gt 0 ] && [ "$A2_BEDROCK" -gt 0 ]; then
    pass "TC-11: 3テンプレートで A項目のSkills内容が一致 (generic:$A2_GENERIC, laravel:$A2_LARAVEL, bedrock:$A2_BEDROCK)"
else
    fail "TC-11: 3テンプレートで A項目のSkills内容が不一致 (generic:$A2_GENERIC, laravel:$A2_LARAVEL, bedrock:$A2_BEDROCK)"
fi

# TC-12: 3テンプレートで B項目の内容が一致
echo "TC-12: 3テンプレートで B項目のCLAUDE.md内容が一致"

GENERIC_CLAUDE="$PROJECT_ROOT/templates/generic/CLAUDE.md.example"
LARAVEL_CLAUDE="$PROJECT_ROOT/templates/laravel/CLAUDE.md.template"
BEDROCK_CLAUDE="$PROJECT_ROOT/templates/bedrock/CLAUDE.md.example"

# Check B1 (output format) in all three
B1_GENERIC=$(grep -cE "出力フォーマット|マークダウン.*過多" "$GENERIC_CLAUDE" 2>/dev/null | tr -d '\n' || echo "0")
B1_LARAVEL=$(grep -cE "出力フォーマット|マークダウン.*過多" "$LARAVEL_CLAUDE" 2>/dev/null | tr -d '\n' || echo "0")
B1_BEDROCK=$(grep -cE "出力フォーマット|マークダウン.*過多" "$BEDROCK_CLAUDE" 2>/dev/null | tr -d '\n' || echo "0")

if [ "$B1_GENERIC" -gt 0 ] && [ "$B1_LARAVEL" -gt 0 ] && [ "$B1_BEDROCK" -gt 0 ]; then
    pass "TC-12: 3テンプレートで B項目のCLAUDE.md内容が一致 (generic:$B1_GENERIC, laravel:$B1_LARAVEL, bedrock:$B1_BEDROCK)"
else
    fail "TC-12: 3テンプレートで B項目のCLAUDE.md内容が不一致 (generic:$B1_GENERIC, laravel:$B1_LARAVEL, bedrock:$B1_BEDROCK)"
fi

echo ""
echo "========================================"
echo "一貫性チェック Results: $PASSED passed, $FAILED failed"
echo "========================================"

exit $FAILED
