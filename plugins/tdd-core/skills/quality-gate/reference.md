# Quality Gate - Reference

SKILL.mdの詳細情報。必要時のみ参照。

## エージェント詳細

### correctness-reviewer

正確性を検証:
- 論理エラー（条件分岐、ループ、計算式）
- エッジケース（null/空値、境界値、不正入力）
- 例外処理（try-catch、リソース解放）

### performance-reviewer

パフォーマンスを検証:
- アルゴリズム効率（O記法、不要ループ）
- N+1問題（DBクエリ、API呼び出し）
- メモリ使用（大量データ、メモリリーク）

### security-reviewer

セキュリティを検証:
- 入力検証（サニタイズ、型チェック）
- 認証・認可（アクセス制御、セッション）
- SQLi/XSS（インジェクション対策）
- 機密データ（パスワード、APIキー）

### guidelines-reviewer

ガイドライン準拠を検証:
- コーディング規約（PSR-12、PEP8等）
- 命名規則（変数名、関数名の一貫性）
- ドキュメント（コメント、docstring）

## 信頼スコア詳細

各エージェントが0-100の信頼スコアを返す:

| スコア | 判定 | アクション |
|--------|------|-----------|
| 80-100 | BLOCK | GREENに戻って修正必須 |
| 50-79 | WARN | 警告確認後、COMMITへ |
| 0-49 | PASS | COMMITへ自動進行 |

## 出力形式

各エージェントの出力:

```json
{
  "confidence": 85,
  "issues": [
    {
      "severity": "critical",
      "message": "SQLインジェクションの脆弱性",
      "file": "src/UserController.php",
      "line": 42,
      "suggestion": "プレースホルダを使用してください"
    }
  ]
}
```

## 結果統合

最大スコアで判定:

```
================================================================================
quality-gate 完了
================================================================================
スコア: 85 (BLOCK)

correctness-reviewer: 30 (PASS)
performance-reviewer: 40 (PASS)
security-reviewer: 85 (BLOCK)
  - SQLインジェクションの脆弱性 (src/UserController.php:42)
guidelines-reviewer: 25 (PASS)

重大な問題が検出されました。GREENに戻って修正してください。
================================================================================
```
