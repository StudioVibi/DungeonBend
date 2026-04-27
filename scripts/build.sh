#!/bin/sh
set -eu

out_dir="${OUT_DIR:-dist}"
out_html="$out_dir/index.html"
out_assets="$out_dir/assets"

mkdir -p "$out_assets"

bun scripts/build.ts src/main.bend "$out_html"

cp -R assets/. "$out_assets"/
touch "$out_dir/.nojekyll"
printf '%s\n' "Built $out_html"
