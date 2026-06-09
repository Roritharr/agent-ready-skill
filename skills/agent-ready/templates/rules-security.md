<!--
TEMPLATE: an always-loaded rule. Place at .claude/rules/security.md
No `paths:` frontmatter means it applies to all files.
Fill in the real auth model and forbidden operations for this repo.
-->

# Security Rules

<One line describing how requests are authenticated in this project, if relevant.>

## Forbidden

- NEVER bypass authentication or authorization checks.
- NEVER hardcode tokens, secrets, or credentials anywhere.
- NEVER commit `.env` files, vault tokens, or service-account keys.
- NEVER log sensitive data (PII, auth tokens, secrets).
- NEVER expose internal service URLs or infrastructure details in client-facing output.

## Secrets

All secrets come from <source: e.g. a secrets manager, environment variables>.
Do not create new secret-storage mechanisms.

## Auth Flow

<Short description of the auth path, if the project has one. Delete if not applicable.>
