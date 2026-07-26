---
name: llm
description: LLM integration standard — provider behind a project-owned interface, deterministic fake in dev/tests, model per use case (suggested defaults: Gemini Flash and Claude Sonnet), keys via env
allowed-tools: Read, Grep, Glob
---

# LLM Integration

Template skill — model-agnostic by design. The project picks its providers
and models; this skill fixes **how** they are wired, not **which** one wins.

## Provider behind your own interface

The SDK never leaks into domain code. One package/module owns the
integration (like `jobs` owns Hatchet):

```typescript
export interface Ai {
  complete(req: CompletionRequest): Promise<Result<Completion, AiError>>
}

// Composition root picks the implementation:
const ai = process.env.GEMINI_API_KEY === undefined
  ? createFakeAi()                 // dev/test: deterministic
  : createGeminiProvider({apiKey: process.env.GEMINI_API_KEY})
```

- **Deterministic fake in dev and tests** — same input, same output; no
  network, no key, no cost. Tests never call a real model.
- Swapping providers touches one file, never business logic.

## Choosing models

Choice is per project and per use case — record it in the project's
AGENTS.md. Suggested defaults (revisit against current model lineups):

| Profile | Suggested default |
|---|---|
| High volume, low latency, extraction/classification | **Gemini Flash** |
| Quality reasoning, generation, agentic use | **Claude Sonnet** |

Escalate to a bigger model only with evidence the default fails the task;
route by use case, not one model for everything.

## Rules

- **Keys via env** (`env` skill): never committed, never logged, never in
  client bundles. One env var per provider.
- **Structured output validated with Zod** at the edge — model output is
  untrusted input (`safeParse`, never blind `JSON.parse` + cast).
- **Predictable failures are Results** (`error` skill): rate limit,
  refusal, invalid output → typed error, with retry/backoff only where
  idempotent. Timeouts always set.
- **Observability**: log model, latency, token usage and outcome per call
  (structured, no prompt/PII in logs); token counts make cost visible in
  dashboards.
- **Long/expensive calls run as background jobs** (`hatchet` skill), not
  inside HTTP request handlers.
- Prompts are code: versioned in the repo, close to their use case, with
  the "why" documented — never inline strings scattered around.
