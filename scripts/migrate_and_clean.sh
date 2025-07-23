#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="\$(pwd)"
declare -a LEGACY_BASES=(
  "\$HOME/legacy-all/passivecore-dashboard"
  "\$HOME/legacy-all/analytics-reporter"
  "\$HOME/legacy"
  "\$HOME/analytics-reporter"
)

echo "[1/4] Cleaning old workspaces..."
rm -rf "\$ROOT_DIR/workspaces"/* 2>/dev/null || true

echo "[2/4] Pruning caches & node_modules..."
find "\$ROOT_DIR" -type d \( -name "node_modules" -o -name ".cache" -o -name ".vercel" \) -prune -exec rm -rf {} +

echo "[3/4] Copying staged legacy code..."
for BASE in "\${LEGACY_BASES[@]}"; do
  if [ -d "\$BASE" ]; then
    for DIR in apps functions supabase/migrations src/supabase; do
      if [ -d "\$BASE/\$DIR" ]; then
        mkdir -p "\$ROOT_DIR/\$(dirname "\$DIR")"
        cp -a "\$BASE/\$DIR" "\$ROOT_DIR/\$DIR"
        echo "  • Copied \$DIR from \$BASE"
      fi
    done
  fi
done

echo "[4/4] (Optional) Bringing in recent files from legacy-all..."
if [ -d "\$HOME/legacy-all" ]; then
  find "\$HOME/legacy-all" -type f -mtime -30 -exec bash -c '
    for f; do
      rel="\${f#\$HOME/legacy-all/}"
      dest="\$ROOT_DIR/\$rel"
      mkdir -p "\$(dirname "\$dest")"
      cp -a "\$f" "\$dest"
      echo "  • Pulled recent file \$rel"
    done
  ' _ {} +
fi

echo "✅ Migration & cleanup complete."
