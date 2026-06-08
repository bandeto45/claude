# CLAUDE.md — Project Brain

Primary instruction set for AI assistants in this repository. Defines behavior, stack assumptions, and how to use the `.claude/` configuration system.

---

## Project Overview

This repository is a **reusable AI assistant configuration template** for TypeScript full-stack apps (Next.js App Router, Prisma, pnpm). It ships no application source code — only `CLAUDE.md` and `.claude/` (agents, rules, commands, hooks, skills).

**Goals**

- Give Claude/Cursor consistent, project-wide standards before any app code exists
- Provide specialized agents and slash commands for common workflows
- Enforce quality gates via hooks when adopted into a real codebase

**Adopting into an app**

1. Copy `CLAUDE.md` and `.claude/` into your application repo root
2. Customize the [Architecture](#architecture) and [Key Conventions](#key-conventions) sections for your stack
3. Add `package.json` scripts expected by hooks: `typecheck`, `lint`, `test`, and tooling (`prettier`, `eslint`)
4. Wire git hooks (e.g. Husky) to `.claude/hooks/pre-commit.sh`, or rely on your editor’s Claude hook integration via `.claude/settings.json`
5. Copy `.env.example` to `.env.local` and fill in values

---

## Architecture

Default stack this template targets (edit when adopting):

| Layer | Stack |
|-------|--------|
| **Frontend** | React 19 + TypeScript + Tailwind CSS (Next.js App Router) |
| **Backend** | Next.js Route Handlers / Server Actions |
| **Database** | PostgreSQL via Prisma |
| **Auth** | NextAuth.js or Clerk |
| **Infra** | Vercel (app) + managed Postgres (e.g. Neon, Supabase) |

Expected directory layout in a consuming app:

```
src/
  app/              # Routes and API (App Router)
  components/       # Shared UI
  features/         # Feature-scoped modules
  hooks/            # React hooks
  lib/              # Utilities, db client, constants
prisma/             # Schema and migrations
```

---

## Key Conventions

- Shared UI lives in `src/components/`; feature code in `src/features/`
- API routes live in `src/app/api/`
- Environment variables are documented in `.env.example` — never commit `.env*`
- Use **pnpm** as the package manager
- Prefer **named exports** over default exports
- Validate inputs with **Zod**; derive types via `z.infer<typeof Schema>`

---

## `.claude/` System Map

| Path | Purpose |
|------|---------|
| `.claude/settings.json` | Enables agents, commands, hooks, rules, skills; glob → rule mapping |
| `.claude/agents/` | Specialized personas (review, debug, test, refactor, docs, security) |
| `.claude/commands/` | Slash-command playbooks (`/pr-review`, `/fix-issue`, `/deploy`, …) |
| `.claude/rules/` | Domain rules auto-applied by file glob (see `settings.json`) |
| `.claude/hooks/` | `pre-commit.sh` (quality gate), `lint-on-save.sh` (format/lint on write) |
| `.claude/skills/` | Situational expertise (e.g. `frontend-design`) |

Configuration is read from `.claude/settings.json`. Rules apply automatically when editing paths listed under `rules.autoApply`.

---

## Agent Team

Specialized agents in `.claude/agents/`:

| Agent | Role |
|-------|------|
| `code-reviewer` | Reviews diffs; enforces conventions and flags blocking issues |
| `debugger` | Reproduces, isolates, and fixes bugs with minimal changes |
| `test-writer` | Adds unit, integration, and E2E tests (Vitest, RTL, Playwright) |
| `refactorer` | Improves structure without behavior changes |
| `doc-writer` | README, API docs, JSDoc, changelogs |
| `security-auditor` | OWASP-oriented review for auth, input, and data paths |

Invoke by name or via commands (e.g. `/pr-review` delegates to `code-reviewer` and `security-auditor`).

---

## Skills

| Skill | When to use |
|-------|-------------|
| `frontend-design` | Luxury UX-first UI, web/mobile layout, responsive/dark mode |

Skills live in `.claude/skills/<name>/SKILL.md`. Prefer existing UI patterns from `frontend.md` before inventing new ones.

---

## Domain Rules

| Rule file | Scope |
|-----------|--------|
| `frontend.md` | React, responsive web/mobile UX, luxury UI, a11y |
| `api.md` | REST, Server Actions, validation, caching, responses |
| `database.md` | Prisma schema, migrations, queries, audit |
| `security.md` | Auth, input, secrets, headers, OWASP-aligned coding |
| `observability.md` | Structured logging, metrics, tracing, alerting |
| `testing.md` | Test structure, coverage expectations, tooling |

---

## Workflow

1. New features include tests (see `testing.md` and `test-writer` agent)
2. Before commit: `pnpm typecheck && pnpm lint && pnpm test` (also run by `pre-commit` hook when wired)
3. Follow `.claude/rules/` for the files you touch
4. Use `.claude/commands/` for repeatable tasks (`/pr-review`, `/fix-issue`, `/deploy`, `/test`, `/lint`)
5. Hooks in `.claude/hooks/` run when enabled in `settings.json` and git/editor integration is configured

---

## Do Not

- Commit secrets, API keys, or filled `.env` files
- Skip TypeScript annotations on public APIs
- Bypass lint with `eslint-disable` without a short justification comment
- Use `any` without documented reason — prefer `unknown` and narrowing
- Edit committed Prisma migrations (append new migrations instead)
- Return HTTP `200` with an error payload
