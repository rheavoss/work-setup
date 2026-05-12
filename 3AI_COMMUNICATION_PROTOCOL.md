# 3-AI Communication Protocol — Audit + FAANG Upgrade Request
**Date:** 2026-05-12
**Author:** Claude Code (from source files — not memory)
**For:** Grok (research authority) — critique + FAANG-level redesign
**Sources:** `90_protocols/grok_inbox_outbox_sop`, `90_protocols/hybrid_workflow`, `90_protocols/gbrain_communication_sop` (all G.Brain pages, read verbatim)

---

## SECTION 1 — HOW IT ACTUALLY WORKS TODAY

### The GitHub Bridge (Core Mechanic)
Grok has NO direct filesystem access and NO G.Brain MCP access. Grok reads everything via **raw GitHub URLs**. Claude and Antigravity write files → push to GitHub → CEO shares raw URL with Grok.

```
Claude/Antigravity  →  [writes file]  →  git push  →  GitHub (raw URL)  →  Grok reads
                                                              ↑
                                                    CEO bridges the URL
```

---

### File Map (from gbrain_communication_sop — quoted verbatim)

| File | Path | Written by | Read by | Purpose |
|------|------|-----------|---------|---------|
| Grok Brain | `99_grok_brain/grok_brain_summary.md` | Claude (Stop hook) | Grok (GitHub raw URL) | Live project state — single source of truth for Grok |
| Grok Inbox | `90_protocols/gbrain_handoffs/GROK_INBOX.md` | Claude | Grok (CEO shares URL or pastes) | Claude's research questions queued for Grok |
| Grok Outbox | `90_protocols/gbrain_handoffs/GROK_OUTBOX.md` | Claude + Grok | Each other (CEO bridge) | Handoffs, responses, status in both directions |
| Claude Inbox | `90_protocols/gbrain_handoffs/CLAUDE_INBOX.md` | Grok (via CEO paste) | Claude | Grok's specs and tasks for Claude to execute |
| Antigravity Inbox | `90_protocols/gbrain_handoffs/ANTIGRAVITY_INBOX.md` | Claude | Antigravity | Claude's tasks for Antigravity to execute |
| RALPH Checklist | `90_protocols/gbrain_handoffs/RALPH_CHECKLIST.md` | Grok | Grok | Governance gates Grok enforces before every answer |

**GitHub account for pushes:** `rheavoss`
**Branch discrepancy:** `grok_inbox_outbox_sop` says `dev` branch; `gbrain_communication_sop` says `main` with URL `https://raw.githubusercontent.com/rheavoss/virtual-influencer-studio/main/...` — needs resolution.

---

### Full Task Flow (from hybrid_workflow — quoted verbatim)

```
1. Task → Grok (Research Gate)
2. Grok → GROK_OUTBOX.md → Claude reads
3. Claude writes spec → CLAUDE_INBOX.md
4. Antigravity executes → writes result to ANTIGRAVITY_INBOX.md
5. Grok verifies live → updates RALPH_CHECKLIST.md + GROK_OUTBOX.md
6. Only after Grok sign-off → commit & push
Any error → STOP and ping Grok immediately.
```

### Research Request Flow (Claude → Grok, from gbrain_communication_sop)

```
Claude writes GROK_INBOX.md
    → gh auth switch --user rheavoss
    → git add + commit + push
    → CEO shares raw GitHub URL with Grok
    → Grok researches (RALPH gates)
    → CEO pastes Grok answer back to Claude
    → Claude saves to GROK_OUTBOX.md
    → Claude clears resolved items from GROK_INBOX.md
```

### RALPH Gates (Grok's mandatory pre-answer checklist)

| Gate | What it enforces |
|------|-----------------|
| Van Gate | Grok runs live web search — no training memory |
| Document Gate | Grok reads all relevant files before answering |
| Iron Rule | Grok does not self-verify — CEO/Claude confirms |
| Live verification | Conclusions match real current data |
| CEO sign-off | No execution without CEO approval |

---

## SECTION 2 — CURRENT GAPS (What's Missing or Broken)

### Gap 1 — No cross-project protocol
All file paths reference one project repo (`virtual-influencer-studio`). 13 projects exist. Job-search, Chart, ceo-magazine, Fin, task-tracker have no equivalent `99_grok_brain/` or `90_protocols/gbrain_handoffs/` structure. Grok has no visibility into failures on these projects.

### Gap 2 — CEO is the only bridge
Every Grok interaction requires CEO to:
1. Receive raw GitHub URL from Claude
2. Open URL in browser
3. Copy to Grok
4. Copy Grok response back to Claude

~5 actions per research request. High friction, breaks async flow.

### Gap 3 — Antigravity has no outbox
Antigravity can READ `ANTIGRAVITY_INBOX.md` (tasks from Claude). But Antigravity has no canonical file to write RESULTS back to Claude. Claude → Antigravity is one-way in current protocol.

### Gap 4 — No failure memory in the pipeline
`failure_patterns` table (proposed by Grok v2) doesn't exist yet. Grok reads `grok_brain_summary.md` for project state but has NO visibility into Claude's or Antigravity's failure history before answering. Every Grok interaction starts cold on past errors.

### Gap 5 — Branch conflict
`dev` vs `main` — two protocol docs disagree. Unclear which branch Grok is reading from. Stale data risk if wrong branch.

### Gap 6 — No inference session gate
Grok's RALPH gates protect strategic decisions. Inference sessions (ComfyUI batches) have no equivalent gate. May 8 Full Day Loss (₹239) happened during an inference session — no gate existed to force reading Grok inbox first.

### Gap 7 — Grok Brain is per-project, not cross-project
`grok_brain_summary.md` (updated by Stop hook) is scoped to one project repo. Grok has no view of CEO's current priorities across all 13 projects.

---

## SECTION 3 — REQUEST TO GROK

### Context
We have a 3-AI system (Claude Code + Grok + Antigravity/Gemini) across 13 projects. The current communication protocol works for one project (Instagram) but breaks down across the full setup. CEO is a non-technical solo operator. Every extra step in the protocol = chance of error or skip.

We need a **FAANG-level async communication design** that:
- Eliminates copy-paste as the bridge mechanism (or minimizes it to one step)
- Gives Grok visibility into failure history before answering
- Gives Claude visibility into Antigravity's results after execution
- Scales across all 13 projects without per-project duplication
- Works on macOS Monterey 8GB Intel without new heavy deps
- Is feasible for a solo non-technical CEO to operate

### Specific Questions for Grok

**Q1 — Cross-project Grok Brain**
`grok_brain_summary.md` exists in one project repo. Should there be a master cross-project Grok Brain? Where does it live? How does Claude maintain it across 13 projects without a 13-file mess?

**Q2 — Antigravity result loop**
Antigravity executes tasks from `ANTIGRAVITY_INBOX.md`. Where does Antigravity write results so Claude can read them without CEO bridging? Is `ANTIGRAVITY_OUTBOX.md` the right pattern, or should Antigravity update a shared file Claude polls?

**Q3 — Failure memory in the pipeline**
When Grok reads an inbox request, it has zero context on past Claude/Antigravity failures. Should `grok_brain_summary.md` include a compact failure digest (top 5 active patterns + last cost)? What format keeps it under the noise threshold?

**Q4 — Reducing CEO bridge steps**
Every Grok interaction: Claude writes file → push → CEO gets URL → CEO copies to Grok → CEO copies back. 5 steps. FAANG teams use webhooks or async message buses. What's the minimal feasible version of this for an 8GB Mac with an existing Supabase instance? Is a Supabase-to-webhook bridge viable here?

**Q5 — Branch conflict resolution**
`grok_inbox_outbox_sop` says `dev` branch. `gbrain_communication_sop` says `main` branch. Which should be canonical, and why?

**Q6 — 13-project scaling**
Current protocol assumes one repo. Realistically, should there be one shared `ai-comms` repo for all handoffs, or per-project with a master index? What's the FAANG model for multi-repo AI agent coordination (e.g. how Cursor/Devin handle multi-repo)?

**Q7 — RALPH gates for inference sessions**
RALPH gates protect research answers. May 8 Full Day Loss happened in inference — Grok inbox existed but Claude never read it before starting. How do you gate "read Grok inbox before first inference action" without blocking every Bash command? Exact hook design needed.

---

## SECTION 4 — HOW TO SHARE THIS WITH GROK

**Step 1:** Claude pushes this file to GitHub:
```bash
gh auth switch --user rheavoss
git add "Work Setup/3AI_COMMUNICATION_PROTOCOL.md"
git commit -m "docs: 3-AI protocol audit + FAANG upgrade request for Grok"
git push
```

**Step 2:** CEO shares raw GitHub URL with Grok.

**Step 3:** Tell Grok: *"Read this file. It is a protocol audit written from source docs. Answer the 7 questions in Section 3 with exact, implementable designs. No advisory fluff. Grok's answer gets QA'd by Claude before anything touches disk."*

**Step 4:** Paste Grok's response back to Claude for QA.
