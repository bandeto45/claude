---
name: fix-issue
description: Analyzes a GitHub issue or bug report and produces a targeted fix with tests.
---

# /fix-issue

Given a bug report or issue number, diagnose the root cause and implement a fix.

## Usage

```
/fix-issue #123
/fix-issue "users cannot log in after password reset"
```

## Steps Claude Will Follow

1. **Understand the issue** — read the description, reproduction steps, and any linked code
2. **Locate the source** — find the relevant file(s) and function(s)
3. **Diagnose** — identify the root cause (consult `debugger` agent if needed)
4. **Implement the fix** — make the smallest change that resolves the issue
5. **Write a regression test** — add a test that would have caught this bug
6. **Summarize** — provide a short explanation of what was wrong and what was changed

## Output

- Modified file(s) with the fix applied
- A new or updated test case
- A one-paragraph summary suitable for a commit message or PR description
