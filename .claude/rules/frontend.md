---
description: React, TypeScript, Tailwind, responsive web/mobile UX, and luxury UI standards
---

# Frontend Rules

Apply when writing or reviewing UI code (React, TypeScript, CSS/Tailwind).

**Also apply:** `.claude/skills/frontend-design/SKILL.md` for layout, visual hierarchy, and component patterns.

---

## UX-First Principles

1. **Content before chrome** — hierarchy serves reading and task completion, not decoration
2. **One primary action per view** — secondary actions stay visually subordinate
3. **Progressive disclosure** — show essentials first; reveal detail on demand
4. **Forgiving interactions** — confirm destructive actions; preserve form state on errors
5. **Feedback always** — loading, success, empty, and error states are never optional

---

## Luxury & Elegant UI

Aim for **professional, restrained, premium** — not flashy.

| Principle | Do | Avoid |
|-----------|-----|-------|
| **Whitespace** | Generous section padding; `max-w-*` on prose | Cramped grids; edge-to-edge text on desktop |
| **Typography** | Single sans-serif family; weight + size for hierarchy | Mixing serif/sans without reason; more than 2 families |
| **Color** | Semantic tokens (`background`, `foreground`, `muted`, `accent`) | Raw hex in components; loud gradients |
| **Depth** | Soft shadows, subtle borders (`ring-1 ring-*/8`) | Heavy drop shadows; neon accents |
| **Motion** | Short transitions (200–300ms); `prefers-reduced-motion` | Bouncy animations; motion on every hover |
| **Imagery** | High-quality, purposeful; `object-cover` with aspect ratios | Stock-photo clutter; unoptimized hero images |

### Design tokens

- Define colors, type scale, spacing, and shadows in one place (`globals.css` `@theme` or `lib/design-tokens.ts`)
- Use fluid type for hero/section headings: `clamp(min, preferred, max)`
- Body: `text-base leading-relaxed`; muted copy: one step lighter, never low-contrast gray on gray

### Section pattern (reuse)

```
SectionLabel (uppercase, tracked, muted)
  → Heading (display weight, balanced)
    → Body copy (relaxed line-height)
      → Primary CTA → Secondary link
```

---

## Web & Mobile Responsive

**Mobile-first** — default styles target small screens; enhance at `sm` / `md` / `lg`.

| Breakpoint | Tailwind | Typical use |
|------------|----------|-------------|
| Default | — | Single column, stacked nav, full-width CTAs |
| `sm` 640px | Wider padding, 2-col grids | |
| `md` 768px | Horizontal nav, side-by-side layouts | |
| `lg` 1024px | Multi-column editorial grids | |
| `xl` 1280px | Max-width container centered | |

### Mobile requirements

- **Touch targets:** minimum 44×44px (`min-h-11 min-w-11` or `py-3 px-4`)
- **Safe areas:** respect `env(safe-area-inset-*)` on notched devices
- **Viewport:** no horizontal scroll; `overflow-x-hidden` only at page level, not on scrollable panels
- **Typography:** body ≥ `16px` on mobile (avoid `text-sm` for long-form body)
- **Navigation:** full-screen or bottom sheet on mobile; persistent header ≤ 64px
- **Forms:** single column; large inputs; show keyboard-appropriate `inputMode` / `type`
- **Images:** `sizes` + `priority` on LCP; WebP/AVIF via `next/image`

### Desktop polish

- Max content width: `max-w-7xl mx-auto px-6 lg:px-16`
- Hover states only where pointer exists (`@media (hover: hover)`)
- Keyboard focus rings on all interactive elements (`focus-visible:ring-2`)

---

## Component Design

- **Functional components** only — no class components
- One component per file; PascalCase file name matches export
- Keep components under ~150 lines; extract sub-components or hooks if larger
- Prefer **composition** and `children` for slots
- Separate **server** (data fetch, no hooks) and **client** (`"use client"`) components deliberately

## TypeScript

- Props typed with named interfaces (reuse across variants)
- Never `any` — use `unknown` and narrow, or `as const` for literals
- Derive types from Zod: `z.infer<typeof Schema>`
- Event handlers: `React.ChangeEvent<HTMLInputElement>`, etc.

## State Management

- Local state (`useState`) unless shared across routes
- `useReducer` for complex multi-field forms
- **TanStack Query** for server state — no ad-hoc `fetch` in components
- Do not store derived data — compute in render or `useMemo`

## Styling

- **Tailwind** utilities; `cn()` for conditional classes
- Extract repeated patterns into components, not `@apply`
- Inline `style={{}}` only for dynamic values (clamp sizes, motion)
- Dark mode: `dark:` variants on all new surfaces and text

## Accessibility

- Semantic HTML: `<main>`, `<nav>`, `<section>`, `<button>` (not `<div onClick>`)
- Keyboard-navigable; visible `focus-visible` rings
- Images: meaningful `alt` or `alt=""` if decorative
- `aria-label` / `aria-labelledby` when visible label is absent
- Respect `prefers-reduced-motion: reduce`
- Color contrast ≥ WCAG AA (4.5:1 body, 3:1 large text)

## UI States (required)

| State | Pattern |
|-------|---------|
| Loading | Skeleton placeholders for content; spinner only on buttons |
| Empty | Icon + heading + explanation + primary CTA |
| Error | Inline field errors; toast for async; error boundary for fatal |
| Success | Brief confirmation; don't block next action |

## Performance

- `React.lazy` + `Suspense` for route-level splits
- `useMemo` / `useCallback` only when profiling shows benefit
- Avoid layout shift: reserve space for images and async content
- Font: `display: swap`; preload only critical weights

## File Structure

```
src/
  components/   # Shared UI (ui/, layout/, sections/)
  features/     # Feature-scoped modules
  hooks/        # Custom React hooks
  lib/          # Utilities, tokens, constants
  app/          # Routes (Next.js App Router)
```
