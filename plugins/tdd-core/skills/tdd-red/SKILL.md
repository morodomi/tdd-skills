---
name: tdd-red
description: テストコードを作成し、失敗することを確認する。PLANの次フェーズ。「テスト書いて」「red」で起動。
---

# TDD RED Phase

テストコードを作成し、失敗することを確認する。

## Progress Checklist

コピーして進捗を追跡:

```
RED Progress:
- [ ] Cycle doc確認、TODO→WIPに移動
- [ ] カテゴリ別チェック
- [ ] テストコード作成
- [ ] テスト実行→失敗確認
- [ ] GREENフェーズへ誘導
```

## 禁止事項

- 実装コード作成（GREENで行う）
- テストを通すための実装
- 複数テストの同時作成（1つずつ）

## Workflow

### Step 1: Cycle doc確認

```bash
ls -t docs/cycles/*.md 2>/dev/null | head -1
```

Test ListのTODOから1つ選択してWIPに移動。

### Step 2: カテゴリ別チェック

該当カテゴリに応じて具体的な観点を確認:

| カテゴリ | チェック項目 |
|----------|------------|
| **境界値** | 0、-1、MAX_INT、最小/最大長 |
| **エッジケース** | null、undefined、空文字、空配列 |
| **異常系** | 型違い、フォーマット違反、存在しないID |
| **権限** | 未認証、権限不足、他ユーザーのデータ |
| **外部依存** | API失敗、DB失敗、タイムアウト |
| **セキュリティ** | SQLi、XSS、パストラバーサル |

追加すべきケースがあればTest ListのTODOに追加。

### Step 3: テスト作成

Given/When/Then形式でテストを作成:

```php
#[Test]
public function user_can_login(): void
{
    // Given: 有効なユーザーが存在
    // When: 正しい認証情報でログイン
    // Then: ダッシュボードにリダイレクト
}
```

### Step 4: テスト実行→失敗確認

```bash
php artisan test --filter=TestName  # PHP
pytest tests/test_xxx.py -v          # Python
```

**期待**: テストが**失敗**すること（RED状態）

### Verification Gate

| 結果 | 判定 | アクション |
|------|------|-----------|
| テスト失敗 | PASS | GREENへ自動進行 |
| テスト成功 | BLOCK | テスト条件を見直して再試行 |

### Step 5: 完了→GREEN誘導

```
================================================================================
RED完了
================================================================================
テスト作成完了。失敗を確認しました。
次: GREENフェーズ（最小実装）
================================================================================
```

## Reference

- 詳細: [reference.md](reference.md)
- テストガイド: `.claude/rules/testing-guide.md`
