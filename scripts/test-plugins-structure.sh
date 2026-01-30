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

# TC-02e: tdd-onboard has pre-commit hook step (Step 7)
ONBOARD_SKILL="$PLUGINS_DIR/tdd-core/skills/tdd-onboard/SKILL.md"
ONBOARD_REF="$PLUGINS_DIR/tdd-core/skills/tdd-onboard/reference.md"
if grep -q "Step 7.*Pre-commit Hook" "$ONBOARD_SKILL" 2>/dev/null; then
    test_pass "tdd-onboard has Step 7 (Pre-commit Hook)"
else
    test_fail "tdd-onboard missing Step 7 (Pre-commit Hook)"
fi

# TC-02f: tdd-onboard has .git check (SKILL.md or reference.md)
if grep -q "\.git" "$ONBOARD_SKILL" "$ONBOARD_REF" 2>/dev/null; then
    test_pass "tdd-onboard has .git check"
else
    test_fail "tdd-onboard missing .git check"
fi

# TC-02g: tdd-onboard has hook check (SKILL.md or reference.md)
if grep -q ".husky/pre-commit\|.git/hooks/pre-commit" "$ONBOARD_SKILL" "$ONBOARD_REF" 2>/dev/null; then
    test_pass "tdd-onboard has hook check"
else
    test_fail "tdd-onboard missing hook check"
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

# TC-02k: tdd-onboard has hierarchical CLAUDE.md step (Step 5)
if grep -q "Step 5.*階層CLAUDE.md\|Step 5.*CLAUDE.md推奨" "$ONBOARD_SKILL" 2>/dev/null; then
    test_pass "tdd-onboard has Step 5 (階層CLAUDE.md)"
else
    test_fail "tdd-onboard missing Step 5 (階層CLAUDE.md)"
fi

# TC-02l: tdd-onboard Step 5 has directory check (SKILL.md or reference.md)
if grep -q "tests.*src.*docs\|tests/, src/, docs/" "$ONBOARD_SKILL" "$ONBOARD_REF" 2>/dev/null; then
    test_pass "tdd-onboard Step 5 has directory check"
else
    test_fail "tdd-onboard Step 5 missing directory check"
fi

# TC-02m: tdd-onboard Progress Checklist has hierarchical CLAUDE.md item
if grep -A20 "Progress Checklist" "$ONBOARD_SKILL" 2>/dev/null | grep -qi "階層CLAUDE.md\|CLAUDE.md推奨"; then
    test_pass "tdd-onboard Checklist has 階層CLAUDE.md item"
else
    test_fail "tdd-onboard Checklist missing 階層CLAUDE.md item"
fi

# TC-02n: tdd-onboard reference.md has tests/ template
if grep -q "tests/CLAUDE.md\|tests/ CLAUDE.md" "$ONBOARD_REF" 2>/dev/null; then
    test_pass "tdd-onboard reference.md has tests/ template"
else
    test_fail "tdd-onboard reference.md missing tests/ template"
fi

# TC-02o: tdd-onboard reference.md has depth limit (第1階層)
if grep -qi "第1階層\|1階層\|サブディレクトリは非推奨" "$ONBOARD_REF" 2>/dev/null; then
    test_pass "tdd-onboard reference.md has depth limit"
else
    test_fail "tdd-onboard reference.md missing depth limit"
fi

# TC-02p: tdd-onboard reference.md has size limit (30-50行)
if grep -q "30-50行\|30行\|50行" "$ONBOARD_REF" 2>/dev/null; then
    test_pass "tdd-onboard reference.md has size limit"
else
    test_fail "tdd-onboard reference.md missing size limit"
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

# TC-10: tdd-flask plugin.json exists and is valid
echo "--- tdd-flask ---"
FLASK_PLUGIN="$PLUGINS_DIR/tdd-flask/.claude-plugin/plugin.json"
if [ -f "$FLASK_PLUGIN" ]; then
    test_pass "plugin.json exists"
    if python3 -c "import json; json.load(open('$FLASK_PLUGIN'))" 2>/dev/null; then
        test_pass "plugin.json is valid JSON"
    else
        test_fail "plugin.json is invalid JSON"
    fi
else
    test_fail "plugin.json not found"
fi

# TC-10b: tdd-flask has flask-quality skill
if [ -f "$PLUGINS_DIR/tdd-flask/skills/flask-quality/SKILL.md" ]; then
    test_pass "flask-quality skill exists"
else
    test_fail "flask-quality skill not found"
fi

# TC-10c: flask-quality SKILL.md has pytest-flask
FLASK_SKILL="$PLUGINS_DIR/tdd-flask/skills/flask-quality/SKILL.md"
if grep -q "pytest-flask" "$FLASK_SKILL" 2>/dev/null; then
    test_pass "SKILL.md has pytest-flask"
else
    test_fail "SKILL.md missing pytest-flask"
fi

# TC-10d: flask-quality SKILL.md has test_client
if grep -q "test_client" "$FLASK_SKILL" 2>/dev/null; then
    test_pass "SKILL.md has test_client"
else
    test_fail "SKILL.md missing test_client"
fi

# TC-10e: flask-quality reference.md has conftest.py template
FLASK_REF="$PLUGINS_DIR/tdd-flask/skills/flask-quality/reference.md"
if grep -q "conftest.py" "$FLASK_REF" 2>/dev/null; then
    test_pass "reference.md has conftest.py template"
else
    test_fail "reference.md missing conftest.py template"
fi

# TC-10f: flask-quality reference.md has Flask 3.x patterns
if grep -qi "Flask 3\|create_app\|App Factory" "$FLASK_REF" 2>/dev/null; then
    test_pass "reference.md has Flask 3.x patterns"
else
    test_fail "reference.md missing Flask 3.x patterns"
fi

# TC-10g: tdd-flask README.md has Installation section
FLASK_README="$PLUGINS_DIR/tdd-flask/README.md"
if grep -qi "Installation" "$FLASK_README" 2>/dev/null; then
    test_pass "README.md has Installation section"
else
    test_fail "README.md missing Installation section"
fi
echo ""

# TC-11: No plugin.json should contain a "version" field
echo "--- version field check ---"
ALL_PLUGIN_JSONS=$(find "$PLUGINS_DIR" -path "*/.claude-plugin/plugin.json" 2>/dev/null)
VERSION_FOUND=0
for pj in $ALL_PLUGIN_JSONS; do
    if python3 -c "import json,sys; d=json.load(open('$pj')); sys.exit(0 if 'version' in d else 1)" 2>/dev/null; then
        test_fail "$(basename $(dirname $(dirname $pj)))/plugin.json contains version field"
        ((VERSION_FOUND++))
    fi
done
if [ "$VERSION_FOUND" -eq 0 ]; then
    test_pass "No plugin.json contains version field"
fi

# TC-11b: All plugin.json files are valid JSON (comprehensive check)
INVALID_JSON=0
for pj in $ALL_PLUGIN_JSONS; do
    if ! python3 -c "import json; json.load(open('$pj'))" 2>/dev/null; then
        test_fail "$(basename $(dirname $(dirname $pj)))/plugin.json is invalid JSON"
        ((INVALID_JSON++))
    fi
done
if [ "$INVALID_JSON" -eq 0 ]; then
    test_pass "All plugin.json files are valid JSON"
fi
echo ""

echo "=========================================="
echo "Results: $PASS passed, $FAIL failed"
echo "=========================================="

if [ "$FAIL" -gt 0 ]; then
    exit 1
fi
