# Migration Guide: v1.x → v2.0

## Breaking Changes

v2.0 では `agent_docs/` ディレクトリが `.claude/` 構造に変更されました。

| v1.x | v2.0 |
|------|------|
| `agent_docs/` | `.claude/rules/`, `.claude/hooks/` |

### 変更の理由

- [everything-claude-code](https://github.com/anthropics/everything-claude-code) 互換
- Rules と Hooks の明確な分離
- Claude Code 公式推奨構造への準拠

### v2.0 ファイル構造

```
.claude/
├── rules/
│   ├── git-safety.md      # Git安全規則
│   ├── security.md        # セキュリティチェックリスト
│   └── git-conventions.md # Git規約
└── hooks/
    └── recommended.md     # 推奨Hooks設定
```

---

## Recommended: tdd-onboard 実行

最も簡単なマイグレーション方法は `tdd-onboard` を実行することです。

```bash
claude

> TDDセットアップ
# または「onboard」
```

`tdd-onboard` は以下を自動実行します:
1. `.claude/rules/` と `.claude/hooks/` を作成
2. 必要なルールファイルを生成
3. CLAUDE.md を更新（既存があればマージ確認）

**注意**: 既存の CLAUDE.md がある場合、マージ方法を確認されます。

---

## Manual Migration

手動でマイグレーションする場合:

### Step 1: 新ディレクトリ作成

```bash
mkdir -p .claude/{rules,hooks}
```

### Step 2: ルールファイル作成

以下の3ファイルを `.claude/rules/` に作成:

| ファイル | 説明 |
|---------|------|
| `git-safety.md` | Git安全規則（--no-verify禁止等） |
| `security.md` | セキュリティチェックリスト |
| `git-conventions.md` | コミットメッセージ規約 |

テンプレートは `tdd-onboard` の [reference.md](https://github.com/morodomi/tdd-skills/blob/main/plugins/tdd-core/skills/tdd-onboard/reference.md) を参照。

### Step 3: Hooks設定

`.claude/hooks/recommended.md` を作成（任意）。

### Step 4: CLAUDE.md 更新

CLAUDE.md に Configuration セクションを追加:

```markdown
## Claude Code Configuration

| ディレクトリ | 内容 |
|-------------|------|
| .claude/rules/ | 常時適用ルール |
| .claude/hooks/ | 推奨Hooks設定 |

### Rules

- git-safety.md - Git安全規則
- security.md - セキュリティチェック
- git-conventions.md - Git規約
```

### Step 5: 旧ディレクトリ削除

```bash
rm -rf agent_docs/
```

---

## Verification

マイグレーション後、以下を確認:

```bash
# 構造確認
ls -la .claude/rules/
ls -la .claude/hooks/

# 旧ディレクトリが削除されていること
ls agent_docs/ 2>/dev/null && echo "Warning: agent_docs still exists" || echo "OK"
```

---

## Support

問題が発生した場合:

1. [GitHub Issues](https://github.com/morodomi/tdd-skills/issues) で報告
2. `tdd-onboard` を再実行して構造を再生成
