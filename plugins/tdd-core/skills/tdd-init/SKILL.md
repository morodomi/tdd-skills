---
name: tdd-init
description: 新しいTDDサイクルを開始し、Cycle docを作成する。「新機能を開発したい」「TDDを始めたい」「機能追加」で起動。
---

# TDD INIT Phase

新しいTDDサイクルを開始し、Cycle docを作成する。

## Progress Checklist

コピーして進捗を追跡:

```
INIT Progress:
- [ ] プロジェクト状況確認（docs/STATUS.md）
- [ ] 環境情報収集
- [ ] 既存サイクル確認
- [ ] ユーザーに「やりたいこと」を質問
- [ ] 機能名を生成して確認
- [ ] Cycle doc作成（環境情報含む）
- [ ] PLANフェーズへ誘導
```

## 禁止事項

- 実装計画の詳細作成（PLANで行う）
- テストコード作成（REDで行う）
- 実装コード作成（GREENで行う）

## Workflow

### Step 1: プロジェクト状況確認

```bash
cat docs/STATUS.md 2>/dev/null
```

存在しない場合は `tdd-onboard` を推奨。

### Step 2: 環境情報収集

実行環境のバージョンを収集（AIの知識が古い問題を防止）:

```bash
# 言語バージョン（すべて実行）
python --version 2>/dev/null
php -v 2>/dev/null | head -1
node -v 2>/dev/null

# 主要パッケージ（すべて実行）
echo "=== Python ===" && pip list 2>/dev/null | head -10
echo "=== PHP ===" && composer show 2>/dev/null | head -10
echo "=== Node ===" && npm list --depth=0 2>/dev/null | head -10
```

収集した情報はCycle docのEnvironmentセクションに記録。

### Step 3: 既存サイクル確認

```bash
ls -t docs/cycles/*.md 2>/dev/null | head -1
```

進行中のサイクルがあれば継続を推奨。

### Step 4: やりたいことを質問

```
どんな機能を実装しますか？
例: ユーザーがログインできるようにしたい
```

### Step 5: 機能名生成

ユーザーの回答から機能名を生成（10-20文字）。確認後、Cycle docを作成。

### Step 6: Cycle doc作成

```bash
date +"%Y%m%d_%H%M"
mkdir -p docs/cycles
```

テンプレート: [templates/cycle.md](templates/cycle.md)

### Step 7: 完了→PLAN誘導

```
================================================================================
INIT完了
================================================================================
ファイル: docs/cycles/YYYYMMDD_HHMM_<機能名>.md
次: PLANフェーズ（設計・計画）
================================================================================
```

## Reference

- 詳細: [reference.md](reference.md)
- テンプレート: [templates/cycle.md](templates/cycle.md)
