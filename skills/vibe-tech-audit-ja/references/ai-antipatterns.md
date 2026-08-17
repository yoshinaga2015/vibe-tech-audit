# AI implementation antipatterns

生成コードが繰り返す型。データアクセス変更がある監査では必読。

| ID | Severity目安 | パターン | 探し方 |
|---|---|---|---|
| A-01 | CRITICAL | `where: { id }` だけで update/delete | ORM 呼び出しを Grepし owner/org 欠落を Read |
| A-02 | CRITICAL | middleware / レイアウトリダイレクトだけが認可 | route/action 内に session 検証が無い |
| A-03 | CRITICAL | `catch { return next() }` / 認可失敗で通す | catch で true・next・200 を返す箇所 |
| A-04 | CRITICAL | `service_role` / admin SDK がクライアント | クライアントディレクトリ配下のヒット |
| A-05 | HIGH | `TODO: add auth` / コメントアウトしたガード | TODO、コメントアウト auth |
| A-06 | HIGH | `cors({ origin: "*" })` + credentials | cors / Access-Control-Allow-Origin |
| A-07 | HIGH | `dangerouslySetInnerHTML` + ユーザーHTML | React/Vue 生HTML |
| A-08 | HIGH | `queryRawUnsafe` / 文字列 SQL | raw SQL API |
| A-09 | HIGH | RLS 無効のまま / Firebase `if true` | migrations、rules ファイル |
| A-10 | HIGH | Server Action 増設時に認可コピー漏れ | 新規 `"use server"` / actions と旧実装比較 |
| A-11 | MEDIUM | seed の admin/admin が本番経路 | seed、demo credentials |
| A-12 | HIGH | エージェント/CI に本番書き込み鍵 | 環境変数名、deploy 設定 |
| A-13 | HIGH | 幻覚パッケージ | package.json の怪し名をレジストリで実在確認 |
| A-14 | MEDIUM | フロントだけの `role === "admin"` | クライアント条件とサーバ条件の不一致 |
| A-15 | MEDIUM | ハッピーパスだけのテスト | 他人id・未ログイン・二重送信テストの有無 |

真陽性だけ finding にする。フレームワークの正当な用法（例: 公開ページの意図的な生HTMLで静的のみ）は除外し、理由をレポートに1行書く。
