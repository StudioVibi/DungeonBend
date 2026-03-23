import /Dungeon/DungeonState as DungeonState
import /Dungeon/default_meta as default_meta
import /Dungeon/initial_seed as initial_seed
import /Dungeon/App/key_event
import /Dungeon/App/on_event

init : DungeonState =
  dungeon{default_meta(), idle_run{}, initial_seed(), 0, 0, 9, 0}
