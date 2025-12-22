---
name: tdd-red
description: PLANの次。「テスト書いて」で起動。テストのみ作成、実装は書かない。
allowed-tools: Read, Write, Edit, Grep, Glob, Bash
---

# TDD RED Phase

テストコードを作成し、失敗することを確認する。

## Checklist

1. [ ] 最新Cycle doc確認
2. [ ] Test ListからTODO→WIPに1つ移動
3. [ ] テストコード作成（失敗するテスト）
4. [ ] テスト実行→失敗確認
5. [ ] Cycle doc更新
6. [ ] GREENフェーズへ誘導

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

### Step 2: テスト作成

Given/When/Then形式でテストを作成:

```php
#[Test]
public function user_can_login_with_valid_credentials(): void
{
    // Given: 有効なユーザーが存在
    $user = User::factory()->create();

    // When: 正しい認証情報でログイン
    $response = $this->post(route('login'), [...]);

    // Then: ダッシュボードにリダイレクト
    $response->assertRedirect(route('dashboard'));
}
```

### Step 3: テスト実行→失敗確認

```bash
# PHP/Laravel
php artisan test --filter=TestName

# Python
pytest tests/test_xxx.py -v
```

**期待**: テストが**失敗**すること（RED状態）

### Step 4: Cycle doc更新

```markdown
### WIP
- [ ] TC-01: [テストケース名] ← 作成完了、RED確認済み
```

### Step 5: 完了→GREEN誘導

```
================================================================================
RED完了
================================================================================
テスト作成完了。失敗を確認しました。

次: GREENフェーズ（最小実装）
================================================================================
```

tdd-green Skillを起動。

## Reference

- 詳細ワークフロー: `reference.md`
- テストガイド: `agent_docs/testing_guide.md`
