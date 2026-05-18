#!/usr/bin/env bash
# .claude/hooks/lint-on-save.sh
# Runs linting and formatting whenever Claude writes a source file.
# Hook type: PostToolUse (Write/Edit file)

set -euo pipefail

FILE="${1:-}"

if [[ -z "$FILE" ]]; then
  echo "Usage: lint-on-save.sh <filepath>"
  exit 1
fi

EXT="${FILE##*.}"

# Only process known source file types
case "$EXT" in
  ts|tsx|js|jsx|mjs|cjs)
    echo "  → Formatting $FILE with Prettier..."
    pnpm prettier --write "$FILE"

    echo "  → Linting $FILE with ESLint..."
    pnpm eslint --fix "$FILE"
    ;;
  css|scss)
    echo "  → Formatting $FILE with Prettier..."
    pnpm prettier --write "$FILE"
    ;;
  json)
    echo "  → Formatting $FILE with Prettier..."
    pnpm prettier --write "$FILE"
    ;;
  md|mdx)
    echo "  → Formatting $FILE with Prettier..."
    pnpm prettier --write "$FILE"
    ;;
  *)
    echo "  → Skipping lint for $FILE (unsupported extension: .$EXT)"
    ;;
esac

echo "✅ lint-on-save complete for $FILE"
