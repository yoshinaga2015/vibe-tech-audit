# Workflow: adversarial-review

`feature` / `prelaunch` / 修正後の再検証に追加する、任意の攻撃者レンズ。
攻撃目標を置いて経路を証拠付きで追う。組織レッドチームの代替ではない。

## Entry

- 基本モードが `feature` / `prelaunch` / `fix` のいずれか
- Lens = `adversarial`
- 対象はユーザー所有、またはテスト許可が明示されている
- 生きた環境へリクエストする前に制約を書いている

実行対象・許可・制約が不明なら `static-only` のまま進める。
武器化した攻撃キットを作らず、対象データを外部送信しない。

## Phase A1 — 攻撃目標を定義

入口: profile 完了。  
行動:

1. 実際の資産から、最大3つの具体的な目標を選ぶ:
   - 他テナントの非公開データを読む
   - 管理者専用機能を得る
   - 正当な支払いなしで有料権限を得る
   - LLMに意図しないツール操作をさせる
   - 高コスト資源を枯渇させる
2. 攻撃者の初期権限（未認証、一般ユーザー、テナント管理者）を定義する。
3. 保護資産、信頼境界、禁止操作を定義する。

出口: 攻撃者・対象・入口・制約を持つ objective card。

## Phase A2 — 攻撃チェーンを追跡

入口: 目標確定。  
行動:

1. 入口 → 信頼境界 → 認可判断 → データ／操作 sink を追う。
2. 既存 finding が組み合わさって大きな被害になる経路を接続する。
3. 必要条件をすべて書き、根拠のない飛躍をしない。
4. 各チェーンを判定する:
   - `CONFIRMED`: 全段階を証拠で実証
   - `PLAUSIBLE`: 静的根拠はあるが実行検証なし
   - `BLOCKED`: 検証済み防御が停止
   - `UNVERIFIED`: 必要な証拠が取得不能

出口: 各段階に証拠を持つチェーン一覧。

## Phase A3 — 安全に検証

入口: PLAUSIBLE なチェーンが1件以上。  
行動:

1. 静的証拠と既存テストを優先する。
2. 実行する場合はテスト用アカウント／データと、最小の無害なリクエストを使う。
3. 本番データを対象にしない。アクセスを永続化しない。監視回避や外部持ち出しをしない。
4. リクエストまたはテストケース、安全な期待結果、観測結果を記録する。
5. 失敗した試行だけで脆弱性クラス不存在と断定せず、テスト範囲を書く。

出口: 非破壊で再現可能な証拠によりチェーン状態を更新。

## Phase A4 — 防御側で閉じる

入口: チェーン評価完了。  
行動:

1. [detection-response.md](../references/detection-response.md) を読む。
2. CONFIRMED / PLAUSIBLE ごとに次を評価:
   - prevention
   - detection
   - containment
   - recovery
3. 欠けた検知・対応を finding または UNVERIFIED として追加する。

出口: 各チェーンに悪用可能性と防御カバレッジの両方がある。

## Output

レポートの `Attack-chain analysis` を使う:

```text
AC-01: 一般ユーザー → orgId偽装 → 未スコープexport → テナント漏洩
Status: PLAUSIBLE
Evidence: api/export.ts:42; repositories/invoice.ts:18
Detection: テナント不一致拒否・export急増のアラートなし
Containment: export tokenだけを個別失効できない
```

## Exit

- 目標が具体的でスコープ内
- 全チェーン段階に証拠、または不足の明記
- 破壊・外部持ち出しなし
- prevention だけでなく detection / response も評価
