#!/usr/bin/env bash
# .claude/hooks/pre-commit.sh
# Runs before every commit when wired via git hooks or Claude PreToolUse.
# Skips checks in config-only repos (no package.json).

set -euo pipefail

echo "🔍 Running pre-commit checks..."

if [[ ! -f package.json ]]; then
  echo "  → No package.json — skipping (config template repo)."
  exit 0
fi

if ! command -v pnpm >/dev/null 2>&1; then
  echo "❌ pnpm is required but not installed."
  exit 1
fi

run_script() {
  local script="$1"
  if node -e "const p=require('./package.json'); process.exit(p.scripts?.['$script']?0:1)" 2>/dev/null; then
    pnpm "$script"
  else
    echo "  → Skipping '$script' (not defined in package.json)"
  fi
}

echo "  → TypeScript..."
run_script typecheck

echo "  → Linting..."
run_script lint

echo "  → Tests..."
if node -e "const p=require('./package.json'); process.exit(p.scripts?.test?0:1)" 2>/dev/null; then
  pnpm test --run 2>/dev/null || pnpm test
else
  echo "  → Skipping 'test' (not defined in package.json)"
fi

if [[ -d src ]]; then
  echo "  → Scanning for secrets..."
  if grep -rE "(api[_-]?key|secret|password|token)\s*[:=]\s*['\"][^'\"]{8,}" \
    --include="*.ts" --include="*.tsx" --include="*.js" src/ 2>/dev/null; then
    echo "❌ Possible hardcoded secret detected. Aborting commit."
    exit 1
  fi

  if grep -rn "console\.log" --include="*.ts" --include="*.tsx" src/ 2>/dev/null \
    | grep -v "__tests__" | grep -vE '\.(test|spec)\.'; then
    echo "⚠️  console.log found in source files (warning only)."
  fi
fi

echo "✅ Pre-commit checks passed."
