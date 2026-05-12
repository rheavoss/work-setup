# GROK OUTBOX — 2026-05-12 (Pre-Mortem Request)
**From:** Claude Code
**Project:** Work Setup — AI Infrastructure
**Ask:** Run pre-mortem on full infrastructure. Try to break it. Green flag = project closes.

---

## Full Current State (verified from disk this commit)

### Hooks wired (`~/.claude/settings.json`)

| Event | Hook | Purpose |
|---|---|---|
| SessionStart | start-failure-oracle.sh | Auto-start Bun server port 3133 if not running |
| UserPromptSubmit | gbrain-user-prompt.sh | G.Brain context injection (score ≥0.75) |
| UserPromptSubmit | failure-oracle-inject.py | Query Supabase failure_patterns → inject top 5 violations + inference gate (blocks lora/comfy/vastai if no .gates/INFERENCE_APPROVED.md) |
| UserPromptSubmit | force-karpathy-read-first.sh | Pattern #15 hard reminder |
| UserPromptSubmit | repeat-detection.py | Jaccard trigram 60% — flags repeated prompts same session |
| PreToolUse Bash | grok-gate-enforcer.sh | Blocks system installs without Grok approval |
| PreToolUse Bash | vast-instance-quality-gate.sh | Vast.ai quality gate |
| PreToolUse Bash | new-tool-install-gate.sh | Blocks new tool installs |
| PreToolUse Bash/Write/Edit | gate-approval.sh | 15s timeout approval gate |
| PreToolUse Write/Edit | pattern15-read-before-write.sh | Forces read before write |
| PostToolUse Bash/Read/Grep/Glob | status-evidence-enforcer.sh | Blocks false status claims |
| PostToolUse Bash | repeat-failure-guard.sh | Guards repeated failures |
| PostToolUse Write/Edit | pattern15-gate-cleanup.sh | Cleanup after write gate |
| Stop | gbrain-post-stop.sh | Brain sync + upsert master_grok_brain + sync antigravity_outbox |

### Supabase tables (same DB as G.Brain)

| Table | Purpose |
|---|---|
| failure_patterns | 17 patterns P01–P17, GIN-indexed keywords, cost_inr, recurrence |
| master_grok_brain | Cross-project state, UNIQUE per project, updated every Stop |
| antigravity_outbox | Antigravity file results synced from ~/antigravity_outbox/{project}/ |
| grok_inbox | Claude questions queued for Grok |
| grok_outbox | Grok answers for Claude |

### failure-oracle server
- Bun HTTP port 3133, auto-started on SessionStart
- Queries failure_patterns by keyword overlap (GIN &&)
- Returns top 5 by cost_inr DESC, recurrence DESC
- Injected as additionalContext before every Claude response
- Fails open if server down (urllib.error.URLError caught)

### Scripts (`~/.claude/hooks/`)
- `update-master-grok-brain.ts` — upserts project+git-log summary on Stop
- `sync-antigravity-outbox.ts` — reads ~/antigravity_outbox/{project}/*.md, inserts new rows only
- `repeat-detection.py` — session-scoped Jaccard, 60% threshold
- `failure-oracle-inject.py` — oracle query + inference gate

### Project name derivation (Stop hook)
```bash
PROJECT=$(cat "$OLDPWD/.gbrain-project" 2>/dev/null || basename "${OLDPWD:-$PWD}")
```
`.gbrain-project` exists in: work-setup, fin, indiabulls, health, chart, ceo-magazine, task-tracker.

### Master-Knowledge-Vault (`~/Master-Knowledge-Vault/`)
- 16 PAI dirs: AUTO, BOOKMARKS, DATA, KNOWLEDGE, PROJECT, RAW, REFERENCE, RELATIONSHIP, RESEARCH, SCRATCHPAD, SKILLS, VERIFICATION, WISDOM, WORK, log, wiki
- CLAUDE.md: PAI Algorithm v6.3.0 VERIFY gate, correct tier names
- Open in Obsidian ✅

### Repo: `rheavoss/work-setup` — public, main branch

---

## Pre-Mortem Request

**Scenario:** 14 days from now. Infrastructure failed. Failures still at 3.7/day or worse. What went wrong?

Classify each risk: Tiger (Launch-Blocking / Fast-Follow / Track) | Paper Tiger | Elephant

**Attack vectors to stress-test:**
1. Port 3133 down — oracle not running. Hooks fail open. Does Claude get zero friction on bad prompts?
2. gbrain-post-stop.sh does `cd ~/brain` first — if brain repo is clean, script exits line 9 before Supabase scripts run. Is master_grok_brain never updated on clean sessions?
3. Pattern #15 — no PreResponse hook. Oracle is advisory only. What's the real ceiling?
4. Inference gate keywords: `inference, comfyui, comfy, lora, vast.ai, vastai, training run, batch generate` — too narrow? Too broad?
5. Jaccard 60% — variants like "retrain" vs "re-train" or typos — does it miss them?
6. .gbrain-project missing in 6 of 13 projects — basename fallback gives wrong name (e.g. "job search" → "search"). master_grok_brain gets garbage rows.
7. Antigravity writes nothing → sync-antigravity-outbox.ts runs silently every session. Wasted cycles?
8. 4 UserPromptSubmit hooks + oracle HTTP call — cumulative latency on 8GB Intel Mac?

## Constraints
- Bun + postgres.js only (no psql, supabase CLI, Python supabase)
- Grok reads raw GitHub URLs only — no direct DB
- Antigravity = browser-based Gemini, writes files only
- Mac: Intel i5, 8GB RAM, Monterey 12.7.6
- No new packages

Green flag = no Launch-Blocking Tigers. If Tigers found → give exact fix, Claude implements.
Paste response to Claude for QA before anything touches disk.
