---
name: db-migrate
description: Database migrations — dbmate with plain SQL, regenerated types committed together, applied migrations are immutable
argument-hint: [migration-name]
allowed-tools: Read, Write, Bash, Grep, Glob
user-invocable: true
---

# Database Migrations

Standard: **dbmate** with plain SQL migrations; the query layer's types
(Kysely codegen or Drizzle) are regenerated from the real database and
committed **with** the migration.

## Flow

```bash
mise run db:migrate:new <name>   # or: dbmate new <name>
# edit the generated SQL (migrations/ directory)
mise run db:migrate              # apply locally
mise run db:codegen              # regenerate types (if the repo has it)
mise run test                    # nothing broke
```

One migration = one logical change, named for what it does
(`add_patient_document_index`, not `changes`).

## SQL rules

- Write both `-- migrate:up` and `-- migrate:down`; if the change is truly
  irreversible, say so in the down block instead of faking it.
- **Never edit an applied migration** — fix forward with a new one.
- Destructive statements (`DROP`, `TRUNCATE`, `DELETE`/`UPDATE` without
  `WHERE`, column removal) require explicit user approval and belong in
  their own migration, deployed only after the code stops using the object
  (expand → migrate → contract).
- Soft-delete standard: prefer `deleted_at` over hard `DELETE` where the
  project uses it.
- Indexes for the queries you are adding — check the repo layer for the
  access pattern.

## Production

- Migrations run as a deliberate step (release task/pipeline), never
  automatically on app boot without a gate.
- Before a risky migration in prod: snapshot/backup first; verify the
  schema-version health check (if the project has one) will hold traffic
  until the DB catches up.
