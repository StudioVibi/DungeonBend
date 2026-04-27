import Dungeon/Meta as Meta
import Dungeon/HeroProfile as HeroProfile
import Dungeon/UiState as UiState
import Dungeon/DungeonEvent as DungeonEvent
import Dungeon/DungeonState as DungeonState
import Dungeon/config as config
import Dungeon/default_ui as default_ui
import Dungeon/App/state_helpers/_state as _state
import Dungeon/Run/upgrade_hero/upgrade_hero_ref as upgrade_hero_ref
import Dungeon/hero_helpers/next_hero_ref as next_hero_ref
import Dungeon/hero_helpers/prev_hero_ref as prev_hero_ref
import Dungeon/hero_helpers/normalize_hero_ref as normalize_hero_ref
import Dungeon/profile_helpers/profile_for_hero as profile_for_hero
import Dungeon/profile_helpers/profile_unlocked as profile_unlocked
import Dungeon/profile_helpers/set_selected_hero as set_selected_hero
import Dungeon/profile_helpers/set_selection_confirmed as set_selection_confirmed
def update_character_select(evt: DungeonEvent, meta_state: Meta, preview_hero: U32, next_seed_value: U32, ui_value: UiState) -> DungeonState:
  match evt:
    case move{left{}}:
      _preview_character(meta_state, prev_hero_ref(config(), preview_hero), next_seed_value, ui_value)
    case move{right{}}:
      _preview_character(meta_state, next_hero_ref(config(), preview_hero), next_seed_value, ui_value)
    case preview_character{ref}:
      _preview_character(meta_state, normalize_hero_ref(config(), ref), next_seed_value, ui_value)
    case upgrade{}:
      _upgrade_preview_character(meta_state, normalize_hero_ref(config(), preview_hero), next_seed_value)
    case select_character{}:
      _state(meta_state, character_select{preview_hero}, next_seed_value, ui_value)
    case open_boosters{}:
      _state(meta_state, boosters{no_pack_reward{}, 0, booster_return_character_select{preview_hero}}, next_seed_value, default_ui())
    case close_character_select{}:
      _state(meta_state, setup{}, next_seed_value, default_ui())
    case _:
      _state(meta_state, character_select{preview_hero}, next_seed_value, ui_value)

def _preview_character(meta_state: Meta, hero_ref: U32, next_seed_value: U32, ui_value: UiState) -> DungeonState:
  _preview_profile(meta_state, hero_ref, next_seed_value, ui_value, profile_for_hero(meta_state, hero_ref))

def _upgrade_preview_character(meta_state: Meta, hero_ref: U32, next_seed_value: U32) -> DungeonState:
  _state(upgrade_hero_ref(config(), meta_state, hero_ref), character_select{hero_ref}, next_seed_value, default_ui())

def _preview_profile(meta_state: Meta, hero_ref: U32, next_seed_value: U32, ui_value: UiState, profile: HeroProfile) -> DungeonState:
  match profile_unlocked(profile):
    case 0:
      _state(meta_state, character_select{hero_ref}, next_seed_value, ui_value)
    case _:
      _state(set_selection_confirmed(set_selected_hero(meta_state, hero_ref), 1), character_select{hero_ref}, next_seed_value, default_ui())
