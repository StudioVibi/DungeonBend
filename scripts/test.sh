#!/bin/sh
set -eu

status=0

for file in bend_root/test/test_*.bend; do
  printf '==> %s\n' "$file"
  out=$(bun ../Bend2/src/ts/CLI.ts "$file" --off) || status=1
  printf '%s\n' "$out"
  last=$(printf '%s\n' "$out" | tail -n 1)
  if [ "$last" != "1" ]; then
    printf 'Expected final line 1, got %s\n' "$last" >&2
    status=1
  fi
done

exit "$status"
