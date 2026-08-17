<p align="right">
  <a href="./README.md"><img src="https://img.shields.io/badge/EN-1e293b?style=for-the-badge&labelColor=0f172a" alt="English" /></a>
  <a href="./README.ja.md"><img src="https://img.shields.io/badge/JP-0ea5e9?style=for-the-badge&labelColor=0f172a" alt="日本語" /></a>
</p>

<div align="center">

# vibe-tech-audit

**バイブコーディング向け・チェックリスト駆動の技術監査**

<br />

[![License: MIT](https://img.shields.io/badge/License-MIT-0f172a?style=flat-square&labelColor=0ea5e9&color=0f172a)](LICENSE)

<br />

[インストール](#インストール)
·
[モード](#モード)
·
[Adversarial lens](#任意の-adversarial-lens)
·
[動き方](#動き方)
·
[JA チェックリスト](docs/prelaunch-checklist.ja.md)
·
[EN チェックリスト](docs/prelaunch-checklist.en.md)

</div>

---

デモで動くことと、公開して安全なことは別です。チャットで通った実装に対し、次の失敗を本番前に洗い出します。

`IDOR` · `秘密情報の露出` · `RLS未設定` · `認証ガードの真偽反転` · `XSS` · `署名なし Webhook` · `AI/API 課金の青天井`

| パッケージ | 言語 | Skill 名 |
|---|---|---|
| [`skills/vibe-tech-audit`](skills/vibe-tech-audit) | English | `vibe-tech-audit` |
| [`skills/vibe-tech-audit-ja`](skills/vibe-tech-audit-ja) | 日本語 | `vibe-tech-audit-ja` |

> デフォルトは報告のみです。finding には `file:line` かコマンド出力が必要で、証拠のない PASS は出しません。コードを直すのは **fix** モードを明示したときだけです。

---

## モード

| モード | いつ | 動作 |
|:---|:---|:---|
| **feature** | 機能追加・差分のあと | 差分範囲＋毎回の ★ |
| **prelaunch** | 実ユーザー・本番の前 | 該当チェック全項 → **PASS / FAIL / CONDITIONAL** |
| **fix** | 「直して」と明示したとき | 指定 finding の最小修正と再検証 |

```text
feature   →  差分を安全に出す
prelaunch →  公開の合否を出す
fix       →  指定 finding を閉じる（明示時のみ）
```

---

## 任意の adversarial lens

`feature`、`prelaunch`、修正後の再検証には `lens: adversarial` を付けられます。攻撃目標を置いて、信頼境界をまたぐ経路を証拠付きで追います。組織レッドチームの代替ではありません。

| 観点 | 内容 |
|:---|:---|
| 目標 | 攻撃目標と初期権限 |
| チェーン | 信頼境界をまたぐ証拠付き経路 |
| 判定 | `CONFIRMED` / `PLAUSIBLE` / `BLOCKED` / `UNVERIFIED` |
| 防御側 | prevention に加え detection / containment / recovery |
| 安全側 | 実環境テストの許可がなければ `static-only` |

例の依頼文は次のとおりです。

```text
公開前監査を攻撃者視点でも実行して。
一般ユーザーから他テナントの請求書へ届くか確認して
```

---

## インストール

[Agent Skills](https://agentskills.io/) 形式です。[skills CLI](https://skills.sh/)（`npx skills`）で入れます。Cursor、Claude Code、Codex ほか対応ホストで動作します。

```bash
npx skills add yoshinaga2015/vibe-tech-audit
```

CLI が Skill（`vibe-tech-audit` / `vibe-tech-audit-ja`）、エージェント、global / project を聞きます。入れ終わったらエージェントを開き直し、例えば次のように依頼します。

```text
公開前に技術監査して
この差分を技術監査して
CRITICAL を直して
```

一覧確認と更新です。

```bash
npx skills add yoshinaga2015/vibe-tech-audit -l
npx skills update vibe-tech-audit-ja
# 英語版は vibe-tech-audit
```

| エージェント | CLI id | グローバル | プロジェクト |
|:---|:---|:---|:---|
| Cursor | `cursor` | `~/.cursor/skills/` | `.agents/skills/` |
| Claude Code | `claude-code` | `~/.claude/skills/` | `.claude/skills/` |
| Codex | `codex` | `~/.codex/skills/` | `.agents/skills/` |

対応ホスト一覧は [skills CLI supported agents](https://github.com/vercel-labs/skills#supported-agents) を見てください。

<details>
<summary>非対話 / CI</summary>

```bash
# 日本語 → Claude Code、グローバル
npx skills add yoshinaga2015/vibe-tech-audit -s vibe-tech-audit-ja -a claude-code -g -y

# 英語 → Cursor + Claude Code + Codex、グローバル
npx skills add yoshinaga2015/vibe-tech-audit \
  -s vibe-tech-audit \
  -a cursor -a claude-code -a codex \
  -g -y

# Skill パス直指定（-s 不要）
npx skills add https://github.com/yoshinaga2015/vibe-tech-audit/tree/main/skills/vibe-tech-audit-ja -g -y
```

</details>

<details>
<summary>手動フォールバック（<code>cp</code>）</summary>

```bash
SKILL=vibe-tech-audit-ja   # または vibe-tech-audit

cp -R "skills/$SKILL" ~/.cursor/skills/    # Cursor
cp -R "skills/$SKILL" ~/.claude/skills/    # Claude Code
cp -R "skills/$SKILL" ~/.codex/skills/     # Codex

mkdir -p .agents/skills .claude/skills
cp -R "skills/$SKILL" .agents/skills/
cp -R "skills/$SKILL" .claude/skills/
```

</details>

---

## 動き方

```text
1. Profile     スタックと表面（認可・決済・LLM・モバイル・アップロード・マルチテナント）
2. Scan        scripts/scan-antipatterns.sh（または同等の Grep）で定番アンチパターン
3. Prioritize  認可・データ経路を最優先。証拠必須
4. Deep-dive   該当表面だけ深掘り
5. Optional    攻撃チェーン分析（adversarial lens）
6. Assess      検知・対応も評価し、Severity 付きレポート（公開前は合否）
```

入口は短い `SKILL.md` です。チェックの詳細は `references/` にあります。

---

## 必要環境

| 必要なもの | メモ |
|:---|:---|
| [Agent Skills](https://agentskills.io/) 対応ホスト | Cursor、Claude Code、Codex、OpenCode、Gemini CLI、GitHub Copilot など |
| [skills CLI](https://skills.sh/)（推奨） | `npx skills add …` で各エージェントの正しいディレクトリへ入れる |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | スキャンスクリプト用に `rg` 推奨 |

---

## 対象外

| 項目 | 理由 |
|:---|:---|
| ペンテスト / ASVS 認証の代替 | スコープが違う |
| 組織レッドチームの代替 | adversarial lens はその代替ではない |
| 漏れた本番鍵のローテーション | 人間が行う作業 |
| Skill インストールの安全性審査 | その用途には使わない |
| 法務・コンプライアンス助言 | エンジニアリング用チェックリスト |

---

## 構成

```text
.
├── README.md
├── README.ja.md
├── LICENSE
├── docs/
│   ├── prelaunch-checklist.en.md
│   └── prelaunch-checklist.ja.md
└── skills/
    ├── vibe-tech-audit/       # 英語
    └── vibe-tech-audit-ja/    # 日本語
```

---

## 方法論

チェック項目は次の枠組みを参照しています。

- OWASP Top 10:2025
- OWASP API Security Top 10:2023
- ASVS 5.0（章立て）
- WSTG · MASVS
- OWASP LLM Top 10:2025
- CWE Top 25
- AI 生成アプリで繰り返される公開事故（RLS 無効、クライアントの `service_role`、middleware のみの認可など）

---

## ライセンス

MIT。[LICENSE](LICENSE) を参照してください。
