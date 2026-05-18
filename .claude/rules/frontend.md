# Frontend Rules

Apply these rules whenever writing or reviewing frontend code (React, TypeScript, CSS/Tailwind).

---

## Component Design

- Use **functional components** only — no class components
- One component per file; file name matches component name in PascalCase
- Keep components under ~150 lines; extract sub-components or hooks if larger
- Prefer **composition over inheritance**
- Use `children` prop for slot-style composition

## TypeScript

- All props must be typed with explicit interfaces (not inline object types for reuse)
- Never use `any` — use `unknown` and narrow, or `as const` for literals
- Derive types from Zod schemas: `z.infer<typeof MySchema>`
- Mark event handlers with proper types: `React.ChangeEvent<HTMLInputElement>`

## State Management

- Prefer **local state** (`useState`) unless shared across routes
- Use `useReducer` for complex multi-field state
- Use **React Query / TanStack Query** for all server state — no manual fetch in components
- Avoid storing derived data in state — compute it in render or `useMemo`

## Styling

- Use **Tailwind CSS** utility classes
- Extract repeated class patterns into reusable components, not `@apply`
- Use `cn()` (clsx + tailwind-merge) for conditional classes
- No inline `style={{}}` unless absolutely necessary (animations, dynamic values)

## Accessibility

- All interactive elements must be keyboard-navigable
- Use semantic HTML (`<button>`, `<nav>`, `<main>`, `<section>`)
- All images require meaningful `alt` text or `alt=""` if decorative
- Use `aria-label` when label text is not visible

## Performance

- Wrap expensive computations in `useMemo`
- Wrap stable callbacks passed to child components in `useCallback`
- Use `React.lazy` + `Suspense` for route-level code splitting
- Avoid re-rendering by memoizing context values

## File Structure

```
src/
  components/       # Shared, reusable UI components
  features/         # Feature-scoped components and logic
  hooks/            # Custom React hooks
  lib/              # Utilities, helpers, constants
  app/              # Routes (Next.js App Router)
```
