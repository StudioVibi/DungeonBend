# DungeonBend Build Restore Notes

Snapshot updated on `2026-04-27` against sibling `../Bend2` at commit
`289c0d6d9`.

## Minimum Goal

The immediate requirement is narrower than the original migration track:

- `./scripts/build.sh` must succeed again.
- The build must produce `dist/index.html`.
- Compatibility must live inside `DungeonBend`.
- The local `../Bend2` checkout must remain untouched.

## Current Strategy

The repo no longer treats `Bend2/base` as the first unblocker.

Instead, the active restore path is:

- compile against `../Bend2/old_base`
- keep the compatibility bridge local to [scripts/build.ts](/Users/isabellaherman/Documents/HOC/DungeonBend/scripts/build.ts:1)
- stage a temporary source tree under `/tmp`
- normalize legacy syntax only in the staged tree
- preserve the current HTML runtime patches and asset copy flow

This is a build-restore strategy, not the final language migration strategy.

## What The Bridge Now Has To Cover

The Bend2 parser and loader currently disagree with the legacy DungeonBend
layout in three concrete ways:

1. Alias-less imports break parsing when imports are stacked.
Example:
- `import App`
- `import HTML`
- `import Midum/Layout/Align`

Those need staged normalization to:
- `import App as App`
- `import HTML as HTML`
- `import Midum/Layout/Align as Align`

2. Legacy multiline list literals are missing commas for the current parser.
Examples:
- [src/Midum/Internal/DOM/Layout/_.bend](/Users/isabellaherman/Documents/HOC/DungeonBend/src/Midum/Internal/DOM/Layout/_.bend:203)
- [src/Dungeon/UltimateCutins/_render_ultimate_cutin.bend](/Users/isabellaherman/Documents/HOC/DungeonBend/src/Dungeon/UltimateCutins/_render_ultimate_cutin.bend:14)

3. The stock Bend2 loader does not understand the legacy ownership model of
this project.
Examples:
- `Dungeon/DungeonState` is defined inside [src/Dungeon/_.bend](/Users/isabellaherman/Documents/HOC/DungeonBend/src/Dungeon/_.bend:291)
- `Dungeon/Content` is a module path backed by [src/Dungeon/Content/_.bend](/Users/isabellaherman/Documents/HOC/DungeonBend/src/Dungeon/Content/_.bend:1)
- `Midum/Layout` is a module path backed by [src/Midum/Layout/_.bend](/Users/isabellaherman/Documents/HOC/DungeonBend/src/Midum/Layout/_.bend:1)

Because of that, import resolution has to be driven by an explicit owner index,
not by the current `bend/src/Lang.ts` path resolver.

## Build Contract

The active build contract is:

- [scripts/build.sh](/Users/isabellaherman/Documents/HOC/DungeonBend/scripts/build.sh:1)
  remains the entrypoint
- [scripts/build.ts](/Users/isabellaherman/Documents/HOC/DungeonBend/scripts/build.ts:1)
  owns staging, normalization, owner indexing, checking, HTML generation, and
  post-processing
- [scripts/dungeon-data.ts](/Users/isabellaherman/Documents/HOC/DungeonBend/scripts/dungeon-data.ts:1)
  stays the source of generated Bend code, but generation happens against the
  staged workspace instead of the tracked tree
- assets still copy from `assets/` to the chosen output directory

Tracked source is not required to be fully rewritten to the current Bend2
surface for this milestone.

## Deferred Work

These are explicitly later phases now:

- porting the game from `old_base` to `base`
- deleting the compatibility bridge
- removing staged syntax normalization
- revalidating browser behavior beyond a basic build restore

Once the build is back, the next milestone becomes browser smoke-checking:

- app boots
- first screen renders
- keyboard patch still works
- no regression in asset loading
