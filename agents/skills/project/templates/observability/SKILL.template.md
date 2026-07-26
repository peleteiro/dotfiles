---
name: observability
description: Observability first — structured logging (zero console.log), tracing on I/O, metrics, error capture, no sensitive data in logs. Use when instrumenting code or investigating production.
allowed-tools: Read, Grep
---

# Observability

Global skill — if the repo has its own `observability`/`logs` skill, it wins.

## Structured logging (always)

```typescript
logger.info({userId: '123'}, 'operation started')
logger.error({err, module: 'web', route: '/api/*'}, 'failed to query dependency')

// ❌ NEVER console.log (oxlint no-console: error already blocks it)
```

- Stable event + searchable fields; do **not** concatenate context into the message.
- Preserve correlation IDs: `requestId`, `jobId`, `tenantId`, module,
  status, duration.
- Caught errors are `unknown` — extract only safe fields.
- **Never log**: Authorization, cookies, tokens, secrets, full
  payloads, unsanitized URL/query, clinical/personal data in the clear.
- Runtime exception: edge Workers (Cloudflare) emit structured JSON via
  `console.error` because the runtime collects the stream natively — it's still
  structured logging, not loose text.

## Tracing

Instrument **I/O operations** (DB, APIs, queues) with the project's layer:

```typescript
return traced('repo.find_cliente_by_email', async span => {
  span.setAttribute('email', email)
  // logic...
}, {attributes: {email}})
```

The `traced()`/span comes **before** the logic, it is not an afterthought — all
new I/O code is born instrumented.

## Metrics

```typescript
const counter = getCounter('requests.total', 'Total requests')
counter.increment({method: 'POST'})

const histogram = getHistogram('operation.duration_ms', 'Duration')
histogram.record(Date.now() - start, {status: 'success'})
```

In jobs, return counts in the task output (`{sent: 3}`) — it becomes a metric
for free on the dashboard.

## Error capture

```typescript
try {
  await riskyOp()
} catch (error) {
  captureError(error, {context: 'operation.name'})
  // ...Result or rethrow per the `error` skill
}
```

## Provider-agnostic layer

Encapsulate tracing/metrics/capture in your own layer
(`@project/observability` or `@/services/observability`) — swapping
Sentry/OpenTelemetry/mock must not touch business code.

## Production investigation

- Start with **read-only** queries; pin the window in UTC, environment, and build
  (`X-Build-Id`).
- Separate what the client saw from stale cache (`CF-Cache-Status`, `Age`)
  before blaming the origin.
- Correlate boundaries in order (edge → LB → app) comparing the status of
  each layer; one source does not replace the other.
- Do not change retention, IAM, alarms, or scaling during diagnosis without
  authorization.

## Checklist

- [ ] `traced()` on new I/O operations
- [ ] Structured logger with correlation IDs (never console)
- [ ] `captureError()` in catches
- [ ] No sensitive data in logs
