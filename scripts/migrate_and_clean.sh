#!/usr/bin/env bash
set -euo pipefail

echo "🚀 1) Nuke old workspaces…"
rm -rf ~/google-cloud-sdk \
       ~/PassiveCore-Dashboard* \
       ~/product-sync \
       ~/aws-cli \
       ~/analytics-reporter \
       ~/analytics-reporter-infra \
       ~/dealsGenerator-fn \
       ~/bin \
       ~/passivecore-dashboard-old

echo "📦 2) Prune node_modules, Docker & caches…"
find ~ -maxdepth 2 -type d -name node_modules -prune -exec rm -rf {} +
docker system prune -af
npm cache clean --force
yarn cache clean 2>/dev/null || true

echo "📊 3) Show you’re under ~80%:"
du -sh ~/* 2>/dev/null | sort -h | tail -n 10

echo "🔀 4) Re-import only what you need…"
# adjust these OLDx paths if your legacy code lives elsewhere
OLD1=~/analytics-reporter
OLD2=~/product-sync
OLD3=~/supabase

cp -R "$OLD1"/src/app   src/app-legacy-1
cp -R "$OLD2"/src/app   src/app-legacy-2
cp -R "$OLD3"/migrations   supabase/migrations-legacy
cp "$OLD1"/cloudbuild.yaml  ./
cp "$OLD2"/scan.js          ./
cp "$OLD2"/server.js        ./

echo "✅ Done! Now run \`npm install && npm run dev\`"
