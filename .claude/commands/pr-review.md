---
name: pr-review
description: Performs a comprehensive pull request review covering correctness, security, tests, and conventions.
---

# /pr-review

Conduct a full code review of the current branch diff or a specified PR.

## Usage

```
/pr-review
/pr-review #456
/pr-review --focus security
/pr-review --focus performance
```

## Review Dimensions

### 1. Correctness
- Does the implementation match the requirements?
- Are edge cases handled?
- Is error handling complete?

### 2. Security
- Consult `security-auditor` agent for any auth, input, or data handling changes
- Check for secrets, unsafe patterns, or injection vectors

### 3. Tests
- Are new code paths covered by tests?
- Do existing tests still pass?
- Is there a regression test for any bug fix?

### 4. Conventions
- Does the code follow `.claude/rules/` for the relevant domain?
- Are naming conventions consistent with the codebase?
- Is the PR scoped appropriately (not too large)?

### 5. Documentation
- Are public APIs documented?
- Is the PR description clear enough to understand the change?

## Output Format

A structured review using the `code-reviewer` agent format:
- **Blocking issues** — must be resolved before merge
- **Suggestions** — optional improvements
- **Approved** — confirms what looks good
