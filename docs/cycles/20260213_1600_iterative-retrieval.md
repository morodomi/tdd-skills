---
feature: tdd-core
cycle: iterative-retrieval
phase: DONE
created: 2026-02-13 16:00
updated: 2026-02-13 16:00
---

# Iterative Retrieval（段階的コンテキスト精度向上）

## Scope Definition

### In Scope
- [ ] red-worker.md に Context Retrieval Protocol セクション追加
- [ ] green-worker.md に Context Retrieval Protocol セクション追加
- [ ] テストスクリプト作成（構造検証）

### Out of Scope
- redteam-core への適用（次サイクルで実装）
- reviewer系エージェントへの適用（効果検証後に検討）
- 自動リファイン回数の動的制御

### Files to Change (target: 10 or less)
- plugins/tdd-core/agents/red-worker.md (edit)
- plugins/tdd-core/agents/green-worker.md (edit)
- scripts/test-iterative-retrieval.sh (new)

## Environment

### Scope
- Layer: Backend (Plugin system)
- Plugin: tdd-core (Markdown agent definitions)
- Risk: 15 (PASS)

### Runtime
- Bash 3.2.57 (macOS default)

### Dependencies (key packages)
- Claude Code: Subagent system (Task tool)

## Context & Dependencies

### Reference Documents
- [docs/20260212_iterative_retrieval.md] - 企画書
- [everything-claude-code](https://github.com/affaan-m/everything-claude-code) - 参考実装

### Dependent Features
- red-worker: agents/red-worker.md 編集
- green-worker: agents/green-worker.md 編集

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
- [x] TC-01: red-worker.md に "Context Retrieval Protocol" セクションが存在する
- [x] TC-02: green-worker.md に "Context Retrieval Protocol" セクションが存在する
- [x] TC-03: red-worker.md のプロトコルにリファイン回数上限（3）が記載されている
- [x] TC-04: green-worker.md のプロトコルにリファイン回数上限（3）が記載されている
- [x] TC-05: red-worker.md のプロトコルに十分性評価基準（チェックリスト）が含まれている
- [x] TC-06: green-worker.md のプロトコルに十分性評価基準（チェックリスト）が含まれている
- [x] TC-07: red-worker.md の既存セクション（Workflow, Principles, Input, Output）が維持されている
- [x] TC-08: green-worker.md の既存セクション（Workflow, Principles, Input, Output）が維持されている

## Implementation Notes

### Goal
サブエージェント（red-worker, green-worker）が初回検索で不十分なコンテキストを得た場合に、
段階的にリファインして精度を向上させるプロトコルを追加する。

### Background
tdd-core のサブエージェントはコンテキスト窓が独立しており、親から渡された情報だけで判断する。
検索結果が不十分な場合、精度の低いテスト/実装になりうる。
everything-claude-code の Iterative Retrieval パターンを参考に、段階的な検索リファインを導入する。

### Design Approach

**変更内容**: 既存エージェント定義に Context Retrieval Protocol セクションを追加

| エージェント | 追加位置 | 評価基準の焦点 |
|-------------|---------|---------------|
| red-worker | Workflow の前（Input/Output の直後） | テスト対象コードの理解 |
| green-worker | Workflow の前（Input/Output の直後） | テスト要件と既存コードパターンの把握 |

**プロトコル構造（共通）**:
1. 初回検索: Cycle doc + 対象ファイル + 直接依存
2. 十分性評価: エージェント固有のチェックリストで判定
3. リファイン: 不足時に追加検索（Grep/Read/Glob）
4. 制約: 最大3サイクル（everything-claude-code準拠）、超過時は不明点明示して続行

**十分性評価チェックリスト（エージェント固有）**:

| red-worker | green-worker |
|-----------|-------------|
| 対象ファイルの責務と公開インターフェース把握 | テストコードの期待値と前提条件の把握 |
| 直接の依存関係（import先）確認 | 対象ファイルの既存コードパターン確認 |
| 既存テストパターン確認 | 直接の依存関係（import先）確認 |

## Progress Log

### 2026-02-13 16:00 - INIT
- Cycle doc created
- 企画書 docs/20260212_iterative_retrieval.md を参照
- Scope: tdd-core のみ（red-worker, green-worker）
- Risk: 15 (PASS) - プロンプト改善のみ

### 2026-02-13 16:30 - REVIEW
- quality-gate WARN (75): performance（レイテンシ未計測）、product（ROI未定義）、usability（配置改善余地）
- 全テスト183 PASS維持

### 2026-02-13 16:25 - REFACTOR
- リファクタ不要と判断（最小限の実装で品質十分）

### 2026-02-13 16:20 - GREEN
- red-worker.md に Context Retrieval Protocol 追加（18行）
- green-worker.md に Context Retrieval Protocol 追加（18行）
- 全8テストPASS + 既存175テストPASS = 183 PASS

### 2026-02-13 16:15 - RED
- scripts/test-iterative-retrieval.sh 作成（8テストケース）
- 6件失敗確認（RED状態）
- TC-03/TC-04 の検索パターンを修正（"3" → "最大3"）

### 2026-02-13 16:10 - plan-review WARN (68)
- product: 68 WARN（ROI根拠不足、効果測定未定義）
- usability: 65 WARN（評価基準曖昧、挿入位置不適切）
- scope: 25 PASS / architecture: 25 PASS / risk: 8 PASS
- 共通指摘3件（下記）

### 2026-02-13 16:05 - PLAN
- 設計方針: 既存エージェント定義に Context Retrieval Protocol セクション追加
- Test List: 8ケース（セクション存在2 + リファイン回数2 + 評価基準2 + 既存維持2）
- 変更ファイル3件（agent定義2 + テスト1）

---

## Next Steps

1. [Done] INIT
2. [Done] PLAN
3. [Done] RED
4. [Done] GREEN
5. [Done] REFACTOR
6. [Done] REVIEW <- Current
7. [Next] COMMIT
