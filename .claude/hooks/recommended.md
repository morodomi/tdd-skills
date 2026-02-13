# Recommended Hooks

~/.claude/settings.json に追加:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "if echo \"$TOOL_INPUT\" | grep -qF -- '--no-verify'; then echo 'BLOCK: --no-verify is prohibited' >&2; exit 2; fi"
          },
          {
            "type": "command",
            "command": "if echo \"$TOOL_INPUT\" | grep -qE 'rm\\s+-[a-zA-Z]*r[a-zA-Z]*f|rm\\s+-[a-zA-Z]*f[a-zA-Z]*r'; then echo 'BLOCK: rm -rf is prohibited. Delete specific files instead.' >&2; exit 2; fi"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "if echo \"$TOOL_INPUT\" | grep -qE 'test_|_test\\.|\\.test\\.|spec\\.'; then echo 'Note: Test file updated. Run tests to verify.'; fi"
          }
        ]
      }
    ],
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "if [ ! -f CLAUDE.md ]; then echo 'Warning: CLAUDE.md not found. Run tdd-onboard to set up.'; fi"
          }
        ]
      }
    ],
    "PreCompact": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "if [ -x scripts/save-tdd-state.sh ]; then scripts/save-tdd-state.sh; fi"
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
          },
          {
            "type": "command",
            "command": "if git status --porcelain 2>/dev/null | grep -q '^'; then echo 'Warning: Uncommitted changes detected. Run git status to review.'; fi"
          },
          {
            "type": "command",
            "command": "if [ -x scripts/check-debug-statements.sh ]; then scripts/check-debug-statements.sh; fi"
          }
        ]
      }
    ]
  }
}
```

## 使い方

1. 上記をコピー
2. ~/.claude/settings.json に追加
3. Claude Code再起動

## Hook一覧

| Hook | 用途 |
|------|------|
| PreToolUse (Bash) | `--no-verify` ブロック, `rm -rf` ブロック |
| PostToolUse (Write) | テストファイル更新検出 → リマインダー |
| SessionStart | CLAUDE.md 存在確認 → tdd-onboard 推奨 |
| PreCompact | save-tdd-state.sh 実行 → TDD状態をユーザーに通知 |
| Stop | テストリマインダー, git status 未コミット警告, check-debug-statements.sh 実行 |

## 注意

- exit 2: ブロック（Claudeにフィードバック）
- exit 0: 許可
- TOOL_INPUT: JSON形式で渡される
- check-debug-statements.sh はプロジェクトルートの scripts/ に配置
