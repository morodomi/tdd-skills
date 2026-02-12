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

AGENT_FILES="correctness-reviewer performance-reviewer security-reviewer guidelines-reviewer scope-reviewer architecture-reviewer risk-reviewer product-reviewer usability-reviewer"
AGENT_COUNT=0
for agent in $AGENT_FILES; do
    if [ -f "$AGENTS_DIR/$agent.md" ]; then
        ((AGENT_COUNT++))
    fi
done
if [ "$AGENT_COUNT" -eq 9 ]; then
    test_pass "tdd-core has 9 reviewer agents"
else
    test_fail "tdd-core has $AGENT_COUNT/9 reviewer agents"
fi

# TC-02b2: product-reviewer agent exists
if [ -f "$AGENTS_DIR/product-reviewer.md" ]; then
    test_pass "product-reviewer agent exists"
else
    test_fail "product-reviewer agent not found"
fi

# TC-02b3: plan-review includes product-reviewer
PLAN_REVIEW_SKILL="$PLUGINS_DIR/tdd-core/skills/plan-review/SKILL.md"
PLAN_REVIEW_DIR="$PLUGINS_DIR/tdd-core/skills/plan-review"
if grep -rq "product-reviewer" "$PLAN_REVIEW_DIR" 2>/dev/null; then
    test_pass "plan-review includes product-reviewer"
else
    test_fail "plan-review missing product-reviewer"
fi

# TC-02b4: quality-gate includes product-reviewer
QG_SKILL="$PLUGINS_DIR/tdd-core/skills/quality-gate/SKILL.md"
QG_DIR="$PLUGINS_DIR/tdd-core/skills/quality-gate"
if grep -rq "product-reviewer" "$QG_DIR" 2>/dev/null; then
    test_pass "quality-gate includes product-reviewer"
else
    test_fail "quality-gate missing product-reviewer"
fi

# TC-02b6: usability-reviewer agent exists
if [ -f "$AGENTS_DIR/usability-reviewer.md" ]; then
    test_pass "usability-reviewer agent exists"
else
    test_fail "usability-reviewer agent not found"
fi

# TC-02b7: plan-review includes usability-reviewer
if grep -rq "usability-reviewer" "$PLAN_REVIEW_DIR" 2>/dev/null; then
    test_pass "plan-review includes usability-reviewer"
else
    test_fail "plan-review missing usability-reviewer"
fi

# TC-02b8: quality-gate includes usability-reviewer
if grep -rq "usability-reviewer" "$QG_DIR" 2>/dev/null; then
    test_pass "quality-gate includes usability-reviewer"
else
    test_fail "quality-gate missing usability-reviewer"
fi

# TC-02b5: risk-reviewer does not contain business impact wording
if ! grep -qi "ビジネス\|business" "$AGENTS_DIR/risk-reviewer.md" 2>/dev/null; then
    test_pass "risk-reviewer focused on technical risk (no business wording)"
else
    test_fail "risk-reviewer still contains business impact wording"
fi

# TC-02c: quality-gate skill exists (replaces code-review)
if [ -f "$PLUGINS_DIR/tdd-core/skills/quality-gate/SKILL.md" ]; then
    test_pass "quality-gate skill exists"
else
    test_fail "quality-gate skill not found"
fi

# TC-AT-01: quality-gate SKILL.md uses Subagent mode with Sonnet
if grep -qi "subagent" "$QG_SKILL" 2>/dev/null && grep -qi "sonnet" "$QG_SKILL" 2>/dev/null; then
    test_pass "quality-gate uses Subagent mode with Sonnet"
else
    test_fail "quality-gate missing Subagent/Sonnet configuration"
fi

# TC-AT-02: quality-gate SKILL.md is 100 lines or less
QG_LINES=$(wc -l < "$QG_SKILL" 2>/dev/null | tr -d ' ')
if [ -n "$QG_LINES" ] && [ "$QG_LINES" -le 100 ]; then
    test_pass "quality-gate SKILL.md is ${QG_LINES} lines (<= 100)"
else
    test_fail "quality-gate SKILL.md is ${QG_LINES} lines (> 100)"
fi

# TC-AT-03: steps-subagent.md exists and has 6-agent parallel procedure
QG_SUBAGENT="$PLUGINS_DIR/tdd-core/skills/quality-gate/steps-subagent.md"
if [ -f "$QG_SUBAGENT" ] && grep -q "correctness-reviewer" "$QG_SUBAGENT" && grep -q "security-reviewer" "$QG_SUBAGENT"; then
    test_pass "steps-subagent.md exists with 6-agent procedure"
else
    test_fail "steps-subagent.md missing or incomplete"
fi

# TC-AT-04: steps-teams.md removed from quality-gate (Subagent only)
QG_TEAMS="$PLUGINS_DIR/tdd-core/skills/quality-gate/steps-teams.md"
if [ ! -f "$QG_TEAMS" ]; then
    test_pass "quality-gate steps-teams.md removed (Subagent only)"
else
    test_fail "quality-gate steps-teams.md still exists"
fi

# TC-AT-05: reference.md has shared info (scope, scoring, output format)
QG_REF="$PLUGINS_DIR/tdd-core/skills/quality-gate/reference.md"
if grep -q "対象範囲" "$QG_REF" 2>/dev/null && grep -q "信頼スコア" "$QG_REF" 2>/dev/null && grep -q "出力形式" "$QG_REF" 2>/dev/null; then
    test_pass "reference.md has shared info (scope, scoring, output)"
else
    test_fail "reference.md missing shared info"
fi

# TC-02c2: tdd-review SKILL.md marks quality-gate as mandatory
REVIEW_SKILL="$PLUGINS_DIR/tdd-core/skills/tdd-review/SKILL.md"
if grep -q "必須" "$REVIEW_SKILL" 2>/dev/null; then
    test_pass "tdd-review marks quality-gate as mandatory (必須)"
else
    test_fail "tdd-review missing mandatory (必須) for quality-gate"
fi

# TC-02c3: tdd-review SKILL.md marks quality-gate as skip not allowed
if grep -q "スキップ不可" "$REVIEW_SKILL" 2>/dev/null; then
    test_pass "tdd-review marks quality-gate as skip not allowed"
else
    test_fail "tdd-review missing skip not allowed (スキップ不可) for quality-gate"
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

# TC-02k2: tdd-commit Cycle doc update step comes before git commit step
CYCLE_STEP=$(grep -n "^### Step.*Cycle doc" "$COMMIT_SKILL" 2>/dev/null | head -1 | cut -d: -f1)
COMMIT_STEP=$(grep -n "^### Step.*コミット実行\|^### Step.*git add" "$COMMIT_SKILL" 2>/dev/null | head -1 | cut -d: -f1)
if [ -n "$CYCLE_STEP" ] && [ -n "$COMMIT_STEP" ] && [ "$CYCLE_STEP" -lt "$COMMIT_STEP" ]; then
    test_pass "tdd-commit: Cycle doc update before git commit"
else
    test_fail "tdd-commit: Cycle doc update must come before git commit"
fi

# TC-02k3: tdd-commit STATUS.md update step comes before git commit step
STATUS_STEP=$(grep -n "^### Step.*STATUS.md" "$COMMIT_SKILL" 2>/dev/null | head -1 | cut -d: -f1)
if [ -n "$STATUS_STEP" ] && [ -n "$COMMIT_STEP" ] && [ "$STATUS_STEP" -lt "$COMMIT_STEP" ]; then
    test_pass "tdd-commit: STATUS.md update before git commit"
else
    test_fail "tdd-commit: STATUS.md update must come before git commit"
fi

# TC-02k4: tdd-commit Progress Checklist has doc updates before git add
if grep -A20 "Progress Checklist" "$COMMIT_SKILL" 2>/dev/null | grep -B5 "git add" | grep -q "Cycle doc\|STATUS.md"; then
    test_pass "tdd-commit Checklist: doc updates before git add"
else
    test_fail "tdd-commit Checklist: doc updates must come before git add"
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

# --- tdd-diagnose ---
echo "--- tdd-diagnose ---"
DIAG_DIR="$PLUGINS_DIR/tdd-core/skills/tdd-diagnose"
DIAG_SKILL="$DIAG_DIR/SKILL.md"

# TC-DG-01: tdd-diagnose SKILL.md exists and is 100 lines or less
if [ -f "$DIAG_SKILL" ]; then
    DIAG_LINES=$(wc -l < "$DIAG_SKILL" | tr -d ' ')
    if [ "$DIAG_LINES" -le 100 ]; then
        test_pass "tdd-diagnose SKILL.md exists and is ${DIAG_LINES} lines (<= 100)"
    else
        test_fail "tdd-diagnose SKILL.md is ${DIAG_LINES} lines (> 100)"
    fi
else
    test_fail "tdd-diagnose SKILL.md not found"
fi

# TC-DG-02: tdd-diagnose SKILL.md has Agent Teams env var branching
if grep -q "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS" "$DIAG_SKILL" 2>/dev/null; then
    test_pass "tdd-diagnose has Agent Teams env var branching"
else
    test_fail "tdd-diagnose missing Agent Teams env var branching"
fi

# TC-DG-03: tdd-diagnose SKILL.md has Progress Checklist
if grep -q "Progress Checklist" "$DIAG_SKILL" 2>/dev/null; then
    test_pass "tdd-diagnose has Progress Checklist"
else
    test_fail "tdd-diagnose missing Progress Checklist"
fi

# TC-DG-04: steps-subagent.md exists with Explore agent procedure
DIAG_SUBAGENT="$DIAG_DIR/steps-subagent.md"
if [ -f "$DIAG_SUBAGENT" ] && grep -qi "Explore" "$DIAG_SUBAGENT"; then
    test_pass "tdd-diagnose steps-subagent.md exists with Explore agent"
else
    test_fail "tdd-diagnose steps-subagent.md missing or no Explore agent"
fi

# TC-DG-05: steps-teams.md exists with Team debate procedure
DIAG_TEAMS="$DIAG_DIR/steps-teams.md"
if [ -f "$DIAG_TEAMS" ] && grep -q "Teammate\|Team" "$DIAG_TEAMS" && grep -qi "Debate\|debate\|討論" "$DIAG_TEAMS"; then
    test_pass "tdd-diagnose steps-teams.md exists with Team debate"
else
    test_fail "tdd-diagnose steps-teams.md missing or incomplete"
fi

# TC-DG-06: steps-teams.md has Fallback section
if grep -qi "Fallback\|fallback\|フォールバック" "$DIAG_TEAMS" 2>/dev/null; then
    test_pass "tdd-diagnose steps-teams.md has Fallback"
else
    test_fail "tdd-diagnose steps-teams.md missing Fallback"
fi

# TC-DG-07: reference.md exists with hypothesis template
DIAG_REF="$DIAG_DIR/reference.md"
if [ -f "$DIAG_REF" ] && grep -qi "hypothesis\|仮説" "$DIAG_REF"; then
    test_pass "tdd-diagnose reference.md exists with hypothesis info"
else
    test_fail "tdd-diagnose reference.md missing or no hypothesis info"
fi

# TC-DG-08: tdd-init SKILL.md has tdd-diagnose auto-transition
INIT_SKILL="$PLUGINS_DIR/tdd-core/skills/tdd-init/SKILL.md"
if grep -q "tdd-diagnose" "$INIT_SKILL" 2>/dev/null; then
    test_pass "tdd-init has tdd-diagnose auto-transition"
else
    test_fail "tdd-init missing tdd-diagnose auto-transition"
fi

# TC-DG-09: tdd-init SKILL.md is 100 lines or less
INIT_LINES=$(wc -l < "$INIT_SKILL" 2>/dev/null | tr -d ' ')
if [ -n "$INIT_LINES" ] && [ "$INIT_LINES" -le 100 ]; then
    test_pass "tdd-init SKILL.md is ${INIT_LINES} lines (<= 100)"
else
    test_fail "tdd-init SKILL.md is ${INIT_LINES} lines (> 100)"
fi

# TC-DG-11: reference.md has hypothesis template fields
if grep -q "hypothesis" "$DIAG_REF" 2>/dev/null && grep -q "evidence_for" "$DIAG_REF" 2>/dev/null && grep -q "evidence_against" "$DIAG_REF" 2>/dev/null && grep -q "verdict" "$DIAG_REF" 2>/dev/null; then
    test_pass "tdd-diagnose reference.md has hypothesis template fields"
else
    test_fail "tdd-diagnose reference.md missing hypothesis template fields"
fi

# TC-DG-12: SKILL.md Step 4 has investigation result branching
if grep -qi "特定\|identified\|confirmed" "$DIAG_SKILL" 2>/dev/null && grep -qi "絞込\|narrowed\|候補" "$DIAG_SKILL" 2>/dev/null && grep -qi "不明\|inconclusive\|エスカレート" "$DIAG_SKILL" 2>/dev/null; then
    test_pass "tdd-diagnose SKILL.md has result branching"
else
    test_fail "tdd-diagnose SKILL.md missing result branching"
fi

# TC-DG-13: CLAUDE.md Skills table has tdd-diagnose
if grep -q "tdd-diagnose" "CLAUDE.md" 2>/dev/null; then
    test_pass "CLAUDE.md Skills table has tdd-diagnose"
else
    test_fail "CLAUDE.md Skills table missing tdd-diagnose"
fi
echo ""

# --- tdd-parallel ---
echo "--- tdd-parallel ---"
PAR_DIR="$PLUGINS_DIR/tdd-core/skills/tdd-parallel"
PAR_SKILL="$PAR_DIR/SKILL.md"

# TC-PL-01: tdd-parallel SKILL.md exists and is 100 lines or less
if [ -f "$PAR_SKILL" ]; then
    PAR_LINES=$(wc -l < "$PAR_SKILL" | tr -d ' ')
    if [ "$PAR_LINES" -le 100 ]; then
        test_pass "tdd-parallel SKILL.md exists and is ${PAR_LINES} lines (<= 100)"
    else
        test_fail "tdd-parallel SKILL.md is ${PAR_LINES} lines (> 100)"
    fi
else
    test_fail "tdd-parallel SKILL.md not found"
fi

# TC-PL-02: SKILL.md has Agent Teams env var check + fallback for disabled
if grep -q "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS" "$PAR_SKILL" 2>/dev/null && grep -qi "tdd-red\|通常.*TDD\|sequential\|逐次" "$PAR_SKILL" 2>/dev/null; then
    test_pass "tdd-parallel has env var check + fallback"
else
    test_fail "tdd-parallel missing env var check or fallback"
fi

# TC-PL-03: SKILL.md has Progress Checklist
if grep -q "Progress Checklist" "$PAR_SKILL" 2>/dev/null; then
    test_pass "tdd-parallel has Progress Checklist"
else
    test_fail "tdd-parallel missing Progress Checklist"
fi

# TC-PL-04: SKILL.md has Architecture Note (composite pattern)
if grep -qi "Architecture Note\|合成パターン\|composite\|複数フェーズ" "$PAR_SKILL" 2>/dev/null; then
    test_pass "tdd-parallel has Architecture Note"
else
    test_fail "tdd-parallel missing Architecture Note"
fi

# TC-PL-05: SKILL.md has When to Use section
if grep -qi "When to Use\|使用推奨\|使用非推奨" "$PAR_SKILL" 2>/dev/null; then
    test_pass "tdd-parallel has When to Use section"
else
    test_fail "tdd-parallel missing When to Use section"
fi

# TC-PL-06: SKILL.md has integration test step
if grep -qi "統合テスト\|Integration Test\|全テスト.*一括" "$PAR_SKILL" 2>/dev/null; then
    test_pass "tdd-parallel has integration test step"
else
    test_fail "tdd-parallel missing integration test step"
fi

# TC-PL-07: steps-teams.md exists with Team creation, Teammate, file conflict check, integration test
PAR_TEAMS="$PAR_DIR/steps-teams.md"
if [ -f "$PAR_TEAMS" ] && grep -q "Teammate" "$PAR_TEAMS" && grep -qi "競合\|conflict" "$PAR_TEAMS" && grep -qi "統合\|Integration" "$PAR_TEAMS"; then
    test_pass "tdd-parallel steps-teams.md exists with required sections"
else
    test_fail "tdd-parallel steps-teams.md missing or incomplete"
fi

# TC-PL-08: steps-teams.md has Fallback with specific error message + next action
if grep -qi "Fallback\|fallback\|フォールバック" "$PAR_TEAMS" 2>/dev/null && grep -qi "Skill(tdd-core:tdd-red)\|tdd-red.*個別\|next action\|次のアクション" "$PAR_TEAMS" 2>/dev/null; then
    test_pass "tdd-parallel steps-teams.md has Fallback with next action"
else
    test_fail "tdd-parallel steps-teams.md missing Fallback or next action"
fi

# TC-PL-09: reference.md exists with layer guide, Why Agent Teams Only, recommended layer count (2-4)
PAR_REF="$PAR_DIR/reference.md"
if [ -f "$PAR_REF" ] && grep -qi "レイヤー\|layer" "$PAR_REF" && grep -qi "Why Agent Teams Only\|Agent Teams.*必須\|なぜ.*Agent Teams" "$PAR_REF" && grep -q "2-4\|2〜4" "$PAR_REF"; then
    test_pass "tdd-parallel reference.md has layer guide, Why Agent Teams Only, 2-4 layers"
else
    test_fail "tdd-parallel reference.md missing or incomplete"
fi

# TC-PL-10: tdd-plan/SKILL.md has tdd-parallel auto-proposal with env var check
PLAN_SKILL="$PLUGINS_DIR/tdd-core/skills/tdd-plan/SKILL.md"
if grep -q "tdd-parallel" "$PLAN_SKILL" 2>/dev/null && grep -q "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS" "$PLAN_SKILL" 2>/dev/null; then
    test_pass "tdd-plan has tdd-parallel proposal with env var check"
else
    test_fail "tdd-plan missing tdd-parallel proposal or env var check"
fi

# TC-PL-11: tdd-plan/SKILL.md is 100 lines or less
PLAN_LINES=$(wc -l < "$PLAN_SKILL" 2>/dev/null | tr -d ' ')
if [ -n "$PLAN_LINES" ] && [ "$PLAN_LINES" -le 100 ]; then
    test_pass "tdd-plan SKILL.md is ${PLAN_LINES} lines (<= 100)"
else
    test_fail "tdd-plan SKILL.md is ${PLAN_LINES} lines (> 100)"
fi

# TC-PL-12: CLAUDE.md Skills table has tdd-parallel
if grep -q "tdd-parallel" "CLAUDE.md" 2>/dev/null; then
    test_pass "CLAUDE.md Skills table has tdd-parallel"
else
    test_fail "CLAUDE.md Skills table missing tdd-parallel"
fi
echo ""

# ==========================================
# plan-review Agent Teams Tests
# ==========================================
echo "--- plan-review Agent Teams ---"

PR_DIR="$PLUGINS_DIR/tdd-core/skills/plan-review"
PR_SKILL="$PR_DIR/SKILL.md"

# TC-PR-01: plan-review SKILL.md uses Subagent mode with Sonnet
if grep -qi "subagent" "$PR_SKILL" 2>/dev/null && grep -qi "sonnet" "$PR_SKILL" 2>/dev/null; then
    test_pass "plan-review uses Subagent mode with Sonnet"
else
    test_fail "plan-review missing Subagent/Sonnet configuration"
fi

# TC-PR-02: plan-review SKILL.md references steps-subagent.md
if grep -q "steps-subagent.md" "$PR_SKILL" 2>/dev/null; then
    test_pass "plan-review references steps-subagent.md"
else
    test_fail "plan-review missing steps-subagent.md reference"
fi

# TC-PR-03: plan-review SKILL.md is 100 lines or less
PR_LINES=$(wc -l < "$PR_SKILL" 2>/dev/null | tr -d ' ')
if [ -n "$PR_LINES" ] && [ "$PR_LINES" -le 100 ]; then
    test_pass "plan-review SKILL.md is ${PR_LINES} lines (<= 100)"
else
    test_fail "plan-review SKILL.md is ${PR_LINES:-0} lines (> 100)"
fi

# TC-PR-04: plan-review SKILL.md has Progress Checklist
if grep -q "Progress Checklist" "$PR_SKILL" 2>/dev/null; then
    test_pass "plan-review SKILL.md has Progress Checklist"
else
    test_fail "plan-review SKILL.md missing Progress Checklist"
fi

# TC-PR-05: plan-review steps-teams.md removed (Subagent only)
PR_TEAMS="$PR_DIR/steps-teams.md"
if [ ! -f "$PR_TEAMS" ]; then
    test_pass "plan-review steps-teams.md removed (Subagent only)"
else
    test_fail "plan-review steps-teams.md still exists"
fi

# TC-PR-06: steps-subagent.md has 5 reviewers
PR_SUB_REVIEWERS=0
for reviewer in scope-reviewer architecture-reviewer risk-reviewer product-reviewer usability-reviewer; do
    if grep -q "$reviewer" "$PR_DIR/steps-subagent.md" 2>/dev/null; then
        ((PR_SUB_REVIEWERS++))
    fi
done
if [ "$PR_SUB_REVIEWERS" -eq 5 ]; then
    test_pass "plan-review steps-subagent.md has 5 reviewers"
else
    test_fail "plan-review steps-subagent.md has ${PR_SUB_REVIEWERS}/5 reviewers"
fi

# TC-PR-09: steps-subagent.md exists with 5-agent parallel procedure
PR_SUBAGENT="$PR_DIR/steps-subagent.md"
if [ -f "$PR_SUBAGENT" ] && grep -q "scope-reviewer" "$PR_SUBAGENT" && grep -q "architecture-reviewer" "$PR_SUBAGENT" && grep -qi "並行\|parallel" "$PR_SUBAGENT"; then
    test_pass "plan-review steps-subagent.md has 5-agent parallel procedure"
else
    test_fail "plan-review steps-subagent.md missing or incomplete"
fi

# TC-PR-10: steps-subagent.md has 5 reviewers (scope/architecture/risk/product/usability)
PR_SUB_REVIEWERS=0
for reviewer in scope-reviewer architecture-reviewer risk-reviewer product-reviewer usability-reviewer; do
    if grep -q "$reviewer" "$PR_SUBAGENT" 2>/dev/null; then
        ((PR_SUB_REVIEWERS++))
    fi
done
if [ "$PR_SUB_REVIEWERS" -eq 5 ]; then
    test_pass "plan-review steps-subagent.md has 5 reviewers"
else
    test_fail "plan-review steps-subagent.md has ${PR_SUB_REVIEWERS}/5 reviewers"
fi

# TC-PR-11: steps-subagent.md has JSON output format
if grep -q "JSON\|json" "$PR_SUBAGENT" 2>/dev/null && grep -q "confidence" "$PR_SUBAGENT" 2>/dev/null; then
    test_pass "plan-review steps-subagent.md has JSON output format"
else
    test_fail "plan-review steps-subagent.md missing JSON output format"
fi

# TC-PR-12: plan-review SKILL.md Progress Checklist has Subagent + Sonnet expression
if grep -qi "Subagent.*Sonnet\|レビュー実行（Subagent" "$PR_SKILL" 2>/dev/null; then
    test_pass "plan-review Progress Checklist has Subagent + Sonnet expression"
else
    test_fail "plan-review Progress Checklist missing Subagent + Sonnet expression"
fi

echo ""

# ==========================================
# onboard AI Behavior Principles Tests
# ==========================================
echo "--- onboard AI Behavior Principles ---"

ONBOARD_REF="$PLUGINS_DIR/tdd-core/skills/tdd-onboard/reference.md"

# TC-OB-01: reference.md CLAUDE.md template has AI Behavior Principles header
if grep -q "## AI Behavior Principles" "$ONBOARD_REF" 2>/dev/null; then
    test_pass "onboard template has AI Behavior Principles header"
else
    test_fail "onboard template missing AI Behavior Principles header"
fi

# TC-OB-02: template has Role: PdM section
if grep -q "### Role: PdM" "$ONBOARD_REF" 2>/dev/null; then
    test_pass "onboard template has Role: PdM section"
else
    test_fail "onboard template missing Role: PdM section"
fi

# TC-OB-03: template has Mandatory: AskUserQuestion section
if grep -q "### Mandatory: AskUserQuestion" "$ONBOARD_REF" 2>/dev/null; then
    test_pass "onboard template has Mandatory: AskUserQuestion section"
else
    test_fail "onboard template missing Mandatory: AskUserQuestion section"
fi

# TC-OB-04: template has Delegation Strategy with Agent Teams env var
if grep -q "### Delegation Strategy" "$ONBOARD_REF" 2>/dev/null && grep -q "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS" "$ONBOARD_REF" 2>/dev/null; then
    test_pass "onboard template has Delegation Strategy with env var"
else
    test_fail "onboard template missing Delegation Strategy or env var"
fi

# TC-OB-05: template has Delegation Rules with 5 items
if grep -q "### Delegation Rules" "$ONBOARD_REF" 2>/dev/null; then
    OB_RULES_COUNT=$(grep -c "green-worker\|red-worker\|architect\|reviewer.*委譲\|AskUserQuestion.*確認" "$ONBOARD_REF" 2>/dev/null)
    if [ "$OB_RULES_COUNT" -ge 5 ]; then
        test_pass "onboard template has Delegation Rules with ${OB_RULES_COUNT} items"
    else
        test_fail "onboard template has Delegation Rules but only ${OB_RULES_COUNT}/5 items"
    fi
else
    test_fail "onboard template missing Delegation Rules section"
fi

# ===========================================
# tdd-orchestrate skill structure tests
# ===========================================
echo "--- tdd-orchestrate ---"
ORCH_DIR="$PLUGINS_DIR/tdd-core/skills/tdd-orchestrate"
ORCH_SKILL="$ORCH_DIR/SKILL.md"
ORCH_REF="$ORCH_DIR/reference.md"
ORCH_TEAMS="$ORCH_DIR/steps-teams.md"
ORCH_SUB="$ORCH_DIR/steps-subagent.md"

# TC-OR-01: SKILL.md exists and is <= 100 lines
if [ -f "$ORCH_SKILL" ]; then
    ORCH_LINES=$(wc -l < "$ORCH_SKILL" | tr -d ' ')
    if [ "$ORCH_LINES" -le 100 ]; then
        test_pass "tdd-orchestrate SKILL.md exists and is ${ORCH_LINES} lines (<= 100)"
    else
        test_fail "tdd-orchestrate SKILL.md is ${ORCH_LINES} lines (> 100)"
    fi
else
    test_fail "tdd-orchestrate SKILL.md not found"
fi

# TC-OR-02: SKILL.md contains Block 1, Block 2, Block 3
if grep -q "Block 1" "$ORCH_SKILL" 2>/dev/null && grep -q "Block 2" "$ORCH_SKILL" 2>/dev/null && grep -q "Block 3" "$ORCH_SKILL" 2>/dev/null; then
    test_pass "tdd-orchestrate SKILL.md has Block 1/2/3"
else
    test_fail "tdd-orchestrate SKILL.md missing Block 1/2/3"
fi

# TC-OR-03: SKILL.md contains env var branching
if grep -q "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS" "$ORCH_SKILL" 2>/dev/null; then
    test_pass "tdd-orchestrate SKILL.md has env var branching"
else
    test_fail "tdd-orchestrate SKILL.md missing env var branching"
fi

# TC-OR-04: SKILL.md has Progress Checklist with 7+ phases
if grep -q "Progress Checklist" "$ORCH_SKILL" 2>/dev/null; then
    ORCH_PHASES=$(grep -c "INIT\|PLAN\|plan-review\|RED\|GREEN\|REFACTOR\|REVIEW\|COMMIT" "$ORCH_SKILL" 2>/dev/null)
    if [ "$ORCH_PHASES" -ge 7 ]; then
        test_pass "tdd-orchestrate SKILL.md has Progress Checklist with ${ORCH_PHASES} phase refs"
    else
        test_fail "tdd-orchestrate SKILL.md Progress Checklist has only ${ORCH_PHASES}/7 phase refs"
    fi
else
    test_fail "tdd-orchestrate SKILL.md missing Progress Checklist"
fi

# TC-OR-05: SKILL.md references steps-teams.md and steps-subagent.md
if grep -q "steps-teams.md" "$ORCH_SKILL" 2>/dev/null && grep -q "steps-subagent.md" "$ORCH_SKILL" 2>/dev/null; then
    test_pass "tdd-orchestrate SKILL.md references both steps files"
else
    test_fail "tdd-orchestrate SKILL.md missing steps file references"
fi

# TC-OR-06: reference.md has PdM judgment criteria table (PASS/WARN/BLOCK + auto-proceed)
if [ -f "$ORCH_REF" ]; then
    if grep -q "PASS" "$ORCH_REF" 2>/dev/null && grep -q "WARN" "$ORCH_REF" 2>/dev/null && grep -q "BLOCK" "$ORCH_REF" 2>/dev/null && grep -qE "自律判断|自動進行" "$ORCH_REF" 2>/dev/null; then
        test_pass "tdd-orchestrate reference.md has PdM judgment criteria"
    else
        test_fail "tdd-orchestrate reference.md missing PdM judgment criteria"
    fi
else
    test_fail "tdd-orchestrate reference.md not found"
fi

# TC-OR-07: reference.md has retry logic with max count and escalation
if grep -qE "再試行|retry" "$ORCH_REF" 2>/dev/null && grep -qE "ユーザーに報告|エスカレーション" "$ORCH_REF" 2>/dev/null && grep -qE "max|上限|[0-9]+回" "$ORCH_REF" 2>/dev/null; then
    test_pass "tdd-orchestrate reference.md has retry logic with limits"
else
    test_fail "tdd-orchestrate reference.md missing retry logic or limits"
fi

# TC-OR-08: reference.md has Phase Ownership table with all phases
if grep -q "INIT" "$ORCH_REF" 2>/dev/null && grep -q "PLAN" "$ORCH_REF" 2>/dev/null && grep -q "RED" "$ORCH_REF" 2>/dev/null && grep -q "GREEN" "$ORCH_REF" 2>/dev/null && grep -q "REFACTOR" "$ORCH_REF" 2>/dev/null && grep -q "REVIEW" "$ORCH_REF" 2>/dev/null && grep -q "COMMIT" "$ORCH_REF" 2>/dev/null; then
    test_pass "tdd-orchestrate reference.md has all 7 phases"
else
    test_fail "tdd-orchestrate reference.md missing some phases"
fi

# TC-OR-09: steps-teams.md has spawnTeam, spawn, shutdown, cleanup
if [ -f "$ORCH_TEAMS" ]; then
    if grep -q "spawnTeam" "$ORCH_TEAMS" 2>/dev/null && grep -qE "spawn|起動" "$ORCH_TEAMS" 2>/dev/null && grep -q "shutdown" "$ORCH_TEAMS" 2>/dev/null && grep -q "cleanup" "$ORCH_TEAMS" 2>/dev/null; then
        test_pass "tdd-orchestrate steps-teams.md has team lifecycle keywords"
    else
        test_fail "tdd-orchestrate steps-teams.md missing team lifecycle keywords"
    fi
else
    test_fail "tdd-orchestrate steps-teams.md not found"
fi

# TC-OR-10: steps-teams.md has fallback to steps-subagent.md
if grep -q "steps-subagent.md" "$ORCH_TEAMS" 2>/dev/null; then
    test_pass "tdd-orchestrate steps-teams.md has fallback reference"
else
    test_fail "tdd-orchestrate steps-teams.md missing fallback reference"
fi

# TC-OR-11: steps-subagent.md has Skill calls for 6 skills
if [ -f "$ORCH_SUB" ]; then
    ORCH_SKILL_COUNT=0
    for sk in tdd-plan tdd-red tdd-green tdd-refactor tdd-review tdd-commit; do
        if grep -q "$sk" "$ORCH_SUB" 2>/dev/null; then
            ORCH_SKILL_COUNT=$((ORCH_SKILL_COUNT + 1))
        fi
    done
    if [ "$ORCH_SKILL_COUNT" -ge 6 ] && grep -q "Skill" "$ORCH_SUB" 2>/dev/null; then
        test_pass "tdd-orchestrate steps-subagent.md has Skill calls for ${ORCH_SKILL_COUNT}/6 skills"
    else
        test_fail "tdd-orchestrate steps-subagent.md has only ${ORCH_SKILL_COUNT}/6 skill refs"
    fi
else
    test_fail "tdd-orchestrate steps-subagent.md not found"
fi

# TC-OR-12: SKILL.md links to reference.md
if grep -q "reference.md" "$ORCH_SKILL" 2>/dev/null; then
    test_pass "tdd-orchestrate SKILL.md links to reference.md"
else
    test_fail "tdd-orchestrate SKILL.md missing reference.md link"
fi

echo ""

# ==========================================
# Architect / Refactorer Agent + tdd-init Integration Tests
# ==========================================

echo "--- Architect/Refactorer Agent + tdd-init Integration ---"

ARCH_AGENT="$AGENTS_DIR/architect.md"
REFAC_AGENT="$AGENTS_DIR/refactorer.md"
INIT_SKILL="$PLUGINS_DIR/tdd-core/skills/tdd-init/SKILL.md"
CLAUDE_MD="CLAUDE.md"

# TC-AG-01: architect.md exists with YAML frontmatter name: architect
if [ -f "$ARCH_AGENT" ] && grep -q "name: architect" "$ARCH_AGENT" 2>/dev/null; then
    test_pass "architect.md exists with name: architect in frontmatter"
else
    test_fail "architect.md missing or missing name: architect in frontmatter"
fi

# TC-AG-02: architect.md references Skill(tdd-plan) or tdd-core:tdd-plan
if grep -q "tdd-plan" "$ARCH_AGENT" 2>/dev/null; then
    test_pass "architect.md references tdd-plan"
else
    test_fail "architect.md missing tdd-plan reference"
fi

# TC-AG-03: architect.md has Input/Output/Workflow/Principles sections
if [ -f "$ARCH_AGENT" ]; then
    ARCH_SECTIONS=0
    for section in Input Output Workflow Principles; do
        if grep -q "## $section" "$ARCH_AGENT" 2>/dev/null; then
            ARCH_SECTIONS=$((ARCH_SECTIONS + 1))
        fi
    done
    if [ "$ARCH_SECTIONS" -eq 4 ]; then
        test_pass "architect.md has all 4 sections (Input/Output/Workflow/Principles)"
    else
        test_fail "architect.md has ${ARCH_SECTIONS}/4 sections"
    fi
else
    test_fail "architect.md not found"
fi

# TC-AG-04: refactorer.md exists with YAML frontmatter name: refactorer
if [ -f "$REFAC_AGENT" ] && grep -q "name: refactorer" "$REFAC_AGENT" 2>/dev/null; then
    test_pass "refactorer.md exists with name: refactorer in frontmatter"
else
    test_fail "refactorer.md missing or missing name: refactorer in frontmatter"
fi

# TC-AG-05: refactorer.md references Skill(tdd-refactor) or tdd-core:tdd-refactor
if grep -q "tdd-refactor" "$REFAC_AGENT" 2>/dev/null; then
    test_pass "refactorer.md references tdd-refactor"
else
    test_fail "refactorer.md missing tdd-refactor reference"
fi

# TC-AG-06: refactorer.md has Input/Output/Workflow/Principles sections
if [ -f "$REFAC_AGENT" ]; then
    REFAC_SECTIONS=0
    for section in Input Output Workflow Principles; do
        if grep -q "## $section" "$REFAC_AGENT" 2>/dev/null; then
            REFAC_SECTIONS=$((REFAC_SECTIONS + 1))
        fi
    done
    if [ "$REFAC_SECTIONS" -eq 4 ]; then
        test_pass "refactorer.md has all 4 sections (Input/Output/Workflow/Principles)"
    else
        test_fail "refactorer.md has ${REFAC_SECTIONS}/4 sections"
    fi
else
    test_fail "refactorer.md not found"
fi

# TC-AG-07: tdd-init SKILL.md has CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS env var branch
if grep -q "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS" "$INIT_SKILL" 2>/dev/null; then
    test_pass "tdd-init SKILL.md has CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS branch"
else
    test_fail "tdd-init SKILL.md missing CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS branch"
fi

# TC-AG-08: tdd-init SKILL.md references tdd-orchestrate
if grep -q "tdd-orchestrate" "$INIT_SKILL" 2>/dev/null; then
    test_pass "tdd-init SKILL.md references tdd-orchestrate"
else
    test_fail "tdd-init SKILL.md missing tdd-orchestrate reference"
fi

# TC-AG-09: tdd-init SKILL.md references tdd-plan (backward compat)
if grep -q "tdd-plan" "$INIT_SKILL" 2>/dev/null; then
    test_pass "tdd-init SKILL.md references tdd-plan (backward compat)"
else
    test_fail "tdd-init SKILL.md missing tdd-plan reference (backward compat broken)"
fi

# TC-AG-10: tdd-init SKILL.md is 100 lines or less
if [ -f "$INIT_SKILL" ]; then
    INIT_LINES=$(wc -l < "$INIT_SKILL" | tr -d ' ')
    if [ "$INIT_LINES" -le 100 ]; then
        test_pass "tdd-init SKILL.md is ${INIT_LINES} lines (<= 100)"
    else
        test_fail "tdd-init SKILL.md is ${INIT_LINES} lines (> 100)"
    fi
else
    test_fail "tdd-init SKILL.md not found"
fi

# TC-AG-11: CLAUDE.md Skills table includes tdd-orchestrate
if grep -q "tdd-orchestrate" "$CLAUDE_MD" 2>/dev/null; then
    test_pass "CLAUDE.md Skills table includes tdd-orchestrate"
else
    test_fail "CLAUDE.md Skills table missing tdd-orchestrate"
fi

echo ""

# ==========================================
# v5.0 Release Documentation Tests
# ==========================================

echo "--- v5.0 Release Documentation ---"

README="README.md"
STATUS_MD="docs/STATUS.md"

# TC-V5-01: README.md has PdM Delegation Model section
if grep -q "PdM Delegation Model" "$README" 2>/dev/null; then
    test_pass "README.md has PdM Delegation Model section"
else
    test_fail "README.md missing PdM Delegation Model section"
fi

# TC-V5-02: README.md has tdd-orchestrate description
if grep -q "tdd-orchestrate" "$README" 2>/dev/null; then
    test_pass "README.md has tdd-orchestrate description"
else
    test_fail "README.md missing tdd-orchestrate description"
fi

# TC-V5-03: README.md has v5.0 version banner
if grep -q "v5\.0" "$README" 2>/dev/null; then
    test_pass "README.md has v5.0 version banner"
else
    test_fail "README.md missing v5.0 version banner"
fi

# TC-V5-04: README.md has v4.3 -> v5.0 Migration section
if grep -q "v4\.3.*v5\.0\|v5\.0.*Migration\|v4\.3.0.*v5\.0" "$README" 2>/dev/null; then
    test_pass "README.md has v4.3 -> v5.0 Migration section"
else
    test_fail "README.md missing v4.3 -> v5.0 Migration section"
fi

# TC-V5-05: README.md has architect/refactorer mention
if grep -q "architect" "$README" 2>/dev/null && grep -q "refactorer" "$README" 2>/dev/null; then
    test_pass "README.md has architect/refactorer mention"
else
    test_fail "README.md missing architect/refactorer mention"
fi

# TC-V5-06: STATUS.md has 0 Open Issues (no issue rows in Open Issues table)
if [ -f "$STATUS_MD" ]; then
    OPEN_ISSUE_COUNT=$(sed -n '/## Open Issues/,/## /p' "$STATUS_MD" 2>/dev/null | grep -c "^| #[0-9]" 2>/dev/null)
    if [ "$OPEN_ISSUE_COUNT" -eq 0 ]; then
        test_pass "STATUS.md has 0 Open Issues"
    else
        test_fail "STATUS.md has ${OPEN_ISSUE_COUNT} Open Issues (expected 0)"
    fi
else
    test_fail "STATUS.md not found"
fi

echo ""

# ==========================================
# Agent Memory Frontmatter Tests
# ==========================================
echo "--- Agent Memory Frontmatter ---"

# TC-MEM-01: security-reviewer.md has memory: project in frontmatter
if grep -q "memory: project" "$AGENTS_DIR/security-reviewer.md" 2>/dev/null; then
    test_pass "security-reviewer.md has memory: project"
else
    test_fail "security-reviewer.md missing memory: project"
fi

# TC-MEM-02: performance-reviewer.md has memory: project in frontmatter
if grep -q "memory: project" "$AGENTS_DIR/performance-reviewer.md" 2>/dev/null; then
    test_pass "performance-reviewer.md has memory: project"
else
    test_fail "performance-reviewer.md missing memory: project"
fi

# TC-MEM-03: correctness-reviewer.md has memory: project in frontmatter
if grep -q "memory: project" "$AGENTS_DIR/correctness-reviewer.md" 2>/dev/null; then
    test_pass "correctness-reviewer.md has memory: project"
else
    test_fail "correctness-reviewer.md missing memory: project"
fi

# TC-MEM-04: guidelines-reviewer.md has memory: project in frontmatter
if grep -q "memory: project" "$AGENTS_DIR/guidelines-reviewer.md" 2>/dev/null; then
    test_pass "guidelines-reviewer.md has memory: project"
else
    test_fail "guidelines-reviewer.md missing memory: project"
fi

# TC-MEM-05: socrates.md has memory: project in frontmatter
if grep -q "memory: project" "$AGENTS_DIR/socrates.md" 2>/dev/null; then
    test_pass "socrates.md has memory: project"
else
    test_fail "socrates.md missing memory: project"
fi

# TC-MEM-06: architect.md has memory: project in frontmatter
if grep -q "memory: project" "$AGENTS_DIR/architect.md" 2>/dev/null; then
    test_pass "architect.md has memory: project"
else
    test_fail "architect.md missing memory: project"
fi

# TC-MEM-07: All 6 memory agents have Memory section in body
MEM_AGENTS="security-reviewer performance-reviewer correctness-reviewer guidelines-reviewer socrates architect"
MEM_SECTION_COUNT=0
for agent in $MEM_AGENTS; do
    if grep -q "## Memory" "$AGENTS_DIR/$agent.md" 2>/dev/null; then
        MEM_SECTION_COUNT=$((MEM_SECTION_COUNT + 1))
    fi
done
if [ "$MEM_SECTION_COUNT" -eq 6 ]; then
    test_pass "All 6 memory agents have ## Memory section"
else
    test_fail "Only ${MEM_SECTION_COUNT}/6 memory agents have ## Memory section"
fi

# TC-MEM-08: red-worker.md does NOT have memory frontmatter
if ! grep -q "memory:" "$AGENTS_DIR/red-worker.md" 2>/dev/null; then
    test_pass "red-worker.md does not have memory frontmatter"
else
    test_fail "red-worker.md should not have memory frontmatter"
fi

# TC-MEM-09: green-worker.md does NOT have memory frontmatter
if ! grep -q "memory:" "$AGENTS_DIR/green-worker.md" 2>/dev/null; then
    test_pass "green-worker.md does not have memory frontmatter"
else
    test_fail "green-worker.md should not have memory frontmatter"
fi

# TC-MEM-10: refactorer.md does NOT have memory frontmatter
if ! grep -q "memory:" "$AGENTS_DIR/refactorer.md" 2>/dev/null; then
    test_pass "refactorer.md does not have memory frontmatter"
else
    test_fail "refactorer.md should not have memory frontmatter"
fi

# TC-MEM-11: scope-reviewer.md does NOT have memory frontmatter
if ! grep -q "memory:" "$AGENTS_DIR/scope-reviewer.md" 2>/dev/null; then
    test_pass "scope-reviewer.md does not have memory frontmatter"
else
    test_fail "scope-reviewer.md should not have memory frontmatter"
fi

echo ""

# ==========================================
# Recommended Hooks + Onboard Guidance Tests
# ==========================================
echo "--- Recommended Hooks + Onboard Guidance ---"

HOOKS_MD=".claude/hooks/recommended.md"

# TC-HK-01: recommended.md has --no-verify block hook
if grep -q "\-\-no-verify" "$HOOKS_MD" 2>/dev/null; then
    test_pass "recommended.md has --no-verify block hook"
else
    test_fail "recommended.md missing --no-verify block hook"
fi

# TC-HK-02: recommended.md has rm -rf block hook
if grep -q "rm.*-rf\|rm.*-r.*f" "$HOOKS_MD" 2>/dev/null; then
    test_pass "recommended.md has rm -rf block hook"
else
    test_fail "recommended.md missing rm -rf block hook"
fi

# TC-HK-03: tdd-onboard SKILL.md Step 6 has settings.json guidance
if grep -qi "settings.json" "$ONBOARD_SKILL" 2>/dev/null; then
    test_pass "tdd-onboard SKILL.md has settings.json guidance"
else
    test_fail "tdd-onboard SKILL.md missing settings.json guidance"
fi

# TC-HK-04: tdd-onboard reference.md recommended.md template has rm -rf
if grep -q "rm.*-rf\|rm.*-r.*f" "$ONBOARD_REF" 2>/dev/null; then
    test_pass "tdd-onboard reference.md template has rm -rf hook"
else
    test_fail "tdd-onboard reference.md template missing rm -rf hook"
fi

echo ""

# ==========================================
# Token Compression: tdd-onboard reference.md
# ==========================================
echo "--- Token Compression: tdd-onboard reference.md ---"

ONBOARD_REF="$PLUGINS_DIR/tdd-core/skills/tdd-onboard/reference.md"

# TC-TC-01: reference.md byte count <= 4000
ONBOARD_REF_BYTES=$(wc -c < "$ONBOARD_REF" 2>/dev/null | tr -d ' ')
if [ -n "$ONBOARD_REF_BYTES" ] && [ "$ONBOARD_REF_BYTES" -le 4000 ]; then
    test_pass "tdd-onboard reference.md is ${ONBOARD_REF_BYTES} bytes (<= 4000)"
else
    test_fail "tdd-onboard reference.md is ${ONBOARD_REF_BYTES} bytes (> 4000)"
fi

# TC-TC-02: reference.md contains reference paths to .claude/rules/ and .claude/hooks/
TC_TC_02_REFS=0
for ref_path in ".claude/rules/security.md" ".claude/rules/git-safety.md" ".claude/rules/git-conventions.md" ".claude/hooks/recommended.md"; do
    if grep -q "$ref_path" "$ONBOARD_REF" 2>/dev/null; then
        TC_TC_02_REFS=$((TC_TC_02_REFS + 1))
    fi
done
if [ "$TC_TC_02_REFS" -eq 4 ]; then
    test_pass "tdd-onboard reference.md has all 4 reference paths"
else
    test_fail "tdd-onboard reference.md has ${TC_TC_02_REFS}/4 reference paths"
fi

# TC-TC-03: reference.md does NOT contain full security.md embed
if ! grep -q "ハードコードされた秘密鍵" "$ONBOARD_REF" 2>/dev/null; then
    test_pass "tdd-onboard reference.md no security.md full embed"
else
    test_fail "tdd-onboard reference.md still has security.md full embed"
fi

# TC-TC-04: reference.md does NOT contain full git-safety.md embed
if ! grep -q "force-with-leaseは許可" "$ONBOARD_REF" 2>/dev/null; then
    test_pass "tdd-onboard reference.md no git-safety.md full embed"
else
    test_fail "tdd-onboard reference.md still has git-safety.md full embed"
fi

# TC-TC-05: reference.md does NOT contain full recommended.md embed (no JSON settings block)
if ! grep -q '"PreToolUse"' "$ONBOARD_REF" 2>/dev/null; then
    test_pass "tdd-onboard reference.md no recommended.md JSON embed"
else
    test_fail "tdd-onboard reference.md still has recommended.md JSON embed"
fi

# TC-TC-06: reference.md still has framework detection table
if grep -q "artisan" "$ONBOARD_REF" 2>/dev/null && grep -q "app.py" "$ONBOARD_REF" 2>/dev/null; then
    test_pass "tdd-onboard reference.md has framework detection table"
else
    test_fail "tdd-onboard reference.md missing framework detection table"
fi

# TC-TC-07: reference.md still has variable list
if grep -q '${PROJECT_NAME}' "$ONBOARD_REF" 2>/dev/null && grep -q '${TEST_COMMAND}' "$ONBOARD_REF" 2>/dev/null; then
    test_pass "tdd-onboard reference.md has variable list"
else
    test_fail "tdd-onboard reference.md missing variable list"
fi

echo ""

# ==========================================
# Hooks Integration Tests
# ==========================================
echo "--- Hooks Integration ---"

HOOKS_MD=".claude/hooks/recommended.md"
INIT_SKILL="$PLUGINS_DIR/tdd-core/skills/tdd-init/SKILL.md"
INIT_REF="$PLUGINS_DIR/tdd-core/skills/tdd-init/reference.md"
DEBUG_SCRIPT="scripts/check-debug-statements.sh"

# TC-HI-01: check-debug-statements.sh exists and is executable
if [ -x "$DEBUG_SCRIPT" ]; then
    test_pass "check-debug-statements.sh exists and is executable"
else
    test_fail "check-debug-statements.sh missing or not executable"
fi

# TC-HI-02: recommended.md has PostToolUse hook
if grep -q "PostToolUse" "$HOOKS_MD" 2>/dev/null; then
    test_pass "recommended.md has PostToolUse hook"
else
    test_fail "recommended.md missing PostToolUse hook"
fi

# TC-HI-03: recommended.md has SessionStart hook
if grep -q "SessionStart" "$HOOKS_MD" 2>/dev/null; then
    test_pass "recommended.md has SessionStart hook"
else
    test_fail "recommended.md missing SessionStart hook"
fi

# TC-HI-04: recommended.md has Stop hook with git status warning
if grep -q "git status" "$HOOKS_MD" 2>/dev/null; then
    test_pass "recommended.md has Stop hook with git status"
else
    test_fail "recommended.md missing Stop hook with git status"
fi

# TC-HI-05: recommended.md has check-debug-statements.sh reference
if grep -q "check-debug-statements" "$HOOKS_MD" 2>/dev/null; then
    test_pass "recommended.md has check-debug-statements.sh reference"
else
    test_fail "recommended.md missing check-debug-statements.sh reference"
fi

# TC-HI-06: tdd-init has hooks check (SKILL.md or reference.md)
if grep -qi "hooks" "$INIT_SKILL" "$INIT_REF" 2>/dev/null; then
    test_pass "tdd-init has hooks check"
else
    test_fail "tdd-init missing hooks check"
fi

# TC-HI-07: tdd-init SKILL.md is 100 lines or less (post-edit)
INIT_LINES=$(wc -l < "$INIT_SKILL" 2>/dev/null | tr -d ' ')
if [ -n "$INIT_LINES" ] && [ "$INIT_LINES" -le 100 ]; then
    test_pass "tdd-init SKILL.md is ${INIT_LINES} lines (<= 100)"
else
    test_fail "tdd-init SKILL.md is ${INIT_LINES} lines (> 100)"
fi

echo ""

echo "=========================================="
echo "Results: $PASS passed, $FAIL failed"
echo "=========================================="

if [ "$FAIL" -gt 0 ]; then
    exit 1
fi
