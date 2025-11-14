---
description: Multi-agent code review with parallel execution (Correctness/Performance/Security). Run 3 subagents in parallel, then synthesize results with priority categorization (Critical/Important/Optional).
---

# Multi-Agent Code Review

このコマンドは、3つの観点（Correctness/Performance/Security）で並行レビューを実行し、結果を統合します。

---

## 重要: 並行実行の指示

**Step 1の3つのレビューは、必ず1つのメッセージで並行実行してください**。

Claude Codeは、1つのメッセージで複数のTaskツールを呼び出すことで並行実行できます。
3つのTask呼び出しを同時に行ってください。

---

## Step 1: 並行レビュー実行（3つ同時）

以下の3つのレビューを**並行実行**してください（1メッセージで3つのTask呼び出し）:

### Task 1: Correctness Review

**Taskツール呼び出し**:
- **subagent_type**: `general-purpose`
- **description**: "Correctness review"
- **model**: `haiku`（軽量タスク）
- **prompt**:
```
git diffを実行し、以下の観点でコードレビューを実施してください:

## レビュー観点

1. **論理エラーとバグ**
   - 条件分岐の誤り
   - ループの無限ループリスク
   - null/undefined処理の欠如

2. **エッジケース処理**
   - 空配列・空文字列
   - 境界値（0, -1, MAX等）
   - 例外処理の欠如

3. **要件への適合性**
   - 変更が意図した機能を実現しているか
   - テストケースで網羅されているか

4. **コードの一貫性**
   - 既存コードとのスタイル一致
   - 命名規則の遵守

## 出力形式

問題を発見した場合、以下の形式で出力:

### [問題タイトル]
- **ファイル**: path/to/file.ext:行番号
- **問題**: 具体的な問題の説明
- **影響**: どのような問題が発生するか
- **修正案**: 具体的な修正コード

問題がない場合: "問題なし"
```

---

### Task 2: Performance Review（Gemini使用）

**Taskツール呼び出し**:
- **subagent_type**: `general-purpose`
- **description**: "Performance review using Gemini"
- **model**: `haiku`
- **prompt**:
```
git diffを実行し、Bashツールでgemini CLIを使ってパフォーマンスレビューを実施してください:

## 手順

1. 差分を一時ファイルに保存:
   ```bash
   git diff > /tmp/review_diff.txt
   ```

2. Gemini CLIでパフォーマンスレビュー実行:
   ```bash
   gemini -p "以下のコード変更をパフォーマンス観点でレビューしてください:

   ## レビュー観点
   - アルゴリズム効率（O記法で評価）
   - データベースクエリ最適化（N+1問題、インデックス等）
   - メモリ使用パターン（メモリリーク、不要なコピー）
   - 潜在的なボトルネック
   - 非同期処理最適化（Promise/async-awaitの適切な使用）

   ## 出力形式
   問題を発見した場合:
   ### [問題タイトル]
   - **ファイル**: path/to/file.ext:行番号
   - **問題**: パフォーマンス上の問題
   - **影響**: 計測可能な影響（レスポンス時間、メモリ使用量等）
   - **改善案**: 具体的な最適化コード

   問題がない場合: 問題なし

   ## コード差分
   $(cat /tmp/review_diff.txt)" 2>&1
   ```

3. Geminiの出力を整形して返す

## エラーハンドリング

- geminiコマンドが失敗した場合: "Performance review skipped (Gemini CLI unavailable)"
- 差分が空の場合: "No changes to review"

## 出力形式

Geminiのレビュー結果をそのまま返してください。
エラーの場合はエラーメッセージを返してください。
```

---

### Task 3: Security Review

**Taskツール呼び出し**:
- **subagent_type**: `general-purpose`
- **description**: "Security review"
- **model**: `haiku`
- **prompt**:
```
git diffを実行し、以下のセキュリティ観点でレビューしてください:

## レビュー観点

1. **入力検証の欠如**
   - ユーザー入力のサニタイズ
   - バリデーションの不足

2. **認証・認可の問題**
   - 認証チェックの欠如
   - 権限チェックの不足

3. **SQLインジェクションリスク**
   - 生SQL文字列結合
   - パラメータ化されていないクエリ

4. **XSS脆弱性**
   - エスケープ処理の欠如
   - innerHTML等の危険な操作

5. **機密データの露出**
   - ログへの機密情報出力
   - エラーメッセージでの情報漏洩

6. **依存関係の脆弱性**
   - 既知の脆弱性を持つパッケージ
   - 古いバージョンの使用

## 出力形式

問題を発見した場合、以下の形式で出力:

### [脆弱性タイトル]
- **ファイル**: path/to/file.ext:行番号
- **脆弱性**: 具体的なセキュリティリスク
- **影響**: 攻撃シナリオ
- **対策**: 具体的な修正コード
- **優先度**: Critical/High/Medium/Low

問題がない場合: "セキュリティ上の問題なし"
```

---

## Step 2: 結果統合

3つのレビュー結果を受け取ったら、以下のTaskで統合してください:

### Task 4: Synthesize Results

**Taskツール呼び出し**:
- **subagent_type**: `general-purpose`
- **description**: "Synthesize review results"
- **model**: `sonnet`（複雑な統合処理）
- **prompt**:
```
以下の3つのレビュー結果を統合し、優先度付きサマリーを作成してください:

## 入力

**Correctness Review結果**:
[Task 1の結果をここに貼り付け]

**Performance Review結果**:
[Task 2の結果をここに貼り付け]

**Security Review結果**:
[Task 3の結果をここに貼り付け]

## タスク

1. 全ての問題を収集
2. 優先度で分類
3. 重複を除去
4. 競合する推奨事項を明記

## 出力形式

以下の形式で優先度付きサマリーを作成:

---
# Code Review Results

## 🔴 Critical（即座に対応必須）

セキュリティ脆弱性やシステム障害を引き起こす問題:

1. **[問題タイトル]**
   - ファイル: path/to/file.ext:行番号
   - 問題: ...
   - 対策: ...

（Criticalがない場合: "Critical問題なし"）

---

## 🟡 Important（早めに対応推奨）

パフォーマンス問題やメンテナンス性の改善:

1. **[問題タイトル]**
   - ファイル: path/to/file.ext:行番号
   - 問題: ...
   - 改善案: ...

（Importantがない場合: "Important問題なし"）

---

## 🟢 Optional（時間があれば対応）

コードスタイル改善やリファクタリング提案:

1. **[問題タイトル]**
   - ファイル: path/to/file.ext:行番号
   - 提案: ...

（Optionalがない場合: "Optional問題なし"）

---

## 競合する推奨事項

（複数のレビューで矛盾する推奨がある場合のみ記載）

---

## サマリー

- Critical: X件
- Important: Y件
- Optional: Z件
- 総問題数: N件
```

---

## Step 3: ユーザーへの提示

統合結果をユーザーに提示し、以下を促してください:

```
Code Review完了しました。

## 次のアクション

以下の質問に答えてください:

1. **Critical問題**（X件）をすべてチケット化しますか？
   - Y: すべてチケット化
   - N: 個別に選択

2. **Important問題**（Y件）のうち、どれをチケット化しますか？
   - 番号で指定（例: 1,3,5）
   - all: すべて
   - skip: スキップ

3. **Optional問題**（Z件）で対応したいものはありますか？
   - 番号で指定（例: 2）
   - skip: スキップ

## チケット作成方法

選択後、以下でチケット作成できます:

```bash
# GitHub Issue
gh issue create --title "fix: [問題タイトル]" --body "詳細: ..."

# または、DISCOVEREDに記録（TDDサイクル内の場合）
# Cycle docのDISCOVEREDセクションに追記
```

## DISCOVEREDへの記録（TDDサイクル内の場合）

最新のCycle doc（`docs/cycles/YYYYMMDD_hhmm_*.md`）が存在する場合、
DISCOVEREDセクションに以下を追記:

```markdown
### 実装中に気づいた追加テスト（DISCOVERED）

**Code Review指摘事項**:
- 🔴 [Critical問題タイトル] - 次サイクルで対応（HIGH）
- 🟡 [Important問題タイトル] - 次サイクルで対応（MED）
- 🟢 [Optional問題タイトル] - バックログ（LOW）
```
```

---

## 実装上の注意

- Step 1の3つのTaskは、**必ず1メッセージで並行実行**してください
- Task 2（Performance Review）でgeminiコマンドが失敗しても、他のレビューは継続してください
- 結果統合時は、空の結果（"問題なし"）も含めて処理してください

---

*このコマンドは全プロジェクト共通で使用できます*
