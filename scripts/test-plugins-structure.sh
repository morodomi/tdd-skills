#!/bin/bash
# Plugin Structure Test
# Plugin/Marketplace構造の検証

PLUGINS_DIR="${1:-plugins}"

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
echo "Plugin Structure Test"
echo "Directory: $PLUGINS_DIR"
echo "=========================================="
echo ""

# TC-01: tdd-core plugin.json exists and is valid
echo "--- tdd-core ---"
CORE_PLUGIN="$PLUGINS_DIR/tdd-core/.claude-plugin/plugin.json"
if [ -f "$CORE_PLUGIN" ]; then
    test_pass "plugin.json exists"
    # Check if valid JSON
    if python3 -c "import json; json.load(open('$CORE_PLUGIN'))" 2>/dev/null; then
        test_pass "plugin.json is valid JSON"
    else
        test_fail "plugin.json is invalid JSON"
    fi
else
    test_fail "plugin.json not found"
fi

# TC-02: tdd-core has 7 TDD skills
TDD_SKILLS="tdd-init tdd-plan tdd-red tdd-green tdd-refactor tdd-review tdd-commit"
SKILL_COUNT=0
for skill in $TDD_SKILLS; do
    if [ -f "$PLUGINS_DIR/tdd-core/skills/$skill/SKILL.md" ]; then
        ((SKILL_COUNT++))
    fi
done
if [ "$SKILL_COUNT" -eq 7 ]; then
    test_pass "tdd-core has 7 TDD skills"
else
    test_fail "tdd-core has $SKILL_COUNT/7 TDD skills"
fi
echo ""

# TC-03: tdd-php plugin.json exists and is valid
echo "--- tdd-php ---"
PHP_PLUGIN="$PLUGINS_DIR/tdd-php/.claude-plugin/plugin.json"
if [ -f "$PHP_PLUGIN" ]; then
    test_pass "plugin.json exists"
    if python3 -c "import json; json.load(open('$PHP_PLUGIN'))" 2>/dev/null; then
        test_pass "plugin.json is valid JSON"
    else
        test_fail "plugin.json is invalid JSON"
    fi
else
    test_fail "plugin.json not found"
fi

# TC-03b: tdd-php has php-quality skill
if [ -f "$PLUGINS_DIR/tdd-php/skills/php-quality/SKILL.md" ]; then
    test_pass "php-quality skill exists"
else
    test_fail "php-quality skill not found"
fi
echo ""

# TC-04: tdd-python plugin.json exists and is valid
echo "--- tdd-python ---"
PYTHON_PLUGIN="$PLUGINS_DIR/tdd-python/.claude-plugin/plugin.json"
if [ -f "$PYTHON_PLUGIN" ]; then
    test_pass "plugin.json exists"
    if python3 -c "import json; json.load(open('$PYTHON_PLUGIN'))" 2>/dev/null; then
        test_pass "plugin.json is valid JSON"
    else
        test_fail "plugin.json is invalid JSON"
    fi
else
    test_fail "plugin.json not found"
fi

# TC-04b: tdd-python has python-quality skill
if [ -f "$PLUGINS_DIR/tdd-python/skills/python-quality/SKILL.md" ]; then
    test_pass "python-quality skill exists"
else
    test_fail "python-quality skill not found"
fi
echo ""

# TC-05: tdd-js plugin.json exists and is valid
echo "--- tdd-js ---"
JS_PLUGIN="$PLUGINS_DIR/tdd-js/.claude-plugin/plugin.json"
if [ -f "$JS_PLUGIN" ]; then
    test_pass "plugin.json exists"
    if python3 -c "import json; json.load(open('$JS_PLUGIN'))" 2>/dev/null; then
        test_pass "plugin.json is valid JSON"
    else
        test_fail "plugin.json is invalid JSON"
    fi
else
    test_fail "plugin.json not found"
fi

# TC-05b: tdd-js has js-quality skill
if [ -f "$PLUGINS_DIR/tdd-js/skills/js-quality/SKILL.md" ]; then
    test_pass "js-quality skill exists"
else
    test_fail "js-quality skill not found"
fi
echo ""

# TC-06: tdd-hugo plugin.json exists and is valid
echo "--- tdd-hugo ---"
HUGO_PLUGIN="$PLUGINS_DIR/tdd-hugo/.claude-plugin/plugin.json"
if [ -f "$HUGO_PLUGIN" ]; then
    test_pass "plugin.json exists"
    if python3 -c "import json; json.load(open('$HUGO_PLUGIN'))" 2>/dev/null; then
        test_pass "plugin.json is valid JSON"
    else
        test_fail "plugin.json is invalid JSON"
    fi
else
    test_fail "plugin.json not found"
fi

# TC-06b: tdd-hugo has hugo-quality skill
if [ -f "$PLUGINS_DIR/tdd-hugo/skills/hugo-quality/SKILL.md" ]; then
    test_pass "hugo-quality skill exists"
else
    test_fail "hugo-quality skill not found"
fi
echo ""

# TC-07: marketplace.json exists and is valid
echo "--- marketplace ---"
MARKETPLACE=".claude-plugin/marketplace.json"
if [ -f "$MARKETPLACE" ]; then
    test_pass "marketplace.json exists"
    if python3 -c "import json; json.load(open('$MARKETPLACE'))" 2>/dev/null; then
        test_pass "marketplace.json is valid JSON"
    else
        test_fail "marketplace.json is invalid JSON"
    fi
else
    test_fail "marketplace.json not found"
fi
echo ""

echo "=========================================="
echo "Results: $PASS passed, $FAIL failed"
echo "=========================================="

if [ "$FAIL" -gt 0 ]; then
    exit 1
fi
