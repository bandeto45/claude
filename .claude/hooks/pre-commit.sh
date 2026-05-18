#!/usr/bin/env bash
# .claude/hooks/pre-commit.sh
# Runs before every commit. Claude MUST ensure these checks pass.
# Hook type: PreToolUse (Bash)

set -euo pipefail

echo "🔍 Running pre-commit checks..."

# 1. TypeScript type check
echo "  → TypeScript..."
pnpm typecheck

# 2. ESLint
echo "  → Linting..."
pnpm lint

# 3. Unit tests (fast only — skip e2e)
echo "  → Tests..."
pnpm test --run

# 4. Check for secrets / sensitive patterns
echo "  → Scanning for secrets..."
if grep -rE "(api_key|secret|password|token)\s*=\s*['\"][^'\"]{8,}" --include="*.ts" --include="*.tsx" --include="*.js" src/ 2>/dev/null; then
  echo "❌ Possible hardcoded secret detected. Aborting commit."
  exit 1
fi

# 5. Ensure no console.log left in production code
if grep -rn "console\.log" --include="*.ts" --include="*.tsx" src/ 2>/dev/null | grep -v "__tests__" | grep -v ".test." | grep -v ".spec."; then
  echo "⚠️  console.log found in source files. Consider removing before committing."
  # Warning only — does not block commit
fi

echo "✅ Pre-commit checks passed."
