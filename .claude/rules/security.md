---
description: Application security — auth, input, secrets, headers, and OWASP-aligned coding standards
---

# Security Rules

Apply when writing or reviewing auth, API routes, Server Actions, data access, file uploads, or third-party integrations.

**Agent:** invoke `security-auditor` for PR review of sensitive changes.

---

## Authentication & Sessions

- Hash passwords with **argon2** or **bcrypt** (cost ≥ 12)
- Session cookies: `HttpOnly`, `Secure`, `SameSite=Lax` (or `Strict` for high-security)
- Rotate session ID on login; invalidate all sessions on password change
- JWT: verify `alg` allowlist; short expiry; refresh token rotation; never store JWT in `localStorage` for sensitive apps
- MFA for admin and high-privilege accounts

## Authorization

- Check permissions on **every** request — not just UI hiding
- Resource-level checks: user can only access their own `userId` / `orgId` records
- Deny by default; explicit allow lists for roles and scopes
- `401` unauthenticated; `403` authenticated but forbidden — never leak existence via different messages

## Input & Output

- Validate and sanitize all input with Zod at the boundary
- Encode output for context (HTML, URL, JS) — use framework defaults; sanitize if using `dangerouslySetInnerHTML`
- Reject oversized payloads; set body size limits on upload routes
- Validate file type by magic bytes, not extension; scan uploads if user-generated
- No `eval()`, `Function()`, or dynamic `require()` with user input

## Secrets & Configuration

- Secrets only in env vars or secret manager — never in source or git
- `.env*` gitignored; `.env.example` documents keys without values
- Rotate keys on compromise; separate keys per environment
- Disable debug endpoints and verbose errors in production

## Transport & Headers

| Header | Value |
|--------|-------|
| `Strict-Transport-Security` | `max-age=63072000; includeSubDomains` (prod) |
| `X-Content-Type-Options` | `nosniff` |
| `X-Frame-Options` | `DENY` or CSP `frame-ancestors 'none'` |
| `Referrer-Policy` | `strict-origin-when-cross-origin` |
| `Permissions-Policy` | Restrict camera, mic, geolocation as needed |
| `Content-Security-Policy` | Restrict `script-src`, `connect-src` per app |

## CORS

- Explicit origin allowlist — never `Access-Control-Allow-Origin: *` with credentials
- Preflight handled correctly; minimal allowed methods and headers

## Common Vulnerabilities

| Risk | Mitigation |
|------|------------|
| SQL/NoSQL injection | Parameterized queries; Zod before DB |
| XSS | Escape output; CSP; avoid inline scripts |
| CSRF | SameSite cookies + CSRF token on state-changing forms |
| SSRF | Allowlist outbound URLs; block internal IP ranges |
| Open redirect | Validate redirect URLs against same-origin or allowlist |
| IDOR | Server-side ownership check on every resource access |
| Mass assignment | Zod `.pick()` / explicit field lists on writes |

## Dependencies

- Run `pnpm audit` in CI; patch critical CVEs before release
- Pin major versions; review new dependencies for maintenance and license
- No typosquat package names — verify package identity before install

## Incident Response

- Log security events (failed auth, permission denied, rate limit hit) — see `observability.md`
- Have a documented path to revoke sessions and rotate secrets
- Never log passwords, tokens, full credit card numbers, or session cookies
