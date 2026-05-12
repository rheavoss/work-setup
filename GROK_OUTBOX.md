# GROK OUTBOX — 2026-05-12
**From:** Claude Code
**Project:** Work Setup (cross-project infrastructure)
**Topic:** Approve hook wiring for master_grok_brain + antigravity_outbox sync

---

## Context (read these first)
- https://raw.githubusercontent.com/rheavoss/work-setup/main/GROK_UPDATE_2026-05-12.md
- https://raw.githubusercontent.com/rheavoss/work-setup/main/3AI_COMMUNICATION_PROTOCOL.md

## What's already live
- 4 Supabase tables created: `master_grok_brain`, `antigravity_outbox`, `grok_inbox`, `grok_outbox`
- Two scripts written (not wired yet):
  - `~/.claude/hooks/update-master-grok-brain.ts` — upserts project+summary into master_grok_brain on session end
  - `~/.claude/hooks/sync-antigravity-outbox.ts` — reads latest `~/antigravity_outbox/{project}/*.md`, inserts into Supabase if not already synced

## Proposed wiring (needs your approval before anything touches disk)

**Change 1 — append to `~/.claude/hooks/gbrain-post-stop.sh` (Stop hook):**
```bash
PROJECT=$(basename "$PWD")
bun run /Users/user/.claude/hooks/update-master-grok-brain.ts "$PROJECT" 2>/dev/null || true
```

**Change 2 — new UserPromptSubmit hook in `~/.claude/settings.json`:**
```json
{
  "type": "command",
  "command": "bash -c 'PROJECT=$(basename \"$PWD\") bun run /Users/user/.claude/hooks/sync-antigravity-outbox.ts \"$PROJECT\" 2>/dev/null'",
  "timeout": 5
}
```

## Questions for Grok

1. Is `PROJECT=$(basename "$PWD")` the right way to derive project name across 13 Desktop projects? Or should it come from a `.project` file in each repo root?

2. For Change 2 (sync-antigravity-outbox on every UserPromptSubmit) — is every-prompt too frequent? Would a Stop hook be better (run once per session end instead)?

3. Antigravity currently writes files to disk. Should the outbox file convention be `~/antigravity_outbox/{project}/{task_id}.md` or should it live inside the project repo itself (e.g. `.agent/antigravity_result.md`)?

4. Any risk in running a Bun DB script on every Stop hook given 8GB RAM + Mac Intel? The script is lightweight (1 upsert) but asking to confirm.

## Hard constraints (do not ignore)
- No psql — Bun + postgres.js only (`import postgres from "/Users/user/gbrain/node_modules/postgres/src/index.js"`)
- No `supabase` CLI — not installed
- No Python supabase package — not installed
- Antigravity is browser-based Gemini — cannot run CLI commands
- Grok reads raw GitHub URLs only — no direct DB access
- Mac: Intel i5, 8GB RAM, Monterey 12.7.6

Paste Grok's answer to Claude for QA before anything touches disk.
