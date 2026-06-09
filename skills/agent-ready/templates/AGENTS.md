<!--
TEMPLATE. Adapt, do not copy verbatim. Delete every line that does not apply.

Golden rule: include ONLY what an agent cannot infer by reading the code.
Keep examples like custom commands, non-obvious conventions, forbidden patterns,
and the "why" behind surprising decisions. Cut directory trees, architecture
tours, and endpoint lists; the agent can explore those, and padding them in
measurably lowers task success. Terse and opinionated beats comprehensive.
Aim under ~100 lines.
-->

# <Project name>

<One or two sentences: what this project is and who uses it.>

## Verification Commands

<!-- The single most valuable section. Exact commands an agent runs to check its own work. -->

```bash
<test command>            # run the full test suite
<single-file test>        # run one test file
<lint command>            # lint
<type-check command>      # type check, if applicable
```

## Non-Obvious Conventions

<!-- Things that are surprising or deviate from the framework default. -->

- <Where new code of type X goes, if it is not the obvious place>
- <A pattern this repo uses that an agent would not guess>
- <A standard convention this repo deliberately breaks, and why>

## Forbidden

<!-- Hard "never do this" rules. Security, legacy patterns, dangerous ops. -->

- NEVER hardcode secrets, tokens, or credentials. Secrets come from <source>.
- NEVER commit `.env` files or credential files.
- NEVER <project-specific forbidden operation>.

## Known Tech Debt

<!-- Optional. Specific files/areas to avoid extending. -->

- `<path/to/large_or_legacy_file>` - <why to avoid; create a new file instead>
