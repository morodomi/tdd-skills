---
name: ts-quality
description: TypeScript品質チェック。型チェック/ESLint/テスト実行時に使用。「TSの品質チェック」「型チェック」で起動。
allowed-tools: Bash, Read, Grep, Glob
---

# TypeScript Quality Check

TypeScript プロジェクトの品質チェックツール。

## Commands

| ツール | コマンド | 用途 |
|--------|---------|------|
| Type Check | `npx tsc --noEmit` | 型チェック |
| ESLint | `npx eslint .` | 静的解析 |
| Prettier | `npx prettier --check .` | フォーマットチェック |
| Jest | `npx jest` | テスト実行 |
| Vitest | `npx vitest run` | テスト実行 |

## Usage

### 型チェック

```bash
# 基本
npx tsc --noEmit

# watch モード
npx tsc --noEmit --watch

# 特定ファイル
npx tsc --noEmit src/index.ts
```

### 静的解析

```bash
# 基本
npx eslint .

# 自動修正
npx eslint . --fix

# TypeScript ファイルのみ
npx eslint . --ext .ts,.tsx
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
| 型エラー | 0 |
| ESLint | エラー0 |
| Prettier | エラー0 |
| カバレッジ | 90%+ |

## Reference

- 詳細: `reference.md`
