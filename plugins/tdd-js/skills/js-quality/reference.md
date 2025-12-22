# js-quality Reference

## ESLint Configuration

### eslint.config.js (Flat Config)

```javascript
import js from '@eslint/js';

export default [
  js.configs.recommended,
  {
    rules: {
      'no-unused-vars': 'error',
      'no-console': 'warn',
    },
  },
];
```

### .eslintrc.js (Legacy)

```javascript
module.exports = {
  env: {
    browser: true,
    es2021: true,
    node: true,
  },
  extends: ['eslint:recommended'],
  parserOptions: {
    ecmaVersion: 'latest',
    sourceType: 'module',
  },
  rules: {
    'no-unused-vars': 'error',
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
  "trailingComma": "es5"
}
```

## Jest Configuration

### jest.config.js

```javascript
module.exports = {
  testEnvironment: 'node',
  testMatch: ['**/*.test.js', '**/*.spec.js'],
  collectCoverageFrom: ['src/**/*.js'],
  coverageThreshold: {
    global: {
      branches: 90,
      functions: 90,
      lines: 90,
      statements: 90,
    },
  },
};
```

## Vitest Configuration

### vitest.config.js

```javascript
import { defineConfig } from 'vitest/config';

export default defineConfig({
  test: {
    globals: true,
    environment: 'node',
    coverage: {
      provider: 'v8',
      reporter: ['text', 'html'],
    },
  },
});
```

## Alpine.JS Testing

```javascript
import Alpine from 'alpinejs';

// テスト前にAlpineを初期化
beforeEach(() => {
  document.body.innerHTML = `
    <div x-data="{ count: 0 }">
      <button @click="count++">Increment</button>
      <span x-text="count"></span>
    </div>
  `;
  Alpine.start();
});
```

## Error Handling

### ESLint エラー

```
エラー: Parsing error: Unexpected token

対応:
1. parserOptions.ecmaVersion を確認
2. sourceType: 'module' を設定
```

### Jest エラー

```
エラー: Cannot use import statement outside a module

対応:
1. babel-jest を設定
2. または package.json に "type": "module"
```
