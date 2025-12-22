# php-quality Reference

## PHPStan Configuration

### phpstan.neon

```neon
includes:
    - ./vendor/nunomaduro/larastan/extension.neon  # Laravel用

parameters:
    level: 8
    paths:
        - app
        - tests
    excludePaths:
        - vendor
```

### レベル説明

| Level | チェック内容 |
|-------|-------------|
| 0 | 基本的な型チェック |
| 5 | 中級（nullable等） |
| 8 | 最高（strict） |

## Pint Configuration

### pint.json

```json
{
    "preset": "laravel",
    "rules": {
        "simplified_null_return": true,
        "ordered_imports": {
            "sort_algorithm": "alpha"
        }
    }
}
```

## Pest vs PHPUnit

| 項目 | PHPUnit | Pest |
|------|---------|------|
| 構文 | クラスベース | 関数ベース |
| Laravel | 標準 | pest-plugin-laravel |
| 推奨 | 従来プロジェクト | 新規プロジェクト |

## Error Handling

### PHPStan エラー

```
⚠️ PHPStan エラーが発生しました。

対応:
1. 型ヒントを追加
2. @var アノテーションを追加
3. phpstan-baseline.neon で一時的に除外
```

### Pint エラー

```
⚠️ Pint でフォーマットエラーが発生しました。

対応:
./vendor/bin/pint --dirty  # 変更ファイルのみ修正
```
