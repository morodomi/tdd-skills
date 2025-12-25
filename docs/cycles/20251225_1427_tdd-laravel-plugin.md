# tdd-laravel プラグイン

## Status: DONE

## INIT

### Scope Definition

Laravel固有のTDD品質チェックプラグインを作成。

Issue: #12

### Target Structure

```
plugins/tdd-laravel/
├── .claude-plugin/
│   └── plugin.json
├── skills/
│   └── laravel-quality/
│       ├── SKILL.md
│       └── reference.md
└── README.md
```

### Tools

- **静的解析**: PHPStan + Larastan
- **テスト**: Pest (Laravel Pest Plugin)
- **フォーマット**: Laravel Pint

### Out of Scope

- tdd-core の修正
- tdd-php の修正

### Environment

#### Scope
- Layer: Backend
- Plugin: tdd-laravel（新規）
- 依存: tdd-core

#### Runtime
- Claude Code Plugins

## PLAN

### 設計方針

**方式: 補完型（A）**

tdd-php は汎用PHP品質ツール。tdd-laravel は Laravel 固有のテストパターンに特化し、tdd-php を参照。

**tdd-php との関係**:
- tdd-php: PHPStan基本、Pint基本、PHPUnit/Pest基本
- tdd-laravel: Laravel固有パターン + 「詳細は tdd-php 参照」

**tdd-laravel 固有コンテンツ**:
- Pest Laravel Plugin のテストヘルパー（actingAs, assertDatabaseHas等）
- Feature vs Unit テストガイドライン
- HTTP テスト、Database テストパターン
- Eloquent モック戦略

### ファイル構成

| ファイル | 行数目安 | 内容 |
|----------|---------|------|
| `plugin.json` | 10行 | プラグイン定義 |
| `laravel-quality/SKILL.md` | 80行 | コマンド + 基本パターン |
| `laravel-quality/reference.md` | 100行 | 詳細パターン + エラー対応 |
| `README.md` | 30行 | インストール手順 |

### SKILL.md 構成

```markdown
# Laravel Quality Check

## Commands
- PHPStan + Larastan
- Pest (php artisan test)
- Laravel Pint

## Pest Laravel Helpers
- actingAs(), assertDatabaseHas(), etc.

## Test Categories
- Feature vs Unit

## Quality Standards
```

### reference.md 構成

```markdown
# reference

## Larastan Rules
- 推奨設定

## Test Patterns
- HTTP Tests
- Database Tests
- Mocking Facades

## Error Handling
- 典型的なエラーと対応
```

## Test List

### TODO

（なし）

### WIP

（なし）

### DONE

- [x] TC-01: plugin.json が存在する
- [x] TC-02: SKILL.md が100行以下（91行）
- [x] TC-03: reference.md が存在する（127行）
- [x] TC-04: Pest Laravel helpers セクションがある
- [x] TC-05: Feature vs Unit の説明がある
- [x] TC-06: HTTP テストパターンがある

## Notes

- tdd-flask の構造を参考にする
- tdd-php との違い: Larastan, Pest Plugin, Laravel固有パターン
