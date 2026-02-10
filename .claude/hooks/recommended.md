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
```

## 使い方

1. 上記をコピー
2. ~/.claude/settings.json に追加
3. Claude Code再起動

## 注意

- exit 2: ブロック（Claudeにフィードバック）
- exit 0: 許可
- TOOL_INPUT: JSON形式で渡される
