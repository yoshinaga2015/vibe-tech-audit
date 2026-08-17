# Workflow: fix-findings

Remediate audit findings only when the user explicitly asks.

## Entry (Safety Gate)

All must hold; otherwise return to audit mode.

1. User explicitly requested fixes (“fix”, “remediate CRITICAL”, etc.)
2. Finding list exists (prior report or user-specified ids)
3. Scope is clear (e.g. CRITICAL only / F-003 only / all)

If scope is ambiguous, AskQuestion once. **Do not guess-refactor the repo.**

## Phase X1 — Queue

Entry: gate passed.  
Actions:

1. List finding ids + severities to fix.
2. Order: CRITICAL → HIGH → (only if asked) MEDIUM. LOW only if asked.
3. Re-Read evidence locations.

Exit: fix queue.

## Phase X2 — Minimal patches

Entry: queue set.  
Actions:

1. Smallest change per finding. No drive-by refactors or formatting churn.
2. Authz fixes: constrain queries with session userId/orgId; never trust client role/tenant/price.
3. Secret exposure: remove from client; **tell the user to rotate keys** (do not revoke production secrets yourself).
4. After each fix, re-check that finding’s verification step.

Exit: patched files + per-finding verification notes.

## Phase X3 — Narrow re-audit

Entry: queue drained.  
Actions:

1. Re-check only fixed items.
2. Re-run machine scan on the diff for newly introduced issues.
3. Update report: `open` → `fixed`, append verification evidence.

Exit: updated report; list remaining opens.

## Phase X4 — Report

- Separate: fixed / remaining / human tasks (key rotation, dashboard RLS, etc.)
- Commit only if the user asks (confirm first)

## Exit

- No out-of-scope edits
- Each fixed item has re-verification notes
- Human tasks are explicit, not silently skipped
