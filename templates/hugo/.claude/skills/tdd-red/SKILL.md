---
name: tdd-red
description: REDフェーズ用（Hugo）。期待するページ構造を定義する。content/やlayouts/の実装は行わない。ユーザーが「red」「構造定義」と言った時、PLANフェーズ完了後、または /tdd-red コマンド実行時に使用。最新のCycle doc（docs/cycles/YYYYMMDD_hhmm_*.md）のTest ListからTODOを1つWIPに移動してページ構造を定義。Hugo向け。
allowed-tools: Read, Write, Edit, Grep, Glob, Bash
---

# TDD RED Phase

あなたは現在 **REDフェーズ** にいます。

## このフェーズの目的

**期待するページ構造を定義**し、実装の要件を明確にすることです。
Hugo では「テストコード」の代わりに「期待するページ構造・URL」を定義します。

## このフェーズでやること（Hugo）

- [ ] 最新のCycle docを検索する（`ls -t docs/cycles/202*.md | head -1`）
- [ ] Cycle docを読み込む
- [ ] Test ListのTODO項目を1つWIPに移動する
- [ ] 期待するページ構造を Cycle doc に記述する
  - URL パス（例: `/posts/my-first-post/`）
  - ページタイプ（single / list / home）
  - 期待するセクション・コンテンツ
  - 必要なテンプレート（layouts/）
- [ ] 現在この構造が存在しないことを確認（RED状態）
- [ ] Progress Logに記録（RED phase）
- [ ] YAML frontmatterのphaseを"RED"に、updatedを更新
- [ ] 選択肢を提示（星5つ形式）

## このフェーズで絶対にやってはいけないこと

- content/ にMarkdownを作成すること
- layouts/ にテンプレートを作成すること
- ユーザーの承認なしに実装を始めること
- ページを表示可能にすること（GREEN状態にすること）

## ワークフロー

### 1. 準備フェーズ

まず、以下を確認してください：

```bash
# 最新のCycle docを検索
ls -t docs/cycles/202*.md 2>/dev/null | head -1

# Cycle docの読み込み
Read docs/cycles/YYYYMMDD_hhmm_<機能名>.md

# テストディレクトリ構造の確認
Glob tests/**/*.[your test file extension]
```

**ドキュメントが見つからない場合**:

```
エラー: Cycle docが見つかりません。

まず tdd-init と tdd-plan を実行してください。

手順:
1. /tdd-init を実行
2. /tdd-plan を実行してPLANセクションを完成させる
3. 再度 /tdd-red を実行
```

Cycle docから以下の情報を抽出してください：
- YAML frontmatter（feature, cycle, phase, created, updated）
- 「## Test List（テストリスト）」セクション
  - 実装予定（TODO）
  - 実装中（WIP）
  - 実装中に気づいた追加テスト（DISCOVERED）
  - 完了（DONE）

### 2. Test List更新フェーズ

#### 2.1 TODO項目を1つ選択

Test ListのTODO項目から、最初の1つを選択します。

**選択例**：
```
Test Listの実装予定（TODO）:
- [ ] TC-01: ログインページが表示される
- [ ] TC-02: 正しい認証情報でログインできる
- [ ] TC-03: 誤った認証情報でログインできない

次に実装するテストケースを選んでください（TC-01を推奨）：
```

ユーザーが選択したテストケース（例: TC-01）を次に進めます。

#### 2.2 WIPに移動

選択したTODO項目をWIPセクションに移動します。

Editツールを使用してCycle docを更新：

**更新前**:
```markdown
### 実装予定（TODO）
- [ ] TC-01: ログインページが表示される
- [ ] TC-02: 正しい認証情報でログインできる
- [ ] TC-03: 誤った認証情報でログインできない

### 実装中（WIP）
（現在なし）
```

**更新後**:
```markdown
### 実装予定（TODO）
- [ ] TC-02: 正しい認証情報でログインできる
- [ ] TC-03: 誤った認証情報でログインできない

### 実装中（WIP）
- [ ] TC-01: ログインページが表示される
```

### 3. テスト作成フェーズ

#### 3.1 テストコードを作成

選択したテストケースのテストコードを作成します。

**作成前の確認**：
```
これから以下のテストを作成します：
- tests/XXX/XXXTest.[ext]
  - TC-01: ログインページが表示される

よろしいですか？
```

ユーザーの承認を得てから作成してください。

#### 3.2 テストコード構造（テストファースト原則）

REDフェーズでは、**テストファースト**の原則に従い、実装より先にテストを書きます。

テストは以下の基本構造に従ってください：

**基本テンプレート（Arrange/Act/Assert）**:

```[your language]
# Arrange（準備）
# テストに必要なデータやオブジェクトを準備

# Act（実行）
# テスト対象のコードを実行

# Assert（検証）
# 期待通りの結果が得られたか検証
```

**Given/When/Then形式のコメント推奨**:

```[your language]
def test_user_can_update_profile():
    # Given: ログイン済みユーザーがいる
    [準備処理]

    # When: プロフィールを更新する
    [実行処理]

    # Then: 成功メッセージが表示される
    [検証処理]

    # And: データが更新されている
    [追加検証処理]
```

**重要な原則**:
- テストの意図を明確にするため、Given/When/Then/Andコメントを含める
- Arrange/Act/Assert構造を意識する
- 1つのテストケースは1つの関心事をテストする

### 4. テスト実行フェーズ

テストを作成したら、テスト実行を促してください：

```
テストを作成しました。

次のステップ:
1. テストを実行してください:
   [your test command]
   例: pytest, npm test, vendor/bin/phpunit 等

2. テストが失敗することを確認してください
   （これは正常です。まだ実装がないためです）

3. 失敗メッセージを確認してください:
   - 存在しないクラスやメソッドのエラー
   - 未定義の関数のエラー
   - 等

これらのエラーが、次のGREENフェーズで実装すべき内容を示しています。
```

**重要**: この時点では、テストが失敗するのが正しい状態です。実装がないためです。

### 5. Progress Log更新フェーズ

テスト実行を確認したら、Progress Logを更新します。

Editツールを使用してCycle docを更新：

```markdown
## Progress Log（進捗ログ）

### YYYY-MM-DD HH:MM - INIT phase
- TDDサイクルドキュメント作成
- Scope定義準備完了
- Context確認完了
- Test List作成準備完了

### YYYY-MM-DD HH:MM - RED phase
- TC-01: テストファイル作成（tests/XXX/XXXTest.[ext]）
- テスト実行: FAILED（期待通り）
- エラー内容: [クラス/メソッドが存在しない等]
```

### 6. YAML frontmatter更新フェーズ

phaseを"RED"に、updatedを現在日時に更新します。

Editツールを使用してCycle docのYAML frontmatterを更新：

**更新前**:
```yaml
---
feature: auth
cycle: login-implementation
phase: PLAN
created: 2025-11-14 15:30
updated: 2025-11-14 15:45
---
```

**更新後**:
```yaml
---
feature: auth
cycle: login-implementation
phase: RED
created: 2025-11-14 15:30
updated: 2025-11-14 16:00
---
```

### 7. 選択肢提示フェーズ

テスト作成が完了したら、次のアクションを選択肢で提示してください：

```
REDフェーズが完了しました。

作成したテストファイル:
- tests/XXX/XXXTest.[ext]
  - TC-01: [テストケース名]

現在のTDDワークフロー:
[完了] INIT (初期化)
[完了] PLAN (計画)
[完了] RED (テスト作成) ← 現在ここ
[次] GREEN (実装)
[ ] REFACTOR (リファクタリング)
[ ] REVIEW (品質検証)
[ ] DOC (ドキュメント更新)
[ ] COMMIT (コミット)

次のアクションを選んでください:

1. [推奨★★★★★] GREENフェーズに進む（このテストを通す実装を作成）
   理由: TDDサイクルを継続。テストを通す最小限の実装を作成。95%のケースでこれが最適

2. [推奨★★★★☆] 追加のテストを作成（RED継続）
   理由: 関連テストをまとめて作成したい場合。Test ListのTODOから次を選択

3. [推奨★★☆☆☆] テストを修正（RED継続）
   理由: テストに問題がある場合のみ。慎重に判断

どうしますか？
```

ユーザーが選択1を選んだ場合、Skillツールを使って`tdd-green` Skillを起動してください。
選択2の場合、Test Listの次のTODO項目を選択して、再度ステップ2から実施します。
選択3の場合、ユーザーと対話してテストを修正します。

## 制約の強制

このフェーズでは、`allowed-tools: Read, Write, Edit, Grep, Glob, Bash` のみ使用可能です。

もしユーザーが以下のような依頼をした場合は、**丁寧に拒否**してください：

- 「コントローラーを実装して」→ 「REDフェーズでは実装コードを作成できません。これはGREENフェーズで行います」
- 「テストを通して」→ 「REDフェーズではテストを失敗させたままにします。GREENフェーズで実装してテストを通します」
- 「関数を実装して」→ 「REDフェーズでは実装できません。Cycle docに記載されていることを確認し、GREENフェーズで実装します」

## トラブルシューティング

### Cycle docが見つからない場合

```
Cycle docが見つかりません。
REDフェーズを開始する前に、INIT と PLAN フェーズを完了してください。

以下を確認してください：
- docs/cycles/YYYYMMDD_hhmm_*.md が存在するか（ls -t docs/cycles/202*.md で確認）
- Cycle docに「## Test List（テストリスト）」セクションがあるか
- Test Listに実装予定（TODO）の項目があるか
```

### Test ListのTODOが空の場合

```
Test Listの実装予定（TODO）が空です。

選択肢:
1. PLANフェーズに戻って、Test Listを見直す
2. すべてのテストが完了している場合は、REVIEWフェーズに進む

どうしますか？
```

### ユーザーが「どんなテストを書けばいいかわからない」と言った場合

```
Cycle docの「## Test List（テストリスト）」セクションに記載されたテストケースを作成します。

もしTest Listのテストケースが不明確な場合は、PLANフェーズに戻って見直しましょうか？

または、以下のような質問で具体化できます：
- この機能で、ユーザーは何ができるべきですか？
- どんな入力を受け付けますか？
- どんな出力が期待されますか？
- どんなエラーケースがありますか？
```

### テスト実行でエラーが出た場合（想定外）

```
テスト実行でエラーが発生しました。

REDフェーズでは、以下のエラーが期待されます：
- クラスが存在しない
- メソッドが存在しない
- 関数が未定義

その他のエラー（構文エラー、インポートエラー等）が出た場合は、
テストコードを修正してください。

エラー内容を教えてください：
```

## プロジェクト固有のカスタマイズ

このSkillファイルはフレームワーク非依存の汎用版です。
プロジェクト固有の要件がある場合は、以下の項目をカスタマイズしてください：

1. **テストフレームワーク固有の記述**
   - インポート文（例: `import pytest`, `import unittest`）
   - テストクラス/関数の命名規則
   - アサーション記法（例: `self.assertEqual()`, `$this->assertEquals()`）

2. **テストデータの作成方法**
   - ファクトリーの使用方法（例: Laravel Factory、pytest fixtures）
   - モックの作成方法
   - テストデータベースのセットアップ

3. **テストディレクトリ構造**
   - 統合テスト/単体テストの配置場所
   - ファイル名規則（例: `XXXTest.php`, `test_XXX.py`）

4. **テスト実行コマンド**
   - フレームワーク固有のコマンド（例: `php artisan test`, `pytest`, `npm test`）

例: テストフレームワーク別のカスタマイズ

ここに言語・テストフレームワーク固有のテストコード例を追加してください：


[your test framework] では以下のように記述します：

```
// Given: [前提条件]
// When: [アクション]
// Then: [期待される結果]
```

## REDフェーズの特徴

### 1テストずつの作成

REDフェーズでは、Test ListのTODO項目を**1つずつ**WIPに移動してテストを作成します。

**理由**:
- フォーカスを保つ（1つのテストに集中）
- 進捗を可視化（WIP/DONEで状況を把握）
- 柔軟性（途中で方針変更しやすい）

### Progress Logによる記録

各フェーズでProgress Logに記録することで、以下が実現します：

- **トレーサビリティ**: いつ何をしたか追跡可能
- **デバッグ支援**: 問題が起きた時の調査が容易
- **学習**: 過去の判断を振り返れる

### YAML frontmatterによる状態管理

phaseフィールドで現在のフェーズを管理：

- INIT: 初期化完了
- PLAN: 計画完了
- RED: テスト作成中
- GREEN: 実装中
- REFACTOR: リファクタリング中
- REVIEW: 品質検証中
- DOC: ドキュメント更新中
- DONE: サイクル完了

updatedフィールドで最終更新日時を記録します。

## 参考情報

このSkillは、TDDワークフローの一部です。

- 詳細なワークフロー: README.md参照
- プロジェクト設定: CLAUDE.md参照
- 前のフェーズ: tdd-plan Skill（計画作成）
- 次のフェーズ: tdd-green Skill（実装）

### Given/When/Then/Andコメントについて

テストの意図を明確にするため、各テストケースに構造化コメントを含めてください：

- **Given**: 前提条件（テスト実行前の状態）
- **When**: アクション（何をするか）
- **Then**: 期待結果（何が起きるべきか）
- **And**: 追加の期待結果

これにより、テストの可読性が向上し、レビューしやすくなります。

---

*このSkillはClaudeSkillsプロジェクトの一部です*
