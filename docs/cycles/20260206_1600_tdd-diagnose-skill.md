---
feature: tdd-diagnose
cycle: tdd-diagnose-skill
phase: DONE
created: 2026-02-06 16:00
updated: 2026-02-06 16:00
---

# TDD Diagnose Skill

## Scope Definition

### In Scope
- [ ] tdd-diagnose/SKILL.md 新規作成（< 100行）
- [ ] tdd-diagnose/reference.md 新規作成
- [ ] tdd-diagnose/steps-subagent.md 新規作成（並行調査モード）
- [ ] tdd-diagnose/steps-teams.md 新規作成（討論型調査モード）
- [ ] tdd-init/SKILL.md 編集（auto-transition 追加、行数調整）
- [ ] CLAUDE.md 編集（Skills table に tdd-diagnose 追加）

### Out of Scope
- 新規 investigator エージェント定義の追加（既存エージェント活用 or 別サイクル）
- plan-review への統合
- DIAGNOSE フェーズのワークフロー図更新（docs/STATUS.md は REVIEW で更新）

### Files to Change (target: 10 or less)
- plugins/tdd-core/skills/tdd-diagnose/SKILL.md (new)
- plugins/tdd-core/skills/tdd-diagnose/reference.md (new)
- plugins/tdd-core/skills/tdd-diagnose/steps-subagent.md (new)
- plugins/tdd-core/skills/tdd-diagnose/steps-teams.md (new)
- plugins/tdd-core/skills/tdd-init/SKILL.md (edit)
- CLAUDE.md (edit)

## Environment

### Scope
- Layer: Plugin (Claude Code Plugin skill definition)
- Plugin: tdd-core
- Risk: 15 (PASS)

### Runtime
- Bash: 3.2.57
- Claude Code: 2.1.32

### Dependencies (key packages)
- Claude Code Agent Teams: experimental (CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS)
- quality-gate steps-teams.md: 参考パターン

## Context & Dependencies

### Reference Documents
- plugins/tdd-core/skills/quality-gate/SKILL.md - 環境変数分岐の参考
- plugins/tdd-core/skills/quality-gate/steps-teams.md - Agent Teams討論パターンの参考
- plugins/tdd-core/skills/quality-gate/steps-subagent.md - Subagentパターンの参考
- docs/cycles/20260206_1400_quality-gate-agent-teams.md - #44実装の参考

### Dependent Features
- tdd-init: plugins/tdd-core/skills/tdd-init/SKILL.md (auto-transition追加先)
- quality-gate: Agent Teamsパターンの既存実装

### Related Issues/PRs
- Issue #45: feat: tdd-diagnose - parallel bug investigation phase

## Test List

### TODO
(none)

### WIP
(none)

### DISCOVERED
(none)

### DONE
- [x] TC-01: SKILL.md が存在し 100行以下であること (79行)
- [x] TC-02: SKILL.md が CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS 分岐を含むこと
- [x] TC-03: SKILL.md が Progress Checklist を含むこと
- [x] TC-04: steps-subagent.md が存在し、Explore エージェント並行調査手順を含むこと
- [x] TC-05: steps-teams.md が存在し、Team作成・討論・合議判定手順を含むこと
- [x] TC-06: steps-teams.md が Fallback セクションを含むこと
- [x] TC-07: reference.md が存在し、仮説テンプレート・調査手法を含むこと
- [x] TC-08: tdd-init/SKILL.md が tdd-diagnose への auto-transition を含むこと
- [x] TC-09: tdd-init/SKILL.md が 100行以下を維持すること (99行)
- [x] TC-10: scripts/test-plugins-structure.sh 78 passed, 0 failed
- [x] TC-11: reference.md が仮説テンプレート（hypothesis, evidence_for, evidence_against, verdict）を含むこと
- [x] TC-12: SKILL.md Step 4 に調査結果の分岐（特定/絞込/不明）を含むこと
- [x] TC-13: CLAUDE.md Skills table に tdd-diagnose が登録されていること

## Implementation Notes

### Goal
複雑なバグに対し、複数の仮説を並行調査し互いに反証し合う調査フェーズ（tdd-diagnose）を新スキルとして追加する。tdd-init の高リスク時に自動起動する auto-transition も実装する。

### Background

現在の tdd-skills にはバグ調査専用スキルがない。ワークフローは「根本原因が既知」を前提としており、
複雑なバグ（競合状態、分散システム問題等）では根本原因特定前に TDD サイクルに入ってしまう。

quality-gate (#44) で Agent Teams 討論パターンを確立済み。同パターンを調査フェーズに適用する。

### Design Approach

**方針: quality-gate と同じ構造（env分岐 + steps分離）で新規スキルを作成**

#### SKILL.md のフロー (< 100行)

```
Step 1: バグ情報収集
  - AskUserQuestion でバグカテゴリ・重要度を構造化入力
  - エラーメッセージ・関連ファイルを収集

Step 2: 仮説生成
  - バグの原因候補を3つ以上リスト
  - 各仮説に調査方針を付与

Step 3: 調査実行（モード自動選択）
  - CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS 確認
  - 有効 → steps-teams.md (討論型調査、最大2ラウンド)
  - 無効 → steps-subagent.md (並行調査)

Step 4: 調査結果統合 (分岐判定)
  - 根本原因特定 → Cycle doc 記録、tdd-plan へ
  - 2-3候補に絞込 → ユーザーに選択を求める
  - 不明 → 手動調査へエスカレート or 仮説追加して再調査

Step 5: Cycle doc 更新 → tdd-plan 自動実行
```

#### steps-subagent.md (並行調査)

Explore エージェント（Claude Code 組み込み read-only 型）を仮説数分並行起動。
各自がコード検索・ファイル読取で仮説を検証。
※ 再現実行が必要な場合は Lead がコマンド実行を担当。

#### steps-teams.md (討論型調査)

```
Phase 1: Team 作成
Phase 2: Investigator teammates 起動（仮説ごとに1名、Explore型）
Phase 3: Independent Investigation（各自が担当仮説を検証）
Phase 4: Debate（発見事項 broadcast → 反証・補強、最大2ラウンド）
Phase 5: Lead Synthesis（生き残った仮説で根本原因特定）
Phase 6: Team cleanup
Fallback: Agent Teams 失敗時は steps-subagent.md へ切替
```

#### tdd-init 変更 (Step 4.7 拡張)

BLOCK 判定時にバグ調査キーワード（investigate, diagnose, debug, reproduce, 原因調査）を
検出したら AskUserQuestion でユーザー確認後、`Skill(tdd-core:tdd-diagnose)` を自動実行。
既存 Step 4.7 の説明文を短縮し reference.md へ委譲して行数を確保。

#### ファイル構成

```
tdd-diagnose/
├── SKILL.md              # メインフロー (< 100行)
├── reference.md          # 詳細（仮説テンプレート、調査手法等）
├── steps-subagent.md     # 並行調査手順 (Explore 組み込み型)
└── steps-teams.md        # 討論型調査手順

tdd-init/
└── SKILL.md              # Step 4.7 短縮 + auto-transition 追加
```

## Progress Log

### 2026-02-06 16:00 - INIT
- Cycle doc created
- Scope: 5 files (4 new, 1 edit)
- Risk: 15 (PASS)
- Reference: #44 quality-gate-agent-teams の実装パターンを踏襲

### 2026-02-06 16:00 - PLAN
- Design: quality-gate パターン踏襲（env分岐 + steps分離）
- Test List: 13 test cases

### 2026-02-06 16:00 - plan-review
- Score: 62 (WARN) - product-reviewer
- 反映: tdd-init行数調整、auto-transition確認追加、escape hatch、
  Explore組み込み型明記、仮説テンプレートTC、CLAUDE.md登録
- 見送り: コスト定量化、Cycle docテンプレート更新、仮説別Progress

### 2026-02-06 16:00 - RED
- 11 tests added to test-plugins-structure.sh (TC-DG-01〜TC-DG-13)
- 67 passed, 11 failed (RED state confirmed)

### 2026-02-06 16:00 - GREEN
- 6 files implemented (4 new, 2 edit)
- 78 passed, 0 failed (GREEN state confirmed)
- SKILL.md: 79 lines, tdd-init: 99 lines

### 2026-02-06 16:00 - REFACTOR
- 品質点検: 構造パターン一貫性確認済み
- リファクタリング対象なし（Markdownファイルのみ、パターン統一済み）
- 78 passed, 0 failed

### 2026-02-06 16:00 - REVIEW
- quality-gate: WARN (max 62, usability-reviewer)
- 全テスト: 78 passed, 0 failed
- 指摘は初期実装として受容可能、改善は次サイクルで対応

---

## Next Steps

1. [Done] INIT
2. [Done] PLAN
3. [Done] plan-review (WARN 62 → proceed)
4. [Done] RED (11 tests failing)
5. [Done] GREEN (78 passed, 0 failed)
6. [Done] REFACTOR
7. [Done] REVIEW (quality-gate WARN: max 62)
8. [Done] COMMIT
