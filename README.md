<p align="right">
  <a href="./README.md"><img src="https://img.shields.io/badge/EN-0ea5e9?style=for-the-badge&labelColor=0f172a" alt="English" /></a>
  <a href="./README.ja.md"><img src="https://img.shields.io/badge/JP-1e293b?style=for-the-badge&labelColor=0f172a" alt="日本語" /></a>
</p>

<div align="center">

# vibe-tech-audit

**Checklist-driven technical audit for vibe-coded apps**

<br />

[![License: MIT](https://img.shields.io/badge/License-MIT-0f172a?style=flat-square&labelColor=0ea5e9&color=0f172a)](LICENSE)

<br />

[Install](#install)
·
[Modes](#modes)
·
[Adversarial lens](#optional-adversarial-lens)
·
[How it works](#how-it-works)
·
[EN checklist](docs/prelaunch-checklist.en.md)
·
[JA checklist](docs/prelaunch-checklist.ja.md)

</div>

---

A demo that works is not a safe launch. This skill finds failures that show up when chat-passing code is treated as production-ready.

`IDOR` · `leaked secrets` · `missing RLS` · `inverted auth guards` · `XSS` · `unsigned webhooks` · `unbounded AI/API spend`

| Package | Language | Install name |
|---|---|---|
| [`skills/vibe-tech-audit`](skills/vibe-tech-audit) | English | `vibe-tech-audit` |
| [`skills/vibe-tech-audit-ja`](skills/vibe-tech-audit-ja) | Japanese | `vibe-tech-audit-ja` |

> Default is report only. Every finding needs `file:line` or command output. No PASS without evidence. Code changes happen only in **fix** mode when you ask for them.

---

## Modes

| Mode | When | Behavior |
|:---|:---|:---|
| **feature** | After a change / PR | Diff-scoped audit + always-on ★ checks |
| **prelaunch** | Before real users | Full applicable checklist → **PASS / FAIL / CONDITIONAL** |
| **fix** | Only when you ask | Minimal patches for named findings, then re-verify |

```text
feature  →  ship the diff safely
prelaunch → gate the launch
fix       → close named findings (explicit only)
```

---

## Optional adversarial lens

Add `lens: adversarial` to `feature`, `prelaunch`, or post-fix validation. It sets an attacker objective and traces evidence-backed paths across trust boundaries. It is not a substitute for an organizational red team.

| Focus | Content |
|:---|:---|
| Objective | Attacker goal + starting privilege |
| Chains | Evidence-backed paths across trust boundaries |
| Grades | `CONFIRMED` / `PLAUSIBLE` / `BLOCKED` / `UNVERIFIED` |
| Defense | Prevention plus detection / containment / recovery |
| Safety | `static-only` unless live testing is explicitly authorized |

Example prompts follow.

```text
Run a prelaunch audit with the adversarial lens.
Can a basic user reach another tenant's invoices?
```

---

## Install

This repo uses the [Agent Skills](https://agentskills.io/) format. Install with the [skills CLI](https://skills.sh/) (`npx skills`). It works on Cursor, Claude Code, Codex, and other supported hosts.

```bash
npx skills add yoshinaga2015/vibe-tech-audit
```

The CLI asks which skill (`vibe-tech-audit` / `vibe-tech-audit-ja`), which agents, and global vs project. After install, open a fresh agent session and try prompts like these.

```text
Run a prelaunch security audit on this app
Tech-audit this diff
Fix the CRITICAL findings from the audit
```

List and update.

```bash
npx skills add yoshinaga2015/vibe-tech-audit -l
npx skills update vibe-tech-audit
# Japanese package: vibe-tech-audit-ja
```

| Agent | CLI id | Global | Project |
|:---|:---|:---|:---|
| Cursor | `cursor` | `~/.cursor/skills/` | `.agents/skills/` |
| Claude Code | `claude-code` | `~/.claude/skills/` | `.claude/skills/` |
| Codex | `codex` | `~/.codex/skills/` | `.agents/skills/` |

Full host list: [skills CLI supported agents](https://github.com/vercel-labs/skills#supported-agents).

<details>
<summary>Non-interactive / CI</summary>

```bash
# Japanese → Claude Code, global
npx skills add yoshinaga2015/vibe-tech-audit -s vibe-tech-audit-ja -a claude-code -g -y

# English → Cursor + Claude Code + Codex, global
npx skills add yoshinaga2015/vibe-tech-audit \
  -s vibe-tech-audit \
  -a cursor -a claude-code -a codex \
  -g -y

# Direct skill path (no -s)
npx skills add https://github.com/yoshinaga2015/vibe-tech-audit/tree/main/skills/vibe-tech-audit-ja -g -y
```

</details>

<details>
<summary>Manual fallback (<code>cp</code>)</summary>

```bash
SKILL=vibe-tech-audit   # or vibe-tech-audit-ja

cp -R "skills/$SKILL" ~/.cursor/skills/    # Cursor
cp -R "skills/$SKILL" ~/.claude/skills/    # Claude Code
cp -R "skills/$SKILL" ~/.codex/skills/     # Codex

mkdir -p .agents/skills .claude/skills
cp -R "skills/$SKILL" .agents/skills/
cp -R "skills/$SKILL" .claude/skills/
```

</details>

---

## How it works

```text
1. Profile     stack + surfaces (auth, payments, LLM, mobile, uploads, multi-tenant)
2. Scan        antipatterns via scripts/scan-antipatterns.sh (or equivalent Grep)
3. Prioritize  authorization and data paths first; evidence required
4. Deep-dive   only matching surfaces
5. Optional    attack-chain analysis (adversarial lens)
6. Assess      detection and response, then a Severity report (plus a gate verdict for prelaunch)
```

`SKILL.md` stays short. Detailed checks live under `references/`.

---

## Requirements

| Need | Notes |
|:---|:---|
| An [Agent Skills](https://agentskills.io/)-compatible host | Cursor, Claude Code, Codex, OpenCode, Gemini CLI, GitHub Copilot, and others |
| [skills CLI](https://skills.sh/) (recommended) | `npx skills add …` installs into the correct agent directories |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | Recommended for the scan script (`rg`) |

---

## Out of scope

| Item | Why |
|:---|:---|
| Penetration test / ASVS certification substitute | Different scope |
| Organizational red-team substitute | Adversarial lens is not that |
| Rotating leaked production secrets | Humans do that work |
| Skill install safety review | Do not use it for that |
| Legal / compliance advice | Engineering checklist only |

---

## Layout

```text
.
├── README.md
├── README.ja.md
├── LICENSE
├── docs/
│   ├── prelaunch-checklist.en.md
│   └── prelaunch-checklist.ja.md
└── skills/
    ├── vibe-tech-audit/       # English skill
    └── vibe-tech-audit-ja/    # Japanese skill
```

---

## Methodology

Checklist items draw on these frameworks.

- OWASP Top 10:2025
- OWASP API Security Top 10:2023
- ASVS 5.0 chapter structure
- WSTG · MASVS
- OWASP LLM Top 10:2025
- CWE Top 25
- Recurring public failures in AI-generated apps (disabled RLS, client `service_role`, middleware-only auth)

---

## License

MIT. See [LICENSE](LICENSE).
