# Database Rules

Apply these rules whenever writing or reviewing database queries, migrations, or ORM code.

---

## ORM & Query Safety

- Use **Prisma** as the ORM — never write raw SQL unless using `prisma.$queryRaw` with tagged template literals
- Never concatenate user input into queries — always use parameterized queries or ORM methods
- Use `prisma.$queryRaw` with `Prisma.sql` tagged templates, never string interpolation
- Validate all inputs with Zod **before** passing to database layer

## Schema Design

- Every table must have a primary key (`id`) using `cuid()` or `uuid()`
- All tables should have `createdAt` and `updatedAt` timestamps
- Use `deletedAt` (soft delete) for user-facing records — never hard delete
- Foreign keys must have explicit `onDelete` behavior defined
- Index columns used in `WHERE` clauses and `JOIN` conditions

## Migrations

- Migrations are **append-only** — never edit a committed migration
- Run `pnpm prisma migrate dev` locally, `prisma migrate deploy` in CI/CD
- All schema changes require a migration file — never use `prisma db push` in production
- Test data-transforming migrations on a copy of production data before applying

## Transactions

- Wrap multi-step writes in a `prisma.$transaction()` to ensure atomicity
- Keep transactions short — don't do network calls inside a transaction block

## Performance

- Use `select` to fetch only the fields you need — never over-fetch with full model selects on lists
- Paginate all list queries — never return unbounded result sets
- Use `include` carefully — avoid N+1 queries by batching relations
- Add `@@index` in Prisma schema for any field filtered or sorted on frequently

## Secrets

- Database credentials must only live in environment variables
- Never log query parameters that contain PII or sensitive data
- Use connection pooling (e.g., PgBouncer / Prisma Accelerate) in production
