# Pre-launch checklist (human)

Companion to the **vibe-tech-audit** agent skill. Use this when reviewing by hand.  
★ = never skip. Tags: **feature** / **launch** / **payments** / **llm** / **mobile** / **ops**.

This is not a full ASVS dump. Run ★ on every feature that touches data or auth; run launch items before real users; add surface sections when relevant.

---

## 30-minute path

1. Swap another user’s resource id on GET/PATCH/DELETE
2. Call the same APIs logged out
3. Search bundle + git history for secrets
4. Confirm production errors hide stacks
5. Check RLS / storage rules / public buckets
6. Loop login/OTP/AI endpoints for unbounded cost

---

## 1. Authorization

- [ ] ★ **feature** Foreign ids cannot read/update/delete (IDOR)
- [ ] ★ **feature** Ownership checks use session user/org on the server
- [ ] ★ **feature** List APIs are not fetch-all + client filter
- [ ] ★ **launch** RLS / row rules enabled on every table (Supabase/Firebase)
- [ ] **feature** Admin endpoints reject normal-user tokens
- [ ] **feature** No mass assignment of `role` / `isAdmin`
- [ ] **feature** APIs do not over-expose sensitive fields (BOPLA)
- [ ] **feature** Handlers re-check auth (not middleware-only)
- [ ] **feature** Tenant comes from session, not client headers
- [ ] **feature** Cache/jobs/paths include tenant
- [ ] **feature** SSRF blocked on user-supplied URLs
- [ ] **feature** Open redirects blocked
- [ ] **launch** Storage buckets not world-readable

## 2. Authentication / session

- [ ] ★ **feature** Auth guards are not inverted
- [ ] ★ **feature** Reset/magic/invite tokens: unguessable, single-use, short-lived
- [ ] **launch** Cookies: HttpOnly + Secure + SameSite
- [ ] **launch** Logout invalidates server sessions/refresh tokens
- [ ] **feature** Rate limits on login/OTP/reset
- [ ] **feature** OAuth: state, PKCE, exact redirect_uri
- [ ] **feature** Re-auth before email/phone change

## 3. Secrets

- [ ] ★ **launch** No secrets in client JS / mobile binaries
- [ ] ★ **launch** No `.env` in git (including history) — rotate if ever committed
- [ ] **launch** No secrets under `NEXT_PUBLIC_` / `VITE_` / `EXPO_PUBLIC_`
- [ ] **launch** No secrets in source maps or open preview deploys

## 4. Injection / XSS

- [ ] ★ **feature** No unsanitized HTML (`dangerouslySetInnerHTML`, Markdown, SVG)
- [ ] ★ **feature** No string-concat SQL / unsafe raw queries
- [ ] ★ **feature** Server-side schema validation (not client-only)
- [ ] **feature** Block `javascript:` / `data:` user URLs
- [ ] **feature** No command injection / path traversal / Zip Slip
- [ ] **launch** CSP restricts `script-src`

## 5. CSRF / CORS / headers

- [ ] ★ **launch** Cross-origin state changes blocked; no `CORS *` + credentials
- [ ] **feature** No state-changing GET
- [ ] **launch** Clickjacking defenses; nosniff; HSTS

## 6. Business logic / money

- [ ] ★ **payments** Server recomputes price
- [ ] ★ **payments** Fulfillment via signed webhook or server lookup — not `?paid=true`
- [ ] ★ **payments** Webhook signature on raw body; idempotent event ids
- [ ] **payments** No checkout step skipping; coupon races handled; integer money units
- [ ] **payments** IAP receipts verified server-side
- [ ] **launch** SMS/OTP pumping bounded

## 7. Abuse / performance

- [ ] ★ **launch** Looping APIs does not unbounded-bill
- [ ] ★ **llm** Per-user/IP caps on model calls
- [ ] ★ **feature** No N+1 on lists; indexes on filter/sort columns
- [ ] **feature** Pagination; image resizing/CDN

## 8. Idempotency / races / webhooks

- [ ] ★ **feature** Double-submit does not double-create
- [ ] ★ **feature** Concurrent edits do not silently clobber (or warn)
- [ ] ★ **payments** Webhook retries are idempotent; replay bounded
- [ ] **feature** Jobs/cron are safe under at-least-once delivery

## 9. Uploads

- [ ] ★ **launch** Large files (e.g. 200MB) rejected without taking down the server
- [ ] **feature** Magic-byte type checks; no inline execution of uploads

## 10. Errors / logging / ops

- [ ] ★ **launch** Production responses hide stacks/SQL/env
- [ ] **launch** Consistent 403/404 policy; no secrets in logs; no fail-open auth
- [ ] **launch** Debug/Swagger/playground closed; cron/webhooks authenticated
- [ ] **ops** Dependency reality check (no slopsquatting); backups restore-tested

## 11. Crypto / privacy

- [ ] ★ **launch** Passwords hashed with modern KDFs
- [ ] **feature** Secrets not in URLs; analytics PII minimized
- [ ] **ops** Deletion/export policy defined

## 12. Mobile (when applicable)

- [ ] ★ **mobile** No secrets in ipa/apk; tokens in Keychain/Keystore
- [ ] ★ **mobile** Deep links re-authorized server-side
- [ ] **mobile** ATS/cleartext, OTA signing, WebView bridges, exported activities

## 13. LLM / agents (when applicable)

- [ ] ★ **llm** Prompt injection contained; no raw execution of model output
- [ ] ★ **llm** Least-privilege tools; human gate on destructive actions; usage caps
- [ ] **llm** No secrets in system prompts; RAG tenant isolation

## 14. AI antipatterns (always skim)

- [ ] ★ `where: { id }` only updates; middleware-only auth; fail-open catch
- [ ] ★ `service_role` on client; `dangerouslySetInnerHTML`; `queryRawUnsafe`; `origin: "*"`
- [ ] ★ `TODO: add auth`; RLS left off; hallucinated packages

```bash
rg -n "service_role|sk_live_|queryRawUnsafe|dangerouslySetInnerHTML|origin:\\s*[\"']\\*" --glob '!node_modules/**'
```

---

## Sources (methodology)

OWASP Top 10:2025, API Security Top 10:2023, ASVS 5.0 (structure only), WSTG, MASVS, LLM Top 10:2025, CWE Top 25, and recurring vibe-coding failure modes (missing RLS, client secrets, middleware-only auth).
