---
feature: recommended-hooks
cycle: recommended-hooks-onboard
phase: DONE
created: 2026-02-10 02:00
updated: 2026-02-10 02:00
---

# Recommended Hooks Onboard

## Scope Definition

### In Scope
- [ ] recommended.md に `rm -rf` ブロック Hook を追加
- [ ] tdd-onboard Step 6 で settings.json への追加を明示的にユーザーに案内
- [ ] tdd-onboard reference.md の recommended.md テンプレートを更新

### Out of Scope
- settings.json への自動書き込み (Reason: #62 Socratic review で否定。押し付けNG)
- Strict/Standard/Minimal の3段階選択 (Reason: 過剰。2つの Hook で十分)
- アンインストール機構 (Reason: 手動で JSON 編集すれば十分)
- CI 環境での Hook 無効化 (Reason: Claude Code Hook は Claude Code セッション内のみ)

### Files to Change (target: 10 or less)
- .claude/hooks/recommended.md (edit)
- plugins/tdd-core/skills/tdd-onboard/SKILL.md (edit)
- plugins/tdd-core/skills/tdd-onboard/reference.md (edit)
- scripts/test-plugins-structure.sh (edit)

## Environment

### Scope
- Layer: N/A (Plugin configuration)
- Plugin: tdd-core
- Risk: 20 (PASS)

### Runtime
- Claude Code: 2.1.37
- Agent Teams: enabled

### Dependencies (key packages)
- Claude Code Hooks: v1.0+ (PreToolUse, Stop)

## Context & Dependencies

### Reference Documents
- #62 close comment: フェーズ注入不要、TaskCompleted テスト過剰、残スコープ #67 に統合
- #67 Socratic comments: 自動書き込みは押し付け、3段階は複雑すぎ

### Related Issues/PRs
- Issue #67: P5: recommended.md 拡充 + tdd-onboard での Hook 案内
- Issue #62 (closed): P0: Hooks による TDD フロー強制 → 残スコープ吸収

## Test List

### TODO
(none)

### WIP
(none)

### DISCOVERED
(none)

### DONE
- [x] TC-01: 既存 Plugin 構造テストが全て通る
- [x] TC-02: recommended.md に `rm -rf` ブロック Hook が記載されている
- [x] TC-03: recommended.md に `--no-verify` ブロック Hook が記載されている (既存維持)
- [x] TC-04: tdd-onboard SKILL.md Step 6 に settings.json への追加案内が含まれる
- [x] TC-05: tdd-onboard reference.md の recommended.md テンプレートに `rm -rf` が含まれる

## Implementation Notes

### Goal
recommended.md に `rm -rf` ブロックを追加し、tdd-onboard でユーザーに Hook 設定を明示的に案内する。

### Design Approach

#### 1. recommended.md の拡充

現状の Hook:
- PreToolUse: `--no-verify` ブロック
- Stop: テストリマインダー

追加する Hook:
- PreToolUse: `rm -rf` ブロック（ルートディレクトリやプロジェクトディレクトリの一括削除を防止）

```json
{
  "matcher": "Bash",
  "hooks": [
    {
      "type": "command",
      "command": "if echo \"$TOOL_INPUT\" | grep -qE 'rm\\s+-[a-zA-Z]*r[a-zA-Z]*f|rm\\s+-[a-zA-Z]*f[a-zA-Z]*r'; then echo 'BLOCK: rm -rf is prohibited. Delete specific files instead.' >&2; exit 2; fi"
    }
  ]
}
```

#### 2. tdd-onboard での案内

Step 6 完了後に AskUserQuestion で案内:
```
Hook設定を推奨します。
.claude/hooks/recommended.md に推奨設定が記載されています。
~/.claude/settings.json にコピーして Claude Code を再起動してください。
```

#### 3. reference.md テンプレート更新

recommended.md テンプレート内の hooks JSON に `rm -rf` ブロックを追加。

## Progress Log

### 2026-02-10 02:00 - INIT/PLAN
- Cycle doc created
- Socratic review 完了: スコープ2点に縮小
- PLAN ready

---

## Next Steps

1. [Done] INIT
2. [Done] PLAN
3. [Done] RED
4. [Done] GREEN
5. [Done] REFACTOR (skip)
6. [Done] REVIEW (Risk 20 PASS, quality-gate skip)
7. [ ] COMMIT <- Current
