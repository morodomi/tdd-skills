#!/bin/bash
# check-debug-statements.sh
# Stop hook: 変更ファイル内のdebug文を検出
#
# Usage:
#   check-debug-statements.sh [file ...]
#   引数なし: git diff で変更ファイルを自動取得

set -euo pipefail

# Debug statement patterns by language
PATTERNS='console\.log\|console\.debug\|debugger\|var_dump(\|dd(\|dump(\|print(\|breakpoint()\|pdb\.set_trace()'

FOUND=0

check_file() {
    local file="$1"
    if [ ! -f "$file" ]; then
        return
    fi
    MATCHES=$(grep -In "$PATTERNS" "$file" 2>/dev/null || true)
    if [ -n "$MATCHES" ]; then
        if [ "$FOUND" -eq 0 ]; then
            echo "Debug statements found:" >&2
        fi
        echo "  $file:" >&2
        echo "$MATCHES" | while read -r line; do
            echo "    $line" >&2
        done
        FOUND=1
    fi
}

# Get files to check
if [ $# -gt 0 ]; then
    for file in "$@"; do
        check_file "$file"
    done
else
    while IFS= read -r file; do
        [ -n "$file" ] && check_file "$file"
    done < <(git diff --cached --name-only 2>/dev/null)

    if [ "$FOUND" -eq 0 ]; then
        while IFS= read -r file; do
            [ -n "$file" ] && check_file "$file"
        done < <(git diff --name-only 2>/dev/null)
    fi
fi

if [ "$FOUND" -eq 1 ]; then
    echo "Remove debug statements before committing." >&2
    exit 1
fi

exit 0
