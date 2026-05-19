# YAMTAM ENGINE — Changelog

All notable changes to YAMTAM ENGINE release packs are documented here.

> **Note:** This changelog tracks **release pack** events. This scaffold repo
> does not enforce any release item at runtime until the pack's `hooks/`,
> `scripts/`, and `tests/` are imported into `core/`.

---

## v1.3.16 — Claude Code Harness Integration
*2026-05-19*

### New Docs
- `docs/MAINTENANCE_POLICY.md` — hook lifecycle policy: 4 states (active/review/deprecated/removed), trigger conditions for early review, stale hook risk analysis, review history in `docs/reviews/`
- `docs/CLAUDE_MD_GUIDE.md` — CLAUDE.md architecture guide: 4-tier layering (root → subdirectory → subdirectory init → per-dir test scope), checklist before creating new CLAUDE.md

### New Rules
- `core/rules/subagent-policy.md` — subagent read-only policy: permission table (main agent vs subagent), dispatch format, report format, red flag indicators

### New Skills
- `core/skills/lsp-navigation/SKILL.md` — LSP-first symbol navigation: go-to-definition + find-references before grep; grep fallback guidelines to minimize context budget usage

### New Commands
- `core/commands/hook-review.md` — `/hook-review`: hook lifecycle review (read-only report); checks version header, test coverage, execute bit, last touched, bypass indicators, overlap; human-gated execution

### New Tests
- `core/tests/commands/test-hook-review-smoke.sh` — 6 smoke tests verifying hook-review.md file structure and format
- `core/tests/skills/test-skill-triggering.sh` — +3 lsp-navigation trigger cases; total now 25 tests

### Updated Docs
- `docs/HOOK_WIRING.md` — added `/hook-review` entry under Commands section

### MANIFEST
- Version 1.3.15 → 1.3.16; commands 32→33, skills 19→20, rules 3→4; 6 new file entries

---

## v1.3.15 — Executing-Plans, Code Review Skills
*2026-05-18*

### New Skills
- `core/skills/executing-plans/SKILL.md` — structured execution of approved plans; gate checks before each step
- `core/skills/requesting-code-review/SKILL.md` — how to request code review with context and scope
- `core/skills/receiving-code-review/SKILL.md` — how to receive and address review comments
- `core/skills/writing-skills/SKILL.md` — how to author new YAMTAM skill files correctly

### Tests
- +8 skill trigger tests (4 new skills × 2 phrases each) → 22 total

### Release
- `releases/yamtam-engine-v1.3.15-fixed.zip` — 173 files, 260K

---

## v1.3.14 — Checkpoint + Handoff Commands
*2026-05-18*

### New Commands
- `/checkpoint` — save session state mid-task; structured snapshot of current progress, blockers, next steps
- `/handoff` — generate handoff note for context-window boundary; structured for clean agent pickup

### MANIFEST
- Version 1.3.13 → 1.3.14; commands 30→32 (+checkpoint, +handoff)

---

## v1.3.13 — TDD Skill Import
*2026-05-18*

### New Skills
- `core/skills/tdd/SKILL.md` — RED → GREEN → REFACTOR cycle; multi-agent context isolation; external test scripts removed; integrated with verify-before-done and debug-protocol skills
- Source: adapted from glebis/claude-skills (MIT License)

### MANIFEST
- Version 1.3.12 → 1.3.13; skills 14→15 (+tdd)

---

## v1.3.12 — Superpowers Skill Import
*2026-05-18*

### New Skills
- `core/skills/plan-first/SKILL.md` — plan before implement; multi-step task gate
- `core/skills/verify-before-done/SKILL.md` — verify claims before reporting done/fixed
- `core/skills/debug-protocol/SKILL.md` — structured debug loop: reproduce → isolate → fix → verify
- `core/skills/branch-finish/SKILL.md` — branch completion checklist before merge
- `core/skills/worktree-safety/SKILL.md` — safe experiment isolation via git worktree
- Source: adapted from obra/superpowers v5.1.0 (MIT License); content rewritten in YAMTAM style

### New Commands
- `/diff-review` — review staged diff before commit; checks scope, test coverage, doc drift

### MANIFEST
- Version 1.3.11 → 1.3.12; skills 9→14 (+5), commands 26→27 (+diff-review)

---

## v1.3.11-fire — FIRE List 1–5: Audit Hardening, Fact-Check, Session Trust, Tool Router, Skill Loop
*2026-05-18*

### New Scripts
- `core/scripts/verify-audit-chain.sh` — verifies SHA-256 hash chain in audit log; exit 0 = intact, exit 1 = first broken entry printed
- `core/scripts/session-trust.sh` — tracks session trust score (0–100); `get/show/decrement N/reset`; state in `.claude/state/session-trust.json`

### New Commands
- `/fact-check [claim]` — proactive claim verification; agent must show evidence inline and rate confidence: `verified / likely / unverified`
- `/improve-skill [path/to/SKILL.md]` — human-gated skill improvement loop; Executor → Analyst → Mutator → Human; Mutator never edits without approval

### Updated Hooks
- `audit-log.sh` — upgraded from plain text to SHA-256 hash-chained JSONL (`audit-chain.log`); each entry hashes content + previous hash; tamper-evident
- `truth-gate-guard.sh` — now calls `session-trust.sh decrement 10` on each unverified claim warning; score < 50 shows `🔴 LOW TRUST SESSION` banner

### Updated Agents
- `tool-router.md` — added Specialist Routing Table (5 query types → specialist + tool allowlist); Confidence Threshold rule: < 70% → ask user, do not guess; least-privilege enforced

### New Tests
- `core/tests/hooks/test-audit-chain.sh` — 12 test cases: entry format, genesis hash, chain integrity, secret masking, tampering detection
- `core/tests/hooks/run-hook-tests.sh` — added 5 session-trust cases; total now 47 tests

### New Docs
- `docs/ARCHITECTURE.md` — full architecture reference: layer model, hook execution model, memory architecture, agent routing, release process
- `docs/AUDIT_HARDENING.md` — hash-chain audit log design: format, masking rules, verification, limitations

### Bug Fixes
- SC2295: fixed unquoted `$PROJECT_ROOT` inside `${..#..}` in `scope-guard.sh`, `context-gate.sh`, `drift-check.sh`, `search-facts.sh`, `search-session-facts.sh`
- Removed unused `CUTOFF` variable from `drift-check.sh`
- Fixed execute bit on 6 scripts missing `+x`
- Version headers bumped from v1.2.x → v1.3.11 in 5 files

---

## v1.3.11 — gitnexus Upstream Refresh, Wiki Automation, Git Lessons Skill
*2026-05-17*

### New Skills
- `git-lessons` — extract lessons from `fix:` commits via `git log --grep`; pattern recognition
  by area/type/recurrence; promotes critical lessons to L1. No L3 infrastructure needed.

### New Commands
- `/wiki` — generate static docs from gitnexus knowledge graph → `docs/wiki/` (git-tracked);
  agents read `docs/wiki/` instead of scanning code — reduces context window usage.

### New Scripts
- `generate-wiki.sh` — runs `npx gitnexus wiki`, copies output to `docs/wiki/`, optional
  `--commit` flag for auto-commit. Handles output path detection across gitnexus versions.

### Upstream Refresh
- `gitnexus-cli` skill updated to v1.6.5: incremental indexing default, `--embeddings-url`
  HTTP backend flag for self-hosted endpoints, v1.6.0 install bug warning added.

### Docs
- `README.md` — full rewrite: correct counts, Action Gate L0–L5 table, `.out-of-scope/`
  section, `.claude-plugin/` install instructions, GitHub Actions release note.
- `AGENTS.md` — L2 session memory section, skills table, updated enforcement table (L0–L5).

### MANIFEST
- Version 1.3.10 → 1.3.11; commands 25→26 (+wiki); scripts 17→18 (+generate-wiki); skills 8→9 (+git-lessons).

---

## v1.3.10 — .out-of-scope/ Boundary Documents
*2026-05-17*

### New Docs
- `.out-of-scope/README.md` — index of 5 boundary decisions.
- `.out-of-scope/real-time-cost-dashboard.md` — why we don't build a live cost UI.
- `.out-of-scope/multi-agent-coordination.md` — why cross-repo coordination is out of scope.
- `.out-of-scope/enterprise-rbac.md` — why full RBAC is wrong for a personal OS.
- `.out-of-scope/l3-l4-memory-tiers.md` — why L3/L4 memory waits until L1 proves insufficient.
- `.out-of-scope/cloud-console-protection.md` — why cloud console protection belongs at IAM layer.

---

## v1.3.9 — /code-simplify Command
*2026-05-17*

### New Commands
- `/code-simplify [file|dir] [--dry-run]` — static analysis targeting dead code,
  over-abstraction, redundant logic, unnecessary indirection.

---

## v1.3.8 — Security Advisory Templates
*2026-05-17*

### New Docs
- `.github/security-advisories/GHSA-TEMPLATE.md` — standard CVSS/CWE advisory template.
- `.github/security-advisories/GHSA-2026-0001.md` — hook output format bug (cost-guard +
  rbac-guard); CVSS 6.5 Medium, CWE-693; fixed in v1.3.1.

---

## v1.3.7 — GitHub Actions Release Workflow
*2026-05-17*

### Infra
- `.github/workflows/release.yml` — triggers on semver tag push (`v[0-9]+.[0-9]+.[0-9]+`).
  Steps: validate tag → install jq/zip → run hook tests → drift check → build pack →
  update plugin.json/marketplace.json version → create GitHub Release via `softprops/action-gh-release@v2`.

---

## v1.3.6 — .claude-plugin/ Distribution
*2026-05-17*

### New Files
- `.claude-plugin/plugin.json` — schema_version 1; install via zip from GitHub Releases latest.
- `.claude-plugin/marketplace.json` — tagline, highlights, stats, install command.
- `build-release.sh` updated: creates `yamtam-engine-latest.zip` symlink for stable install URL.

---

## v1.3.5 — /memory L2 Integration
*2026-05-17*

### Updated Commands
- `/memory` — bare call now shows L1 + L2 automatically; `--l2` (both layers);
  `--l2-only` (session facts only).

---

## v1.3.4 — L2 Session Memory
*2026-05-17*

### New Memory Tier
- `memory/L2_session/` — ephemeral facts, gitignored, cleared each session.
- `memory/L2_session/SCHEMA.md` — simpler schema: required id/statement/source; optional tags/evidence.

### New Scripts
- `add-session-fact.sh` — non-interactive flag-based writer for agent use.
- `search-session-facts.sh` — keyword + `--tag` filter for L2 facts.
- `clear-session.sh` — wipe L2 with `--force` or confirmation; never deletes SCHEMA.md.

### New Commands
- `/session` — add/search/clear/promote L2 session facts to L1.

### Infra
- `.gitignore` — `memory/L2_session/*.md` ignored, `!memory/L2_session/SCHEMA.md` tracked.

---

## v1.3.3 — Tag Support on Seed Facts + Test Seam for commit-gate
*2026-05-17*

### Memory
- All 4 seed facts tagged: fact-confidence-rule `[memory,confidence,schema]`,
  fact-hook-exit-codes `[hook,exit-code,format]`, fact-scope-boundary `[scope,gate,cross-scope]`,
  fact-truth-gate `[hook,truth-gate,claim-verb]`.

### Tests
- `commit-gate.sh` test seam: `COMMIT_GATE_TEST_STAGED` env var (mirrors `TRUTH_GATE_TEST_TEXT`).
- +8 commit-gate tests → 42 total (was 34).

### Release
- `releases/yamtam-engine-v1.3.3-fixed.zip` — 133 files, 208K.

---

## v1.3.2 — L4 Action Gate: commit-gate + deploy-gate
*2026-05-17*

### New Hooks
- `commit-gate.sh` (PreToolUse, L2 advisory): warns when staged files touch cross-scope paths.
  Bypass: `YAMTAM_SCOPE_OK=1`. Test seam: `COMMIT_GATE_TEST_STAGED`.
- `deploy-gate.sh` (PreToolUse, L4 block): blocks gh workflow run, kubectl apply/rollout,
  docker push, gcloud deploy, fly deploy/launch, heroku releases:promote.
  Bypass: `YAMTAM_DEPLOY_APPROVED=1`.

### Tests
- +8 deploy-gate tests, +8 commit-gate tests → 34 total (was 26).

### Spec Updates
- `gates/action_gate.md` — updated with full L0–L5 coverage table.
- `docs/HOOK_WIRING.md` — v1.3.1, both hooks wired in all presets.

---

## v1.3.1 — Tag Support, Hook Output Format Fix, Regex Fix
*2026-05-17*

### Bug Fixes (Critical)
- **`cost-guard.sh` wrong output format**: `emit()` used `{decision,reason}+exit 0` —
  blocking rules were silent no-ops. Fixed: `block()` uses `hookSpecificOutput+exit 2`,
  `warn()` uses `additionalContext+exit 0`.
- **`rbac-guard.sh` wrong output format**: same class of bug; also used fragile python3
  JSON encoding. Fixed with jq-based hookSpecificOutput + exit 2.
- **`cost-guard.sh` grep regex**: pattern `grep.*(-r).*[[:space:]]+\.` missed
  `grep -r pattern .` (content between flag and path). Fixed: `grep.*(-r).*[[:space:]]\.`.
- **`drift-check.sh` SCHEMA.md not skipped**: would have triggered false stale alert in 2027
  on example date in SCHEMA.md. Fixed: now skips SCHEMA.md alongside INDEX.md.

### New Features
- **Tag support for L1 memory**: `tags` field in SCHEMA.md, `--tag TAG` filter in
  `search-facts.sh`, tag prompt in `add-fact.sh`, `/memory --tag` documented.

### Tests
- +5 cost-guard tests (block/allow/bypass) → 26 total (was 21).

### Security Advisory Filed
- GHSA-2026-0001: hook output format bug affected cost-guard + rbac-guard in all versions
  prior to v1.3.1. CVSS 6.5 Medium (CWE-693).

---

## v1.3.0 — Truth Gate Runtime, Scope Guard, L1 Memory, Drift Detector
*2026-05-17*

### New Hooks
- `truth-gate-guard.sh` (Stop): scans last assistant message for claim verbs
  (done/fixed/deployed…); warns when no evidence patterns or fallback qualifiers
  present. Non-blocking. Bypass: `YAMTAM_TRUTH_GATE_BYPASS=1`.
- `scope-guard.sh` (PreToolUse): warns when Write/Edit targets product dirs
  (`app/ components/ lib/ db/ migrations/ .env* vercel.json`…).
  Advisory only. Bypass: `YAMTAM_SCOPE_OK=1`.

### New Commands
- `/verify` — full health check: git state + hook syntax + test suite + drift report.
  Shows actual command output (Truth Gate compliant).
- `/memory [keyword]` — search and list L1 Atomic Memory facts by keyword,
  type, scope, or confidence.

### New Scripts
- `drift-check.sh` — detects task drift (done with no recent commit), README
  overclaims (feature with no grep hit), and stale L1 facts (expired).
  Exit 0 clean / 1 dirty. Integrated into `/verify`.
- `search-facts.sh` — grep-based L1 fact retrieval. Filters: `--type`, `--scope`,
  `--confidence`, `--expired`, `--all`.
- `add-fact.sh` — interactive fact writer. Enforces scope mandatory, blocks
  secret patterns, defaults confidence to `unverified`.

### L1 Atomic Memory
- `memory/L1_atomic/SCHEMA.md` — field spec: id, type, statement, source,
  confidence, scope, expires_at, forbidden_assumptions, evidence.
- `memory/L1_atomic/INDEX.md` — auto-updated index table.
- File-based only. No network, no server, no npm deps.
- L2 session tier added in v1.3.4. L3/L4 deliberately excluded (see `.out-of-scope/`).

### Spec Updates
- `gates/truth_gate.md` — status updated from "Future Hook" to "Implemented".
- `MANIFEST.json` — hooks 20→22, commands 21→23, scripts 10→13, memory section added.

### Infra
- `.gitignore` — added `.claude/state/` (runtime logs, not committed).
- Hook test suite expanded: +7 truth-gate test cases.

---

## v1.2.9-fixed — Hook Test Suite & Release QA
*2026-05-07*

- Added hook test suite with 13 automated tests across 4 hooks (in pack).
- Test suite reports 13/13 PASS when run from imported pack.
- Added `verify-claude-pack.js` for pack integrity check.
- Documented known limitations explicitly.
- Fixed `RELEASE_CHECKLIST.md` to match v1.2.9 scope (not v1.2 template).
- Cleaned filename encoding issues (`#U2014` → ASCII).
- Updated `MANIFEST.json` to reflect actual file structure.
- Added `README.md` at pack root.

---

## v1.2.8-fixed — PocketOS / API Destruction Guard
*2026-04*

- Added `api-destruct-guard.sh`: blocks raw destructive HTTP/GraphQL calls.
- Defense against PocketOS-style incidents (agent deletes Railway volume autonomously).
- Updated `AGENT_INCIDENT_DEFENSE.md` with PocketOS case analysis.

---

## v1.2.7 — Replit-Incident Defense / Production Protection
*2026-04*

- Strengthened `guard-destructive.sh` following Replit incident analysis.
- Added production command block patterns.
- Updated `AGENT_INCIDENT_DEFENSE.md` with Replit case.

---

## v1.2.6 — Handoff Mode
*2026-04*

- Added checkpoint/handoff protocol for context window limits.
- Agent generates structured handoff note before token exhaustion.

---

## v1.2.5 — E2E Safety
*2026-04*

- Added E2E safety layer to prevent runaway test loops.
- Timeout guards on E2E test runs.

---

## v1.2.4 — Local Audit Log
*2026-03*

- All hook decisions (allow/warn/deny) logged locally.
- Log format: `timestamp | hook | input | decision`.

---

## v1.2.3 — Scope Lock
*2026-03*

- Agent scope bounded to declared task.
- Cross-scope edits require explicit approval.

---

## v1.2.2 — Budget Mode Switch
*2026-03*

- Manual budget mode toggle to reduce API cost during low-priority tasks.

---

## v1.2.1 — Truthful Cost Guard
*2026-03*

- Cost estimation before expensive operations.
- Agent must report estimated cost, not hide it.

---

## v1.0–v1.1 — Foundation
*2026-02/03*

- Initial hook architecture.
- `db-protect.sh`, `token-scope-guard.sh` first versions.
- Basic agent ruleset.
