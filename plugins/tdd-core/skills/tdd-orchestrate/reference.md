# TDD Orchestrate Reference

PdM (Product Manager) オーケストレータの詳細ガイド。

## PdM の責務

### やること

| 責務 | 詳細 |
|------|------|
| ユーザー対話 | INIT で AskUserQuestion、BLOCK 時のエスカレーション |
| 自律判断 | PASS/WARN/BLOCK を自分で判定し、次 Phase へ自動進行 |
| Phase orchestration | 専門家の spawn/shutdown、Phase 間遷移 |
| Context 管理 | Cycle doc 読み書き、Phase 状態追跡 |
| Verification Gate | テスト実行、成功/失敗確認 |
| Git 操作 | commit, status, diff |
| DISCOVERED issue 起票 | スコープ外の DISCOVERED 項目を GitHub issue に起票 |

### やらないこと

| 禁止 | 委譲先 |
|------|--------|
| 実装コード作成 | green-worker |
| テストコード作成 | red-worker |
| 設計詳細・Test List 作成 | architect |
| コードレビュー | reviewer |
| リファクタリング | refactorer |
| 推測で進む | AskUserQuestion |

## Phase Ownership

| Phase | Owner | 委譲先 |
|-------|-------|--------|
| INIT | PdM (Lead) 直接実行 | - |
| PLAN | PdM → architect | Skill(tdd-plan) |
| plan-review | PdM → 5 reviewer | 討論/並列 |
| RED | PdM → N red-worker | 並列テスト作成 |
| GREEN | PdM → N green-worker | 並列実装 |
| REFACTOR | PdM → refactorer | Skill(tdd-refactor) |
| REVIEW | PdM → 6 reviewer | 討論/並列 quality-gate |
| COMMIT | PdM (Lead) 直接実行 | - |

## 判断基準

### スコアベース判定

| スコア | 判定 | PdM の自律判断 | ユーザーに聞く |
|--------|------|---------------|---------------|
| 0-49 | PASS | 次 Phase へ自動進行 | - |
| 50-79 | WARN | 次 Phase へ自動進行、警告ログ出力 | - |
| 80-100 | BLOCK | 1回目: 自動再試行 | 2回目 BLOCK: ユーザーに報告 |

### WARN 自動進行の設計理由

PdM は自律性を重視する。WARN は品質基準内であり、Progress Checklist で
警告数を可視化することでユーザーへの透明性を確保する。
既存の quality-gate ではユーザーに選択肢を提示するが、
PdM モードでは自律的に進行する。COMMIT は tdd-commit Skill 経由で実行され、
既存の承認フローが適用される。

## 再試行ロジック

### BLOCK 時の再試行

| 場面 | 再試行上限 | 超過時のアクション |
|------|-----------|-------------------|
| plan-review BLOCK | max 1回再試行 | ユーザーに報告、PLAN 修正を依頼 |
| quality-gate BLOCK | max 1回再試行 | ユーザーに報告、GREEN 修正を依頼 |

### テスト失敗時の再試行

| 場面 | 再試行上限 | 超過時のアクション |
|------|-----------|-------------------|
| RED テスト作成失敗 | max 2回再試行 | ユーザーに報告 |
| GREEN テスト失敗 | max 2回再試行 | ユーザーに報告 |

### エスカレーション条件

再試行上限を超えた場合、PdM はユーザーにエスカレーションする:

```
BLOCK が解消されません。
Phase: [Phase名]
試行回数: [N]回
エラー概要: [要約]

選択肢:
1. 手動で修正して続行
2. サイクルを中断
```

## Phase 遷移時のステータス更新

各 Phase 完了時、PdM は Progress Checklist を更新して出力する:

```
tdd-orchestrate Progress:
- [x] Block 1: INIT → PLAN → plan-review → PASS
- [ ] Block 2: RED (実行中) → GREEN → REFACTOR → REVIEW
- [ ] Block 3: COMMIT
```

これにより、ユーザーは長時間の自律実行中も進捗を把握できる。

## DISCOVERED issue 起票

REVIEW の PASS/WARN 後、COMMIT の前に実行する。

### データソース

Cycle doc の `### DISCOVERED` セクションから読み取る。

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

`gh` が利用不可の場合、DISCOVERED 項目を Cycle doc に残したまま COMMIT へ進行する。

### ユーザー確認ゲート

GitHub issue 作成は外部副作用のため、PdM 自律判断ではなくユーザー承認を求める:

```
DISCOVERED items found:
1. [項目1の要約]
2. [項目2の要約]

GitHub issue を作成しますか? (Y/n/skip)
```

### 重複防止

起票済みの項目は Cycle doc で `→ #<issue番号>` マークが付く:

```markdown
### DISCOVERED
- パフォーマンス問題 → #42
- エラーハンドリング不足 → #43
```

`→ #` が付いている項目は起票をスキップする。
