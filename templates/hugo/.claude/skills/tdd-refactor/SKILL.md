---
name: tdd-refactor
description: REFACTORフェーズ用（Hugo）。GREENフェーズで作成したテンプレートをリファクタリングし、コード品質を改善する。パーシャル分割、ショートコード化、DRY原則の適用を行う。ユーザーが「refactor」「リファクタリング」と言った時、GREENフェーズ完了後、または /tdd-refactor コマンド実行時に使用。Hugo向け。
allowed-tools: Read, Write, Edit, Grep, Glob, Bash
---

# TDD REFACTOR Phase

あなたは現在 **REFACTORフェーズ** にいます。

## このフェーズの目的

GREENフェーズで作成したテンプレートをリファクタリングし、コード品質を改善することです。
**ビルド成功を維持しながら**、動作を変えずに内部構造をより良いコードに改善します。

## このフェーズでやること（Hugo）

- [ ] 最新のTDDドキュメントを検索する（`ls -t docs/cycles/202*.md | head -1`）
- [ ] ビルドが通っていることを確認する（`hugo build`）
- [ ] TDDドキュメントの品質基準を確認する
- [ ] リファクタリングを行う:
  - パーシャル分割（`layouts/partials/` に共通部品を抽出）
  - ショートコード化（再利用可能なコンポーネント）
  - DRY原則の適用（重複コードの削除）
  - テンプレート整理（適切なディレクトリ構造）
- [ ] 各変更後にビルドを実行する（`hugo build`）
- [ ] 次のフェーズ（REVIEW）を案内する

## このフェーズで絶対にやってはいけないこと

- テストを変更すること（機能追加ではない）
- 新機能を追加すること（別のTDDサイクルで行う）
- テストを失敗させたままにすること
- 品質チェックをスキップすること
- **依頼された変更のみ実装する**: スコープ外の改善はDISCOVEREDに記録し、今は実装しない
- **ファイルを読まずに変更を提案すること**: 必ず対象ファイルをReadしてから実装する

### なぜこれらの制約があるか（理由）

- **テスト変更禁止**: リファクタリングは「動作を変えずに構造を改善」すること。テストが変わると動作も変わる
- **依頼された変更のみ**: リファクタリングの範囲を明確にし、意図しない変更を防ぐため
- **ファイルを読む義務**: 既存コードのパターンや設計意図を理解してからリファクタリングするため

## ワークフロー

### 1. 準備フェーズ

まず、テストがすべて通っていることを確認してください：

```bash
# テスト実行
[your test command]
```

すべてのテストが通っていない場合：
```
REFACTORフェーズを開始できません。
すべてのテストが通っていることが前提条件です。

GREENフェーズに戻って、テストを通してください。
```

次に、TDDドキュメントの品質基準を確認します：

```bash
# 最新のTDDドキュメントを検索
ls -t docs/202*.md 2>/dev/null | head -1

# TDDドキュメントの読み込み
Read docs/YYYYMMDD_hhmm_<機能名>.md
```

品質基準を確認：
- テストカバレッジ目標
- 静的解析ツールとレベル
- その他の品質基準

### 2. リファクタリングフェーズ

以下の順序でリファクタリングを行ってください：

#### 2.1 重複コード削除（DRY原則）

**目的**: Don't Repeat Yourself - 同じコードを繰り返さない

**手順**:
1. 重複コードを探す
2. 共通メソッド/関数を抽出
3. テストを実行して確認

**例**:

悪い例（重複あり）:
```[your language]
def create_user(data):
    if not data.get('name') or not data['name']:
        raise ValidationError('Name is required')
    return User.create(data)

def update_user(user_id, data):
    if not data.get('name') or not data['name']:
        raise ValidationError('Name is required')
    return User.find(user_id).update(data)
```

良い例（共通化）:
```[your language]
def validate_name(data):
    if not data.get('name') or not data['name']:
        raise ValidationError('Name is required')

def create_user(data):
    validate_name(data)
    return User.create(data)

def update_user(user_id, data):
    validate_name(data)
    return User.find(user_id).update(data)
```

**各変更後にテストを実行**:
```bash
[your test command]
```

#### 2.2 マジックナンバー/文字列の定数化

**目的**: 意味を明確にし、変更を容易にする

**手順**:
1. マジックナンバーや文字列を探す
2. 適切な定数に置き換える
3. テストを実行して確認

**例**:

悪い例（マジックナンバー）:
```[your language]
def get_tax_rate():
    return 0.1  # 10%

def get_discount_rate(user_type):
    if user_type == 'premium':
        return 0.2
    return 0.05
```

良い例（定数化）:
```[your language]
TAX_RATE = 0.1
DISCOUNT_RATE_PREMIUM = 0.2
DISCOUNT_RATE_STANDARD = 0.05

def get_tax_rate():
    return TAX_RATE

def get_discount_rate(user_type):
    if user_type == 'premium':
        return DISCOUNT_RATE_PREMIUM
    return DISCOUNT_RATE_STANDARD
```

**各変更後にテストを実行**:
```bash
[your test command]
```

#### 2.3 長いメソッドの分割

**目的**: 単一責任の原則、可読性向上

**手順**:
1. 長いメソッド/関数（20行以上が目安）を探す
2. 論理的な単位で分割
3. テストを実行して確認

**例**:

悪い例（長いメソッド）:
```[your language]
def process(data):
    # バリデーション
    if not data.get('name'):
        raise ValidationError('Name is required')

    # データ加工
    data['name'] = data['name'].strip()
    data['email'] = data['email'].lower()

    # 保存
    user = User.create(data)

    # 通知送信
    send_email(user.email, 'Welcome')

    # ログ記録
    log('User created', user_id=user.id)

    return user
```

良い例（分割）:
```[your language]
def process(data):
    validate(data)
    data = sanitize(data)
    user = save(data)
    send_notification(user)
    log_creation(user)
    return user

def validate(data):
    if not data.get('name'):
        raise ValidationError('Name is required')

def sanitize(data):
    data['name'] = data['name'].strip()
    data['email'] = data['email'].lower()
    return data

def save(data):
    return User.create(data)

def send_notification(user):
    send_email(user.email, 'Welcome')

def log_creation(user):
    log('User created', user_id=user.id)
```

**各変更後にテストを実行**:
```bash
[your test command]
```

#### 2.4 複雑な条件式の簡潔化

**目的**: 可読性向上、保守性向上

**手順**:
1. 複雑な条件式を探す
2. 意味のあるメソッド/関数に抽出
3. テストを実行して確認

**例**:

悪い例（複雑な条件）:
```[your language]
if user.role == 'admin' or (user.role == 'editor' and user.permissions.has('publish')):
    return True
```

良い例（メソッド抽出）:
```[your language]
if can_publish(user):
    return True

def can_publish(user):
    return user.role == 'admin' or (user.role == 'editor' and user.permissions.has('publish'))
```

**各変更後にテストを実行**:
```bash
[your test command]
```

#### 2.5 ネーミング改善

**目的**: コードの意図を明確にする

**手順**:
1. 不明確な名前を探す
2. 意味のある名前に変更
3. テストを実行して確認

**例**:

悪い例（不明確な名前）:
```[your language]
def get(id):
    u = User.find(id)
    d = u.data
    return d
```

良い例（明確な名前）:
```[your language]
def get_user_data(user_id):
    user = User.find(user_id)
    user_data = user.data
    return user_data
```

**各変更後にテストを実行**:
```bash
[your test command]
```

### 3. 品質チェックフェーズ

リファクタリングが完了したら、品質チェックツールを実行してください：

#### 3.1 静的解析実行

```bash
# 静的解析実行
[your static analysis command]
# 例: mypy, pylint, phpstan, eslint 等
```

**期待結果**:
- エラー: 0件
- 最高レベル

**エラーがある場合**:
- エラー内容を確認
- 型定義を追加
- null安全性を改善
- 再度実行

#### 3.2 コード整形実行

```bash
# コード整形実行
[your code formatter command]
# 例: black, prettier, pint 等
```

**期待結果**:
- コーディング規約準拠
- コードが整形される

#### 3.3 テストカバレッジ確認

```bash
# テストカバレッジ確認
[your coverage command]
# 例: pytest --cov, coverage, php artisan test --coverage 等
```

**期待結果**:
- カバレッジ: 90%以上（またはTDDドキュメントで指定された目標）

**目標未達の場合**:
```
警告: テストカバレッジが目標未達です。
現在: XX%
目標: XX%

以下の対応を検討してください：
1. 未テストのコードを確認
2. 必要に応じてテストを追加（次のTDDサイクルで）
3. または品質基準を見直し
```

### 4. 完了フェーズ

すべての品質チェックが完了したら、以下を伝えてください：

```
REFACTORフェーズが完了しました。

リファクタリング内容:
- DRY原則適用: XX箇所
- 定数化: XX箇所
- メソッド分割: XX箇所
- 条件式簡潔化: XX箇所
- ネーミング改善: XX箇所

品質チェック結果:
- 静的解析: エラー 0件
- コード整形: 完了
- テストカバレッジ: XX%

現在のTDDワークフロー:
[完了] INIT (初期化)
[完了] PLAN (計画)
[完了] RED (テスト作成)
[完了] GREEN (実装)
[完了] REFACTOR (リファクタリング) ← 現在ここ
[次] REVIEW (品質検証)
[ ] COMMIT (コミット)

次のステップ:
1. すべてのテストが通っていることを最終確認してください
2. REVIEWフェーズでは、コード全体のレビューと最終チェックを行います

================================================================================
自動遷移: 次のフェーズ（REVIEW）に進みます
================================================================================

REVIEWフェーズ（品質検証）を自動的に開始します...
```

完了メッセージを表示したら、Skillツールを使って`tdd-review` Skillを起動してください。

## リファクタリングの原則

### 重要な原則

1. **テストを維持する**
   - 各変更後にテストを実行
   - テストが失敗したら変更を戻す
   - テストが通り続けることが最優先

2. **小さく変更する**
   - 一度に大きな変更をしない
   - 1つの改善を実施 → テスト → 次の改善
   - 段階的に改善

3. **必要最小限**
   - 過剰なリファクタリングはしない
   - テストが通れば十分
   - 完璧を求めない

4. **可読性を優先**
   - パフォーマンス最適化は後回し
   - まずは読みやすいコード
   - 保守しやすいコード

### やらないこと

- **機能追加**: 新しい機能は別のTDDサイクルで
- **テスト変更**: リファクタリングは実装コードのみ
- **大規模な変更**: アーキテクチャ変更は別途計画
- **過剰最適化**: 早すぎる最適化は悪

## 制約の強制

このフェーズでは、`allowed-tools: Read, Write, Edit, Grep, Glob, Bash` が使用可能です。

GREENフェーズと同様に、**実装コードの変更**と**Bashツールの使用**が許可されています。

もしユーザーが以下のような依頼をした場合は、**丁寧に拒否**してください：

- 「新しい機能XXXを追加して」→ 「REFACTORフェーズでは機能追加を行いません。別のTDDサイクルで実装しましょう」
- 「テストを変更して」→ 「REFACTORフェーズではテストを変更しません。実装コードのみをリファクタリングします」
- 「全体的にアーキテクチャを見直して」→ 「大規模な変更は別途計画が必要です。REFACTORフェーズでは必要最小限の改善のみ行います」

## トラブルシューティング

### テストが失敗した場合

```
リファクタリング中にテストが失敗しました。

失敗したテスト:
[テスト名]

エラーメッセージ:
[エラー内容]

対応:
1. 最後の変更を取り消します
2. より小さい単位で変更を試みます
3. または、この変更はスキップします
```

### 静的解析でエラーが多数発生する場合

```
静的解析でエラーが発生しました。
エラー件数: XX件

段階的に修正します：
1. まずは重要なエラーから修正
2. 各修正後にテストを実行
3. 修正が困難な場合はTDDドキュメントの品質基準を見直し
```

### テストカバレッジが目標に達しない場合

```
テストカバレッジ: XX% (目標: XX%)

このREFACTORフェーズでは、既存のテストを維持します。
カバレッジ向上は次のTDDサイクルで行いましょう。

ただし、以下を確認します：
- リファクタリングでカバレッジが下がっていないか
- 下がっている場合は原因を調査
```

## プロジェクト固有のカスタマイズ

このSkillファイルはフレームワーク非依存の汎用版です。
プロジェクト固有の要件がある場合は、以下の項目をカスタマイズしてください：

1. **静的解析ツール**
   - 使用するツール（mypy, pylint, phpstan, eslint等）
   - レベル設定
   - 実行コマンド

2. **コード整形ツール**
   - 使用するツール（black, prettier, pint等）
   - 設定ファイル
   - 実行コマンド

3. **テストカバレッジツール**
   - カバレッジ取得方法
   - レポート形式
   - 目標値

4. **コーディング規約**
   - プロジェクト固有の規約
   - 命名規則
   - ディレクトリ構造

例: Python/pytest向けカスタマイズ
```markdown
### Python品質チェック
- 静的解析: `mypy .`
- コード整形: `black .`
- カバレッジ: `pytest --cov=. --cov-report=term`
```

例: 言語・フレームワーク固有のカスタマイズ

ここに言語固有の品質ツールを追加してください：

```markdown
### 品質チェック
- 静的解析: [your static analysis tool]
- コード整形: [your code formatter]
- カバレッジ: [your coverage tool]
```

## 参考情報

このSkillは、TDDワークフローの一部です。

- 詳細なワークフロー: README.md参照
- プロジェクト設定: CLAUDE.md参照
- 前のフェーズ: tdd-green Skill（実装）
- 次のフェーズ: tdd-review Skill（品質検証）

### REFACTORフェーズの重要性

REFACTORフェーズは、TDDサイクルの中で「綺麗なコード」を作る唯一のフェーズです：

- **テスト維持**: 動作を保証しながら改善
- **品質向上**: 可読性、保守性を向上
- **技術的負債の削減**: 早期に問題を解決

「動くコード」（GREEN）から「綺麗なコード」（REFACTOR）への昇華が、このフェーズの目的です。

### SOLID原則

リファクタリング時に意識すべき設計原則：

- **S**ingle Responsibility: 単一責任の原則
- **O**pen/Closed: 開放/閉鎖の原則
- **L**iskov Substitution: リスコフの置換原則
- **I**nterface Segregation: インターフェース分離の原則
- **D**ependency Inversion: 依存性逆転の原則

### Code Smells（コードの悪臭）

リファクタリングが必要な兆候：

- 重複コード
- 長いメソッド
- 大きなクラス
- 長いパラメータリスト
- 複雑な条件分岐
- マジックナンバー/文字列

---

*このSkillはClaudeSkillsプロジェクトの一部です*
