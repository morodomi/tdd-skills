# rules/security.md テンプレート作成

## Status: DONE

## INIT

### Scope Definition

tdd-onboard が生成する `.claude/rules/security.md` テンプレートを作成する。

Issue: #22
親Issue: #19

### Target

```
.claude/
└── rules/
    └── security.md  # 新規追加
```

### Tasks

- [ ] reference.md に security.md テンプレート追加
- [ ] SKILL.md Step 6 に security.md を追加
- [ ] テンプレート内容: セキュリティルール、pre-commit確認、シークレット管理

### Out of Scope

- hooks/ 配下のファイル作成（#23で対応）
- git-safety.md（#21で対応）

### Environment

#### Scope
- Layer: tdd-core プラグイン
- Plugin: tdd-core/skills/tdd-onboard

#### Runtime
- Claude Code Plugins

### Dependencies

- #20 完了済み（.claude/rules/ 構造への変更）

## PLAN

### 設計方針

Issue #22 の内容をそのまま security.md テンプレートとして採用。
既存の rules/ ファイル群（tdd-workflow.md, testing-guide.md, quality.md, commands.md）と同じ形式で追加。

### 変更ファイル

| ファイル | 変更内容 |
|----------|----------|
| tdd-onboard/SKILL.md | Step 6 に `security.md` を追加 |
| tdd-onboard/reference.md | Step 6 セクションに security.md テンプレート追加 |

### security.md テンプレート内容

```markdown
# Security Rules

## コミット前チェック（必須）

1. [ ] ハードコードされた秘密鍵がないか
2. [ ] 入力検証が適切か
3. [ ] SQLインジェクション対策
4. [ ] XSS対策
5. [ ] CSRF保護
6. [ ] 認証・認可確認
7. [ ] レート制限
8. [ ] エラーメッセージが情報漏洩しないか

## 秘密鍵管理

- ハードコード禁止
- 環境変数を使用
- .envファイルは.gitignoreに追加

## 問題発見時

1. 即座に作業停止
2. security-reviewerエージェント使用
3. CRITICAL問題を優先修正
4. 公開された秘密鍵はローテーション
```

### 制約

- SKILL.md は100行以下を維持（現在98行）
- テンプレートは reference.md に配置

## Test List

### TODO

（なし）

### WIP

（なし）

### DONE

- [x] TC-01: SKILL.md Step 6 に `security.md` が含まれている
- [x] TC-02: reference.md に security.md テンプレートがある
- [x] TC-03: SKILL.md が99行（100行以下）
- [x] TC-04: テンプレートに「コミット前チェック」セクションがある
- [x] TC-05: テンプレートに「秘密鍵管理」セクションがある

## Notes

- everything-claude-code 互換構造
- 親Issue #19 の子タスク
- #21, #23 と並行作業可能
