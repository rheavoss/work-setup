# GROK OUTBOX — 2026-05-12 (Pattern #1 Inference Gate)
**From:** Claude Code
**Project:** Work Setup — AI Infrastructure
**Ask:** Design a hard gate that blocks inference session execution unless Grok inbox has been read. Claude implements after Grok approval.

---

## Problem

Pattern #1 (jump-to-execution without research) has 11 instances. 20 failures in the May 5–8 week alone. Root cause of both failure clusters:

- May 5 cluster (12 failures): LoraLoader missing from all submit scripts — wrote from memory without reading S0-06 workflow spec
- May 8 cluster (7 failures): All batches ran at wrong LoRA scale (0.75) — Grok inbox doc existed specifying 1.0–1.05, never read

The inference gate in `failure-oracle-inject.py` currently blocks prompts containing `lora, comfy, vastai` etc. unless `.gates/INFERENCE_APPROVED.md` exists. That gate works at the **prompt level**.

What's missing: a gate at the **execution level** — blocking actual Bash tool calls that submit inference jobs unless a Grok inbox read is confirmed for the current session.

---

## Proposed Gate Design (Claude's draft — needs Grok verification)

**Trigger:** PreToolUse Bash  
**Condition:** tool_input contains any of: `submit_v`, `runpod`, `vast`, `comfyui`, `python3 submit`, `bun run submit`  
**Block unless:** `.gates/GROK_INBOX_READ.md` exists in the current project dir  
**Block message:** "INFERENCE GATE — read all Grok inbox docs for this project first. Then create `.gates/GROK_INBOX_READ.md` with the key parameters confirmed."

**CEO creates `.gates/GROK_INBOX_READ.md` manually** after reading Grok inbox — same pattern as INFERENCE_APPROVED.md.

---

## Questions for Grok

1. Is this the right trigger layer (PreToolUse Bash keyword match) or is there a better interception point?
2. Should the gate check for `.gates/GROK_INBOX_READ.md` or should it check for a specific file per session (e.g. `.gates/GROK_INBOX_READ_{date}.md`) so it resets each session?
3. Any risk of false positives blocking legitimate Bash calls that aren't inference?
4. Is there a smarter keyword list than: `submit_v, runpod, vast, comfyui, python3 submit, bun run submit`?

---

## Constraints
- Bash hook only (no new packages, no Python packages beyond stdlib)
- Mac: Intel i5, 8GB RAM, Monterey 12.7.6
- Hook must fail open if gate file check errors
- Grok reads raw GitHub URLs only

## Current hook files for reference
- `https://raw.githubusercontent.com/rheavoss/work-setup/main/hooks/failure-oracle-inject.py` (inference prompt gate — existing)
- `https://raw.githubusercontent.com/rheavoss/work-setup/main/hooks/gbrain-post-stop.sh`

Green flag = Grok approves design → Claude writes the hook → wires to settings.json.
Paste response to Claude for QA before anything touches disk.
