# API Rules

Apply these rules whenever writing or reviewing API routes, controllers, or service integrations.

---

## Route Design

- Follow **RESTful conventions**: `GET /users`, `POST /users`, `PATCH /users/:id`, `DELETE /users/:id`
- Use **noun-based** resource paths, not verb-based (`/users` not `/getUsers`)
- Nest resources when the relationship is strong: `/users/:id/posts`
- Version the API if breaking changes are needed: `/api/v2/...`

## Request Validation

- Validate **all** incoming request bodies, query params, and path params with Zod
- Return `400 Bad Request` with structured error details for validation failures
- Never trust client-supplied IDs for authorization — always verify ownership server-side

## Response Format

All responses must follow this envelope:

```json
// Success
{ "data": { ... } }

// Error
{ "error": { "code": "VALIDATION_ERROR", "message": "...", "details": [...] } }
```

- Use correct HTTP status codes: `200`, `201`, `204`, `400`, `401`, `403`, `404`, `409`, `422`, `500`
- Never return a `200` with an error payload

## Authentication & Authorization

- All non-public routes must validate the session/JWT before processing
- Use middleware for auth — never inline auth checks in route handlers
- Apply **principle of least privilege** — only expose what the caller needs
- Return `401 Unauthorized` for missing auth, `403 Forbidden` for insufficient permissions

## Rate Limiting

- Apply rate limiting to all public-facing and auth endpoints
- Auth endpoints (`/login`, `/register`, `/reset-password`): max 10 req/min per IP
- General API: max 100 req/min per authenticated user

## Error Handling

- All route handlers must be wrapped in try/catch or use an error boundary middleware
- Log errors server-side with context (user ID, route, timestamp) — never expose stack traces to clients
- Use a centralized error handler to normalize responses

## Security Headers

Ensure the following headers are set on all responses:
- `X-Content-Type-Options: nosniff`
- `X-Frame-Options: DENY`
- `Strict-Transport-Security: max-age=63072000`
- `Content-Security-Policy` (configured per-app)
