import /App/
import /Dungeon/save_to_string as save_to_string
import /Dungeon/DungeonEvent as DungeonEvent
import /Dungeon/DungeonState as DungeonState

def finalize_update(prev_state: DungeonState, next_state: DungeonState) -> App/Update(DungeonState, DungeonEvent):
  update{next_state, store_set{"dungeon_meta", save_to_string(next_state)}}
