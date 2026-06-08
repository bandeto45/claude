---
name: test
description: Runs the test suite with the right scope and interprets failures.
---

# /test

Run tests and summarize results. Fix failures when asked.

## Usage

```
/test
/test unit
/test e2e
/test path/to/file.test.ts
```

## Steps

1. If no `package.json`, explain that this template must be adopted into an app first
2. Run `pnpm test --run` for unit/integration (or `pnpm test` if `--run` unsupported)
3. For E2E: `pnpm test:e2e` or `pnpm exec playwright test` if defined in `package.json`
4. On failure: show failing test name, assertion, and likely file; offer to fix using `debugger` + `test-writer` agents
5. Follow conventions in `.claude/rules/testing.md`
