# Work Setup — Pending Tasks
> Last updated: 2026-05-12

## Waiting on Grok

| # | Task | Blocked by |
|---|---|---|
| 1 | Pre-mortem green flag on full infrastructure | Grok response to GROK_OUTBOX.md |

**When Grok responds:** Paste to Claude for QA. If green flag → close project.

---

## Waiting on CEO (Manual Actions)

| # | Task | Notes |
|---|---|---|
| 1 | Obsidian vault | Done — Master-Knowledge-Vault open ✅ |

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

| # | Task |
|---|---|
| 1 | failure-oracle HTTP server (port 3133) |
| 2 | start-failure-oracle.sh (SessionStart hook) |
| 3 | failure-oracle-inject.py (UserPromptSubmit hook) + inference gate |
| 4 | repeat-detection.py (Jaccard trigram 60%) |
| 5 | Supabase failure_patterns table + GIN index |
| 6 | All 17 patterns seeded P01–P17 |
| 7 | 3AI_COMMUNICATION_PROTOCOL.md on Desktop |
| 8 | Master-Knowledge-Vault 16-dir PAI structure |
| 9 | Master-Knowledge-Vault/CLAUDE.md (VERIFY gate, correct tier names) |
| 10 | G.Brain concepts/claude-failure-patterns updated |
| 11 | 4 Supabase comms tables (master_grok_brain, antigravity_outbox, grok_inbox, grok_outbox) |
| 12 | update-master-grok-brain.ts + sync-antigravity-outbox.ts written |
| 13 | Both scripts wired to gbrain-post-stop.sh (Stop hook) |
| 14 | pre-mortem skill installed globally (~/.claude/commands/pre-mortem.md) |
| 15 | rheavoss/work-setup repo — public, all files live |
