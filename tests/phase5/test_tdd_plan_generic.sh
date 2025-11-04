#!/usr/bin/env bash
# test_tdd_plan_generic.sh

echo "TC-03: tdd-plan Skill 汎用化のテスト"

FILE="templates/generic/.claude/skills/tdd-plan/SKILL.md"

if [ ! -f "$FILE" ]; then
  echo "✗ ファイルが存在しません: $FILE"
  exit 1
fi

PASS=0
FAIL=0

# Laravel固有の単語を検索（存在してはいけない）
LARAVEL_WORDS=(
  "Laravel"
  "Eloquent"
  "マイグレーション"
  "PHPUnit"
  "tests/Feature/"
  "tests/Unit/"
)

echo "=== Laravel固有の記述チェック ==="
for word in "${LARAVEL_WORDS[@]}"; do
  if grep -q "$word" "$FILE"; then
    echo "✗ Laravel固有の単語が見つかりました: $word"
    FAIL=$((FAIL + 1))
  else
    echo "✓ $word は見つかりませんでした"
    PASS=$((PASS + 1))
  fi
done

# 汎用的な要素の存在確認
GENERIC_ELEMENTS=(
  "Given/When/Then"
  "ユーザーストーリー"
  "As a"
  "I want to"
  "So that"
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
  echo "✓ TC-03: PASS"
  exit 0
else
  echo "✗ TC-03: FAIL"
  exit 1
fi
