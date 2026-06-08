---
description: Structured logging, monitoring, tracing, and alerting for production operations
---

# Observability Rules

Apply when writing or reviewing logging, error tracking, metrics, health checks, or background jobs.

---

## Logging Principles

1. **Structured JSON** in production — not unstructured `console.log` strings
2. **Correlation ID** on every request (`x-request-id`); propagate to downstream calls
3. **Log levels:** `debug` (dev only), `info` (business events), `warn` (recoverable), `error` (action needed), `fatal` (process exit)
4. **Never log secrets** — passwords, tokens, API keys, full card numbers, session cookies

## What to Log

| Event | Level | Fields |
|-------|-------|--------|
| Request start/end | `info` | `requestId`, `method`, `path`, `status`, `durationMs`, `userId` (if auth) |
| Validation failure | `info` | `requestId`, `code`, field errors (no PII values) |
| Auth failure | `warn` | `requestId`, `ip`, `reason` — not password or token |
| Permission denied | `warn` | `requestId`, `userId`, `resource`, `action` |
| Unhandled exception | `error` | `requestId`, `error.name`, `error.message`, stack (server only) |
| Slow query | `warn` | `durationMs`, query name — not bind parameters with PII |
| External API failure | `error` | `service`, `status`, `durationMs`, `requestId` |

## What NOT to Log

- Passwords, refresh tokens, API secrets, `Authorization` headers
- Full request/response bodies containing PII unless redacted
- Health-check spam at `info` on every kube probe (use `debug` or sample)

## Error Tracking

- Integrate Sentry (or equivalent) for unhandled exceptions in API and client
- Tag errors with `environment`, `release`, `userId` (hashed if required), `requestId`
- Group by fingerprint; don't alert on known transient network blips without threshold
- Client: capture boundary errors; scrub PII before send

## Metrics

Expose or emit metrics for:

- Request rate, latency p50/p95/p99, error rate by route
- Database connection pool usage and slow query count
- Queue depth and job failure rate for background workers
- Cache hit ratio for hot paths

Use consistent naming: `http_requests_total`, `http_request_duration_seconds`.

## Health Checks

- `GET /health` — liveness (process up)
- `GET /ready` — readiness (DB connected, critical deps reachable)
- Return `503` when not ready; `200` with minimal JSON body
- Do not expose internal topology or versions in public health responses

## Tracing

- OpenTelemetry (or provider equivalent) for distributed traces across API → DB → external APIs
- Span per outbound HTTP call and DB query in hot paths
- Attach `requestId` as trace attribute

## Alerting

- Alert on **symptoms** (error rate spike, p95 latency, failed payments) not every log line
- Page on: sustained 5xx, auth system down, DB unreachable, disk full
- Ticket on: elevated 4xx, slow queries, dependency degradation
- Every alert links to a runbook with first steps

## Background Jobs

- Log job start, completion, failure with `jobId`, `attempt`, `durationMs`
- Dead-letter queue after max retries; alert on DLQ growth
- Idempotent job handlers — safe to retry

## Local Development

- Pretty-printed logs acceptable locally
- `debug` level enabled in dev; `info` minimum in staging/prod
- Never ship debug logging of full payloads to production log drains
