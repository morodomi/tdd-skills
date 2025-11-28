---
feature: Claude 4 Best Practices Integration
cycle: claude4-bp-integration
phase: DONE
created: 2025-11-27 11:54
updated: 2025-11-27 12:40
commit: a9ba474
---

# Claude 4 Best Practices Integration

## やりたいこと

Claude 4のベストプラクティス（platform.claude.com/docs および claude.com/blog）から抽出した改善点を、ClaudeSkillsのSkillsおよびCLAUDE.mdテンプレートに取り込む。

**参照元**:
- https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-4-best-practices
- https://www.claude.com/blog/best-practices-for-prompt-engineering

---

## Scope Definition

### 実装対象

**A項目（Skills への取り込み）**:
- A1: ツール使用の明確化（「suggest」vs「change」の違い）
- A2: 過度なエンジニアリング防止（依頼された変更のみ実装）
- A3: コード検査の徹底（変更前に必ずファイルを読む）
- A4: 理由（Why）の提供（制約の理由を説明）

**B項目（CLAUDE.md テンプレートへの取り込み）**:
- B1: 出力フォーマット制御（マークダウン過多の回避）
- B2: サンプルへの注意喚起（例示内容が動作に影響する警告）
- B3: 長期タスク管理（複数セッションにまたがる作業の状態追跡）

### 対象外（今回は実装しない）

- C1: 並列ツール呼び出し（上級者向け、複雑化を避ける）
- C2: 研究時の複数仮説（tdd-plan Skill強化は別サイクル）
- C3: AI slop美学の回避（ux-design Skill強化は別サイクル）

---

## Context & Dependencies

### 対象ファイル

**Skills（A項目）**:
- `templates/generic/.claude/skills/tdd-plan/SKILL.md`
- `templates/generic/.claude/skills/tdd-green/SKILL.md`
- `templates/generic/.claude/skills/tdd-refactor/SKILL.md`
- `templates/generic/.claude/skills/tdd-review/SKILL.md`
- `templates/laravel/.claude/skills/tdd-*/SKILL.md`（同様の変更）
- `templates/bedrock/.claude/skills/tdd-*/SKILL.md`（同様の変更）

**CLAUDE.md テンプレート（B項目）**:
- `templates/generic/CLAUDE.md.example`
- `templates/laravel/CLAUDE.md.template`
- `templates/bedrock/CLAUDE.md.example`

### 依存関係

- 既存のSkills構造を維持
- 既存のCLAUDE.mdテンプレート構造を維持
- 3つのテンプレート（generic, laravel, bedrock）で一貫した変更

---

## Test List

### 実装予定（TODO）

（GREENフェーズで実装）

### 実装中（WIP）

（現在なし）

### 実装中に気づいた追加テスト（DISCOVERED）

（今回のサイクルではなし）

### 完了（DONE）

**A項目（Skills）**:
- [x] TC-01: tdd-green に A2（過度なエンジニアリング防止）の強化指示がある
- [x] TC-02: tdd-green に A3（コード検査の徹底）の指示がある
- [x] TC-03: tdd-refactor に A2, A3 の指示がある
- [x] TC-04: tdd-plan に A1（ツール使用の明確化）の指示がある
- [x] TC-05: 各Skillの制約に A4（理由）が追記されている

**B項目（CLAUDE.md）**:
- [x] TC-06: generic CLAUDE.md に B1（出力フォーマット制御）セクションがある
- [x] TC-07: generic CLAUDE.md に B2（サンプル注意喚起）がある
- [x] TC-08: generic CLAUDE.md に B3（長期タスク管理）セクションがある
- [x] TC-09: laravel CLAUDE.md に B1, B2, B3 がある
- [x] TC-10: bedrock CLAUDE.md に B1, B2, B3 がある

**一貫性チェック**:
- [x] TC-11: 3テンプレートで A項目の内容が一致
- [x] TC-12: 3テンプレートで B項目の内容が一致

---

## Implementation Notes

### A項目の追加位置

**A1: ツール使用の明確化**
- 追加先: tdd-plan Skill の「対話フェーズ」セクション
- 内容: PLANフェーズでは「提案して」「設計案を出して」を使用するよう案内

**A2: 過度なエンジニアリング防止**
- 追加先: tdd-green, tdd-refactor の「やってはいけないこと」セクション
- 内容: 「依頼された変更のみ実装」「スコープ外の改善はDISCOVEREDに記録」

**A3: コード検査の徹底**
- 追加先: tdd-green, tdd-refactor の「ワークフロー」セクション冒頭
- 内容: 「変更対象ファイルを必ずReadしてから実装」

**A4: 理由（Why）の提供**
- 追加先: 各Skillの「制約の強制」セクション
- 内容: 各制約に「なぜこの制約があるか」を追記

### B項目の追加位置

**B1: 出力フォーマット制御**
- 追加先: CLAUDE.md の「Notes for Claude Code」セクション
- 内容: マークダウン過多回避、CLI可読性考慮

**B2: サンプルへの注意喚起**
- 追加先: CLAUDE.md の「Examples」セクション冒頭
- 内容: 注意書きブロック

**B3: 長期タスク管理**
- 追加先: CLAUDE.md の「TDDドキュメント管理」セクション
- 内容: 複数セッション管理、セッション再開手順

---

## Progress Log

### 2025-11-27 11:54 - INIT phase
- Cycle doc作成
- Scope Definition定義（A項目: Skills、B項目: CLAUDE.md）
- Test List作成（12テストケース）
- Implementation Notes作成

### 2025-11-27 12:05 - RED phase
- テストスクリプト作成:
  - `tests/claude4-best-practices/test_skills_a_items.sh` (TC-01〜TC-05)
  - `tests/claude4-best-practices/test_claudemd_b_items.sh` (TC-06〜TC-10)
  - `tests/claude4-best-practices/test_consistency.sh` (TC-11〜TC-12)
  - `tests/claude4-best-practices/run_all_tests.sh` (ランナー)
- テスト実行結果: 0 passed, 12 failed (RED状態)

### 2025-11-27 12:25 - GREEN phase
- A項目実装:
  - `templates/*/skills/tdd-green/SKILL.md`: A2, A3, A4 追加
  - `templates/*/skills/tdd-refactor/SKILL.md`: A2, A3, A4 追加
  - `templates/*/skills/tdd-plan/SKILL.md`: A1 追加
- B項目実装:
  - `templates/*/CLAUDE.md.*`: B1（出力フォーマット制御）追加
  - `templates/*/CLAUDE.md.*`: B2（サンプル注意喚起）追加
  - `templates/*/CLAUDE.md.*`: B3（長期タスク管理）追加
- テスト実行結果: 12 passed, 0 failed (GREEN状態)

### 2025-11-27 12:30 - REFACTOR phase
- 一貫性チェック実施:
  - A項目: 3テンプレートで完全一致
  - B項目: 3テンプレートで完全一致
- リファクタリング判断: 不要（コードは既にクリーン）
- テスト実行結果: 12 passed, 0 failed

### 2025-11-27 12:35 - REVIEW phase
- 最終テスト実行: 12 passed, 0 failed
- 変更ファイル: 17ファイル（Skills 9, CLAUDE.md 3, テスト 4, Cycle doc 1）
- 追加行数: +160行（テンプレート部分）
- チェックリスト: すべて完了

### 2025-11-27 12:40 - COMMIT phase
- コミットハッシュ: a9ba474
- コミットファイル: 17 files changed, 1405 insertions(+)
- ブランチ: main (ahead of origin/main by 1 commit)

---

*このドキュメントはTDDサイクルの進捗を追跡します*
