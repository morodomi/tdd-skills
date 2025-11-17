#!/usr/bin/env bash
################################################################################
# UX Design Skill Tests - SKILL.md Structure Validation
################################################################################

set -e

# 色定義
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

PASS_COUNT=0
FAIL_COUNT=0

# テスト結果表示
pass() {
    echo -e "${GREEN}✓ PASS${NC}: $1"
    ((PASS_COUNT++)) || true
}

fail() {
    echo -e "${RED}✗ FAIL${NC}: $1"
    ((FAIL_COUNT++)) || true
}

echo "=========================================="
echo "UX Design Skill - Structure Tests"
echo "=========================================="
echo ""

################################################################################
# TC-01: SKILL.mdが有効なYAML frontmatterを持つ
################################################################################
echo "TC-01: SKILL.mdが有効なYAML frontmatterを持つ"

SKILL_FILE="$PROJECT_ROOT/templates/generic/.claude/skills/ux-design/SKILL.md"

if [ -f "$SKILL_FILE" ]; then
    # YAML frontmatterの存在確認
    if head -1 "$SKILL_FILE" | grep -q "^---$"; then
        # nameフィールドの確認
        if grep -q "^name:" "$SKILL_FILE"; then
            # descriptionフィールドの確認
            if grep -q "^description:" "$SKILL_FILE"; then
                # allowed-toolsフィールドの確認
                if grep -q "^allowed-tools:" "$SKILL_FILE"; then
                    pass "TC-01: 有効なYAML frontmatter（name, description, allowed-tools）"
                else
                    fail "TC-01: allowed-toolsフィールドが見つからない"
                fi
            else
                fail "TC-01: descriptionフィールドが見つからない"
            fi
        else
            fail "TC-01: nameフィールドが見つからない"
        fi
    else
        fail "TC-01: YAML frontmatterが開始されていない（最初の行が---でない）"
    fi
else
    fail "TC-01: SKILL.mdファイルが存在しない: $SKILL_FILE"
fi

################################################################################
# TC-02: 禁止パターンセクションが存在する
################################################################################
echo "TC-02: 禁止パターンセクションが存在する"

if [ -f "$SKILL_FILE" ]; then
    # 禁止パターンセクションの確認
    if grep -q "禁止パターン\|禁止" "$SKILL_FILE"; then
        # 具体的な禁止項目の確認
        PROHIBITION_COUNT=$(grep -c "❌\|禁止" "$SKILL_FILE" || echo "0")
        if [ "$PROHIBITION_COUNT" -ge 5 ]; then
            pass "TC-02: 禁止パターンセクション存在（$PROHIBITION_COUNT 件の禁止項目）"
        else
            fail "TC-02: 禁止項目が少なすぎる（$PROHIBITION_COUNT 件、5件以上必要）"
        fi
    else
        fail "TC-02: 禁止パターンセクションが見つからない"
    fi
else
    fail "TC-02: SKILL.mdファイルが存在しない"
fi

################################################################################
# TC-03: UX心理学原則が10以上記載されている
################################################################################
echo "TC-03: UX心理学原則が10以上記載されている"

if [ -f "$SKILL_FILE" ]; then
    # UX心理学原則のキーワードをカウント
    UX_PRINCIPLES=(
        "アンカー効果"
        "認知負荷"
        "ドハティ"
        "社会的証明"
        "損失回避"
        "ナッジ"
        "段階的要請"
        "ツァイガルニク"
        "変動型報酬"
        "フレーミング"
        "希少性"
        "デフォルト効果"
        "目標勾配"
    )

    FOUND_COUNT=0
    for principle in "${UX_PRINCIPLES[@]}"; do
        if grep -q "$principle" "$SKILL_FILE"; then
            ((FOUND_COUNT++))
        fi
    done

    if [ "$FOUND_COUNT" -ge 10 ]; then
        pass "TC-03: UX心理学原則が10以上記載（$FOUND_COUNT 原則）"
    else
        fail "TC-03: UX心理学原則が不足（$FOUND_COUNT 原則、10以上必要）"
    fi
else
    fail "TC-03: SKILL.mdファイルが存在しない"
fi

################################################################################
# TC-04: Refactoring UI原則が5以上記載されている
################################################################################
echo "TC-04: Refactoring UI原則が5以上記載されている"

if [ -f "$SKILL_FILE" ]; then
    # Refactoring UI原則のキーワードをカウント
    REFUI_PRINCIPLES=(
        "階層|Hierarchy"
        "ボーダー|border"
        "スペーシング|spacing|余白"
        "タイポグラフィ|Typography|フォント"
        "色彩|HSL|シェード"
        "視覚的|視覚"
        "グレースケール"
        "コントラスト"
    )

    FOUND_COUNT=0
    for principle in "${REFUI_PRINCIPLES[@]}"; do
        if grep -qE "$principle" "$SKILL_FILE"; then
            ((FOUND_COUNT++))
        fi
    done

    if [ "$FOUND_COUNT" -ge 5 ]; then
        pass "TC-04: Refactoring UI原則が5以上記載（$FOUND_COUNT 原則）"
    else
        fail "TC-04: Refactoring UI原則が不足（$FOUND_COUNT 原則、5以上必要）"
    fi
else
    fail "TC-04: SKILL.mdファイルが存在しない"
fi

################################################################################
# TC-05: 具体的なUIコンポーネント例が3以上ある
################################################################################
echo "TC-05: 具体的なUIコンポーネント例が3以上ある"

if [ -f "$SKILL_FILE" ]; then
    # UIコンポーネント例のキーワードをカウント
    UI_COMPONENTS=(
        "CTA|ボタン|Button"
        "料金表|Pricing"
        "フォーム|Form|Input"
        "ローディング|Loading"
        "カード|Card"
        "ナビゲーション|Navigation"
    )

    FOUND_COUNT=0
    for component in "${UI_COMPONENTS[@]}"; do
        if grep -qE "$component" "$SKILL_FILE"; then
            ((FOUND_COUNT++))
        fi
    done

    if [ "$FOUND_COUNT" -ge 3 ]; then
        pass "TC-05: 具体的なUIコンポーネント例が3以上（$FOUND_COUNT コンポーネント）"
    else
        fail "TC-05: UIコンポーネント例が不足（$FOUND_COUNT コンポーネント、3以上必要）"
    fi
else
    fail "TC-05: SKILL.mdファイルが存在しない"
fi

################################################################################
# TC-06: チェックリストが存在する
################################################################################
echo "TC-06: チェックリストが存在する"

if [ -f "$SKILL_FILE" ]; then
    # チェックリストの確認（- [ ] または - [x] パターン）
    CHECKLIST_COUNT=$(grep -c "\- \[ \]\|- \[x\]" "$SKILL_FILE" || echo "0")

    if [ "$CHECKLIST_COUNT" -ge 10 ]; then
        pass "TC-06: チェックリスト存在（$CHECKLIST_COUNT 項目）"
    else
        fail "TC-06: チェックリスト項目が不足（$CHECKLIST_COUNT 項目、10以上必要）"
    fi
else
    fail "TC-06: SKILL.mdファイルが存在しない"
fi

################################################################################
# 結果サマリー
################################################################################
echo ""
echo "=========================================="
echo "Test Results Summary"
echo "=========================================="
echo -e "PASS: ${GREEN}$PASS_COUNT${NC}"
echo -e "FAIL: ${RED}$FAIL_COUNT${NC}"
echo ""

if [ "$FAIL_COUNT" -eq 0 ]; then
    echo -e "${GREEN}All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}Some tests failed.${NC}"
    exit 1
fi
