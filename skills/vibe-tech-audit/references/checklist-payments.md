# Checklist: payments

Read only when `profile.payments = true`.

| ID | ★ | Check | Verify |
|---|---|---|---|
| P-01 | ★ | Server recomputes price | Never trust client price/currency/discount |
| P-02 | ★ | Fulfill via webhook or server lookup | Not `?paid=true` / client purchase flags alone |
| P-03 | ★ | Verify webhook on raw body | Unsigned/tampered → 401. Re-serialized verify = fail |
| P-04 | ★ | Idempotent on event id | Retries must not double-grant (unique/atomic claim) |
| P-05 | | Replay resistance | timestamp window + event id |
| P-06 | | No flow skip | Cannot hit fulfill API without prior steps |
| P-07 | | Coupon races | Concurrent apply cannot break limits |
| P-08 | | Integer minor units | Avoid float money |
| P-09 | | Entitlement drops on cancel/expiry | No unlimited use during webhook lag |
| P-10 | | IAP receipt verified server-side | Client-only completion = CRITICAL |
| P-11 | | Idempotency keys | Double-tap / back button |
| P-12 | | Out-of-order events | failed before succeeded still converges |

Note provider (Stripe, etc.) in the profile.
