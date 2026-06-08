# Claude Config Template

Reusable AI assistant configuration for **TypeScript full-stack apps** (Next.js App Router, Prisma, pnpm). Drop this into any project to give Claude and Cursor consistent standards, specialized agents, slash commands, quality hooks, and domain rules — before or alongside your application code.

This repo ships **no app source code**. It contains:

- `CLAUDE.md` — project brain (architecture, conventions, workflow)
- `.claude/` — agents, rules, commands, hooks, and skills

---

## What you get

| Piece | Purpose |
|-------|---------|
| **Rules** | Auto-applied standards for frontend, API, database, security, observability, and testing |
| **Agents** | Code review, debugging, tests, refactor, docs, security audit personas |
| **Commands** | Playbooks for `/pr-review`, `/fix-issue`, `/deploy`, `/test`, `/lint` |
| **Hooks** | Pre-commit quality gate and format/lint-on-save |
| **Skills** | Situational UI/UX guidance (`frontend-design`) |

---

## Requirements

- **Node.js** 18+ (for hooks and typical consuming apps)
- **pnpm** (recommended package manager in this template)
- **Git** (optional but recommended for pre-commit hooks)
- A target project using (or planning) the default stack in `CLAUDE.md`, or willingness to customize paths and rules

---

## Install into your project

### Option A — Copy files (recommended)

From your application repo root:

```bash
# Clone this template temporarily (or download ZIP from GitHub)
git clone https://github.com/bandeto45/claude.git /tmp/claude-config

# Copy into your project
cp /tmp/claude-config/CLAUDE.md .
cp -R /tmp/claude-config/.claude .

# Optional: merge env documentation
cp /tmp/claude-config/.env.example .env.example
# Then copy to .env.local and fill in real values
cp .env.example .env.local
```

### Option B — Copy only what you need

Minimum install:

```bash
cp CLAUDE.md /path/to/your-app/
cp -R .claude /path/to/your-app/
```

Add agents, commands, or rules later by copying individual files from `.claude/`.

### Option C — Git submodule

Keep the config updatable from this repo:

```bash
cd /path/to/your-app
git submodule add https://github.com/bandeto45/claude.git .claude-config

cp .claude-config/CLAUDE.md .
cp -R .claude-config/.claude .
```

After updating the submodule, re-copy or symlink if you maintain a merged tree.

---

## Post-install checklist

Work through these steps in **your** application repo after copying files.

### 1. Customize `CLAUDE.md`

Edit for your stack and layout:

- **Architecture** — framework, database, auth, hosting
- **Key Conventions** — folder paths, naming, validation library
- **Domain Rules** table — add or remove rule files as needed

### 2. Update `.claude/settings.json`

- Set `project.name` and `project.description` to your app
- Adjust `rules.autoApply` globs if your paths differ (e.g. no `src/` prefix, monorepo packages)

Example monorepo tweak:

```json
"frontend.md": [
  "apps/web/src/components/**",
  "apps/web/src/app/**/*.tsx"
]
```

### 3. Add `package.json` scripts

Hooks call these when present; missing scripts are skipped with a message.

```json
{
  "scripts": {
    "typecheck": "tsc --noEmit",
    "lint": "eslint .",
    "format": "prettier --write .",
    "test": "vitest"
  }
}
```

Install tooling as needed: `typescript`, `eslint`, `prettier`, `vitest`, etc.

### 4. Wire git pre-commit (optional but recommended)

Using [Husky](https://typicode.github.io/husky/):

```bash
pnpm add -D husky
pnpm exec husky init
echo '.claude/hooks/pre-commit.sh' > .husky/pre-commit
chmod +x .claude/hooks/pre-commit.sh .claude/hooks/lint-on-save.sh
```

The pre-commit hook runs `typecheck`, `lint`, and `test`, and scans for hardcoded secrets in `src/`.

### 5. Environment variables

- Keep `.env.example` in git as documentation only
- Copy to `.env.local` (or your env file) and **never commit** real secrets
- Align variable names with what your app and `security.md` / `observability.md` expect

### 6. Commit the config

```bash
git add CLAUDE.md .claude .env.example
git commit -m "Add Claude/Cursor AI configuration"
```

Do **not** commit `.env`, `.env.local`, or files with real API keys.

---

## Using with Cursor

1. Open your project in Cursor — it reads **`CLAUDE.md`** at the repo root as project context.
2. Rules in `.claude/rules/` are referenced by agents and by you when editing matching paths; align globs in `settings.json` with your tree.
3. Invoke **agents** by name in chat (e.g. “use the code-reviewer agent on this diff”).
4. Use **commands** as repeatable workflows — open `.claude/commands/*.md` and follow the playbook, or reference them in chat (e.g. “run the pr-review command”).
5. Enable **lint-on-save** via your editor’s Claude hook integration pointing at `.claude/hooks/lint-on-save.sh` (see `settings.json` → `hooks.post_tool_use`).

For Cursor-native always-on rules, you can optionally mirror `.claude/rules/*.md` into `.cursor/rules/` using the [Cursor rules format](https://docs.cursor.com/context/rules). This template’s source of truth remains `.claude/rules/`.

---

## Using with Claude Code

1. Ensure `CLAUDE.md` and `.claude/` are at the repository root.
2. `settings.json` enables agents, commands, hooks, rules, and skills.
3. Rules auto-apply when editing files matching globs under `rules.autoApply`.
4. Slash commands map to files in `.claude/commands/` (e.g. `/pr-review`).

---

## Directory reference

```
.
├── CLAUDE.md                 # Project brain — customize first
├── .env.example              # Document env vars (no secrets)
└── .claude/
    ├── settings.json         # Master config and rule globs
    ├── agents/               # Specialized AI personas
    ├── commands/             # Workflow playbooks
    ├── hooks/
    │   ├── pre-commit.sh     # typecheck, lint, test, secret scan
    │   └── lint-on-save.sh   # format/lint after file writes
    ├── rules/
    │   ├── frontend.md       # UI, responsive, luxury UX, a11y
    │   ├── api.md            # REST, Server Actions, validation
    │   ├── database.md       # Prisma, migrations, queries
    │   ├── security.md       # Auth, OWASP-aligned coding
    │   ├── observability.md  # Logging, metrics, alerting
    │   └── testing.md        # Vitest, RTL, Playwright
    └── skills/
        └── frontend-design/  # UX-first layout and component patterns
```

---

## Commands

| Command | File | Use when |
|---------|------|----------|
| `/pr-review` | `.claude/commands/pr-review.md` | Reviewing a branch or PR |
| `/fix-issue` | `.claude/commands/fix-issue.md` | Tackling a bug or GitHub issue |
| `/deploy` | `.claude/commands/deploy.md` | Pre-deploy checklist and release |
| `/test` | `.claude/commands/test.md` | Running and scoping tests |
| `/lint` | `.claude/commands/lint.md` | Lint and format pass |

Reference the command file in chat or follow its steps manually.

---

## Agents

| Agent | Role |
|-------|------|
| `code-reviewer` | Conventions, bugs, missing tests |
| `debugger` | Reproduce and fix with minimal diff |
| `test-writer` | Unit, integration, E2E tests |
| `refactorer` | Structure without behavior change |
| `doc-writer` | README, API docs, changelogs |
| `security-auditor` | OWASP-oriented security review |

---

## Customization tips

- **Different stack** (e.g. Express, MongoDB): rewrite relevant sections in `CLAUDE.md` and the matching rule files; update globs in `settings.json`.
- **Stricter or looser gates**: edit `.claude/hooks/pre-commit.sh` or remove scripts you do not use yet.
- **New domain**: add `.claude/rules/your-domain.md` and register it under `rules.autoApply`.
- **Brand/UI**: edit `frontend.md` and `.claude/skills/frontend-design/SKILL.md` with your design tokens and section patterns.

---

## Troubleshooting

| Problem | Fix |
|---------|-----|
| Pre-commit always skips | Add `package.json` with `typecheck` / `lint` / `test` scripts |
| `pnpm: command not found` | Install pnpm: `npm install -g pnpm` or use Corepack |
| Rules not applying | Check file paths match globs in `.claude/settings.json` |
| Hook permission denied | `chmod +x .claude/hooks/*.sh` |
| Secret scan false positive | Adjust the grep pattern in `pre-commit.sh` or exclude safe fixtures |

---

## Updating from upstream

If you copied files manually, pull the latest from this repo and diff against your copy:

```bash
git clone https://github.com/bandeto45/claude.git /tmp/claude-config
diff -ru .claude /tmp/claude-config/.claude
```

Merge changes carefully — you may have customized `CLAUDE.md` and `settings.json`.

---

## License

Use and adapt freely in your projects. Customize `CLAUDE.md` and rules to match your team’s standards.

**Repository:** [github.com/bandeto45/claude](https://github.com/bandeto45/claude)
