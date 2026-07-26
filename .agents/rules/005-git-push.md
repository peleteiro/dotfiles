---
trigger: always_on
---

# Git push only when explicitly requested

Only run `git push` when the user **explicitly** asks. NEVER push on your own
initiative.

- Committing locally is fine in the normal flow; publishing (push) is not —
  wait for the request.
- `git push --force` / `-f` / `--force-with-lease` and `git commit
  --no-verify` remain **forbidden** (they rewrite history / bypass hooks).
