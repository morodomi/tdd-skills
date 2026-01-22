# 構造変更 agent_docs → .claude

## Status: DONE

## INIT

### Scope Definition

tdd-onboard が生成するディレクトリ構造を `agent_docs/` から `.claude/{rules,skills,hooks}` に変更する。

Issue: #20
親Issue: #19

### Target Structure

```
# Before
agent_docs/
├── tdd_workflow.md
├── testing_guide.md
├── quality_standards.md
└── commands.md

# After
.claude/
├── rules/
│   ├── tdd-workflow.md
│   └── quality.md
├── skills/
│   ├── testing-guide.md
│   └── commands.md
└── hooks/
    └── (別issueで追加)
```

### Tasks

- [ ] SKILL.md Step 6 修正
- [ ] reference.md テンプレート修正
- [ ] ファイル名のケバブケース統一（tdd_workflow → tdd-workflow）

### Out of Scope

- hooks/ 配下のファイル作成（#23で対応）
- rules/git-safety.md, rules/security.md 作成（#21, #22で対応）
- マイグレーション戦略（#26で対応）

### Environment

#### Scope
- Layer: tdd-core プラグイン
- Plugin: tdd-core/skills/tdd-onboard

#### Runtime
- Claude Code Plugins

## PLAN

### 設計方針

`agent_docs/` を `.claude/rules/` 構造に変更。
everything-claude-code 互換を目指す。

**決定事項:**
- skills/ は使用しない（公式仕様に準拠したskillを配置する場合のみ使用）
- 4ファイルとも rules/ に統合
- agent_docs/ を参照している他スキルも同時修正

### 変更ファイル

| ファイル | 変更内容 |
|----------|----------|
| tdd-onboard/SKILL.md | Step 6: `agent_docs/` → `.claude/rules/` に変更 |
| tdd-onboard/reference.md | テンプレート全面更新 |
| tdd-red/SKILL.md | agent_docs/ 参照を .claude/rules/ に変更 |
| tdd-commit/SKILL.md | agent_docs/ 参照を .claude/rules/ に変更 |

### 新構造

```
.claude/
├── rules/
│   ├── tdd-workflow.md      # 旧: agent_docs/tdd_workflow.md
│   ├── quality.md           # 旧: agent_docs/quality_standards.md
│   ├── testing-guide.md     # 旧: agent_docs/testing_guide.md
│   └── commands.md          # 旧: agent_docs/commands.md
└── hooks/
    └── (別issue #23で追加)
```

### 命名規則

- スネークケース → ケバブケース
- 例: `tdd_workflow.md` → `tdd-workflow.md`

## Test List

### TODO

（なし）

### WIP

（なし）

### DONE

- [x] TC-01: tdd-onboard/SKILL.md Step 6 が `.claude/rules/` を参照している
- [x] TC-02: tdd-onboard/SKILL.md に `agent_docs` の記述がない
- [x] TC-03: tdd-onboard/reference.md に `.claude/rules/` テンプレートがある
- [x] TC-04: reference.md にファイル名がケバブケースで記載されている
- [x] TC-05: tdd-red/SKILL.md に `agent_docs` の記述がない
- [x] TC-06: tdd-commit/SKILL.md に `agent_docs` の記述がない
- [x] TC-07: tdd-onboard/SKILL.md が100行以下（98行）

## Notes

- everything-claude-code 互換構造への移行
- 親Issue #19 の子タスク
- #21-23 と並行作業可能
