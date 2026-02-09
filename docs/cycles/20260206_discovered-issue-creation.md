---
feature: discovered-issue-creation
cycle: 20260206_discovered-issue-creation
phase: DONE
created: 2026-02-06 23:00
updated: 2026-02-06 23:50
---

# DISCOVERED Issue Auto-Creation

## Scope Definition

### In Scope
- [ ] PdMがDISCOVERED項目をスコープ内/外に判断するロジック追加
- [ ] スコープ外項目を `gh issue create` でGitHub issueに起票
- [ ] tdd-orchestrate (Agent Teams) での対応
- [ ] tdd-review (subagent) での対応

### Out of Scope
- severity別ラベル付与 (Reason: シンプル形式を採用)
- issue テンプレート (Reason: DISCOVERED内容をbodyに記載するだけ)
- 自動アサイン (Reason: 起票のみ)

### Files to Change (target: 10 or less)
- plugins/tdd-core/skills/tdd-orchestrate/SKILL.md (edit)
- plugins/tdd-core/skills/tdd-orchestrate/reference.md (edit)
- plugins/tdd-core/skills/tdd-orchestrate/steps-teams.md (edit)
- plugins/tdd-core/skills/tdd-orchestrate/steps-subagent.md (edit)
- plugins/tdd-core/skills/tdd-review/SKILL.md (edit)
- plugins/tdd-core/skills/tdd-review/reference.md (edit)

## Environment

### Scope
- Layer: N/A (Plugin skill definitions)
- Plugin: tdd-core
- Risk: 40 (WARN)

### Runtime
- Bash: 3.2.57
- gh CLI: 2.74.2

### Dependencies (key packages)
- gh: 2.74.2 (GitHub CLI for issue creation)

## Context & Dependencies

### Reference Documents
- plugins/tdd-core/skills/quality-gate/reference.md - quality-gate出力形式
- plugins/tdd-core/skills/tdd-orchestrate/reference.md - PdM判断基準
- plugins/tdd-core/skills/tdd-review/reference.md - DISCOVERED handling

### Dependent Features
- quality-gate: DISCOVERED項目の生成元
- tdd-orchestrate: PdM判断ロジック
- tdd-review: subagentモードでのDISCOVERED処理

### Related Issues/PRs
- (none)

## Test List

### TODO

#### tdd-orchestrate
- [ ] TC-01: SKILL.md の Block 2 にDISCOVERED処理が記載されていること
- [ ] TC-02: steps-teams.md の REVIEW 自律判断後に「DISCOVERED判断」ステップが存在すること
- [ ] TC-03: steps-teams.md に `gh issue create` コマンドテンプレートが記載されていること
- [ ] TC-04: steps-subagent.md の Block 2 REVIEW後に DISCOVERED 処理が記載されていること
- [ ] TC-05: reference.md の PdM 責務に「DISCOVERED issue 起票」が追加されていること

#### tdd-review (subagent)
- [ ] TC-06: SKILL.md に Step 6 として DISCOVERED issue 起票ステップが存在すること（リナンバ済み）
- [ ] TC-07: reference.md に issue 起票の判断基準・コマンド詳細が記載されていること

#### 共通
- [ ] TC-08: issue タイトル形式が `[DISCOVERED] <要約>` であること
- [ ] TC-09: issue に `discovered` ラベルが指定されていること
- [ ] TC-10: DISCOVERED が空の場合はissue起票をスキップする記載があること
- [ ] TC-11: `gh auth status` による事前チェックが記載されていること
- [ ] TC-12: ユーザー確認ゲート（issue作成前の承認）が記載されていること
- [ ] TC-13: 重複防止（`→ #<番号>` 付き項目のスキップ）が記載されていること
- [ ] TC-14: issue body に Cycle doc パス・Phase・Reviewer が含まれること
- [ ] TC-15: 既存の Plugin 構造テスト (`test-plugins-structure.sh`) が通ること

### WIP
(none)

### DISCOVERED
(none)

### DONE
TC-01 ~ TC-15 (全件 PASS)

## Implementation Notes

### Goal
quality-gateのDISCOVERED項目をPdMが判断し、スコープ外のものをGitHub issueに自動起票する。
Agent Teams / subagent 両モード対応。issue形式はシンプル (タイトル + DISCOVERED内容のbody、ラベルは 'discovered' のみ)。

### Background
quality-gateが問題を発見した場合、現状は2つのパスしかない:
1. BLOCK → GREENに戻って修正（スコープ内で対応）
2. PASS/WARN → そのままCOMMIT（発見事項を無視）

WARN の issues や DISCOVERED に追加された「スコープ外」の項目は、
記録されるだけで追跡されない。これは知見の損失につながる。

PdM がスコープ内/外を判断し、スコープ外をGitHub issueに起票することで、
サイクルを肥大化させずに知見を保持する。

### Design Approach

#### 挿入ポイント
REVIEW の PASS/WARN 判定後、COMMIT の前に新ステップを追加:

```
REVIEW → PASS/WARN → [DISCOVERED判断 + issue起票] → COMMIT
       → BLOCK → GREEN再実行（変更なし）
```

#### データソース (plan-review 指摘対応)
DISCOVERED 項目は **Cycle doc の DISCOVERED セクション** から読み取る:
- quality-gate の reviewer が発見した問題 → tdd-review が DISCOVERED セクションに記録
- RED/GREEN 中に手動で追加された項目
- quality-gate JSON issues[] は直接の入力ソースではない（BLOCK/WARN 判定に使用済み）

#### PdM判断基準
Cycle doc の DISCOVERED セクションの各項目を判断:
- **スコープ内** → RED に戻って修正（既存フロー通り）
- **スコープ外** → GitHub issue に起票

#### ユーザー確認ゲート (plan-review 指摘対応)
issue 作成は外部副作用のため、PdM 自律判断ではなくユーザー承認を求める:
```
DISCOVERED items found:
1. [項目1の要約]
2. [項目2の要約]

GitHub issue を作成しますか? (Y/n/skip)
```

#### issue起票コマンド
```bash
# 事前チェック (plan-review 指摘対応)
gh auth status 2>/dev/null || echo "gh CLI未認証。issue起票をスキップします。"

# 起票
gh issue create --title "[DISCOVERED] <要約>" --body "<詳細>" --label "discovered"
```

issue body テンプレート:
```
## 発見元
- Cycle: docs/cycles/<cycle-doc>.md
- Phase: REVIEW
- Reviewer: <reviewer名 or 手動>

## 内容
<DISCOVERED セクションの記載内容>
```

#### 重複防止 (plan-review 指摘対応)
起票済みの項目は Cycle doc の DISCOVERED セクションで `→ #<issue番号>` を付記:
```
### DISCOVERED
- パフォーマンス問題の可能性 → #42
- エラーハンドリング不足 → #43
```
既に `→ #` が付いている項目はスキップする。

#### 両モード対応
- **Agent Teams (tdd-orchestrate)**: steps-teams.md の Phase 3 自律判断後に追加
- **Subagent (tdd-review)**: SKILL.md Step 6 として追加（既存 Step 5,6 を 6,7 にリナンバ）

#### 変更ファイル一覧
1. `tdd-orchestrate/SKILL.md` - Block 2 にDISCOVERED処理を追記
2. `tdd-orchestrate/reference.md` - PdM責務にissue起票を追加
3. `tdd-orchestrate/steps-teams.md` - REVIEW後にDISCOVERED判断ステップ追加
4. `tdd-orchestrate/steps-subagent.md` - Block 2 のREVIEW後にDISCOVERED処理追加
5. `tdd-review/SKILL.md` - Step 6としてDISCOVERED issue起票ステップ追加（リナンバ）
6. `tdd-review/reference.md` - issue起票の判断基準・コマンド詳細を追加

## Progress Log

### 2026-02-06 23:00 - INIT
- Cycle doc created
- Scope: tdd-orchestrate + tdd-review の両方にissue起票機能追加
- Risk: 40 (WARN) - 既存ワークフローへの追加、破壊的変更なし

### 2026-02-06 23:10 - PLAN
- 設計完了: REVIEW PASS/WARN後にDISCOVERED判断ステップを挿入
- 変更ファイル5つ: orchestrate(3) + review(2)
- Test List: 10ケース (orchestrate 4, review 2, 共通 4)

### 2026-02-06 23:20 - plan-review (WARN: 55)
- scope: 38, architecture: 35, risk: 55, product: 52, usability: 52
- 反映: データソース明確化、gh事前チェック、重複防止、ユーザー確認ゲート
- 反映: Step 5.5→Step 6リナンバ、tdd-orchestrate/SKILL.md追加（計6ファイル）
- 反映: issue bodyテンプレート、DISCOVERED項目に起票済みマーク
- Test List: 15ケースに拡充

### 2026-02-06 23:30 - RED
- テストスクリプト作成: scripts/test-discovered-issue-creation.sh
- 14/15 FAIL (TC-15のみ既存テストでPASS)

### 2026-02-06 23:35 - GREEN
- 6ファイル編集: orchestrate(4) + review(2)
- 15/15 PASS + 既存 136/136 PASS

### 2026-02-06 23:40 - REFACTOR
- Progress Checklist に DISCOVERED ステップ反映
- 全テスト維持

### 2026-02-06 23:45 - REVIEW
- quality-gate WARN: 72
- correctness: 72, performance: 72, security: 72, guidelines: 92, product: 28, usability: 62
- DISCOVERED: (none) → issue起票スキップ

---

## Next Steps

1. [Done] INIT
2. [Done] PLAN
3. [Done] plan-review (WARN: 55, 指摘反映済み)
4. [Done] RED (14/15 FAIL confirmed)
5. [Done] GREEN (15/15 PASS)
6. [Done] REFACTOR (Checklist反映)
7. [Done] REVIEW (quality-gate WARN: 72)
8. [Done] COMMIT
