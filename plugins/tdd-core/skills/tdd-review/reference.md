# tdd-review Reference

SKILL.mdの詳細情報。必要時のみ参照。

## 品質チェック詳細

### 静的解析レベル

**PHP (PHPStan)**:
- Level 0-4: 基本的なチェック
- Level 5-6: 中級
- Level 7-8: 厳格（推奨）

**Python (mypy)**:
- 通常モード: 基本的な型チェック
- strict モード: 厳格な型チェック（推奨）

### カバレッジ計測

**除外対象**:
- 設定ファイル
- マイグレーション
- シーダー

## quality-gate 詳細

4つのエージェントが並行実行:

| エージェント | チェック内容 |
|------------|------------|
| correctness-reviewer | 論理エラー、エッジケース、例外処理 |
| performance-reviewer | O記法、N+1問題、メモリ使用 |
| security-reviewer | 入力検証、認証・認可、SQLi/XSS |
| guidelines-reviewer | コーディング規約、命名規則 |

### 信頼スコア

各エージェントが0-100の信頼スコアを返す:

| スコア | 判定 | アクション |
|--------|------|-----------|
| 80-100 | BLOCK | GREENに戻って修正必須 |
| 50-79 | WARN | 警告確認後、COMMITへ |
| 0-49 | PASS | COMMITへ自動進行 |

## Error Handling

### 品質基準未達

```
品質基準を満たしていません。

対応:
1. 問題をDISCOVEREDに追加
2. REDフェーズに戻ってテスト作成
3. GREENフェーズで修正
4. 再度REVIEWを実行
```

### 静的解析エラー

```
静的解析でエラーが検出されました。

対応:
1. エラー内容を確認
2. 型ヒントの追加または修正
3. 再度解析を実行
```

## DISCOVERED issue 起票

REVIEW の PASS/WARN 後、COMMIT の前に実行する。

### データソース

Cycle doc の `### DISCOVERED` セクションから読み取る。
quality-gate JSON issues[] は直接の入力ソースではない（BLOCK/WARN 判定に使用済み）。

### 判断基準

| 条件 | アクション |
|------|-----------|
| DISCOVERED が空 or `(none)` | スキップ（issue起票なし） |
| 全項目が起票済み（`→ #` 付き） | スキップ |
| 未起票の項目あり | ユーザー確認後に起票 |

### 事前チェック

```bash
gh auth status 2>/dev/null || echo "gh CLI未認証。issue起票をスキップします。"
```

### ユーザー確認ゲート

GitHub issue 作成は外部副作用のため、ユーザー承認を求める:

```
DISCOVERED items found:
1. [項目の要約]

GitHub issue を作成しますか? (Y/n/skip)
```

### issue 起票コマンド

```bash
gh issue create --title "[DISCOVERED] <要約>" --body "$(cat <<'EOF'
## 発見元
- Cycle: docs/cycles/<cycle-doc>.md
- Phase: REVIEW
- Reviewer: <reviewer名 or 手動>

## 内容
<DISCOVERED セクションの記載内容>
EOF
)" --label "discovered"
```

### 重複防止

起票済みの項目は Cycle doc で `→ #<issue番号>` マークが付く:

```markdown
### DISCOVERED
- パフォーマンス問題 → #42
- エラーハンドリング不足 → #43
```

`→ #` が付いている項目は起票をスキップする。
