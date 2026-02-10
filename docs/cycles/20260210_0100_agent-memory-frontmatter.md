---
feature: agent-memory
cycle: agent-memory-frontmatter
phase: DONE
created: 2026-02-10 01:00
updated: 2026-02-10 01:00
---

# Agent Memory Frontmatter

## Scope Definition

### In Scope
- [ ] 6エージェントに `memory: project` frontmatter を追加
- [ ] 各エージェントの本文にエージェント別 memory 指示を追加
- [ ] テストスクリプトが memory frontmatter を許容することを確認

### Out of Scope
- memory クリーンアップ機構 (Reason: 手動 `rm -rf` で十分。必要になったら別 issue)
- ワーカーエージェント (red-worker, green-worker, refactorer) への memory 追加 (Reason: 毎回クリーンな状態が望ましい)
- scope-reviewer への memory 追加 (Reason: スコープはサイクルごとに異なるため蓄積不要)
- Rules での memory 使用規約 (Reason: エージェント本文の指示で十分)

### Files to Change (target: 10 or less)
- plugins/tdd-core/agents/security-reviewer.md (edit)
- plugins/tdd-core/agents/performance-reviewer.md (edit)
- plugins/tdd-core/agents/correctness-reviewer.md (edit)
- plugins/tdd-core/agents/guidelines-reviewer.md (edit)
- plugins/tdd-core/agents/socrates.md (edit)
- plugins/tdd-core/agents/architect.md (edit)
- scripts/test-plugins-structure.sh (edit - memory frontmatter 対応が必要な場合)

## Environment

### Scope
- Layer: N/A (Plugin configuration)
- Plugin: tdd-core
- Risk: 35 (WARN)

### Runtime
- Claude Code: 2.1.37
- Agent Teams: enabled

### Dependencies (key packages)
- Claude Code memory frontmatter: v2.1.33+

## Context & Dependencies

### Reference Documents
- [Claude Code Sub-agents Docs](https://code.claude.com/docs/en/sub-agents) - memory frontmatter 仕様
- [GitHub Issue #24130](https://github.com/anthropics/claude-code/issues/24130) - 並列書き込み問題 (エージェント名が異なるため影響なし)

### Dependent Features
- Agent Teams mode (CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1)

### Related Issues/PRs
- Issue #65: P3: Memory フロントマター活用

## Test List

### TODO
(none)

### WIP
(none)

### DISCOVERED
(none)

### DONE
- [x] TC-01: memory frontmatter 追加後も既存 Plugin 構造テストが全て通る (bash scripts/test-plugins-structure.sh)
- [x] TC-02: security-reviewer.md に `memory: project` が存在する
- [x] TC-03: performance-reviewer.md に `memory: project` が存在する
- [x] TC-04: correctness-reviewer.md に `memory: project` が存在する
- [x] TC-05: guidelines-reviewer.md に `memory: project` が存在する
- [x] TC-06: socrates.md に `memory: project` が存在する
- [x] TC-07: architect.md に `memory: project` が存在する
- [x] TC-08: 対象6エージェントの本文に "Memory" セクションまたは memory 使用指示が含まれる
- [x] TC-09: red-worker.md に memory frontmatter がない
- [x] TC-10: green-worker.md に memory frontmatter がない
- [x] TC-11: refactorer.md に memory frontmatter がない
- [x] TC-12: scope-reviewer.md に memory frontmatter がない

## Implementation Notes

### Goal
6エージェント (security/performance/correctness/guidelines-reviewer + socrates + architect) に `memory: project` を追加し、エージェント別の memory 使用指示をカスタマイズする。プロジェクト固有のドメイン知識を蓄積し、セッション跨ぎでレビュー精度を向上させる。

### Background
- Claude Code v2.1.33 で memory frontmatter が追加
- `memory: project` は `.claude/agent-memory/<name>/` に保存、Git 共有可能
- MEMORY.md 先頭200行がシステムプロンプトに自動注入
- Read/Write/Edit ツールが自動有効化

### Design Approach

#### 変更パターン

各エージェントの `.md` ファイルに対して2つの変更を行う:

1. **frontmatter に `memory: project` を追加**
2. **本文末尾に Memory セクションを追加**（エージェント別カスタマイズ）

#### エージェント別 Memory 指示

| エージェント | 記憶対象 |
|-------------|---------|
| security-reviewer | 脆弱性パターン（SQLi, XSS, 認証不備等）の出現傾向、プロジェクト固有のセキュリティ要件 |
| performance-reviewer | N+1問題の発生箇所、ボトルネックパターン、プロジェクトのパフォーマンス特性 |
| correctness-reviewer | 頻出するロジックエラーのパターン、プロジェクト固有のエッジケース |
| guidelines-reviewer | プロジェクト固有のコーディング規約、命名慣習、ドキュメント方針 |
| socrates | 過去の判断提案とその結果（proceed/fix/abort の実績）、効果的だった反論パターン |
| architect | プロジェクトのアーキテクチャ判断履歴、設計パターンの採用実績 |

#### Memory セクションのテンプレート

```markdown
## Memory

レビューで発見した[エージェント固有の観点]のパターンを agent memory に記録せよ。
記録対象: プロジェクト固有の傾向、繰り返し発見される問題、コードベースの特徴。
記録しないもの: 一般的な知識、個別のバグ修正詳細。
```

#### テストスクリプトへの影響

`scripts/test-plugins-structure.sh` は agent の frontmatter 内容を検証していない（ファイル存在チェックのみ）。memory 追加で既存テストは壊れない。新規テストケースを追加して memory の存在を検証する。

## Progress Log

### 2026-02-10 01:00 - INIT
- Cycle doc created
- Scope definition ready
- memory frontmatter 仕様調査完了
- Socratic Review 結果を反映: 確証バイアス対策としてエージェント別カスタマイズ、Rules 不要

### 2026-02-10 01:30 - PLAN
- plan-review WARN (score 72): product-reviewer「効果測定方法未定義・PoC推奨」、usability-reviewer「制御手段・破損時フォールバック未定義」
- 判断: 既検討済み指摘のため REDへ進行。変更パターンが統一的で6エージェント一括が効率的

### 2026-02-10 02:00 - RED/GREEN/REVIEW
- RED: 7テスト失敗、138テスト通過
- GREEN: 145テスト通過、0失敗
- quality-gate PASS (score 45): 全6エージェント PASS

---

## Next Steps

1. [Done] INIT
2. [Done] PLAN
3. [Done] RED
4. [Done] GREEN
5. [Done] REFACTOR (skip - no refactoring needed)
6. [Done] REVIEW (quality-gate PASS, score 45)
7. [ ] COMMIT <- Current
