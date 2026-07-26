---
name: env
description: Environment variables and secrets — mise.toml/mise.local.toml (never .env), validation with Zod at the edge, public prefixes, secret manager in production
allowed-tools: Read, Grep
---

# Environment Variables and Secrets

Global skill — if the repo has its own `env` skill, it wins.

**Golden rule: secrets NEVER in code, docs, logs, or the bundle.**
Always via the environment, read at runtime.

## Sources (in dev)

| Context | Source |
|---|---|
| Versionable local defaults (non-secret) | `mise.toml` |
| Overrides and personal credentials | `mise.local.toml` (gitignored) |
| Full environment | Tilt injects it (see `Tiltfile`) |

**Do not use `.env` files.** In production: the platform's secret manager
(AWS Secrets Manager/SSM, Fly/Cloudflare secrets) — never hardcode, not even
in IaC.

## Reading and validation (TypeScript)

One `env.ts` per app/package, validated with Zod — fails at startup if
anything is missing:

```typescript
import {z} from 'zod'

const EnvSchema = z.object({
  DATABASE_URL: z.string().min(1),
  PORT: z.coerce.number().default(3000),
})

export const env = EnvSchema.parse(process.env)
```

Usage: `env.DATABASE_URL` — **never** `process.env.X` scattered across domain
code, nor divergent defaults for the same variable.

## Client exposure

Only deliberately public values go into the bundle: prefix `PUBLIC_`
(Astro/Vite) or `NEXT_PUBLIC_` (Next). "Public" in the name = visible to the
user — never put a token/connection string under these prefixes.

## Naming

- Domain variables carry the project prefix (`BIBLEBOX_`, `PROTOCOLO_`…).
- Integrations keep their canonical prefix (`AWS_`, `NODE_ENV`,
  `CLOUDFLARE_`).

## Checklist when adding a variable

- Documented wherever the project documents env vars.
- Presence and format validated at the edge (Zod).
- Safe local default (no accidental access to production).
- Configured in every runtime that consumes it (dev, CI, prod) **before** the
  code that requires it.
