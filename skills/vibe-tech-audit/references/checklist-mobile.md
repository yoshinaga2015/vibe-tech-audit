# Checklist: mobile

Read only when `profile.mobile = true` (Expo / RN / iOS / Android).

| ID | ★ | Check | Verify |
|---|---|---|---|
| M-01 | ★ | No secrets in binary/source | EXPO_PUBLIC_ is public; no sk_/service_role in app code |
| M-02 | ★ | Token storage | Keychain/Keystore; AsyncStorage plaintext = HIGH+ |
| M-03 | ★ | Deep Link authz | `app://resource/other-id` cannot act; re-validate server-side |
| M-04 | | ATS / cleartext | Over-broad HTTP exceptions |
| M-05 | | OTA signing | EAS Update (etc.) signature not disabled |
| M-06 | | WebView | Arbitrary URLs, `javascript:`, untrusted bridges |
| M-07 | | Exported components | Android exported activities launching pay/login |
| M-08 | | Screenshot policy | Pay/ID screens (else LOW/MED) |
| M-09 | | IAP | Pair with payments receipt verification |

If ipa/apk absent, verify from source and mark binary unpack as UNVERIFIED.
