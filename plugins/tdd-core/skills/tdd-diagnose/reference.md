# tdd-diagnose Reference

詳細情報。必要時のみ参照。

## バグ情報収集

### AskUserQuestion テンプレート

```yaml
questions:
  - question: "バグのカテゴリは？"
    header: "Category"
    options:
      - label: "Regression"
        description: "以前動いていた機能が壊れた"
      - label: "New behavior"
        description: "新しいコードで発生した問題"
      - label: "Intermittent"
        description: "断続的・再現が難しい問題"
      - label: "Performance"
        description: "パフォーマンス劣化"
    multiSelect: false
  - question: "重要度は？"
    header: "Severity"
    options:
      - label: "Blocking development"
        description: "開発が止まっている"
      - label: "Blocking users"
        description: "ユーザーに影響がある"
      - label: "Workaround exists"
        description: "回避策がある"
    multiSelect: false
```

### 自動コンテキスト収集

```bash
# 最近の変更（Regression の場合に有効）
git log --oneline -10
git diff HEAD~5 --name-only
```

## 仮説テンプレート

各仮説は以下のフィールドを含む:

| フィールド | 説明 | 例 |
|-----------|------|-----|
| hypothesis | 原因の仮説 | 「キャッシュの無効化タイミングが不正」 |
| evidence_for | 仮説を支持する証拠 | 「キャッシュ更新後にのみ発生」 |
| evidence_against | 仮説に反する証拠 | 「キャッシュ無効でも低頻度で再現」 |
| verdict | 判定（Confirmed / Rejected / Inconclusive） | Inconclusive |

### 仮説記録フォーマット

```markdown
### Hypothesis H1: [仮説名]
- **hypothesis**: [原因の仮説]
- **evidence_for**: [支持する証拠]
- **evidence_against**: [反する証拠]
- **verdict**: Confirmed / Rejected / Inconclusive
- **confidence**: 0-100
```

## 調査手法

### コード検索

Explore エージェント（Claude Code 組み込み read-only 型）を使用:

- Grep: エラーメッセージ、関連キーワードの検索
- Glob: 関連ファイルの特定
- Read: コードの詳細読解

### ログ分析

```bash
# アプリケーションログ（プロジェクト依存）
tail -100 storage/logs/laravel.log  # Laravel
tail -100 /var/log/app.log          # Generic
```

### Git 履歴調査

```bash
# 特定ファイルの変更履歴
git log --oneline -20 -- path/to/file
# 特定期間の変更
git log --since="2 weeks ago" --oneline
```

## 調査結果の Cycle doc 記録

Step 4 完了後、Cycle doc の Implementation Notes に以下を追記:

```markdown
### Diagnosis Results
- **Root Cause**: [特定された根本原因]
- **Hypotheses Investigated**: H1 (Rejected), H2 (Confirmed), H3 (Rejected)
- **Key Evidence**: [決め手となった証拠]
- **Investigation Mode**: Subagent / Agent Teams
```

## 収束条件

### Subagent モード
- 全 Explore エージェントの調査完了で収束

### Agent Teams モード
- 討論は最大 **2ラウンド**
- 新しい指摘が出なくなった時点で収束
- 2ラウンド超過時は Lead が強制収束

## トリガーキーワード

tdd-init の BLOCK 判定時に以下のキーワードで自動起動:

| キーワード | 言語 |
|-----------|------|
| investigate | EN |
| diagnose | EN |
| debug | EN |
| reproduce | EN |
| 原因調査 | JA |
| バグ調査 | JA |
| 不具合調査 | JA |

**トリガー条件**: BLOCK (risk >= 60) AND キーワード検出 AND ユーザー確認
