# vibe-tech-audit

バイブコーディング／AI実装アプリ向けの**技術監査 Agent Skill**（Cursor ほか `SKILL.md` 対応ホスト）。

デモで動くことと、公開して安全なことは別です。IDOR、秘密情報の露出、RLS未設定、認証ガードの真偽反転、XSS、署名なし Webhook、AI/API 課金の青天井などを、チェックリスト駆動で潰します。

**言語**

| フォルダ | 言語 | Skill 名 |
|---|---|---|
| [`skills/vibe-tech-audit`](skills/vibe-tech-audit) | English | `vibe-tech-audit` |
| [`skills/vibe-tech-audit-ja`](skills/vibe-tech-audit-ja) | 日本語 | `vibe-tech-audit-ja` |

人間向けチェックリスト: [docs/prelaunch-checklist.ja.md](docs/prelaunch-checklist.ja.md) · [docs/prelaunch-checklist.en.md](docs/prelaunch-checklist.en.md)

[English README](README.md)

---

## モード

| モード | いつ | 動作 |
|---|---|---|
| **feature** | 機能追加・差分のあと | 差分範囲＋毎回の ★ |
| **prelaunch** | 実ユーザー・本番の前 | 該当チェック全項 → **PASS / FAIL / CONDITIONAL** |
| **fix** | 「直して」と明示したとき | 指定 finding の最小修正と再検証 |

デフォルトは**報告のみ**。修正モード以外で大規模リファクタしません。

---

## 任意の adversarial lens

`feature`、`prelaunch`、修正後の再検証には `lens: adversarial` を追加できます。
これは目標志向の攻撃チェーン分析であり、本格的な組織レッドチーム演習を
実施したようには表現しません。

- 攻撃目標と初期権限を定義
- 信頼境界をまたぐチェーンを証拠付きで追跡
- CONFIRMED / PLAUSIBLE / BLOCKED / UNVERIFIED で判定
- prevention に加えて detection / containment / recovery を確認
- 実環境テストの許可と非破壊制約が明示されなければ static-only

例: `公開前監査を攻撃者視点でも実行して。一般ユーザーから他テナントの請求書へ届くか確認して`

---

## インストール（Cursor）

1. Skill フォルダを個人スキルディレクトリへコピーします。

```bash
# 日本語
cp -R skills/vibe-tech-audit-ja ~/.cursor/skills/

# 英語
cp -R skills/vibe-tech-audit ~/.cursor/skills/
```

2. Cursor を再起動するか、エージェントをリロードします。
3. プロジェクトのチャットで例:

- `公開前に技術監査して`
- `この差分を技術監査して`
- `CRITICAL を直して`

どちらか一方の言語だけ入れて構いません。

リポジトリ共有インストール:

```bash
mkdir -p .cursor/skills
cp -R skills/vibe-tech-audit-ja .cursor/skills/
```

---

## 動き方

1. スタックと表面（認可・決済・LLM・モバイル等）を**プロファイル**
2. 定番アンチパターンを**機械スキャン**
3. **認可・データ経路を最優先**でレビュー（証拠必須）
4. 該当表面だけ深掘り
5. 必要なら**攻撃チェーン分析**
6. **検知・対応**も評価し、Severity 付きレポート。公開前は合否を出す

`SKILL.md` は薄く保ち、詳細は `references/` に置いています（progressive disclosure）。

---

## 必要環境

- Cursor（または Agent Skills を読めるホスト）
- スキャンスクリプト用に [ripgrep](https://github.com/BurntSushi/ripgrep)（`rg`）推奨

---

## これは何ではないか

- 本格的なペンテストや ASVS 認証の代替ではない
- 本格的なレッドチーム演習を実施したという証明ではない
- 漏れた本番鍵のローテーションそのものは人間の作業
- 無作為な Skill インストールの安全性審査には使わない
- 法務・コンプライアンス助言ではない

---

## 構成

```
publish/
├── README.md
├── README.ja.md
├── LICENSE
├── docs/
│   ├── prelaunch-checklist.en.md
│   └── prelaunch-checklist.ja.md
└── skills/
    ├── vibe-tech-audit/          # 英語
    └── vibe-tech-audit-ja/       # 日本語
```

---

## 方法論

OWASP Top 10:2025、API Security Top 10:2023、ASVS 5.0（章立て参照）、WSTG、MASVS、LLM Top 10:2025、CWE Top 25、および AI 生成アプリで繰り返される公開事故（RLS 無効、クライアントの `service_role`、middleware のみの認可など）に基づきます。

---

## ライセンス

MIT — [LICENSE](LICENSE)
