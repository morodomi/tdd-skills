---
feature: review-system
cycle: 20251223_1740_agent-integrated-review
phase: REVIEW
created: 2025-12-23 17:40
updated: 2025-12-23 17:41
---

# エージェント統合レビューシステム

## Scope Definition

### 今回実装する範囲
- [ ] plugins/tdd-core/agents/ に7つのレビューエージェント作成
  - [ ] correctness-reviewer（正確性）
  - [ ] performance-reviewer（パフォーマンス）
  - [ ] security-reviewer（セキュリティ）
  - [ ] guidelines-reviewer（ガイドライン準拠）
  - [ ] scope-reviewer（スコープ妥当性）
  - [ ] architecture-reviewer（設計整合性）
  - [ ] risk-reviewer（リスク評価）
- [ ] skills/quality-gate/ 新規作成（code-reviewの置き換え）
- [ ] skills/plan-review/ 更新（エージェント活用、信頼スコア追加）
- [ ] skills/tdd-review/ 更新（quality-gate参照に変更）
- [ ] skills/code-review/ 削除

### 今回実装しない範囲
- ❌ 信頼スコア閾値のカスタマイズ（理由: 80固定で十分）
- ❌ エージェント数の動的変更（理由: 固定構成でシンプルに）

### 変更予定ファイル（目安: 10以下）
- plugins/tdd-core/agents/correctness-reviewer.md（新規）
- plugins/tdd-core/agents/performance-reviewer.md（新規）
- plugins/tdd-core/agents/security-reviewer.md（新規）
- plugins/tdd-core/agents/guidelines-reviewer.md（新規）
- plugins/tdd-core/agents/scope-reviewer.md（新規）
- plugins/tdd-core/agents/architecture-reviewer.md（新規）
- plugins/tdd-core/agents/risk-reviewer.md（新規）
- plugins/tdd-core/skills/quality-gate/skill.md（新規）
- plugins/tdd-core/skills/plan-review/skill.md（編集）
- plugins/tdd-core/skills/tdd-review/skill.md（編集）
- plugins/tdd-core/skills/code-review/（削除）

## Context & Dependencies

### 参照ドキュメント
- anthropics/claude-plugins-official/plugins/code-review - 公式実装の参考

### 依存する既存機能
- tdd-review: plugins/tdd-core/skills/tdd-review/
- plan-review: plugins/tdd-core/skills/plan-review/
- Task tool: サブエージェント呼び出し

### 関連Issue/PR
- Issue #11: Plugin経由のエージェント配布

## Test List

### TODO
（なし）

### WIP
（なし）

### DISCOVERED
（現在なし）

### DONE
**エージェント定義（7ファイル）**
- [x] TC-01: correctness-reviewer.md が正しい形式（YAML frontmatter + prompt）
- [x] TC-02: performance-reviewer.md が正しい形式
- [x] TC-03: security-reviewer.md が正しい形式
- [x] TC-04: guidelines-reviewer.md が正しい形式
- [x] TC-05: scope-reviewer.md が正しい形式
- [x] TC-06: architecture-reviewer.md が正しい形式
- [x] TC-07: risk-reviewer.md が正しい形式

**quality-gateスキル**
- [x] TC-08: quality-gate/SKILL.md が100行以下
- [x] TC-09: 4エージェントを並行呼び出しする指示が含まれる
- [x] TC-10: 信頼スコア閾値80でBLOCK判定の記述

**plan-reviewスキル更新**
- [x] TC-11: plan-review/SKILL.md が3エージェント呼び出しに更新
- [x] TC-12: 信頼スコア統合処理の記述

**tdd-reviewスキル更新**
- [x] TC-13: code-review → quality-gate への参照変更

**削除確認**
- [x] TC-14: code-review/ ディレクトリが削除されている

**構造テスト**
- [x] TC-15: bash scripts/test-plugins-structure.sh が全PASS（27 passed, 0 failed）

## Implementation Notes

### やりたいこと
anthropics/claude-plugins-official/code-reviewの並行エージェント＋信頼スコア方式を
tdd-skillsのquality-gateとplan-reviewに導入する。

### 背景
- 現在のcode-review/plan-reviewは単一エージェントで3観点を順次チェック
- 公式実装は並行エージェント＋信頼スコアで効率的かつ正確
- エージェントをplugin経由で配布できることが判明（Issue #11）

### 設計方針

#### エージェント定義形式
```yaml
---
name: <agent-name>
description: <説明>
model: sonnet
---
# System Prompt
```

#### ファイル構成
```
plugins/tdd-core/
├── agents/                          # 新規ディレクトリ
│   ├── correctness-reviewer.md      # 正確性（論理エラー、エッジケース）
│   ├── performance-reviewer.md      # パフォーマンス（O記法、N+1）
│   ├── security-reviewer.md         # セキュリティ（SQLi、XSS）
│   ├── guidelines-reviewer.md       # ガイドライン準拠
│   ├── scope-reviewer.md            # スコープ妥当性
│   ├── architecture-reviewer.md     # 設計整合性
│   └── risk-reviewer.md             # リスク評価
└── skills/
    ├── quality-gate/SKILL.md        # 新規（4エージェント呼び出し）
    ├── plan-review/SKILL.md         # 更新（3エージェント呼び出し）
    ├── tdd-review/SKILL.md          # 更新（quality-gate参照）
    └── code-review/                 # 削除
```

#### 信頼スコア基準
| スコア | 判定 | アクション |
|--------|------|-----------|
| 80-100 | BLOCK | 修正必須、進行不可 |
| 50-79 | WARN | 警告表示、継続可能 |
| 0-49 | PASS | 問題なし |

#### エージェント呼び出しパターン
```
Taskツールで4並行起動:
- tdd-core:correctness-reviewer
- tdd-core:performance-reviewer
- tdd-core:security-reviewer
- tdd-core:guidelines-reviewer

各エージェントが返す形式:
{
  "confidence": 85,
  "issues": [
    {"severity": "critical", "message": "...", "file": "...", "line": 123}
  ]
}
```

## Progress Log

### 2025-12-23 17:40 - INIT
- Cycle doc作成
- スコープ: 7エージェント、quality-gate新規、plan-review更新、code-review削除
- 信頼スコア閾値80固定

### 2025-12-23 17:41 - PLAN
- 設計方針策定（エージェント定義形式、ファイル構成、信頼スコア基準）
- Test List作成（15テストケース）
- 実装順序: エージェント → quality-gate → plan-review更新 → tdd-review更新 → code-review削除

### 2025-12-23 17:42 - RED
- test-plugins-structure.sh にエージェント/quality-gateテスト追加
- テスト実行: 23 passed, 4 failed（RED状態確認）
- 全テストケースをWIPに移動

### 2025-12-23 17:43 - GREEN
- agents/ ディレクトリ作成、7エージェントファイル作成
- quality-gate スキル新規作成
- plan-review スキル更新（3エージェント並行呼び出し）
- tdd-review スキル更新（quality-gate参照）
- code-review スキル削除
- テスト実行: 27 passed, 0 failed（GREEN状態確認）

### 2025-12-23 17:44 - REFACTOR
- 全スキル100行以下確認（最大99行: tdd-init）
- reference.md更新（plan-review, tdd-review, quality-gate）
- テスト再実行: 27 passed, 0 failed

### 2025-12-23 17:45 - REVIEW
- 構造テスト: 27 passed, 0 failed
- quality-gate実行（3エージェント並行）
  - correctness: 15 (PASS)
  - performance: 42 (PASS)
  - security: 95 (PASS)
- 最大スコア42 → PASS判定

---

## 次のステップ

1. [完了] INIT
2. [完了] PLAN
3. [完了] RED
4. [完了] GREEN
5. [完了] REFACTOR
6. [完了] REVIEW ← 現在
7. [次] COMMIT
