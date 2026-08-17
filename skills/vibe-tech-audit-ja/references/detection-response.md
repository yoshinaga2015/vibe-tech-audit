# 検知・対応チェックリスト

アプリ攻撃に対するブルー側のカバレッジ。`prelaunch` では毎回、
adversarial lens では Phase A4 で適用する。

| ID | 優先 | コントロール | 証拠 |
|---|---|---|---|
| D-01 | HIGH | オブジェクトidの高速列挙を検知 | 1 actorの多数idアクセス、403/404連発を検知するクエリ／アラート |
| D-02 | HIGH | 機微ルートの認可失敗を検知 | actor、tenant、route、action、result の構造化ログと閾値 |
| D-03 | HIGH | Webhook署名失敗・リプレイを検知 | 署名失敗、期限切れ時刻、重複event idを集計・通知 |
| D-04 | HIGH | API / LLM / SMS のコスト急増を検知 | ユーザー別・全体の利用／費用閾値と対応可能な通知 |
| D-05 | HIGH | 特権操作の監査ログ | 改ざん困難な actor、target、before/after、時刻、correlation id |
| D-06 | MEDIUM | セッション・認証情報を失効 | 1ユーザー／全セッション／API鍵／Webhook secret の失効手順 |
| D-07 | MEDIUM | 悪用主体を封じ込め | 再デプロイなしでアカウント・IP・テナント停止またはquota低減 |
| D-08 | MEDIUM | 安全なフォレンジック情報 | correlation idとsecurity event。パスワード・token・過剰PIIなし |
| D-09 | MEDIUM | インシデント責任者とrunbook | データ漏洩・決済悪用の通知先と初動手順 |
| D-10 | MEDIUM | 復旧をテスト | backup restore、権限整合、event replay の訓練実績 |

## 判定

- `VERIFIED`: 具体的な設定、クエリ、テスト、アラートルールがある
- `PARTIAL`: ログはあるが、アラート・担当・手順がなく行動につながらない
- `MISSING`: 検知または封じ込めができない
- `UNVERIFIED`: 外部プラットフォーム上の証拠が必要

ログがあるだけでは検知ではない。適時に人または自動処理を動かせなければ
VERIFIED にしない。

企業向けSIEMを必須にしない。小規模アプリはプロバイダ通知、構造化ログ、
予算アラーム、短いrunbookで満たしてよい。
