# Stack signals

Fill `profile` from the repo. Do not over-flag. Cite ≥1 evidence path per flag.

## Profile schema

```yaml
stack: []          # e.g. next, express, supabase, firebase, prisma, drizzle, stripe, expo
surfaces:
  auth: false
  payments: false
  llm: false
  mobile: false
  upload: false
  multi_tenant: false
evidence: []       # paths that justified flags
```

## Detection signals

| Flag | Example signals |
|---|---|
| next | `next.config.*`, `app/`, `pages/`, dep `next` |
| supabase | `@supabase/*`, `supabase/` migrations, `SERVICE_ROLE` |
| firebase | `firebase`, `firestore.rules`, `storage.rules` |
| prisma | `schema.prisma`, `@prisma/client` |
| stripe | `stripe`, `STRIPE_`, stripe webhooks |
| auth | `next-auth`, `clerk`, `supabase/auth`, `better-auth`, `lucia` |
| payments | stripe, paddle, lemon, revenuecat, iap, `checkout` |
| llm | `openai`, `@ai-sdk`, `anthropic`, `langchain`, `embeddings` |
| mobile | `expo`, `react-native`, `ios/`, `android/`, `app.json` |
| upload | `multer`, `uploadthing`, `presigned`, `storage.from` |
| multi_tenant | `orgId`, `tenantId`, `workspaceId` |

## Loading rules

- always: checklist-core, ai-antipatterns
- payments true → checklist-payments
- llm true → checklist-llm
- mobile true → checklist-mobile
- upload / multi_tenant → thicken matching core sections

Unknown stack → `stack: [unknown]` and run language-neutral core checks only.
