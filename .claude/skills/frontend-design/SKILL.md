---
name: frontend-design
description: Situational intelligence for making high-quality UI/UX decisions. Invoked when designing new screens, components, or interaction patterns.
triggers:
  - designing a new page
  - building a new component
  - asked about layout, spacing, or visual hierarchy
  - implementing responsive design
  - working on dark mode or theming
---

# Frontend Design Skill

This skill provides Claude with situational design intelligence — opinionated guidance for building UIs that are consistent, accessible, and delightful.

---

## Design Principles

1. **Content first** — layout should serve the content, not the other way around
2. **Progressive disclosure** — show only what users need at each step
3. **Consistency** — reuse existing patterns before inventing new ones
4. **Accessibility by default** — design for keyboard and screen reader from the start

---

## Layout Patterns

### Page Layout
- Use a max-width container: `max-w-7xl mx-auto px-4 sm:px-6 lg:px-8`
- Separate concerns: sidebar, main content, and panel are distinct layout zones

### Spacing Scale (Tailwind)
| Use | Class |
|---|---|
| Between related items | `gap-2` / `space-y-2` |
| Between sections | `gap-6` / `space-y-6` |
| Between page sections | `gap-12` / `space-y-12` |

### Responsive Breakpoints
- Mobile-first: default styles are for mobile
- `sm:` — 640px, `md:` — 768px, `lg:` — 1024px, `xl:` — 1280px

---

## Component Patterns

### Form Fields
```tsx
<div className="space-y-1">
  <label className="text-sm font-medium text-gray-700">{label}</label>
  <input className="w-full rounded-md border border-gray-300 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500" />
  {error && <p className="text-xs text-red-500">{error}</p>}
</div>
```

### Empty States
- Always provide an empty state for lists and search results
- Include: icon, heading, description, and a primary action CTA

### Loading States
- Use skeleton loaders (not spinners) for content areas
- Use a spinner only for button actions

### Error States
- Inline validation errors appear below the field in red
- Toast notifications for async operation outcomes
- Full-page error boundary for unrecoverable errors

---

## Color & Typography

- Use the design token system — no raw hex values in components
- Typography scale: `text-xs`, `text-sm`, `text-base`, `text-lg`, `text-xl`, `text-2xl`, `text-4xl`
- Body text: `text-gray-700`, muted text: `text-gray-500`, headings: `text-gray-900`
- Primary action color: `blue-600` (hover: `blue-700`)
- Destructive action color: `red-600` (hover: `red-700`)

---

## Dark Mode

- Use Tailwind's `dark:` variant throughout
- Test every new component in both light and dark mode
- Never hardcode `#ffffff` or `#000000` — use semantic color tokens
