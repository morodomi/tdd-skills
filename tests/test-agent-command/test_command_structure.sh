#!/usr/bin/env bash

################################################################################
# Test Agent Command - Structure Tests
################################################################################

set -e

# プロジェクトルートを取得
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# 色定義
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# テスト結果カウンター
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
echo "Test Agent Command - Structure Tests"
echo "=========================================="
echo ""

COMMAND_FILE="$PROJECT_ROOT/.claude/commands/test-agent.md"

################################################################################
# TC-01: .claude/commands/test-agent.mdが存在する
################################################################################
echo "TC-01: .claude/commands/test-agent.mdが存在する"

if [ -f "$COMMAND_FILE" ]; then
    FILE_SIZE=$(stat -f%z "$COMMAND_FILE" 2>/dev/null || stat -c%s "$COMMAND_FILE" 2>/dev/null)
    if [ "$FILE_SIZE" -ge 1000 ]; then
        pass "TC-01: test-agent.mdが存在する（$FILE_SIZE bytes）"
    else
        fail "TC-01: test-agent.mdが小さすぎる（$FILE_SIZE bytes）"
    fi
else
    fail "TC-01: test-agent.mdが存在しない: $COMMAND_FILE"
fi

################################################################################
# TC-02: 有効なYAML frontmatterを持つ
################################################################################
echo "TC-02: 有効なYAML frontmatterを持つ（description等）"

if [ -f "$COMMAND_FILE" ]; then
    if head -1 "$COMMAND_FILE" | grep -q "^---$"; then
        if grep -q "^description:" "$COMMAND_FILE"; then
            pass "TC-02: 有効なYAML frontmatter（description）"
        else
            fail "TC-02: descriptionが見つからない"
        fi
    else
        fail "TC-02: YAML frontmatterが見つからない"
    fi
else
    fail "TC-02: ファイルが存在しない"
fi

################################################################################
# TC-03: Task tool使用の指示がある
################################################################################
echo "TC-03: Task tool使用の指示がある（general-purposeエージェント起動）"

if [ -f "$COMMAND_FILE" ]; then
    if grep -qE "Task|general-purpose|エージェント" "$COMMAND_FILE"; then
        pass "TC-03: Task tool使用の指示がある"
    else
        fail "TC-03: Task tool使用の指示が見つからない"
    fi
else
    fail "TC-03: ファイルが存在しない"
fi

################################################################################
# TC-04: カバレッジ測定の指示がある
################################################################################
echo "TC-04: カバレッジ測定の指示がある（phpunit --coverage-text）"

if [ -f "$COMMAND_FILE" ]; then
    if grep -qE "phpunit.*--coverage|coverage.*phpunit|カバレッジ.*測定" "$COMMAND_FILE"; then
        pass "TC-04: カバレッジ測定の指示がある"
    else
        fail "TC-04: カバレッジ測定の指示が見つからない"
    fi
else
    fail "TC-04: ファイルが存在しない"
fi

################################################################################
# TC-05: 対象ファイル選定の指示がある
################################################################################
echo "TC-05: 対象ファイル選定の指示がある（git log, 直近更新頻度）"

if [ -f "$COMMAND_FILE" ]; then
    if grep -qE "git log|更新頻度|ファイル.*選定|対象.*ファイル" "$COMMAND_FILE"; then
        pass "TC-05: 対象ファイル選定の指示がある"
    else
        fail "TC-05: 対象ファイル選定の指示が見つからない"
    fi
else
    fail "TC-05: ファイルが存在しない"
fi

################################################################################
# TC-06: ブランチ作成の指示がある
################################################################################
echo "TC-06: ブランチ作成の指示がある（test/test-agent-YYYYMMDD-HHmm）"

if [ -f "$COMMAND_FILE" ]; then
    if grep -qE "test/test-agent|ブランチ.*作成|git checkout -b" "$COMMAND_FILE"; then
        pass "TC-06: ブランチ作成の指示がある"
    else
        fail "TC-06: ブランチ作成の指示が見つからない"
    fi
else
    fail "TC-06: ファイルが存在しない"
fi

################################################################################
# TC-07: テスト追加の指示がある
################################################################################
echo "TC-07: テスト追加の指示がある（既存構造に合わせる、500行制限）"

if [ -f "$COMMAND_FILE" ]; then
    if grep -qE "テスト.*追加|既存.*構造|500行|ディレクトリ.*分割" "$COMMAND_FILE"; then
        pass "TC-07: テスト追加の指示がある"
    else
        fail "TC-07: テスト追加の指示が見つからない"
    fi
else
    fail "TC-07: ファイルが存在しない"
fi

################################################################################
# TC-08: PHPStan対応の指示がある
################################################################################
echo "TC-08: PHPStan対応の指示がある（Level 8まで段階的）"

if [ -f "$COMMAND_FILE" ]; then
    if grep -qE "PHPStan|phpstan|Level 8|段階的" "$COMMAND_FILE"; then
        pass "TC-08: PHPStan対応の指示がある"
    else
        fail "TC-08: PHPStan対応の指示が見つからない"
    fi
else
    fail "TC-08: ファイルが存在しない"
fi

################################################################################
# TC-09: PR作成の指示がある
################################################################################
echo "TC-09: PR作成の指示がある（成功時、gh pr create）"

if [ -f "$COMMAND_FILE" ]; then
    if grep -qE "gh pr create|PR.*作成|pull request" "$COMMAND_FILE"; then
        pass "TC-09: PR作成の指示がある"
    else
        fail "TC-09: PR作成の指示が見つからない"
    fi
else
    fail "TC-09: ファイルが存在しない"
fi

################################################################################
# TC-10: Issue作成の指示がある
################################################################################
echo "TC-10: Issue作成の指示がある（失敗時、gh issue create）"

if [ -f "$COMMAND_FILE" ]; then
    if grep -qE "gh issue create|Issue.*作成|issue.*create" "$COMMAND_FILE"; then
        pass "TC-10: Issue作成の指示がある"
    else
        fail "TC-10: Issue作成の指示が見つからない"
    fi
else
    fail "TC-10: ファイルが存在しない"
fi

################################################################################
# TC-11: エラーハンドリングの指示がある
################################################################################
echo "TC-11: エラーハンドリングの指示がある（ユーザー確認、既存コード不変）"

if [ -f "$COMMAND_FILE" ]; then
    if grep -qE "エラー|失敗|ユーザー.*確認|既存.*コード|触らない" "$COMMAND_FILE"; then
        pass "TC-11: エラーハンドリングの指示がある"
    else
        fail "TC-11: エラーハンドリングの指示が見つからない"
    fi
else
    fail "TC-11: ファイルが存在しない"
fi

################################################################################
# テスト結果サマリー
################################################################################
echo ""
echo "=========================================="
echo "Test Results Summary"
echo "=========================================="
echo -e "PASS: ${GREEN}${PASS_COUNT}${NC}"
echo -e "FAIL: ${RED}${FAIL_COUNT}${NC}"
echo ""

if [ $FAIL_COUNT -eq 0 ]; then
    echo -e "${GREEN}All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}Some tests failed.${NC}"
    exit 1
fi
