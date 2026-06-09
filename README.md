# agent-ready

A single, portable [Claude Code](https://docs.claude.com/en/docs/claude-code) skill that makes any repository **agent-ready**: easy for AI coding agents to navigate, verify their own work in, and operate safely within.

Run it in a brand-new empty repo to start agent-ready from day one, or in an existing codebase to audit what is missing and fill the gaps. It is tool-neutral: it can write the cross-tool `AGENTS.md` standard, Claude Code's `CLAUDE.md`, or both, and asks you which you want.

## What "agent-ready" means

Agent-readiness is not one file. It is four reinforcing layers:

| Layer | What it is | Why it matters |
|-------|-----------|----------------|
| **1. Context files** | A terse root context file, lazily-loaded subdirectory context, path-scoped rules | The agent learns the non-obvious without burning context window exploring |
| **2. Code structure** | File-size discipline, predictable naming, findable tests | The codebase itself is the most important context |
| **3. Feedback loops** | Exact test / lint / type-check commands | An agent that can self-check catches its own mistakes before you review |
| **4. Safety boundaries** | Forbidden ops, secret handling, deny rules, hooks | The agent stays useful without doing damage |

The guiding principle throughout: a context file should hold **only what an agent cannot infer by reading the code**. Custom commands, non-obvious conventions, forbidden patterns, and institutional "why" earn their place. Directory trees and architecture tours do not. Terse beats comprehensive.

## Install

The skill is the folder `skills/agent-ready/`. Put it where Claude Code looks for skills.

**Global (available in every repo, including new ones):**

```bash
./install.sh
# or manually:
cp -R skills/agent-ready ~/.claude/skills/
```

**Per-project (commit it so your whole team gets it):**

```bash
mkdir -p .claude/skills
cp -R /path/to/agent-ready-skill/skills/agent-ready .claude/skills/
```

Then restart Claude Code if it was already running.

## Use

In any repository:

```
/agent-ready
```

The skill detects whether the repo is empty or existing and adapts. You can also force a phase:

| Command | What it does |
|---------|--------------|
| `/agent-ready` | Auto-detect: bootstrap an empty repo, or audit-and-improve an existing one |
| `/agent-ready bootstrap` | Interview and scaffold the four layers (for a new/empty repo) |
| `/agent-ready audit` | Score the repo against the 12-dimension rubric and save a scorecard |
| `/agent-ready build` | Build / fill the four layers, preserving any existing files |
| `/agent-ready verify` | Run the before/after navigation test to prove the setup helps |

Early in the run it asks you two questions and explains the trade-offs:

1. **Which context file** to write: `AGENTS.md` (portable across Claude Code, Cursor, Codex, Copilot), `CLAUDE.md` (Claude Code only), or both (with `CLAUDE.md` importing `AGENTS.md` so there is one source of truth).
2. **How tool-neutral the safety layer** should be: documented-only, plus a Claude Code `.claude/settings.json` deny/allow adapter, and/or Cursor rules.

## What it produces

Depending on your answers and the repo, some subset of:

- A root context file (`AGENTS.md` and/or `CLAUDE.md`), terse and non-obvious-only
- One or more subdirectory context files that load lazily
- `.claude/rules/` with an always-loaded security rule and a path-scoped example (and optionally `.cursor/rules/`)
- A `## Verification Commands` section with your real test / lint / type-check commands
- `.claude/settings.json` deny/allow rules (if you opt in)
- A pre-commit secret-scanning git hook (if you opt in)
- `AGENT_READINESS.md`, a scored scorecard (in audit mode)

Everything is plain files. The skill never pushes, never adds a remote, and asks before overwriting anything that already exists.

## What's in this repo

```
skills/agent-ready/
  SKILL.md                          # the skill: mode detection + four-layer build
  reference/rubric.md               # the 12-dimension, 4-layer scoring rubric
  templates/
    AGENTS.md                       # terse root context starting point
    AGENTS.subdir.md                # lazily-loaded subdirectory context
    rules-security.md               # always-loaded forbidden-ops rule
    rules-path-scoped.example.md    # worked example of a path-scoped rule
    settings.json                   # Claude Code deny/allow starting point
    pre-commit-secrets.sh           # dependency-free secret-scan git hook
install.sh                          # copies the skill into ~/.claude/skills/
```

## Background

The four-layer model and the 12-dimension rubric come from a hands-on "get your codebase agent-ready" workshop. This repo distills that material into one reusable, vendor-neutral skill with no ties to any specific company, codebase, or course.

## License

MIT. See [LICENSE](LICENSE).
