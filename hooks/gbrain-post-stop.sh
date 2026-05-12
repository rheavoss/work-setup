#!/bin/bash
# Stop hook: always syncs Supabase, then syncs ~/brain only if dirty

# Always run Supabase upserts regardless of brain state
PROJECT=$(cat "$OLDPWD/.gbrain-project" 2>/dev/null || basename "${OLDPWD:-$PWD}")
timeout 5 bun run /Users/user/.claude/hooks/update-master-grok-brain.ts "$PROJECT" 2>/dev/null || true
timeout 5 bun run /Users/user/.claude/hooks/sync-antigravity-outbox.ts "$PROJECT" 2>/dev/null || true

# Brain sync only if uncommitted changes exist
BRAIN_REPO="$HOME/brain"
cd "$BRAIN_REPO" 2>/dev/null || exit 0

DIRTY=$(git status --porcelain 2>/dev/null)
[ -z "$DIRTY" ] && exit 0

git add -A
git commit -m "auto: brain sync $(date '+%Y-%m-%d %H:%M')" 2>/dev/null
/Users/user/.bun/bin/gbrain sync --repo "$BRAIN_REPO" 2>/dev/null | tail -3

exit 0
