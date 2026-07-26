---
name: frontend
description: Frontend design standard — shadcn/ui on Base UI (headless), Tailwind + CVA, premium aesthetic, accessibility, performance. Use when building or reviewing UI components, pages or styles.
allowed-tools: Read, Grep, Glob
---

# Frontend — components, design, a11y, performance

Template skill — the project's copy wins and may specialize (framework,
store, design tokens).

> Base UI and shadcn evolve fast. Before pinning an API that is not in the
> examples below, **check the current docs** (base-ui.com and ui.shadcn.com)
> — do not invent imports or props.

## Stack

- **shadcn/ui on Base UI** — Base UI is the shadcn default since Jul 2026.
  Headless package: `@base-ui/react` (v1; the old `@base-ui-components/react`
  name is dead). Per-component path imports:

```typescript
import {Popover} from '@base-ui/react/popover'
```

- **Composition**: Base UI uses the `render` prop (not Radix's `asChild`) and
  `data-*` state attributes for styling — check the component page before
  assuming Radix idioms.
- **Styling**: Tailwind (v4) + CVA for variants + `cn()` for class merging.
- Radix appears only in legacy installs — never start new work on it, and do
  not migrate an existing Radix install on your own (record it, see
  `/project-doctor`).

## Components

- Add via the shadcn CLI; the generated code is **owned by the project** —
  edit it freely, it is not a dependency.
- Never import styled components from third-party kits; compose Base UI
  primitives + Tailwind instead.
- One main component per CamelCase file; variants with CVA, not prop
  spaghetti:

```typescript
const buttonVariants = cva('inline-flex items-center justify-center …', {
  variants: {
    variant: {default: '…', destructive: '…', ghost: '…'},
    size: {sm: '…', md: '…', lg: '…'},
  },
  defaultVariants: {variant: 'default', size: 'md'},
})
```

- Local state → `useState`; shared/global state → the store the project
  chose (see its AGENTS.md); never a new state lib per feature.

## Premium aesthetic ("wow factor")

The bar is "feels designed", not "works":

- **Generous spacing** — whitespace is a feature; cramped UI reads as broken.
- **Micro-interactions** — hover/focus/press feedback everywhere it makes
  sense (framer-motion for real animation; CSS transitions for the rest).
  Motion must be subtle and fast (≤200ms for feedback).
- **Dark mode is first-class** — every component is designed and reviewed in
  both themes, not "inverted later".
- **Consistency beats novelty** — reuse the project's tokens
  (spacing/radius/colors); one-off values are a smell.

## Two UI standards: product vs admin

The premium bar above applies to the **public/product UI**. An **admin UI**
is a different discipline:

- **Density and productivity over wow factor** — tables, filters, bulk
  actions, keyboard-first flows; compact spacing is correct here.
- Motion minimal (feedback only); no decorative animation.
- Same foundations still apply: ui-kit components, both themes, full
  accessibility, consistent tokens — "different standard" never means
  "sloppy".

When the project has both, keep them as separate apps (e.g. `apps/web` and
`apps/admin`) sharing the ui-kit — never mix the two styles in one app.

## Shared ui-kit

When more than one app consumes UI, components live **once** in a
`packages/ui` kit (tokens, shadcn components, `cn()`/CVA helpers); apps
only consume it. No per-app forks of the same button.

## Accessibility (do not break what Base UI gives you)

Base UI primitives ship with keyboard navigation, focus management and ARIA
wiring — styling must preserve them:

- Keep semantic elements (`button`, `nav`, `label`+input); never a clickable
  `div` when a primitive exists.
- **Visible focus** (`focus-visible:` styles) on every interactive element —
  never `outline-none` without a replacement.
- Contrast checked **in both themes**; state never conveyed by color alone.
- Test the keyboard path (tab/escape/arrows) after restyling any overlay
  (popover, dialog, menu, combobox).
- Images with meaningful `alt`; icon-only buttons with an accessible label.

## Performance

- **Server Components by default**; `"use client"` only at the leaves that
  actually need interactivity — never at the page/layout root out of
  convenience.
- Images through the framework's optimized pipeline (`next/image`, Astro
  assets…), sized to avoid CLS.
- Watch LCP: no giant hero image without priority, no blocking font loads
  (use `font-display: swap`/framework font tooling).
- Lazy-load below-the-fold heavy components (`dynamic()`/`client:visible`).
- Bundle discipline: check what a new dependency costs before adding it —
  prefer composing what already exists.

## Checklist for a new component/page

- [ ] Base UI primitive (via shadcn) as the base, `render` prop for
      composition.
- [ ] Variants via CVA; classes merged with `cn()`.
- [ ] Reviewed in light **and** dark; keyboard path tested.
- [ ] Server Component unless it provably needs the client.
- [ ] Micro-interaction on the interactive states.
