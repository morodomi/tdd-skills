#!/bin/bash
# Test: discovered-issue-creation
# Cycle doc: docs/cycles/20260206_discovered-issue-creation.md

set -e

PLUGIN_DIR="plugins/tdd-core/skills"
ERRORS=0

echo "=== DISCOVERED Issue Auto-Creation Tests ==="
echo ""

# --- tdd-orchestrate ---
echo "--- tdd-orchestrate ---"

ORCH_SKILL="$PLUGIN_DIR/tdd-orchestrate/SKILL.md"
ORCH_REF="$PLUGIN_DIR/tdd-orchestrate/reference.md"
ORCH_TEAMS="$PLUGIN_DIR/tdd-orchestrate/steps-teams.md"
ORCH_SUB="$PLUGIN_DIR/tdd-orchestrate/steps-subagent.md"

# TC-01: SKILL.md の Block 2 にDISCOVERED処理が記載されていること
echo -n "TC-01: tdd-orchestrate SKILL.md Block 2 has DISCOVERED processing... "
if grep -A20 "Block 2" "$ORCH_SKILL" 2>/dev/null | grep -qi "DISCOVERED"; then
    echo "PASS"
else
    echo "FAIL"
    ERRORS=$((ERRORS + 1))
fi

# TC-02: steps-teams.md の REVIEW 自律判断後に「DISCOVERED判断」ステップが存在すること
echo -n "TC-02: steps-teams.md has DISCOVERED judgment step after REVIEW... "
if grep -qi "DISCOVERED" "$ORCH_TEAMS" 2>/dev/null; then
    echo "PASS"
else
    echo "FAIL"
    ERRORS=$((ERRORS + 1))
fi

# TC-03: steps-teams.md に gh issue create コマンドテンプレートが記載されていること
echo -n "TC-03: steps-teams.md has gh issue create command template... "
if grep -q "gh issue create" "$ORCH_TEAMS" 2>/dev/null; then
    echo "PASS"
else
    echo "FAIL"
    ERRORS=$((ERRORS + 1))
fi

# TC-04: steps-subagent.md の Block 2 REVIEW後に DISCOVERED 処理が記載されていること
echo -n "TC-04: steps-subagent.md has DISCOVERED processing after REVIEW... "
if grep -qi "DISCOVERED" "$ORCH_SUB" 2>/dev/null; then
    echo "PASS"
else
    echo "FAIL"
    ERRORS=$((ERRORS + 1))
fi

# TC-05: reference.md の PdM 責務に「DISCOVERED issue 起票」が追加されていること
echo -n "TC-05: reference.md PdM responsibilities include DISCOVERED issue creation... "
if grep -qi "DISCOVERED" "$ORCH_REF" 2>/dev/null && grep -q "issue" "$ORCH_REF" 2>/dev/null; then
    echo "PASS"
else
    echo "FAIL"
    ERRORS=$((ERRORS + 1))
fi

echo ""

# --- tdd-review ---
echo "--- tdd-review ---"

REVIEW_SKILL="$PLUGIN_DIR/tdd-review/SKILL.md"
REVIEW_REF="$PLUGIN_DIR/tdd-review/reference.md"

# TC-06: SKILL.md に Step 6 として DISCOVERED issue 起票ステップが存在すること（リナンバ済み）
echo -n "TC-06: tdd-review SKILL.md has DISCOVERED step (renumbered)... "
if grep -q "DISCOVERED" "$REVIEW_SKILL" 2>/dev/null && grep -qi "issue" "$REVIEW_SKILL" 2>/dev/null; then
    echo "PASS"
else
    echo "FAIL"
    ERRORS=$((ERRORS + 1))
fi

# TC-07: reference.md に issue 起票の判断基準・コマンド詳細が記載されていること
echo -n "TC-07: tdd-review reference.md has issue creation criteria and command... "
if grep -q "gh issue create" "$REVIEW_REF" 2>/dev/null && grep -qi "DISCOVERED" "$REVIEW_REF" 2>/dev/null; then
    echo "PASS"
else
    echo "FAIL"
    ERRORS=$((ERRORS + 1))
fi

echo ""

# --- 共通 ---
echo "--- Common ---"

# TC-08: issue タイトル形式が [DISCOVERED] <要約> であること
echo -n "TC-08: Issue title format is [DISCOVERED] <summary>... "
DISCOVERED_TITLE_FOUND=0
for f in "$ORCH_TEAMS" "$ORCH_SUB" "$REVIEW_REF"; do
    if grep -q '\[DISCOVERED\]' "$f" 2>/dev/null; then
        DISCOVERED_TITLE_FOUND=1
        break
    fi
done
if [ "$DISCOVERED_TITLE_FOUND" -eq 1 ]; then
    echo "PASS"
else
    echo "FAIL"
    ERRORS=$((ERRORS + 1))
fi

# TC-09: issue に discovered ラベルが指定されていること
echo -n "TC-09: Issue has 'discovered' label... "
LABEL_FOUND=0
for f in "$ORCH_TEAMS" "$ORCH_SUB" "$REVIEW_REF"; do
    if grep -q '\-\-label.*discovered\|label.*"discovered"' "$f" 2>/dev/null; then
        LABEL_FOUND=1
        break
    fi
done
if [ "$LABEL_FOUND" -eq 1 ]; then
    echo "PASS"
else
    echo "FAIL"
    ERRORS=$((ERRORS + 1))
fi

# TC-10: DISCOVERED が空の場合はissue起票をスキップする記載があること
echo -n "TC-10: Skip issue creation when DISCOVERED is empty... "
SKIP_FOUND=0
for f in "$ORCH_TEAMS" "$ORCH_SUB" "$ORCH_REF" "$REVIEW_SKILL" "$REVIEW_REF"; do
    if grep -qi "DISCOVERED.*空\|DISCOVERED.*none.*スキップ\|DISCOVERED.*スキップ\|DISCOVERED.*empty.*skip" "$f" 2>/dev/null; then
        SKIP_FOUND=1
        break
    fi
done
if [ "$SKIP_FOUND" -eq 1 ]; then
    echo "PASS"
else
    echo "FAIL"
    ERRORS=$((ERRORS + 1))
fi

# TC-11: gh auth status による事前チェックが記載されていること
echo -n "TC-11: gh auth status pre-check is documented... "
AUTH_CHECK_FOUND=0
for f in "$ORCH_TEAMS" "$ORCH_SUB" "$ORCH_REF" "$REVIEW_REF"; do
    if grep -q "gh auth status" "$f" 2>/dev/null; then
        AUTH_CHECK_FOUND=1
        break
    fi
done
if [ "$AUTH_CHECK_FOUND" -eq 1 ]; then
    echo "PASS"
else
    echo "FAIL"
    ERRORS=$((ERRORS + 1))
fi

# TC-12: ユーザー確認ゲート（issue作成前の承認）が記載されていること
echo -n "TC-12: User confirmation gate before issue creation... "
CONFIRM_FOUND=0
for f in "$ORCH_TEAMS" "$ORCH_SUB" "$ORCH_REF" "$REVIEW_SKILL" "$REVIEW_REF"; do
    if grep -qi "issue.*作成.*確認\|issue.*承認\|issue.*Y/n\|DISCOVERED.*確認.*ゲート\|GitHub issue.*確認" "$f" 2>/dev/null; then
        CONFIRM_FOUND=1
        break
    fi
done
if [ "$CONFIRM_FOUND" -eq 1 ]; then
    echo "PASS"
else
    echo "FAIL"
    ERRORS=$((ERRORS + 1))
fi

# TC-13: 重複防止（→ #<番号> 付き項目のスキップ）が記載されていること
echo -n "TC-13: Duplicate prevention (skip items with issue number)... "
DEDUP_FOUND=0
for f in "$ORCH_TEAMS" "$ORCH_SUB" "$ORCH_REF" "$REVIEW_REF"; do
    if grep -q '→ #\|重複防止\|duplicate\|起票済み' "$f" 2>/dev/null; then
        DEDUP_FOUND=1
        break
    fi
done
if [ "$DEDUP_FOUND" -eq 1 ]; then
    echo "PASS"
else
    echo "FAIL"
    ERRORS=$((ERRORS + 1))
fi

# TC-14: issue body に Cycle doc パス・Phase・Reviewer が含まれること
echo -n "TC-14: Issue body includes Cycle doc path, Phase, Reviewer... "
BODY_FOUND=0
for f in "$ORCH_TEAMS" "$ORCH_SUB" "$REVIEW_REF"; do
    if grep -qi "Cycle.*doc\|Phase\|Reviewer\|発見元" "$f" 2>/dev/null && grep -q "body" "$f" 2>/dev/null; then
        BODY_FOUND=1
        break
    fi
done
if [ "$BODY_FOUND" -eq 1 ]; then
    echo "PASS"
else
    echo "FAIL"
    ERRORS=$((ERRORS + 1))
fi

# TC-15: 既存の Plugin 構造テスト (test-plugins-structure.sh) が通ること
echo -n "TC-15: test-plugins-structure.sh passes... "
if bash scripts/test-plugins-structure.sh >/dev/null 2>&1; then
    echo "PASS"
else
    echo "FAIL"
    ERRORS=$((ERRORS + 1))
fi

echo ""
echo "=== Results ==="
if [ "$ERRORS" -eq 0 ]; then
    echo "All tests passed!"
    exit 0
else
    echo "$ERRORS test(s) failed"
    exit 1
fi
