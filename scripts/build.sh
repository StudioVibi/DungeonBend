#!/bin/sh
set -eu

out_dir="${OUT_DIR:-dist}"
out_html="$out_dir/index.html"
ui_test_html="$out_dir/ui-test/index.html"
out_assets="$out_dir/assets"
bend_dir="${BEND_DIR:-../Bend2}"

mkdir -p "$out_assets"
mkdir -p "$out_dir/ui-test"

bun -e 'import { generateDungeonConfig } from "./scripts/dungeon-data.ts"; await generateDungeonConfig(process.cwd());'
bun scripts/generate-dungeon-view-css.ts

if [ -f "$bend_dir/bend/src/Bend.ts" ] || [ -f "$bend_dir/bend-ts/src/Bend.ts" ]; then
  bun scripts/build.ts src/main.bend "$out_html"
  bun scripts/build.ts src/ui_test.bend "$ui_test_html" ui_test/main
elif command -v bend >/dev/null 2>&1; then
  bend src/main.bend --to-web > "$out_html"
  echo "The global bend CLI path cannot build named alternate mains yet. Use local Bend2 via BEND_DIR for /ui-test." >&2
  exit 1
else
  echo "Bend2 CLI not found. Set BEND_DIR, install bend globally, or keep ../Bend2 next to this repo with bend/src or bend-ts/src." >&2
  exit 1
fi

cp -R assets/. "$out_assets"/
touch "$out_dir/.nojekyll"
printf '%s\n' "Built $out_html"
printf '%s\n' "Built $ui_test_html"
