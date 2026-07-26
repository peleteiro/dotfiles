---
name: error
description: Error handling — Result pattern for predictable errors, throw only for the unexpected, Zod validation at the edge, consistent mapping to HTTP. Use when designing error handling.
allowed-tools: Read
---

# Error Handling

Global skill — if the repo has its own `error` skill, it wins.

**Result pattern for predictable errors. Throw for bugs/impossible state.**

## Result pattern

```typescript
type Result<T, E = Error> =
  | {ok: true; data: T}
  | {ok: false; error: E}

async function findPatient(id: string): Promise<Result<Patient, 'NOT_FOUND' | 'DB_ERROR'>> {
  try {
    const patient = await patients.findById(db, id)
    if (!patient) return {ok: false, error: 'NOT_FOUND'}
    return {ok: true, data: patient}
  } catch (e) {
    logger.error({id, err: e}, 'failed to fetch patient')
    return {ok: false, error: 'DB_ERROR'}
  }
}
```

**Predictable** error ("not found", "no permission", "invalid") → Result,
never throw. The `E` type as a union of strings forces the caller to handle
each case.

## When to use throw

Only for the unexpected — bug, impossible state, infrastructure:

```typescript
function assertNever(x: never): never {
  throw new Error(`Unexpected value: ${x}`)
}
```

In async jobs, throw = retry (skill `hatchet`) — never throw for business
rules; retry doesn't fix a business rule.

## Validation at the edge (Zod)

```typescript
const parsed = CreatePatientInput.safeParse(body)
if (!parsed.success) return {ok: false, error: parsed.error}
// from here inward, the code trusts the types
```

Edges: HTTP request, env vars, job payload, external API response.

## Mapping to HTTP

Convert the Result's `error` into a consistent status, without leaking internal detail:

```typescript
type ApiError = {code: string; message: string; details?: Record<string, unknown>}
// 'NOT_FOUND' → 404 · validation → 400 · no permission → 403
// resource from another tenant → 404 (never reveal that it exists)
```

## Error logging

- Structured, with context (`{id, err}`) — zero `console.log`.
- Capture as `unknown` and extract only safe fields; never log secrets,
  tokens, or sensitive data in the clear.
