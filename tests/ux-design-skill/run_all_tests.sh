#!/usr/bin/env bash
################################################################################
# UX Design Skill - Run All Tests
################################################################################

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=========================================="
echo "Running All UX Design Skill Tests"
echo "=========================================="
echo ""

# テスト1: SKILL.md構造検証
echo "--- Test Suite 1: SKILL.md Structure ---"
bash "$SCRIPT_DIR/test_skill_structure.sh" || true
echo ""

# テスト2: テンプレート配置検証
echo "--- Test Suite 2: Template Placement ---"
bash "$SCRIPT_DIR/test_template_placement.sh" || true
echo ""

echo "=========================================="
echo "All Test Suites Completed"
echo "=========================================="
