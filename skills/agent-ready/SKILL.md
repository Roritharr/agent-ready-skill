---
name: agent-ready
description: Make a repository agent-ready across four layers (context files, code structure, feedback loops, safety boundaries) so AI coding agents navigate and work reliably. Run in an empty repo to start agent-ready from day one, or in an existing repo to audit and improve. Usage /agent-ready [bootstrap|audit|build|verify]
argument-hint: [bootstrap|audit|build|verify]
allowed-tools: Read, Write, Edit, Glob, Grep, Bash(ls:*), Bash(find:*), Bash(wc:*), Bash(cat:*), Bash(test:*), Bash(mkdir:*), Bash(cp:*), Bash(date:*), Bash(git:*), Bash(head:*)
---

# Make This Repository Agent-Ready

Your job is to make the **current repository** work well with AI coding agents. A repo is "agent-ready" when an agent can navigate it, verify its own work, and stay inside safe boundaries without a human babysitting every step.

This skill operates on the **current working directory**. It does not clone anything, does not need a network, and writes only inside this repo (plus, optionally, the user's settings). Everything it produces is plain files the user can read, edit, and commit.

## The four layers

Agent-readiness is not one file. It is four reinforcing layers:

1. **Context files** - a terse root context file (`AGENTS.md` and/or `CLAUDE.md`), lazily-loaded subdirectory context, and path-scoped rules. Structure beats size.
2. **Code structure** - file-size discipline, predictable naming, tests that are easy to find. The codebase itself is the most important context.
3. **Feedback loops** - exact commands an agent can run to verify its own work: tests, linting, type checking. An agent that can self-check catches its own mistakes before a human reviews.
4. **Safety boundaries** - forbidden operations, secret handling, and deny rules that stop an agent from doing damage while still letting it be useful.

**Guiding principle (do not skip):** a context file should contain only what an agent *cannot infer by reading the code*. Custom commands, non-obvious conventions, forbidden patterns, and institutional "why" earn their place. Directory trees, architecture tours, and endpoint lists do not (the agent can explore those, and padding them in measurably lowers task success). Terse and opinionated beats comprehensive.

The skill bundles two helpers next to this file. Read them when you need them:
- `reference/rubric.md` - the 12-dimension, 4-layer scoring rubric used in audit mode.
- `templates/` - starting points for every artifact. Treat them as scaffolding to adapt, never as files to copy verbatim.

---

## Step 1: Detect the mode

Decide whether this is an **empty/greenfield** repo or an **existing** codebase:

```bash
git rev-parse --is-inside-work-tree 2>/dev/null   # is this a git repo at all?
```

Then gauge how much real source code exists. Count source files, ignoring config, docs, and the skill's own scaffolding:

```bash
find . -type f \
  -not -path './.git/*' -not -path './node_modules/*' -not -path './.claude/*' \
  | wc -l
```

- **Bootstrap mode** - the repo is empty or has only boilerplate (no meaningful source yet). There is nothing to infer from, so the **human is the only source of context**. You will interview them and scaffold the four layers as a foundation, so conventions exist before the code does.
- **Audit-and-improve mode** - there is real code. You will score it against the rubric, then build and fill gaps, then validate.

If `$ARGUMENTS` names a phase (`bootstrap`, `audit`, `build`, `verify`), honor it instead of auto-detecting. Otherwise pick the mode and **tell the user which mode you chose and why** before continuing.

If this is not a git repo, mention that agent-readiness assumes version control and offer to run `git init`. Do not force it.

---

## Step 2: Ask the user which context-file convention to use

Different tools look for different files. Ask the user to choose, and explain the trade-off in one breath:

> "Which context-file convention do you want?
> - **AGENTS.md** - the portable cross-tool standard. Read by Claude Code, Cursor, Codex, Copilot, and others. Most neutral choice if your team uses more than one tool.
> - **CLAUDE.md** - canonical for Claude Code specifically. Simplest if Claude Code is all you use.
> - **Both** - I write a full `AGENTS.md` and make `CLAUDE.md` a one-line import of it, so there is one source of truth and no drift."

Use their answer as the **primary context file** for the rest of the run. If they pick "both," after writing `AGENTS.md` create `CLAUDE.md` containing a single import line (for Claude Code: `@AGENTS.md`) plus a short note that the real content lives in `AGENTS.md`. Wherever the steps below say "the context file," substitute their choice.

---

## Step 3: Ask the user how tool-neutral the safety layer should be

The safety layer can be enforced by tooling or just documented. Ask, and explain the implication of each:

> "How should I set up the safety / rules layer?
> - **Neutral only** - forbidden operations live in the context file plus an always-loaded rule, and I add a pre-commit hook that scans for secrets. Works with any tool, but nothing auto-blocks a denied action; it relies on the agent reading the docs and the git hook.
> - **Neutral + Claude Code adapter** - all of the above, plus a `.claude/settings.json` with deny/allow rules. Claude Code will actually refuse the denied operations; other tools just read the documented version.
> - **Also emit Cursor rules** - additionally write `.cursor/rules/*.mdc` so Cursor auto-attaches the same rules."

Record their choice and apply it in Layer 4 (and to the rules in Layer 1) below.

---

## Mode A: Bootstrap (empty repo)

There is no code to read, so interview the user, then scaffold. Keep the interview short and concrete. Ask for:

1. **Purpose** - one or two sentences. What is this project?
2. **Stack** - language(s), framework(s), package manager, runtime.
3. **Verification commands** - how tests, linting, and type checking will be run (even if those tools are not installed yet). Aspirational is fine; record the intended commands.
4. **Forbidden operations** - anything an agent must never do here (touch secrets, hit a production endpoint, commit generated files, bypass auth, etc.).
5. **Auth / secrets model** - where secrets come from and how auth works, if relevant.
6. **Conventions they already care about** - file-size budget, naming, where tests live.

Then build the foundation, adapting the bundled templates:

- **Layer 1 - context file.** Write the primary context file (`AGENTS.md` and/or `CLAUDE.md` per Step 2) from `templates/AGENTS.md`. Fill it with the interview answers. Keep it terse (aim under ~60 lines for a new repo) and include only the non-inferrable. Create `.claude/rules/` with an always-loaded rule from `templates/rules-security.md`, and add `templates/rules-path-scoped.example.md` (commented) so the team has a worked example of path scoping to copy when they add code.
- **Layer 2 - code structure.** Add a short "Conventions" section to the context file: a file-size budget (e.g. split files over ~300 lines), the naming scheme, and where tests live relative to source. Writing this *before* code exists is the whole point; the repo grows into it.
- **Layer 3 - feedback loops.** Add a `## Verification Commands` section with the exact intended test / lint / type-check commands from the interview, including a single-file test variant if the stack supports one.
- **Layer 4 - safety boundaries.** Apply the Step 3 choice: document forbidden ops in the always-loaded rule and context file; install `templates/pre-commit-secrets.sh` as `.git/hooks/pre-commit` (chmod +x) if the user wants the neutral hook; write `.claude/settings.json` from `templates/settings.json` if they chose the Claude adapter, replacing the allow-list placeholders with their real verification commands; emit `.cursor/rules/` if they asked for it.

Finish with the **summary** (see below). There is no before/after test in bootstrap mode (no prior baseline and no code to navigate).

---

## Mode B: Audit and improve (existing repo)

### B1. Audit (read `reference/rubric.md` first)

Score all 12 dimensions, 0 / 1 / 2, with **specific evidence** (file names, line counts, observations) for each. Read the actual repo to score; do not assume. The dimensions, by layer:

**Layer 1 - Context files**
1. Root context file - does `AGENTS.md`, `CLAUDE.md`, `.cursorrules`, or `.github/copilot-instructions.md` exist and is it terse and useful?
2. Subdirectory context - any nested context files for distinct areas? `glob **/{AGENTS,CLAUDE}.md`, count non-root hits.
3. Rules / conditional context - `.claude/rules/` or `.cursor/rules/` with path-scoped activation?

**Layer 2 - Code structure**
4. File-size discipline - find source files over ~300 lines; many large files score low.
5. Naming conventions - consistent, predictable casing and layout across the tree?
6. Test co-location - are tests easy to find and clearly mapped to source?

**Layer 3 - Feedback loops**
7. Test commands - a single documented command to run tests, and to run one test file?
8. Type checking / linting - linter/type config present and commands documented?
9. CI pipeline - does CI catch mistakes before they land? Check `.github/workflows/`, `.gitlab-ci.yml`, `Jenkinsfile`, `.circleci/`.

**Layer 4 - Safety boundaries**
10. Security documentation - auth flow, secret handling, and a "never do this" list?
11. Permission boundaries - deny rules (`.claude/settings.json`) or pre-commit hooks for secrets?
12. Architecture decisions - ADRs or documented rationale for major patterns?

Produce a markdown scorecard: per-dimension table with evidence, per-layer subtotals (each out of 6), grand total out of 24, and the **top 3 lowest-scoring dimensions** with a one-line fix for each. Save it as `AGENT_READINESS.md` at the repo root (or print it and ask where they want it). Then ask the user to adjust any scores: they are the expert on their own codebase.

### B2. Build the gaps (preservation pattern is REQUIRED)

Walk the four layers and fill what the audit flagged, prioritizing the lowest-scoring layer. Use the templates as starting points and the audit evidence to fill them with this repo's real details (the real test command discovered from `Makefile` / `package.json` / `pyproject.toml` / etc., the real auth model, the actual large file to avoid).

**Before writing any file that already exists, do not silently overwrite it.** Existing context files may hold real institutional knowledge. For each target path:

1. `test -f <path>`.
2. If it does **not** exist, write normally.
3. If it **does** exist, pause and ask:
   > "`<path>` already exists and may contain knowledge worth keeping. How should I handle it?
   > - **merge** (default for context/settings): I read it, combine it with my draft, and keep everything specific from yours while adding what is missing.
   > - **replace**: I back up the original to `<path>.bak.<timestamp>` and write my version.
   > - **skip**: leave it untouched."
4. Act on their choice. For replace/merge, always create the timestamped backup first (`cp <path> <path>.bak.$(date +%Y%m%d-%H%M%S)`) and tell them where it is. For settings files especially, prefer merge so you never make an agent more permissive than the team intends.

Build order:
- **L1** - root context file (terse, non-obvious only), then one subdirectory context file for the area with the most tech debt (the largest source files), then `.claude/rules/` (one always-loaded security rule; one path-scoped rule using real globs from this repo). Apply the Step 2 convention and Step 3 posture.
- **L2** - note the worst file-size offenders in the relevant context file as "do not add to X, create a new file." You are documenting structure, not refactoring it (offer refactors separately if asked).
- **L3** - discover the real verification commands and add a `## Verification Commands` section to the root context file.
- **L4** - apply the Step 3 choice (forbidden-ops docs always; `.claude/settings.json` and/or pre-commit hook and/or Cursor rules per their answer), filling the allow-list with the real commands found in L3.

### B3. Verify (the before/after test)

Prove the work paid off. In a way the user can observe:

1. Ask the user to start a **fresh agent session** (so no prior context is cached) pointed at this repo.
2. Have them run a neutral navigation prompt, for example:
   > "I need to add a new feature/endpoint to this project. Where should the code go, what naming conventions apply, and what existing patterns should I match? Do not write code, just give me the plan."
3. Compare against the pre-setup behavior: does the agent now cite the context file, explore fewer files, name the right directory and conventions, and mention the forbidden patterns and the file to avoid? Capture two or three concrete differences.

If a baseline was never captured, run the prompt once now and note it as the new baseline for next time.

---

## Summary (always end here)

Tell the user exactly what changed:
- Which files were created or modified (with paths), and where any `.bak` backups went.
- Per-layer state: what each layer now has and what is still missing.
- The single highest-ROI next step. Layer 1 is the fastest to improve (minutes). Layer 2 is the deepest (structural improvements help every future task).
- Remind them these are plain files: review, edit, and commit them through their normal process. Nothing here pushes or touches a remote.

## Guardrails

- Operate only in the current repo. The only write outside it is an optional `.claude/settings.json` or git hook the user explicitly opts into.
- Never push, never add a remote, never run `rm -rf`.
- Never write a secret into any file. If you discover one while reading, flag it and stop.
- When unsure whether content is inferable from code, leave it out. The context file is more useful short.
