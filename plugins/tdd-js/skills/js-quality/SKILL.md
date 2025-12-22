---
name: js-quality
description: JavaScript品質チェック。ESLint/Prettier/Jest実行時に使用。「JSの品質チェック」「静的解析」で起動。
allowed-tools: Bash, Read, Grep, Glob
---

# JavaScript Quality Check

JavaScript プロジェクトの品質チェックツール。

## Commands

| ツール | コマンド | 用途 |
|--------|---------|------|
| ESLint | `npx eslint .` | 静的解析 |
| Prettier | `npx prettier --check .` | フォーマットチェック |
| Jest | `npx jest` | テスト実行 |
| Vitest | `npx vitest run` | テスト実行 |

## Usage

### 静的解析

```bash
# 基本
npx eslint .

# 自動修正
npx eslint . --fix

# 特定ディレクトリ
npx eslint src/ tests/
```

### コードフォーマット

```bash
# チェック
npx prettier --check .

# 自動修正
npx prettier --write .
```

### テスト実行

```bash
# Jest
npx jest
npx jest --watch
npx jest --coverage

# Vitest
npx vitest run
npx vitest --coverage
```

## Quality Standards

| 項目 | 目標 |
|------|------|
| ESLint | エラー0 |
| Prettier | エラー0 |
| カバレッジ | 90%+ |

## Reference

- 詳細: `reference.md`
