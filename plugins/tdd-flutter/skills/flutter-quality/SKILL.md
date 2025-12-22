---
name: flutter-quality
description: Flutter品質チェック。静的解析/フォーマット/テスト実行時に使用。「Flutterの品質チェック」で起動。
allowed-tools: Bash, Read, Grep, Glob
---

# Flutter Quality Check

Flutter/Dart プロジェクトの品質チェックツール。

## Commands

| ツール | コマンド | 用途 |
|--------|---------|------|
| Analyze | `dart analyze` | 静的解析 |
| Format | `dart format .` | フォーマット |
| Test | `flutter test` | テスト実行 |
| Coverage | `flutter test --coverage` | カバレッジ |

## Usage

### 静的解析

```bash
# 基本
dart analyze

# 特定ディレクトリ
dart analyze lib/

# 厳格モード（fatal-infos）
dart analyze --fatal-infos
```

### コードフォーマット

```bash
# チェック
dart format --output=none --set-exit-if-changed .

# 自動修正
dart format .

# 特定ディレクトリ
dart format lib/ test/
```

### テスト実行

```bash
# 基本
flutter test

# 特定ファイル
flutter test test/widget_test.dart

# カバレッジ付き
flutter test --coverage

# レポート生成
genhtml coverage/lcov.info -o coverage/html
```

### パッケージ管理

```bash
# 依存関係取得
flutter pub get

# 依存関係更新
flutter pub upgrade

# outdated確認
flutter pub outdated
```

## Quality Standards

| 項目 | 目標 |
|------|------|
| Analyze | issues 0 |
| Format | エラー0 |
| カバレッジ | 90%+ |

## Reference

- 詳細: `reference.md`
