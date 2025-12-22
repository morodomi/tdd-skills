# ts-quality Reference

## TypeScript Configuration

### tsconfig.json (推奨)

```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "NodeNext",
    "moduleResolution": "NodeNext",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "outDir": "./dist",
    "rootDir": "./src",
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
```

### strict オプション詳細

```json
{
  "compilerOptions": {
    "strict": true,
    // 以下が有効になる
    // "noImplicitAny": true,
    // "strictNullChecks": true,
    // "strictFunctionTypes": true,
    // "strictBindCallApply": true,
    // "strictPropertyInitialization": true,
    // "noImplicitThis": true,
    // "alwaysStrict": true
  }
}
```

## ESLint Configuration

### eslint.config.js (Flat Config)

```javascript
import eslint from '@eslint/js';
import tseslint from 'typescript-eslint';

export default tseslint.config(
  eslint.configs.recommended,
  ...tseslint.configs.recommended,
  {
    rules: {
      '@typescript-eslint/no-unused-vars': 'error',
      '@typescript-eslint/explicit-function-return-type': 'warn',
    },
  }
);
```

### .eslintrc.js (Legacy)

```javascript
module.exports = {
  env: {
    node: true,
    es2021: true,
  },
  extends: [
    'eslint:recommended',
    'plugin:@typescript-eslint/recommended',
  ],
  parser: '@typescript-eslint/parser',
  parserOptions: {
    ecmaVersion: 'latest',
    sourceType: 'module',
  },
  plugins: ['@typescript-eslint'],
  rules: {
    '@typescript-eslint/no-unused-vars': 'error',
  },
};
```

## Prettier Configuration

### .prettierrc

```json
{
  "semi": true,
  "singleQuote": true,
  "tabWidth": 2,
  "trailingComma": "es5",
  "printWidth": 100
}
```

## Jest Configuration

### jest.config.ts

```typescript
import type { Config } from 'jest';

const config: Config = {
  preset: 'ts-jest',
  testEnvironment: 'node',
  testMatch: ['**/*.test.ts', '**/*.spec.ts'],
  collectCoverageFrom: ['src/**/*.ts'],
  coverageThreshold: {
    global: {
      branches: 90,
      functions: 90,
      lines: 90,
      statements: 90,
    },
  },
};

export default config;
```

## Vitest Configuration

### vitest.config.ts

```typescript
import { defineConfig } from 'vitest/config';

export default defineConfig({
  test: {
    globals: true,
    environment: 'node',
    include: ['**/*.test.ts', '**/*.spec.ts'],
    coverage: {
      provider: 'v8',
      reporter: ['text', 'html'],
      thresholds: {
        branches: 90,
        functions: 90,
        lines: 90,
        statements: 90,
      },
    },
  },
});
```

## Error Handling

### 型エラー

```
エラー: TS2345: Argument of type 'string' is not assignable to parameter of type 'number'.

対応:
1. 引数の型を確認
2. 型アサーションが必要か検討
3. ジェネリクスの使用を検討
```

### ESLint エラー

```
エラー: @typescript-eslint/no-explicit-any

対応:
1. 具体的な型を定義
2. unknown 型の使用を検討
3. ジェネリクスの使用を検討
```

### Jest/Vitest エラー

```
エラー: Cannot find module '@/utils'

対応:
1. tsconfig.json の paths 設定確認
2. jest.config.ts の moduleNameMapper 設定
3. vitest.config.ts の alias 設定
```

## Package Installation

```bash
# TypeScript
npm install -D typescript

# ESLint + TypeScript
npm install -D eslint @eslint/js typescript-eslint

# Prettier
npm install -D prettier

# Jest + TypeScript
npm install -D jest ts-jest @types/jest

# Vitest
npm install -D vitest @vitest/coverage-v8
```
