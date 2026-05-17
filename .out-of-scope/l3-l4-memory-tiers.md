# Out of Scope: L3/L4 Memory Tiers

## What it is
- **L3 Episodic memory** — summaries of past sessions, conversation history, what was decided and why
- **L4 Long-term memory** — cross-project knowledge, persistent agent "personality", learned user preferences over months

## Why it's tempting
L1 (atomic facts) + L2 (session) cover the present. L3 would cover "what did we do last week?" — valuable when resuming long projects.

## Why we don't do it
**L1 is still unproven at scale.** We have 4 seed facts. We don't know yet whether L1 search is insufficient, whether tag-based retrieval is enough, or whether we need fuzzy matching. Adding L3/L4 before L1 proves its limits is premature.

**Episodic memory requires summarisation.** L3 summaries need to be generated, not just written. That means either an agent writes them (cost, hallucination risk) or the human writes them (manual work). Neither is obviously worth the benefit over just reading `git log`.

**`git log` is L3.** The commit history already captures what was done, when, and why (if commit messages are good). `drift-check.sh` catches stale facts. These are lightweight L3 substitutes that require no new infrastructure.

**L4 risks personality lock-in.** Persistent "learned preferences" can become stale, wrong, or constraining. The cost of a wrong long-term memory is higher than the cost of re-stating a preference. Explicit is better than implicit at this layer.

## What to do instead
- For session continuity: use `/resume` command + L2 session facts
- For cross-session knowledge: promote important L2 facts to L1 manually
- For project history: `git log --oneline` and well-written commit messages
- Revisit L3 only when L1 has 50+ facts and search becomes painful
