---
name: vibe-tech-audit
description: >-
  Audits vibe-coded / AI-assisted apps for authorization (IDOR), secrets,
  XSS/injection, auth flaws, payments, RLS, and pre-launch readiness.
  Use when the user asks for a security audit, prelaunch check, IDOR review,
  vibe coding audit, deploy readiness review, or review before shipping an
  AI-built app; also when they request an attacker perspective, adversarial
  review, or attack-chain analysis. Modes: feature-diff audit, full prelaunch gate, or fix
  findings when asked; optionally applies an adversarial attack-chain lens.
  Do not use for auditing whether an Agent Skill file
  itself is safe to install, or for style-only code review.
---

# Vibe Tech Audit

Checklist-driven **technical audit** for vibe-coded / AI-assisted apps. No finding without evidence.

Agent-oriented checklists live under `references/`. Optional human-readable docs may ship alongside this skill in the repo `docs/` folder.

## Essential Principles

1. **Authorization first** — “Logged in” ≠ “Allowed.” Kill IDOR / tenant leaks / missing RLS first.
2. **Evidence required** — Every finding needs a `file:line` quote or command output. Otherwise do not file it.
3. **Audit ≠ fix** — Default is report only. Change code only in `fix` mode when the user explicitly asks.
4. **Do not load everything** — Profile surfaces; read only matching `references/`.
5. **Demo success is not a pass** — Pretty UI and happy-path tests are not acceptance criteria.
6. **Red/blue is a lens, not a mode** — Keep lifecycle modes stable; adversarial analysis and defensive detection are orthogonal.

## When to Use

- Security check after a feature landing
- Gate before production / real users
- “Is this app dangerous?” style requests
- Right after adding payments, LLM, or uploads

## When NOT to Use

- Vetting whether a Skill/MCP install is safe → use a skill-supply-chain auditor
- Style / readability-only review → normal code review
- Mass-producing exploit PoCs against production (unless the user explicitly requests and scopes it)
- Generic PR security subagents that are not checklist/profile driven

## Mode Routing

Infer mode from the user message. If ambiguous, AskQuestion once.

| Signals | Mode | Workflow |
|---|---|---|
| diff, this change, feature, PR, current implementation | `feature` | [workflows/feature-diff.md](workflows/feature-diff.md) |
| prelaunch, before deploy, launch, full audit, production | `prelaunch` | [workflows/prelaunch.md](workflows/prelaunch.md) |
| fix, remediate, fix findings | `fix` | [workflows/fix-findings.md](workflows/fix-findings.md) |

`fix` requires prior findings. If none exist, run `feature` or `prelaunch` first.

## Lens Routing

Select a lens independently from the mode:

| Signals | Lens | Behavior |
|---|---|---|
| normal audit request | `standard` | Checklist and evidence review |
| attacker perspective, attack chain, abuse path, can another tenant… | `adversarial` | Also run [workflows/adversarial-review.md](workflows/adversarial-review.md) |

An adversarial request does not replace the base mode. Resolve both dimensions,
for example `mode: prelaunch`, `lens: adversarial`. If live testing scope or
authorization is unclear, use `runtime: static-only`.

## Shared Pipeline

```
Phase 0 Confirm mode
Phase 1 Profile (stack + surfaces)
Phase 2 Machine scan (scripts + grep)
Phase 3 Authorization / data-path review (priority)
Phase 4 Surface deep-dives (payments / llm / mobile)
Phase 5 Optional adversarial lens + defensive coverage
Phase 6 Report + verdict
```

### Phase 1 — Profile

Entry: repository root known.  
Actions:

1. Skim root config and layout (`package.json`, `app/`, `supabase/`, etc.).
2. Set flags via [references/stack-signals.md](references/stack-signals.md).
3. Choose references:

| Flag | Also read |
|---|---|
| always | [checklist-core.md](references/checklist-core.md), [ai-antipatterns.md](references/ai-antipatterns.md) |
| prelaunch or adversarial | [detection-response.md](references/detection-response.md) |
| payments | [checklist-payments.md](references/checklist-payments.md) |
| llm | [checklist-llm.md](references/checklist-llm.md) |
| mobile | [checklist-mobile.md](references/checklist-mobile.md) |

Exit: `profile` written in chat or report header.

### Phase 2 — Machine scan

Entry: profile done.  
Actions:

1. Run `{baseDir}/scripts/scan-antipatterns.sh` from repo root when possible; else apply [grep-recipes.md](references/grep-recipes.md) with Grep.
2. Hits are **candidates**, not findings.
3. Read each hit; promote true positives only.

Exit: verified candidate list.

### Phase 6 — Report contract

Follow [report-template.md](references/report-template.md).

- Chat: all CRITICAL, HIGH count, next 3 actions; for `prelaunch` emit **PASS/FAIL/CONDITIONAL**
- File: write `tech-audit-YYYY-MM-DD.md` at repo root (or `docs/` / `Flow/` if those folders exist)
- Severities: CRITICAL / HIGH / MEDIUM / LOW
- `prelaunch` FAIL if any CRITICAL or HIGH

## Severity cheat sheet

| Severity | Examples |
|---|---|
| CRITICAL | Cross-user read/write, `service_role` in client, unsigned payment fulfillment |
| HIGH | Stored XSS, RLS off, inverted auth guard, secrets in git history |
| MEDIUM | Missing rate limits, excess data exposure, production source maps |
| LOW | Missing headers, noisy non-secret logs |

## Reference Index

| File | Purpose |
|---|---|
| [workflows/feature-diff.md](workflows/feature-diff.md) | Diff audit |
| [workflows/prelaunch.md](workflows/prelaunch.md) | Full prelaunch gate |
| [workflows/fix-findings.md](workflows/fix-findings.md) | Fix mode |
| [workflows/adversarial-review.md](workflows/adversarial-review.md) | Optional goal-oriented attacker lens |
| [references/checklist-core.md](references/checklist-core.md) | Authz, authn, secrets, injection, CORS, perf, errors |
| [references/checklist-payments.md](references/checklist-payments.md) | Payments / webhooks |
| [references/checklist-llm.md](references/checklist-llm.md) | LLM / agents |
| [references/checklist-mobile.md](references/checklist-mobile.md) | Mobile |
| [references/ai-antipatterns.md](references/ai-antipatterns.md) | Common AI-codegen mistakes |
| [references/detection-response.md](references/detection-response.md) | Detection, containment, recovery controls |
| [references/stack-signals.md](references/stack-signals.md) | Stack detection |
| [references/grep-recipes.md](references/grep-recipes.md) | Search recipes |
| [references/report-template.md](references/report-template.md) | Report shape |
| [scripts/scan-antipatterns.sh](scripts/scan-antipatterns.sh) | Bulk scan |

## Success Criteria

- [ ] Mode stated
- [ ] Lens and runtime stated
- [ ] Profile (surface flags) present
- [ ] Every finding has evidence
- [ ] Authz not skipped when data paths exist
- [ ] No unsolicited large refactors (`fix` only when asked)
- [ ] `prelaunch` emits PASS/FAIL/CONDITIONAL
- [ ] `prelaunch` assesses actionable detection and response
- [ ] Chat summary plus report file when possible
