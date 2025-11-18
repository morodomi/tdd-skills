#!/usr/bin/env bash

################################################################################
# Test Agent Command - Test Runner
################################################################################

# プロジェクトルートを取得
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

echo "=========================================="
echo "Running All Test Agent Command Tests"
echo "=========================================="
echo ""

# Test Suite 1: Command Structure
echo "--- Test Suite 1: Command Structure ---"
bash "$PROJECT_ROOT/tests/test-agent-command/test_command_structure.sh" || true
echo ""

# Test Suite 2: Execution Flow
echo "--- Test Suite 2: Execution Flow ---"
bash "$PROJECT_ROOT/tests/test-agent-command/test_execution_flow.sh" || true
echo ""

echo "=========================================="
echo "All Test Suites Completed"
echo "=========================================="
