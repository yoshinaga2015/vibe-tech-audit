# Checklist: mobile

`profile.mobile = true` のときだけ読む（Expo / RN / iOS / Android）。

| ID | ★ | 項目 | 確認 |
|---|---|---|---|
| M-01 | ★ | バイナリに秘密なし | EXPO_PUBLIC_ は公開前提。sk_/service_role がソースに無い |
| M-02 | ★ | トークン保管 | Keychain/Keystore。AsyncStorage 平文は HIGH 以上 |
| M-03 | ★ | Deep Link 認可 | `app://resource/他者id` で操作できない。パラメータをサーバで再検証 |
| M-04 | | ATS / cleartext | HTTP 許可の広すぎる例外が残っていない |
| M-05 | | OTA 署名 | EAS Update 等の署名検証が無効化されていない |
| M-06 | | WebView | 任意 URL、`javascript:`、未検証ブリッジ |
| M-07 | | exported コンポーネント | Android exported Activity から課金・ログイン起動 |
| M-08 | | 画面キャプチャ方針 | 決済・身分証画面の方針（無ければ LOW/MED） |
| M-09 | | IAP | payments チェックリストのレシート検証とセット |

ipa/apk がワークスペースに無ければソース上の確認とし、バイナリ展開は UNVERIFIED 手順にする。
