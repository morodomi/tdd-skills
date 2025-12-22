# flutter-quality Reference

## Analysis Options

### analysis_options.yaml

```yaml
include: package:flutter_lints/flutter.yaml

analyzer:
  strong-mode:
    implicit-casts: false
    implicit-dynamic: false
  errors:
    missing_return: error
    missing_required_param: error
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"

linter:
  rules:
    - always_declare_return_types
    - avoid_print
    - prefer_const_constructors
    - prefer_final_fields
    - require_trailing_commas
```

### 厳格な設定

```yaml
analyzer:
  language:
    strict-casts: true
    strict-inference: true
    strict-raw-types: true
```

## Test Configuration

### テストファイル構成

```
test/
├── widget_test.dart        # Widgetテスト
├── unit/                   # ユニットテスト
│   └── service_test.dart
└── integration/            # 統合テスト
    └── app_test.dart
```

### テスト例

```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Counter', () {
    test('初期値は0', () {
      final counter = Counter();
      expect(counter.value, 0);
    });

    test('incrementで1増加', () {
      final counter = Counter();
      counter.increment();
      expect(counter.value, 1);
    });
  });
}
```

### Widget テスト

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Counter increments', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('0'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('1'), findsOneWidget);
  });
}
```

## CI/CD Integration

### GitHub Actions

```yaml
name: Flutter CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.x'
          channel: 'stable'

      - name: Install dependencies
        run: flutter pub get

      - name: Analyze
        run: dart analyze --fatal-infos

      - name: Format check
        run: dart format --output=none --set-exit-if-changed .

      - name: Test
        run: flutter test --coverage
```

## Error Handling

### Analyze エラー

```
エラー: The argument type 'String' can't be assigned to the parameter type 'int'.

対応:
1. 型を確認
2. 型変換を追加（int.parse()等）
```

### Format エラー

```
エラー: lib/main.dart would change

対応:
dart format . で自動修正
```

### Test エラー

```
エラー: Expected: <1>  Actual: <0>

対応:
1. テストの期待値を確認
2. 実装を確認
```

## Useful Packages

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
  mockito: ^5.4.0
  build_runner: ^2.4.0
```
