# quality-gate 機能拡張

## Status: DONE

## INIT

### Scope Definition

quality-gate スキルに以下の機能を追加:
1. デフォルトで差分（git diff）をチェック
2. 引数指定で全体または特定ディレクトリをチェック

**判定のみ**: 修正提案は行わず、既存の判定フロー（PASS/WARN/BLOCK）を維持

### Target Structure

```
plugins/tdd-core/skills/quality-gate/
├── SKILL.md       # 修正: 対象範囲指定（Step 1拡張）
└── reference.md   # 新規: 引数仕様の詳細
```

### Usage Examples

```bash
# デフォルト: 差分のみチェック
quality-gate

# 全体チェック
quality-gate 全部チェックして
quality-gate --all

# 特定ディレクトリ
quality-gate srcディレクトリだけ
quality-gate src/
```

### Out of Scope

- 新規スキル作成（既存スキルの拡張のみ）
- プリセット選択機能（全てチェックが基本方針）
- CI/CD統合（ローカル実行のみ）
- 修正提案機能（判定のみ、修正はREFACTORフェーズ）

### Environment

#### Scope
- Layer: tdd-core（言語非依存）
- Plugin: tdd-core

#### Runtime
- Claude Code Plugins

## PLAN

### 設計方針

既存の quality-gate ワークフローを拡張し、対象範囲指定機能を追加。
判定ロジック（Step 2-5）は変更なし。

### 拡張後の Workflow

```
Step 1: 対象範囲決定 ← 拡張
        - 引数なし → git diff（デフォルト）
        - 「全部」「--all」 → 全ファイル
        - ディレクトリ指定 → 特定範囲
Step 2: スコープ/プラグイン確認（既存）
Step 3: 4エージェント並行起動（既存）
Step 4: 結果統合（既存）
Step 5: 分岐判定（PASS/WARN/BLOCK）（既存）
```

### 変更ファイル

| ファイル | 変更内容 | 行数目安 |
|----------|---------|---------|
| `quality-gate/SKILL.md` | Step 1拡張（対象範囲決定） | +15行 |
| `quality-gate/reference.md` | 新規作成（引数仕様） | 30行 |

## Test List

### TODO

（なし）

### WIP

（なし）

### DONE

#### 正常系: 対象範囲指定
- [x] TC-01: 引数なしで git diff HEAD 対象をチェック
- [x] TC-02: 「全部チェックして」で全ファイル対象
- [x] TC-03: 「srcだけ」で src/ ディレクトリのみ対象
- [x] TC-04: 「--all」フラグで全ファイル対象

#### エッジケース
- [x] TC-05: git diff が空の場合「変更なし」メッセージ
- [x] TC-06: 指定ディレクトリが存在しない場合エラー表示

#### 回帰テスト
- [x] TC-07: 対象範囲指定後、既存Step 2-5が正常動作

## Notes

- 現状の quality-gate は git diff --stat で対象確認
- 拡張後もデフォルト動作は差分チェックで維持
- quality-gate は「判定のみ」に責務を限定（Aggregatorパターン維持）
- 修正は既存フロー通り REFACTOR フェーズで実施
