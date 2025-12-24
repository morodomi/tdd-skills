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

# TC-02b: tdd-core has agents directory with 7 reviewers
AGENTS_DIR="$PLUGINS_DIR/tdd-core/agents"
if [ -d "$AGENTS_DIR" ]; then
    test_pass "agents directory exists"
else
    test_fail "agents directory not found"
fi

AGENT_FILES="correctness-reviewer performance-reviewer security-reviewer guidelines-reviewer scope-reviewer architecture-reviewer risk-reviewer"
AGENT_COUNT=0
for agent in $AGENT_FILES; do
    if [ -f "$AGENTS_DIR/$agent.md" ]; then
        ((AGENT_COUNT++))
    fi
done
if [ "$AGENT_COUNT" -eq 7 ]; then
    test_pass "tdd-core has 7 reviewer agents"
else
    test_fail "tdd-core has $AGENT_COUNT/7 reviewer agents"
fi

# TC-02c: quality-gate skill exists (replaces code-review)
if [ -f "$PLUGINS_DIR/tdd-core/skills/quality-gate/SKILL.md" ]; then
    test_pass "quality-gate skill exists"
else
    test_fail "quality-gate skill not found"
fi

# TC-02d: code-review skill should NOT exist (replaced by quality-gate)
if [ ! -d "$PLUGINS_DIR/tdd-core/skills/code-review" ]; then
    test_pass "code-review skill removed (replaced by quality-gate)"
else
    test_fail "code-review skill still exists (should be removed)"
fi

# TC-02e: tdd-onboard has pre-commit hook step (Step 6)
ONBOARD_SKILL="$PLUGINS_DIR/tdd-core/skills/tdd-onboard/SKILL.md"
if grep -q "Step 6.*Pre-commit Hook" "$ONBOARD_SKILL" 2>/dev/null; then
    test_pass "tdd-onboard has Step 6 (Pre-commit Hook)"
else
    test_fail "tdd-onboard missing Step 6 (Pre-commit Hook)"
fi

# TC-02f: tdd-onboard Step 6 has .git check
if grep -q "ls -d .git" "$ONBOARD_SKILL" 2>/dev/null; then
    test_pass "tdd-onboard Step 6 has .git check"
else
    test_fail "tdd-onboard Step 6 missing .git check"
fi

# TC-02g: tdd-onboard Step 6 has hook check
if grep -q ".husky/pre-commit\|.git/hooks/pre-commit" "$ONBOARD_SKILL" 2>/dev/null; then
    test_pass "tdd-onboard Step 6 has hook check"
else
    test_fail "tdd-onboard Step 6 missing hook check"
fi

# TC-02h: tdd-onboard Progress Checklist has hook item
if grep -A20 "Progress Checklist" "$ONBOARD_SKILL" 2>/dev/null | grep -q "Pre-commit Hook"; then
    test_pass "tdd-onboard Checklist has hook item"
else
    test_fail "tdd-onboard Checklist missing hook item"
fi

# TC-02i: tdd-commit has pre-commit hook step (Step 2)
COMMIT_SKILL="$PLUGINS_DIR/tdd-core/skills/tdd-commit/SKILL.md"
if grep -q "Step 2.*Pre-commit Hook\|Step 2.*Hook" "$COMMIT_SKILL" 2>/dev/null; then
    test_pass "tdd-commit has Step 2 (Pre-commit Hook)"
else
    test_fail "tdd-commit missing Step 2 (Pre-commit Hook)"
fi

# TC-02j: tdd-commit Progress Checklist has hook item
if grep -A20 "Progress Checklist" "$COMMIT_SKILL" 2>/dev/null | grep -qi "hook"; then
    test_pass "tdd-commit Checklist has hook item"
else
    test_fail "tdd-commit Checklist missing hook item"
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

# TC-07: tdd-ts plugin.json exists and is valid
echo "--- tdd-ts ---"
TS_PLUGIN="$PLUGINS_DIR/tdd-ts/.claude-plugin/plugin.json"
if [ -f "$TS_PLUGIN" ]; then
    test_pass "plugin.json exists"
    if python3 -c "import json; json.load(open('$TS_PLUGIN'))" 2>/dev/null; then
        test_pass "plugin.json is valid JSON"
    else
        test_fail "plugin.json is invalid JSON"
    fi
else
    test_fail "plugin.json not found"
fi

# TC-07b: tdd-ts has ts-quality skill
if [ -f "$PLUGINS_DIR/tdd-ts/skills/ts-quality/SKILL.md" ]; then
    test_pass "ts-quality skill exists"
else
    test_fail "ts-quality skill not found"
fi
echo ""

# TC-08: tdd-flutter plugin.json exists and is valid
echo "--- tdd-flutter ---"
FLUTTER_PLUGIN="$PLUGINS_DIR/tdd-flutter/.claude-plugin/plugin.json"
if [ -f "$FLUTTER_PLUGIN" ]; then
    test_pass "plugin.json exists"
    if python3 -c "import json; json.load(open('$FLUTTER_PLUGIN'))" 2>/dev/null; then
        test_pass "plugin.json is valid JSON"
    else
        test_fail "plugin.json is invalid JSON"
    fi
else
    test_fail "plugin.json not found"
fi

# TC-08b: tdd-flutter has flutter-quality skill
if [ -f "$PLUGINS_DIR/tdd-flutter/skills/flutter-quality/SKILL.md" ]; then
    test_pass "flutter-quality skill exists"
else
    test_fail "flutter-quality skill not found"
fi
echo ""

# TC-09: marketplace.json exists and is valid
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
