#!/bin/bash
# save-tdd-state.sh - PreCompact hook for TDD state notification
# Usage: save-tdd-state.sh [project-dir]
# Outputs TDD state (Cycle doc path + phase) to stderr for user notification.

PROJECT_DIR="${1:-.}"
CYCLES_DIR="$PROJECT_DIR/docs/cycles"

if [ ! -d "$CYCLES_DIR" ]; then
    echo "Warning: No Cycle docs found ($CYCLES_DIR not found)" >&2
    exit 0
fi

LATEST_CYCLE=$(ls -t "$CYCLES_DIR"/*.md 2>/dev/null | head -1)

if [ -z "$LATEST_CYCLE" ]; then
    echo "Warning: No Cycle docs found in $CYCLES_DIR" >&2
    exit 0
fi

PHASE=$(grep -m1 '^phase:' "$LATEST_CYCLE" 2>/dev/null | sed 's/^phase:[[:space:]]*//')

if [ -z "$PHASE" ]; then
    PHASE="unknown"
fi

CYCLE_NAME=$(basename "$LATEST_CYCLE")
echo "TDD State: $CYCLE_NAME (Phase: $PHASE)" >&2
exit 0
