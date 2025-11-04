#!/usr/bin/env bash
# test_plan_template_generic.sh

echo "TC-09: PLAN.md.template 汎用化のテスト"

FILE="templates/generic/.claude/skills/tdd-plan/templates/PLAN.md.template"

if [ ! -f "$FILE" ]; then
  echo "✗ ファイルが存在しません: $FILE"
  exit 1
fi

PASS=0
FAIL=0

# Laravel固有のセクションを検索（存在してはいけない）
LARAVEL_SECTIONS=(
  "データモデル"
  "マイグレーション"
  "Eloquent"
)

echo "=== Laravel固有のセクションチェック ==="
for section in "${LARAVEL_SECTIONS[@]}"; do
  if grep -q "$section" "$FILE"; then
    echo "✗ Laravel固有のセクションが見つかりました: $section"
    FAIL=$((FAIL + 1))
  else
    echo "✓ $section は見つかりませんでした"
    PASS=$((PASS + 1))
  fi
done

# 汎用的なセクションの存在確認
GENERIC_SECTIONS=(
  "ユーザーストーリー"
  "受け入れ基準"
  "Given"
  "When"
  "Then"
  "テストケース"
)

echo ""
echo "=== 汎用的なセクションの存在チェック ==="
for section in "${GENERIC_SECTIONS[@]}"; do
  if grep -q "$section" "$FILE"; then
    echo "✓ 汎用的なセクションが含まれています: $section"
    PASS=$((PASS + 1))
  else
    echo "✗ 汎用的なセクションが見つかりません: $section"
    FAIL=$((FAIL + 1))
  fi
done

echo ""
echo "結果: $PASS passed, $FAIL failed"

if [ $FAIL -eq 0 ]; then
  echo "✓ TC-09: PASS"
  exit 0
else
  echo "✗ TC-09: FAIL"
  exit 1
fi
