# Workflow: feature-diff

差分・機能追加直後の技術監査。全チェックリストは回さない。

## Entry

- モード = `feature`
- Lens = `standard` または `adversarial`
- 対象リポジトリが開いている
- SKILL.md の Phase 1（プロファイル）を完了している

## Phase F1 — 差分範囲

入口: profile 完了。  
行動:

1. `git status` / `git diff`（staged + unstaged）と、必要なら base ブランチとの diff を取る。
2. 変更ファイルを分類する: auth / data-access / API / UI入力 / payments / llm / config / unrelated。
3. unrelated（文言・スタイルのみ）だけなら、機械スキャンの危険ヒットがゼロなら「セキュリティ表面なし」と報告して終了してよい。

出口: 変更ファイル一覧と表面分類。

## Phase F2 — 毎回必須（★）

入口: セキュリティ表面がある、または機械スキャンに候補がある。  
行動: [checklist-core.md](../references/checklist-core.md) の **★ FEATURE** 項目だけを、**変更された経路**に適用する。最低限:

1. 新規・変更された `find*` / `update` / `delete` / SQL / Storage 読みに、セッション由来の owner / org 条件があるか。
2. 新規 API / Server Action / tRPC / Cloud Function に認証があるか。middleware のみに頼っていないか。
3. 秘密・`NEXT_PUBLIC_*SECRET*`・`service_role`・`dangerouslySetInnerHTML`・生 SQL が差分に入っていないか。
4. ユーザー入力の出力エンコード / スキーマ検証がサーバ側にあるか。

出口: ★ 関連の証拠付き finding または「差分上は ★ クリア」。

## Phase F3 — 差分に応じた追加

入口: F2 完了。  
行動:

| 差分に含まれるもの | 追加 |
|---|---|
| Stripe / 価格 / Webhook / IAP | [checklist-payments.md](../references/checklist-payments.md) の該当項 |
| LLM / agent / embeddings | [checklist-llm.md](../references/checklist-llm.md) |
| Expo / RN / モバイル | [checklist-mobile.md](../references/checklist-mobile.md) |
| アップロード | core のアップロード ★ |
| テナント / org | core のテナント項 |

[ai-antipatterns.md](../references/ai-antipatterns.md) は差分にデータアクセスがあれば必ず見る。

出口: 追加 finding。

## Phase F4 — 任意のadversarial lens

入口: F3 完了。
行動:

- `lens = adversarial` なら
  [adversarial-review.md](adversarial-review.md) を変更された攻撃経路に適用する。
- 目標は差分の blast radius に限定し、フルリポジトリまたは本格レッドチームを
  実施したように表現しない。
- `lens = standard` ならスキップする。

出口: 差分範囲の攻撃チェーンまたは N/A。

## Phase F5 — 報告

入口: レビュー完了。  
行動:

1. [report-template.md](../references/report-template.md) でレポートを書く（短くてよい）。
2. チャットに CRITICAL/HIGH と「公開前なら prelaunch を回せ」を出す。
3. **修正しない**。ユーザーが直してと言ったら `fix` モードへ。

出口: レポート提出。判定は PASS/FAIL 必須ではない（推奨: 残 CRITICAL/HIGH 数）。

## Exit

- 差分範囲が明確
- ★ を差分経路に適用済み
- 証拠付き finding のみ
- 未依頼のコード変更なし
