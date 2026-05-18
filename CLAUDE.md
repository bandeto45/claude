# CLAUDE.md — Project Brain

This file is the primary instruction set for Claude in this project. It defines how Claude should behave, what it knows about this codebase, and how to coordinate with the rest of the `.claude/` system.

---

## Project Overview

> Describe your project here. What does it do? What stack does it use? What are the key goals?

---

## Architecture

- **Frontend:** (e.g., React + TypeScript + Tailwind)
- **Backend:** (e.g., Node.js + Express)
- **Database:** (e.g., PostgreSQL via Prisma)
- **Auth:** (e.g., NextAuth / Clerk)
- **Infra:** (e.g., Vercel + Railway)

---

## Key Conventions

- All components live in `src/components/`
- All API routes live in `src/app/api/`
- Environment variables are defined in `.env.example`
- Use `pnpm` as the package manager
- Prefer named exports over default exports
- Use `zod` for all input validation

---

## Agent Team

This project uses a team of specialized AI agents defined in `.claude/agents/`:

| Agent | Role |
|---|---|
| `code-reviewer` | Reviews PRs and flags issues |
| `debugger` | Diagnoses and fixes bugs |
| `test-writer` | Writes and improves test coverage |
| `refactorer` | Improves code quality and structure |
| `doc-writer` | Writes and updates documentation |
| `security-auditor` | Identifies security vulnerabilities |

---

## Workflow

1. All new features must have corresponding tests
2. Run `pnpm lint && pnpm test` before committing
3. Follow the rules in `.claude/rules/` for domain-specific guidance
4. Use `.claude/commands/` slash commands for common tasks
5. Hooks in `.claude/hooks/` are enforced automatically

---

## Do Not

- Do not commit secrets or API keys
- Do not skip type annotations
- Do not bypass linting with `// eslint-disable` without a comment explaining why
- Do not use `any` in TypeScript without justification
