<p align="right">
  <a href="./README.md"><img src="https://img.shields.io/badge/EN-0ea5e9?style=for-the-badge&label=Docs&labelColor=0f172a" alt="English docs" /></a>
  <a href="./README.ja.md"><img src="https://img.shields.io/badge/JP-1e293b?style=for-the-badge&label=Docs&labelColor=0f172a" alt="Japanese docs" /></a>
</p>

<div align="center">

# vibe-tech-audit

**Checklist-driven technical audit for vibe-coded apps**

Cursor Agent Skill · evidence-required · report-first

<br />

[![License: MIT](https://img.shields.io/badge/License-MIT-0f172a?style=flat-square&labelColor=0ea5e9&color=0f172a)](LICENSE)
[![Skill EN](https://img.shields.io/badge/skill-vibe--tech--audit-0ea5e9?style=flat-square&labelColor=0f172a)](skills/vibe-tech-audit)
[![Skill JA](https://img.shields.io/badge/skill-vibe--tech--audit--ja-64748b?style=flat-square&labelColor=0f172a)](skills/vibe-tech-audit-ja)
[![Modes](https://img.shields.io/badge/modes-feature%20%7C%20prelaunch%20%7C%20fix-38bdf8?style=flat-square&labelColor=0f172a)](#modes)
[![Lens](https://img.shields.io/badge/lens-standard%20%7C%20adversarial-22d3ee?style=flat-square&labelColor=0f172a)](#optional-adversarial-lens)

<br />

[Install](#install-cursor)
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

Demo ≠ ship-ready. This skill hunts the failures that show up when “it works in the chat” is mistaken for “safe in production”:

`IDOR` · `leaked secrets` · `missing RLS` · `inverted auth guards` · `XSS` · `unsigned webhooks` · `unbounded AI/API spend`

| Package | Language | Install name |
|---|---|---|
| [`skills/vibe-tech-audit`](skills/vibe-tech-audit) | English | `vibe-tech-audit` |
| [`skills/vibe-tech-audit-ja`](skills/vibe-tech-audit-ja) | Japanese | `vibe-tech-audit-ja` |

> **Default posture:** report only. Evidence required (`file:line` or command output). No invented PASS. No mass-refactor unless you enter **fix** mode.

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

`feature`, `prelaunch`, and post-fix validation can also use `lens: adversarial`.

Goal-oriented attack-chain analysis — **not** a claim of a full organizational red-team engagement.

| Focus | What you get |
|:---|:---|
| Objective | Attacker goal + starting privilege |
| Chains | Evidence-backed paths across trust boundaries |
| Grades | `CONFIRMED` / `PLAUSIBLE` / `BLOCKED` / `UNVERIFIED` |
| Blue team | Prevention **and** detection / containment / recovery |
| Safety | `static-only` unless live-test authorization is explicit |

```text
Run a prelaunch audit with the adversarial lens.
Can a basic user reach another tenant's invoices?
```

---

## Install (Cursor)

**Personal skill**

```bash
# English
cp -R skills/vibe-tech-audit ~/.cursor/skills/

# Japanese
cp -R skills/vibe-tech-audit-ja ~/.cursor/skills/
```

1. Restart Cursor or reload agents so the skill is discovered.
2. Ask in a project chat:

```text
Run a prelaunch security audit on this app
Tech-audit this diff
Fix the CRITICAL findings from the audit
```

Install only one language if you do not need both.

**Project skill** (shared with the repo)

```bash
mkdir -p .cursor/skills
cp -R skills/vibe-tech-audit .cursor/skills/
```

---

## How it works

```text
1. Profile     stack + surfaces (auth, payments, LLM, mobile, uploads, multi-tenant)
2. Scan        antipatterns via scripts/scan-antipatterns.sh (or equivalent Grep)
3. Prioritize  authorization & data paths first — evidence required
4. Deep-dive   only matching surfaces
5. Optional    attack-chain analysis (adversarial lens)
6. Assess      detection & response → Severity report (+ gate verdict for prelaunch)
```

Progressive disclosure: thin `SKILL.md`, deep checklists under `references/`.

---

## Requirements

| Need | Notes |
|:---|:---|
| Cursor (or compatible Agent Skills host) | Loads skills from `SKILL.md` |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | Recommended for the scan script (`rg`) |

---

## What this is not

| Not this | Because |
|:---|:---|
| Full penetration test / ASVS certification | Different engagement scope |
| Full red-team exercise proof | Adversarial lens ≠ org red team |
| Secret rotation for you | Humans still rotate leaked production keys |
| Skill supply-chain auditor | Do not use it to “approve random skills” |
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

Mapped against:

- OWASP Top 10:2025
- OWASP API Security Top 10:2023
- ASVS 5.0 chapter structure
- WSTG · MASVS
- OWASP LLM Top 10:2025
- CWE Top 25
- Recurring public failures in AI-generated apps (disabled RLS, client `service_role`, middleware-only auth)

---

## License

MIT — see [LICENSE](LICENSE).
