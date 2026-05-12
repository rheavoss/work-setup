# Work Setup — Pending Tasks
> Last updated: 2026-05-12

## Status: 3 Tigers Fixed — Re-run Pre-Mortem for Green Flag

Grok pre-mortem ran (2026-05-12). Found 3 Launch-Blocking Tigers. All fixed.

| # | Tiger | Fix |
|---|---|---|
| 1 | Port 3133 down — silent fail open | failure-oracle-inject.py now injects hard Pattern #15 warning on URLError |
| 2 | gbrain-post-stop.sh early exit — Supabase never ran on clean sessions | Supabase scripts moved before git-dirty check |
| 3 | .gbrain-project missing — basename garbage in master_grok_brain | Created .gbrain-project in Instagram + BMN (all 13 projects now covered) |

**Next:** Re-run pre-mortem or declare green flag if fixes are sufficient.

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
| 16 | Grok pre-mortem run — 3 Tigers found |
| 17 | Tiger 1 fix — failure-oracle-inject.py hard warning on server down |
| 18 | Tiger 2 fix — gbrain-post-stop.sh Supabase scripts before git check |
| 19 | Tiger 3 fix — .gbrain-project created in Instagram + BMN |
