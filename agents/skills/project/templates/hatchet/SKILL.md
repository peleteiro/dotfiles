---
name: hatchet
description: Asynchronous jobs with self-hosted Hatchet in TypeScript projects — tasks, crons, events, durable tasks, flow control (concurrency, rate limit, priority), idempotency and transactional outbox. Use when creating, dispatching or reviewing background jobs. Exception: in biblebox the standing choice is Inngest (legacy decision — new code there stays on Inngest until the eventual migration).
---

# Hatchet — durable asynchronous jobs

Personal standard for background jobs with **self-hosted Hatchet**
(TS SDK `@hatchet-dev/typescript-sdk`). If the repo has its own `hatchet`
skill, **it wins** — this is the global/generic version.

> The SDK surface evolves. Before pinning an API that is not in the examples
> below (durable tasks, rate limits, priority), **check the current Hatchet
> docs** — do not invent method signatures.

## Standard architecture

The Hatchet SDK stays **encapsulated in a `jobs` package** — the rest of the
repo never imports the SDK directly:

- `packages/jobs` (**producer**) — singleton client (`getHatchet()`), task
  catalog + Zod payloads, `sendJob()`.
- `services/worker` (**consumer**) — registers and runs the tasks with
  injected deps (db, logger, mailer…); the only other place that sees the SDK.
- Self-hosted engine (docker-compose in dev via Tilt; ECS/VM in prod); worker
  connects via gRPC, authenticated by `HATCHET_CLIENT_TOKEN` (env, never
  committed).

## Task and event names

- **Canonical ID**: `domain:group:job` (`documents:prontuario:render`);
  sub-jobs with `.`; compound words with hyphens.
- **Events in the past tense**: they describe what happened
  (`record_entry.signed`, `consultation.approved`) — never imperative.
- **Wire format**: the engine builds the action id as `workflow:task` and
  **rejects `:` inside the name** — map `:` → `.` in a single place:

```typescript
export function toEngineTaskName(name: TaskName): string {
  return name.replaceAll(':', '.')
}
```

The `domain:group:job` convention applies everywhere else in the code; only
the wire format changes, encapsulated in the producer and the worker.

## Task catalog + Zod payloads

Single source of truth in `tasks.ts`: names in an `as const`, each task's
payload with a Zod schema (**schema = type, same name**), and a name → schema
map for generic validation at dispatch:

```typescript
export const TaskName = {
  documentsProntuarioRender: 'documents:prontuario:render',
  messagingEntryNotify: 'messaging:entry:notify',
} as const
export type TaskName = (typeof TaskName)[keyof typeof TaskName]

export const RenderProntuarioPayload = z.object({
  tenantId: z.string().min(1),
  recordEntryId: z.string().min(1),
})
export type RenderProntuarioPayload = z.infer<typeof RenderProntuarioPayload>

export const TaskPayloadSchemas: Record<TaskName, z.ZodType> = {
  [TaskName.documentsProntuarioRender]: RenderProntuarioPayload,
  [TaskName.messagingEntryNotify]: EntryNotifyPayload,
}
```

**Payload design** (what made Inngest events work well applies equally
here):

1. **Self-sufficient** — include everything the consumer needs (main IDs +
   context), without forcing an unnecessary round-trip to the database.
2. **Immutable** — never change the meaning of a field after it is published;
   add optional fields or create a new task.
3. **Traceable** — always carry the correlation IDs (`tenantId`,
   `recordEntryId`…); sweep crons use an empty payload and read state from
   the database.

## Dispatch (producer)

Validate at the edge, fire-and-forget dispatch, typed errors:

```typescript
export async function sendJob(name: TaskName, payload: Record<string, unknown>): Promise<void> {
  const parsed = TaskPayloadSchemas[name].safeParse(payload)
  if (!parsed.success) throw new InvalidJobPayloadError(name, parsed.error.message)
  try {
    await getHatchet().runNoWait(toEngineTaskName(name), parsed.data as never, {})
  } catch (cause) {
    throw new JobSendError(name, {cause})
  }
}
```

- `runNoWait` = fire-and-forget: retrying the **work** belongs to the engine;
  losing **this hop** is the outbox's problem (below).
- To compose flows that need the result, prefer DAG/child tasks in the
  worker over a synchronous `run(...)` in an HTTP request.

## Tasks in the worker (consumer)

```typescript
const renderTask = hatchet.task({
  name: toEngineTaskName(TaskName.documentsProntuarioRender),
  retries: 3,
  fn: async (input: RenderProntuarioPayload) => {
    return renderEntryPdf({db, bucket, logger}, input)
  },
})

const worker = await hatchet.worker('my-worker', {
  workflows: [renderTask /* … */],
})
await worker.start()
```

- The task delegates to a domain function with **injected deps** — the `fn`
  is just glue; the logic lives in modules testable without Hatchet.
- **Return useful data** (counts, IDs) — it becomes visible output in the
  dashboard.

### Crons

```typescript
const renewalDueTask = hatchet.task({
  name: toEngineTaskName(TaskName.clinicalTreatmentRenewalDue),
  onCrons: ['0 12 * * *'], // 09:00 America/Sao_Paulo (cron in UTC — note the conversion!)
  fn: async () => ({notified: await renewalDueSweep({db, mailer, logger})}),
})
```

A cron **sweeps database state** (sweep), it carries no payload — that way a
missed run is recovered on the next one.

### Events and fan-out

One event can trigger N independent tasks (one failing does not affect the
others, selective replay per task). Two ways:

- **Via outbox relay** (preferred pattern, see below): the relay maps
  `eventType` → list of tasks and dispatches each one:

```typescript
export function tasksForOutboxEvent(eventType: string): TaskName[] {
  switch (eventType) {
    case 'record_entry.signed':
      return ['documents:prontuario:render', 'messaging:entry:notify']
    default:
      return []
  }
}
```

- **Native to Hatchet** (`onEvents` on the task + event push) — useful when
  the producer is already inside the worker; check the docs for the current
  signature.

## Multi-step: DAG and durable tasks

Hatchet's retry unit is the **task**. When a job has multiple steps with
independent side effects, do **not** pile everything into one `fn` — split it:

- **DAG (`hatchet.workflow` + tasks with `parents`)** — chained steps, each
  with its own retry; one step's output feeds the next. It is the
  equivalent of Inngest's `step.run`.
- **Durable task (sleep/event wait)** — for "sleep 24h and continue" or
  "wait for human approval with a timeout", use the SDK's durable variant
  (`ctx.sleepFor(...)`, event wait with timeout). **Always set a timeout
  and handle the non-arrival case** (the equivalent of `waitForEvent`'s
  `null`). Check the current docs before using it — the durable API is the
  one that changes most.

Rules inherited from the durable model (they apply to any engine):

- **A non-deterministic side effect belongs in its own step** (external
  API, database, I/O). Pure computation/validation needs no step.
- **Never rename a step/task with in-flight executions** — replay loses the
  reference.
- Large jobs: split them into smaller tasks composed via DAG/events, not
  into a monolithic 30-minute function.

## Flow control — decision guide

| I need… | Use |
|---|---|
| "At most N running at the same time" | `concurrency` with `maxRuns` |
| "Fairness across tenants (noisy neighbor)" | `concurrency` with per-tenant key + round-robin |
| "Only the most recent execution matters" (≈ debounce/singleton) | `concurrency` with key + cancel-in-flight strategy |
| "Respect an external API limit (e.g. OpenAI)" | shared rate limit by key |
| "Some runs jump the queue" | priority at dispatch |
| "Run on a schedule" | `onCrons` |

```typescript
// Example: serializes per tenant (CEL key over the input).
concurrency: {expression: 'input.tenantId', maxRuns: 1}
```

Hatchet **does not have** native debounce or batching like Inngest: debounce
is approximated with keyed concurrency + cancellation of the previous run;
batching is solved with a sweep cron that processes the backlog.

## Errors and retries

- `retries` per task; configurable backoff. Calibrate by the cost of the
  effect (an external webhook can take 5; a PDF render, 3).
- **A predictable error is not a retry**: validate with Zod at the edge and
  resolve domain errors with the Result pattern (`{ok, data, error}`)
  **inside** the domain function. `throw` (and therefore retry) is only for
  the unexpected (network, timeout, 5xx).
- **A permanent error must not retry** ("user does not exist"): throw the
  SDK's non-retryable error (`NonRetryableError`) to fail for good.
- External rate limit (429): retry honoring `retry-after` when the SDK
  allows it; otherwise, protect with Hatchet's own rate limit.

## Idempotency

Delivery is **at-least-once** — design the consumer to receive duplicates:

- **Key derived from the payload** (`tenantId + recordEntryId`), never
  random.
- **Idempotent effect** in the consumer: `INSERT ... ON CONFLICT DO NOTHING`,
  check state before acting ("already rendered? return"), mark processing
  in a control table.
- Sweep crons are naturally idempotent (they read the current state).

## Transactional outbox (preferred pattern)

To avoid losing events in a crash between the commit and the dispatch:

1. Write the event to an `outbox` table **in the same transaction** as the
   domain write.
2. A relay (cron `* * * * *` in the worker) reads the pending outbox and
   dispatches via `sendJob` (idempotent, marks as sent).
3. **Never** call the Hatchet SDK directly from HTTP handlers/routes — the
   API only writes to the outbox.

The same relay serves to deliver outgoing webhooks (HMAC-signed POST +
retry).

## Observability

- **Structured** logger with the task name and correlation IDs; zero
  `console.log` (oxlint `no-console: error` already blocks it).
- Log **once per effect**, inside the step that performs it — on replay,
  code outside the step runs again and duplicates the log.
- Return metrics in the task output (`{sent: 3}`) — free in the dashboard.

## Common mistakes

1. ❌ Importing the Hatchet SDK outside the `jobs` package/worker.
2. ❌ Dispatching a job directly from the HTTP handler without the outbox
   (the event vanishes on a crash).
3. ❌ Payload without Zod validation at the dispatch edge.
4. ❌ Monolithic task with N side effects (split into DAG/tasks).
5. ❌ Ignoring idempotency in a critical task (delivery is at-least-once).
6. ❌ Cron comment without the UTC ↔ America/Sao_Paulo conversion.
7. ❌ Renaming a task/step with in-flight executions.
8. ❌ `throw` for a predictable domain error (use Result; retry does not fix
   a business rule).

---

_Concepts of durable execution, flow control and event design adapted from
the `inngest-*` skills (github.com/inngest/inngest-skills, Apache-2.0) for
Hatchet; API examples as actually used in the `protocolo` repo._
