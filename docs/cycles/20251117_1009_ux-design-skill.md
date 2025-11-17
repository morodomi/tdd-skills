---
feature: skills
cycle: ux-design-skill-001
phase: COMMIT
created: 2025-11-17 10:09
updated: 2025-11-17 10:50
---

# UX Design Skill 作成

## やりたいこと

UX心理学とRefactoring UI原則に基づいたUI/UXデザインスキルを作成し、全テンプレート（Laravel/Bedrock/Generic）に配置する。

**目的**:
- AIが統計的に「安全」な選択をすることを防ぐ
- UX心理学45原則を活用したデザイン支援
- Refactoring UI原則に基づく実践的なガイドライン
- 禁止パターンの明示化（izanami.dev方式）

**成果物**:
1. `templates/laravel/.claude/skills/ux-design/SKILL.md`
2. `templates/bedrock/.claude/skills/ux-design/SKILL.md`
3. `templates/generic/.claude/skills/ux-design/SKILL.md`
4. install.sh更新（グローバルインストールオプション追加）

---

## Scope Definition

### 今回実装する範囲
- [ ] UX Design Skill作成（SKILL.md）
- [ ] 禁止パターン定義（フォント、カラー、レイアウト、UIパターン）
- [ ] UX心理学原則適用ガイド（10-15原則厳選）
- [ ] Refactoring UI原則統合（階層、スペーシング、色彩、タイポグラフィ）
- [ ] 具体的なUIコンポーネント設計例（CTA、料金表、フォーム）
- [ ] チェックリスト作成
- [ ] 3テンプレートへの配置（Laravel/Bedrock/Generic）
- [ ] install.sh更新（グローバルインストールオプション）

### 今回実装しない範囲
- フレームワーク固有のカスタマイズ（全テンプレート共通版）
- 画像・アイコン素材の提供
- 具体的なTailwind CSS設定
- デザインシステム全体の構築

### 変更予定ファイル
- `templates/laravel/.claude/skills/ux-design/SKILL.md`（新規）
- `templates/bedrock/.claude/skills/ux-design/SKILL.md`（新規）
- `templates/generic/.claude/skills/ux-design/SKILL.md`（新規）
- `templates/laravel/install.sh`（編集）
- `templates/bedrock/install.sh`（編集）
- `templates/generic/install.sh`（編集）

---

## Context & Dependencies

### 参照ドキュメント
- 松下村塾 UX心理学45原則: https://www.shokasonjuku.com/ux-psychology
- Refactoring UI: https://www.refactoringui.com/
- izanami.dev禁止パターン方式: https://izanami.dev/post/e84bbd32-cc13-46d2-9b62-b2aef12e6564
- Zenn explaza記事（skill-creator）: https://zenn.dev/explaza/articles/9f3271d1a9ce70
- Zenn appbrew記事（Hook機能）: https://zenn.dev/appbrew/articles/e2f38677f6a0ce

### 依存する既存機能
- テンプレートinstall.sh構造
- `.claude/skills/` ディレクトリ構造
- Skill MDファイルフォーマット（YAML frontmatter）

### 関連Issue/PR
- なし（新規機能）

---

## Test List

### 実装予定（TODO）
（なし）

### 実装中（WIP）
（なし）

### 実装中に気づいた追加テスト（DISCOVERED）
- テストスクリプトで`set -e`使用時、`((PASS_COUNT++))`が0を返すと終了する問題発見 → `|| true`で修正
- grepの拡張正規表現パターンで`\|`ではなく`|`を使用する必要があることを発見

### 完了（DONE）
- [x] TC-01: SKILL.mdが有効なYAML frontmatterを持つ
- [x] TC-02: 禁止パターンセクションが存在する（26件）
- [x] TC-03: UX心理学原則が10以上記載されている（13原則）
- [x] TC-04: Refactoring UI原則が5以上記載されている（8原則）
- [x] TC-05: 具体的なUIコンポーネント例が3以上ある（6コンポーネント）
- [x] TC-06: チェックリストが存在する（23項目）
- [x] TC-07: Laravel版が正しいパスに配置される（16KB）
- [x] TC-08: Bedrock版が正しいパスに配置される（16KB）
- [x] TC-09: Generic版が正しいパスに配置される（16KB）
- [x] TC-10: install.shがグローバルインストールオプションを持つ
- [x] TC-11: install.sh実行後に~/.claude/skills/ux-design/が存在する

---

## Implementation Notes

### 背景
- AIは統計的に「安全」な選択をしがち（デフォルトフォント、汎用ボタンラベル等）
- UX心理学原則を明示的に指示することで、より効果的なUI設計が可能
- Refactoring UI原則はデザイナーでない開発者にも実践的
- 禁止パターンを明示することで、AIのデフォルト行動を制御

### 設計方針
1. **禁止パターン優先**: 統計的デフォルトを明示的に排除
2. **原則の厳選**: 45原則から実用的な10-15原則を選定
3. **具体例重視**: 抽象的なガイドラインではなく、コード例を提供
4. **チェックリスト化**: 実装時に確認できる具体的な項目
5. **全テンプレート共通**: フレームワーク非依存の汎用スキル

### UX心理学原則の選定基準
以下の原則を優先的に採用:
- アンカー効果（料金表設計）
- 認知負荷削減（フォーム設計）
- ドハティの閾値（ローディング）
- 社会的証明（信頼性）
- 損失回避（CTA）
- ナッジ効果（デフォルト設定）
- 段階的要請（オンボーディング）
- ツァイガルニク効果（進捗表示）
- 変動型報酬（エンゲージメント）
- フレーミング効果（メッセージング）

### Refactoring UI原則の統合
- 階層構造（視覚的優先順位）
- ボーダー削減（クリーンなデザイン）
- 色彩戦略（HSL、シェード管理）
- タイポグラフィ（フォント選定、整列）
- スペーシング（余白の重要性）

### Anti-patterns回避
- **避けるべき**: 汎用的なガイドラインのみ（「ユーザビリティを考慮」等）
- **推奨**: 具体的な禁止事項と代替案のセット
- **避けるべき**: すべての原則を網羅（情報過多）
- **推奨**: 実用的な原則を厳選

---

## Progress Log

### 2025-11-17 10:09 - INIT phase
- Cycle doc作成
- やりたいことを定義
- UX心理学45原則、Refactoring UI原則、禁止パターン方式の調査完了

### 2025-11-17 10:12 - PLAN phase
- Scope Definition記入完了（実装範囲8項目、非実装範囲4項目、変更予定6ファイル）
- Context & Dependencies記入完了（参照ドキュメント5件、依存機能3件）
- Test List作成完了（TODO: 11件）
- Implementation Notes記入完了（背景、設計方針、原則選定基準、Anti-patterns回避）
- YAML frontmatter更新（phase: INIT → PLAN → RED）

### 2025-11-17 10:25 - RED phase
- テストスクリプト作成完了:
  - `tests/ux-design-skill/test_skill_structure.sh` (TC-01〜TC-06)
  - `tests/ux-design-skill/test_template_placement.sh` (TC-07〜TC-11)
  - `tests/ux-design-skill/run_all_tests.sh`
- テスト実行: 全テスト失敗確認（実装なし）
- YAML frontmatter更新（phase: RED → GREEN）

### 2025-11-17 10:35 - GREEN phase
- SKILL.md作成:
  - YAML frontmatter（name, description, allowed-tools）
  - 禁止パターン（26件: フォント、カラー、UI、レイアウト）
  - UX心理学原則（13原則: アンカー効果、認知負荷、損失回避等）
  - Refactoring UI原則（8原則: 階層、ボーダー、スペーシング等）
  - UIコンポーネント例（6種: CTA、料金表、フォーム等）
  - チェックリスト（23項目）
- 3テンプレートへ配置（Laravel/Bedrock/Generic）
- install.sh更新:
  - SKILLS配列にux-design追加
  - グローバルインストールセクション追加（~/.claude/skills/ux-design/）
- DISCOVERED: テストスクリプトのバグ修正（set -e対応、grep ERE構文）
- テスト実行: 全11テスト成功
- YAML frontmatter更新（phase: GREEN → REFACTOR）

### 2025-11-17 10:50 - REFACTOR/COMMIT phase
- SKILL.mdはドキュメントのため、リファクタリングは最小限
- 構造は既に明確で重複なし
- 全テスト再確認: 11/11 PASS
- git status確認: 変更ファイル10件（SKILL.md x3, install.sh x3, tests x3, cycle doc x1）
- YAML frontmatter更新（phase: REFACTOR → COMMIT）
- コミット実行: `9c09d89`
  - 10 files changed, 2469 insertions(+), 3 deletions(-)
  - feat: UX Design Skill作成 - 禁止パターン + UX心理学原則 + Refactoring UI

**TDDサイクル完了**
