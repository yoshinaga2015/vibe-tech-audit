# Workflow: prelaunch

Full technical audit gate before production / real users.

## Entry

- Mode = `prelaunch`
- SKILL.md Phase 1 (profile) complete
- Surface flags set (payments / llm / mobile)

## Phase P1 — 30-minute gate

Entry: profile done.  
Actions: Verify with code or dashboard evidence. Warn early if any looks CRITICAL, but continue.

1. Cross-user id read/write blocked in code (IDOR)
2. Protected APIs reject unauthenticated calls
3. No secrets in client/bundle (validated scan hits)
4. Production errors do not return stacks
5. RLS / storage rules not wide open (Supabase/Firebase)
6. Billing / AI / OTP endpoints have some rate or cost bound

Exit: per-item OK / FAIL / N/A.

## Phase P2 — Full core

Entry: P1 done.  
Actions:

1. Walk [checklist-core.md](../references/checklist-core.md). Keep evidence via search or config reads.
2. If a check needs a live environment you lack, mark `UNVERIFIED` with a one-line user procedure. Never invent PASS.
3. Run [ai-antipatterns.md](../references/ai-antipatterns.md) across the repo.

Exit: core + antipattern findings / UNVERIFIED list.

## Phase P3 — Surfaces

Entry: P2 done.  
Actions: load only flagged refs.

- payments → [checklist-payments.md](../references/checklist-payments.md)
- llm → [checklist-llm.md](../references/checklist-llm.md)
- mobile → [checklist-mobile.md](../references/checklist-mobile.md)

Exit: surface findings.

## Phase P4 — Attacker lens (short)

Entry: P3 done.  
Actions: one paragraph each (N/A if no matching code):

1. Authed user enumerates other object ids
2. Client forges price / role / tenant
3. Public bucket or anon key alone exfiltrates data
4. Forged webhook/cron fulfills entitlements
5. XSS or token theft steals session (especially if tokens in localStorage)

Link existing finding ids; add new ones if needed.

Exit: scenario table.

## Phase P5 — Verdict + report

Entry: P4 done.  
Actions:

1. Write full report via [report-template.md](../references/report-template.md).
2. **PASS**: CRITICAL=0 and HIGH=0. If only UNVERIFIED remain → **CONDITIONAL** (list them).
3. **FAIL**: CRITICAL≥1 or HIGH≥1.
4. Chat: verdict, all CRITICAL, HIGH count, next 3 actions. Do not fix.

Exit: PASS / FAIL / CONDITIONAL + report file.

## Exit

- P1–P5 complete
- Every finding has evidence or UNVERIFIED
- Verdict emitted
- No unsolicited code changes
