# tdd-parallel Reference

詳細情報。必要時のみ参照。

## Why Agent Teams Only?

| 観点 | レビュー (quality-gate) | 調査 (tdd-diagnose) | 開発 (tdd-parallel) |
|------|----------------------|--------------------|--------------------|
| 処理 | 読み取り専用 | 読み取り専用 | 書き込み（実装） |
| 通信 | あれば便利 | あれば便利 | **必須**（API契約共有） |
| Subagent | 可能 | 可能 | 不可（通信不可） |

Agent Teams 必須の理由:
- レイヤー間の API 契約変更を broadcast で即時共有する必要がある
- Subagent (Task tool) はワーカー間通信をサポートしない
- 書き込み処理の並列化にはファイル競合検出が必要で、Lead の統括が不可欠

## レイヤー分割ガイド

### 推奨レイヤー数: 2-4

| レイヤー数 | 推奨度 | 理由 |
|-----------|--------|------|
| 1 | 非推奨 | 通常 TDD で十分 |
| 2-4 | 推奨 | 並列化の効果が高く管理可能 |
| 5-6 | 注意 | コスト増、管理複雑化 |
| 7+ | 非推奨 | レイヤー統合を検討 |

### レイヤー分割の例

#### Web アプリケーション（3レイヤー）
| レイヤー | ファイル | テスト |
|---------|---------|--------|
| Frontend | src/components/, src/pages/ | tests/components/ |
| Backend API | src/api/, src/services/ | tests/api/ |
| Database | migrations/, src/models/ | tests/models/ |

#### モバイルアプリ + API（2レイヤー）
| レイヤー | ファイル | テスト |
|---------|---------|--------|
| Mobile | lib/screens/, lib/widgets/ | test/screens/ |
| API | api/routes/, api/models/ | api/tests/ |

### レイヤー分離の原則

1. **ファイル独立性**: 各レイヤーのファイルが重複しないこと
2. **テスト独立性**: 各レイヤーのテストが独立実行可能なこと
3. **API契約**: レイヤー間の接点は API 契約（型定義、エンドポイント仕様）で定義

## API 契約テンプレート

レイヤー間の接点を事前定義:

```markdown
### API Contract: [エンドポイント名]
- Method: GET/POST/PUT/DELETE
- Path: /api/v1/resource
- Request: { field: type }
- Response: { field: type }
- Status: 200/201/400/404/500
```

## ファイル競合検出

Phase 2 で以下をチェック:

```bash
# 各レイヤーのファイル一覧を取得して重複確認
comm -12 <(sort layer_a_files.txt) <(sort layer_b_files.txt)
```

共有ファイル検出時の対応:
1. 共有ファイルを1つのレイヤーに帰属させる
2. 帰属不可の場合、該当レイヤーを逐次実行に降格

## tdd-plan レイヤー検出

tdd-plan Step 5.5 で使用するレイヤー検出条件:

| 条件 | 判定 |
|------|------|
| In Scope に Backend + Frontend が含まれる | クロスレイヤー |
| Files to Change に 3+ ディレクトリ接頭辞 | クロスレイヤー |
| Scope Layer が "Both" | クロスレイヤー |

検出時は AskUserQuestion で tdd-parallel の利用を提案。
