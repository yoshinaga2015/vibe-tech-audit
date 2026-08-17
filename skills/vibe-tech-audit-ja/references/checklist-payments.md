# Checklist: payments

`profile.payments = true` のときだけ読む。

| ID | ★ | 項目 | 確認 |
|---|---|---|---|
| P-01 | ★ | 価格はサーバ再計算 | リクエストの price/currency/割引を信じない。マスタから算出 |
| P-02 | ★ | 履行は Webhook またはサーバ照会 | `?paid=true` やクライアント購入フラグだけで権限付与しない |
| P-03 | ★ | Webhook 署名を生ボディで検証 | 改ざん・署名なしが 401。再シリアライズ後検証は不合格 |
| P-04 | ★ | event id で冪等 | 同一イベント再送で二重付与しない。unique 制約または原子的 claim |
| P-05 | | リプレイ耐性 | timestamp 窓 + event id |
| P-06 | | フロー飛ばし | 確認ステップを飛ばして履行 API を直接呼べない |
| P-07 | | クーポン競合 | 同時適用で回数・在庫が破綻しない |
| P-08 | | 金額は整数最小単位 | 浮動小数の丸め依存を避ける |
| P-09 | | 解約・期限切れで権限落ち | Webhook 遅延中の使い放題を疑う |
| P-10 | | IAP レシートサーバ検証 | Store 検証なしのクライアント完了フラグは CRITICAL |
| P-11 | | idempotency key | 二重タップ・戻るで二重課金しない |
| P-12 | | イベント逆順 | failed が succeeded より先でも収束する |

報告時: Stripe/Lemon/PayPal 等のどのプロバイダかを profile に書く。
