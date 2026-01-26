---
feature: tdd-core
cycle: 20260126_1003
phase: DONE
created: 2026-01-26 10:03
updated: 2026-01-26 10:03
---

# v3.3: GREEN Parallelization

## Scope Definition

### In Scope
- [ ] tdd-green スキルを並列実行デフォルトに変更
- [ ] green-worker エージェントを新規作成
- [ ] tdd-red から「1つずつ」制約を削除
- [ ] CLAUDE.md / README.md に TDD Philosophy を追加
- [ ] コンテキスト共有・競合解決の仕組み

### Out of Scope
- RED並列化（v4.0で検討）
- 他フェーズへの影響
- 既存のシーケンシャル実行の削除（並列はオプション）

### Files to Change (target: 10 or less)
- `plugins/tdd-core/skills/tdd-green/SKILL.md`（編集）
- `plugins/tdd-core/skills/tdd-green/reference.md`（編集）
- `plugins/tdd-core/agents/green-worker.md`（新規）
- `plugins/tdd-core/skills/tdd-red/SKILL.md`（編集）- 「1つずつ」制約削除
- `CLAUDE.md`（編集）- TDD Philosophy追加
- `README.md`（編集）- TDD Philosophy追加

## Environment

### Scope
- Layer: Plugin（Claude Code Skills + Agents）
- Plugin: tdd-core
- Risk: 80 (BLOCK) - アーキテクチャ変更

### Runtime
- Claude Code Plugin: Markdown + Task tool

### Dependencies (key packages)
- Task tool（並列エージェント起動）
- Issue #35: v3.3 GREEN並列化

### Risk Interview

**Brainstorm:**
- Problem: 開発速度の向上（GREENフェーズの実装時間短縮）
- Alternatives: 並列化が最善と判断済み

**Architecture Risk:**
- コンテキスト共有: Cycle docから設計情報を抽出
- 競合解決: ファイル単位でエージェント分担
- ロールバック: 並列実行失敗時は該当workerのみ再試行

**plan-review対応 (WARN: 75):**
1. TDD原則違反 → チケット単位R-G-Rに設計変更、CLAUDE.md/README.mdに明記
2. ファイル依存関係 → ファイル単位分担で対応
3. reference.ja.md不在 → スコープから除外（既存パターンに合わせる）

## Context & Dependencies

### Reference Documents
- README.md Roadmap section
- 前回サイクル: 20260126_0940_question-driven-warn.md
- quality-gate/SKILL.md（並列エージェント実行の参考）

### Related Issues/PRs
- Issue #35: v3.3: GREEN並列化 (並列エージェントによる実装)

## Test List

### TODO
(none)

### WIP
(none)

### DISCOVERED
(none)

### DONE
- [x] TC-01: tdd-green/SKILL.md に並列実行ワークフローがある
- [x] TC-02: tdd-green/SKILL.md に "green-worker" への言及がある
- [x] TC-03: tdd-green/SKILL.md に "ファイル依存関係分析" の説明がある
- [x] TC-04: agents/green-worker.md が存在する
- [x] TC-05: green-worker.md に入力仕様がある
- [x] TC-06: green-worker.md に出力形式の定義がある
- [x] TC-07: tdd-green/reference.md に並列実行の詳細がある
- [x] TC-08: tdd-green/reference.md に競合解決戦略がある
- [x] TC-09: tdd-red/SKILL.md から「1つずつ」制約が削除されている
- [x] TC-10: CLAUDE.md に TDD Philosophy セクションがある
- [x] TC-11: README.md に TDD Philosophy セクションがある
- [x] TC-12: tdd-green/SKILL.md が100行以下

## Implementation Notes

### Goal
Test Listの各テストを並列エージェントで実装し、GREENフェーズを高速化する。

### Background
- v3.0.0: 基本TDDワークフロー
- v3.1.0: Brainstorm質問追加
- v3.2.0: WARN質問追加
- v3.3.0: GREEN並列化（今回）

### Design Approach

**設計思想**: チケット（Cycle）単位でRED→GREEN→REFACTOR
- 従来TDD: 1テストずつRED→GREEN→REFACTOR
- tdd-skills: Test List全体でRED → 並列GREEN → REFACTOR

**アーキテクチャ**:
```
tdd-green（並列実行がデフォルト）
├─ Step 1: Cycle doc確認、WIPテスト抽出
├─ Step 2: ファイル依存関係分析（同一ファイル→同一worker）
├─ Step 3: green-worker並列起動（Taskツール）
├─ Step 4: 結果収集・マージ
└─ Step 5: 全テスト実行→成功確認
```

**競合解決**: ファイル単位分担（同一ファイルは1つのworkerに集約）

**green-worker入力**:
- 担当テストケース（TC-XX）
- Cycle doc（設計情報、Implementation Notes）
- 対象ファイルパス
- 言語プラグイン情報

**green-worker出力**:
- 実装コード（Edit/Write）
- テスト結果（成功/失敗）

**tdd-red変更**:
- 「複数テストの同時作成（1つずつ）」禁止事項を削除
- Test List全体のテストを一括作成可能に

### Technical Challenges
1. **コンテキスト共有**: Cycle docのImplementation Notesを各workerに渡す
2. **競合解決**: ファイル単位でworkerを分担（同一ファイル編集を防ぐ）
3. **エラーハンドリング**: 1つのworkerが失敗→該当workerのみ再試行

## Progress Log

### 2026-01-26 10:03 - INIT
- Cycle doc作成
- Issue #35 に対応
- Risk: 80 (BLOCK)
- Brainstorm: 開発速度向上が目的、並列化が最善

---

## Next Steps

1. [Done] INIT
2. [Done] PLAN
3. [Done] RED
4. [Done] GREEN
5. [Done] REFACTOR
6. [Done] REVIEW
7. [Done] COMMIT
