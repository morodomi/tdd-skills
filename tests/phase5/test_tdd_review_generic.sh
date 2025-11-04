#!/usr/bin/env bash
# test_tdd_review_generic.sh

echo "TC-07: tdd-review Skill 汎用化のテスト"

FILE="templates/generic/.claude/skills/tdd-review/SKILL.md"

if [ ! -f "$FILE" ]; then
  echo "✗ ファイルが存在しません: $FILE"
  exit 1
fi

PASS=0
FAIL=0

# Laravel/PHP固有のツール名を検索
SPECIFIC_TOOLS=(
  "PHPStan"
  "Laravel Pint"
  "Pint"
  "vendor/bin/"
  "composer "
)

echo "=== Laravel/PHP固有のツールチェック ==="
for tool in "${SPECIFIC_TOOLS[@]}"; do
  if grep -q "$tool" "$FILE"; then
    echo "✗ 固有のツールが見つかりました: $tool"
    FAIL=$((FAIL + 1))
  else
    echo "✓ $tool は見つかりませんでした"
    PASS=$((PASS + 1))
  fi
done

# 汎用的な要素の存在確認
GENERIC_ELEMENTS=(
  "テストカバレッジ"
  "90%"
  "静的解析"
  "\[your static analysis tool\]"
  "\[your code formatter\]"
  "品質基準"
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
  echo "✓ TC-07: PASS"
  exit 0
else
  echo "✗ TC-07: FAIL"
  exit 1
fi
