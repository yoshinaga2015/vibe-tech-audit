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

デモで動くこと ≠ 公開して安全なこと。チャットで通った実装を、本番前提で潰します:

`IDOR` · `秘密情報の露出` · `RLS未設定` · `認証ガードの真偽反転` · `XSS` · `署名なし Webhook` · `AI/API 課金の青天井`

| パッケージ | 言語 | Skill 名 |
|---|---|---|
| [`skills/vibe-tech-audit`](skills/vibe-tech-audit) | English | `vibe-tech-audit` |
| [`skills/vibe-tech-audit-ja`](skills/vibe-tech-audit-ja) | 日本語 | `vibe-tech-audit-ja` |

> **既定の姿勢:** 報告のみ。証拠必須（`file:line` またはコマンド出力）。でっち上げの PASS 禁止。**fix** モード以外で大規模リファクタしない。

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

`feature`、`prelaunch`、修正後の再検証には `lens: adversarial` を追加できます。

目標志向の攻撃チェーン分析です。本格的な組織レッドチーム演習を実施したようには表現しません。

| 観点 | 得られるもの |
|:---|:---|
| 目標 | 攻撃目標と初期権限 |
| チェーン | 信頼境界をまたぐ証拠付き経路 |
| 判定 | `CONFIRMED` / `PLAUSIBLE` / `BLOCKED` / `UNVERIFIED` |
| Blue team | prevention **と** detection / containment / recovery |
| 安全側 | 実環境テストの許可がなければ `static-only` |

```text
公開前監査を攻撃者視点でも実行して。
一般ユーザーから他テナントの請求書へ届くか確認して
```

---

## インストール

[Agent Skills](https://agentskills.io/) 形式＋[skills CLI](https://skills.sh/)（`npx skills`）。**Cursor**、**Claude Code**、**Codex** ほか対応ホストで使えます。

**推奨 — 主要エージェントへグローバルインストール**

```bash
# 日本語
npx skills add yoshinaga2015/vibe-tech-audit \
  -s vibe-tech-audit-ja \
  -a cursor -a claude-code -a codex \
  -g

# 英語
npx skills add yoshinaga2015/vibe-tech-audit \
  -s vibe-tech-audit \
  -a cursor -a claude-code -a codex \
  -g
```

**エージェントを1つだけ**（例）

```bash
npx skills add yoshinaga2015/vibe-tech-audit -s vibe-tech-audit-ja -a claude-code -g
npx skills add yoshinaga2015/vibe-tech-audit -s vibe-tech-audit-ja -a codex -g
npx skills add yoshinaga2015/vibe-tech-audit -s vibe-tech-audit-ja -a cursor -g
```

**プロジェクト共有**（アプリのリポジトリ直下で実行。`-g` なし）

```bash
npx skills add yoshinaga2015/vibe-tech-audit \
  -s vibe-tech-audit-ja \
  -a cursor -a claude-code -a codex
```

CLI が知る全エージェントへ:

```bash
npx skills add yoshinaga2015/vibe-tech-audit -s vibe-tech-audit-ja -a '*' -g
```

中身だけ確認:

```bash
npx skills add yoshinaga2015/vibe-tech-audit -l
```

更新:

```bash
npx skills update vibe-tech-audit-ja
# または
npx skills update vibe-tech-audit
```

その後 **新しいエージェントセッション** で:

```text
公開前に技術監査して
この差分を技術監査して
CRITICAL を直して
```

| エージェント | CLI id | グローバル | プロジェクト |
|:---|:---|:---|:---|
| Cursor | `cursor` | `~/.cursor/skills/` | `.agents/skills/` |
| Claude Code | `claude-code` | `~/.claude/skills/` | `.claude/skills/` |
| Codex | `codex` | `~/.codex/skills/` | `.agents/skills/` |

その他のホスト: [skills CLI supported agents](https://github.com/vercel-labs/skills#supported-agents)。

<details>
<summary>手動フォールバック（<code>cp</code>）</summary>

```bash
SKILL=vibe-tech-audit-ja   # または vibe-tech-audit

# Cursor（グローバル）
cp -R "skills/$SKILL" ~/.cursor/skills/

# Claude Code（グローバル）
cp -R "skills/$SKILL" ~/.claude/skills/

# Codex（グローバル）
cp -R "skills/$SKILL" ~/.codex/skills/

# プロジェクト（Cursor / Codex は .agents/skills）
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
3. Prioritize  認可・データ経路を最優先 — 証拠必須
4. Deep-dive   該当表面だけ深掘り
5. Optional    攻撃チェーン分析（adversarial lens）
6. Assess      検知・対応も評価 → Severity 付きレポート（公開前は合否）
```

`SKILL.md` は薄く保ち、詳細は `references/` に置く（progressive disclosure）。

---

## 必要環境

| 必要なもの | メモ |
|:---|:---|
| [Agent Skills](https://agentskills.io/) 対応ホスト | Cursor、Claude Code、Codex、OpenCode、Gemini CLI、GitHub Copilot など |
| [skills CLI](https://skills.sh/)（推奨） | `npx skills add …` で各エージェントの正しいディレクトリへ入れる |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | スキャンスクリプト用に `rg` 推奨 |

---

## これは何ではないか

| ではないもの | 理由 |
|:---|:---|
| 本格ペンテスト / ASVS 認証の代替 | スコープが違う |
| 本格レッドチーム演習の証明 | adversarial lens ≠ 組織レッドチーム |
| 漏れた本番鍵のローテーション代行 | 回転作業は人間側 |
| Skill サプライチェーン監査 | 無作為インストールの「承認」には使わない |
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

以下にマッピングしています:

- OWASP Top 10:2025
- OWASP API Security Top 10:2023
- ASVS 5.0（章立て参照）
- WSTG · MASVS
- OWASP LLM Top 10:2025
- CWE Top 25
- AI 生成アプリで繰り返される公開事故（RLS 無効、クライアントの `service_role`、middleware のみの認可など）

---

## ライセンス

MIT — [LICENSE](LICENSE)
