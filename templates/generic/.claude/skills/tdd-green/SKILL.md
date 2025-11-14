---
name: tdd-green
description: GREENフェーズ用。REDフェーズで作成したテストを通すための最小限の実装のみを行う。ユーザーが「green」「実装」と言った時、REDフェーズ完了後、または /tdd-green コマンド実行時に使用。過剰な実装を防ぎ、テストを通すことに集中。
allowed-tools: Read, Write, Edit, Grep, Glob, Bash
---

# TDD GREEN Phase

あなたは現在 **GREENフェーズ** にいます。

## このフェーズの目的

REDフェーズで作成したテストを通すための**最小実装**（最小限の実装）を行うことです。
「動くコード」を優先し、「綺麗なコード」はREFACTORフェーズに委ねます。

## このフェーズでやること

- [ ] 最新のTDD Cycle ドキュメントを検索する（`ls -t docs/cycles/202*.md | head -1`）
- [ ] Cycle docを読み込み、Test ListのWIP項目を確認する
- [ ] 作成済みのテストファイルを確認する
- [ ] テストを実行してエラー内容を確認する
- [ ] Cycle docのImplementation Notesを参照して実装範囲を確認する
- [ ] テストを通すための最小限のコードを実装する（GREEN状態）
- [ ] エッジケース発見時はTest ListのDISCOVEREDセクションに追加（実装はしない）
- [ ] Test ListのWIP項目をDONEに移動する
- [ ] Progress Logに記録（GREEN phase - 実装ファイル、テスト結果、発見事項）
- [ ] YAML frontmatterのphaseを"GREEN"に、updatedを更新
- [ ] テストが通ることを確認する
- [ ] 次のフェーズ（REFACTOR）を案内する

## このフェーズで絶対にやってはいけないこと

- 過剰な実装を行うこと（テストにない機能の追加）
- リファクタリングを行うこと（REFACTORフェーズで行う）
- パフォーマンス最適化を行うこと（REFACTORフェーズで行う）
- 完璧なコードを書こうとすること

## ワークフロー

### 1. 準備フェーズ

まず、以下を確認してください：

```bash
# 最新のTDD Cycle ドキュメントを検索
ls -t docs/cycles/202*.md 2>/dev/null | head -1

# Cycle docの確認
Read docs/cycles/YYYYMMDD_hhmm_<機能名>.md
```

**Cycle docから以下を確認**：
- YAML frontmatter の `phase` フィールド（現在のフェーズ）
- Test List セクション：
  - 実装中（WIP）: 現在作業中のテストケース
  - 実装予定（TODO）: 次に実装するテストケース
  - 完了（DONE）: 既に完了したテストケース
- Implementation Notes: 実装方針・背景
- Scope Definition: 実装範囲

**テストファイルの確認**：
```bash
# テストファイルの確認
Glob tests/**/*.[your test extension]
```

次に、テストを実行してエラーを確認します：

```bash
# テスト実行
[your test command]
```

エラーメッセージから、何を実装すべきかを判断してください：
- クラスが存在しない → クラスを作成
- メソッドが存在しない → メソッドを追加
- 関数が存在しない → 関数を定義
- モジュールが存在しない → モジュールを作成

### 2. 実装フェーズ

#### 2.1 実装の原則

**最重要**: テストを通すための**最小限のコード**のみを書いてください。

以下の原則に従ってください：

1. **最小限**
   - テストを通すための最低限のコードのみ
   - 不要な機能は追加しない
   - テストされていない機能は実装しない

2. **単純**
   - 複雑なロジックは書かない
   - 早期リターンやハードコードも許容
   - 「動けばOK」の精神

3. **べた書き許容**
   - DRY（Don't Repeat Yourself）は気にしない
   - コピペも許容
   - 共通化はREFACTORフェーズで

4. **ハードコード許容**
   - 定数化しなくてOK
   - マジックナンバーも許容
   - 設定ファイル化はREFACTORフェーズで

#### 2.2 実装順序

以下の順序で実装してください：

1. **モデル/エンティティ**（必要な場合）
   ```[your language]
   # 最小限のクラス定義
   class User:
       def __init__(self, name):
           self.name = name
   ```

2. **ビジネスロジック**
   ```[your language]
   # 最小限のメソッド実装
   def update_profile(user, data):
       user.name = data['name']
       return user
   ```

3. **コントローラー/ハンドラー**（必要な場合）
   ```[your language]
   # 最小限のエンドポイント
   def profile_update():
       return {"status": "success"}
   ```

4. **ルーティング/URL設定**（必要な場合）
   ```[your language]
   # ルート定義
   app.route('/profile', methods=['PUT'])(profile_update)
   ```

#### 2.3 実装例

**悪い例**（過剰な実装）:
```[your language]
# GREENフェーズでこれは書かない
def create_user(data):
    # バリデーション（テストされていない）
    if not data.get('name'):
        raise ValueError('Name is required')

    # トランザクション（テストされていない）
    with transaction():
        user = User.create(data)
        send_email(user)  # 通知（テストされていない）
        log_event(user)   # ログ（テストされていない）
        return user
```

**良い例**（最小限の実装）:
```[your language]
# GREENフェーズではこれでOK
def create_user(data):
    return User.create(data)
```

テストが「バリデーションエラーを返す」をテストしている場合のみ、バリデーションを追加します。

### 3. テスト実行フェーズ

実装が完了したら、テストを実行してください：

```bash
# すべてのテストを実行
[your test command]

# 特定のテストのみ実行
[your specific test command]
```

**テストが通った場合**:
```
すべてのテストが通りました！

GREENフェーズ完了です。
次のREFACTORフェーズでコードを改善しましょう。
```

**テストが失敗した場合**:
```
テストが失敗しました。

エラーメッセージを確認してください：
[エラーメッセージ]

不足している実装を追加します。
```

エラーメッセージから、追加で必要な実装を判断して修正してください。

### 3.5. テストリストの更新フェーズ

#### テストリストアプローチ（Kent Beckの原典に基づく）

GREENフェーズで実装中に以下のような気づきがあった場合、**今すぐ対応せず、Test Listに記録**します：

- 別の機能の必要性
- バグの発見
- 新しいテストケースの必要性
- エッジケースの発見
- リファクタリングが必要な箇所

#### 手順

1. **Cycle docを開く**
   ```bash
   Read docs/cycles/YYYYMMDD_hhmm_<機能名>.md
   ```

2. **Test List の「実装中に気づいた追加テスト（DISCOVERED）」に追記**
   ```markdown
   ### 実装中に気づいた追加テスト（DISCOVERED）
   - [ ] TC-XX: [気づいた内容]（GREEN中に気づいた - Priority: [High/Medium/Low]）
   ```

3. **今の実装に戻る**

#### 例

実装中に「ユーザー削除のエラーハンドリングがない」と気づいた場合：

```markdown
### 実装中に気づいた追加テスト（DISCOVERED）
- [ ] TC-05: ユーザー削除：エラーハンドリング（GREEN中に気づいた - Priority: Medium）
```

#### 緊急度の判断

**今すぐ対応すべきか？**

1. **緊急（今のタスクに影響）** → 今すぐ対応
   - 今のテストが通らない原因
   - セキュリティ脆弱性
   - データ損失の可能性

2. **重要（関連性高い）** → Test Listに追加（Priority: High）
   - 今実装中の機能の一部
   - 密接に関連するリファクタリング

3. **通常（関連性低い）** → Test Listに追加（Priority: Medium/Low）
   - 別機能のバグ
   - 一般的なリファクタリング
   - ドキュメント整備

#### 重要な原則

**今のタスクに集中**:
- 気づきを記録したら、今の実装に戻る
- 新しいタスクは次のサイクルで対応
- GREENフェーズは「テストを通す」ことに集中

### 4. 完了フェーズ

すべてのテストが通ったら、以下の手順でCycle docを更新してください：

#### ステップ1: Test Listを更新

Cycle docの Test List セクションを更新します：

```markdown
### 実装中（WIP）
（現在なし）

### 完了（DONE）
- [x] TC-01: [完了したテストケース]
```

**手順**:
1. WIP項目をDONEセクションに移動
2. チェックボックスを `[x]` に変更
3. 次に実装するテストケースがあればWIPに移動

#### ステップ2: Progress Logを追記

Cycle docの Progress Log セクションに記録を追加します：

```markdown
### YYYY-MM-DD HH:MM - GREEN phase
- 実装ファイル:
  - [実装したファイル1]
  - [実装したファイル2]
- テスト結果: すべて成功（GREEN状態）
- 発見事項:
  - [気づいた内容1]（Test Listに追加済み）
  - [気づいた内容2]（Test Listに追加済み）
```

#### ステップ3: YAML frontmatterを更新

```markdown
---
feature: [機能領域]
cycle: [サイクル識別子]
phase: GREEN
created: YYYY-MM-DD HH:MM
updated: YYYY-MM-DD HH:MM  ← 現在日時に更新
---
```

#### ステップ4: 完了メッセージを表示

```
GREENフェーズが完了しました。

実装したファイル:
- [実装ファイルのリスト]

テスト結果: すべて成功（GREEN状態）

発見事項（Test Listに追加済み）:
- [気づいた内容のリスト]

Cycle doc更新内容:
- Test List: WIP → DONE に移動
- Progress Log: GREEN phase の記録を追加
- YAML frontmatter: phase=GREEN, updated更新

現在のTDDワークフロー:
[完了] INIT (初期化)
[完了] PLAN (計画)
[完了] RED (テスト作成)
[完了] GREEN (実装) ← 現在ここ
[次] REFACTOR (リファクタリング)
[ ] REVIEW (品質検証)
[ ] DOC (ドキュメント更新)
[ ] COMMIT (コミット)

次のステップ:
1. [推奨★★★★★] REFACTORフェーズに進む
   理由: コードの改善・DRY化・最適化を行う。テストを保ちながら品質向上

2. [推奨★★★☆☆] Test Listの次のテストケースに取り組む（REDフェーズへ）
   理由: Test ListにTODO項目が残っている場合のみ。追加機能を実装

3. [推奨★☆☆☆☆] REVIEWフェーズに進む（リファクタリング不要な場合）
   理由: コードが既に十分シンプルで改善不要な場合のみ

どのステップに進みますか？

================================================================================
推奨: 次のフェーズ（REFACTOR）に進みます
================================================================================

REFACTORフェーズ（リファクタリング）を自動的に開始します...
```

完了メッセージを表示したら、Skillツールを使って`tdd-refactor` Skillを起動してください。

## 実装の原則（詳細）

### 最小限の実装とは？

- **テストを通すための最低限のコード**
  - テストが「200 OKを返す」だけなら、空のレスポンスでOK
  - テストが「特定のデータを返す」なら、そのデータをハードコードでもOK
  - テストが「データを保存する」なら、最小限の保存処理のみ

### べた書きの例

```[your language]
# GREENフェーズではこれでOK
if user.role == 'admin':
    return True
if user.role == 'editor':
    return True
if user.role == 'viewer':
    return False

# REFACTORフェーズで改善
return user.role in ['admin', 'editor']
```

### ハードコードの例

```[your language]
# GREENフェーズではこれでOK
def get_tax_rate():
    return 0.1  # 10%

# REFACTORフェーズで改善
def get_tax_rate():
    return config.get('tax.rate')
```

## 制約の強制

このフェーズでは、`allowed-tools: Read, Write, Edit, Grep, Glob, Bash` が使用可能です。

REDフェーズと異なり、**実装コードの作成が許可**されています。
また、**Bashツールが許可**されているため、テスト実行が可能です。

もしユーザーが以下のような依頼をした場合は、**丁寧に拒否**してください：

- 「ついでにXXX機能も追加して」→ 「GREENフェーズではテストを通すための最小限の実装のみです。追加機能は別のTDDサイクルで実装しましょう」
- 「このコードをリファクタリングして」→ 「GREENフェーズではリファクタリングを行いません。REFACTORフェーズで改善します」
- 「パフォーマンス最適化して」→ 「GREENフェーズでは最適化を行いません。まずテストを通すことに集中します」

## トラブルシューティング

### Cycle docが見つからない場合

```
エラー: TDD Cycle ドキュメントが見つかりません。

まず tdd-init を実行してください。

手順:
1. /tdd-init を実行
2. やりたいことを入力
3. 機能名を確認
4. /tdd-plan を実行してPLANを完成させる
5. /tdd-red を実行してテストを作成
6. 再度 /tdd-green を実行
```

### Test ListにWIP項目がない場合

```
⚠️ 警告: Test ListにWIP（実装中）項目がありません。

選択肢:
1. [推奨★★★★★] TODO項目を1つWIPに移動してから開始
   理由: Kent Beckのテストリストアプローチに基づく標準的な進め方

2. [推奨★★☆☆☆] Test Listを確認して適切な項目を選ぶ
   理由: TODO項目が複数ある場合、優先度を判断してから開始

3. [推奨★☆☆☆☆] すべて完了済みなら次のフェーズへ
   理由: 実装するテストケースが残っていない場合

どうしますか？
```

### テストファイルが見つからない場合

```
テストファイルが見つかりません。
GREENフェーズを開始する前に、REDフェーズを完了してください。

以下を確認してください：
- テストディレクトリにテストファイルが存在するか
- Cycle docのTest List（TODO/WIP）に項目があるか
```

### テストがすべて通っている場合

```
すべてのテストがすでに通っています。

GREENフェーズで実装することはありません。

選択肢:
1. [推奨★★★★★] Test Listを確認（次のテストケースがあるか）
   理由: 追加のテストケースがあれば、REDフェーズに戻る

2. [推奨★★★★☆] REFACTORフェーズに進む
   理由: コードの改善・DRY化が必要な場合

3. [推奨★★★☆☆] REVIEWフェーズに進む
   理由: すべてのテストケースが完了し、リファクタリング不要な場合

どうしますか？
```

### 「最小限」の判断が難しい場合

```
最小限の実装の判断基準：

1. テストがチェックしていることだけを実装する
2. テストがチェックしていないことは実装しない
3. 迷ったら「ハードコードで十分か？」と自問する
4. 迷ったら「これはREFACTORフェーズで改善できるか？」と自問する

例：
- テストが「200 OKを返す」のみ → return success_response()
- テストが「特定のデータを返す」 → return {"data": "hardcoded"}
- テストが「エラーを返す」 → if invalid: raise Error()
```

## プロジェクト固有のカスタマイズ

このSkillファイルはフレームワーク非依存の汎用版です。
プロジェクト固有の要件がある場合は、以下の項目をカスタマイズしてください：

1. **実装の推奨パターン**
   - フレームワーク固有のコーディング規約
   - ディレクトリ構造の推奨
   - 命名規則

2. **テスト実行コマンド**
   - フレームワーク固有のテストコマンド
   - カバレッジ取得方法
   - 特定のテストファイルのみ実行する方法

3. **データベース/データストア操作**
   - ORM/ODMの使用方法
   - マイグレーションの実行方法
   - テストデータのセットアップ

4. **デプロイメント/ビルド**
   - 必要なビルドステップ
   - 環境変数の設定

例: フレームワーク固有のカスタマイズ

ここに言語・フレームワーク固有の実装順序を追加してください：

```markdown
### 実装順序
1. [Your database setup/migration]
2. [Your model/data layer]
3. [Your business logic/controller]
4. [Your routing/view setup]
```

## 参考情報

このSkillは、TDDワークフローの一部です。

- 詳細なワークフロー: README.md参照
- プロジェクト設定: CLAUDE.md参照
- 前のフェーズ: tdd-red Skill（テスト作成）
- 次のフェーズ: tdd-refactor Skill（リファクタリング）

### GREENフェーズの重要性

GREENフェーズは、TDDサイクルの中で最も重要なフェーズの一つです：

- **テストを通す**: 機能が動作することを証明
- **最小限**: 過剰設計を避ける（YAGNI原則）
- **速度**: 素早く動くものを作る

「完璧なコードを書く」のではなく、「動くコードを書く」ことに集中してください。
リファクタリングは次のフェーズで行います。

### テストリストアプローチ（Kent Beckの原典）

このフレームワークは、Kent Beckの原典に基づく「テストリスト」アプローチを採用しています。

**TDDの正式な5ステップ**:
1. **テストリストを書く**（シナリオをリストアップ）
2. テストリストから1つ選んで実行可能なテストコードに変換
3. プロダクトコードを変更してテストを成功させる **（その過程で気づいたことはテストリストに追加する）** ← GREENフェーズ
4. 必要に応じてリファクタリング
5. テストリストが空になるまで2に戻る

**重要なポイント**:
- 実装中に気づいたことは**今すぐ対応せず、Test Listに追加して後で対応**
- GREENフェーズは「テストを通す」ことに集中
- 気づきはTest ListのDISCOVEREDセクションに記録

参考: [Kent Beckのテスト駆動開発の定義 - t-wadaのブログ](https://t-wada.hatenablog.jp/entry/canon-tdd-by-kent-beck)

### ドキュメント構造

GREENフェーズでは、以下のドキュメントを使用します：

**Cycle doc** (`docs/cycles/YYYYMMDD_hhmm_<機能名>.md`):
- YAML frontmatter: phase, created, updated
- Scope Definition: 実装範囲
- Context & Dependencies: 依存関係
- Test List: TODO/WIP/DISCOVERED/DONE
- Implementation Notes: 実装方針
- Progress Log: フェーズごとの進捗記録

**更新内容**:
- Test List: WIP → DONE に移動
- Progress Log: GREEN phase の記録を追加
- YAML frontmatter: phase=GREEN, updated更新

---

*このSkillはClaudeSkillsプロジェクトの一部です*
