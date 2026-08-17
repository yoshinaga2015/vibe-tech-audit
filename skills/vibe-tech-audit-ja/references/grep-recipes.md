# Grep recipes

`scripts/scan-antipatterns.sh` が使えないとき、Grep ツールで同等を実行する。  
リポジトリルート基準。`node_modules` / `.git` / `dist` / `build` / `.next` は除外。

## 秘密・危険パターン（1回で広く）

Patterns（複数回に分けてよい）:

- `service_role|sk_live_|sk_test_|sk-proj-|sk-ant-|ghp_|xox[baprs]-|BEGIN (RSA |OPENSSH )?PRIVATE KEY`
- `password\s*=\s*['\"][^'\"]+['\"]`
- `NEXT_PUBLIC_[A-Z0-9_]*(SECRET|PRIVATE|PASSWORD|TOKEN|SERVICE_ROLE)`
- `VITE_[A-Z0-9_]*(SECRET|PRIVATE|PASSWORD)`
- `EXPO_PUBLIC_[A-Z0-9_]*(SECRET|PRIVATE|PASSWORD|SERVICE)`

## コード危険API

- `dangerouslySetInnerHTML`
- `queryRawUnsafe|\$queryRawUnsafe|executeRawUnsafe`
- `child_process|exec\(|execSync|spawn\(`
- `origin:\s*['\"]\*['\"]|Access-Control-Allow-Origin['\"]?\s*[:=]\s*['\"]\*`
- `allow (read|write).*if\s+true`

## データアクセス（要 Read 精査）

- `findUnique\(|findFirst\(|findMany\(|\.update\(|\.delete\(`
- `where:\s*\{\s*id\s*:`
- `"use server"`

## 認証まわり

- `TODO.*(auth|Auth)|FIXME.*(auth|Auth)`
- `if\s*\(\s*session\s*\)`（反転疑い。前後を Read）
- `createClient\(|createServerClient\(`

ヒットは候補。Read して真陽性だけ finding にする。
