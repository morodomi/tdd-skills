---
name: tdd-review
description: REVIEWフェーズ用（Hugo）。REFACTORフェーズ完了後の最終的な品質検証を行う。ビルド検証（hugo build --gc --minify）、リンク検証（htmltest）、Code Review（/code-review）、品質基準クリアできない場合はDISCOVEREDに追加。Progress Logに記録、YAML frontmatterのphaseを"REVIEW"に更新。ユーザーが「review」「レビュー」と言った時、REFACTORフェーズ完了後、または /tdd-review コマンド実行時に使用。Hugo向け。
allowed-tools: Read, Grep, Glob, Bash, Edit, Task, SlashCommand
---

# TDD REVIEW Phase

あなたは現在 **REVIEWフェーズ** にいます。

## このフェーズの目的

REFACTORフェーズ完了後の**最終的な品質検証**を行うことです。
品質基準を満たしているか確認し、問題があればDISCOVEREDに記録します。

## このフェーズでやること

- [ ] 最新のCycle docを読み込む（`docs/cycles/YYYYMMDD_hhmm_*.md`）
- [ ] ビルド検証を実行する（`hugo build --gc --minify`）
- [ ] リンク検証を実行する（`htmltest ./public`）
- [ ] **Code Review実行**（`/code-review`、3つのSubagent並行実行）
- [ ] 品質基準・Code Review指摘事項をクリアできない場合はDISCOVEREDに追加する
- [ ] Progress Logに記録する（REVIEW phase - ビルド結果、リンク検証結果、Code Review結果）
- [ ] YAML frontmatterのphaseを"REVIEW"に、updatedを更新する
- [ ] 次のフェーズを選択肢提示（星5つ形式）

## このフェーズで絶対にやってはいけないこと

- 実装コードを修正すること（読み取り専用、問題発見時はDISCOVEREDに記録のみ）
- テストコードを修正すること
- 品質チェックをスキップすること
- DISCOVEREDへの記録をスキップすること

## ワークフロー

### 1. 準備フェーズ

まず、最新のCycle docを読み込んで品質基準を確認してください：

```bash
# 最新のCycle docを検索
ls -t docs/cycles/202*.md 2>/dev/null | head -1

# Cycle docの読み込み
Read docs/cycles/YYYYMMDD_hhmm_<機能名>.md
```

**Cycle docが見つからない場合**:
```
エラー: Cycle docが見つかりません。

まず tdd-init を実行してください。

手順:
1. /tdd-init を実行
2. 再度 /tdd-review を実行
```

Cycle docから以下の情報を確認してください：

1. **YAML frontmatter**
   - phase: REFACTOR であることを確認（REVIEWフェーズに進む前提）
   - feature、cycle情報

2. **Scope Definition**
   - 今回実装する範囲
   - 今回実装しない範囲
   - 変更予定ファイル

3. **Test List**
   - 実装予定（TODO）: 空であることを確認
   - 実装中（WIP）: 空であることを確認
   - 完了（DONE）: すべてのテストがDONEに移動していることを確認
   - 実装中に気づいた追加テスト（DISCOVERED）: 次サイクル対応予定

4. **品質基準**（CLAUDE.mdまたはCycle docのImplementation Notesから）
   - ビルド成功（hugo build エラー0件）
   - リンク検証（htmltest 内部リンク切れ0件）

これらの情報を基に、品質検証を実施します。

### 2. ビルド検証フェーズ

Hugoビルドを実行して、エラーがないことを確認してください：

```bash
# 本番ビルド
hugo build --gc --minify
```

**ビルド成功の場合**:
```
ビルドが成功しました。

ビルド結果:
- 生成ページ数: XX件
- 警告: 0件
- エラー: 0件

次のリンク検証に進みます。
```

**ビルドが失敗した場合**:

DISCOVEREDに追加し、次のサイクルで修正します：

```
ビルドが失敗しています。

エラー内容:
[エラーメッセージ]

DISCOVEREDに追加します:
- [ ] DISC-XX: ビルドエラー修正（エラー: [エラーメッセージ概要]）

ビルドエラーを解消してから再度REVIEWを実行してください。
```

Editツールを使用してCycle docのTest List > DISCOVERED セクションに追加してください。

**重要**: ビルドエラーがある場合はリンク検証に進めません。

### 3. リンク検証フェーズ

htmltest でリンク検証を実行します。

#### 3.1 リンク検証実行

```bash
# リンク検証
htmltest ./public
```

**期待結果**:
- 内部リンク切れ: 0件

**結果の判定**:

**合格**（リンク切れ0件）:
```
リンク検証: 合格
  - 検証ページ数: XX件
  - リンク切れ: 0件
```

**不合格**（エラーあり）:

DISCOVEREDに追加します：

```
静的解析: 不合格
  - レベル: 8
  - エラー: XX件

DISCOVEREDに追加します:
- [ ] DISC-XX: 静的解析エラー修正（XX件のエラー）

詳細:
[エラー内容の一部を記載]

このまま品質チェックを継続します。
```

Editツールを使用してCycle docのTest List > DISCOVERED セクションに追加してください。

#### 3.2 テストカバレッジ確認

```bash
# テストカバレッジ確認
[your coverage command]
```

**期待結果**:
- 目標: 90%以上
- 最低ライン: 80%

**結果の判定**:

**合格**（90%以上）:
```
テストカバレッジ: 合格
  - カバレッジ: XX%
  - 目標: 90%以上
```

**条件付き合格**（80%以上90%未満）:
```
テストカバレッジ: 条件付き合格
  - カバレッジ: XX%
  - 最低ライン: 80%（クリア）
  - 目標: 90%以上（未達）

最低ラインはクリアしています。
次のサイクルでカバレッジ向上を推奨します。
```

**不合格**（80%未満）:

DISCOVEREDに追加します：

```
テストカバレッジ: 不合格
  - カバレッジ: XX%
  - 最低ライン: 80%（未達）

DISCOVEREDに追加します:
- [ ] DISC-XX: テストカバレッジ向上（現在XX%、目標90%+）

このまま品質チェックを継続します。
```

Editツールを使用してCycle docのTest List > DISCOVERED セクションに追加してください。

#### 3.3 コードフォーマット実行

```bash
# コードフォーマッタ実行（自動修正）
[your code formatter command]
# 例: vendor/bin/pint, black ., ruff format .
```

**期待動作**:
- コーディング規約に準拠するよう自動修正
- フォーマットエラー: 0件

**結果の判定**:

**修正なし**:
```
コードフォーマット: 合格
  - 修正ファイル: 0件
  - すでにコーディング規約に準拠しています
```

**自動修正実施**:
```
コードフォーマット: 自動修正完了
  - 修正ファイル: XX件

以下のファイルを自動修正しました:
- [ファイル1]
- [ファイル2]

自動修正後のテストを実行して、問題がないか確認します。
```

自動修正後は必ずテストを再実行してください：
```bash
[your test command]
```

修正後にテストが失敗した場合はDISCOVEREDに追加します。

### 4. Code Reviewフェーズ

**重要**: REVIEWフェーズでは、静的解析に加えて、必ず Code Review を実行します。

SlashCommandツールを使って `/code-review` を実行してください：

```
SlashCommand: /code-review
```

`/code-review` コマンドは、3つのSubagentを並行実行します：
1. **Correctness Review**: 論理エラー、エッジケース処理
2. **Performance Review**: パフォーマンス分析
3. **Security Review**: セキュリティ脆弱性チェック

**Code Review結果の処理**:

Code Reviewが完了したら、以下のように対応してください：

1. **🔴 Critical問題**: すべてDISCOVEREDに追加（HIGH優先度）
2. **🟡 Important問題**: DISCOVEREDに追加（MED優先度）、ユーザーに報告
3. **🟢 Optional問題**: 必要に応じてDISCOVEREDに追加（LOW優先度）

**DISCOVEREDへの記録例**:

```markdown
### 実装中に気づいた追加テスト（DISCOVERED）

**Code Review指摘事項**:
- 🔴 セキュリティ脆弱性: ユーザー検索でパラメータ化されていないクエリ - 次サイクルで対応（HIGH）
- 🟡 パフォーマンス: データ一覧でeager loadingなし - 次サイクルで対応（MED）
- 🟢 命名規則: 変数名が冗長 - バックログ（LOW）
```

**Code Review完了後**:

- ユーザーに結果を報告
- DISCOVEREDに記録した件数を伝える
- 「完璧なコードは一度に生まれない」哲学に基づき、次のフェーズに進む

### 5. Progress Log記録フェーズ

品質検証の結果をProgress Logに記録します。

Editツールを使用してCycle docのProgress Logセクションに追記：

```markdown
### YYYY-MM-DD HH:MM - REVIEW phase
- テスト実行: 合格 XX件、失敗 0件
- 静的解析: [合格/不合格] Level 8, エラー XX件
- カバレッジ: XX% ([合格/条件付き合格/不合格])
- コードフォーマット: [自動修正完了/修正なし]
- Code Review: Critical XX件、Important YY件、Optional ZZ件
- DISCOVEREDに追加: XX件（うちCode Review指摘: AA件）
```

**記録例（すべて合格の場合）**:
```markdown
### 2025-11-14 16:30 - REVIEW phase
- テスト実行: 合格 15件、失敗 0件
- 静的解析: 合格 Level 8, エラー 0件
- カバレッジ: 92% (合格)
- コードフォーマット: 修正なし
- Code Review: Critical 0件、Important 2件、Optional 3件
- DISCOVEREDに追加: 2件（うちCode Review指摘: 2件）
```

**記録例（一部不合格の場合）**:
```markdown
### 2025-11-14 16:30 - REVIEW phase
- テスト実行: 合格 12件、失敗 3件（DISCOVEREDに追加）
- 静的解析: 不合格 Level 8, エラー 5件（DISCOVEREDに追加）
- カバレッジ: 76% (不合格、DISCOVEREDに追加)
- コードフォーマット: 自動修正完了（3ファイル）
- Code Review: Critical 1件、Important 3件、Optional 2件
- DISCOVEREDに追加: 3件
```

### 6. YAML frontmatter更新フェーズ

Cycle docのYAML frontmatterを更新します。

Editツールを使用してCycle docの先頭部分を更新：

```markdown
---
feature: [機能領域]
cycle: [サイクル識別子]
phase: REVIEW
created: YYYY-MM-DD HH:MM
updated: YYYY-MM-DD HH:MM  # 現在時刻に更新
---
```

**更新内容**:
- `phase`: "REVIEW"に変更
- `updated`: 現在日時に更新

### 7. 完了フェーズ

レビュー完了後、次のフェーズを選択肢で案内します：

```
================================================================================
REVIEWフェーズが完了しました
================================================================================

品質検証結果:
- テスト: 合格 XX件、失敗 0件
- 静的解析: 合格（Level 8, エラー 0件）
- カバレッジ: XX% (合格)
- コードフォーマット: 修正なし
- DISCOVEREDに追加: 0件

現在のTDDワークフロー:
[完了] INIT (初期化)
[完了] PLAN (計画)
[完了] RED (テスト作成)
[完了] GREEN (実装)
[完了] REFACTOR (リファクタリング)
[完了] REVIEW (品質検証) ← 現在ここ
[次] DOC or COMMIT

次のステップを選択してください:

1. [推奨★★★★★] DOCフェーズに進む（ドキュメント更新）
   理由: Feature docやOverview docを更新し、実装内容を記録。95%のケースでこれが最適

2. [推奨★★★☆☆] COMMITフェーズに進む（ドキュメント更新スキップ）
   理由: 小規模な変更でドキュメント更新不要な場合。Cycle docだけで十分

3. [推奨★☆☆☆☆] REFACTORに戻る（品質改善）
   理由: DISCOVEREDに追加された問題を今すぐ修正したい場合。通常は次サイクル推奨

どうしますか？
```

**DISCOVEREDに項目がある場合**:
```
注意: DISCOVEREDに XX件の項目があります。
これらは次のTDDサイクルで対応することを推奨します。

DISCOVERED:
- DISC-01: [内容]
- DISC-02: [内容]

選択肢:
1. [推奨★★★★★] DOC/COMMITに進み、次サイクルでDISCOVEREDに対応
   理由: 小さなサイクルを回す方が効率的。今回の変更をまずコミット

2. [推奨★★☆☆☆] REFACTORに戻り、今すぐDISCOVEREDを解消
   理由: 緊急性が高い問題の場合のみ。時間がかかる可能性あり

どうしますか？
```

## 制約の強化

このフェーズでは、`allowed-tools: Read, Grep, Glob, Bash, Edit, Task, SlashCommand` が使用可能です。

**Editツールの使用は限定的**:
- Cycle docのTest List > DISCOVERED セクションへの追記のみ
- Progress Logへの記録のみ
- YAML frontmatterの更新のみ

**実装コードやテストコードの修正は禁止**です。

もしユーザーが以下のような依頼をした場合は、**丁寧に拒否**してください：

- 「テストを修正して」→ 「REVIEWフェーズでは実装コードを変更できません。DISCOVEREDに記録し、次サイクルで対応します」
- 「コードを改善して」→ 「REVIEWフェーズは検証のみです。DISCOVEREDに記録しました。次サイクルで対応してください」
- 「静的解析エラーを修正して」→ 「DISCOVEREDに記録しました。次サイクルで対応することを推奨します」

## トラブルシューティング

### Cycle docが見つからない場合

```
Cycle docが見つかりません。
REVIEWフェーズを開始する前に、INIT と PLAN フェーズを完了してください。

以下を確認してください：
- docs/cycles/YYYYMMDD_hhmm_*.md が存在するか（ls -t docs/cycles/202*.md で確認）
- Cycle docのphaseが"REFACTOR"になっているか
```

### phaseがREFACTORでない場合

```
Cycle docのphaseが「[現在のphase]」です。
REVIEWフェーズに進む前に、REFACTORフェーズを完了してください。

現在のワークフロー:
[完了] INIT (初期化)
[完了] PLAN (計画)
[完了] RED (テスト作成)
[完了] GREEN (実装)
[現在] [現在のphase] ← ここを完了させてください
[ ] REVIEW (品質検証)

REFACTORフェーズを完了してから、再度 /tdd-review を実行してください。
```

### Test ListにTODOまたはWIPが残っている場合

```
Test ListにまだTODOまたはWIPの項目が残っています。

TODO:
- [ ] TC-01: [テストケース]

WIP:
- [ ] TC-02: [テストケース]

すべてのテストをDONEに移動してから、REVIEWフェーズに進んでください。

対応方法:
1. GREENフェーズに戻ってテストを通す
2. REFACTORフェーズでリファクタリングを完了
3. 再度REVIEWフェーズに進む
```

## 参考情報

このSkillは、TDDワークフローの一部です。

- 詳細なワークフロー: README.md参照
- プロジェクト設定: CLAUDE.md参照
- 前のフェーズ: tdd-refactor Skill（リファクタリング）
- 次のフェーズ: tdd-commit Skill（コミット）

### REVIEWフェーズの重要性

REVIEWフェーズは、TDDサイクルの**品質ゲートキーパー**です：

- **品質検証**: 静的解析、カバレッジ、フォーマットをチェック
- **問題の記録**: 品質基準未達の場合はDISCOVEREDに追加
- **次サイクルへの橋渡し**: 完璧を求めず、小さなサイクルを回す

「完璧なコードは一度に生まれない。小さな改善を積み重ねる」哲学に基づいています。

### DISCOVEREDの活用

REVIEWフェーズでは、以下をDISCOVEREDに記録します：

1. **テスト失敗**: 失敗したテストケース
2. **静的解析エラー**: Level 8/--strictで検出されたエラー
3. **カバレッジ不足**: 80%未達のケース
4. **Code Review指摘**: Critical/Important/Optionalな問題
5. **その他の品質問題**: リファクタリング候補等

DISCOVEREDに記録された項目は、次のTDDサイクルで対応します。

### 小さなサイクルを回す

REVIEWフェーズでは、完璧を求めません：

- 品質基準をクリアできなくても、DISCOVEREDに記録してコミット可能
- 次のサイクルで改善することを推奨
- 小さく、頻繁にコミットする方が効率的

## プロジェクト固有のカスタマイズ

このSkillファイルはフレームワーク非依存の汎用版です。
プロジェクト固有の要件がある場合は、以下の項目をカスタマイズしてください：

1. **テスト実行コマンド**
   - フレームワーク固有のコマンド
   - カバレッジ取得コマンド

2. **静的解析ツール**
   - 使用するツール（PHPStan, mypy, etc.）
   - レベル設定（Level 8, --strict）
   - 実行コマンド

3. **コードフォーマッタ**
   - 使用するツール（Pint, black, ruff）
   - 実行コマンド
   - 自動修正オプション

4. **品質基準**
   - カバレッジ目標（デフォルト: 90%以上）
   - 最低ライン（デフォルト: 80%）
   - 静的解析レベル（デフォルト: Level 8/--strict）

### 言語別カスタマイズ例

**PHP (Laravel/PHPUnit)**:
```markdown
#### 品質チェックコマンド
- テスト実行: `php artisan test`
- カバレッジ: `php artisan test --coverage --min=90`
- 静的解析: `vendor/bin/phpstan analyse --level=8`
- コードフォーマット: `vendor/bin/pint`
```

**Python (pytest/mypy)**:
```markdown
#### 品質チェックコマンド
- テスト実行: `pytest`
- カバレッジ: `pytest --cov=. --cov-report=term --cov-fail-under=90`
- 静的解析: `mypy . --strict`
- コードフォーマット: `black . && ruff format .`
```

---

*このSkillはClaudeSkillsプロジェクトの一部です*
