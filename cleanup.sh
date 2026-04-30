#!/bin/bash
# Mac Cleanup Script — run weekly
# MacBook Air 2015, 113GB SSD, macOS Monterey 12.7.6
# Usage: bash cleanup.sh          → dry run (preview only)
#        bash cleanup.sh --delete  → actually delete

DRY_RUN=true
TOTAL=0

if [[ "$1" == "--delete" ]]; then
  DRY_RUN=false
  echo "🗑️  LIVE MODE — files will be deleted"
else
  echo "👀 DRY RUN — nothing will be deleted (run with --delete to execute)"
fi

echo ""
echo "=============================="
echo " MAC CLEANUP — $(date '+%Y-%m-%d')"
echo "=============================="

free_before=$(df -h / | awk 'NR==2 {print $4}')
echo "Free space before: $free_before"
echo ""

delete_item() {
  local path="$1"
  local label="$2"
  if [ -e "$path" ]; then
    size=$(du -sh "$path" 2>/dev/null | cut -f1)
    echo "  [$size] $label"
    echo "         $path"
    if [ "$DRY_RUN" = false ]; then
      rm -rf "$path"
      echo "         → DELETED"
    fi
  fi
}

# ─── SECTION 1: System & App Caches ───────────────────────────────────────────
echo "── System & App Caches ──"
delete_item "$HOME/Library/Caches" "User app caches (macOS rebuilds automatically)"
echo ""

# ─── SECTION 2: Package Manager Caches ────────────────────────────────────────
echo "── Package Manager Caches ──"
delete_item "$HOME/.npm" "npm cache"
delete_item "$HOME/.bun/install/cache" "bun install cache (keeps bun binary)"
echo ""

# ─── SECTION 3: Cold Project Build Caches (.next folders) ─────────────────────
echo "── Cold Project Build Caches (.next) ──"
COLD_PROJECTS=(
  "/Users/user/Desktop/antigravity-directory"
  "/Users/user/Desktop/ceo-magazine"
  "/Users/user/Desktop/Fin"
  "/Users/user/Desktop/task-tracker"
  "/Users/user/Desktop/Mac issue/apple-legal-dashboard"
)
for proj in "${COLD_PROJECTS[@]}"; do
  find "$proj" -name ".next" -maxdepth 3 2>/dev/null | while read d; do
    delete_item "$d" ".next build cache ($(basename "$(dirname "$d")"))"
  done
done
echo ""

# ─── SECTION 4: Cold Project node_modules ─────────────────────────────────────
echo "── Cold Project node_modules ──"
COLD_NODE_MODULES=(
  "/Users/user/Desktop/ceo-magazine/node_modules"
  "/Users/user/Desktop/Mac issue/apple-legal-dashboard/node_modules"
  "/Users/user/Desktop/task-tracker/node_modules"
)
for nm in "${COLD_NODE_MODULES[@]}"; do
  delete_item "$nm" "node_modules ($(basename "$(dirname "$nm")"))"
done
echo ""

# ─── SECTION 5: Backup / Junk Folders ─────────────────────────────────────────
echo "── Backup & Junk Folders ──"
delete_item "/Users/user/Desktop/Instagram/.gbrain.bak-20260430" "G.Brain backup folder (Instagram)"
echo ""

# ─── SECTION 6: Trash ─────────────────────────────────────────────────────────
echo "── Trash ──"
if [ "$DRY_RUN" = false ]; then
  osascript -e 'tell app "Finder" to empty trash' 2>/dev/null
  echo "  Trash emptied"
else
  trash_size=$(du -sh "$HOME/.Trash" 2>/dev/null | cut -f1)
  echo "  [${trash_size:-0}] Trash (would empty)"
fi
echo ""

# ─── SUMMARY ──────────────────────────────────────────────────────────────────
echo "=============================="
if [ "$DRY_RUN" = true ]; then
  echo "DRY RUN complete. Run with --delete to free the space above."
else
  free_after=$(df -h / | awk 'NR==2 {print $4}')
  echo "Cleanup complete."
  echo "Free space before: $free_before"
  echo "Free space after:  $free_after"
fi
echo "=============================="
