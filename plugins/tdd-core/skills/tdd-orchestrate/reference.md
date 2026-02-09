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

### スコアベース判定 (Agent Teams 有効時)

| スコア | 判定 | PdM アクション | ユーザーに聞く |
|--------|------|---------------|---------------|
| 0-49 | PASS | 次 Phase へ自動進行 | - |
| 50-79 | WARN | Socrates Protocol → 人間判断 | メリデメ提示後に自由入力 |
| 80-100 | BLOCK | Socrates Protocol → 人間判断 | メリデメ提示後に自由入力 |

Agent Teams 無効時は v5.0 互換: WARN 自動進行、BLOCK 自動再試行。

### WARN/BLOCK 時の Socrates Protocol (v5.1 設計理由)

WARN (50-79) は判断が分かれるゾーン。Socrates Protocol で人間の知見を入れることが
最も ROI が高い。自律性 (v5.0) より判断精度 (v5.1) を優先する意図的な設計変更。
BLOCK (80+) も同様に Socrates Protocol を経由し、自動再試行ではなく人間が
「再試行/修正/中断」を判断する。

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

GitHub issue を作成しますか? (Y/n)
```

### 重複防止

起票済みの項目は Cycle doc で `→ #<issue番号>` マークが付く:

```markdown
### DISCOVERED
- パフォーマンス問題 → #42
- エラーハンドリング不足 → #43
```

`→ #` が付いている項目は起票をスキップする。

## Socrates Protocol

Agent Teams 有効時、plan-review / quality-gate のスコアが WARN (50-79) または BLOCK (80+) の場合に発動する。
Socrates は常駐 advisor teammate であり、reviewer とは異なる役割を持つ。

### Protocol フロー

1. **PdM → Socrates**: 判断提案を SendMessage で送信 (Phase名, スコア, reviewer サマリ, 提案)
2. **Socrates → PdM**: 反論を返答 (Objections + Alternative 形式)
3. **PdM → Human**: Socrates の反論を統合し、メリデメを構造化してテキスト出力
4. **Human → PdM**: 自由入力で判断を返す

### 人間の自由入力ハンドリング

有効な入力例:

| 入力 | 意味 |
|------|------|
| proceed | 現状のまま次 Phase へ進行 |
| fix | 指摘事項を修正してから進行 (Phase 再実行) |
| abort | サイクルを中断 |
| 1, 2, 3 | 提示された選択肢の番号で選択 |

不明瞭な入力 (曖昧な文言、無関係な内容) を受けた場合は再確認する (max 2回):

```
入力を解釈できません。以下から選択してください:
1. proceed - 進行
2. fix - 修正して再実行
3. abort - サイクル中断
```

2回再確認しても不明瞭な場合、デフォルト (proceed) で次 Phase へ進行する:

```
入力が2回不明瞭でした。デフォルト (proceed) で次 Phase へ進行します。
```

再試行カウンタは Socrates Protocol 発動ごとにリセットする。

### Progress Log 記録フォーマット

Socrates Protocol 発動時、Cycle doc の Progress Log に以下を追記:

```markdown
#### [Phase名] (Score: [N] [WARN/BLOCK])
- PdM Proposal: [提案内容]
- Socrates Objection: [反論の要約]
- Human Decision: [人間の判断]
- Action: [次のアクション]
```

### 初回発動時のユーザー案内

サイクル内で初めて Socrates Protocol が発動する際、以下の案内を表示:

```
Socrates (Devil's Advocate advisor) が判断に反論します。
reviewer とは異なり、スコアは付けず代替案を提示します。
メリット・デメリットを確認し、自由入力で判断してください。
```
