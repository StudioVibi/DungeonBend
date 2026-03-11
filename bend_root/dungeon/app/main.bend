import /dungeon/data/default_meta as default_meta
import /dungeon/data/initial_seed as initial_seed
import /dungeon/app/DungeonState
import /dungeon/app/DungeonEvent
import /dungeon/app/render as render
import /dungeon/app/on_event as on_event

main : App =
  app{
    DungeonState,
    DungeonEvent,
    hub{default_meta(), initial_seed()},
    render,
    on_event
  }
