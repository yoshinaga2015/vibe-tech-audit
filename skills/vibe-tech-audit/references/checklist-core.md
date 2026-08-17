# Checklist: core

Agent-oriented. Columns: ID, ★, when, check, how.  
`FEATURE` = also on diffs / `LAUNCH` = required before ship.

Pass only if the verification step is satisfied. If blocked, mark UNVERIFIED with a procedure. Never invent PASS.

---

## AUTHZ

| ID | ★ | When | Check | Verify |
|---|---|---|---|---|
| C-AUTHZ-01 | ★ | FEATURE | No cross-user GET/PATCH/DELETE by id | Data access scoped by session user/org. Flag `where: { id }` alone |
| C-AUTHZ-02 | ★ | FEATURE | Ownership enforced server-side | Do not trust client `userId`. UI hiding ≠ control |
| C-AUTHZ-03 | ★ | FEATURE | Lists are not fetch-all + client filter | Query/API already owner-scoped |
| C-AUTHZ-04 | ★ | LAUNCH | RLS / row rules on | Supabase/Firebase: every table. `if true` / RLS off = CRITICAL |
| C-AUTHZ-05 | | FEATURE | Admin APIs blocked for normal users | `/admin` `/internal` `/debug`, method swap |
| C-AUTHZ-06 | | FEATURE | No mass assignment | Body `role`/`isAdmin` cannot escalate |
| C-AUTHZ-07 | | FEATURE | BOPLA | No hashes, cost fields, others’ PII in JSON |
| C-AUTHZ-08 | | FEATURE | Auth in handlers too | Not middleware-only (re-check in Server Actions / routes) |
| C-AUTHZ-09 | | FEATURE | Tenant from session | Do not trust `X-Tenant-Id` / query org |
| C-AUTHZ-10 | | FEATURE | Tenant on cache/jobs/paths | Keys not just `resource:id` |
| C-AUTHZ-11 | | FEATURE | SSRF | User URLs cannot hit internal IP / metadata |
| C-AUTHZ-12 | | FEATURE | Open redirect | `next`/`redirect`/`redirect_uri` stay on allowlist |
| C-AUTHZ-13 | | LAUNCH | Storage buckets | Unsigned URLs cannot read others’ files |

---

## AUTHN

| ID | ★ | When | Check | Verify |
|---|---|---|---|---|
| C-AUTHN-01 | ★ | FEATURE | Auth guard not inverted | Unauthed cannot open protected surfaces; watch `if (session)` mistakes |
| C-AUTHN-02 | ★ | FEATURE | Reset / magic / invite tokens | Unguessable, single-use, short-lived; reissue invalidates old |
| C-AUTHN-03 | | LAUNCH | Cookie flags | HttpOnly + Secure + SameSite. localStorage tokens ⇒ XSS is CRITICAL-class |
| C-AUTHN-04 | | LAUNCH | Logout invalidates server-side | Refresh/session die on logout |
| C-AUTHN-05 | | FEATURE | Rate limits | login/OTP/reset limited in code or platform |
| C-AUTHN-06 | | FEATURE | OAuth | state / PKCE / exact redirect_uri |
| C-AUTHN-07 | | FEATURE | Re-auth before email change | Session-only email change must not enable takeover |

---

## SECRETS

| ID | ★ | When | Check | Verify |
|---|---|---|---|---|
| C-SEC-01 | ★ | FEATURE | No secrets in client | No service_role / sk_live / DB URL on client paths |
| C-SEC-02 | ★ | LAUNCH | No .env in git | gitignore + history. Hits ⇒ rotate |
| C-SEC-03 | | LAUNCH | No secrets in PUBLIC_ vars | NEXT_PUBLIC_/VITE_/EXPO_PUBLIC_ misuse |
| C-SEC-04 | | LAUNCH | Source maps / previews | Prod client maps; unauthed preview leaking secrets |

---

## INJECT / XSS

| ID | ★ | When | Check | Verify |
|---|---|---|---|---|
| C-XSS-01 | ★ | FEATURE | No raw HTML injection | dangerouslySetInnerHTML / unsanitized Markdown / SVG |
| C-XSS-02 | ★ | FEATURE | No SQL string concat | queryRawUnsafe, template SQL, user-controlled column names |
| C-XSS-03 | ★ | FEATURE | Server-side validation | Zod (etc.). Client-only = fail |
| C-XSS-04 | | FEATURE | javascript:/data: URLs | User links / images |
| C-XSS-05 | | FEATURE | Command injection | exec/spawn with user input |
| C-XSS-06 | | FEATURE | Path traversal | `../`, Zip Slip |
| C-XSS-07 | | LAUNCH | CSP | Restricted script-src (else MEDIUM+) |

---

## CSRF / CORS / HEADERS

| ID | ★ | When | Check | Verify |
|---|---|---|---|---|
| C-CSRF-01 | ★ | LAUNCH | Cross-origin state change blocked | Cookie auth: SameSite/Origin. No CORS `*` + credentials |
| C-CSRF-02 | | FEATURE | No state-changing GET | Deletes/billing not GET-only |
| C-CSRF-03 | | LAUNCH | Clickjacking | frame-ancestors / X-Frame-Options |
| C-CSRF-04 | | LAUNCH | nosniff / HSTS | Production headers |

---

## ABUSE / PERF

| ID | ★ | When | Check | Verify |
|---|---|---|---|---|
| C-ABUSE-01 | ★ | LAUNCH | Looped APIs do not unbounded-bill | Rate limits / cost caps |
| C-PERF-01 | ★ | FEATURE | No N+1 | Suspicious per-row queries in list paths |
| C-PERF-02 | ★ | FEATURE | Indexes | Filter/sort columns indexed |
| C-PERF-03 | | FEATURE | Pagination | No unbounded list APIs |
| C-IDEM-01 | ★ | FEATURE | Double submit | Create paths have idempotency / unique constraints |
| C-IDEM-02 | | FEATURE | Concurrent edits | version / updatedAt optimistic locking |

---

## UPLOAD

| ID | ★ | When | Check | Verify |
|---|---|---|---|---|
| C-UP-01 | ★ | LAUNCH | Size limits | Proxy + app; large files do not crash |
| C-UP-02 | | FEATURE | Magic-byte checks | Do not trust claimed MIME alone |
| C-UP-03 | | FEATURE | No inline execution | attachment / re-encode / separate domain |

---

## ERRORS / OPS

| ID | ★ | When | Check | Verify |
|---|---|---|---|---|
| C-ERR-01 | ★ | LAUNCH | No prod stacks | Error handler, NODE_ENV, debug flags |
| C-ERR-02 | | LAUNCH | Existence leak policy | Consistent 403/404 for foreign ids |
| C-ERR-03 | | LAUNCH | No secrets in logs | No Authorization / password / OTP dumps |
| C-ERR-04 | | LAUNCH | No fail-open | catch must not skip auth |
| C-OPS-01 | | LAUNCH | Debug surfaces closed | swagger / playground / /api/debug |
| C-OPS-02 | | LAUNCH | Slopsquatting | Verify new deps exist on registry |
| C-OPS-03 | | LAUNCH | Cron/webhook auth | Shared secret or signature verify |
| C-OPS-04 | | LAUNCH | Backups | Config present or UNVERIFIED + steps |

---

## CRYPTO / PRIVACY

| ID | ★ | When | Check | Verify |
|---|---|---|---|---|
| C-CRYPTO-01 | ★ | LAUNCH | Password hashing | bcrypt/argon2 etc. Not plaintext / reversible / raw SHA |
| C-PRIV-01 | | FEATURE | Secrets not in URLs | Reset-token handling |
| C-PRIV-02 | | LAUNCH | Analytics PII | Over-collection in SDK calls |
