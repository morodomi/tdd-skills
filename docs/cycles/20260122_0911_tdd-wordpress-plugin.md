# tdd-wordpress プラグイン

## Status: DONE

## INIT

### Scope Definition

WordPress/Bedrock固有のTDD品質チェックプラグインを作成。

Issue: #13

### Target Structure

```
plugins/tdd-wordpress/
├── .claude-plugin/
│   └── plugin.json
├── skills/
│   └── wordpress-quality/
│       ├── SKILL.md
│       └── reference.md
└── README.md
```

### Tools

- **静的解析**: PHPStan + PHPStan for WordPress
- **コーディング規約**: WordPress Coding Standards (WPCS)
- **テスト**: PHPUnit (WP_UnitTestCase)

### Out of Scope

- tdd-core の修正
- tdd-php の修正

### Environment

#### Scope
- Layer: Backend
- Plugin: tdd-wordpress（新規）
- 依存: tdd-core

#### Runtime
- Claude Code Plugins

## PLAN

### 設計方針

**方式: 補完型（A）**

tdd-php は汎用PHP品質ツール。tdd-wordpress は WordPress 固有のテストパターンに特化し、tdd-php を参照。

**tdd-php との関係**:
- tdd-php: PHPStan基本、phpcs基本、PHPUnit基本
- tdd-wordpress: WordPress固有パターン + 「詳細は tdd-php 参照」

**tdd-wordpress 固有コンテンツ**:
- PHPStan for WordPress 設定
- WordPress Coding Standards (WPCS)
- WP_UnitTestCase のテストヘルパー（`$this->factory()` 等）
- Hook テスト、REST API テストパターン

### ファイル構成

| ファイル | 行数目安 | 内容 |
|----------|---------|------|
| `plugin.json` | 10行 | プラグイン定義 |
| `wordpress-quality/SKILL.md` | 80行 | コマンド + 基本パターン |
| `wordpress-quality/reference.md` | 100行 | 詳細パターン + エラー対応 |
| `README.md` | 30行 | インストール手順 |

### SKILL.md 構成

```markdown
# WordPress Quality Check

## Commands
- PHPStan (phpstan-wordpress)
- WPCS (phpcs)
- PHPUnit

## WP_UnitTestCase Helpers
- $this->factory()->user->create()
- $this->go_to()
- set_current_user()

## Test Categories
- Unit vs Integration

## Quality Standards
```

### reference.md 構成

```markdown
# reference

## PHPStan for WordPress
- 推奨設定

## WPCS Rules
- 主要ルール

## Test Patterns
- Hook Tests
- REST API Tests
- Custom Post Type Tests

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
- [x] TC-02: SKILL.md が100行以下（92行）
- [x] TC-03: reference.md が存在する
- [x] TC-04: WP_UnitTestCase helpers セクションがある
- [x] TC-05: Unit vs Integration の説明がある
- [x] TC-06: Hook テストパターンがある
- [x] TC-07: REST API テストパターンがある

## Notes

- tdd-laravel の構造を参考にする
- tdd-php との違い: PHPStan for WordPress, WPCS, WP_UnitTestCase
