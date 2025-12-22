---
feature: infrastructure
cycle: plugin-marketplace-migration
phase: INIT
created: 2025-12-22 09:26
updated: 2025-12-22 09:26
---

# Plugin/Marketplace構造への移行

## Scope Definition

### 今回実装する範囲

- [ ] plugins/ ディレクトリ構造作成
- [ ] tdd-core Plugin作成（言語非依存のTDD Skills）
- [ ] tdd-php Plugin作成（PHP固有: PHPStan, Pint, PHPUnit）
- [ ] tdd-python Plugin作成（Python固有: mypy, black, pytest）
- [ ] marketplace.json 作成
- [ ] 既存 templates/ との互換性維持

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

- [ ] TC-01: plugins/tdd-core/.claude-plugin/plugin.json が有効
- [ ] TC-02: tdd-core に7つのTDD Skillsが含まれる
- [ ] TC-03: plugins/tdd-php/.claude-plugin/plugin.json が有効
- [ ] TC-04: plugins/tdd-python/.claude-plugin/plugin.json が有効
- [ ] TC-05: marketplace.json が有効
- [ ] TC-06: `/plugin validate .` が成功

### WIP

（現在なし）

### DISCOVERED

（現在なし）

### DONE

（現在なし）

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

---

## 次のステップ

1. [完了] INIT ← 現在
2. [次] PLAN
3. [ ] RED
4. [ ] GREEN
5. [ ] REFACTOR
6. [ ] REVIEW
7. [ ] COMMIT
