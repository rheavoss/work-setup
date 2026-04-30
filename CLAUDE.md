# Work Setup — AI Infrastructure Command Center
> Last updated: 2026-04-30 | This is Suraj's infrastructure workspace

## Purpose
This folder is the command center for all AI infrastructure across Suraj's 13 Desktop projects.
Open Claude Code HERE for: hooks, G.Brain, MCP servers, cleanup, cross-project setup.
Do NOT use Chart/ for infrastructure — Chart = astrology tools only.

---

## Infrastructure Built (2026-04-30 Session)

### Global Hooks (`~/.claude/hooks/`)
| Hook | File | Trigger | Purpose |
|------|------|---------|---------|
| G.Brain query | `gbrain-user-prompt.sh` | UserPromptSubmit | Injects brain context (score ≥0.60 filter) |
| G.Brain pre-tool | `gbrain-pre-tool.sh` | PreToolUse Read/Grep/Glob | Injects context before file reads |
| G.Brain auto-sync | `gbrain-post-stop.sh` | Stop | Auto-commits + syncs brain on session end |
| Approach verification | `approach-verification.sh` | PreToolUse Write/Edit/Bash | Forces Claude to state intent before acting |
| Write gate | `write-edit-warning.sh` | PreToolUse Write/Edit | Warns before file edits |
| Grok enforcer | `grok-gate-enforcer.sh` | PreToolUse Bash | Blocks system changes without Grok approval |
| Post-gen audit | `post-generation-audit-reminder.sh` | PostToolUse Bash | Reminds to audit after generation |

### G.Brain (`~/brain/` repo)
- Format: Compiled Truth (above `---`) + Timeline (append-only, below)
- Sync: auto on session end via gbrain-post-stop.sh
- Pages: instagram, antigravity-directory, ceo-magazine, fin, task-tracker, claude-failure-patterns, resolver
- Binary: `~/.bun/bin/gbrain` · Config: `~/.gbrain/`

### MCP Servers (`~/.claude.json`)
- **gbrain**: G.Brain knowledge graph queries
- **token-optimizer**: Local build at `~/token-optimizer-mcp/dist/server/index.js`

### Ralph Protocol
- v23.0 installed in: antigravity-directory, ceo-magazine, Fin, task-tracker
- Location per project: `.agent/RALPH_PROTOCOL.md`

---

## Weekly Mac Cleanup

**Script**: `cleanup.sh`
**Run**:
```bash
bash cleanup.sh           # dry run — preview what will be deleted
bash cleanup.sh --delete  # live — actually delete
```

**What it cleans:**
- `~/Library/Caches` (~8.7 GB — safe, macOS rebuilds)
- `.npm` cache (~1 GB)
- `.bun/install/cache` (keeps binary)
- `.next` build caches in cold projects
- `node_modules` in cold projects (ceo-magazine, Mac issue, task-tracker)
- Instagram `.gbrain.bak` backup folder
- Trash

**Expected recovery: ~13–14 GB per run** on a 113 GB SSD.

**MacBook specs**: Air 7,2 · Intel i5 1.8GHz · 8GB RAM · macOS 12.7.6 Monterey (max)

---

## Key Global Files
| File | Purpose |
|------|---------|
| `~/.claude/settings.json` | Hooks wiring, statusline, effortLevel |
| `~/.claude.json` | MCP servers (gbrain, token-optimizer) |
| `~/.claude/CLAUDE.md` | Global rules: Grok gate, approach verification |
| `~/brain/` | Knowledge graph repo (git) |
| `~/token-optimizer-mcp/` | Token optimizer MCP (local build) |

## Rules for This Folder
- Read this file + relevant hook files before modifying any global infrastructure
- Any change to `~/.claude/settings.json` or `~/.claude.json` → Grok gate applies
- Test hooks with `echo '{"tool_name":"Bash","tool_input":{}}' | bash ~/.claude/hooks/approach-verification.sh`
- After hook changes → restart Claude Code to pick up
