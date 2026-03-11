#!/bin/sh
set -eu

menu_entry="bend_root/dungeon/app/main.bend"
run_entry="bend_root/dungeon/run/main.bend"

rm -rf dist
mkdir -p dist/assets
bun ../Bend2/src/ts/CLI.ts "$menu_entry" --to-web --off > dist/index.html
bun ../Bend2/src/ts/CLI.ts "$run_entry" --to-web --off > dist/dungeon.html
cp assets/* dist/assets/
