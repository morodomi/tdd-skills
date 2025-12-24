# redteam-skills 構想

セキュリティ監査企業が行う業務をClaude Code Agentで自動化するプラグイン集。

## コンセプト

- **tdd-skills**: 開発ワークフロー（Blue Team的 / 守り）
- **redteam-skills**: セキュリティ監査（Red Team的 / 攻め）

quality-gateが「内部コードレビュー」なら、redteam-skillsは「外部攻撃シミュレーション」。

## レポジトリ構造

```
redteam-skills/
├── plugins/
│   └── redteam-core/
│       ├── .claude-plugin/
│       │   └── plugin.json
│       ├── agents/
│       │   ├── recon-agent.md
│       │   ├── injection-attacker.md
│       │   ├── auth-attacker.md
│       │   ├── xss-attacker.md
│       │   ├── api-attacker.md
│       │   ├── file-attacker.md
│       │   └── ssrf-attacker.md
│       ├── skills/
│       │   ├── security-scan/
│       │   │   ├── SKILL.md
│       │   │   └── reference.md
│       │   └── attack-report/
│       │       ├── SKILL.md
│       │       └── reference.md
│       └── README.md
├── CHANGELOG.md
├── CLAUDE.md
└── README.md
```

## エージェント定義

### recon-agent（偵察）

情報収集フェーズ:
- エンドポイント列挙（routes, API endpoints）
- 技術スタック特定（フレームワーク、DB、認証方式）
- 攻撃対象の優先順位付け

### injection-attacker（インジェクション攻撃）

対象:
- SQL Injection（Union, Blind, Time-based）
- NoSQL Injection
- Command Injection
- LDAP Injection

### auth-attacker（認証攻撃）

対象:
- 認証バイパス
- セッション固定
- セッションハイジャック
- パスワードリセット脆弱性
- JWT脆弱性（alg:none, 弱い署名）

### xss-attacker（XSS攻撃）

対象:
- Reflected XSS
- Stored XSS
- DOM-based XSS
- CSPバイパス

### api-attacker（API攻撃）

対象:
- BOLA (Broken Object Level Authorization)
- BFLA (Broken Function Level Authorization)
- Mass Assignment
- Rate Limiting不備
- GraphQL特有の脆弱性

### file-attacker（ファイル攻撃）

対象:
- Path Traversal
- ファイルアップロード脆弱性
- LFI/RFI (Local/Remote File Inclusion)

### ssrf-attacker（SSRF攻撃）

対象:
- Server-Side Request Forgery
- 内部ネットワーク探索
- クラウドメタデータアクセス（169.254.169.254）

## ワークフロー

```
RECON → SCAN → ATTACK → EXPLOIT → REPORT
```

### Phase 1: RECON（偵察）

```
security-scan RECON:
- [ ] エンドポイント列挙
- [ ] 技術スタック特定
- [ ] 攻撃対象リスト作成
```

### Phase 2: SCAN（スキャン）

```
security-scan SCAN:
- [ ] 各攻撃エージェント並行起動
- [ ] 脆弱性候補の検出
- [ ] 信頼スコア付与
```

### Phase 3: ATTACK（攻撃検証）

```
security-scan ATTACK:
- [ ] 高スコア脆弱性の検証
- [ ] PoC（Proof of Concept）作成
- [ ] 再現手順の確認
```

### Phase 4: REPORT（レポート）

```
attack-report:
- [ ] 脆弱性レポート生成
- [ ] 重大度分類（Critical/High/Medium/Low）
- [ ] 修正推奨事項
```

## 出力形式

### 脆弱性レポート

```json
{
  "id": "VULN-001",
  "type": "SQL Injection",
  "severity": "critical",
  "cvss": 9.8,
  "endpoint": "POST /api/users/login",
  "parameter": "username",
  "payload": "admin'--",
  "evidence": "Response contains 'Welcome admin'",
  "impact": "認証バイパス、データベース全体へのアクセス",
  "remediation": [
    "プリペアドステートメントを使用",
    "入力値のバリデーション強化"
  ],
  "references": [
    "https://owasp.org/www-community/attacks/SQL_Injection"
  ]
}
```

### サマリーレポート

```markdown
# Security Audit Report

## Executive Summary

- Critical: 2件
- High: 5件
- Medium: 8件
- Low: 12件

## Critical Findings

### VULN-001: SQL Injection in Login

...
```

## 検討事項

### 静的 vs 動的

| アプローチ | メリット | デメリット |
|-----------|---------|-----------|
| 静的解析 | 安全、高速 | 誤検知多い |
| 動的テスト | 正確 | 環境必要、リスク |
| ハイブリッド | バランス | 複雑 |

**推奨**: 静的解析ベース + ローカル環境での動的検証（オプション）

### チェックリストベース

- OWASP Top 10 (2021)
- OWASP ASVS (Application Security Verification Standard)
- CWE Top 25

### tdd-skillsとの連携

```bash
# 開発時
/plugin install tdd-core@tdd-skills

# リリース前監査
/plugin install redteam-core@redteam-skills
/security-scan
```

## ロードマップ

### v0.1.0 - MVP

- [ ] recon-agent
- [ ] injection-attacker（SQLi のみ）
- [ ] xss-attacker（Reflected のみ）
- [ ] security-scan スキル
- [ ] 基本レポート出力

### v0.2.0 - 拡張

- [ ] auth-attacker
- [ ] api-attacker
- [ ] attack-report スキル
- [ ] OWASP Top 10 カバレッジ

### v1.0.0 - 完成

- [ ] 全エージェント実装
- [ ] 動的テストオプション
- [ ] CI/CD統合
- [ ] カスタムルール対応

## 参考資料

- [OWASP Testing Guide](https://owasp.org/www-project-web-security-testing-guide/)
- [OWASP ASVS](https://owasp.org/www-project-application-security-verification-standard/)
- [PortSwigger Web Security Academy](https://portswigger.net/web-security)
- [HackTricks](https://book.hacktricks.xyz/)
