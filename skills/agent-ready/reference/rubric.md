# Agent-Readiness Rubric - Four Layers

Score each dimension **0** (Red), **1** (Yellow), or **2** (Green). Maximum: 24.

This rubric works on any codebase, any language. Use it to audit how well an AI coding agent can navigate and work in a repo, and to prioritize what to improve.

## Layer 1 - Context Files

| # | Dimension | 0 - Red | 1 - Yellow | 2 - Green |
|---|-----------|---------|------------|-----------|
| 1 | **Root context file** | No `AGENTS.md` / `CLAUDE.md` or equivalent | Exists but generic, too long, outdated, or over-constrained (blanket style bans, conflicts with other context files) | Terse, non-obvious only, judgment-framed, under ~100 lines |
| 2 | **Subdirectory context** | None | One or two, but inconsistent | Key areas have focused context files that load lazily |
| 3 | **Rules / conditional context** | None | Some rules exist but no path scoping | `.claude/rules/` or `.cursor/rules/` with path-scoped activation; hard rules reserved for safety |

## Layer 2 - Code Structure

| # | Dimension | 0 - Red | 1 - Yellow | 2 - Green |
|---|-----------|---------|------------|-----------|
| 4 | **File-size discipline** | Multiple files >500 lines, mixed concerns | Some large files but most are reasonable | All files <300 lines, single responsibility |
| 5 | **Naming conventions** | Inconsistent, undocumented | Mostly consistent within each layer | Documented, consistent across the codebase |
| 6 | **Test co-location** | No clear test-to-source mapping | Tests mirror source tree with a naming convention | Co-located or clearly mapped, easy for agents to find |

## Layer 3 - Feedback Loops

| # | Dimension | 0 - Red | 1 - Yellow | 2 - Green |
|---|-----------|---------|------------|-----------|
| 7 | **Test commands** | Undocumented, require tribal knowledge | In README but not in context files, or ambiguous | Exact commands in the context file, including single-file test |
| 8 | **Type checking / linting** | No config | Config exists but commands undocumented | Strict config + documented commands + CI enforcement |
| 9 | **CI pipeline** | No CI or minimal | Basic CI (tests only) | Multi-layer: lint + types + tests + security scan |

## Layer 4 - Safety Boundaries

| # | Dimension | 0 - Red | 1 - Yellow | 2 - Green |
|---|-----------|---------|------------|-----------|
| 10 | **Security documentation** | None | Auth flow partially described | Auth flow, secret handling, and forbidden operations documented |
| 11 | **Permission boundaries** | None | Some informal guidelines | Deny rules (e.g. `.claude/settings.json`) + pre-commit hooks |
| 12 | **Architecture decisions** | No rationale documented | Some code comments | ADRs or documented rationale for major patterns |

## Scoring Guide

| Total | Rating | What it means |
|-------|--------|---------------|
| 0-6 | Low | Agent will struggle; high hallucination risk |
| 7-12 | Below average | Agent can work but wastes context window navigating |
| 13-18 | Good | Agent is productive; some friction on edge cases |
| 19-24 | Excellent | Agent-optimized codebase; minimal wasted context |

## Per-Layer Health

| Layer | Max | Healthy | Focus if below |
|-------|-----|---------|----------------|
| Context Files | 6 | 4+ | Write a terse root context file, add one subdirectory file |
| Code Structure | 6 | 4+ | Split the largest files, co-locate tests |
| Feedback Loops | 6 | 3+ | Document test commands in the context file, add a linter |
| Safety | 6 | 3+ | Write deny rules, document the auth flow and forbidden ops |

## How to Use

1. Score each dimension with concrete evidence (file names, line counts).
2. Validate and adjust each score with your own judgment. You know your codebase.
3. Note per-layer subtotals. The weakest layer is your priority.
4. Layer 1 has the fastest ROI (minutes to improve). Layer 2 has the deepest ROI (structural improvements help every future task).
5. In Claude Code, `/doctor` automates the rightsizing part of Layer 1 (CLAUDE.md and skills). Use this rubric for the full four-layer picture.
