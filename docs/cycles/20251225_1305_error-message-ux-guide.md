# エラーメッセージUXガイド

## Status: DONE

## INIT

### Scope Definition

tdd-plan に「エラーメッセージ設計」のガイドを追加:
1. SKILL.md に reference.md への参照リンクを1行追加
2. reference.md にエラーメッセージ設計セクションを追加

### Target Structure

```
plugins/tdd-core/skills/tdd-plan/
├── SKILL.md       # 修正: reference.md への参照追加（1行）
└── reference.md   # 修正: エラーメッセージ設計セクション追加
```

### Out of Scope

- 新規エージェント作成（過剰）
- plan-review への統合（シンプルに保つ）
- 他スキルへの適用（tdd-plan のみ）

### Environment

#### Scope
- Layer: tdd-core（言語非依存）
- Plugin: tdd-core
- Version: v1.4.1

#### Runtime
- Claude Code Plugins

## PLAN

### 設計方針

tdd-plan スキルにエラーメッセージ設計ガイドを追加。
異常系テストケース作成時に参照することで、ユーザーフレンドリーなエラーメッセージを設計できるようにする。

### 変更ファイル

| ファイル | 変更内容 | 行数目安 |
|----------|---------|---------|
| `tdd-plan/SKILL.md` | Step 5 に参照リンク追加 | +1行 |
| `tdd-plan/reference.md` | エラーメッセージ設計セクション追加 | +30行 |

### reference.md 追加内容

```markdown
## エラーメッセージ設計

### 原則

1. ポジティブフレーミング: 否定形より肯定形
2. ユーザーを責めない: システム視点で説明
3. 次のアクションを提示: 何をすべきか明示
4. 技術用語を避ける: ユーザー視点の言葉

### パターン表

| 避ける | 推奨 |
|--------|------|
| 0件見つかりました | 該当するデータがありません |
| 入力が間違っています | 有効な形式で入力してください |
| 権限がありません | この操作には管理者権限が必要です |
| エラーが発生しました | 処理を完了できませんでした。再度お試しください |
```

## Test List

### TODO

（なし）

### WIP

（なし）

### DONE

- [x] TC-01: SKILL.md Step 5 に reference.md への参照がある
- [x] TC-02: reference.md にエラーメッセージ設計セクションがある
- [x] TC-03: 原則が4つ定義されている
- [x] TC-04: パターン表に4つ以上の例がある（6例）

## Notes

- 「0件見つかりました」vs「見つかりませんでした」のような心理的配慮
- ポジティブフレーミングの原則をパターン化
- PLANフェーズでTest List作成時に参照できるようにする
