# AGENTS.md — Operating Manual for AI Assistants

> **If you are an AI assistant entering this repository, read this file first.**

This repository is a personal agent operating system. It is NOT a product.
Your role when working in any repo that has YAMTAM applied: follow the
operating constraints below.

---

## What to read, in order

1. `AGENTS.md` ← you are here
2. `gates/truth_gate.md`       — evidence rules before claims (L3)
3. `gates/action_gate.md`      — rules before write/commit/deploy (L0–L5)
4. `docs/SEPARATION.md`        — boundary between YAMTAM and target product
5. `docs/AGENT_BEHAVIOR.md`    — concrete examples of good vs bad behavior
6. `memory/L1_atomic/INDEX.md` — known facts and constraints (read before acting)
7. `memory/L2_session/`        — session facts (if any exist, read before acting)

If you only have time for one file, read `gates/truth_gate.md`.

---

## Five rules that apply everywhere

1. **No claim without evidence.**
   Before "done / passed / clean / fixed / pushed / deployed / merged / verified",
   show concrete output (git status, test runner output, file contents) in the
   same response. If you cannot show evidence, soften the language:
   "claimed / reportedly / expected / unverified".
   Enforced at runtime by `core/hooks/truth-gate-guard.sh` (Stop hook).

2. **No cross-scope edits without approval.**
   If your task is YAMTAM-scoped, never edit target product code
   (`app/`, `components/`, `lib/`, `db/`, `migrations/`, `public/`).
   If your task is product-scoped, never edit YAMTAM operating files.
   Enforced at runtime by `core/hooks/scope-guard.sh` (PreToolUse hook).

3. **No silent destructive actions.**
   Before any `rm -rf`, `git push --force`, `DROP TABLE`, deploy command,
   or production write — STOP and request explicit human approval in the
   same response.
   Enforced by `guard-destructive.sh`, `db-protect.sh`, `deploy-gate.sh`.

4. **Report scope before acting.**
   Before any write operation, state which files you will touch and wait
   for approval if risk is at commit level or higher
   (see `gates/action_gate.md` for risk levels L0–L5).

5. **Stop when uncertain.**
   If you cannot tell whether an action is safe, stop and ask.
   Asking is always cheaper than rollback.

---

## What this repo is NOT

- Not a product. Don't ship features here.
- Not a backup for target project files.
- Not a place to commit secrets, tokens, or `.env` files.
- Not coupled to any single product — applies to any target repo via release pack.
- See `.out-of-scope/` for features deliberately excluded.

---

## How to know if YAMTAM is active

| You see... | YAMTAM is... |
|---|---|
| `.claude/hooks/` in target project | applied (runtime hooks active) |
| This scaffold repo | being developed/maintained |
| Neither | not applied — rules still recommended via prompt |

In all cases above, the **rules in this file apply** regardless of runtime state.

---

## Memory system

YAMTAM has two active memory tiers:

### L1 Atomic Memory — persistent, git-tracked

Before acting on any assumption about YAMTAM behavior, check:

```bash
bash core/scripts/search-facts.sh --all
bash core/scripts/search-facts.sh "KEYWORD"
bash core/scripts/search-facts.sh --tag TAGNAME
```

| ID | What it tells you |
|---|---|
| `fact-scope-boundary` | Which product paths are off-limits without approval |
| `fact-truth-gate` | How the Truth Gate hook works and its bypass |
| `fact-hook-exit-codes` | exit 0 = allow, exit 0 + stdout = warn, JSON + exit 2 = block |
| `fact-confidence-rule` | Confidence must be promoted manually only |

Do not treat `unverified` facts as reliable for product decisions.
Add new L1 facts: `bash core/scripts/add-fact.sh`

### L2 Session Memory — ephemeral, gitignored

Short-lived facts scoped to the current session. Cleared when session ends.

```bash
bash core/scripts/search-session-facts.sh "KEYWORD"
bash core/scripts/add-session-fact.sh --id "s-xyz" --statement "..." --source "agent"
bash core/scripts/clear-session.sh          # wipe all session facts
```

Use `/session` command for interactive session memory management.
Promote important session facts to L1 with `/session promote <id>`.

---

## Available slash commands

| Command | Purpose |
|---|---|
| `/verify` | Full health check: git + hook syntax + tests + drift |
| `/memory [keyword]` | Search L1 + L2 facts; `--l2-only` for session only |
| `/session` | Add, search, clear, or promote L2 session facts |
| `/wiki` | Generate static docs from gitnexus graph → `docs/wiki/` |
| `/code-simplify [path]` | Identify dead code, over-abstraction, redundant logic |
| `/status` | Project status card from TODO.md, git, PRD |
| `/audit` | Lightweight quality audit via 5 agents |
| `/debug` | Debug a failing feature or test |
| `/review` | Code review before merge |

Full list: `core/commands/`

---

## Available skills

| Skill | Trigger |
|---|---|
| `git-lessons` | Past bugs, recurring mistakes, "have we hit this before?" |
| `gitnexus-exploring` | Architecture understanding, "how does X work?" |
| `gitnexus-debugging` | Trace bugs, "why is X failing?" |
| `gitnexus-impact-analysis` | Blast radius, "what breaks if I change X?" |
| `gitnexus-refactoring` | Rename, extract, split, move |
| `gitnexus-cli` | Index/re-index, status, wiki, clean |
| `karpathy-guidelines` | Code quality principles |

---

## When stuck

1. State exactly what you are stuck on.
2. List actions you considered and why each was rejected.
3. Ask one specific question.
4. Do not invent context. Do not assume.
5. Do not run "exploratory" commands that change state.

---

## Enforcement status (v1.3.11)

| Layer | Hook | Behavior |
|---|---|---|
| L0 Audit | `audit-log.sh`, `telemetry-sender.sh` | Log every tool call |
| L1 Warn: secrets | `token-scope-guard.sh` | Warn on credential file reads |
| L1 Warn: scope | `scope-guard.sh` | Warn on writes to product dirs |
| L2 Advisory: commits | `commit-gate.sh` | Warn on cross-scope staged files |
| L3 Truth Gate | `truth-gate-guard.sh` | Warn on unsupported claims (Stop hook) |
| L4 Block: deploys | `deploy-gate.sh` | Block gh/kubectl/docker/gcloud/fly/heroku |
| L5 Block: destructive | `guard-destructive.sh`, `db-protect.sh`, `api-destruct-guard.sh` | Block rm -rf, DROP TABLE, DELETE without WHERE |
| Memory | `search-facts.sh`, `search-session-facts.sh` | L1 + L2 retrieval |
| Drift detection | `drift-check.sh` | Stale facts, README overclaims, task drift |
| Release integrity | `build-release.sh` | Syntax + 42 tests + drift before pack |
