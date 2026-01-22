# hooks/recommended.md テンプレート作成

## Status: DONE

## INIT

### Scope Definition

tdd-onboard が生成する `.claude/hooks/recommended.md` テンプレートを作成する。

Issue: #23
親Issue: #19

### Target

```
.claude/
└── hooks/
    └── recommended.md  # 新規追加
```

### Tasks

- [ ] reference.md に recommended.md テンプレート追加
- [ ] SKILL.md に hooks/ 生成ステップ追加
- [ ] テンプレート内容: PreToolUse/PostToolUse/Stop Hooks設定

### Out of Scope

- Hooks自動登録機能（将来検討）
- settings.json への自動書き込み

### Environment

#### Scope
- Layer: tdd-core プラグイン
- Plugin: tdd-core/skills/tdd-onboard

#### Runtime
- Claude Code Plugins

### Dependencies

- #20 完了済み（.claude/rules/ 構造への変更）
- #22 完了済み（security.md テンプレート）

## PLAN

### 設計方針

Issue #23 の内容を hooks/recommended.md テンプレートとして追加。
SKILL.md の行数制限（100行）を考慮し、Step 6 を拡張して hooks/ を含める。

### 変更ファイル

| ファイル | 変更内容 |
|----------|----------|
| tdd-onboard/SKILL.md | Step 6 に hooks/ を追加、Progress Checklist 更新 |
| tdd-onboard/reference.md | hooks/recommended.md テンプレート追加 |

### SKILL.md 変更箇所

1. Progress Checklist (21行目):
   - 変更前: `- [ ] .claude/rules/ 生成`
   - 変更後: `- [ ] .claude/ 構造生成（rules/, hooks/）`

2. Step 6 (71-83行目):
   - タイトル: `.claude/rules/ 生成` → `.claude/ 構造生成`
   - ツリーに hooks/ を追加

### hooks/recommended.md テンプレート（公式仕様準拠）

```markdown
# Recommended Hooks

~/.claude/settings.json に追加:

\`\`\`json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "if echo \"$TOOL_INPUT\" | grep -qF '\\-\\-no-verify'; then echo 'BLOCK: --no-verify is prohibited' >&2; exit 2; fi"
          }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "echo 'Session ended: Remember to run tests'"
          }
        ]
      }
    ]
  }
}
\`\`\`

## 使い方

1. 上記をコピー
2. ~/.claude/settings.json に追加
3. Claude Code再起動

## 注意

- exit 2: ブロック（Claudeにフィードバック）
- exit 0: 許可
- TOOL_INPUT: JSON形式で渡される
```

### 制約

- SKILL.md は100行以下を維持（現在99行）
- hooks/ は settings.json への自動書き込みは行わない（ユーザーに案内のみ）

## Test List

### TODO

（なし）

### WIP

（なし）

### DONE

- [x] TC-01: Progress Checklist に `hooks/` の記述がある
- [x] TC-02: Step 6 に `hooks/` ディレクトリが含まれている
- [x] TC-03: reference.md に recommended.md テンプレートがある
- [x] TC-04: SKILL.md が99行（100行以下）
- [x] TC-05: テンプレートに `"type": "command"` がある
- [x] TC-06: テンプレートにネストされた `"hooks"` 配列がある

## Notes

- everything-claude-code 互換構造
- 親Issue #19 の子タスク
- hooks/ は rules/ とは別ディレクトリ
