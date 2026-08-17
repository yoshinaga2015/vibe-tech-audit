---
name: vibe-tech-audit-ja
description: >-
  バイブコーディング／AI実装アプリを技術監査する。認可(IDOR)、秘密情報、XSS/注入、
  認証、決済、RLS、公開前ゲートをチェックリスト駆動で確認する。
  「技術監査」「公開前チェック」「セキュリティ監査」「IDOR」「バイブコーディング監査」
  「デプロイ前に見て」「攻撃者視点」「攻撃チェーン」「adversarial review」
  「prelaunch audit」「security audit」で使う。
  モード: 差分監査 / 公開前フル / 修正（明示時）。任意で攻撃チェーンを
  分析する adversarial lens を適用する。
  Skill自体のインストール安全性審査や、スタイルのみのレビューには使わない。
---

# Vibe Tech Audit（日本語）

バイブコーディング／AI実装アプリ向けの**技術監査**。チェックリスト駆動。証拠のない指摘は出さない。

本 Skill の `references/` はエージェント実行用。人間向けの長い説明はリポジトリの `docs/` を参照。

英語版 Skill 名: `vibe-tech-audit`（同梱）。

## Essential Principles

1. **認可が最優先** — 「ログインできる」≠「権限が正しい」。IDOR / テナント / RLS を最初に潰す。
2. **証拠必須** — finding には `file:line` の引用、または実行したコマンド結果が必要。無いなら出さない。
3. **監査と修正を分離** — デフォルトは報告のみ。コード変更はユーザーが明示したときだけ（`fix` モード）。
4. **全部を毎回読まない** — プロファイルで表面を切り、該当 `references/` だけ読む。
5. **デモ合格を合格にしない** — UI が動くこと、ハッピーパステスト通過は合否条件にしない。
6. **赤／青はモードではなくレンズ** — ライフサイクルのモードを維持し、攻撃者分析と防御検知を直交させる。

## When to Use

- 機能実装後の差分セキュリティ確認
- 本番・実ユーザー公開前のゲート
- 「このアプリ危なくない？」系の依頼
- 決済・LLM・アップロードを足した直後

## When NOT to Use

- Skill / MCP 自体のインストール安全性審査 → skill-auditor 系を使う
- スタイルや可読性だけのレビュー → 通常の code review
- 本番侵入テストの攻撃コード量産（ユーザーが明示し方針を書いたとき以外はしない）
- チェックリスト非駆動の汎用 PR セキュリティレビュー専用ツールの代替

## Mode Routing

発話からモードを決める。曖昧ならモードをでっち上げず、ユーザーに1回だけ確認する。

| シグナル | モード | 読むワークフロー |
|---|---|---|
| 差分、この変更、機能追加した、PR、今の実装 | `feature` | [workflows/feature-diff.md](workflows/feature-diff.md) |
| 公開前、デプロイ前、ローンチ、フル監査、本番前 | `prelaunch` | [workflows/prelaunch.md](workflows/prelaunch.md) |
| 直して、修正して、fix findings | `fix` | [workflows/fix-findings.md](workflows/fix-findings.md) |

`fix` は直前の監査 finding がある前提。無ければ先に `feature` または `prelaunch` を回す。

## Lens Routing

モードと独立して lens を決める:

| シグナル | Lens | 動作 |
|---|---|---|
| 通常の監査依頼 | `standard` | チェックリストと証拠レビュー |
| 攻撃者視点、攻撃チェーン、悪用経路、他テナントに届くか | `adversarial` | [workflows/adversarial-review.md](workflows/adversarial-review.md) も実行 |

adversarial は基本モードを置き換えない。例: `mode: prelaunch`,
`lens: adversarial`。実環境テストの許可またはスコープが曖昧なら
`runtime: static-only` とする。

## Shared Pipeline

```
Phase 0 モード確定
Phase 1 プロファイル（スタック・表面）
Phase 2 機械スキャン（scripts + grep）
Phase 3 認可・データ経路レビュー（最優先）
Phase 4 該当表面の深掘り（payments / llm / mobile）
Phase 5 任意のadversarial lens＋防御カバレッジ
Phase 6 レポート＋判定
```

### Phase 1 — プロファイル（入口）

入口: リポジトリルートが分かっている。  
行動:

1. ルートの設定・依存・ディレクトリをざっと把握する（package.json、app/、supabase/ 等）。
2. [references/stack-signals.md](references/stack-signals.md) でスタックと表面フラグを付ける。
3. 読む references を決める:

| フラグ | 追加で読む |
|---|---|
| 常時 | [checklist-core.md](references/checklist-core.md)、[ai-antipatterns.md](references/ai-antipatterns.md) |
| prelaunch または adversarial | [detection-response.md](references/detection-response.md) |
| payments | [checklist-payments.md](references/checklist-payments.md) |
| llm | [checklist-llm.md](references/checklist-llm.md) |
| mobile | [checklist-mobile.md](references/checklist-mobile.md) |

出口: `profile` がチャット内またはレポート冒頭に書ける。

### Phase 2 — 機械スキャン

入口: profile 完了。  
行動:

1. `{baseDir}/scripts/scan-antipatterns.sh` をリポジトリルートで実行（実行可なら）。不可なら [grep-recipes.md](references/grep-recipes.md) を Grep で同等実行。
2. ヒットは**候補**。ここだけでは finding にしない。
3. 各ヒットを Read で確認し、真陽性だけ Phase 3–4 の finding にする。

出口: 確認済み候補リスト。

### Phase 6 — レポート契約

[report-template.md](references/report-template.md) に従う。

- チャット: CRITICAL 全文、HIGH 件数、次の3手、`prelaunch` なら **PASS/FAIL/CONDITIONAL**
- ファイル: リポジトリ直下（または `docs/` / `Flow/` があればそこ）に `tech-audit-YYYY-MM-DD.md`
- Severity: CRITICAL / HIGH / MEDIUM / LOW
- `prelaunch` の FAIL 条件: CRITICAL または HIGH が1件以上

## Quick Reference — Severity

| Severity | 例 |
|---|---|
| CRITICAL | 他ユーザーデータ読み書き、service_role のクライアント露出、署名なし決済履行 |
| HIGH | XSS 保存、RLS 無効、認証ガード反転、秘密の git 履歴 |
| MEDIUM | レート制限欠如、過剰データ露出、ソースマップ本番公開 |
| LOW | ヘッダ不足、ログ冗長（秘密なし） |

## Reference Index

| ファイル | 用途 |
|---|---|
| [workflows/feature-diff.md](workflows/feature-diff.md) | 差分監査手順 |
| [workflows/prelaunch.md](workflows/prelaunch.md) | 公開前フル手順 |
| [workflows/fix-findings.md](workflows/fix-findings.md) | 修正モード |
| [workflows/adversarial-review.md](workflows/adversarial-review.md) | 任意の目標志向・攻撃者レンズ |
| [references/checklist-core.md](references/checklist-core.md) | 認可・認証・秘密・注入・CORS・性能・エラー等 |
| [references/checklist-payments.md](references/checklist-payments.md) | 決済・Webhook |
| [references/checklist-llm.md](references/checklist-llm.md) | LLM・エージェント |
| [references/checklist-mobile.md](references/checklist-mobile.md) | モバイル |
| [references/ai-antipatterns.md](references/ai-antipatterns.md) | AI実装の定番ミス |
| [references/detection-response.md](references/detection-response.md) | 検知・封じ込め・復旧 |
| [references/stack-signals.md](references/stack-signals.md) | スタック検出 |
| [references/grep-recipes.md](references/grep-recipes.md) | 検索レシピ |
| [references/report-template.md](references/report-template.md) | レポート形 |
| [scripts/scan-antipatterns.sh](scripts/scan-antipatterns.sh) | 一括スキャン |

## Success Criteria

- [ ] モードが明示されている
- [ ] lens と runtime が明示されている
- [ ] profile（表面フラグ）がある
- [ ] 全 finding に証拠がある
- [ ] 認可系をスキップしていない（該当コードがある場合）
- [ ] 勝手に大規模修正していない（fix 以外）
- [ ] prelaunch なら PASS/FAIL/CONDITIONAL を出している
- [ ] prelaunch なら行動可能な検知・対応も評価している
- [ ] チャット要約と、可能ならレポートファイルがある
