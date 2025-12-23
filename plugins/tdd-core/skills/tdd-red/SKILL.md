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
- [ ] 最新Cycle doc確認
- [ ] Test ListからTODO→WIPに1つ移動
- [ ] エッジケースチェック
- [ ] テストコード作成（失敗するテスト）
- [ ] テスト実行→失敗確認
- [ ] Cycle doc更新
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

### Step 1.5: エッジケースチェック

テスト作成前に以下を確認し、該当するものをTest Listに追加:

| カテゴリ | チェック項目 |
|----------|------------|
| **null/空値** | null、undefined、空文字、空配列 |
| **境界値** | 0、-1、MAX_INT、配列の最初/最後 |
| **不正入力** | 型違い、フォーマット違反、特殊文字 |
| **権限** | 未認証、権限不足、他ユーザーのデータ |
| **外部依存** | API接続失敗、DB接続失敗、タイムアウト |

該当するエッジケースがあれば、Test ListのTODOに追加してから次へ。

### Step 2: テスト作成

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

### Step 3: テスト実行→失敗確認

```bash
php artisan test --filter=TestName  # PHP
pytest tests/test_xxx.py -v          # Python
```

**期待**: テストが**失敗**すること（RED状態）

### Step 4: 完了→GREEN誘導

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
- テストガイド: `agent_docs/testing_guide.md`
