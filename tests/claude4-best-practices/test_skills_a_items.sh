#!/bin/bash
# Test: A項目（Skills への取り込み）
# TC-01 ~ TC-05

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
echo "Testing A項目: Skills への取り込み"
echo "========================================"
echo ""

# Generic template paths
TDD_GREEN="$PROJECT_ROOT/templates/generic/.claude/skills/tdd-green/SKILL.md"
TDD_REFACTOR="$PROJECT_ROOT/templates/generic/.claude/skills/tdd-refactor/SKILL.md"
TDD_PLAN="$PROJECT_ROOT/templates/generic/.claude/skills/tdd-plan/SKILL.md"

# TC-01: tdd-green に A2（過度なエンジニアリング防止）の強化指示がある
echo "TC-01: tdd-green に A2（過度なエンジニアリング防止）の強化指示がある"
if grep -qE "依頼された変更のみ|only.*requested|スコープ外.*DISCOVERED" "$TDD_GREEN"; then
    pass "TC-01: tdd-green に過度なエンジニアリング防止の指示がある"
else
    fail "TC-01: tdd-green に過度なエンジニアリング防止の指示がない"
fi

# TC-02: tdd-green に A3（コード検査の徹底）の指示がある
echo "TC-02: tdd-green に A3（コード検査の徹底）の指示がある"
if grep -qE "必ず.*Read|ALWAYS.*read|変更前.*確認|ファイルを読" "$TDD_GREEN"; then
    pass "TC-02: tdd-green にコード検査の徹底指示がある"
else
    fail "TC-02: tdd-green にコード検査の徹底指示がない"
fi

# TC-03: tdd-refactor に A2, A3 の指示がある
echo "TC-03: tdd-refactor に A2, A3 の指示がある"
A2_REFACTOR=$(grep -cE "依頼された変更のみ|only.*requested|スコープ外.*DISCOVERED" "$TDD_REFACTOR" 2>/dev/null | tr -d '\n' || echo "0")
A3_REFACTOR=$(grep -cE "必ず.*Read|ALWAYS.*read|変更前.*確認|ファイルを読" "$TDD_REFACTOR" 2>/dev/null | tr -d '\n' || echo "0")
if [ "$A2_REFACTOR" -gt 0 ] && [ "$A3_REFACTOR" -gt 0 ]; then
    pass "TC-03: tdd-refactor に A2, A3 の指示がある"
else
    fail "TC-03: tdd-refactor に A2($A2_REFACTOR) または A3($A3_REFACTOR) の指示がない"
fi

# TC-04: tdd-plan に A1（ツール使用の明確化）の指示がある
echo "TC-04: tdd-plan に A1（ツール使用の明確化）の指示がある"
if grep -qE "提案して|suggest.*change|ツール使用.*明確|指示.*違い" "$TDD_PLAN"; then
    pass "TC-04: tdd-plan にツール使用の明確化指示がある"
else
    fail "TC-04: tdd-plan にツール使用の明確化指示がない"
fi

# TC-05: 各Skillの制約に A4（理由）が追記されている
echo "TC-05: 各Skillの制約に A4（理由 Why）が追記されている"
# Check for "なぜ" or "理由" or "because" in constraint sections
WHY_GREEN=$(grep -cE "なぜ|理由:|because|ため:" "$TDD_GREEN" 2>/dev/null | tr -d '\n' || echo "0")
WHY_REFACTOR=$(grep -cE "なぜ|理由:|because|ため:" "$TDD_REFACTOR" 2>/dev/null | tr -d '\n' || echo "0")
if [ "$WHY_GREEN" -ge 3 ] && [ "$WHY_REFACTOR" -ge 1 ]; then
    pass "TC-05: 各Skillの制約に理由が追記されている (green:$WHY_GREEN, refactor:$WHY_REFACTOR)"
else
    fail "TC-05: 各Skillの制約に理由が不足 (green:$WHY_GREEN, refactor:$WHY_REFACTOR)"
fi

echo ""
echo "========================================"
echo "A項目 Results: $PASSED passed, $FAILED failed"
echo "========================================"

exit $FAILED
