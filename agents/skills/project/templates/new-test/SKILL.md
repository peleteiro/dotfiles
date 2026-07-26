---
name: new-test
description: Creates a test following the Bug = Test protocol — red reproduction, fix, green validation; test next to the source, real dependencies
argument-hint: [file-or-bug]
allowed-tools: Read, Write, Glob, Grep, Bash
user-invocable: true
disable-model-invocation: true
---

# Create Test (Bug = Test)

Global skill — if the repo has its own `new-test` skill, it wins.

Flow: 🔴 test that reproduces the failure → 🟢 fix the code → ✅ validate.
Found a bug? **First** the test that reproduces it (it must fail), then the
fix — never the other way around.

## Where and how

- Test **next to the source**: `file.test.ts` (unit),
  `file.integration.test.ts` (integration). **NEVER** a `__tests__/` folder.
- TypeScript: **Vitest** (`import {describe, expect, it} from 'vitest'`), not
  Jest. Other languages: the stack's canonical runner (`go test`, `pytest`,
  `flutter test`, `cargo test`) with the same protocol.
- Run via the repo's task: `mise run test`.

## Real dependencies, not mocks

- **Real database** (isolated test Postgres) — do NOT mock the database; the
  project setup handles creation/cleanup (e.g. `src/test/setup.ts`,
  TRUNCATE between tests).
- Access the database through the layer the code uses (`@/repo`), not via a
  shortcut.
- Prefer **integration** tests for code with I/O.

## Template

```typescript
import {describe, expect, it} from 'vitest'

describe('functionName', () => {
  it('describes the expected behavior', async () => {
    // Arrange
    // Act
    // Assert
    expect(result).toEqual(expected)
  })
})
```

## Flow

1. Identify the file/function (or the reported bug).
2. Create the test next to the source reproducing the case.
3. `mise run test` → confirm it **fails** for the right reason.
4. Fix the code.
5. `mise run test` → confirm green, without breaking the others.

In multi-tenant systems, every domain repo/endpoint also needs a test
proving that one tenant **cannot see** another tenant's data.
