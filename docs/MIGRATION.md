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

---

## Manual Migration

### Step 1: 新ディレクトリ作成

```bash
mkdir -p .claude/{rules,hooks}
```

### Step 2: ファイル移動/リネーム

| v1.x (Before) | v2.0 (After) |
|---------------|--------------|
| `agent_docs/tdd_workflow.md` | `.claude/rules/tdd-workflow.md` |
| `agent_docs/testing_guide.md` | `.claude/rules/testing-guide.md` |
| `agent_docs/quality_standards.md` | `.claude/rules/quality.md` |
| `agent_docs/commands.md` | `.claude/rules/commands.md` |

```bash
# 例: ファイル移動
mv agent_docs/tdd_workflow.md .claude/rules/tdd-workflow.md
mv agent_docs/testing_guide.md .claude/rules/testing-guide.md
mv agent_docs/quality_standards.md .claude/rules/quality.md
mv agent_docs/commands.md .claude/rules/commands.md
```

### Step 3: 新規ファイル追加

v2.0 で追加された新しいテンプレートをコピー:

| ファイル | 説明 |
|---------|------|
| `.claude/rules/security.md` | セキュリティチェックリスト |
| `.claude/rules/git-safety.md` | Git安全規則 |
| `.claude/rules/git-conventions.md` | Git規約 |
| `.claude/hooks/recommended.md` | 推奨Hooks設定 |

テンプレートは `tdd-onboard` の reference.md から取得できます。

### Step 4: CLAUDE.md 更新

CLAUDE.md に Configuration セクションを追加:

```markdown
## Claude Code Configuration

| ディレクトリ | 内容 |
|-------------|------|
| .claude/rules/ | 常時適用ルール |
| .claude/hooks/ | 推奨Hooks設定 |
```

### Step 5: 旧ディレクトリ削除

```bash
rm -rf agent_docs/
```

---

## Alternative: tdd-onboard 再実行

手動マイグレーションの代わりに、`tdd-onboard` を再実行することで自動的に新構造を生成できます。

```bash
claude

> TDDセットアップ
# または「onboard」
```

**注意**: 既存の CLAUDE.md がある場合、マージ方法を確認されます。

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
