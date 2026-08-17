#!/usr/bin/env bash
# Scan common vibe-coding antipatterns. Hits are CANDIDATES — verify before filing.
set -euo pipefail

ROOT="${1:-.}"
cd "$ROOT"

if command -v rg >/dev/null 2>&1; then
  RG=(rg -n --hidden --glob '!node_modules/**' --glob '!.git/**' --glob '!.next/**' --glob '!dist/**' --glob '!build/**' --glob '!coverage/**' --glob '!.turbo/**' --glob '!vendor/**' --glob '!Pods/**')
else
  echo "rg (ripgrep) not found; use Grep tool + references/grep-recipes.md" >&2
  exit 2
fi

section() {
  printf '\n=== %s ===\n' "$1"
}

section "SECRETS_AND_KEYS"
"${RG[@]}" -e 'service_role|sk_live_|sk_test_|sk-proj-|sk-ant-|ghp_|xox[baprs]-|BEGIN (RSA |OPENSSH )?PRIVATE KEY' \
  -e 'NEXT_PUBLIC_[A-Z0-9_]*(SECRET|PRIVATE|PASSWORD|TOKEN|SERVICE_ROLE)' \
  -e 'VITE_[A-Z0-9_]*(SECRET|PRIVATE|PASSWORD)' \
  -e 'EXPO_PUBLIC_[A-Z0-9_]*(SECRET|PRIVATE|PASSWORD|SERVICE)' \
  || true

section "DANGEROUS_APIS"
"${RG[@]}" -e 'dangerouslySetInnerHTML' \
  -e 'queryRawUnsafe|\$queryRawUnsafe|executeRawUnsafe' \
  -e 'child_process|\bexecSync\b|\bexec\(' \
  -e "origin:\\s*['\"]\\*['\"]|Access-Control-Allow-Origin['\"]?\\s*[:=]\\s*['\"]\\*" \
  -e 'allow (read|write).{0,40}if\s+true' \
  || true

section "AUTH_TODOS"
"${RG[@]}" -e 'TODO.*(auth|Auth)|FIXME.*(auth|Auth)' \
  -e 'auth disabled|skip auth|no auth' \
  || true

section "DATA_ACCESS_HINTS"
"${RG[@]}" -e 'where:\s*\{\s*id\s*:' \
  -e '"use server"' \
  || true

section "DONE"
echo "Candidates only. Read each hit before creating a finding."
