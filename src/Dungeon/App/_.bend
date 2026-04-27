import App/Cmd/store_get as store_get
import Dungeon/DungeonState as DungeonState
import Dungeon/DungeonEvent as DungeonEvent
import Dungeon/initial_game as initial_game
import Dungeon/default_ui as default_ui
import Dungeon/_parse_meta as _parse_meta
init : App/Update(DungeonState, DungeonEvent) =
  update{dungeon{initial_game(), default_ui()}, store_get(DungeonEvent, "dungeon_meta", _parse_meta, no_save{})}
