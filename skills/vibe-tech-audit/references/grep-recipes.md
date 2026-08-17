# Grep recipes

When `scripts/scan-antipatterns.sh` is unavailable, run equivalents with Grep.  
From repo root. Exclude `node_modules`, `.git`, `dist`, `build`, `.next`.

## Secrets / keys

- `service_role|sk_live_|sk_test_|sk-proj-|sk-ant-|ghp_|xox[baprs]-|BEGIN (RSA |OPENSSH )?PRIVATE KEY`
- `password\s*=\s*['\"][^'\"]+['\"]`
- `NEXT_PUBLIC_[A-Z0-9_]*(SECRET|PRIVATE|PASSWORD|TOKEN|SERVICE_ROLE)`
- `VITE_[A-Z0-9_]*(SECRET|PRIVATE|PASSWORD)`
- `EXPO_PUBLIC_[A-Z0-9_]*(SECRET|PRIVATE|PASSWORD|SERVICE)`

## Dangerous APIs

- `dangerouslySetInnerHTML`
- `queryRawUnsafe|\$queryRawUnsafe|executeRawUnsafe`
- `child_process|exec\(|execSync|spawn\(`
- `origin:\s*['\"]\*['\"]|Access-Control-Allow-Origin['\"]?\s*[:=]\s*['\"]\*`
- `allow (read|write).*if\s+true`

## Data access (must Read)

- `findUnique\(|findFirst\(|findMany\(|\.update\(|\.delete\(`
- `where:\s*\{\s*id\s*:`
- `"use server"`

## Auth

- `TODO.*(auth|Auth)|FIXME.*(auth|Auth)`
- `if\s*\(\s*session\s*\)` (possible inversion — Read context)
- `createClient\(|createServerClient\(`

Hits are candidates. Read before filing.
