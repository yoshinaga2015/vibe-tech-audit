# Workflow: adversarial-review

Optional attacker lens for `feature`, `prelaunch`, or post-fix revalidation.
Sets an attacker objective and traces evidence-backed paths. Not a substitute for an organizational red team.

## Entry

- Base mode is known: `feature`, `prelaunch`, or `fix`
- Lens = `adversarial`
- Target is owned by the user or explicitly authorized for testing
- Test constraints are written before any live request

If a live target, authorization, or constraints are unclear, stay `static-only`.
Do not generate weaponized exploit kits or transmit target data externally.

## Phase A1 — Define the objective

Entry: profile complete.  
Actions:

1. Choose up to three concrete attacker objectives from the app’s actual assets:
   - read another tenant’s private data
   - gain an admin-only capability
   - obtain paid entitlement without valid payment
   - execute an unintended LLM tool action
   - exhaust a costly resource
2. Define the attacker’s starting privilege (anonymous, basic user, tenant admin).
3. Define protected assets, trust boundaries, and prohibited actions.

Exit: objective cards with attacker, target, entry point, and constraints.

## Phase A2 — Trace attack chains

Entry: objectives defined.  
Actions:

1. Trace entry point → trust boundary → authorization decision → data/action sink.
2. Link existing findings that can compose into a larger outcome.
3. State every prerequisite; do not skip missing steps with speculation.
4. Grade each chain:
   - `CONFIRMED`: evidence demonstrates every step
   - `PLAUSIBLE`: static evidence exists but runtime validation is missing
   - `BLOCKED`: a verified control stops the chain
   - `UNVERIFIED`: required evidence is unavailable

Exit: chain list with evidence at each hop.

## Phase A3 — Validate safely

Entry: at least one PLAUSIBLE chain.  
Actions:

1. Prefer static proof and existing tests.
2. For a live test, use test accounts/data and the narrowest harmless request.
3. Never target production data, persist access, evade monitoring, or exfiltrate content.
4. Record exact request shape or test case, expected safe result, and observed result.
5. A failed attempt does not prove the class absent; record tested coverage.

Exit: chain status updated with reproducible, non-destructive evidence.

## Phase A4 — Defensive closure

Entry: chains assessed.  
Actions:

1. Read [detection-response.md](../references/detection-response.md).
2. For every CONFIRMED or PLAUSIBLE chain, assess:
   - prevention
   - detection
   - containment
   - recovery
3. Add missing detection/response controls as findings or UNVERIFIED items.

Exit: each chain has both exploitability and defensive-coverage results.

## Output

Use the report template’s `Attack-chain analysis` section:

```text
AC-01: Basic user → forged orgId → unscoped export → tenant data leak
Status: PLAUSIBLE
Evidence: api/export.ts:42; repositories/invoice.ts:18
Detection: no alert found for cross-tenant denials or export spikes
Containment: export token cannot be revoked independently
```

## Exit

- Objectives are concrete and in scope
- Every chain hop has evidence or is marked missing
- No destructive or externalized testing
- Detection and response are assessed, not just prevention
