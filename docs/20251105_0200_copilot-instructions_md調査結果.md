# copilot-instructions.md 調査結果

**作成日時**: 2025-11-05 02:00
**目的**: GitHub Copilot用の `copilot-instructions.md` について調査し、CLAUDE.mdとの違いやMCP統合を理解する

---

## 1. copilot-instructions.md とは？

### 概要

GitHub Copilotに対してプロジェクト固有の指示を与えるファイルです。

- **配置場所**: `.github/copilot-instructions.md`
- **導入時期**: 2024年10月に追加された機能
- **動作**: GitHub Copilotがコード補完・チャット応答・コードレビュー時に自動的に読み込む
- **設定**: 特別な設定不要、ファイルを配置するだけ

参考:
- [GitHub Copilotを使っている人は全員"copilot-instructions.md"を作成してください - Qiita](https://qiita.com/TooMe/items/873540da84567733d16b)
- [実はGitHub Copilotに前提情報を渡すことができる - Qiita](https://qiita.com/hashin2425/items/d038e0d3de61e51ee3e0)

### 2025年の最新アップデート

- **Web UI対応**: github.com の Web サイト上でもカスタムインストラクションを設定可能に
- **リポジトリレベル + Web UI**: 両方で設定可能になった

参考: [github.comのCopilotにカスタムインストラクションが指定可能になりました - Alternative Architecture DOJO](https://aadojo.alterbooth.com/entry/2025/02/16/155228)

---

## 2. 推奨される構成

### 7つのセクション構成

以下のセクションを含めることが推奨されています：

#### 1. 前提条件

AIへの基本ルールを定義：

```markdown
## 前提条件

- 回答は必ず日本語で行う
- 200行を超える変更は事前に確認を求める
- コード生成時はコメントを含める
```

#### 2. アプリの概要

プロジェクトの目的と主要機能を簡潔に説明：

```markdown
## アプリの概要

このプロジェクトは、ユーザー管理機能を持つWebアプリケーションです。
主な機能：
- ユーザー登録・ログイン
- プロフィール管理
- 権限管理
```

#### 3. 技術スタック

使用言語、フレームワーク、ライブラリとバージョンを明記：

```markdown
## 技術スタック

- **言語**: TypeScript 5.0
- **フレームワーク**: Next.js 14.0
- **UI**: React 18.2, Tailwind CSS 3.3
- **状態管理**: Zustand 4.4
- **テスト**: Jest 29.0, React Testing Library 14.0
- **ビルドツール**: Vite 5.0
```

#### 4. ディレクトリ構成

主要なディレクトリと役割を説明：

```markdown
## ディレクトリ構成

```
src/
├── features/      # 機能ごとのコンポーネント
├── shared/        # 共通コンポーネント・ユーティリティ
├── api/           # APIクライアント
└── types/         # 型定義
```

**配置方針**:
- 機能ごとにfeatures配下に配置
- 複数機能で使う共通部品はshared配下
```

#### 5. アーキテクチャ・設計指針

採用パターンを記載：

```markdown
## アーキテクチャ・設計指針

- **設計**: Atomic Design + Feature-Based Architecture
- **状態管理**: Zustand（グローバル状態）、React Context（局所状態）
- **データフロー**: 単方向データフロー
- **型安全性**: TypeScript strict mode有効
```

#### 6. テスト方針

テストフレームワークと記述方針を明示：

```markdown
## テスト方針

- **単体テスト**: Jest + React Testing Library
- **E2Eテスト**: Playwright
- **カバレッジ目標**: 80%以上
- **テスト記述**: Given/When/Then形式でコメント記載
- **モック**: `__mocks__/` ディレクトリに配置
```

#### 7. アンチパターン

避けるべきパターンを明記：

```markdown
## アンチパターン

以下のパターンは使用禁止：

- `default export`（named exportを使用）
- `any`型（unknownを使用して型安全性を確保）
- インラインスタイル（Tailwind CSSを使用）
- `console.log`（デバッグ用ロガーを使用）
```

参考: [GitHub Copilotを使っている人は全員"copilot-instructions.md"を作成してください - Qiita](https://qiita.com/TooMe/items/873540da84567733d16b)

---

## 3. 実戦での効果と制限

### 効果

- **対話型UIで精度向上**: チャット形式での質問時に、プロジェクト固有の文脈を理解した回答が得られる
- **ゼロからのコード生成に強い**: 新規ファイル作成時に適切なコードが生成される
- **メンテナンスが容易**: 自然言語での記述が読みやすい

参考: [copilot-instructions.mdは使えるぞ！実戦投入レポート - Zenn](https://zenn.dev/sirosuzume/articles/9962625cde1298)

### 制限事項

- **サジェスト出力には未対応**: インライン補完（自動補完）では機能しない
  - 対話型UI（Copilot Chat）での使用が必須
- **ファイル/フォルダ生成不可**: 既存ツール（Hygen等）との併用が必要

参考: [copilot-instructions.mdは使えるぞ！実戦投入レポート - Zenn](https://zenn.dev/sirosuzume/articles/9962625cde1298)

---

## 4. CLAUDE.md との違い

### 基本的な役割の違い

| 項目 | copilot-instructions.md | CLAUDE.md |
|------|------------------------|-----------|
| **対象ツール** | GitHub Copilot | Claude Code |
| **配置場所** | `.github/copilot-instructions.md` | `CLAUDE.md`（プロジェクトルート） |
| **主な用途** | チーム全体の開発標準 | Claude固有の詳細ガイダンス |
| **自動生成** | 手動作成 | `/init` コマンドで生成可能 |
| **参照対象** | 他のファイルを参照しない | `.cursor/*.mdc`, `.cursorrules`, `.github/copilot-instructions.md` を参照 |

### 使い分けの指針

**copilot-instructions.md**:
- **チーム全体の標準**: コーディング規約、アーキテクチャ、テスト方針
- **GitHub Copilot特化**: Copilotユーザー全員に適用される
- **簡潔な記述**: 必要最小限の情報

**CLAUDE.md**:
- **Claude Code固有**: ビルドコマンド、Claude専用のワークフロー
- **詳細なガイダンス**: 長文の説明、複雑なルール
- **他ファイル参照**: 既存の `.github/copilot-instructions.md` を参照可能

### 併用戦略

両方のツールを使用するチームでは、以下の戦略が推奨されています：

1. **基本ルールをcopilot-instructions.mdに記載**
   - 技術スタック
   - ディレクトリ構成
   - コーディング規約

2. **CLAUDE.mdで参照**
   ```markdown
   # CLAUDE.md

   ## 開発ガイドライン

   基本的な開発標準は `.github/copilot-instructions.md` を参照してください。

   ## Claude固有の指示

   - ビルドコマンド: `npm run build`
   - テストコマンド: `npm test`
   ```

3. **同期コマンドの活用**
   - カスタムコマンド `/sync-instructions-workflow` で自動同期
   - 重複を避けながらコンテンツをマージ

参考: [Claude CodeとCopilot Custom Instructions併用するためのCustom Commands - Zenn](https://zenn.dev/flierinc/articles/41875e7e495218)

---

## 5. MCP (Model Context Protocol) との統合

### MCPとは？

**Model Context Protocol (MCP)** は、アプリケーションが大規模言語モデル（LLMs）とコンテキストを共有する方法を標準化するオープンスタンダードです。

- **目的**: AIが外部の情報源にアクセスできるようにする
- **提供元**: Anthropic（Claudeの開発元）
- **対応**: GitHub Copilot（2025年4月にパブリックプレビュー）

参考:
- [GitHub Copilot、Model Context Protocolをパブリックプレビューで利用可能に - gihyo.jp](https://gihyo.jp/article/2025/04/github-mcp)
- [Extending GitHub Copilot Chat with Model Context Protocol (MCP) servers - GitHub Docs](https://docs.github.com/en/copilot/how-tos/provide-context/use-mcp/extend-copilot-chat-with-mcp)

### GitHub CopilotでのMCP使用方法

#### 前提条件

- Visual Studio Code バージョン 1.99 以降

#### 設定手順

**1. VS Codeの設定を有効化**

```json
// settings.json
{
  "chat.agent.enabled": true,
  "chat.mcp.discovery": true
}
```

**2. MCP設定ファイルの作成**

`.vscode/mcp.json` を作成：

```json
{
  "inputs": [
    { "type": "promptString" }
  ],
  "servers": {
    "fetch": {
      "command": "uvx",
      "args": ["mcp-server-fetch"]
    },
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/path/to/allowed/files"]
    }
  }
}
```

**3. エージェントモードの使用**

- VS CodeのCopilot Chatを開く
- ポップアップメニューから「Agent」を選択
- チャットボックス内のツールアイコンで利用可能なMCPサーバーを確認

#### MCP使用例

**Fetch MCPサーバー**（URLの内容を取得）:
```
Fetch https://github.com/github/docs
```

**Filesystem MCPサーバー**（ファイルシステムへのアクセス）:
```
Read the contents of /path/to/file.md
```

参考: [Extending GitHub Copilot Chat with Model Context Protocol (MCP) servers - GitHub Docs](https://docs.github.com/en/copilot/how-tos/provide-context/use-mcp/extend-copilot-chat-with-mcp)

### MCPの利点

1. **外部データへのアクセス**
   - Webページの取得
   - ファイルシステムへのアクセス
   - データベースクエリ
   - API呼び出し

2. **標準化されたプロトコル**
   - 複数のAIツールで同じMCPサーバーを使用可能
   - Claude Code、GitHub Copilot、Cursorなどで共通

3. **拡張性**
   - カスタムMCPサーバーを作成可能
   - プロジェクト固有のツールを統合

参考: [VS Code の GitHub Copilot をカスタム指示と MCP で高度に使いこなす - TECHSCORE BLOG](https://blog.techscore.com/entry/20250526/advanced)

---

## 6. copilot-instructions.md と MCP の関係

### 役割の違い

| 項目 | copilot-instructions.md | MCP |
|------|------------------------|-----|
| **役割** | 静的なプロジェクト情報 | 動的な外部データアクセス |
| **内容** | コーディング規約、技術スタック | Web、ファイル、APIデータ |
| **更新頻度** | 低い（プロジェクト設定） | 高い（リアルタイムデータ） |
| **記述形式** | Markdown | JSON設定 + MCPサーバー |

### 併用の利点

**copilot-instructions.md**:
- プロジェクト固有のルールを定義
- 技術スタック、アーキテクチャを記載

**MCP**:
- 外部データをリアルタイムで取得
- Webページ、API、ファイルシステムへのアクセス

**例**:
```markdown
<!-- copilot-instructions.md -->
## 技術スタック

- Next.js 14.0
- TypeScript 5.0
```

```json
// .vscode/mcp.json
{
  "servers": {
    "fetch": {
      "command": "uvx",
      "args": ["mcp-server-fetch"]
    }
  }
}
```

→ Copilot Chatで「Next.js 14の最新ドキュメントを取得して、推奨されるディレクトリ構成を教えて」と質問すると、`copilot-instructions.md`の技術スタック情報と、MCPで取得した最新ドキュメントを組み合わせた回答が得られる。

---

## 7. ClaudeSkillsへの応用

### 現状のCLAUDE.mdとの比較

ClaudeSkillsプロジェクトでは、現在以下のファイルが存在します：

- `CLAUDE.md`: ClaudeSkills自体のプロジェクト設定
- `templates/generic/CLAUDE.md.example`: 汎用テンプレート
- `templates/laravel/CLAUDE.md.template`: Laravel用テンプレート
- `templates/bedrock/CLAUDE.md.template`: Bedrock用テンプレート

### copilot-instructions.md テンプレート追加の意義

1. **GitHub Copilotユーザーへの対応**
   - Claude Codeだけでなく、GitHub Copilotユーザーもサポート
   - より広いユーザーベースに対応

2. **クロスツール対応**
   - Claude Code + GitHub Copilot 併用時に同期可能
   - 両方のツールで一貫した開発体験

3. **標準化**
   - `.github/copilot-instructions.md` は業界標準として定着しつつある
   - チーム開発での採用が増加

### 提案: copilot-instructions.md テンプレートの作成

以下のテンプレートを作成することを提案します：

1. **templates/generic/.github/copilot-instructions.md.template**
   - 汎用版（言語・フレームワーク非依存）

2. **templates/laravel/.github/copilot-instructions.md.template**
   - Laravel固有の設定

3. **templates/bedrock/.github/copilot-instructions.md.template**
   - Bedrock/WordPress固有の設定

### テンプレートの構成案

```markdown
# GitHub Copilot Instructions

## 前提条件

- 回答は日本語で行う
- 大規模な変更は事前に確認を求める
- [Your project-specific rules]

## プロジェクト概要

[Your project description]

## 技術スタック

- **言語**: [Your language]
- **フレームワーク**: [Your framework]
- **テストフレームワーク**: [Your test framework]
- **静的解析**: [Your static analysis tool]
- **コードフォーマッター**: [Your code formatter]

## ディレクトリ構成

[Your directory structure]

## アーキテクチャ・設計指針

[Your architecture guidelines]

## テスト方針

[Your testing guidelines]

## コーディング規約

[Your coding standards]

## アンチパターン

[Your anti-patterns]

---

*このファイルは ClaudeSkills TDD Framework によって生成されました*
*詳細: https://github.com/yourname/ClaudeSkills*
```

### CLAUDE.md との連携

CLAUDE.md から copilot-instructions.md を参照：

```markdown
# CLAUDE.md

## 開発ガイドライン

基本的な開発標準は `.github/copilot-instructions.md` を参照してください。

## TDD ワークフロー

ClaudeSkills TDD Framework の7フェーズ：
INIT → PLAN → RED → GREEN → REFACTOR → REVIEW → COMMIT

詳細は各Skillファイル参照。
```

---

## 8. まとめ

### copilot-instructions.md の特徴

- **GitHub Copilot専用**のプロジェクト固有指示ファイル
- **2024年10月に追加**された比較的新しい機能
- **チーム全体の開発標準**を記載するのに適している
- **対話型UI（Copilot Chat）で効果を発揮**
- **インライン補完では未対応**

### CLAUDE.md との違い

- **copilot-instructions.md**: GitHub Copilot用、チーム標準
- **CLAUDE.md**: Claude Code用、詳細ガイダンス
- **併用可能**: 相互参照して内容を同期

### MCP統合

- **2025年4月にパブリックプレビュー**
- **外部データへのアクセス**が可能に
- **`.vscode/mcp.json`で設定**
- **copilot-instructions.mdと補完関係**

### ClaudeSkillsへの応用

以下のテンプレートを作成することを推奨：

1. `templates/generic/.github/copilot-instructions.md.template`
2. `templates/laravel/.github/copilot-instructions.md.template`
3. `templates/bedrock/.github/copilot-instructions.md.template`

各テンプレートに7つのセクション（前提条件、概要、技術スタック、ディレクトリ構成、アーキテクチャ、テスト方針、アンチパターン）を含める。

---

## 参考資料

### 公式ドキュメント

- [Extending GitHub Copilot Chat with Model Context Protocol (MCP) servers - GitHub Docs](https://docs.github.com/en/copilot/how-tos/provide-context/use-mcp/extend-copilot-chat-with-mcp)

### 技術記事

- [GitHub Copilotを使っている人は全員"copilot-instructions.md"を作成してください - Qiita](https://qiita.com/TooMe/items/873540da84567733d16b)
- [copilot-instructions.mdは使えるぞ！実戦投入レポート - Zenn](https://zenn.dev/sirosuzume/articles/9962625cde1298)
- [実はGitHub Copilotに前提情報を渡すことができる - Qiita](https://qiita.com/hashin2425/items/d038e0d3de61e51ee3e0)
- [Claude CodeとCopilot Custom Instructions併用するためのCustom Commands - Zenn](https://zenn.dev/flierinc/articles/41875e7e495218)
- [VS Code の GitHub Copilot をカスタム指示と MCP で高度に使いこなす - TECHSCORE BLOG](https://blog.techscore.com/entry/20250526/advanced)
- [GitHub Copilot、Model Context Protocolをパブリックプレビューで利用可能に - gihyo.jp](https://gihyo.jp/article/2025/04/github-mcp)

---

*この調査はClaudeSkillsプロジェクトの一部です*
