#!/usr/bin/env bash
#
# Pre-commit secret scanner (tool-agnostic).
# Install: copy to .git/hooks/pre-commit and `chmod +x .git/hooks/pre-commit`
#
# Blocks a commit when a staged change looks like a hardcoded secret or a
# committed credential file. Intentionally simple and dependency-free: a
# starting safety net, not a replacement for a real secret-scanning service.

set -euo pipefail

fail=0

# 1) Block credential files from being committed at all.
blocked_files=$(git diff --cached --name-only --diff-filter=AM \
  | grep -E '(^|/)\.env($|\.)|\.pem$|\.key$|credentials|vault.*token' || true)

if [ -n "$blocked_files" ]; then
  echo "BLOCKED: these staged files look like secrets/credentials:"
  echo "$blocked_files" | sed 's/^/  - /'
  fail=1
fi

# 2) Scan staged diffs for obvious secret-looking assignments.
#    Tune these patterns for your stack. Add an allowlist comment
#    `# pragma: allowlist secret` on a line to skip it.
patterns='(AKIA[0-9A-Z]{16})|(-----BEGIN [A-Z ]*PRIVATE KEY-----)|((api[_-]?key|secret|token|password|passwd|pwd)["'"'"' ]*[:=]["'"'"' ]*[A-Za-z0-9/+_-]{12,})'

staged=$(git diff --cached -U0 --diff-filter=AM | grep -E '^\+' | grep -Ev '^\+\+\+' || true)
hits=$(printf '%s\n' "$staged" | grep -Ein "$patterns" | grep -v 'pragma: allowlist secret' || true)

if [ -n "$hits" ]; then
  echo "BLOCKED: staged changes contain possible secrets:"
  printf '%s\n' "$hits" | sed 's/^/  /'
  echo "If this is a false positive, append '# pragma: allowlist secret' to the line."
  fail=1
fi

if [ "$fail" -ne 0 ]; then
  echo
  echo "Commit aborted by pre-commit-secrets hook."
  exit 1
fi

exit 0
