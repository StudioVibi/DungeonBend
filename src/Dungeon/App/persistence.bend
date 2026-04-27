import App
import App/Cmd/store_set as store_set
import Dungeon/save_to_string as save_to_string
import Dungeon/DungeonEvent as DungeonEvent
import Dungeon/DungeonState as DungeonState
def finalize_update(evt: DungeonEvent, prev_state: DungeonState, next_state: DungeonState) -> App/Update(DungeonState, DungeonEvent):
  match evt:
    case damage_tick{}:
      update{next_state, none{}}
    case _:
      update{next_state, store_set(DungeonEvent, "dungeon_meta", save_to_string(next_state), no_save{})}
