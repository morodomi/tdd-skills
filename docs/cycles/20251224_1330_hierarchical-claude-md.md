# 階層CLAUDE.md対応

Issue: #18

## Status: DONE

## INIT

### Scope Definition

ディレクトリ作成時に、そのディレクトリ用のCLAUDE.mdを配置することを推奨・支援する。

### Target Skills

1. **tdd-onboard**: 主要ディレクトリにCLAUDE.md配置を推奨

※ tdd-red/greenへの追加は実効性が低いため削除

### Expected Structure

```
project/
├── CLAUDE.md              # プロジェクト全体
├── tests/
│   └── CLAUDE.md          # テスト規約、命名、モックパターン
├── src/
│   └── CLAUDE.md          # アーキテクチャ、コーディング規約
└── docs/
    └── CLAUDE.md          # ドキュメント規約
```

### Out of Scope

- 既存CLAUDE.mdの自動検出・マージ
- CLAUDE.md内容の自動生成（テンプレート提供のみ）

### Environment

- Claude Code Plugin形式
- Bash scripts for testing

## Background

Claude Code Meetup Tokyo Q&A (2025/12/22)より:
> 「CLAUDE.mdは小さいフォルダでもちょくちょくいろんなところに入れた方がいい」
> 「Claude Codeがファイルを読んでいる時、そのフォルダのCLAUDE.mdを見てコンテキストがわかる」

## PLAN

### 設計方針

1. **tdd-onboard中心**: 初期セットアップ時に階層CLAUDE.mdを推奨
2. **階層制限**: 第1階層（tests/, src/, docs/）のみ推奨、サブディレクトリは非推奨
3. **サイズ制限**: 各CLAUDE.md 30-50行以内
4. **強制ではなく推奨**: ユーザーの判断に委ねる

### 制約事項（Context肥大化対策）

| 制約 | 基準 |
|------|------|
| 深さ制限 | 第1階層まで（tests/, src/, docs/） |
| サイズ制限 | 各30-50行以内 |
| 合計予算 | 全CLAUDE.md合計 500行以内目安 |

**非推奨パターン**:
```
❌ tests/Unit/CLAUDE.md        # 深すぎる
❌ src/Services/Auth/CLAUDE.md # 深すぎる
```

### tdd-onboard への追加

**Step 5（新規）: 階層CLAUDE.md推奨**

```markdown
### Step 5: 階層CLAUDE.md推奨（任意）

主要ディレクトリにCLAUDE.mdを配置することを推奨:

```bash
ls -d tests src docs 2>/dev/null
```

| ディレクトリ | 推奨内容 | サイズ目安 |
|-------------|----------|-----------|
| tests/ | テスト規約、命名、モックパターン | 30-50行 |
| src/ | アーキテクチャ、コーディング規約 | 30-50行 |
| docs/ | ドキュメント規約 | 30-50行 |

**制約**:
- 第1階層のみ（サブディレクトリは非推奨）
- 各ファイル30-50行以内
- そのディレクトリ固有の内容のみ（親に委譲）

テンプレートは [reference.md](reference.md) を参照。
```

- 既存Step 5→6、Step 6→7、Step 7→8、Step 8→9に繰り下げ
- Progress Checklistに項目追加

### tdd-red/green への追加

**なし**（plan-reviewの指摘により削除）

理由:
- 新規ディレクトリ作成の検知が困難
- tdd-onboardで初期セットアップ時に推奨すれば十分
- 過剰な提案でユーザー体験を損なう可能性

### ファイル変更詳細

| ファイル | 変更内容 |
|----------|----------|
| tdd-onboard/SKILL.md | Step 5追加、既存Step繰り下げ、Checklist更新 |
| tdd-onboard/reference.md | テンプレート追加、制約事項追加 |

## Test List

### TODO

### WIP

### DONE
- [x] TC-01: tdd-onboard SKILL.mdにStep 5（階層CLAUDE.md）が存在する
- [x] TC-02: tdd-onboard Step 5でディレクトリ確認コマンドがある
- [x] TC-03: tdd-onboard Progress Checklistに階層CLAUDE.md項目がある
- [x] TC-04: tdd-onboard reference.mdにテンプレートがある（tests/用）
- [x] TC-05: tdd-onboard reference.mdに深さ制限（第1階層のみ）が明記されている
- [x] TC-06: tdd-onboard reference.mdにサイズ制限（30-50行）が明記されている

## Notes

