#!/bin/sh
set -eu

bun ../Bend2/src/ts/CLI.ts bend_root/dungeon/app/main.bend --to-chk --off > /dev/null
bun ../Bend2/src/ts/CLI.ts bend_root/dungeon/run/main.bend --to-chk --off > /dev/null
