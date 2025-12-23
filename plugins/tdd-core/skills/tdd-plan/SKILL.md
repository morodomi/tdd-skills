---
name: tdd-plan
description: 実装計画を作成し、Test Listを定義する。INITの次フェーズ。「設計して」「計画して」で起動。
---

# TDD PLAN Phase

実装計画を作成し、Cycle docのPLANセクションを更新する。

## Progress Checklist

コピーして進捗を追跡:

```
PLAN Progress:
- [ ] Cycle doc確認（Environment含む）
- [ ] 最新ドキュメント確認（必要な場合のみ）
- [ ] ユーザーと実装計画を対話で作成
- [ ] PLANセクションを更新
- [ ] Test Listを作成
- [ ] plan-review（推奨）
- [ ] REDフェーズへ誘導
```

## 禁止事項

- 実装コード作成（GREENで行う）
- テストコード作成（REDで行う）
- ユーザー承認なしの次フェーズ移行

## Workflow

### Step 1: Cycle doc確認

```bash
ls -t docs/cycles/*.md 2>/dev/null | head -1
```

Environmentセクションでバージョン情報を把握。

### Step 2: 最新ドキュメント確認（必要な場合）

メジャーバージョンや破壊的変更が疑われる場合、WebSearch/WebFetchで確認。

### Step 3: 実装計画の対話

アーキテクチャ、依存関係、品質基準をユーザーに確認。

### Step 4: PLANセクション更新

背景・設計方針・ファイル構成をCycle docに追記。

### Step 5: Test List作成

```markdown
## Test List

### TODO
- [ ] TC-01: [正常系テスト]
- [ ] TC-02: [異常系テスト]
```

### Step 6: plan-review（推奨）

変更5ファイル以上/新規ライブラリ/セキュリティ関連の場合に推奨。

### Step 7: 完了→RED誘導

```
================================================================================
PLAN完了
================================================================================
実装計画とTest Listを作成しました。
次: REDフェーズ（テスト作成）
================================================================================
```

## Reference

- 詳細: [reference.md](reference.md)
