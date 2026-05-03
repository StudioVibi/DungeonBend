import Dungeon/Meta as Meta
import Dungeon/Scene as Scene
import Dungeon/UiState as UiState
import Dungeon/DungeonEvent as DungeonEvent
import Dungeon/DungeonState as DungeonState
import Dungeon/config as config
import Dungeon/default_ui as default_ui
import Dungeon/App/state_helpers/_state as _state
import Dungeon/App/state_helpers/_start as _start
import Dungeon/hero_helpers/normalize_hero_ref as normalize_hero_ref
import Dungeon/profile_helpers/selected_hero as selected_hero

def update_setup(evt: DungeonEvent, meta_state: Meta, next_seed_value: U32, ui_value: UiState) -> DungeonState:
  match evt:
    case start{}:
      _start(meta_state, next_seed_value)
    case open_character_select{}:
      _state(meta_state, character_select{normalize_hero_ref(config(), selected_hero(meta_state))}, next_seed_value, default_ui())
    case open_ultimate_preview{}:
      _state(meta_state, ultimate_preview{ultimate_preview_idle{}}, next_seed_value, default_ui())
    case open_boosters{}:
      _state(meta_state, boosters{no_pack_reward{}, 0, booster_return_setup{}}, next_seed_value, default_ui())
    case _:
      _state(meta_state, setup{}, next_seed_value, ui_value)
