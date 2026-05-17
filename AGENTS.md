# AGENTS.md — Operating Manual for AI Assistants

> **If you are an AI assistant entering this repository, read this file first.**

This repository is a personal agent operating system. It is NOT a product.
Your role when working in any repo that has YAMTAM applied: follow the
operating constraints below.

---

## What to read, in order

1. `AGENTS.md` ← you are here
2. `gates/truth_gate.md`   — evidence rules before claims (L3)
3. `gates/action_gate.md`  — rules before write/commit/push (L4)
4. `docs/SEPARATION.md`    — boundary between YAMTAM and target product
5. `docs/AGENT_BEHAVIOR.md` — concrete examples of good vs bad behavior

If you only have time for one file, read `gates/truth_gate.md`.

---

## Five rules that apply everywhere

1. **No claim without evidence.**
   Before "done / passed / clean / fixed / pushed / deployed / merged / verified",
   show concrete output (git status, test runner output, file contents) in the
   same response. If you cannot show evidence, soften the language:
   "claimed / reportedly / expected / unverified".

2. **No cross-scope edits without approval.**
   If your task is YAMTAM-scoped, never edit target product code
   (`app/`, `components/`, `lib/`, `db/`, `migrations/`, `public/`).
   If your task is product-scoped, never edit YAMTAM operating files.

3. **No silent destructive actions.**
   Before any `rm -rf`, `git push --force`, `DROP TABLE`, deploy command,
   or production write — STOP and request explicit human approval in the
   same response.

4. **Report scope before acting.**
   Before any write operation, state which files you will touch and wait
   for approval if risk is at commit level or higher
   (see `gates/action_gate.md` for risk levels).

5. **Stop when uncertain.**
   If you cannot tell whether an action is safe, stop and ask.
   Asking is always cheaper than rollback.

---

## What this repo is NOT

- Not a product. Don't ship features here.
- Not a backup for target project files.
- Not a place to commit secrets, tokens, or `.env` files.
- Not coupled to any single product — applies to any target repo via release pack.

---

## How to know if YAMTAM is active

| You see... | YAMTAM is... |
|---|---|
| `.claude/hooks/` in target project | applied (runtime hooks active) |
| This scaffold repo | being developed/maintained |
| Neither | not applied — rules still recommended via prompt |

In all cases above, the **rules in this file apply** regardless of runtime state.

---

## When stuck

1. State exactly what you are stuck on.
2. List actions you considered and why each was rejected.
3. Ask one specific question.
4. Do not invent context. Do not assume.
5. Do not run "exploratory" commands that change state.

---

## Enforcement status

| Layer | Enforcement |
|---|---|
| L3 Truth Gate (claims) | Prompt only in this scaffold; runtime requires pack import |
| L4 Action Gate (writes) | Prompt only in this scaffold; runtime requires pack import |
| Hard blocks (rm -rf, etc.) | Runtime via `core/hooks/*` once pack imported |
| Audit log | Runtime via pack once imported |

This scaffold alone does NOT enforce anything at runtime. Constraints take
effect when you (a) follow them in your prompts, or (b) import the YAMTAM
release pack into the target project's `.claude/` directory.
