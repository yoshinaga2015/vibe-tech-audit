# Stack signals

リポジトリを見て `profile` を埋める。推測でフラグを立てすぎない。証拠ファイルを1つ以上挙げる。

## profile スキーマ

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

## 検出シグナル

| フラグ | シグナル例 |
|---|---|
| next | `next.config.*`, `app/`, `pages/`, `package.json` deps `next` |
| supabase | `@supabase/*`, `supabase/` migrations, `SERVICE_ROLE` |
| firebase | `firebase`, `firestore.rules`, `storage.rules` |
| prisma | `schema.prisma`, `@prisma/client` |
| stripe | `stripe`, `STRIPE_`, `webhook` + stripe |
| auth | `next-auth`, `clerk`, `supabase/auth`, `better-auth`, `lucia` |
| payments | stripe, paddle, lemon, revenuecat, iap, `checkout` |
| llm | `openai`, `@ai-sdk`, `anthropic`, `langchain`, `embeddings` |
| mobile | `expo`, `react-native`, `ios/`, `android/`, `app.json` |
| upload | `multer`, `uploadthing`, `presigned`, `storage.from` |
| multi_tenant | `orgId`, `tenantId`, `workspaceId` columns / middleware |

## 読み分け

- 常時: checklist-core, ai-antipatterns
- payments true → checklist-payments
- llm true → checklist-llm
- mobile true → checklist-mobile
- upload / multi_tenant は core 内の該当節を厚く見る

不明なスタックは `stack: [unknown]` とし、言語・フレームワーク中立の core 項だけで進める。
