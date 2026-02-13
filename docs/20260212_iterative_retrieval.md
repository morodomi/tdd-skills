# 企画: Iterative Retrieval パターン

## 参考元

[affaan-m/everything-claude-code](https://github.com/affaan-m/everything-claude-code) の `skills/iterative-retrieval/`

## 概要

サブエージェントが十分なコンテキストを得られない問題を、段階的な検索リファインで解決するパターン。

```
DISPATCH → EVALUATE → REFINE → LOOP (最大3サイクル)
```

1. **DISPATCH**: サブエージェントに検索タスクを委譲
2. **EVALUATE**: 返された結果の十分性を評価
3. **REFINE**: 不足があればクエリを修正して再検索
4. **LOOP**: 最大3サイクルまで繰り返し

## 現状の課題

tdd-core と redteam-core の両方でサブエージェントを多用している:

- tdd-core: red-worker, green-worker, 各種 reviewer (plan-review, quality-gate)
- redteam-core: recon-agent, 各 attacker, false-positive-filter

サブエージェントはコンテキスト窓が独立しているため、親から渡された情報だけで判断する。検索結果が不十分な場合、精度の低い出力になりうる。

## 実装方針

**既存プラグインに統合**: tdd-core と redteam-core の該当エージェントに適用

### 理由

- パターンであって独立機能ではない
- 適用先が明確（特定のエージェントのプロンプト改善）
- 新プラグイン化するほどの規模ではない

### 適用候補

#### tdd-core

| エージェント | 適用効果 |
|-------------|---------|
| red-worker | テスト対象コードの理解深化 → より的確なテスト |
| green-worker | テスト要件の正確な把握 → 無駄のない実装 |

#### redteam-core

| エージェント | 適用効果 |
|-------------|---------|
| recon-agent | エンドポイント列挙の網羅性向上 |
| false-positive-filter | コンテキスト収集の充実 → 誤検知除外精度向上 |

### 実装イメージ

エージェント定義 (.md) のプロンプトに Iterative Retrieval プロトコルを埋め込む:

```markdown
## Context Retrieval Protocol

1. 初回検索で得られた情報を評価する
2. 以下の場合、検索をリファインする（最大3回）:
   - 対象ファイルの依存関係が不明
   - 関数の呼び出し元/呼び出し先が未確認
   - テスト対象の仕様が曖昧
3. 3回のリファイン後も不十分な場合、不明点を明示して続行する
```

## 検討事項

- リファイン回数の上限（3回が適切か）
- リファインによるレイテンシ増加とのトレードオフ
- 全エージェントに一律適用すべきか、特定エージェントのみか
- 評価基準の具体化（何をもって「十分」とするか）

## 優先度

中〜高。サブエージェントの出力品質に直結する改善で、特に redteam-core の recon-agent と tdd-core の red-worker で効果が見込める。実装コストはプロンプト改善のみで低い。
