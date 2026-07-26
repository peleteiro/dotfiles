---
name: debug-prod
description: Production diagnosis discipline — read-only first, fix the window, walk the layers in order, correlate by IDs; never change infra mid-diagnosis
allowed-tools: Read, Bash, Grep, Glob
---

# Debugging Production

Template skill — the project's copy should add its concrete sources (log
groups, dashboards, buckets, runbooks). The discipline below is universal.

## Ground rules

- **Read-only first.** Queries and log reads only; no restarts, retention
  changes, IAM edits, scaling or deploys during diagnosis without explicit
  approval.
- **Fix the frame before theorizing**: time window in **UTC**, environment,
  host, and build id (e.g. `X-Build-Id`). A bug report without a window is
  a guess.
- Copy any downloaded data (log slices, dumps) only into `.tmp/` — treat it
  as sensitive; never paste raw log lines with IPs/tokens into tickets or
  chat.

## Walk the layers in order

Investigate the **first boundary that failed** and correlate across layers
by IDs (requestId, jobId, ray/trace id) — one source never replaces
another:

1. **Client/cache**: separate what the user saw from stale cache
   (`CF-Cache-Status`, `Age`) before blaming the origin.
2. **Edge/CDN**: status seen at the edge, normalized route, ray id.
3. **Load balancer**: LB status vs target status, timings, error reason —
   a 502 at the LB with a healthy target points elsewhere than a 502 from
   the app.
4. **Application**: structured logs — query by event and correlation IDs,
   not by message text.
5. **Metrics/alarms**: volume, rate, latency — quantify by route and cause
   **before** proposing retry, scaling or timeout changes.

## Async jobs

For job failures: engine dashboard first (run status, retries, output),
then worker logs by jobId. Remember delivery is at-least-once — check
whether the "bug" is a missing idempotency guard.

## Wrap-up

Report: window, layer where it broke, evidence per layer, quantified
impact, and the smallest fix. If the diagnosis revealed a missing signal
(log, metric, trace), adding it is part of the fix (Bug = Test also
applies to observability gaps).
