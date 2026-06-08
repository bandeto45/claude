---
name: lint
description: Runs typecheck and lint, then fixes safe auto-fixable issues.
---

# /lint

Run static analysis and apply auto-fixes where appropriate.

## Usage

```
/lint
/lint src/components/Button.tsx
```

## Steps

1. If no `package.json`, skip with adoption instructions
2. Run `pnpm typecheck` when the script exists
3. Run `pnpm lint` (full project) or `pnpm exec eslint --fix <path>` for a single file
4. Report remaining errors that need manual fixes
5. Do not add `eslint-disable` without a justification comment (see `CLAUDE.md`)
