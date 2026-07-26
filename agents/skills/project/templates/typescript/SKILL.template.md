---
name: typescript
description: Personal TypeScript standards — strict, no any, undefined instead of null, Zod (schema = type), absolute imports, barrel rules, es-toolkit. Use when writing or reviewing TS code.
allowed-tools: Read, Grep
---

# TypeScript — personal standards

Global skill — if the repo has its own `typescript` skill, it wins.

## Golden rules

### 1. Never `any`

```typescript
// ❌ NEVER
const data: any = fetchData()

// ✅ unknown + Zod validation
const data: unknown = fetchData()
const validated = Schema.parse(data)
```

Never silence with `// @ts-ignore` — fix the root cause.

### 2. Prefer `undefined` over `null`

`undefined` is the default for absence. Convert `null` from APIs/DB **at the
edge**:

```typescript
type Patient = {name: string; birthDate?: string} // undefined, not null
const value = row.value ?? undefined
```

### 3. Truly strict

`strict: true` + `noUncheckedIndexedAccess: true`. Handle all type
errors.

## Zod

```typescript
// Schema and type with the SAME name
export const Patient = z.object({id: z.string(), name: z.string()})
export type Patient = z.infer<typeof Patient>

// Form suffix for forms
export const SignInForm = z.object({email: z.string().email()})
export type SignInForm = z.infer<typeof SignInForm>

// Enums: as const + Zod; never native enum. Only the schema gets the Enum suffix
export const Status = ['active', 'inactive'] as const
export const StatusEnum = z.enum(Status)
export type Status = z.infer<typeof StatusEnum>
```

Validation **at the edge** (request, env, job payload); internal code trusts
the types.

## Imports

- Absolute: `@/…` within the app, `@scope/package` across packages.
- ❌ Deep relative imports (`../../../components`).
- Utilities: **es-toolkit**, never lodash.

## Barrels and re-exports

Barrel = file that only re-exports (`index.ts`, `types.ts`) — no logic.

- `index.ts` is **always and only** a barrel; real code lives in a file with
  a descriptive name (`patients.ts`, `encoder.ts`).
- ❌ Cross-package re-export — import directly from the source package.
- ❌ Re-export in a file that has logic.
- Name collisions? Use subpath exports (`@scope/backend/schema/*`), not
  creative renames.

## Naming and files

- kebab-case for general files; CamelCase for the main React component.
- No pseudo-extensions: `protocol.ts`, not `protocol-service.ts`.
- **Single-screen rule**: files between 50 and 350 lines; past 400,
  split. Code a junior can understand.

## Type vs Interface

- `interface` for object shapes and contracts; `type` for
  unions/tuples/utilities. Consistency within the file.
