---
name: tdd-green
description: GREENフェーズ用。REDフェーズで作成したテストを通すための最小限の実装のみを行う。ユーザーが「green」「実装」と言った時、REDフェーズ完了後、または /tdd-green コマンド実行時に使用。過剰な実装を防ぎ、テストを通すことに集中。Laravel向け。
allowed-tools: Read, Write, Edit, Grep, Glob, Bash
---

# TDD GREEN Phase

あなたは現在 **GREENフェーズ** にいます。

## このフェーズの目的

REDフェーズで作成したテストを通すための**最小限の実装**を行うことです。
「動くコード」を優先し、「綺麗なコード」はREFACTORフェーズに委ねます。

## このフェーズでやること

- [ ] 最新のCycle docを検索する（`ls -t docs/cycles/202*.md | head -1`）
- [ ] Cycle docを読み込み、Test ListのWIP項目を確認する
- [ ] 作成済みのテストファイルを確認する
- [ ] テストを実行してエラー内容を確認する
- [ ] Cycle docのImplementation Notesを参照して実装範囲を確認する
- [ ] テストを通すための最小限のコードを実装する（GREEN状態）
- [ ] エッジケース発見時はTest ListのDISCOVEREDセクションに追加（実装はしない）
- [ ] Test ListのWIP項目をDONEに移動する
- [ ] Progress Logに記録（GREEN phase）
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
# 最新のCycle docを検索
ls -t docs/cycles/202*.md 2>/dev/null | head -1

# Cycle docの確認
Read docs/cycles/YYYYMMDD_hhmm_<機能名>.md

# テストファイルの確認
Glob tests/Feature/**/*.php
Glob tests/Unit/**/*.php
```

**Cycle docから以下を確認**：
- YAML frontmatter の `phase` フィールド（RED のはず）
- Test List セクション：
  - 実装中（WIP）: 現在作業中のテストケース
  - 実装予定（TODO）: 次に実装するテストケース
  - 完了（DONE）: 既に完了したテストケース
  - 実装中に気づいた追加テスト（DISCOVERED）: 発見された新しいエッジケース
- Implementation Notes: 実装方針・背景
- Scope Definition: 実装範囲

次に、テストを実行してエラーを確認します：

```bash
# テスト実行
php artisan test
```

エラーメッセージから、何を実装すべきかを判断してください：
- クラスが存在しない → クラスを作成
- メソッドが存在しない → メソッドを追加
- ルートが存在しない → ルート定義を追加
- データベーステーブルが存在しない → マイグレーション実行

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

#### 2.2 Laravel実装順序

以下の順序で実装してください：

1. **マイグレーション**（必要な場合）
   ```bash
   # マイグレーションファイル作成
   php artisan make:migration create_xxx_table

   # マイグレーション実行
   php artisan migrate
   ```

2. **モデル**（必要な場合）
   ```php
   <?php

   namespace App\Models;

   use Illuminate\Database\Eloquent\Model;

   class XXX extends Model
   {
       protected $fillable = ['field1', 'field2'];
   }
   ```

3. **コントローラー**
   ```php
   <?php

   namespace App\Http\Controllers;

   class XXXController extends Controller
   {
       public function index()
       {
           // 最小限の実装
           return view('xxx.index');
       }
   }
   ```

4. **ルート定義**
   ```php
   // routes/web.php または routes/api.php
   Route::get('/xxx', [XXXController::class, 'index'])->name('xxx.index');
   ```

5. **サービスクラス**（必要な場合）
   ```php
   <?php

   namespace App\Services;

   class XXXService
   {
       public function create($data)
       {
           // 最小限の実装
       }
   }
   ```

6. **ビュー**（必要な場合）
   ```blade
   {{-- resources/views/xxx/index.blade.php --}}
   <div>Minimum implementation</div>
   ```

#### 2.3 実装例

**悪い例**（過剰な実装）:
```php
// GREENフェーズでこれは書かない
public function create($data)
{
    // バリデーション（テストされていない）
    $validator = Validator::make($data, [
        'name' => 'required|string|max:255',
        'email' => 'required|email|unique:users',
    ]);

    if ($validator->fails()) {
        throw new ValidationException($validator);
    }

    // トランザクション（テストされていない）
    DB::transaction(function () use ($data) {
        $user = User::create($data);
        event(new UserCreated($user));
        Log::info('User created', ['user_id' => $user->id]);
        return $user;
    });
}
```

**良い例**（最小限の実装）:
```php
// GREENフェーズではこれでOK
public function create($data)
{
    return User::create($data);
}
```

テストが「バリデーションエラーを返す」をテストしている場合のみ、バリデーションを追加します。

### 3. テスト実行フェーズ

実装が完了したら、テストを実行してください：

```bash
# すべてのテストを実行
php artisan test

# 特定のテストのみ実行
php artisan test --filter=XXXTest
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

### 4. DISCOVERED項目の管理

実装中に新しいエッジケースや追加テストが必要だと気づいた場合、Test ListのDISCOVEREDセクションに追加します。

**DISCOVEREDに追加すべき例**:
- 境界値テスト（0件、1件、100件のデータ）
- エラーハンドリング（存在しないIDでアクセス）
- 権限チェック（管理者のみアクセス可能な機能）
- セキュリティテスト（SQLインジェクション、XSS）

**優先度の付け方**:
- 🔴 HIGH: セキュリティリスク、データ破損リスク
- 🟡 MED: ユーザー体験に影響、エラーハンドリング
- 🟢 LOW: エッジケース、パフォーマンス最適化

**記録方法**:

Editツールを使用してCycle docのTest Listを更新：

```markdown
### 実装中に気づいた追加テスト（DISCOVERED）
- 🔴 TC-XX: 権限のないユーザーがアクセスできないこと（HIGH）
  理由: セキュリティリスク
  次サイクルで実装

- 🟡 TC-YY: データが0件の場合の表示（MED）
  理由: ユーザー体験に影響
  次サイクルで実装
```

**重要**: DISCOVEREDに追加した項目は、**今回のサイクルでは実装しません**。次のTDDサイクルでTODOに追加します。

### 5. Test List更新フェーズ

WIP項目をDONEに移動します。

Editツールを使用してCycle docを更新：

**更新前**:
```markdown
### 実装中（WIP）
- [ ] TC-01: ログインページが表示される

### 完了（DONE）
（現在なし）
```

**更新後**:
```markdown
### 実装中（WIP）
（現在なし）

### 完了（DONE）
- [x] TC-01: ログインページが表示される
  実装日: YYYY-MM-DD HH:MM
  実装ファイル: app/Http/Controllers/Auth/LoginController.php, routes/web.php
```

### 6. Progress Log記録フェーズ

Progress Logセクションに記録を追加します。

Editツールを使用してProgress Logに追記：
```markdown
### YYYY-MM-DD HH:MM - GREEN phase
- TC-XX: [テストケース名] の実装完了
  実装ファイル: app/Models/XXX.php, app/Http/Controllers/XXXController.php, routes/web.php
  テスト結果: GREEN（全テスト通過）
- 発見事項:
  - DISCOVERED: TC-YY ([追加テスト内容]) - 優先度🟡MED
- Test List更新（WIP→DONE: TC-XX）
- YAML frontmatter更新（phase: RED → GREEN）
```

### 7. YAML frontmatter更新フェーズ

Cycle docのYAML frontmatterを更新します。

Editツールを使用して更新：
```markdown
---
feature: [機能領域]
cycle: [サイクル識別子]
phase: GREEN  # RED から GREEN に更新
created: YYYY-MM-DD HH:MM
updated: YYYY-MM-DD HH:MM  # 現在日時に更新
---
```

### 8. 完了フェーズ

すべてのテストが通ったら、以下を伝えてください：

```
GREENフェーズが完了しました。

実装したファイル:
- app/Models/XXX.php
- app/Http/Controllers/XXXController.php
- routes/web.php
- database/migrations/YYYY_MM_DD_HHMMSS_create_xxx_table.php

Test List更新:
- WIP → DONE: TC-XX

DISCOVERED項目:
- TC-YY: [追加テスト内容] (優先度🟡MED)

現在のTDDワークフロー:
[完了] INIT (初期化)
[完了] PLAN (計画)
[完了] RED (テスト作成)
[完了] GREEN (実装) ← 現在ここ
[次] REFACTOR (リファクタリング)
[ ] REVIEW (品質検証)
[ ] COMMIT (コミット)

次のステップ:
選択肢:
1. [推奨★★★★★] REFACTORフェーズでコード改善する
   理由: TDDサイクルの標準フロー。コード品質を向上

2. [推奨★★★☆☆] さらにテストを追加して実装する（TODO項目をRED→GREEN）
   理由: 複数機能をまとめて実装したい場合。管理コスト増加

3. [推奨★★☆☆☆] そのままREVIEWに進む（REFACTORスキップ）
   理由: 実装が既に十分綺麗な場合のみ。品質低下リスク

どうしますか？
```

ユーザーが選択1（REFACTORフェーズ）を選んだ場合：

```
================================================================================
自動遷移: 次のフェーズ（REFACTOR）に進みます
================================================================================

REFACTORフェーズ（リファクタリング）を自動的に開始します...
```

その後、Skillツールを使って`tdd-refactor` Skillを起動してください。

## 実装の原則（詳細）

### 最小限の実装とは？

- **テストを通すための最低限のコード**
  - テストが「200 OKを返す」だけなら、空のレスポンスでOK
  - テストが「特定のデータを返す」なら、そのデータをハードコードでもOK
  - テストが「データベースに保存する」なら、`Model::create()`だけでOK

### べた書きの例

```php
// GREENフェーズではこれでOK
if ($user->role === 'admin') {
    return true;
}
if ($user->role === 'editor') {
    return true;
}
if ($user->role === 'viewer') {
    return false;
}

// REFACTORフェーズで改善
return in_array($user->role, ['admin', 'editor']);
```

### ハードコードの例

```php
// GREENフェーズではこれでOK
public function getTaxRate()
{
    return 0.1; // 10%
}

// REFACTORフェーズで改善
public function getTaxRate()
{
    return config('tax.rate');
}
```

## 制約の強制

このフェーズでは、`allowed-tools: Read, Write, Edit, Grep, Glob, Bash` が使用可能です。

REDフェーズと異なり、**実装コードの作成が許可**されています。
また、**Bashツールが許可**されているため、テスト実行やマイグレーション実行が可能です。

もしユーザーが以下のような依頼をした場合は、**丁寧に拒否**してください：

- 「ついでにXXX機能も追加して」→ 「GREENフェーズではテストを通すための最小限の実装のみです。追加機能は別のTDDサイクルで実装しましょう」
- 「このコードをリファクタリングして」→ 「GREENフェーズではリファクタリングを行いません。REFACTORフェーズで改善します」
- 「パフォーマンス最適化して」→ 「GREENフェーズでは最適化を行いません。まずテストを通すことに集中します」

## トラブルシューティング

### テストファイルが見つからない場合

```
テストファイルが見つかりません。
GREENフェーズを開始する前に、REDフェーズを完了してください。

以下を確認してください：
- tests/Feature/ または tests/Unit/ にテストファイルが存在するか
```

### テストがすべて通っている場合

```
すべてのテストがすでに通っています。

GREENフェーズで実装することはありません。
次のREFACTORフェーズに進みますか？
```

### マイグレーション実行エラーの場合

```
マイグレーション実行時にエラーが発生しました：
[エラーメッセージ]

マイグレーションファイルを確認してください。
または、データベース接続設定を確認してください。
```

### 「最小限」の判断が難しい場合

```
最小限の実装の判断基準：

1. テストがチェックしていることだけを実装する
2. テストがチェックしていないことは実装しない
3. 迷ったら「ハードコードで十分か？」と自問する
4. 迷ったら「これはREFACTORフェーズで改善できるか？」と自問する

例：
- テストが「200 OKを返す」のみ → return response()->json();
- テストが「特定のJSONを返す」 → return response()->json(['data' => 'hardcoded']);
- テストが「エラーを返す」 → if ($invalid) { abort(400); }
```

## 参考情報

このSkillは、Laravel開発におけるTDDワークフローの一部です。

- 詳細なワークフロー: README.md参照
- プロジェクト設定: CLAUDE.md参照
- 前のフェーズ: tdd-red Skill（テスト作成）
- 次のフェーズ: tdd-refactor Skill（リファクタリング）

### GREENフェーズの重要性

GREENフェーズは、TDDサイクルの中で最も重要なフェーズの一つです：

- **テストを通す**: 機能が動作することを証明
- **最小限**: 過剰設計を避ける
- **速度**: 素早く動くものを作る

「完璧なコードを書く」のではなく、「動くコードを書く」ことに集中してください。
リファクタリングは次のフェーズで行います。

---

*このSkillはClaudeSkillsプロジェクトの一部です*
