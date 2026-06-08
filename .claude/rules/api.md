---
description: REST API, Server Actions, validation, auth, caching, and mobile-friendly responses
---

# API Rules

Apply when writing or reviewing API routes, Server Actions, controllers, or service integrations.

**Cross-check:** `.claude/rules/security.md` (auth, headers) and `.claude/rules/observability.md` (logging).

---

## Route Design

- **RESTful** resources: `GET /users`, `POST /users`, `PATCH /users/:id`, `DELETE /users/:id`
- **Noun paths**, not verbs (`/users` not `/getUsers`)
- Nest strong relationships: `/users/:id/posts`
- Version breaking changes: `/api/v2/...`
- **Server Actions** (Next.js): validate with Zod; return typed results, not thrown strings to the client

## Request Validation

- Validate **all** bodies, query params, and path params with Zod
- Return `400` with structured errors for validation failures
- Never trust client IDs for authorization — verify ownership server-side
- Reject unknown fields on write endpoints (`strict()` or `.strip()`)

## Response Format

```json
// Success
{ "data": { ... }, "meta": { "page": 1, "pageSize": 20, "total": 142 } }

// Error
{ "error": { "code": "VALIDATION_ERROR", "message": "...", "details": [...] } }
```

- Correct status codes: `200`, `201`, `204`, `400`, `401`, `403`, `404`, `409`, `422`, `429`, `500`
- **Never** return `200` with an error payload
- `204` only when the client needs no body (e.g. DELETE)

## Pagination & Lists

- Cursor-based pagination for large/mobile feeds; offset only for admin tables
- Default `pageSize` ≤ 20; cap at 100
- Always return `meta` with total or `hasMore` + `nextCursor`
- Select only fields needed for list views — full detail on `GET /:id`

## Authentication & Authorization

- Non-public routes validate session/JWT **before** business logic
- Auth in middleware or shared guard — not copy-pasted per handler
- Least privilege: expose only fields the caller may see
- `401` missing/invalid auth; `403` valid auth, insufficient permission

## Rate Limiting

| Endpoint type | Limit |
|---------------|-------|
| Auth (`/login`, `/register`, `/reset-password`) | 10 req/min per IP |
| Public read | 60 req/min per IP |
| Authenticated API | 100 req/min per user |

Return `429` with `Retry-After` header when exceeded.

## Caching (web & mobile)

- `GET` responses: `Cache-Control` appropriate to mutability
- Immutable assets: long `max-age` + fingerprinted URLs
- Private user data: `Cache-Control: private, no-store`
- ETag / `If-None-Match` for expensive read endpoints
- Support `Accept-Encoding: gzip, br` in production

## Mobile & Client Considerations

- Keep payloads lean — omit nulls and unused relations on list endpoints
- Stable `error.code` strings for client i18n and retry logic
- Idempotency-Key header on `POST` that creates resources (payments, orders)
- Timeouts: fail fast; return `504` gateway timeout, not hung connections

## Error Handling

- Wrap handlers in try/catch or centralized error middleware
- Log server-side with request ID and user context — **no stack traces to clients**
- Normalize errors through a single `handleApiError()` helper
- Distinguish operational errors (log + 500) from expected failures (4xx)

## Security Headers

Set on all responses (see `security.md` for full list):

- `X-Content-Type-Options: nosniff`
- `X-Frame-Options: DENY` (or CSP `frame-ancestors`)
- `Strict-Transport-Security` in production
- `Content-Security-Policy` configured per app

## Webhooks & Outbound Calls

- Verify webhook signatures before processing
- Process asynchronously when possible; return `200` quickly, retry with backoff on failure
- Allowlist outbound URLs — no user-controlled fetch targets (SSRF)
