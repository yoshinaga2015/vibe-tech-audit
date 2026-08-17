# Detection and response checklist

Blue-team coverage for application attacks. Apply during every `prelaunch`
audit and during Phase A4 of the adversarial lens.

| ID | Priority | Control | Evidence |
|---|---|---|---|
| D-01 | HIGH | Detect rapid enumeration of object ids | Alert/query on one actor accessing many distinct ids or repeated 403/404 |
| D-02 | HIGH | Detect authorization failures on sensitive routes | Structured actor, tenant, route, action, result fields; alert threshold defined |
| D-03 | HIGH | Detect invalid webhook signatures and replay | Signature failures, stale timestamps, duplicate event ids counted and alerted |
| D-04 | HIGH | Detect API / LLM / SMS cost spikes | Per-user and global spend/usage thresholds with an actionable alert |
| D-05 | HIGH | Audit privileged actions | Immutable actor, target, before/after, timestamp, request/correlation id |
| D-06 | MEDIUM | Revoke sessions and credentials | Documented way to revoke one user, all sessions, API keys, webhook secrets |
| D-07 | MEDIUM | Contain abusive actors | Account/IP/tenant disable or quota reduction without redeploying |
| D-08 | MEDIUM | Preserve forensic context safely | Correlation ids and security events without passwords, tokens, or excess PII |
| D-09 | MEDIUM | Incident ownership and runbook | Named notification path and first-response steps for data leak/payment abuse |
| D-10 | MEDIUM | Recovery is tested | Backup restore, entitlement reconciliation, and event replay procedures exercised |

## Grading

- `VERIFIED`: concrete config, query, test, or alert rule exists
- `PARTIAL`: logs exist but no alert/owner/runbook makes them actionable
- `MISSING`: the event cannot be detected or contained
- `UNVERIFIED`: external platform evidence is required

Logging alone is not detection. A control is not VERIFIED unless it can cause a
timely human or automated response.

Do not require enterprise SIEM products. Small apps may satisfy controls with
provider alerts, structured logs, budget alarms, and a concise incident runbook.
