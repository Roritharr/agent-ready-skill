<!--
TEMPLATE for a subdirectory context file (place it inside the directory it
describes, e.g. src/api/AGENTS.md). It loads lazily: an agent only reads it when
working on files in this directory, so the root context stays small.

Keep it under ~30 lines. Only directory-specific facts an agent cannot infer.
-->

# <Directory name> - local context

- <The pattern specific to this directory that differs from the rest of the repo>
- <The exemplar file in here to mirror when adding new code>
- <The large or legacy file in here to avoid extending, if any>
- <Where the tests for this code live, and how to run just them>
- <Error-handling / naming convention unique to this area>
