---
name: tdd-plan
description: PLANフェーズ用。最新のCycle doc（docs/cycles/）を読み込み、Scope Definition/Context/Test List/Implementation Notesを記入する。実装計画のみ作成し、実装コードは一切書かない。ユーザーが「plan」「計画」「設計」と言った時、または /tdd-plan コマンド実行時に使用。Laravel向けTDDワークフロー。
allowed-tools: Read, Grep, Glob, Write, Edit, Bash
---

# TDD PLAN Phase

あなたは現在 **PLANフェーズ** にいます。

## このフェーズの目的

最新のCycle docを読み込み、**Scope Definition**、**Context & Dependencies**、**Test List**、**Implementation Notes** を記入して、実装の方向性を明確にすることです。

## このフェーズでやること

- [ ] 最新のCycle doc（`docs/cycles/YYYYMMDD_hhmm_*.md`）を検索する
- [ ] Cycle docを読み込み、「やりたいこと」を確認する
- [ ] Scope Definition（今回の実装範囲、実装しない範囲、変更予定ファイル）を記入する
- [ ] Context & Dependencies（参照ドキュメント、依存する既存機能、関連Issue/PR）を記入する
- [ ] Test List（実装予定テスト、TODO状態）を作成する
- [ ] Implementation Notes（背景、設計方針、Anti-patterns回避）を記入する
- [ ] Progress Logに記録する
- [ ] YAML frontmatter更新（phase: INIT → PLAN）
- [ ] ユーザーにレビューを促す

## このフェーズで絶対にやってはいけないこと

- 実装コードを書くこと（プロダクションコードの作成禁止）
- テストコードを書くこと
- ユーザーの回答を推測すること
- ユーザーの承認なしに次のフェーズに進むこと

## ワークフロー

### 1. 準備フェーズ: 最新のCycle docを検索

最新のCycle docを検索します：

```bash
# 最新のCycle docを検索（時系列順、新しい順）
ls -t docs/cycles/202*.md 2>/dev/null | head -1
```

**ドキュメントが見つかった場合**:

```bash
# Cycle docを読み込む
Read docs/cycles/20251114_1530_XXX.md
```

YAML frontmatterとINITフェーズの内容を確認し、以下を把握：
- feature（機能領域）
- cycle（サイクル識別子）
- phase（現在のフェーズ、INITのはず）
- やりたいこと（Implementation Notesセクション）

**ドキュメントが見つからない場合**:

```
エラー: Cycle docが見つかりません。

まず tdd-init を実行してください。

手順:
1. /tdd-init を実行
2. やりたいことを入力
3. 機能名を確認
4. 再度 /tdd-plan を実行
```

エラーを表示して終了します。

### 2. Scope Definition記入フェーズ

ユーザーと対話しながら、Scope Definitionセクションを埋めます。

重要な原則：
- **推測しない**: ユーザーの回答を待つ
- **明確に質問**: 何を答えて欲しいか具体的に聞く
- **小さく始める**: 目安は変更ファイル10個以下

#### 質問の順序

1. **今回実装する範囲**
   ```
   「今回のサイクルで実装する範囲を教えてください」

   チェックリスト形式で入力してください：
   - ユーザーがログインできる
   - セッションが管理される
   - ログアウトできる
   ```

2. **今回実装しない範囲**
   ```
   「今回実装しない範囲を教えてください」

   例:
   - パスワードリセット（理由: 次サイクルで実装）
   - ソーシャルログイン（理由: 優先度が低い）
   ```

3. **変更予定ファイル**
   ```
   「変更・作成するファイルを教えてください（目安: 10ファイル以下）」

   Laravel向けファイルパス例:
   - app/Models/User.php（編集）
   - app/Http/Controllers/Auth/LoginController.php（新規）
   - routes/web.php（編集）
   - database/migrations/2025_XX_XX_create_sessions_table.php（新規）
   - tests/Feature/Auth/LoginTest.php（新規）
   ```

### 3. Context & Dependencies記入フェーズ

プロジェクトのコンテキストを記録します。

#### 質問の順序

1. **参照ドキュメント**
   ```
   「参照する必要があるドキュメントはありますか？」

   例:
   - docs/overview/architecture.md（レイヤー構造を確認）
   - docs/features/auth/README.md（既存認証設計を参照）
   ```

2. **依存する既存機能**
   ```
   「この機能が依存する既存機能はありますか？」

   例:
   - ユーザーモデル: app/Models/User.php
   - ミドルウェア: app/Http/Middleware/Authenticate.php
   ```

3. **関連Issue/PR**
   ```
   「関連するIssueやPRはありますか？」

   例:
   - Issue #123: ログイン機能の追加
   - PR #456: 認証基盤の準備（マージ済み）
   ```

### 4. Test List記入フェーズ

実装予定のテストケースを列挙します。

#### Laravel固有のテスト設計質問

```
「テストケースを教えてください」

Laravel向けテストファイル構造:
- tests/Feature/: HTTPリクエストをテストする統合テスト
- tests/Unit/: モデル・サービスクラスをテストする単体テスト

例:
【TODO】
- TC-01: ログインフォームが表示される（Feature）
- TC-02: 正しい認証情報でログインできる（Feature）
- TC-03: 不正な認証情報でログインできない（Feature）
- TC-04: Userモデルがハッシュ化されたパスワードを保存する（Unit）
```

テストケースの記録方法：
```markdown
### 実装予定（TODO）
- [ ] TC-01: ログインフォームが表示される
  ファイル: tests/Feature/Auth/LoginTest.php
  種類: Feature Test

- [ ] TC-02: 正しい認証情報でログインできる
  ファイル: tests/Feature/Auth/LoginTest.php
  種類: Feature Test

- [ ] TC-03: Userモデルがハッシュ化されたパスワードを保存する
  ファイル: tests/Unit/Models/UserTest.php
  種類: Unit Test
```

### 5. Implementation Notes記入フェーズ

実装の背景と方針を記録します。

#### Laravel固有の設計質問

1. **背景**
   ```
   「この機能を実装する背景を教えてください」

   例:
   - ユーザーが安全にアプリケーションにアクセスする必要がある
   - セッション管理が現在実装されていない
   ```

2. **設計方針**
   ```
   「設計方針を教えてください」

   Laravel固有の質問:
   - Eloquent Model設計: User::hasMany(Session::class)等
   - マイグレーション設計: sessions テーブル構造
   - Controller設計: LoginController::store()でセッション作成
   - Middleware設計: auth ミドルウェアの使用
   - Bladeテンプレート設計: resources/views/auth/login.blade.php
   - API設計（必要な場合）: POST /login, POST /logout
   ```

3. **Anti-patterns回避**
   ```
   「避けるべきAnti-patternsはありますか？」

   Laravel固有のAnti-patterns:
   - ❌ パスワードを平文で保存
   - ❌ コントローラーに過剰なロジック（Serviceクラスに分離）
   - ❌ Factoryを使わないテストデータ生成
   - ❌ route()関数を使わないルート参照
   - ❌ RefreshDatabaseトレイトの使用（migrate制御アプローチを推奨）
   ```

### 6. Progress Log記録フェーズ

Progress Logセクションに記録を追加します。

Editツールを使用してProgress Logに追記：
```markdown
### YYYY-MM-DD HH:MM - PLAN phase
- Scope Definition記入完了（実装範囲X項目、非実装範囲Y項目、変更予定Zファイル）
- Context & Dependencies記入完了（参照ドキュメントX件、依存機能Y件）
- Test List作成完了（TODO: X件）
- Implementation Notes記入完了（背景、設計方針、Anti-patterns回避）
- YAML frontmatter更新（phase: INIT → PLAN）
```

### 7. YAML frontmatter更新フェーズ

Cycle docのYAML frontmatterを更新します。

Editツールを使用して更新：
```markdown
---
feature: [機能領域]
cycle: [サイクル識別子]
phase: PLAN  # INIT から PLAN に更新
created: YYYY-MM-DD HH:MM
updated: YYYY-MM-DD HH:MM  # 現在日時に更新
---
```

### 8. 完了フェーズ

PLANセクションの記入が完了したら、以下を伝えてください：

```
PLANフェーズが完了しました。

記入内容:
- Scope Definition: 実装範囲X項目、非実装範囲Y項目、変更予定Zファイル
- Context & Dependencies: 参照ドキュメントX件、依存機能Y件
- Test List: TODO X件
- Implementation Notes: 背景、設計方針、Anti-patterns回避を記入

Cycle docを更新しました: docs/cycles/YYYYMMDD_hhmm_<機能名>.md

次のステップ:
1. Cycle docの内容をレビューしてください
2. 修正が必要な場合は、直接ファイルを編集するか、私に修正を依頼してください
3. レビューが完了したら教えてください

現在のTDDワークフロー:
[完了] INIT (初期化)
[完了] PLAN (計画) ← 現在ここ
[次] RED (テスト作成)
[ ] GREEN (実装)
[ ] REFACTOR (リファクタリング)
[ ] REVIEW (品質検証)
[ ] COMMIT (コミット)
```

ユーザーがレビュー完了を伝えたら、以下のメッセージを表示してください：

```
================================================================================
自動遷移: 次のフェーズ（RED）に進みます
================================================================================

REDフェーズ（テスト作成）を自動的に開始します...
```

その後、Skillツールを使って`tdd-red` Skillを起動してください。

## 制約の強制

このフェーズでは、`allowed-tools: Read, Grep, Glob, Write, Edit, Bash` のみ使用可能です。

### ツール使用の明確化（指示の違い）

PLANフェーズでは、ユーザーの指示を以下のように解釈してください：

| 指示の種類 | 例 | 対応 |
|-----------|-----|------|
| 提案して・設計案を出して | 「アーキテクチャを提案して」 | PLANセクションに記載（実装しない） |
| 確認して・レビューして | 「この設計で問題ないか確認して」 | 分析・フィードバックのみ |
| 実装して・作成して | 「モデルを作成して」 | **拒否**: PLANフェーズでは実装不可 |

**理由**: PLANフェーズは「設計・計画」に集中するフェーズ。実装はRED/GREENフェーズで行う。

もしユーザーが以下のような依頼をした場合は、**丁寧に拒否**してください：

- 「モデルを作成して」→ 「PLANフェーズでは実装コードを作成できません。まずPLANセクションを完成させましょう」
- 「テストを書いて」→ 「PLANフェーズではテストを作成できません。これはREDフェーズで行います」
- 「ファイルを作成して」→ 「PLANフェーズではファイル作成はできません。Cycle docに記載しておきましょう」

## トラブルシューティング

### ユーザーが「わからない」と回答した場合

```
理解しました。このセクションは後で埋めることもできます。

選択肢:
1. [推奨★★★★★] スキップして次に進む（後でREDフェーズ前に埋める）
   理由: 全体像を把握してから詳細を決める方が効率的。95%のケースでこれが最適

2. [推奨★★★☆☆] 例を示して一緒に考える
   理由: サンプルがあると考えやすい場合に有効。時間がかかる

3. [推奨★★☆☆☆] このセクションを空欄にして完了する
   理由: とりあえず進めたい場合。後で埋め忘れるリスク

どうしますか？
```

### ユーザーが曖昧な回答をした場合

```
もう少し具体的に教えていただけますか？

例えば、以下のような形で答えていただけると助かります：

【Laravel向け例】
実装範囲:
- ユーザーがメールアドレスとパスワードでログインできる
- ログイン後、ダッシュボードにリダイレクトされる
- ログアウト機能が使える

変更予定ファイル:
- app/Http/Controllers/Auth/LoginController.php（新規）
- routes/web.php（編集）
- tests/Feature/Auth/LoginTest.php（新規）
```

### Cycle docが見つからない場合

```
Cycle docが見つかりません。
まず tdd-init を実行してください。

手順:
1. /tdd-init を実行
2. やりたいことを入力
3. 機能名を確認
4. 再度 /tdd-plan を実行
```

## Laravel固有の品質基準

このSkillはLaravel向けです。

**デフォルトの品質基準**:
- テストカバレッジ目標: **90%以上**
- 静的解析: **PHPStan Level 8**（最高レベル）
- コーディング規約: **Laravel Pint (PSR-12)**
- TDD徹底

**テストケースの形式**:
- テストファイル名規則: `XXXTest.php`
- テストディレクトリ: `tests/Feature/`, `tests/Unit/`
- #[Test]属性形式を推奨
- Factory必須（`User::factory()->create()`）
- route()関数必須（`route('profile.show')`）
- RefreshDatabase禁止（migrate制御アプローチ使用）
- DatabaseTransactions非推奨（結合テストで問題発生）

**実装範囲の記述形式**:
- Laravelディレクトリ構造に従う
- `app/Http/Controllers/`, `app/Models/`, `app/Services/`, `routes/`, `database/migrations/`, `resources/views/` 等

## 参考情報

このSkillは、Laravel開発におけるTDDワークフローの一部です。

- 詳細なワークフロー: README.md参照
- プロジェクト設定: CLAUDE.md参照
- 前のフェーズ: tdd-init Skill（初期化）
- 次のフェーズ: tdd-red Skill（テスト作成）

### PLANフェーズの重要性

PLANフェーズは、TDDサイクルの**方向性を決める**フェーズです：

- **スコープの明確化**: 何をやるか、やらないかを明確に
- **コンテキストの把握**: 既存機能との関連を理解
- **テスト設計**: 実装前にテストケースを洗い出す
- **設計方針の合意**: Laravel固有の設計パターンを選択

「良い計画は成功の半分」という原則に基づいています。

---

*このSkillはClaudeSkillsプロジェクトの一部です*
