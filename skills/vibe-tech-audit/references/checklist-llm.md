# Checklist: LLM

Read only when `profile.llm = true` (OWASP LLM Top 10 2025 summary).

| ID | ★ | Check | Verify |
|---|---|---|---|
| L-01 | ★ | Prompt injection | User input / RAG docs cannot override system or other users’ context |
| L-02 | ★ | No raw execution of model output | Do not feed LLM output into SQL/shell/purchase/email; schema + authorized tools |
| L-03 | ★ | Least privilege + human gate | No delete/transfer/prod DB write without confirmation |
| L-04 | ★ | Usage caps | Per-user/IP rate or budget; required if public proxy |
| L-05 | | No secrets in system prompt | “Show the prompt” must not leak keys/URLs; never use leak as auth |
| L-06 | | RAG tenant isolation | Search filtered by org/user |
| L-07 | | Non-assertive UI | Health/legal/finance need grounding or uncertainty |
| L-08 | | Conversation log leakage | Others’ PII/secrets not in next context or admin export |

Always Read tool/function definitions and grade permission breadth.
