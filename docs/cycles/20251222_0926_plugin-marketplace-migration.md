---
feature: infrastructure
cycle: plugin-marketplace-migration
phase: DONE
created: 2025-12-22 09:26
updated: 2025-12-22 09:50
---

# Plugin/Marketplace構造への移行

## Scope Definition

### 今回実装する範囲

- [x] plugins/ ディレクトリ構造作成
- [x] tdd-core Plugin作成（言語非依存のTDD Skills）
- [x] tdd-php Plugin作成（PHP固有: PHPStan, Pint, PHPUnit）
- [x] tdd-python Plugin作成（Python固有: mypy, black, pytest）
- [x] marketplace.json 作成
- [x] 既存 templates/ との互換性維持

### 今回実装しない範囲

- ❌ tdd-hugo Plugin（次サイクル）
- ❌ tdd-wordpress Plugin（次サイクル）
- ❌ ux-design Plugin分離（次サイクル）
- ❌ 既存 templates/ の削除（互換性維持のため残す）

### 変更予定ファイル

```
plugins/
├── tdd-core/
│   ├── .claude-plugin/plugin.json
│   ├── skills/
│   │   ├── tdd-init/
│   │   ├── tdd-plan/
│   │   ├── tdd-red/
│   │   ├── tdd-green/
│   │   ├── tdd-refactor/
│   │   ├── tdd-review/
│   │   └── tdd-commit/
│   └── README.md
├── tdd-php/
│   ├── .claude-plugin/plugin.json
│   ├── skills/
│   │   └── php-quality/
│   └── README.md
├── tdd-python/
│   ├── .claude-plugin/plugin.json
│   ├── skills/
│   │   └── python-quality/
│   └── README.md
└── .claude-plugin/
    └── marketplace.json
```

計: 約20ファイル

## Context & Dependencies

### 参照ドキュメント

- [Claude Code Plugins](https://code.claude.com/docs/en/plugins.md)
- [Plugin Marketplaces](https://code.claude.com/docs/en/plugin-marketplaces.md)

### 設計原則

1. **tdd-core**: 言語非依存のTDDワークフロー（7フェーズ）
2. **tdd-php/python**: 言語固有の品質チェックコマンド
3. **組み合わせ**: tdd-core + tdd-php でPHP開発環境

### 関連Issue

- Issue #5: Plugin/Marketplace構造への移行

## Test List

### TODO

（なし）

### WIP

（なし）

### DISCOVERED

（なし）

### DONE

- [x] TC-01: plugins/tdd-core/.claude-plugin/plugin.json が有効
- [x] TC-02: tdd-core に7つのTDD Skillsが含まれる
- [x] TC-03: plugins/tdd-php/.claude-plugin/plugin.json が有効
- [x] TC-04: plugins/tdd-python/.claude-plugin/plugin.json が有効
- [x] TC-05: marketplace.json が有効

## Implementation Notes

### やりたいこと

templates/ の重複構造から、Plugin/Marketplace 構造に移行。
tdd-core（共通）+ 言語差分 Plugin の組み合わせで柔軟に対応。

### 使い方イメージ

```bash
# Marketplace登録
/plugin marketplace add morodomi/tdd-skills

# Laravel開発者
/plugin install tdd-core@tdd-skills
/plugin install tdd-php@tdd-skills

# Flask開発者
/plugin install tdd-core@tdd-skills
/plugin install tdd-python@tdd-skills
```

## Progress Log

### 2025-12-22 09:26 - INIT

- Cycle doc作成
- Issue #5 から要件確認

### 2025-12-22 09:30 - PLAN

- Plugin構造設計
- tdd-core + tdd-php + tdd-python の3 Plugin構成

### 2025-12-22 09:35 - RED

- scripts/test-plugins-structure.sh 作成
- 11テスト（全て失敗）

### 2025-12-22 09:40 - GREEN

- tdd-core Plugin作成（7 TDD Skills）
- tdd-php Plugin作成（php-quality Skill）
- tdd-python Plugin作成（python-quality Skill）
- marketplace.json作成
- 11テスト全て通過

### 2025-12-22 09:45 - REFACTOR

- plugins/README.md追加

### 2025-12-22 09:48 - REVIEW

- 全テスト通過確認（Plugin: 11, Skills: 28）

### 2025-12-22 09:50 - COMMIT

- `9b30c94` - 46 files, +4,162 lines
- Closes #5

---

## 完了
