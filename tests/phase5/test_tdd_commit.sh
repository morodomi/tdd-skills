#!/usr/bin/env bash
# test_tdd_commit.sh

echo "TC-08: tdd-commit Skill のテスト"

FILE="templates/generic/.claude/skills/tdd-commit/SKILL.md"

if [ ! -f "$FILE" ]; then
  echo "✗ ファイルが存在しません: $FILE"
  exit 1
fi

PASS=0
FAIL=0

# Git/MCP関連の要素の存在確認（存在すべき）
GIT_ELEMENTS=(
  "git status"
  "git add"
  "git commit"
  "MCP"
  "Co-Authored-By"
  "コミットメッセージ"
)

echo "=== Git/MCP要素の存在チェック ==="
for element in "${GIT_ELEMENTS[@]}"; do
  if grep -q "$element" "$FILE"; then
    echo "✓ Git/MCP要素が含まれています: $element"
    PASS=$((PASS + 1))
  else
    echo "✗ Git/MCP要素が見つかりません: $element"
    FAIL=$((FAIL + 1))
  fi
done

echo ""
echo "結果: $PASS passed, $FAIL failed"

if [ $FAIL -eq 0 ]; then
  echo "✓ TC-08: PASS"
  exit 0
else
  echo "✗ TC-08: FAIL"
  exit 1
fi
