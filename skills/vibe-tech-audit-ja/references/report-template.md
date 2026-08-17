# Report template

ファイル名例: `tech-audit-YYYY-MM-DD.md`（リポジトリ直下、または `docs/` / `Flow/` があればそこ）

```markdown
# Tech Audit — <project> — <YYYY-MM-DD>

- Mode: feature | prelaunch | fix
- Lens: standard | adversarial
- Runtime: static-only | live-test
- Verdict: PASS | FAIL | CONDITIONAL | n/a (feature)
- Stack: …
- Surfaces: auth= / payments= / llm= / mobile= / upload= / multi_tenant=
- Scope: <diff summary or "full repo">

## Summary
<3–6行。最悪の問題を先に。>

## Findings

### F-001 — <title>
- Severity: CRITICAL|HIGH|MEDIUM|LOW
- Status: open|fixed|unverified|accepted
- ID: <checklist id e.g. C-AUTHZ-01>
- Location: `path:line`
- Evidence:
  ``` 
  <code quote or command output>
  ```
- Impact: <1文>
- Fix: <1–3文。実装は fix モードまで待ってよい>

（finding を Severity 降順で列挙）

## UNVERIFIED
| ID | 理由 | ユーザーがやる確認 |
|---|---|---|
| … | 実行環境なし | … |

## Detection and response
| Control | Grade | Evidence / gap |
|---|---|---|
| Enumeration detection | VERIFIED|PARTIAL|MISSING|UNVERIFIED | … |

## Attack-chain analysis（adversarial lens のみ）
| ID | Objective and chain | Status | Detection / containment |
|---|---|---|---|
| AC-01 | 一般ユーザー → orgId偽装 → 未スコープexport | CONFIRMED|PLAUSIBLE|BLOCKED|UNVERIFIED | … |

## Next 3 actions
1. …
2. …
3. …
```

## チャット要約（必須）

```text
Verdict: FAIL|PASS|CONDITIONAL
CRITICAL: <件数> — <タイトルを列挙>
HIGH: <件数>
Next: <3手>
Report: <path or "chat only">
```

## ルール

- Evidence の無い finding を書かない
- 同じ根因は1 finding にまとめ、複数 Location を列挙してよい
- fix 後は Status を更新し、再検証 Evidence を足す
- 結果をレッドチーム演習と呼ばず、adversarial review または攻撃チェーン分析と表現する
