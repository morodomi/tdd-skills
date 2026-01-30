---
feature: remove-version-field
cycle: 20260130_1000
phase: DONE
created: 2026-01-30 10:00
updated: 2026-01-30 10:00
---

# Remove version field from plugin.json

## Scope Definition

### In Scope
- [ ] 全plugin.jsonからversionフィールドを削除
- [ ] 構造テストがversionを必須としていないことを確認

### Out of Scope
- plugin.json以外のフィールド変更 (Reason: スコープ外)

### Files to Change (target: 10 or less)
- plugins/tdd-core/.claude-plugin/plugin.json (edit)
- plugins/tdd-php/.claude-plugin/plugin.json (edit)
- plugins/tdd-python/.claude-plugin/plugin.json (edit)
- plugins/tdd-ts/.claude-plugin/plugin.json (edit)
- plugins/tdd-js/.claude-plugin/plugin.json (edit)
- plugins/tdd-flask/.claude-plugin/plugin.json (edit)
- plugins/tdd-laravel/.claude-plugin/plugin.json (edit)
- plugins/tdd-hugo/.claude-plugin/plugin.json (edit)
- plugins/tdd-flutter/.claude-plugin/plugin.json (edit)
- plugins/tdd-wordpress/.claude-plugin/plugin.json (edit)

## Environment

### Scope
- Layer: N/A (configuration only)
- Plugin: N/A
- Risk: 5 (PASS)

### Runtime
- Bash 3.2.57

### Dependencies (key packages)
- None

## Context & Dependencies

### Related Issues/PRs
- Issue #37: plugin.jsonからversionフィールドを削除

## Test List

### TODO
(none)

### WIP
(none)

### DISCOVERED
(none)

### DONE
- [x] TC-01: 全plugin.jsonにversionフィールドが存在しないこと
- [x] TC-02: 全plugin.jsonが有効なJSONであること
- [x] TC-03: 既存の構造テストがPASSすること

## Implementation Notes

### Goal
plugin.json間のバージョン不整合を解消するため、全plugin.jsonからversionフィールドを削除する。

### Background
plugin.jsonのversionフィールドがtdd-core(4.0.0)と他プラグイン(2.0.0)で不整合。
Claude Code Pluginには依存解決の仕組みがなく、バージョン番号は実質的に意味がない。

### Design Approach
- 全10ファイルからversionフィールドを削除
- 既存テスト(test-plugins-structure.sh)はversionを検証していないため変更不要
- 新規テストでversionフィールドが存在しないことを検証

## Progress Log

### 2026-01-30 10:00 - INIT
- Cycle doc created
- Scope definition ready
- 10 plugin.json files identified

---

## Next Steps

1. [Done] INIT
2. [Done] PLAN
3. [Done] RED
4. [Done] GREEN
5. [Done] REFACTOR
6. [Done] REVIEW
7. [Done] COMMIT <- Current
3. [ ] RED
4. [ ] GREEN
5. [ ] REFACTOR
6. [ ] REVIEW
7. [ ] COMMIT
