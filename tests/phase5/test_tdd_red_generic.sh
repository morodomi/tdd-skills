#!/usr/bin/env bash
# test_tdd_red_generic.sh

echo "TC-04: tdd-red Skill 汎用化のテスト"

FILE="templates/generic/.claude/skills/tdd-red/SKILL.md"

if [ ! -f "$FILE" ]; then
  echo "✗ ファイルが存在しません: $FILE"
  exit 1
fi

PASS=0
FAIL=0

# Laravel/PHPUnit固有の単語を検索（存在してはいけない）
SPECIFIC_WORDS=(
  "RefreshDatabase"
  "DatabaseTransactions"
  "#\[Test\]"
  "PHPUnit"
  "Illuminate\\\\"
  "use.*Framework.*TestCase"
)

echo "=== Laravel/PHPUnit固有の記述チェック ==="
for word in "${SPECIFIC_WORDS[@]}"; do
  if grep -E "$word" "$FILE" > /dev/null 2>&1; then
    echo "✗ 固有の単語が見つかりました: $word"
    FAIL=$((FAIL + 1))
  else
    echo "✓ $word は見つかりませんでした"
    PASS=$((PASS + 1))
  fi
done

# 汎用的な要素の存在確認
GENERIC_ELEMENTS=(
  "テストファースト"
  "RED"
  "失敗するテスト"
  "Arrange/Act/Assert"
  "Given/When/Then"
  "\[your test framework\]"
  "カスタマイズ"
)

echo ""
echo "=== 汎用的な要素の存在チェック ==="
for element in "${GENERIC_ELEMENTS[@]}"; do
  if grep -q "$element" "$FILE"; then
    echo "✓ 汎用的な要素が含まれています: $element"
    PASS=$((PASS + 1))
  else
    echo "✗ 汎用的な要素が見つかりません: $element"
    FAIL=$((FAIL + 1))
  fi
done

echo ""
echo "結果: $PASS passed, $FAIL failed"

if [ $FAIL -eq 0 ]; then
  echo "✓ TC-04: PASS"
  exit 0
else
  echo "✗ TC-04: FAIL"
  exit 1
fi
