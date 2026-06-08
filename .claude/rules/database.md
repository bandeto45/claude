---
description: Prisma schema, migrations, transactions, performance, and data safety
---

# Database Rules

Apply when writing or reviewing database queries, migrations, or ORM code.

**Cross-check:** `.claude/rules/security.md` (PII, access) and `.claude/rules/observability.md` (slow-query logging).

---

## ORM & Query Safety

- **Prisma** as ORM — raw SQL only via `prisma.$queryRaw` with `Prisma.sql` tagged templates
- Never concatenate user input into queries
- Validate inputs with Zod **before** the database layer
- Set query timeouts in production; log queries exceeding threshold (without PII in logs)

## Schema Design

- Primary key on every table: `id` with `cuid()` or `uuid()`
- `createdAt` and `updatedAt` on all tables
- `deletedAt` for user-facing records — prefer soft delete over hard delete
- Foreign keys with explicit `onDelete` (`Restrict`, `Cascade`, or `SetNull` — document choice)
- Index columns used in `WHERE`, `ORDER BY`, and `JOIN`
- Store enums as Prisma enums or constrained strings — not free-text status fields

## Audit & Sensitive Data

- Append-only `audit_log` (or event table) for security-relevant changes: who, what, when
- Encrypt highly sensitive columns at application layer if required (tokens, PII beyond profile)
- Never store plaintext passwords — bcrypt/argon2 only
- Separate tables for credentials vs profile data when feasible

## Migrations

- **Append-only** — never edit a committed migration
- Local: `pnpm prisma migrate dev`; CI/CD: `prisma migrate deploy`
- Every schema change gets a migration — no `db push` in production
- Test data-transforming migrations on a production copy first
- Name migrations descriptively: `add_user_soft_delete`, not `migration2`

## Transactions

- Multi-step writes in `prisma.$transaction()` for atomicity
- Keep transactions **short** — no HTTP calls, file I/O, or email inside a transaction
- Use `isolationLevel` only when race conditions are proven — default is usually enough
- Serializable isolation for financial balance updates if contention exists

## Performance

- `select` only needed fields on lists — avoid full model fetches
- Paginate all list queries — no unbounded `findMany`
- Avoid N+1: batch with `include` thoughtfully or use `dataloader` patterns
- `@@index` on filtered/sorted columns; composite indexes for common multi-column filters
- Connection pooling in production (PgBouncer, Prisma Accelerate, or provider pooler)

## Read Patterns

- Read replicas for heavy reporting queries when available — never write to replica
- Cache hot reads at app layer (Redis) with explicit TTL and invalidation on write
- Denormalize only when measured — prefer views or materialized views for analytics

## Secrets & Environment

- Credentials only in environment variables — rotate on leak
- Never log query parameters containing PII, tokens, or passwords
- Use least-privilege DB roles: app user without `DROP` / `SUPERUSER`
- Separate dev/staging/prod databases — no production data in local `.env`

## Backup & Recovery

- Automated daily backups with tested restore procedure
- Point-in-time recovery enabled on managed Postgres when available
- Document RPO/RTO expectations in runbooks
