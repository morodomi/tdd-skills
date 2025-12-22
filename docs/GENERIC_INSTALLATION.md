# 汎用 ClaudeSkills インストールガイド

**最終更新**: 2025-12-22
**対象**: 任意のプログラミング言語/フレームワーク

---

## Plugin インストール（推奨）

```bash
# TDDワークフロー
/plugin install tdd-core@tdd-skills

# 言語別品質ツール
/plugin install tdd-php@tdd-skills      # PHP
/plugin install tdd-python@tdd-skills   # Python
```

詳細: [plugins/README.md](../plugins/README.md)

---

## Template インストール（レガシー）

以下はTemplate方式のインストール手順です。新規プロジェクトにはPlugin方式を推奨します。

---

## 前提条件

### 必須

- **Git**: バージョン管理用（推奨）
- **Claude Code**: CLI環境
- **テストフレームワーク**: プロジェクトに適したもの（Jest, pytest, PHPUnit, Go test等）

### 推奨

- **Node.js**: 18以上（MCP統合用）
- **静的解析ツール**: ESLint, mypy, PHPStan, golangci-lint等
- **フォーマッター**: Prettier, black, Laravel Pint, gofmt等

---

## 自動インストール（推奨）

### プロジェクトのルートでインストール

```bash
cd /path/to/your-project
bash /path/to/ClaudeSkills/templates/generic/install.sh
```

### 実行内容

1. `.claude/skills/` ディレクトリ作成
2. 7つのSkills配置（tdd-init, tdd-plan, tdd-red, tdd-green, tdd-refactor, tdd-review, tdd-commit）
3. `docs/tdd/` ディレクトリ作成
4. `CLAUDE.md.example` をコピー（CLAUDE.mdが存在しない場合）
5. MCP統合（Git/Filesystem/GitHub）

### MCPをスキップする場合

```bash
bash /path/to/ClaudeSkills/templates/generic/install.sh --skip-mcp
```

---

## 手動インストール

### 1. Skillsのコピー

```bash
cd /path/to/your-project
mkdir -p .claude/skills
cp -r /path/to/ClaudeSkills/templates/generic/.claude/skills/* .claude/skills/
```

### 2. ドキュメントディレクトリ作成

```bash
mkdir -p docs/tdd
touch docs/tdd/.gitkeep
```

### 3. CLAUDE.md 作成

```bash
cp /path/to/ClaudeSkills/templates/generic/CLAUDE.md.example CLAUDE.md
```

### 4. MCP統合（オプション）

```bash
bash /path/to/ClaudeSkills/scripts/install-mcp.sh
```

---

## カスタマイズ

汎用テンプレートは**最小コア**です。プロジェクトに合わせてカスタマイズしてください。

### 1. CLAUDE.md の編集

プロジェクト固有の情報を記入:

```markdown
## Project Overview

- **Type**: Web Application
- **Language**: JavaScript
- **Framework**: Express
- **Test Framework**: Jest
- **Quality Tools**: ESLint, Prettier

## Quality Standards

### テストカバレッジ
- **測定**: `npm test -- --coverage`

### 静的解析
- **ツール**: ESLint
- **実行**: `npm run lint`

### コーディング規約
- **ツール**: Prettier
- **実行**: `npm run format`
```

### 2. tdd-init のカスタマイズ

`.claude/skills/tdd-init/SKILL.md` を編集:

```markdown
# プロジェクト構造の検証

## 必須ファイル
- [ ] package.json が存在する
- [ ] .eslintrc.js が設定されている
- [ ] jest.config.js が設定されている

## 必須ディレクトリ
- [ ] src/ が存在する
- [ ] tests/ が存在する

## 依存関係の検証
- [ ] jest がインストールされている
- [ ] eslint がインストールされている
```

### 3. tdd-red のカスタマイズ

`.claude/skills/tdd-red/SKILL.md` を編集:

```markdown
# テストフレームワーク固有のルール

## Jest
- テストファイル名: `*.test.js` または `*.spec.js`
- テスト構造: `describe` と `test`/`it`
- モック: `jest.mock()` を使用

## 例
\`\`\`javascript
describe('Math operations', () => {
  test('adds two numbers', () => {
    // Given: 2つの数値
    const a = 1;
    const b = 2;

    // When: 足し算を実行
    const result = add(a, b);

    // Then: 正しい結果を返す
    expect(result).toBe(3);
  });
});
\`\`\`
```

### 4. tdd-review のカスタマイズ

`.claude/skills/tdd-review/SKILL.md` を編集:

```markdown
# 品質チェックコマンド

## 実行コマンド

### 静的解析
\`\`\`bash
npm run lint
\`\`\`

### テストカバレッジ
\`\`\`bash
npm test -- --coverage
\`\`\`

### コーディング規約
\`\`\`bash
npm run format:check
\`\`\`

## 品質基準

- 静的解析: エラー0件
- カバレッジ: 90%以上
- コーディング規約: 違反0件
```

---

## 使用例

### Node.js + Jest

#### プロジェクト構造

```
my-project/
├── src/
│   └── math.js
├── tests/
│   └── unit/
│       └── math.test.js
├── package.json
├── jest.config.js
├── .eslintrc.js
├── CLAUDE.md
└── .claude/
    └── skills/
        ├── tdd-init/
        ├── tdd-plan/
        ├── tdd-red/
        ├── tdd-green/
        ├── tdd-refactor/
        ├── tdd-review/
        └── tdd-commit/
```

#### package.json

```json
{
  "scripts": {
    "test": "jest",
    "test:watch": "jest --watch",
    "test:coverage": "jest --coverage",
    "lint": "eslint src tests",
    "format": "prettier --write \"src/**/*.js\" \"tests/**/*.js\"",
    "format:check": "prettier --check \"src/**/*.js\" \"tests/**/*.js\""
  },
  "devDependencies": {
    "jest": "^29.0.0",
    "eslint": "^8.0.0",
    "prettier": "^3.0.0"
  }
}
```

#### テスト例

```javascript
// tests/unit/math.test.js
describe('Math operations', () => {
  test('adds two numbers', () => {
    // Given: 2つの数値
    const a = 1;
    const b = 2;

    // When: 足し算を実行
    const result = add(a, b);

    // Then: 正しい結果を返す
    expect(result).toBe(3);
  });
});
```

---

### Python + pytest

#### プロジェクト構造

```
my-project/
├── src/
│   └── math.py
├── tests/
│   └── unit/
│       └── test_math.py
├── pyproject.toml
├── pytest.ini
├── mypy.ini
├── CLAUDE.md
└── .claude/
    └── skills/
        ├── tdd-init/
        ├── tdd-plan/
        ├── tdd-red/
        ├── tdd-green/
        ├── tdd-refactor/
        ├── tdd-review/
        └── tdd-commit/
```

#### pyproject.toml

```toml
[tool.pytest.ini_options]
testpaths = ["tests"]
python_files = ["test_*.py", "*_test.py"]
addopts = "--cov=src --cov-report=term-missing"

[tool.black]
line-length = 100
target-version = ['py311']

[tool.mypy]
python_version = "3.11"
strict = true
warn_return_any = true
warn_unused_configs = true
```

#### テスト例

```python
# tests/unit/test_math.py
def test_add_two_numbers():
    # Given: 2つの数値
    a = 1
    b = 2

    # When: 足し算を実行
    result = add(a, b)

    # Then: 正しい結果を返す
    assert result == 3
```

#### スクリプト例

```bash
# scripts/test.sh
#!/bin/bash
set -e

echo "Running tests..."
pytest

echo "Running type check..."
mypy src

echo "Running code style check..."
black --check src tests

echo "All checks passed!"
```

---

### PHP + PHPUnit

#### プロジェクト構造

```
my-project/
├── src/
│   └── Math.php
├── tests/
│   └── Unit/
│       └── MathTest.php
├── composer.json
├── phpunit.xml
├── phpstan.neon
├── pint.json
├── CLAUDE.md
└── .claude/
    └── skills/
        ├── tdd-init/
        ├── tdd-plan/
        ├── tdd-red/
        ├── tdd-green/
        ├── tdd-refactor/
        ├── tdd-review/
        └── tdd-commit/
```

#### composer.json

```json
{
  "require-dev": {
    "phpunit/phpunit": "^10.0",
    "phpstan/phpstan": "^1.10",
    "laravel/pint": "^1.0"
  },
  "scripts": {
    "test": "phpunit",
    "test:coverage": "phpunit --coverage-text",
    "stan": "phpstan analyse --memory-limit=1G",
    "pint": "pint",
    "pint:fix": "pint --repair",
    "check": [
      "@pint",
      "@stan",
      "@test"
    ]
  }
}
```

#### テスト例

```php
// tests/Unit/MathTest.php
use PHPUnit\Framework\TestCase;
use PHPUnit\Framework\Attributes\Test;

class MathTest extends TestCase
{
    #[Test]
    public function adds_two_numbers(): void
    {
        // Given: 2つの数値
        $a = 1;
        $b = 2;

        // When: 足し算を実行
        $result = add($a, $b);

        // Then: 正しい結果を返す
        $this->assertSame(3, $result);
    }
}
```

---

## TDD ワークフロー

### 1. INITフェーズ

```bash
# Claude Codeで「init」と入力
```

- TDDドキュメント作成（`docs/tdd/YYYYMMDD_hhmm_機能名.md`）
- 要件定義の記録
- 自動的にPLANフェーズへ遷移

### 2. PLANフェーズ

- 実装計画の作成
- テストケースの定義
- 必要なファイルのリストアップ
- 自動的にREDフェーズへ遷移

### 3. REDフェーズ

- 失敗するテストを作成
- Given/When/Then構造でテストを記述
- テストの実行（失敗を確認）
- 自動的にGREENフェーズへ遷移

### 4. GREENフェーズ

- 最小限の実装でテストを通す
- リファクタリングは後回し
- テストが通ることを確認
- 自動的にREFACTORフェーズへ遷移

### 5. REFACTORフェーズ

- コードを改善
- テストを維持しながらリファクタリング
- パフォーマンス、可読性の向上
- 自動的にREVIEWフェーズへ遷移

### 6. REVIEWフェーズ

- 品質チェック実行
  - 静的解析: エラー0件
  - カバレッジ: 90%以上
  - コーディング規約: 違反0件
- すべての基準を満たすまで改善
- 自動的にCOMMITフェーズへ遷移

### 7. COMMITフェーズ

- 変更をコミット
- コミットメッセージの作成
- Git操作の実行
- ワークフロー完了

---

## トラブルシューティング

### Skills が認識されない

**症状**: Claude Codeで「init」と入力しても反応がない

**解決策**:
```bash
# Skillsディレクトリが存在するか確認
ls -la .claude/skills/

# tdd-initが存在するか確認
ls .claude/skills/tdd-init/SKILL.md

# Claude Codeを再起動
```

### MCP統合が動作しない

**症状**: Git操作が自動化されない

**解決策**:
```bash
# MCPが正しくインストールされているか確認
claude mcp list

# Git MCPが表示されるはず:
# git
# filesystem
# github

# 表示されない場合は再インストール
bash /path/to/ClaudeSkills/scripts/install-mcp.sh
```

### テストが実行できない

**症状**: テストコマンドでエラーが発生

**解決策**:
```bash
# テストフレームワークがインストールされているか確認
# Node.js
npm list jest

# Python
pip show pytest

# PHP
composer show phpunit/phpunit

# インストールされていない場合
# Node.js
npm install --save-dev jest

# Python
pip install pytest

# PHP
composer require --dev phpunit/phpunit
```

### カバレッジが取得できない

**症状**: カバレッジレポートが表示されない

**解決策**:

#### Node.js + Jest
```json
// package.json
{
  "jest": {
    "collectCoverage": true,
    "coverageThreshold": {
      "global": {
        "branches": 90,
        "functions": 90,
        "lines": 90,
        "statements": 90
      }
    }
  }
}
```

#### Python + pytest
```ini
# pytest.ini
[pytest]
addopts = --cov=src --cov-report=term-missing --cov-fail-under=90
```

#### PHP + PHPUnit
```xml
<!-- phpunit.xml -->
<coverage>
    <include>
        <directory suffix=".php">src</directory>
    </include>
    <report>
        <text outputFile="php://stdout" showUncoveredFiles="true"/>
    </report>
</coverage>
```

---

## よくある質問

### Q1: どの言語/フレームワークで使えますか？

**A**: 任意の言語/フレームワークで使用できます。
- **Node.js**: Jest, Mocha, Vitest等
- **Python**: pytest, unittest等
- **PHP**: PHPUnit, Pest等
- **Go**: go test
- **Rust**: cargo test
- **その他**: テストフレームワークがあれば使用可能

### Q2: 既存プロジェクトに後から追加できますか？

**A**: はい、可能です。
```bash
cd /path/to/existing-project
bash /path/to/ClaudeSkills/templates/generic/install.sh
```

既存の `.claude/` ディレクトリがある場合は上書き確認されます。

### Q3: 言語固有のテンプレートはありますか？

**A**: はい、以下のテンプレートが用意されています：
- **Laravel**: `templates/laravel/`
- **Bedrock/WordPress**: `templates/bedrock/`

これらはカスタマイズの参考になります。

### Q4: MCPは必須ですか？

**A**: 必須ではありませんが、推奨します。
- MCPなし: 手動でGit操作
- MCPあり: Git操作の自動化（コミット、ブランチ作成等）

スキップする場合:
```bash
bash install.sh --skip-mcp
```

### Q5: カスタマイズ方法を詳しく知りたい

**A**: 以下を参照してください：
- `CLAUDE.md.example`: プロジェクト設定のテンプレート
- `templates/laravel/`: Laravel用カスタマイズ例
- `templates/bedrock/`: WordPress用カスタマイズ例

---

## 次のステップ

### 1. CLAUDE.md をカスタマイズ

```bash
# プロジェクト固有の設定を記入
vim CLAUDE.md
```

### 2. Skillsをカスタマイズ（必要に応じて）

```bash
# プロジェクト検証ルール
vim .claude/skills/tdd-init/SKILL.md

# テストフレームワーク固有ルール
vim .claude/skills/tdd-red/SKILL.md

# 品質チェックコマンド
vim .claude/skills/tdd-review/SKILL.md
```

### 3. TDD開発を開始

```bash
# Claude Code起動
# 「init」と入力してTDD開始
```

### 4. ドキュメントを確認

- `CLAUDE.md`: プロジェクト設定とガイドライン
- `ClaudeSkills/README.md`: フレームワークの概要
- `ClaudeSkills/docs/MCP_INSTALLATION.md`: MCP設定

---

## サポート

問題が発生した場合:
1. このドキュメントのトラブルシューティングセクションを確認
2. ClaudeSkillsリポジトリのIssuesを検索
3. 新しいIssueを作成

---

*このガイドは ClaudeSkills Phase 5 の一部です*
