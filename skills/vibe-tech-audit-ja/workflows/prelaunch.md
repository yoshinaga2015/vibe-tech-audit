# Workflow: prelaunch

公開・実ユーザー前のフル技術監査ゲート。

## Entry

- モード = `prelaunch`
- SKILL.md の Phase 1（プロファイル）を完了している
- 表面フラグ（payments / llm / mobile）が付いている

## Phase P1 — 30分ゲート（先に落とす）

入口: profile 完了。  
行動: 次を**実際にコードまたはダッシュボード根拠で**確認する。1つでも CRITICAL 相当なら後続も続けるが、冒頭で警告する。

1. 他ユーザー id での読み書きがコード上ブロックされているか（IDOR）
2. 未認証で保護 API が呼べないか
3. バンドル／クライアントに秘密が無いか（スキャン結果を検証）
4. 本番エラーがスタックを返さない設定か
5. RLS / ストレージルールが「全開」でないか（Supabase/Firebase 使用時）
6. 課金・AI・OTP エンドポイントに上限の気配があるか

出口: ゲート結果（各 OK / FAIL / N/A）。

## Phase P2 — コア全項

入口: P1 完了。  
行動:

1. [checklist-core.md](../references/checklist-core.md) を上から適用する。各項は「確認手順」に従い、コード検索または設定読取で証拠を残す。
2. 実行環境が無く手動テストできない項は、`UNVERIFIED` とし、ユーザーがやる手順を1行書く。勝手に PASS にしない。
3. [ai-antipatterns.md](../references/ai-antipatterns.md) を全リポジトリ視点で見る。

出口: core + antipattern findings / UNVERIFIED 一覧。

## Phase P3 — 表面別

入口: P2 完了。  
行動: フラグが立っている参照だけ読む。

- payments → [checklist-payments.md](../references/checklist-payments.md)
- llm → [checklist-llm.md](../references/checklist-llm.md)
- mobile → [checklist-mobile.md](../references/checklist-mobile.md)

出口: 表面別 findings。

## Phase P4 — 攻撃者視点（短く）

入口: P3 完了。  
行動: 次のシナリオをそれぞれ1段落で書く。該当コードが無ければ N/A。

1. 認証済み一般ユーザーが他人のオブジェクト id を総当たりする
2. クライアント改変で価格・role・tenant を偽る
3. 公開バケットまたは anon key だけでデータを抜く
4. Webhook または cron を偽って履行する
5. XSS またはトークン盗難でセッションを奪う（トークンが localStorage の場合は特に）

既に finding になっているものは参照 id を貼る。新規があれば追加する。

出口: シナリオ表。

## Phase P5 — 判定と報告

入口: P4 完了。  
行動:

1. [report-template.md](../references/report-template.md) でフルレポートをファイルに書く。
2. **PASS**: CRITICAL=0 かつ HIGH=0。UNVERIFIED のみなら PASS にせず **CONDITIONAL**（未検証リスト付き）。
3. **FAIL**: CRITICAL≥1 または HIGH≥1。
4. チャット: 判定、CRITICAL 全文、HIGH 件数、次の3手。修正はしない。

出口: PASS / FAIL / CONDITIONAL とレポートファイル。

## Exit

- P1–P5 完了
- 全 finding に証拠または UNVERIFIED
- 判定が出ている
- 未依頼のコード変更なし
