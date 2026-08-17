# vibe-tech-audit

Checklist-driven **technical audit skill** for vibe-coded / AI-assisted apps (Cursor and compatible agents).

It catches the failures that show up when “it works in the demo” is mistaken for “it is safe to ship”: IDOR, leaked secrets, missing RLS, inverted auth guards, XSS, unsigned webhooks, and unbounded AI/API spend.

**Languages**

| Skill folder | Language | Install name |
|---|---|---|
| [`skills/vibe-tech-audit`](skills/vibe-tech-audit) | English | `vibe-tech-audit` |
| [`skills/vibe-tech-audit-ja`](skills/vibe-tech-audit-ja) | Japanese | `vibe-tech-audit-ja` |

Human checklists: [docs/prelaunch-checklist.en.md](docs/prelaunch-checklist.en.md) · [docs/prelaunch-checklist.ja.md](docs/prelaunch-checklist.ja.md)

[日本語 README](README.ja.md)

---

## Modes

| Mode | When | Behavior |
|---|---|---|
| **feature** | After a change / PR | Diff-scoped audit + always-on ★ checks |
| **prelaunch** | Before real users | Full applicable checklist → **PASS / FAIL / CONDITIONAL** |
| **fix** | Only when you ask | Minimal patches for named findings, then re-verify |

Default is **report only**. The agent must not mass-refactor unless you explicitly enter fix mode.

---

## Install (Cursor)

1. Copy a skill folder into your personal skills directory:

```bash
# English
cp -R skills/vibe-tech-audit ~/.cursor/skills/

# Japanese
cp -R skills/vibe-tech-audit-ja ~/.cursor/skills/
```

2. Restart Cursor or reload agents so the skill is discovered.
3. In a project chat, ask for example:

- `Run a prelaunch security audit on this app`
- `Tech-audit this diff`
- `Fix the CRITICAL findings from the audit`

Optional: copy only one language if you do not need both.

Project install (shared with the repo):

```bash
mkdir -p .cursor/skills
cp -R skills/vibe-tech-audit .cursor/skills/
```

---

## How it works

1. **Profile** the stack and surfaces (auth, payments, LLM, mobile, uploads, multi-tenant).
2. **Machine-scan** common antipatterns (`scripts/scan-antipatterns.sh` or equivalent Grep).
3. **Review** authorization and data paths first (evidence required: `file:line` or command output).
4. **Deep-dive** only matching surfaces.
5. **Report** with severities; prelaunch emits a gate verdict.

Progressive disclosure keeps `SKILL.md` small; detailed checklists live under `references/`.

---

## Requirements

- Cursor (or another agent host that loads Agent Skills from `SKILL.md`)
- [ripgrep](https://github.com/BurntSushi/ripgrep) recommended for the scan script (`rg`)

---

## What this is not

- Not a full penetration test or ASVS certification
- Not a substitute for rotating leaked production secrets
- Not a skill-file supply-chain auditor (do not use it to “approve installing random skills”)
- Not licensed legal/compliance advice

---

## Layout

```
publish/
├── README.md
├── README.ja.md
├── LICENSE
├── docs/
│   ├── prelaunch-checklist.en.md
│   └── prelaunch-checklist.ja.md
└── skills/
    ├── vibe-tech-audit/          # English skill
    └── vibe-tech-audit-ja/       # Japanese skill
```

---

## Methodology

Mapped against OWASP Top 10:2025, OWASP API Security Top 10:2023, ASVS 5.0 chapter structure, WSTG, MASVS, OWASP LLM Top 10:2025, CWE Top 25, and recurring public failures in AI-generated apps (disabled RLS, client `service_role`, middleware-only auth).

---

## License

MIT — see [LICENSE](LICENSE).
