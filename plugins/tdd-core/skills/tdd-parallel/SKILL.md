---
name: tdd-parallel
description: クロスレイヤー並列開発オーケストレータ。Agent Teamsでレイヤー別にRED/GREEN/REFACTORを並列実行。「parallel」「並列開発」で起動。
---

# TDD Parallel - Cross-Layer Parallel Development

Agent Teams でレイヤー別に RED/GREEN/REFACTOR を並列実行するオーケストレータ。

## Architecture Note

このスキルは例外的に複数フェーズ(RED/GREEN/REFACTOR)をまたぐが、
内部では既存の単一フェーズ Skill を Teammate が順次実行する。
7フェーズモデル自体は維持される（合成パターン）。

## When to Use

| 条件 | 推奨 |
|------|------|
| 3+ レイヤー、API契約変更あり | tdd-parallel |
| 単一レイヤー、2ファイル以下 | 通常 TDD (tdd-red → tdd-green → tdd-refactor) |

## Progress Checklist

```
tdd-parallel Progress:
- [ ] Agent Teams 確認
- [ ] レイヤー定義確認・ファイル分離検証
- [ ] レイヤー別 Teammate 起動 (RED→GREEN→REFACTOR)
- [ ] 統合テスト実行・全レイヤー GREEN 確認
- [ ] REVIEW 自動実行
```

## Workflow

### Step 1: Agent Teams 確認

`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` 環境変数をチェック:

| 環境変数 | アクション |
|----------|-----------|
| 有効 (`1`) | Step 2 へ |
| 無効 / 未設定 | エラー表示、通常 TDD を推奨して終了 |

無効時: [steps-teams.md Fallback](steps-teams.md#fallback) のメッセージを表示して終了。

### Step 2: レイヤー定義確認

Cycle doc から In Scope のレイヤー情報を読取:

| レイヤー数 | アクション |
|-----------|-----------|
| 1 | 中止、通常 TDD を推奨 |
| 2-4 | Step 3 へ |
| 5+ | 警告、レイヤー統合を推奨 |

| レイヤー例 | ファイル範囲 | テスト範囲 |
|-----------|-------------|-----------|
| Backend | src/api/, models/ | tests/api/ |
| Frontend | src/components/ | tests/components/ |
| Database | migrations/ | tests/db/ |

詳細: [reference.md](reference.md)

### Step 3: 並列開発実行

[steps-teams.md](steps-teams.md) の手順に従い実行。
各 Teammate が `Skill(tdd-core:tdd-red)` → `Skill(tdd-core:tdd-green)` → `Skill(tdd-core:tdd-refactor)` を順次実行。

### Step 4: 統合テスト

全レイヤーの GREEN 確認後、全テスト一括実行:

```bash
# 全テスト実行（プロジェクト依存）
pytest            # Python
npm test          # JS/TS
php artisan test  # PHP
```

失敗時: テスト出力からレイヤー特定 → 該当 Teammate に修正指示。

### Step 5: 完了 → REVIEW 自動実行

```
tdd-parallel 完了。全レイヤー GREEN、統合テスト PASS。
REVIEW フェーズを自動実行します。
```

`Skill(tdd-core:tdd-review)` を実行。

## Reference

- 詳細: [reference.md](reference.md)
- オーケストレーション: [steps-teams.md](steps-teams.md)
