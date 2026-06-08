---
description: Vitest, RTL, Playwright, and coverage conventions for tests
---

# Testing Rules

Apply when writing or reviewing tests, test utilities, or CI test configuration.

---

## Tooling

- **Unit / integration:** Vitest (preferred) or Jest
- **Components:** React Testing Library — query by role/label, not implementation
- **E2E:** Playwright for critical user flows (include mobile viewport projects)
- **HTTP mocking:** MSW for API boundaries in tests
- **Responsive:** test key layouts at 375px and 1280px in component or E2E suites

## Structure

- Co-locate unit tests: `Component.test.tsx` next to `Component.tsx`, or use `__tests__/` for grouped suites
- E2E tests live in `e2e/` at repo root
- Follow AAA (Arrange, Act, Assert); one primary behavior per `it` block
- Name tests: `should [expected] when [condition]`

## Coverage Expectations

- Every bug fix includes a regression test
- New public functions and API routes require happy-path + one edge/error case
- Do not test third-party internals or trivial pass-through code
- Prefer testing through public APIs, not private implementation details

## Determinism

- No time-dependent assertions without mocking timers
- Mock `Date`, `Math.random`, and network I/O at boundaries
- Reset mocks between tests; avoid shared mutable state across files

## CI

- Fast suite runs on every commit (`pnpm test --run`)
- E2E runs in CI on `main` and release branches, not on every pre-commit (too slow)
- Fail the build on skipped tests unless explicitly marked with documented reason

## Assertions

- Prefer `toEqual` / `toMatchObject` over snapshot tests except for stable markup
- Async: always `await` expectations; use `waitFor` for UI updates
- Avoid testing CSS class strings — assert roles, text, and ARIA instead
