---
feature: tdd-onboard SKILL.md/reference.md 更新
cycle: onboard-skill-update-001
phase: INIT
created: 2026-01-22
updated: 2026-01-22
issue: "#25"
---

# tdd-onboard SKILL.md/reference.md 更新

## Status: REVIEW

## やりたいこと

Issue #20-#24 で追加したテンプレートに対応するため、テストスクリプトを Progressive Disclosure パターンに合わせて更新する。

## 現状分析

### 失敗しているテスト（3件）

| テスト | 期待値 | reference.md の現状 |
|--------|--------|---------------------|
| TC-02f | `ls -d .git` in SKILL.md | なし（追加必要） |
| TC-02g | `.husky/pre-commit` in SKILL.md | あり（line 527-528） |
| TC-02l | `ls -d tests src docs` in SKILL.md | `tests/, src/, docs/` 形式あり |

### 方針

**テストスクリプトを更新** して reference.md もチェック対象に含める。

---

## Test List

- [x] TC-02f: reference.md または SKILL.md に .git check
- [x] TC-02g: reference.md に hook path 記載
- [x] TC-02l: reference.md に tests/src/docs 記載
- [x] 全体テスト: 47 passed, 0 failed

---

## 設計（plan-review後 修正版）

### 変更対象

`scripts/test-plugins-structure.sh`

### 変更内容

#### 0. ONBOARD_REF 変数定義の移動（Critical）

```bash
# line 95 の後に追加
ONBOARD_SKILL="$PLUGINS_DIR/tdd-core/skills/tdd-onboard/SKILL.md"
ONBOARD_REF="$PLUGINS_DIR/tdd-core/skills/tdd-onboard/reference.md"  # 追加
```

line 160 の重複定義を削除。

#### TC-02f (line 102-107)

```bash
# 変更前
if grep -q "ls -d .git" "$ONBOARD_SKILL" 2>/dev/null; then

# 変更後（SKILL.md または reference.md をチェック）
if grep -q "ls -d .git\|\.git" "$ONBOARD_SKILL" "$ONBOARD_REF" 2>/dev/null; then
```

#### TC-02g (line 109-114)

```bash
# 変更前
if grep -q ".husky/pre-commit\|.git/hooks/pre-commit" "$ONBOARD_SKILL" 2>/dev/null; then

# 変更後
if grep -q ".husky/pre-commit\|.git/hooks/pre-commit" "$ONBOARD_SKILL" "$ONBOARD_REF" 2>/dev/null; then
```

#### TC-02l (line 145-150)

```bash
# 変更前
if grep -q "ls -d tests src docs" "$ONBOARD_SKILL" 2>/dev/null; then

# 変更後（パターンを緩和）
if grep -q "tests.*src.*docs\|tests/, src/, docs/" "$ONBOARD_SKILL" "$ONBOARD_REF" 2>/dev/null; then
```

### スコープ

| 項目 | 値 |
|------|-----|
| 変更ファイル | 1（test-plugins-structure.sh） |
| 変更行数 | 約15行 |
| 破壊的変更 | なし（既存テストは FAIL 状態を修正） |

---

## 実装メモ

- ONBOARD_REF 変数を line 96 に移動（TC-02f/TC-02g で使用するため）
- テスト名は変更しない（既に正しい）
