# Workflow: feature-diff

Diff / post-feature technical audit. Do not run the full checklist.

## Entry

- Mode = `feature`
- Lens = `standard` or `adversarial`
- Target repo open
- SKILL.md Phase 1 (profile) complete

## Phase F1 — Diff scope

Entry: profile done.  
Actions:

1. Collect `git status` / `git diff` (staged + unstaged); include base-branch diff if needed.
2. Classify changed files: auth / data-access / API / UI input / payments / llm / config / unrelated.
3. If only unrelated (copy/style) and machine scan has zero dangerous hits, report “no security surface” and stop.

Exit: changed-file list + surface classes.

## Phase F2 — Always-on (★)

Entry: security surface exists, or scan has candidates.  
Actions: Apply only **★ FEATURE** rows from [checklist-core.md](../references/checklist-core.md) to **changed paths**. Minimum:

1. New/changed `find*` / `update` / `delete` / SQL / storage reads include session-derived owner/org constraints.
2. New API / Server Action / tRPC / Cloud Function authenticates; not middleware-only.
3. Diff must not introduce secrets, `NEXT_PUBLIC_*SECRET*`, `service_role`, `dangerouslySetInnerHTML`, or raw SQL concatenation.
4. User input has server-side schema validation / output encoding where rendered.

Exit: ★ findings with evidence, or “★ clear on diff”.

## Phase F3 — Diff-triggered extras

Entry: F2 done.  
Actions:

| Diff contains | Also load |
|---|---|
| Stripe / price / webhook / IAP | [checklist-payments.md](../references/checklist-payments.md) |
| LLM / agent / embeddings | [checklist-llm.md](../references/checklist-llm.md) |
| Expo / RN / mobile | [checklist-mobile.md](../references/checklist-mobile.md) |
| Uploads | core upload ★ |
| Tenant / org | core tenant rows |

Always consult [ai-antipatterns.md](../references/ai-antipatterns.md) when data access changed.

Exit: extra findings.

## Phase F4 — Optional adversarial lens

Entry: F3 done.
Actions:

- If `lens = adversarial`, run
  [adversarial-review.md](adversarial-review.md) against changed attack paths.
- Keep objectives within the diff’s blast radius; do not pretend a full-repo
  or live red-team exercise was performed.
- If `lens = standard`, skip.

Exit: diff-scoped attack chains or N/A.

## Phase F5 — Report

Entry: review done.  
Actions:

1. Write report per [report-template.md](../references/report-template.md) (short OK).
2. Chat: CRITICAL/HIGH + “run prelaunch before ship”.
3. **Do not fix** unless user asks → then `fix` mode.

Exit: report delivered. PASS/FAIL optional (recommend counting remaining CRITICAL/HIGH).

## Exit

- Diff scope clear
- ★ applied to changed paths
- Evidence-backed findings only
- No unsolicited code changes
