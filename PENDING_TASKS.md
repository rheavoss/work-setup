# Work Setup — Pending Tasks
> Last updated: 2026-05-12

## Waiting on Grok

| # | Task | Blocked by | Created |
|---|---|---|---|
| 1 | FAANG-level failure prevention architecture | Grok response to `3AI_COMMUNICATION_PROTOCOL.md` (Desktop) — 7 questions inside | 2026-05-12 |
| 2 | Supabase async comms bus (reduce 5-step CEO bridge) | Same Grok response — Q4 in protocol doc | 2026-05-12 |

**When Grok responds:** Paste to Claude for QA (AGREE/DISAGREE per point) before anything touches disk.

---

## Waiting on CEO (Manual Actions)

| # | Task | Notes |
|---|---|---|
| 1 | Point Obsidian at vault | Open Obsidian → "Open folder as vault" → `~/Master-Knowledge-Vault` |
| 2 | Share `3AI_COMMUNICATION_PROTOCOL.md` with Grok | File is on Desktop. Paste + ask for FAANG redesign answers to 7 questions. |

---

## Ongoing / Recurring

| # | Task | Cadence |
|---|---|---|
| 1 | Weekly Mac cleanup | `bash cleanup.sh --delete` from this folder |
| 2 | Sunday check | `bash sunday_check.sh` — verifies hooks, MCP, gbrain binary |
| 3 | Add new failures to `claude_failure_log.md` | End of each session |
| 4 | Sync G.Brain failure patterns page | After failure log additions |

---

## Completed (2026-05-12 Session)

| # | Task | Status |
|---|---|---|
| 1 | failure-oracle HTTP server (`~/.claude/mcp/failure-oracle/server.ts`, port 3133) | Done |
| 2 | failure-oracle SessionStart hook (`start-failure-oracle.sh`) | Done |
| 3 | failure-oracle UserPromptSubmit inject hook (`failure-oracle-inject.py`) | Done |
| 4 | Repeat-detection hook (`repeat-detection.py`) — Jaccard trigram, 60% threshold | Done |
| 5 | Supabase `failure_patterns` table + GIN index on keywords | Done |
| 6 | All 17 failure patterns seeded into Supabase (P01–P17, normalized) | Done |
| 7 | `3AI_COMMUNICATION_PROTOCOL.md` written to Desktop | Done |
| 8 | `~/Master-Knowledge-Vault/` directory structure (16 dirs, PAI-aligned) | Done |
| 9 | `~/Master-Knowledge-Vault/CLAUDE.md` with PAI Algorithm v6.3.0 VERIFY gate | Done |
| 10 | G.Brain `concepts/claude-failure-patterns` updated with all 17 patterns | Done |
