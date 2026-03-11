# DungeonBend

Pure Bend2 prototype for the dungeon crawler. The game now lives under [`bend_root/`](./bend_root) and the old JS/Vite host was removed.

## Requirements

- [Bun](https://bun.sh)
- A sibling checkout of `Bend2` at `../Bend2`

## Workspace Layout

- `bend_root/dungeon/logic`: game rules, board, combat, deck, run and meta state
- `bend_root/dungeon/app`: Bend `App` state, events, render tree and CSS string
- `bend_root/dungeon/data`: compiled game balance data
- `bend_root/test`: Bend regression tests

## Commands

```bash
bun run check
bun run test
bun run build
```

- `bun run check`: Bend typecheck for the app via `--to-chk`
- `bun run test`: runs the Bend regression suite
- `bun run build`: generates `dist/index.html`, `dist/dungeon.html` and static assets

## Current Constraints

- Keyboard input is the supported play path right now: Arrow Keys and WASD.
- `index.html` and `dungeon.html` are separated on purpose as a workaround for the current Bend2 same-root screen swap bug.
- Swipe/touch, browser persistence and one-step local asset serving remain Bend2 demands.
- The balance tool is intentionally out of this deliverable.

See [`BEND2_DEMANDS.md`](./BEND2_DEMANDS.md) for the open requests to the Bend2 team.
