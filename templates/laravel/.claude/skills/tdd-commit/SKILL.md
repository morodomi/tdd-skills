---
name: tdd-commit
description: COMMITフェーズ用。REVIEWフェーズ完了後、DOC更新とGitコミットを統合実行。Test List DONE確認→git commit（コード変更）→Feature doc更新（実装ステータス、新API/DB）→Feature docサイズチェック（500行警告、1000行分割要求、星5つ選択）→Overview doc更新（新機能領域・アーキ変更時のみ）→Progress Log記録→docs/*とコードを一括コミット。Git MCP利用時はMCP経由、未利用時はBashフォールバック。ユーザーが「commit」「コミット」と言った時、REVIEWフェーズ完了後、または /tdd-commit コマンド実行時に使用。
allowed-tools: Read, Write, Edit, Grep, Glob, Bash
---

# TDD COMMIT Phase

あなたは現在 **COMMITフェーズ** にいます。

## このフェーズの目的

REVIEWフェーズ完了後、**コードの変更をGitコミット**し、**ドキュメントを更新**することです。
DOCフェーズを統合し、すべてを一度にコミットします。

## DOCフェーズの統合

tdd-commitはコミット実行とドキュメント更新を統合した包括的なフェーズ：

1. Test List DONE確認
2. git commit実行（コード変更）
3. Feature doc更新（実装ステータステーブル、新API/DB schema）
4. Feature docサイズチェック（500行超過で分割提案、星5つ形式）
5. Overview doc更新（新機能領域・アーキ変更時のみ）
6. Progress Log記録
7. すべてまとめてコミット

## このフェーズでやること

- [ ] 最新のCycle docを読み込み、機能名を確認する
- [ ] Test List DONEを確認する
- [ ] Git状態を確認する（変更ファイル、ブランチ情報）
- [ ] コミットメッセージを生成する
- [ ] Git MCP経由でコミット実行（または Bashフォールバック）
- [ ] Feature docを更新する（実装ステータス、新API/DB schema）
- [ ] Feature docサイズチェック（500行警告、1000行分割要求）
- [ ] Overview docを更新する（新機能領域・アーキ変更時のみ）
- [ ] Progress Logに記録する
- [ ] docs/*をコミットする
- [ ] ユーザーに次のアクションを案内する

## このフェーズで絶対にやってはいけないこと

- 実装コードを変更すること（コミットのみ）
- テストコードを変更すること
- 品質チェックをスキップすること
- コミット前に変更内容を十分に確認しないこと

## ワークフロー

### 1. 準備フェーズ

まず、Cycle docと変更内容を確認してください：

```bash
# 最新のCycle docを検索
ls -t docs/cycles/202*.md 2>/dev/null | head -1

# Cycle docの読み込み
Read docs/cycles/YYYYMMDD_hhmm_<機能名>.md
```

Cycle docから以下の情報を抽出してください：

1. **機能名**: コミットメッセージのプレフィックスに使用
2. **実装概要**: コミットメッセージの本文に使用
3. **変更ファイル**: コミット対象の確認
4. **Test List DONE**: 完了したテストケース一覧
5. **新しいAPI**: Feature doc更新用
6. **新しいDB schema**: Feature doc更新用

### 2. Test List DONE確認フェーズ

Cycle docのTest List > DONEセクションを確認します：

```
Test List DONE確認:

DONE:
- [x] TC-01: [テストケース名]
- [x] TC-02: [テストケース名]
- [x] TC-03: [テストケース名]

完了したテスト: 3件

これらをFeature docの実装ステータステーブルに反映します。
```

### 3. Git状態確認フェーズ

Gitの状態を確認してください：

```bash
# Git状態確認
git status

# ブランチ確認
git branch --show-current

# 変更の差分確認
git diff --stat

# ステージング状態確認
git diff --cached --stat
```

**確認事項**:
- [ ] 変更ファイルがCycle docの対象ファイルと一致
- [ ] 意図しない変更が含まれていない
- [ ] 正しいブランチにいる

**問題がある場合**:
```
警告: 以下の問題を確認してください：
- 意図しない変更: XXX
- ブランチ: YYY (期待: ZZZ)

コミットを中断します。
```

### 4. コード変更のコミット実行フェーズ

#### 4.1 MCP利用可能性チェック

まず、Git MCPが利用可能かチェックしてください：

```bash
# MCP サーバー一覧確認
claude mcp list 2>/dev/null | grep -q "^git "
echo $?  # 0ならMCP利用可能
```

#### 4.2 コミットメッセージ生成

Cycle docの情報を基にコミットメッセージを生成してください：

**フォーマット**:
```
<type>: <機能名の簡潔な説明>

<詳細説明>
- 変更内容1
- 変更内容2

Test List DONE:
- TC-01: [テストケース名]
- TC-02: [テストケース名]

Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

**type の種類**:
- `feat`: 新機能追加
- `fix`: バグ修正
- `refactor`: リファクタリング
- `test`: テスト追加・修正
- `docs`: ドキュメント更新
- `style`: コードフォーマット
- `chore`: ビルド、設定変更

#### 4.3 コミット実行（MCP優先）

**パターンA: Git MCP利用時**

Git MCPが利用可能な場合、MCP経由でコミットします：

```
注: Git MCPが利用可能です。MCP経由でコミットを実行します。
```

Claude Codeの内部MCPツールを使用してコミットを実行してください。
（Note: MCPツールは自動的に利用可能になります）

コミット実行後、結果を確認：

```bash
# コミット履歴確認
git log --oneline -n 5

# 最新コミットの詳細
git show HEAD --stat
```

**パターンB: Bashフォールバック時**

Git MCPが利用不可の場合、Bashコマンドを使用します：

```
注: Git MCPが利用できません。Bashコマンドでコミットを実行します。
```

```bash
# 変更をステージング（app/, routes/, database/, tests/, resources/のみ）
git add app/ routes/ database/ tests/ resources/

# コミット実行
git commit -m "$(cat <<'EOF'
<type>: <機能名の簡潔な説明>

<詳細説明>
- 変更内容1
- 変更内容2

Test List DONE:
- TC-01: [テストケース名]
- TC-02: [テストケース名]

Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"

# コミット確認
git log --oneline -n 5
```

### 5. Feature doc更新フェーズ

コード変更のコミット後、Feature docを更新します。

#### 5.1 Feature docの特定

```bash
# Feature docを検索（docs/features/ または docs/ 配下）
ls -t docs/features/*.md 2>/dev/null || ls -t docs/*.md 2>/dev/null | grep -v cycles | head -1
```

**Feature docが見つからない場合**:
```
Feature docが見つかりません。新規作成しますか？

通常、Feature docは以下の場所にあるはずです:
- docs/features/<機能領域>.md
- docs/<機能領域>.md

新規作成する場合は、INIT時にFeature docを作成することを推奨します。
```

#### 5.2 実装ステータステーブルの更新

Feature docのImplementation Status（実装ステータステーブル）を更新します。

Editツールを使用してFeature docのImplementation Statusセクションを更新：

```markdown
## Implementation Status

| Feature | Status | Cycle | Completed |
|---------|--------|-------|-----------|
| [機能名] | Done | cycle-001 | 2025-11-14 |
| [別の機能] | In Progress | cycle-002 | - |
| [未着手機能] | Planned | - | - |

**最新の更新**:
- 2025-11-14: [機能名] 実装完了（cycle-001）
```

**ステータスの種類**:
- `Done`: 完了
- `In Progress`: 実装中
- `Planned`: 計画中
- `Blocked`: ブロック中

#### 5.3 新しいAPI/エンドポイントの追加

新しいAPI/エンドポイントが追加された場合、Feature docに追記します：

```markdown
## API Endpoints

### POST /api/users
新規ユーザー作成

**Request**:
```json
{
  "name": "John Doe",
  "email": "john@example.com"
}
```

**Response**:
```json
{
  "id": 1,
  "name": "John Doe",
  "email": "john@example.com",
  "created_at": "2025-11-14T10:00:00Z"
}
```

**Added in**: cycle-001
```

#### 5.4 新しいDB schemaの追加

新しいDB schema（テーブル、カラム）が追加された場合、Feature docに追記します：

```markdown
## Database Schema

### users テーブル

| Column | Type | Nullable | Description |
|--------|------|----------|-------------|
| id | bigint | No | 主キー |
| name | varchar(255) | No | ユーザー名 |
| email | varchar(255) | No | メールアドレス |
| created_at | timestamp | Yes | 作成日時 |
| updated_at | timestamp | Yes | 更新日時 |

**Added in**: cycle-001
```

### 6. Feature docサイズチェックフェーズ

Feature docのサイズを確認し、必要に応じて分割提案します。

```bash
# Feature docの行数確認
wc -l docs/features/<機能領域>.md
```

**結果の判定**:

**500行未満**（正常）:
```
Feature docサイズ: XX行
適切なサイズです。
```

**500行以上1000行未満**（警告）:
```
警告: Feature docサイズ: XX行

500行を超えています。
以下のいずれかの対応を検討してください:

1. [推奨★★★★☆] このまま継続
   理由: 1000行未満なら管理可能。次のサイクルで分割を検討

2. [推奨★★★☆☆] 今すぐ分割
   理由: 早めに分割することで管理しやすくなる

どうしますか？
```

**1000行以上**（分割必須）:
```
エラー: Feature docサイズ: XX行

1000行を超えています。分割が必要です。

以下のいずれかの対応を選択してください:

1. [推奨★★★★★] 機能領域別に分割
   理由: 関連する機能ごとにFeature docを分割。最も推奨される方法

2. [推奨★★★☆☆] 実装完了/未完了で分割
   理由: 完了した機能をアーカイブ。一時的な対応として有効

3. [推奨★★☆☆☆] このまま継続（非推奨）
   理由: 1000行超えは管理困難。技術的負債になる可能性

どうしますか？
```

分割が選択された場合、分割作業を実施します（別途Writeツールを使用）。

### 7. Overview doc更新フェーズ

**新機能領域またはアーキテクチャ変更がある場合のみ**、Overview docを更新します。

#### 7.1 Overview docの特定

```bash
# Overview docを検索
ls docs/overview.md 2>/dev/null || ls docs/OVERVIEW.md 2>/dev/null
```

#### 7.2 新機能領域の追加

新しい機能領域が追加された場合、Overview docに追記します：

```markdown
## Feature Areas

### [新機能領域]
[簡潔な説明]

**Related Feature docs**:
- [docs/features/<機能領域>.md](docs/features/<機能領域>.md)

**Added in**: cycle-001
```

#### 7.3 アーキテクチャ変更の記録

アーキテクチャ変更があった場合、Overview docに追記します：

```markdown
## Architecture Changes

### 2025-11-14: [変更内容]
[変更の詳細]

**Rationale**: [変更理由]
**Impact**: [影響範囲]
**Related Cycle**: cycle-001
```

### 8. Progress Log記録フェーズ

Cycle docのProgress Logにコミット情報を記録します。

Editツールを使用してCycle docのProgress Logセクションに追記：

```markdown
### YYYY-MM-DD HH:MM - COMMIT phase
- コードコミット: <コミットハッシュ>
- Feature doc更新: 実装ステータス、新API XX件、新DB schema XX件
- Feature docサイズ: XX行（[正常/警告/分割必要]）
- Overview doc更新: [更新あり/更新なし]
- docs/*コミット: 完了
```

### 9. YAML frontmatter更新フェーズ

Cycle docのYAML frontmatterを更新します。

Editツールを使用してCycle docの先頭部分を更新：

```markdown
---
feature: [機能領域]
cycle: [サイクル識別子]
phase: DONE
created: YYYY-MM-DD HH:MM
updated: YYYY-MM-DD HH:MM  # 現在時刻に更新
---
```

**更新内容**:
- `phase`: "DONE"に変更
- `updated`: 現在日時に更新

### 10. ドキュメントの一括コミット

Feature doc、Overview doc、Cycle docの変更を一括コミットします。

```bash
# docs/*をステージング
git add docs/

# ドキュメントコミット
git commit -m "docs: Update Feature/Overview/Cycle docs for <機能名>

- Feature doc: Implementation status updated, added XX APIs, XX DB schemas
- Overview doc: [Added new feature area / Architecture change / No update]
- Cycle doc: Progress log updated

Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"
```

### 11. 完了フェーズ

すべてのコミットが成功したら、以下を伝えてください：

```
================================================================================
COMMITフェーズが完了しました
================================================================================

コード変更コミット:
- コミットハッシュ: XXXXXXX
- ブランチ: <ブランチ名>
- 変更ファイル数: XX件

ドキュメント更新:
- Feature doc: 実装ステータス更新、新API XX件、新DB schema XX件
- Feature docサイズ: XX行（[正常/警告/分割必要]）
- Overview doc: [更新あり/更新なし]

ドキュメントコミット:
- コミットハッシュ: YYYYYYY
- 変更ファイル: docs/features/<機能領域>.md, docs/cycles/<サイクル>.md

現在のTDDワークフロー:
[完了] INIT (初期化)
[完了] PLAN (計画)
[完了] RED (テスト作成)
[完了] GREEN (実装)
[完了] REFACTOR (リファクタリング)
[完了] REVIEW (品質検証)
[完了] COMMIT (コミット) ← 現在ここ

次のアクション:
1. リモートにプッシュ: git push origin <ブランチ名>
2. プルリクエスト作成（必要に応じて）
3. 次の機能開発: tdd-init から新しいサイクルを開始

TDDワークフローが完了しました。
```

## MCP統合の詳細

### Git MCPの利用

Git MCPが利用可能な場合、以下の機能が自動的に利用されます：

1. **変更のステージング**: MCPツールが自動的に変更をステージング
2. **コミット実行**: MCPツール経由でコミット
3. **エラーハンドリング**: MCP側でエラーハンドリング

### MCPのメリット

- **安全性**: ファイルアクセス制御が適用される
- **監査ログ**: MCP経由の操作はログに記録される
- **統一的な操作**: プロトコルに準拠した標準的な操作

### フォールバックの動作

MCP未利用時は従来のBashコマンドにフォールバックします：

```bash
# フォールバックの判定
if ! claude mcp list 2>/dev/null | grep -q "^git "; then
  echo "Git MCPが利用できません。Bashコマンドを使用します。"
  # Bashコマンドでコミット
fi
```

## エラーハンドリング

### エラー1: コミット対象ファイルが空

**症状**: `nothing to commit, working tree clean`

**対処**:
```
エラー: コミット対象の変更がありません。

確認事項:
- git status で変更があるか確認
- git add でファイルがステージングされているか確認

COMMITフェーズを中断します。
```

### エラー2: コミットメッセージが空

**症状**: コミットメッセージ生成に失敗

**対処**:
```
エラー: コミットメッセージを生成できませんでした。

Cycle docを確認して、機能名と実装概要を再取得します。
```

### エラー3: Git MCPエラー

**症状**: MCP経由のコミットが失敗

**対処**:
```
警告: Git MCP経由のコミットが失敗しました。
Bashフォールバックに切り替えます。

エラー内容:
<MCPエラーメッセージ>
```

自動的にBashフォールバックに切り替えてコミットを再試行してください。

### エラー4: pre-commit hookエラー

**症状**: pre-commit hookでコミットが失敗

**対処**:
```
エラー: pre-commit hookでコミットが失敗しました。

エラー内容:
<hookエラーメッセージ>

対処方法:
1. フックで指摘された問題を修正
2. 再度COMMITフェーズを実行

問題を修正してから、再度コミットしてください。
```

## 制約事項

このフェーズでは、`allowed-tools: Read, Write, Edit, Grep, Glob, Bash` が使用可能です。

DOCフェーズが統合されているため、**WriteとEditツールが使用可能**です。

もしユーザーが以下のような依頼をした場合は、**丁寧に拒否**してください：

- 「このファイルも追加して実装して」→ 「COMMITフェーズでは実装を行いません。新しいTDDサイクルで実装しましょう」
- 「コミットメッセージを変更してpush --forceして」→ 「force pushは推奨されません。通常のpushを使用してください」
- 「複数のコミットに分割して」→ 「COMMITフェーズでは2つのコミット（コード、ドキュメント）を作成します」

## Git操作のベストプラクティス

### コミット前の確認事項

- [ ] すべてのテストが通っている
- [ ] 品質チェックが完了している
- [ ] Cycle docの要件を満たしている
- [ ] 意図しない変更が含まれていない
- [ ] コミットメッセージが明確

### コミットメッセージのガイドライン

1. **簡潔**: 1行目は50文字以内
2. **明確**: 何をしたか、なぜしたかを記載
3. **構造化**: type + コロン + 説明
4. **Test List DONE**: 完了したテストケースを記載
5. **Co-Authored-By**: Claude Codeで生成したことを明示

### リモートへのpush

コミット後、リモートにpushする際は：

```bash
# 現在のブランチをpush
git push origin $(git branch --show-current)

# または
git push
```

## トラブルシューティング

### 問題1: MCPが利用できない

**確認方法**:
```bash
claude mcp list
```

**解決方法**:
```bash
# MCPインストールスクリプト実行
bash scripts/install-mcp.sh

# インストール確認
claude mcp list | grep git
```

### 問題2: コミットが失敗する

**確認方法**:
```bash
# Git状態確認
git status

# 最近のコミット確認
git log --oneline -n 5
```

**解決方法**:
- エラーメッセージを確認
- 変更内容を確認
- 必要に応じてREFACTORフェーズに戻る

### 問題3: ブランチが間違っている

**確認方法**:
```bash
git branch --show-current
```

**解決方法**:
```bash
# 正しいブランチに切り替え
git checkout <正しいブランチ>

# またはブランチ作成
git checkout -b feature/<機能名>
```

### 問題4: Feature docが見つからない

**確認方法**:
```bash
ls docs/features/*.md
ls docs/*.md | grep -v cycles
```

**解決方法**:
```
Feature docが見つかりません。

INITフェーズでFeature docを作成することを推奨します。
または、既存のFeature docパスを確認してください。
```

## 参考情報

このSkillは、Laravel開発におけるTDDワークフローの最終フェーズです。

- 詳細なワークフロー: README.md参照
- プロジェクト設定: CLAUDE.md参照
- 前のフェーズ: tdd-review Skill（品質検証）
- MCP統合: docs/MCP_INSTALLATION.md参照

### COMMITフェーズの重要性

COMMITフェーズは、TDDサイクルの完了を意味します：

- **品質保証**: テスト・レビュー完了後のコミット
- **追跡可能性**: コミットメッセージで変更の意図を記録
- **ドキュメント整合性**: コードとドキュメントを同時に更新
- **自動化**: MCP統合で安全・効率的なコミット

このフェーズを完了すると、安心してリモートにpushできます。

### DOC統合のメリット

DOCフェーズをCOMMITに統合することで：

1. **一貫性**: コード変更とドキュメント更新が同期
2. **効率性**: 1つのフェーズで完結
3. **追跡性**: Feature doc、Overview doc、Cycle docを同時に更新
4. **品質**: Feature docサイズチェックで文書肥大化を防止

---

*このSkillはClaudeSkillsプロジェクトの一部です*
