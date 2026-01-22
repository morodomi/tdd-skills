# Git Safety Rules

## 禁止事項

- `--no-verify` の使用禁止
- `main`/`master` への直接push禁止
- `--force` push禁止（force-with-leaseは許可）
- 秘密鍵・認証情報のコミット禁止

## 推奨フロー

1. `develop` or `feature/*` ブランチで作業
2. PR経由で `main` にマージ
3. pre-commit hook を必ず通す

## ブランチ保護

| ブランチ | push | force push | 直接commit |
|---------|------|------------|-----------|
| main    | X    | X          | X         |
| develop | !    | X          | !         |
| feature/* | OK | X          | OK        |
