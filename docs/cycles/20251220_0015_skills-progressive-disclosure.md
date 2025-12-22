---
feature: skills
cycle: progressive-disclosure-refactor
phase: INIT
created: 2025-12-20 00:15
updated: 2025-12-20 00:15
---

# Skills Progressive Disclosure対応

## Scope Definition（スコープ定義）

### 今回実装する範囲

- [x] tdd-init Skill改善（Progressive Disclosure対応）
- [ ] tdd-plan Skill改善
- [ ] tdd-red Skill改善
- [ ] tdd-green Skill改善
- [ ] tdd-refactor Skill改善
- [ ] tdd-review Skill改善
- [ ] tdd-commit Skill改善
- [ ] 他テンプレート（laravel/flask/hugo/bedrock）への反映

### 今回実装しない範囲（次サイクル以降）

- ❌ install.shのagent_docs→skill コピー対応（Issue #4）
- ❌ ux-design Skillの改善（別サイクル）

### 変更予定ファイル

**tdd-init（参考）**:
- templates/generic/.claude/skills/tdd-init/SKILL.md（編集: 670→100行以下）
- templates/generic/.claude/skills/tdd-init/reference.md（新規）
- templates/generic/.claude/skills/tdd-init/templates/cycle.md（新規）

**他6 Skill × 同様の構造変更**

計: 約30ファイル（7 Skill × 3ファイル + 共通）

## Context & Dependencies（コンテキストと依存関係）

### 参照ドキュメント

- [Claude Skill Best Practices](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices)
- [anthropics/skills frontend-design](https://github.com/anthropics/skills)

### 設計原則（公式ベストプラクティスより）

1. **Claudeは賢い** - 講義不要、知らないことだけ書く
2. **1トークンごとに価値を疑え** - 無駄なコンテキスト消費を避ける
3. **description重要** - 「どんなときに使うか」を明確に
4. **Progressive Disclosure** - SKILL.mdは目次、詳細は別ファイル
5. **1段構造** - 参照の参照（A→B→C）は禁止
6. **自由度設計** - 壊れやすい処理は厳密に、判断系は余地を残す
7. **チェックリスト形式** - 文章より自己管理しやすい形
8. **検証ループ** - 実行→検証→修正を組み込む

### 関連Issue/PR

- Issue #4: install.shでagent_docsをskillディレクトリにコピー

## Test List（テストリスト）

### 実装予定（TODO）

- [ ] TC-01: tdd-init SKILL.mdが100行以下
- [ ] TC-02: reference.mdに詳細が分離されている
- [ ] TC-03: templates/cycle.mdにテンプレートが分離されている
- [ ] TC-04: descriptionに「どんなときに使うか」が明記されている
- [ ] TC-05: 講義的な説明が削除されている
- [ ] TC-06: ワークフローがチェックリスト形式
- [ ] TC-07: 他6 Skillも同様の構造
- [ ] TC-08: 5テンプレートすべてに反映

### 実装中（WIP）

- [ ] TC-01〜TC-04: scripts/test-skills-structure.sh で自動検証
  - 現状: 13 passed, 15 failed

### 実装中に気づいた追加テスト（DISCOVERED）

（現在なし）

### 完了（DONE）

（現在なし）

## Implementation Notes（実装ノート）

### やりたいこと

Claude公式ベストプラクティスに基づき、全TDD Skillを改善する。
SKILL.mdを目次化し、詳細をreference.mdに分離（Progressive Disclosure）。

### Before/After

**Before (tdd-init: 670行)**:
```
SKILL.md に全部入り
├── 目的説明（講義）
├── ワークフロー詳細
├── テンプレート（100行）
├── トラブルシューティング
├── カスタマイズ例
└── 参考情報（講義）
```

**After (目標: 100行以下)**:
```
SKILL.md（目次のみ）
├── description 改善（トリガー明確化）
├── チェックリスト（10項目以下）
├── 禁止事項（3行）
└── 「詳細は reference.md を読め」

reference.md（必要時のみ読む）
├── 詳細ワークフロー
├── トラブルシューティング
└── エラーハンドリング

templates/cycle.md（コピー用）
└── Cycle docテンプレート
```

## Progress Log（進捗ログ）

### 2025-12-20 00:15 - INIT phase

- TDDサイクルドキュメント作成
- 公式ベストプラクティス分析完了
- Issue #4 作成（install.sh改善）

---

## 次のステップ

1. [完了] INIT（初期化）← 現在ここ
2. [次] PLAN（計画）
3. [ ] RED（テスト作成）
4. [ ] GREEN（実装）
5. [ ] REFACTOR（リファクタリング）
6. [ ] REVIEW（品質検証）
7. [ ] COMMIT（コミット）

---

*作成日時: 2025-12-20 00:15*
*次のフェーズ: PLAN*
