# Cycle Doc Template

以下をコピーして `docs/cycles/YYYYMMDD_HHMM_<機能名>.md` を作成。

---

```markdown
---
feature: [機能領域]
cycle: [サイクル識別子]
phase: INIT
created: YYYY-MM-DD HH:MM
updated: YYYY-MM-DD HH:MM
---

# [機能名]

## Scope Definition

### 今回実装する範囲
- [ ] [実装項目1]
- [ ] [実装項目2]

### 今回実装しない範囲
- ❌ [項目]（理由: [理由]）

### 変更予定ファイル（目安: 10以下）
- [ファイルパス]（新規/編集）

## Environment

### Scope
- Layer: [Backend / Frontend / Both]
- Plugin: [tdd-php / tdd-flask / tdd-python / tdd-js / tdd-ts]
- Risk: [0-100] ([PASS / WARN / BLOCK])

### Runtime
- Language: [Python 3.12.0 / PHP 8.3.0 / Node 20.0.0]

### Dependencies（主要）
- [パッケージ名]: [バージョン]
- [パッケージ名]: [バージョン]

### Risk Interview（BLOCK時のみ）
- リスクタイプ: [セキュリティ / 外部連携 / データ変更]
- [質問1]: [回答]
- [質問2]: [回答]
- [質問3]: [回答]

## Context & Dependencies

### 参照ドキュメント
- [docs/xxx.md] - [理由]

### 依存する既存機能
- [機能]: [ファイルパス]

### 関連Issue/PR
- Issue #[番号]: [タイトル]

## Test List

### TODO
- [ ] TC-01: [テストケース]
- [ ] TC-02: [テストケース]

### WIP
（現在なし）

### DISCOVERED
（現在なし）

### DONE
（現在なし）

## Implementation Notes

### やりたいこと
[ユーザー入力]

### 背景
[PLANで記入]

### 設計方針
[PLANで記入]

## Progress Log

### YYYY-MM-DD HH:MM - INIT
- Cycle doc作成
- Scope定義準備完了

---

## 次のステップ

1. [完了] INIT ← 現在
2. [次] PLAN
3. [ ] RED
4. [ ] GREEN
5. [ ] REFACTOR
6. [ ] REVIEW
7. [ ] COMMIT
```
