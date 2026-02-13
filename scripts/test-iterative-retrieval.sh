#!/bin/bash
# test-iterative-retrieval.sh - Iterative Retrieval 構造検証テスト
set -euo pipefail

PASS=0
FAIL=0
RED_WORKER="plugins/tdd-core/agents/red-worker.md"
GREEN_WORKER="plugins/tdd-core/agents/green-worker.md"

assert_contains() {
  local file="$1" pattern="$2" label="$3"
  if grep -q "$pattern" "$file" 2>/dev/null; then
    echo "PASS: $label"
    PASS=$((PASS + 1))
  else
    echo "FAIL: $label"
    FAIL=$((FAIL + 1))
  fi
}

# TC-01: red-worker.md に "Context Retrieval Protocol" セクションが存在する
assert_contains "$RED_WORKER" "## Context Retrieval Protocol" \
  "TC-01: red-worker.md has Context Retrieval Protocol section"

# TC-02: green-worker.md に "Context Retrieval Protocol" セクションが存在する
assert_contains "$GREEN_WORKER" "## Context Retrieval Protocol" \
  "TC-02: green-worker.md has Context Retrieval Protocol section"

# TC-03: red-worker.md のプロトコルにリファイン回数上限（3）が記載されている
assert_contains "$RED_WORKER" "最大3" \
  "TC-03: red-worker.md mentions refine limit (最大3)"

# TC-04: green-worker.md のプロトコルにリファイン回数上限（3）が記載されている
assert_contains "$GREEN_WORKER" "最大3" \
  "TC-04: green-worker.md mentions refine limit (最大3)"

# TC-05: red-worker.md のプロトコルに十分性評価基準（チェックリスト）が含まれている
assert_contains "$RED_WORKER" "\- \[" \
  "TC-05: red-worker.md has sufficiency checklist"

# TC-06: green-worker.md のプロトコルに十分性評価基準（チェックリスト）が含まれている
assert_contains "$GREEN_WORKER" "\- \[" \
  "TC-06: green-worker.md has sufficiency checklist"

# TC-07: red-worker.md の既存セクション（Workflow, Principles, Input, Output）が維持されている
tc07_pass=true
for section in "## Input" "## Output" "## Workflow" "## Principles"; do
  if ! grep -q "$section" "$RED_WORKER" 2>/dev/null; then
    tc07_pass=false
    break
  fi
done
if [ "$tc07_pass" = true ]; then
  echo "PASS: TC-07: red-worker.md preserves existing sections (Input, Output, Workflow, Principles)"
  PASS=$((PASS + 1))
else
  echo "FAIL: TC-07: red-worker.md preserves existing sections (Input, Output, Workflow, Principles)"
  FAIL=$((FAIL + 1))
fi

# TC-08: green-worker.md の既存セクション（Workflow, Principles, Input, Output）が維持されている
tc08_pass=true
for section in "## Input" "## Output" "## Workflow" "## Principles"; do
  if ! grep -q "$section" "$GREEN_WORKER" 2>/dev/null; then
    tc08_pass=false
    break
  fi
done
if [ "$tc08_pass" = true ]; then
  echo "PASS: TC-08: green-worker.md preserves existing sections (Input, Output, Workflow, Principles)"
  PASS=$((PASS + 1))
else
  echo "FAIL: TC-08: green-worker.md preserves existing sections (Input, Output, Workflow, Principles)"
  FAIL=$((FAIL + 1))
fi

echo ""
echo "Results: $PASS PASS, $FAIL FAIL (Total: $((PASS + FAIL)))"
[ "$FAIL" -eq 0 ] && exit 0 || exit 1
