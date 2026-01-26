#!/bin/bash
# v3.3 GREEN Parallelization Test Script
# Test List validation for GREEN parallel execution feature

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

PASS=0
FAIL=0

check() {
    local desc="$1"
    local result="$2"
    if [ "$result" = "true" ]; then
        echo -e "${GREEN}PASS${NC}: $desc"
        ((PASS++))
    else
        echo -e "${RED}FAIL${NC}: $desc"
        ((FAIL++))
    fi
}

echo "========================================"
echo "v3.3 GREEN Parallelization Tests"
echo "========================================"
echo ""

# File paths
GREEN_SKILL="$PROJECT_ROOT/plugins/tdd-core/skills/tdd-green/SKILL.md"
GREEN_REF="$PROJECT_ROOT/plugins/tdd-core/skills/tdd-green/reference.md"
GREEN_WORKER="$PROJECT_ROOT/plugins/tdd-core/agents/green-worker.md"
RED_SKILL="$PROJECT_ROOT/plugins/tdd-core/skills/tdd-red/SKILL.md"
CLAUDE_MD="$PROJECT_ROOT/CLAUDE.md"
README_MD="$PROJECT_ROOT/README.md"

# TC-01: tdd-green/SKILL.md に並列実行ワークフローがある
if [ -f "$GREEN_SKILL" ]; then
    if grep -q "並列" "$GREEN_SKILL" || grep -q "parallel" "$GREEN_SKILL"; then
        check "TC-01: tdd-green/SKILL.md に並列実行ワークフローがある" "true"
    else
        check "TC-01: tdd-green/SKILL.md に並列実行ワークフローがある" "false"
    fi
else
    check "TC-01: tdd-green/SKILL.md に並列実行ワークフローがある" "false"
fi

# TC-02: tdd-green/SKILL.md に "green-worker" への言及がある
if [ -f "$GREEN_SKILL" ]; then
    if grep -q "green-worker" "$GREEN_SKILL"; then
        check "TC-02: tdd-green/SKILL.md に green-worker への言及がある" "true"
    else
        check "TC-02: tdd-green/SKILL.md に green-worker への言及がある" "false"
    fi
else
    check "TC-02: tdd-green/SKILL.md に green-worker への言及がある" "false"
fi

# TC-03: tdd-green/SKILL.md に "ファイル依存関係分析" の説明がある
if [ -f "$GREEN_SKILL" ]; then
    if grep -q "ファイル依存" "$GREEN_SKILL" || grep -q "file dependency" "$GREEN_SKILL" || grep -q "依存関係分析" "$GREEN_SKILL"; then
        check "TC-03: tdd-green/SKILL.md にファイル依存関係分析の説明がある" "true"
    else
        check "TC-03: tdd-green/SKILL.md にファイル依存関係分析の説明がある" "false"
    fi
else
    check "TC-03: tdd-green/SKILL.md にファイル依存関係分析の説明がある" "false"
fi

# TC-04: agents/green-worker.md が存在する
if [ -f "$GREEN_WORKER" ]; then
    check "TC-04: agents/green-worker.md が存在する" "true"
else
    check "TC-04: agents/green-worker.md が存在する" "false"
fi

# TC-05: green-worker.md に入力仕様がある
if [ -f "$GREEN_WORKER" ]; then
    if grep -q "Input" "$GREEN_WORKER" || grep -q "入力" "$GREEN_WORKER"; then
        check "TC-05: green-worker.md に入力仕様がある" "true"
    else
        check "TC-05: green-worker.md に入力仕様がある" "false"
    fi
else
    check "TC-05: green-worker.md に入力仕様がある" "false"
fi

# TC-06: green-worker.md に出力形式の定義がある
if [ -f "$GREEN_WORKER" ]; then
    if grep -q "Output" "$GREEN_WORKER" || grep -q "出力" "$GREEN_WORKER"; then
        check "TC-06: green-worker.md に出力形式の定義がある" "true"
    else
        check "TC-06: green-worker.md に出力形式の定義がある" "false"
    fi
else
    check "TC-06: green-worker.md に出力形式の定義がある" "false"
fi

# TC-07: tdd-green/reference.md に並列実行の詳細がある
if [ -f "$GREEN_REF" ]; then
    if grep -q "並列" "$GREEN_REF" || grep -q "parallel" "$GREEN_REF"; then
        check "TC-07: tdd-green/reference.md に並列実行の詳細がある" "true"
    else
        check "TC-07: tdd-green/reference.md に並列実行の詳細がある" "false"
    fi
else
    check "TC-07: tdd-green/reference.md に並列実行の詳細がある" "false"
fi

# TC-08: tdd-green/reference.md に競合解決戦略がある
if [ -f "$GREEN_REF" ]; then
    if grep -q "競合" "$GREEN_REF" || grep -q "conflict" "$GREEN_REF"; then
        check "TC-08: tdd-green/reference.md に競合解決戦略がある" "true"
    else
        check "TC-08: tdd-green/reference.md に競合解決戦略がある" "false"
    fi
else
    check "TC-08: tdd-green/reference.md に競合解決戦略がある" "false"
fi

# TC-09: tdd-red/SKILL.md から「1つずつ」制約が削除されている
if [ -f "$RED_SKILL" ]; then
    if grep -q "1つずつ" "$RED_SKILL"; then
        check "TC-09: tdd-red/SKILL.md から「1つずつ」制約が削除されている" "false"
    else
        check "TC-09: tdd-red/SKILL.md から「1つずつ」制約が削除されている" "true"
    fi
else
    check "TC-09: tdd-red/SKILL.md から「1つずつ」制約が削除されている" "false"
fi

# TC-10: CLAUDE.md に TDD Philosophy セクションがある
if [ -f "$CLAUDE_MD" ]; then
    if grep -q "TDD Philosophy" "$CLAUDE_MD"; then
        check "TC-10: CLAUDE.md に TDD Philosophy セクションがある" "true"
    else
        check "TC-10: CLAUDE.md に TDD Philosophy セクションがある" "false"
    fi
else
    check "TC-10: CLAUDE.md に TDD Philosophy セクションがある" "false"
fi

# TC-11: README.md に TDD Philosophy セクションがある
if [ -f "$README_MD" ]; then
    if grep -q "TDD Philosophy" "$README_MD"; then
        check "TC-11: README.md に TDD Philosophy セクションがある" "true"
    else
        check "TC-11: README.md に TDD Philosophy セクションがある" "false"
    fi
else
    check "TC-11: README.md に TDD Philosophy セクションがある" "false"
fi

# TC-12: tdd-green/SKILL.md が100行以下
if [ -f "$GREEN_SKILL" ]; then
    LINE_COUNT=$(wc -l < "$GREEN_SKILL" | tr -d ' ')
    if [ "$LINE_COUNT" -le 100 ]; then
        check "TC-12: tdd-green/SKILL.md が100行以下 (現在: ${LINE_COUNT}行)" "true"
    else
        check "TC-12: tdd-green/SKILL.md が100行以下 (現在: ${LINE_COUNT}行)" "false"
    fi
else
    check "TC-12: tdd-green/SKILL.md が100行以下" "false"
fi

echo ""
echo "========================================"
echo "Results: ${PASS} passed, ${FAIL} failed"
echo "========================================"

if [ "$FAIL" -gt 0 ]; then
    exit 1
fi
