import /Dungeon/Meta as Meta
import /Dungeon/Config as Config
import /Dungeon/HeroProfile as HeroProfile
import /Dungeon/UiState as UiState
import /Dungeon/DungeonEvent as DungeonEvent
import /Dungeon/DungeonState as DungeonState
import /Dungeon/config as config
import /Dungeon/default_ui as default_ui
import /Dungeon/App/state_helpers/_state as _state
import /Dungeon/Run/upgrade_hero/upgrade_hero_ref as upgrade_hero_ref
import /Dungeon/hero_helpers/hero_at as hero_at
import /Dungeon/hero_helpers/hero_unlock_cost as hero_unlock_cost
import /Dungeon/hero_helpers/next_hero_ref as next_hero_ref
import /Dungeon/hero_helpers/prev_hero_ref as prev_hero_ref
import /Dungeon/hero_helpers/normalize_hero_ref as normalize_hero_ref
import /Dungeon/profile_helpers/meta_gold as meta_gold
import /Dungeon/profile_helpers/profile_for_hero as profile_for_hero
import /Dungeon/profile_helpers/profile_unlocked as profile_unlocked
import /Dungeon/profile_helpers/profile_with_unlocked as profile_with_unlocked
import /Dungeon/profile_helpers/update_profile as update_profile
import /Dungeon/profile_helpers/set_selected_hero as set_selected_hero
import /Dungeon/profile_helpers/set_meta_gold as set_meta_gold
import /Dungeon/profile_helpers/set_selection_confirmed as set_selection_confirmed

def update_character_select(evt: DungeonEvent, meta_state: Meta, preview_hero: U32, next_seed_value: U32, ui_value: UiState) -> DungeonState:
  match evt:
    case move{left{}}:
      _state(meta_state, character_select{prev_hero_ref(config(), preview_hero)}, next_seed_value, ui_value)
    case move{right{}}:
      _state(meta_state, character_select{next_hero_ref(config(), preview_hero)}, next_seed_value, ui_value)
    case preview_character{ref}:
      _state(meta_state, character_select{normalize_hero_ref(config(), ref)}, next_seed_value, ui_value)
    case upgrade{}:
      _upgrade_preview_character(meta_state, normalize_hero_ref(config(), preview_hero), next_seed_value)
    case select_character{}:
      _select_or_buy_character(config(), meta_state, normalize_hero_ref(config(), preview_hero), next_seed_value)
    case close_character_select{}:
      _state(meta_state, setup{}, next_seed_value, default_ui())
    case _:
      _state(meta_state, character_select{preview_hero}, next_seed_value, ui_value)

def _select_or_buy_character(config_value: Config, meta_state: Meta, hero_ref: U32, next_seed_value: U32) -> DungeonState:
  _select_or_buy_profile(config_value, meta_state, hero_ref, next_seed_value, profile_for_hero(meta_state, hero_ref))

def _upgrade_preview_character(meta_state: Meta, hero_ref: U32, next_seed_value: U32) -> DungeonState:
  _state(upgrade_hero_ref(config(), meta_state, hero_ref), character_select{hero_ref}, next_seed_value, default_ui())

def _select_or_buy_profile(config_value: Config, meta_state: Meta, hero_ref: U32, next_seed_value: U32, profile: HeroProfile) -> DungeonState:
  match profile_unlocked(profile):
    case 0:
      _state(_buy_character_meta(config_value, meta_state, hero_ref), character_select{hero_ref}, next_seed_value, default_ui())
    case _:
      _state(set_selection_confirmed(set_selected_hero(meta_state, hero_ref), 1), character_select{hero_ref}, next_seed_value, default_ui())

def _buy_character_meta(config_value: Config, meta_state: Meta, hero_ref: U32) -> Meta:
  hero_value = hero_at(config_value, hero_ref);
  _buy_character_if_affordable(config_value, meta_gold(meta_state) < hero_unlock_cost(hero_value), meta_state, hero_ref)

def _buy_character_if_affordable(config_value: Config, gold_lt_cost: U32, meta_state: Meta, hero_ref: U32) -> Meta:
  match gold_lt_cost:
    case 0:
      _unlock_character(config_value, meta_state, hero_ref)
    case _:
      meta_state

def _unlock_character(config_value: Config, meta_state: Meta, hero_ref: U32) -> Meta:
  hero_value = hero_at(config_value, hero_ref);
  profile = profile_for_hero(meta_state, hero_ref);
  set_meta_gold(
    update_profile(meta_state, hero_ref, profile_with_unlocked(profile, 1)),
    meta_gold(meta_state) - hero_unlock_cost(hero_value)
  )
