# Checklist: core

エージェント用。各項は ID・いつ・確認。★ はスキップ禁止。  
`FEATURE` = 差分でも見る / `LAUNCH` = 公開前必須。

合否: 確認手順を満たせば OK。実行不能なら UNVERIFIED（手順を残す）。推測 PASS 禁止。

---

## AUTHZ — 認可

| ID | ★ | いつ | 項目 | 確認 |
|---|---|---|---|---|
| C-AUTHZ-01 | ★ | FEATURE | 他人の id で GET/PATCH/DELETE できない | データアクセスが session の user/org で絞り込まれている。`where: { id }` のみを疑う |
| C-AUTHZ-02 | ★ | FEATURE | 所有判定がサーバ側 | クライアント `userId` を信頼していない。UI 非表示だけ不合格 |
| C-AUTHZ-03 | ★ | FEATURE | 一覧が全件+フロントフィルタでない | クエリまたは API が最初から所有者スコープ |
| C-AUTHZ-04 | ★ | LAUNCH | RLS / 行セキュリティ有効 | Supabase/Firebase: 全テーブル RLS/rules。off や `allow … if true` は CRITICAL |
| C-AUTHZ-05 | | FEATURE | 管理 API を一般ユーザーが呼べない | `/admin` `/internal` `/debug`、メソッド差し替え |
| C-AUTHZ-06 | | FEATURE | mass assignment | body の `role`/`isAdmin` で昇格できない |
| C-AUTHZ-07 | | FEATURE | BOPLA | レスポンスに hash・原価・他者PIIが乗っていない |
| C-AUTHZ-08 | | FEATURE | ハンドラ側でも認証 | middleware のみ依存しない（Server Action / route 内再検証） |
| C-AUTHZ-09 | | FEATURE | テナントはセッション由来 | `X-Tenant-Id` やクエリ org を信じない |
| C-AUTHZ-10 | | FEATURE | キャッシュ/ジョブ/パスにテナント | キーが `resource:id` のみでない |
| C-AUTHZ-11 | | FEATURE | SSRF | ユーザー URL 取得に内部 IP / metadata を拒否 |
| C-AUTHZ-12 | | FEATURE | オープンリダイレクト | `next`/`redirect`/`redirect_uri` が外部へ飛ばない |
| C-AUTHZ-13 | | LAUNCH | ストレージバケット | 署名なしで他者ファイルが取れない |

---

## AUTHN — 認証・セッション

| ID | ★ | いつ | 項目 | 確認 |
|---|---|---|---|---|
| C-AUTHN-01 | ★ | FEATURE | ガード真偽反転なし | 未ログインで保護面が開ける／`if (session)` 誤用を疑う |
| C-AUTHN-02 | ★ | FEATURE | リセット等トークン | 推測不能・単回・短寿命。再発行で旧無効 |
| C-AUTHN-03 | | LAUNCH | Cookie 属性 | HttpOnly + Secure + SameSite。localStorage トークンなら XSS=CRITICAL 前提 |
| C-AUTHN-04 | | LAUNCH | ログアウト無効化 | refresh/session がサーバで死ぬ |
| C-AUTHN-05 | | FEATURE | レート制限 | login/OTP/reset に制限の実装または基盤設定 |
| C-AUTHN-06 | | FEATURE | OAuth | state/PKCE/redirect_uri 完全一致 |
| C-AUTHN-07 | | FEATURE | メール変更前の再認証 | セッションだけでメアド変更→乗っ取りできない |

---

## SECRETS

| ID | ★ | いつ | 項目 | 確認 |
|---|---|---|---|---|
| C-SEC-01 | ★ | FEATURE | クライアントに秘密なし | service_role / sk_live / DB URL がクライアントバンドル経路に無い |
| C-SEC-02 | ★ | LAUNCH | git に .env なし | gitignore + 履歴。ヒットしたらローテ指示 |
| C-SEC-03 | | LAUNCH | PUBLIC_ に秘密を載せない | NEXT_PUBLIC_/VITE_/EXPO_PUBLIC_ の SECRET/KEY 誤用 |
| C-SEC-04 | | LAUNCH | ソースマップ/プレビュー | 本番クライアント map、無認証プレビューの秘密露出 |

---

## INJECT / XSS

| ID | ★ | いつ | 項目 | 確認 |
|---|---|---|---|---|
| C-XSS-01 | ★ | FEATURE | HTML 生挿入なし | dangerouslySetInnerHTML / 未サニタイズ Markdown / SVG |
| C-XSS-02 | ★ | FEATURE | SQL 結合なし | queryRawUnsafe、文字列連結 SQL、ユーザー入力カラム名 |
| C-XSS-03 | ★ | FEATURE | サーババリデーション | Zod 等。フロントのみは不合格 |
| C-XSS-04 | | FEATURE | javascript:/data: URL | ユーザーリンク・画像 |
| C-XSS-05 | | FEATURE | コマンド注入 | exec/spawn にユーザー入力 |
| C-XSS-06 | | FEATURE | パストラバーサル | `../`、Zip Slip |
| C-XSS-07 | | LAUNCH | CSP | script-src 制限の有無（無ければ MEDIUM 以上） |

---

## CSRF / CORS / HEADERS

| ID | ★ | いつ | 項目 | 確認 |
|---|---|---|---|---|
| C-CSRF-01 | ★ | LAUNCH | 他オリジン状態変更 | Cookie 認証時 SameSite/Origin。CORS * + credentials 禁止 |
| C-CSRF-02 | | FEATURE | 状態変更 GET 禁止 | 削除・課金が GET だけにならない |
| C-CSRF-03 | | LAUNCH | クリックジャッキング | frame-ancestors / X-Frame-Options |
| C-CSRF-04 | | LAUNCH | nosniff / HSTS | 本番ヘッダ |

---

## ABUSE / PERF

| ID | ★ | いつ | 項目 | 確認 |
|---|---|---|---|---|
| C-ABUSE-01 | ★ | LAUNCH | API 連打で青天井にならない | レート制限・コスト上限の実装 |
| C-PERF-01 | ★ | FEATURE | N+1 | 一覧経路のクエリ回数をコードから推定、疑わしいループを指摘 |
| C-PERF-02 | ★ | FEATURE | インデックス | フィルタ/ソート列に index 定義があるか |
| C-PERF-03 | | FEATURE | ページネーション | 全件取得 API が無いか |
| C-IDEM-01 | ★ | FEATURE | 二重送信 | 作成系に idempotency / unique 制約の気配 |
| C-IDEM-02 | | FEATURE | 同時編集 | version / updatedAt 楽観ロック等 |

---

## UPLOAD

| ID | ★ | いつ | 項目 | 確認 |
|---|---|---|---|---|
| C-UP-01 | ★ | LAUNCH | サイズ上限 | プロキシ＋アプリ。巨大ファイルで落ちない設計 |
| C-UP-02 | | FEATURE | 実バイト検証 | MIME 自称だけ信用しない |
| C-UP-03 | | FEATURE | インライン実行させない | attachment / 再エンコード / 別ドメイン |

---

## ERRORS / OPS

| ID | ★ | いつ | 項目 | 確認 |
|---|---|---|---|---|
| C-ERR-01 | ★ | LAUNCH | 本番スタック非表示 | エラーハンドラ、NODE_ENV、debug フラグ |
| C-ERR-02 | | LAUNCH | 存在漏洩方針 | 他人 id の 403/404 が一貫 |
| C-ERR-03 | | LAUNCH | ログに秘密なし | Authorization / password / OTP を dump しない |
| C-ERR-04 | | LAUNCH | fail-open なし | catch で認証スキップしない |
| C-OPS-01 | | LAUNCH | debug 面が閉じている | swagger / playground / /api/debug |
| C-OPS-02 | | LAUNCH | slopsquatting | 新規依存の実在確認（怪しい名前を列挙） |
| C-OPS-03 | | LAUNCH | cron/webhook 署名 | 秘密ヘッダまたは署名検証 |
| C-OPS-04 | | LAUNCH | バックアップ言及 | 設定の有無。無ければ UNVERIFIED+手順 |

---

## CRYPTO / PRIVACY（要約）

| ID | ★ | いつ | 項目 | 確認 |
|---|---|---|---|---|
| C-CRYPTO-01 | ★ | LAUNCH | パスワードハッシュ | bcrypt/argon2 等。平文・可逆・生SHA不可 |
| C-PRIV-01 | | FEATURE | 秘密を URL に載せない | トークン付きリセットの扱い |
| C-PRIV-02 | | LAUNCH | 解析 SDK の PII | 過度な送信が無いかコード上確認 |
