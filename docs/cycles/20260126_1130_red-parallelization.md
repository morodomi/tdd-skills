---
feature: tdd-red
cycle: red-parallelization
phase: DONE
created: 2026-01-26 11:30
updated: 2026-01-26 11:40
---

# RED Parallelization

## Scope Definition

### In Scope
- [ ] red-worker agent for parallel test creation
- [ ] tdd-red SKILL.md update to orchestrate parallel execution
- [ ] Reference documentation update

### Out of Scope
- Feedback loop (Reason: separate v4.0 feature, do later)
- PLAN phase changes (Reason: not needed for RED parallelization)

### Files to Change (target: 10 or less)
- plugins/tdd-core/agents/red-worker.md (new)
- plugins/tdd-core/skills/tdd-red/SKILL.md (edit)
- plugins/tdd-core/skills/tdd-red/reference.md (edit)

## Environment

### Scope
- Layer: Plugin (Markdown/Agent definition)
- Plugin: tdd-core
- Risk: 45 (WARN)

### Runtime
- Bash: 3.2.57

### Dependencies (key packages)
- Claude Code Plugin system
- Task tool with subagent_type

### Risk Interview (BLOCK only)
N/A (WARN level)

## Context & Dependencies

### Reference Documents
- docs/cycles/20260126_1003_green-parallelization.md - Same pattern to follow
- plugins/tdd-core/agents/green-worker.md - Reference implementation

### Dependent Features
- v3.3 GREEN parallelization: plugins/tdd-core/agents/green-worker.md

### Related Issues/PRs
- Issue #36: v4.0: RED並列化 + 統合最適化

## Test List

### TODO
(none)

### WIP
(none)

### DISCOVERED
(none)

### DONE
- [x] TC-01: red-worker.md exists in plugins/tdd-core/agents/
- [x] TC-02: red-worker.md has frontmatter (name, description)
- [x] TC-03: red-worker.md has Input section with test_cases, cycle_doc, test_files, language_plugin
- [x] TC-04: red-worker.md has Output section with JSON format (status, test_cases, files_created, red_state_verified)
- [x] TC-05: red-worker.md has Workflow section (4+ steps)
- [x] TC-06: red-worker.md has Principles section (Given/When/Then, RED state)
- [x] TC-07: red-worker.md has Verification Gate section (all tests must FAIL)
- [x] TC-08: tdd-red/SKILL.md has "並列実行" or "parallel" in description
- [x] TC-09: tdd-red/SKILL.md has Step for "ファイル依存関係分析" or grouping
- [x] TC-10: tdd-red/SKILL.md has Step for "red-worker並列起動"
- [x] TC-11: tdd-red/reference.md documents red-worker usage and shared fixtures handling

## Implementation Notes

### Goal
Parallelize test creation in RED phase using red-worker agent, following the same pattern as GREEN parallelization (v3.3).

### Background
v3.3でGREEN並列化を実装し、実装フェーズの効率化を達成。同様のパターンをREDフェーズにも適用することで、テスト作成の並列化を実現する。

REDはGREENほどトークン消費が大きくないが、Test Listが多い場合やテストファイルが複数に分かれる場合に効果を発揮する。

### Design Approach
**Pattern: Follow v3.3 green-worker**

1. **red-worker agent**: Test List項目を受け取り、テストコードを作成するワーカー
2. **tdd-red orchestration**: テストファイル別にworkerを割り当て、並列起動
3. **競合回避**: 同一テストファイルは同一workerに割り当て

**Parallel Strategy:**
```
Test List: TC-01, TC-02, TC-03, TC-04
  |
  v
Worker 1: TC-01, TC-02 → tests/AuthTest.php
Worker 2: TC-03, TC-04 → tests/UserTest.php
  |
  v
Merge & Verify all tests fail (RED state)
```

**Verification Gate (RED state):**
- 全テストが**失敗**すること（RED状態）
- テストが成功した場合 → 実装が既に存在するか、テストが無効
- red-workerのOutput: `red_state_verified: true` で確認

**Naming Convention:**
| Phase | Field | Reason |
|-------|-------|--------|
| RED | test_files | テストファイルを作成する |
| GREEN | target_files | 実装ファイルを編集する |

**Shared Fixtures Handling:**
- conftest.py（pytest）やTestCase基底クラスは並列化対象外
- 共有fixtureが必要な場合、事前に作成してからworker起動
- reference.mdに詳細を記載

## Progress Log

### 2026-01-26 11:40 - PLAN (plan-review fix)
- Added Verification Gate (RED state) to Design Approach
- Added Naming Convention (test_files vs target_files)
- Added Shared Fixtures Handling
- TC-04: added red_state_verified field
- TC-07: added Verification Gate test case
- TC-11: added shared fixtures handling test case

### 2026-01-26 11:35 - PLAN
- Design approach: Follow v3.3 green-worker pattern
- Test List: 10 test cases defined
- Files to change: 3 files confirmed

### 2026-01-26 11:30 - INIT
- Cycle doc created
- Scope: RED parallelization only (feedback loop deferred)
- Reference: v3.3 green-worker pattern

---

## Next Steps

1. [Done] INIT
2. [Done] PLAN
3. [Done] RED
4. [Done] GREEN
5. [Done] REFACTOR
6. [Done] REVIEW
7. [Done] COMMIT
