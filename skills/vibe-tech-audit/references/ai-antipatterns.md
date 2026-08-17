# AI implementation antipatterns

Patterns AI codegen repeats. Required whenever data access changed.

| ID | Typical severity | Pattern | How to find |
|---|---|---|---|
| A-01 | CRITICAL | `where: { id }` only on update/delete | Grep ORM calls; Read for missing owner/org |
| A-02 | CRITICAL | Middleware/layout redirect as sole authz | Routes/actions lack session checks |
| A-03 | CRITICAL | `catch { return next() }` / fail-open | catch returning true/next/200 |
| A-04 | CRITICAL | `service_role` / admin SDK on client | Hits under client dirs |
| A-05 | HIGH | `TODO: add auth` / commented guards | TODO, commented auth |
| A-06 | HIGH | `cors({ origin: "*" })` + credentials | cors / ACAO |
| A-07 | HIGH | `dangerouslySetInnerHTML` + user HTML | React/Vue raw HTML |
| A-08 | HIGH | `queryRawUnsafe` / string SQL | raw SQL APIs |
| A-09 | HIGH | RLS off / Firebase `if true` | migrations, rules |
| A-10 | HIGH | New Server Action without auth copy | New `"use server"` vs older actions |
| A-11 | MEDIUM | seed admin/admin on prod path | seeds, demo credentials |
| A-12 | HIGH | Agent/CI with prod write keys | env names, deploy config |
| A-13 | HIGH | Hallucinated packages | Verify suspicious package.json names |
| A-14 | MEDIUM | Client-only `role === "admin"` | Client vs server mismatch |
| A-15 | MEDIUM | Happy-path-only tests | Missing foreign-id / unauth / double-submit tests |

File only true positives. Document intentional exceptions in one line.
