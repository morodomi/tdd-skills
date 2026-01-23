---
name: tdd-init
description: 新しいTDDサイクルを開始し、Cycle docを作成する。「新機能を開発したい」「TDDを始めたい」「機能追加」で起動。
---

# TDD INIT Phase

新しいTDDサイクルを開始し、Cycle docを作成する。

## Progress Checklist

```
INIT: STATUS確認 → 環境収集 → 既存確認 → 質問 → リスク判定 → スコープ → 機能名 → Cycle doc → PLAN誘導
```

## 禁止事項

- 実装計画の詳細作成（PLANで行う）
- テストコード作成（REDで行う）
- 実装コード作成（GREENで行う）

## Workflow

### Step 1: プロジェクト状況確認

```bash
cat docs/STATUS.md 2>/dev/null
```

存在しない場合は `tdd-onboard` を推奨。

### Step 2: 環境情報収集

言語バージョン・主要パッケージを収集し、Cycle docのEnvironmentに記録。
詳細コマンド: [reference.md](reference.md)

### Step 3: 既存サイクル確認

```bash
ls -t docs/cycles/*.md 2>/dev/null | head -1
```

進行中のサイクルがあれば継続を推奨。

### Step 4: やりたいことを質問

「どんな機能を実装しますか？」と質問。例: ログイン機能、CSV出力など。

### Step 4.5: リスクスコア判定

ユーザー入力からリスクスコア（0-100）を算出:

| スコア | 判定 | 分岐処理 |
|--------|------|----------|
| 0-29 | PASS | 確認表示のみで自動進行 |
| 30-59 | WARN | スコープ確認（Step 5） |
| 60-100 | BLOCK | リスクタイプ別質問（Step 4.6） |

キーワード別スコアは[reference.md](reference.md)参照。
Cycle docに `Risk: [スコア] ([判定])` を記録。

### Step 4.6: リスクタイプ別質問（BLOCK時のみ）

検出キーワードに応じてAskUserQuestionで詳細確認（複数該当時は全て実行）:

| リスクタイプ | 質問内容 |
|-------------|----------|
| セキュリティ | 認証方式、対象ユーザー、2FA |
| 外部連携 | API認証、エラー処理、レート制限 |
| データ変更 | 既存データ影響、ロールバック |

質問テンプレート詳細: [reference.md](reference.md)
回答はCycle docの `Risk Interview` セクションに記録。

### Step 5: スコープ（Layer）確認

AskUserQuestion でスコープを確認:

| Layer | 説明 | Plugin |
|-------|------|--------|
| Backend | PHP/Python 等 | tdd-php, tdd-python, tdd-flask |
| Frontend | JavaScript/TypeScript | tdd-js, tdd-ts |
| Both | フルスタック | 複数プラグイン |

詳細: [reference.md](reference.md)

### Step 6: 機能名生成→Cycle doc作成

機能名を生成（10-20文字）し、テンプレートからCycle docを作成。
テンプレート: [templates/cycle.md](templates/cycle.md)

### Step 7: 完了→PLAN誘導

`INIT完了` を表示し、PLANフェーズへ誘導。

## Reference

- 詳細: [reference.md](reference.md)
