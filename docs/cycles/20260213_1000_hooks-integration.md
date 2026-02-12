---
feature: hooks-integration
cycle: hooks-integration
phase: DONE
created: 2026-02-13 10:00
updated: 2026-02-13 10:00
---

# Hooks Integration

## Scope Definition

### In Scope
- [ ] scripts/check-debug-statements.sh: Stop hook用ヘルパースクリプト作成
- [ ] .claude/hooks/recommended.md: 新しいhook設定を追加 (PostToolUse, SessionStart, Stop拡充)
- [ ] tdd-init SKILL.md: Step 1にhooks設定チェック・案内を追加

### Out of Scope
- hooks.json のプラグイン自動マージ (Reason: Claude Code非対応)
- redteam-core のhooks (Reason: 別リポジトリ、別サイクルで対応)
- settings.json への自動書き込み (Reason: 過去サイクルで否定済み)
- scripts/check-scan-output.sh (Reason: redteam-core スコープ)

### Files to Change (target: 10 or less)
- scripts/check-debug-statements.sh (new)
- .claude/hooks/recommended.md (edit)
- plugins/tdd-core/skills/tdd-init/SKILL.md (edit)
- plugins/tdd-core/skills/tdd-init/reference.md (edit)
- scripts/test-plugins-structure.sh (edit - テスト追加)

## Environment

### Scope
- Layer: N/A (Plugin configuration + Bash scripts)
- Plugin: tdd-core
- Risk: 10 (PASS)

### Runtime
- Claude Code: 2.1.39
- Bash: 3.2.57

### Dependencies (key packages)
- Claude Code Hooks: PreToolUse, PostToolUse, SessionStart, Stop

## Context & Dependencies

### Reference Documents
- docs/20260212_hooks_integration.md - 設計ドキュメント
- docs/cycles/20260210_0200_recommended-hooks-onboard.md - 前回のhooksサイクル (DONE)
- .claude/hooks/recommended.md - 現在の推奨hooks

### Dependent Features
- tdd-init スキル
- tdd-onboard スキル (recommended.md参照)

### Related Issues/PRs
- (none)

## Test List

### TODO
(none)

### WIP
(none)

### DISCOVERED
(none)

### DONE
- [x] TC-01: scripts/check-debug-statements.sh が存在し実行可能
- [x] TC-02: check-debug-statements.sh がdebug文のないファイルで exit 0 を返す
- [x] TC-03: check-debug-statements.sh がconsole.logを含むファイルで exit 1 + メッセージを返す
- [x] TC-04: check-debug-statements.sh がvar_dumpを含むファイルで exit 1 を返す
- [x] TC-05: recommended.md にPostToolUse hookが記載されている
- [x] TC-06: recommended.md にSessionStart hookが記載されている
- [x] TC-07: recommended.md にStop hookのgit status警告が記載されている
- [x] TC-08: recommended.md にcheck-debug-statements.shへの参照がある
- [x] TC-09: tdd-init SKILL.md/reference.md にhooksチェックが含まれる
- [x] TC-10: tdd-init SKILL.md が100行以下
- [x] TC-11: test-plugins-structure.sh が通る (既存テスト + 新規テスト)

## Implementation Notes

### Goal
Claude Code Hooks を活用し、TDDワークフローの自動品質チェックを実現する。プラグインhooks.json非対応のため、recommended.md拡充 + ヘルパースクリプト + tdd-initでの案内で対応。

### Background
docs/20260212_hooks_integration.md の設計に基づく。プラグインhooks.jsonの自動マージは非対応のため、recommended.mdでの案内パターンを踏襲。

### Design Approach

#### 1. scripts/check-debug-statements.sh (new)

Git diff で変更ファイルを取得し、debug文を検出するスクリプト。

検出対象:
- JS/TS: `console.log`, `console.debug`, `debugger`
- Python: `print(`, `breakpoint()`, `pdb.set_trace()`
- PHP: `var_dump(`, `dd(`, `dump(`

動作:
- `git diff --cached --name-only` で変更ファイル取得
- 変更ファイルがなければ `git diff --name-only` にフォールバック
- 検出あり → stderr にメッセージ + exit 1
- 検出なし → exit 0

#### 2. .claude/hooks/recommended.md (edit)

現在の hooks:
- PreToolUse: `--no-verify` ブロック, `rm -rf` ブロック
- Stop: テストリマインダー

追加する hooks:
- **SessionStart**: `CLAUDE.md` 存在確認 (なければ `tdd-onboard` 推奨)
- **PostToolUse** (Write matcher): テストファイル更新検出 → リマインダー
- **Stop**: `git status` で未コミット変更警告 + `check-debug-statements.sh` 実行

#### 3. tdd-init SKILL.md (edit - 行数制約: 100行以下)

Step 1 の既存行に hooks チェックリンクを1行追加。
詳細は reference.md に委譲。

変更: Step 1 セクション末尾に `Also check hooks: [reference.md](reference.md#hooks-check)` を追加。
ただし100行制約のため、他の冗長な行を1行削減して対応。

#### 4. tdd-init reference.md (edit)

`## Hooks Check` セクションを追加:
- `~/.claude/settings.json` の hooks キー存在確認
- 未設定なら `.claude/hooks/recommended.md` を案内
- AskUserQuestion テンプレート

#### 5. scripts/test-plugins-structure.sh (edit)

新テスト追加:
- TC-HI-01: check-debug-statements.sh が存在し実行可能
- TC-HI-02: recommended.md に SessionStart hook が記載
- TC-HI-03: recommended.md に PostToolUse hook が記載
- TC-HI-04: recommended.md に Stop hook の git status 警告が記載
- TC-HI-05: tdd-init SKILL.md に hooks チェックリンクが含まれる

## Progress Log

### 2026-02-13 10:00 - INIT
- Cycle doc created
- 設計ドキュメントのhooks.json自動マージ前提を否定、代替アプローチ採用
- Risk 10 (PASS)

---

## Next Steps

1. [Done] INIT
2. [Done] PLAN
3. [Done] RED
4. [Done] GREEN
5. [Done] REFACTOR (skip)
6. [Done] REVIEW (quality-gate PASS)
7. [Done] COMMIT
