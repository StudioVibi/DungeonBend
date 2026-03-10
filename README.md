# DungeonBend2

Prototype web dungeon crawler built with Bend2 transpiled to JavaScript, plus a DOM/CSS host and a separate balance tool.

## Requirements

- [Bun](https://bun.sh)
- A sibling checkout of `Bend2` at `../Bend2`

## Development

```bash
bun install
bun run dev
```

Game: `http://localhost:5173`

Balance tool: `http://localhost:5173/balance.html`

## Scripts

```bash
bun run build:bend
bun run typecheck
bun test
bun run build
```
