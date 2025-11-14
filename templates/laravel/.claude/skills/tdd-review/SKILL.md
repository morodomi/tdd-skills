---
name: tdd-review
description: REVIEWフェーズ用。REFACTORフェーズ完了後の最終的な品質検証を行う。静的解析（PHPStan Level 8）、カバレッジチェック（最低80%、目標90%+）、Laravel Pint実行、Code Review（/code-review、3つのSubagent並行実行）、品質基準クリアできない場合はDISCOVEREDに追加。Progress Logに記録、YAML frontmatterのphaseを"REVIEW"に更新。ユーザーが「review」「レビュー」と言った時、REFACTORフェーズ完了後、または /tdd-review コマンド実行時に使用。
allowed-tools: Read, Grep, Glob, Bash, Edit, Task, SlashCommand
---

# TDD REVIEW Phase

あなたは現在 **REVIEWフェーズ** にいます。

## このフェーズの目的

REFACTORフェーズ完了後の**最終的な品質検証**を行うことです。
品質基準を満たしているか確認し、問題があればDISCOVEREDに記録します。

## 哲学の転換

**旧アプローチ**: 品質基準未達→REVIEWフェーズ中断→REFACTORに戻る

**新アプローチ**: 品質基準未達→DISCOVEREDに記録→次サイクルで対応

「完璧なコードは一度に生まれない。小さな改善を積み重ねる」

## このフェーズでやること

- [ ] 最新のCycle docを読み込む（`docs/cycles/YYYYMMDD_hhmm_*.md`）
- [ ] 静的解析を実行する（PHPStan Level 8）
- [ ] カバレッジをチェックする（最低80%、目標90%+）
- [ ] コードフォーマッタを実行する（Laravel Pint）
- [ ] **Code Review実行**（`/code-review`、3つのSubagent並行実行）
- [ ] 品質基準・Code Review指摘事項をクリアできない場合はDISCOVEREDに追加する
- [ ] Progress Logに記録する（REVIEW phase - 静的解析結果、カバレッジ、Code Review結果）
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
   - テストカバレッジ目標（デフォルト: 90%以上、最低80%）
   - 静的解析ツールとレベル（デフォルト: PHPStan Level 8）
   - コーディング規約（デフォルト: Laravel Pint/PSR-12）

これらの情報を基に、品質検証を実施します。

### 2. テスト検証フェーズ

すべてのテストを実行して、テストが通っていることを確認してください：

```bash
# すべてのテストを実行
php artisan test
```

**テストが通った場合**:
```
すべてのテストが通りました。

テスト結果:
- 合格: XX件
- 失敗: 0件
- スキップ: XX件

次の品質チェックに進みます。
```

**テストが失敗した場合**:

DISCOVEREDに追加し、次のサイクルで修正します：

```
テストが失敗しています。

失敗したテスト:
[テスト名とエラーメッセージ]

DISCOVEREDに追加します:
- [ ] DISC-XX: [失敗したテスト] を修正（エラー: [エラーメッセージ概要]）

このまま品質チェックに進みますが、次のサイクルで修正が必要です。
```

Editツールを使用してCycle docのTest List > DISCOVERED セクションに追加してください。

**重要**: テスト失敗はREVIEWフェーズを中断せず、DISCOVEREDに記録して次サイクルで対応します。

### 3. 品質基準チェックフェーズ

品質チェックツールを実行します。

#### 3.1 静的解析実行（PHPStan Level 8）

```bash
# PHPStan実行（Level 8）
vendor/bin/phpstan analyse
```

**期待結果**:
- Level 8
- エラー: 0件

**結果の判定**:

**合格**（エラー0件）:
```
静的解析: 合格
  - レベル: 8
  - エラー: 0件
```

**不合格**（エラーあり）:

DISCOVEREDに追加します：

```
静的解析: 不合格
  - レベル: 8
  - エラー: XX件

DISCOVEREDに追加します:
- [ ] DISC-XX: PHPStan Level 8エラー修正（XX件のエラー）

詳細:
[エラー内容の一部を記載]

このまま品質チェックを継続します。
```

Editツールを使用してCycle docのTest List > DISCOVERED セクションに追加してください。

#### 3.2 テストカバレッジ確認

```bash
# テストカバレッジ確認
php artisan test --coverage
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

#### 3.3 コードフォーマット実行（Laravel Pint）

```bash
# Laravel Pint実行（自動修正）
vendor/bin/pint
```

**期待動作**:
- PSR-12準拠に自動修正
- フォーマットエラー: 0件

**結果の判定**:

**修正なし**:
```
コードフォーマット: 合格
  - 修正ファイル: 0件
  - すでにPSR-12に準拠しています
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
php artisan test
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
2. **Performance Review**: Gemini CLIでパフォーマンス分析
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
- 🔴 SQLインジェクション脆弱性: User検索でパラメータ化されていないクエリ - 次サイクルで対応（HIGH）
- 🟡 N+1問題: Post一覧でeager loadingなし - 次サイクルで対応（MED）
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
- 静的解析: [合格/不合格] PHPStan Level 8, エラー XX件
- カバレッジ: XX% ([合格/条件付き合格/不合格])
- コードフォーマット: [自動修正完了/修正なし]
- Code Review: Critical XX件、Important YY件、Optional ZZ件
- DISCOVEREDに追加: XX件（うちCode Review指摘: AA件）
```

**記録例（すべて合格の場合）**:
```markdown
### 2025-11-14 16:30 - REVIEW phase
- テスト実行: 合格 15件、失敗 0件
- 静的解析: 合格 PHPStan Level 8, エラー 0件
- カバレッジ: 92% (合格)
- コードフォーマット: 修正なし
- Code Review: Critical 0件、Important 2件、Optional 3件
- DISCOVEREDに追加: 2件（うちCode Review指摘: 2件）
```

**記録例（一部不合格の場合）**:
```markdown
### 2025-11-14 16:30 - REVIEW phase
- テスト実行: 合格 12件、失敗 3件（DISCOVEREDに追加）
- 静的解析: 不合格 PHPStan Level 8, エラー 5件（DISCOVEREDに追加）
- カバレッジ: 76% (不合格、DISCOVEREDに追加)
- コードフォーマット: 自動修正完了（3ファイル）
- DISCOVEREDに追加: 3件
```

### 5. YAML frontmatter更新フェーズ

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

### 6. 完了フェーズ

レビュー完了後、次のフェーズを選択肢で案内します：

**DISCOVEREDに項目がない場合**:

```
================================================================================
REVIEWフェーズが完了しました
================================================================================

品質検証結果:
- テスト: 合格 XX件、失敗 0件
- 静的解析: 合格（PHPStan Level 8, エラー 0件）
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
[次] COMMIT

次のステップを選択してください:

1. [推奨★★★★★] COMMITフェーズに進む（コミット実行）
   理由: すべての品質基準をクリア。コミットして次サイクルへ。95%のケースでこれが最適

2. [推奨★★☆☆☆] REFACTORに戻る（さらなる改善）
   理由: より高い品質を目指す場合。通常はコミット後の次サイクルで対応を推奨

どうしますか？
```

**DISCOVEREDに項目がある場合**:

```
================================================================================
REVIEWフェーズが完了しました
================================================================================

品質検証結果:
- テスト: 合格 10件、失敗 2件（DISCOVEREDに追加）
- 静的解析: 不合格（PHPStan Level 8, エラー 3件、DISCOVEREDに追加）
- カバレッジ: 75% (不合格、DISCOVEREDに追加)
- コードフォーマット: 自動修正完了
- DISCOVEREDに追加: 3件

注意: DISCOVEREDに 3件の項目があります。
これらは次のTDDサイクルで対応することを推奨します。

DISCOVERED:
- DISC-01: [失敗したテスト] を修正
- DISC-02: PHPStan Level 8エラー修正（3件）
- DISC-03: テストカバレッジ向上（現在75%、目標90%+）

現在のTDDワークフロー:
[完了] INIT (初期化)
[完了] PLAN (計画)
[完了] RED (テスト作成)
[完了] GREEN (実装)
[完了] REFACTOR (リファクタリング)
[完了] REVIEW (品質検証) ← 現在ここ
[次] COMMIT

次のステップを選択してください:

1. [推奨★★★★★] COMMITに進み、次サイクルでDISCOVEREDに対応
   理由: 小さなサイクルを回す方が効率的。今回の変更をまずコミット。90%のケースでこれが最適

2. [推奨★★☆☆☆] REFACTORに戻り、今すぐDISCOVEREDを解消
   理由: 緊急性が高い問題の場合のみ。時間がかかる可能性あり

どうしますか？
```

## 制約の強化

このフェーズでは、`allowed-tools: Read, Grep, Glob, Bash, Edit` が使用可能です。

**Editツールの使用は限定的**:
- Cycle docのTest List > DISCOVERED セクションへの追記のみ
- Progress Logへの記録のみ
- YAML frontmatterの更新のみ

**実装コードやテストコードの修正は禁止**です。

もしユーザーが以下のような依頼をした場合は、**丁寧に拒否**してください：

- 「テストを修正して」→ 「REVIEWフェーズでは実装コードを変更できません。DISCOVEREDに記録し、次サイクルで対応します」
- 「コードを改善して」→ 「REVIEWフェーズは検証のみです。DISCOVEREDに記録しました。次サイクルで対応してください」
- 「PHPStanエラーを修正して」→ 「DISCOVEREDに記録しました。次サイクルで対応することを推奨します」

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

このSkillは、Laravel開発におけるTDDワークフローの一部です。

- 詳細なワークフロー: README.md参照
- プロジェクト設定: CLAUDE.md参照
- 前のフェーズ: tdd-refactor Skill（リファクタリング）
- 次のフェーズ: tdd-commit Skill（コミット、DOC統合済み）

### REVIEWフェーズの重要性

REVIEWフェーズは、TDDサイクルの**品質ゲートキーパー**です：

- **品質検証**: 静的解析、カバレッジ、フォーマットをチェック
- **問題の記録**: 品質基準未達の場合はDISCOVEREDに追加
- **次サイクルへの橋渡し**: 完璧を求めず、小さなサイクルを回す

「完璧なコードは一度に生まれない。小さな改善を積み重ねる」哲学に基づいています。

### DISCOVEREDの活用

REVIEWフェーズでは、以下をDISCOVEREDに記録します：

1. **テスト失敗**: 失敗したテストケース
2. **静的解析エラー**: PHPStan Level 8で検出されたエラー
3. **カバレッジ不足**: 80%未達のケース
4. **その他の品質問題**: リファクタリング候補等

DISCOVEREDに記録された項目は、次のTDDサイクルで対応します。

### 小さなサイクルを回す

REVIEWフェーズでは、完璧を求めません：

- 品質基準をクリアできなくても、DISCOVEREDに記録してコミット可能
- 次のサイクルで改善することを推奨
- 小さく、頻繁にコミットする方が効率的

---

*このSkillはClaudeSkillsプロジェクトの一部です*
