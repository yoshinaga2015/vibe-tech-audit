# Report template

Suggested filename: `tech-audit-YYYY-MM-DD.md` (repo root, or `docs/` / `Flow/` if present)

```markdown
# Tech Audit — <project> — <YYYY-MM-DD>

- Mode: feature | prelaunch | fix
- Lens: standard | adversarial
- Runtime: static-only | live-test
- Verdict: PASS | FAIL | CONDITIONAL | n/a (feature)
- Stack: …
- Surfaces: auth= / payments= / llm= / mobile= / upload= / multi_tenant=
- Scope: <diff summary or "full repo">

## Summary
<3–6 lines. Worst issues first.>

## Findings

### F-001 — <title>
- Severity: CRITICAL|HIGH|MEDIUM|LOW
- Status: open|fixed|unverified|accepted
- ID: <checklist id e.g. C-AUTHZ-01>
- Location: `path:line`
- Evidence:
  ```
  <code quote or command output>
  ```
- Impact: <one sentence>
- Fix: <1–3 sentences; implement only in fix mode>

(List findings by severity descending)

## UNVERIFIED
| ID | Why | User verification steps |
|---|---|---|
| … | no runtime | … |

## Detection and response
| Control | Grade | Evidence / gap |
|---|---|---|
| Enumeration detection | VERIFIED|PARTIAL|MISSING|UNVERIFIED | … |

## Attack-chain analysis (adversarial lens only)
| ID | Objective and chain | Status | Detection / containment |
|---|---|---|---|
| AC-01 | basic user → forged orgId → unscoped export | CONFIRMED|PLAUSIBLE|BLOCKED|UNVERIFIED | … |

## Next 3 actions
1. …
2. …
3. …
```

## Chat summary (required)

```text
Verdict: FAIL|PASS|CONDITIONAL
CRITICAL: <count> — <titles>
HIGH: <count>
Next: <3 actions>
Report: <path or "chat only">
```

## Rules

- No finding without evidence
- One finding per root cause; multiple locations allowed
- After fix mode, update Status and add re-verification evidence
- Do not label the result a red-team engagement; call it adversarial review or attack-chain analysis
