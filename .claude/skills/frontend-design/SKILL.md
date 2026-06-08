---
name: frontend-design
description: Situational intelligence for luxury, UX-first UI across web and mobile. Invoked when designing screens, components, or interaction patterns.
triggers:
  - designing a new page
  - building a new component
  - asked about layout, spacing, or visual hierarchy
  - implementing responsive design
  - working on dark mode or theming
  - luxury, premium, or elegant UI requests
---

# Frontend Design Skill

Design intelligence for UIs that are **consistent, accessible, and premium** — UX-first on web and mobile.

**Also apply:** `.claude/rules/frontend.md` for TypeScript, state, a11y, and responsive requirements.

---

## Design Principles

1. **UX before aesthetics** — every visual choice must aid clarity, trust, or task completion
2. **Content first** — layout serves reading order and hierarchy
3. **Progressive disclosure** — essentials visible; detail on demand
4. **Consistency** — reuse tokens and section patterns before inventing new ones
5. **Accessibility by default** — keyboard, screen reader, contrast, reduced motion

---

## Luxury & Elegant Aesthetic

Professional luxury is **restraint**, not ornament.

### Visual language

| Element | Guidance |
|---------|----------|
| **Space** | Generous vertical rhythm (`py-16 md:py-24` sections); never crowd the hero |
| **Type** | One sans-serif family; semibold headings + regular body; fluid `clamp()` for display |
| **Color** | Warm neutrals or cool neutrals — 1 accent max; muted text one step from body |
| **Surfaces** | Soft borders (`ring-1 ring-*/8`), subtle gradients, premium shadow on elevated cards |
| **Motion** | 200–300ms ease; stagger entrance on hero only; honor `prefers-reduced-motion` |
| **Imagery** | Full-bleed only when intentional; otherwise contained with aspect ratio |

### Anti-patterns (cheap feel)

- Rainbow gradients, glassmorphism everywhere, bouncing buttons
- Too many font weights/families on one screen
- Tiny touch targets or `text-xs` body copy on mobile
- Spinners replacing entire page content
- Empty states with no guidance or CTA

---

## Layout Patterns

### Page shell

```tsx
<section className="py-16 md:py-24">
  <div className="mx-auto max-w-7xl px-6 lg:px-16">
    {/* content */}
  </div>
</section>
```

### Section hierarchy

```
SectionLabel   → uppercase, tracked, muted (10–12px)
Heading        → display weight, text-balance, fluid size
Body           → text-base md:text-lg, leading-relaxed, text-muted
CTA row        → primary button + understated text link
```

### Spacing scale

| Use | Class |
|-----|-------|
| Related items | `gap-2` / `space-y-2` |
| Card internals | `gap-4` / `p-6` |
| Section blocks | `gap-8 md:gap-10` |
| Between sections | `gap-12 md:gap-16` |

### Responsive breakpoints

Mobile-first defaults; enhance at `sm` (640), `md` (768), `lg` (1024), `xl` (1280).

- Mobile: single column, full-width CTAs, collapsible nav
- Tablet: 2-column grids where content supports it
- Desktop: editorial multi-column; hover only with `(hover: hover)`

---

## Component Patterns

### Form fields

```tsx
<div className="space-y-1.5">
  <label className="text-sm font-medium text-foreground">{label}</label>
  <input
    className="w-full min-h-11 rounded-lg border border-foreground/15 bg-background px-4 py-2.5 text-base focus:outline-none focus-visible:ring-2 focus-visible:ring-accent/30"
  />
  {error && <p className="text-sm text-red-600" role="alert">{error}</p>}
</div>
```

### Primary button

```tsx
<a className="inline-flex min-h-11 items-center justify-center rounded-full bg-foreground px-8 py-3 text-sm font-medium text-background shadow-[var(--shadow-premium)] transition-all duration-300 hover:-translate-y-0.5 hover:shadow-[var(--shadow-premium-hover)] focus-visible:ring-2 focus-visible:ring-offset-2">
  {label}
</a>
```

### Cards

- Rounded `rounded-2xl`, soft ring or border, image with fixed aspect ratio
- Title → meta (date, tag) → excerpt → text link with underline offset
- Hover: subtle lift or opacity — not scale > 1.05

### Empty / loading / error

| State | Pattern |
|-------|---------|
| Loading | Skeleton matching final layout dimensions |
| Empty | Centered icon + heading + one-line explanation + CTA |
| Error | Human message + retry action; preserve user input |

---

## Mobile UX Checklist

- [ ] Touch targets ≥ 44px
- [ ] Body text ≥ 16px on small screens
- [ ] No horizontal scroll on primary flows
- [ ] Sticky header ≤ 64px; content not hidden under it (`pt-*` offset)
- [ ] Forms single-column; appropriate `inputMode`
- [ ] LCP image optimized with `next/image` + `sizes`
- [ ] Tested at 375px and 768px widths

---

## Color & Typography Tokens

- Semantic tokens only — `background`, `foreground`, `muted`, `accent`, `cream`, `charcoal`
- No raw hex in components
- Scale: `text-xs` labels → `text-base` body → fluid clamp for hero/section titles
- Dark mode: pair every `bg-*` with `text-*`; test contrast in both themes

---

## Dark Mode

- Tailwind `dark:` on surfaces, borders, and text
- Avoid pure `#000` / `#fff` — use token neutrals
- Reduce shadow intensity in dark mode; rely more on border separation
