# 企画: Hooks 活用によるワークフロー自動化

## 参考元

[affaan-m/everything-claude-code](https://github.com/affaan-m/everything-claude-code) の `hooks/hooks.json`

## 概要

Claude Code の Hooks 機構を活用し、セッションライフサイクル全体で自動品質チェック・コンテキスト管理を行う。

参考元の hooks.json では以下を実装:

| Hook | 用途 |
|------|------|
| PreToolUse | tmux 外 dev サーバーブロック、不要 .md 作成防止 |
| PostToolUse | PR URL 記録、auto-format、console.log 検出 |
| PreCompact | compaction 前に状態保存 |
| SessionStart | 前回コンテキスト復元、パッケージマネージャ検出 |
| SessionEnd | 状態永続化、パターン抽出評価 |
| Stop | 変更ファイルの console.log 残留チェック |

## 現状との比較

| 観点 | 現状 | 参考元 |
|------|------|--------|
| フック活用 | .claude/hooks/ に recommended.md のみ（ドキュメント） | 実際の hooks.json 稼働 |
| セッション管理 | なし | Start/End でコンテキスト永続化 |
| 自動品質チェック | skill 実行時のみ | PostToolUse で常時 |
| フォーマット | skill 内で手動 | PostToolUse で自動 |

## 実装方針

**既存プラグインに統合**: tdd-core / redteam-core それぞれに hooks 設定を追加

### 理由

- hooks.json はプラグインごとにマージされる仕組み
- TDD と Security で必要なフックが異なる
- 独立プラグインにするほどの規模ではない

### tdd-core に追加するフック

```json
{
  "PostToolUse": [
    {
      "matcher": { "tool_name": "Write" },
      "hooks": [{
        "type": "command",
        "command": "echo 'check: test file updated'"
      }]
    }
  ],
  "Stop": [
    {
      "hooks": [{
        "type": "command",
        "command": "scripts/check-debug-statements.sh"
      }]
    }
  ]
}
```

### redteam-core に追加するフック

```json
{
  "PostToolUse": [
    {
      "matcher": { "tool_name": "Bash" },
      "hooks": [{
        "type": "command",
        "command": "scripts/check-scan-output.sh"
      }]
    }
  ]
}
```

### 共通フック（どちらにも）

- SessionStart: プロジェクト CLAUDE.md の存在確認
- Stop: git status で未コミット変更を警告

## 検討事項

- フックの実行時間がワークフローをブロックしないか（非同期実行の考慮）
- プラグイン間のフック競合・実行順序
- ユーザーが既に設定しているフックとの共存
- hooks.json のテスト方法

## 優先度

高。フックは既存のプラグインアーキテクチャに自然に統合でき、実装コストが低い割に効果が大きい。
