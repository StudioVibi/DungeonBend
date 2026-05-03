import Dungeon/DeckEntry as DeckEntry
import Dungeon/Weapon as Weapon
import Dungeon/BoardDraw as BoardDraw
import Dungeon/Meta as Meta
import Dungeon/Run as Run
import Dungeon/DungeonState as DungeonState
import Dungeon/config as config
import Dungeon/default_ui as default_ui
import Dungeon/Board/indexing/empty_board as empty_board
import Dungeon/Run/refill/_refill_non_hero_slots as _refill_non_hero_slots
import Dungeon/App/state_helpers/_state as _state

def _ultimate_run_from_values(hero_hp: U32, hero_max_hp: U32, hero_index: U32, weapon_value: Weapon, deck_blueprint: List(DeckEntry), capacity: U32, hero_ref: U32, stage: BoardDraw) -> Run:
  match stage:
    case board_draw{next_board, next_counts, next_remaining, next_seed_value, next_level}:
      run{next_level, hero_hp, hero_max_hp, hero_index, weapon_value, next_board, deck_blueprint, next_counts, next_remaining, capacity, next_seed_value, 0, hero_ref}

def use_ultimate(meta_state: Meta, run_value: Run, next_seed_value: U32) -> DungeonState:
  match run_value:
    case run{dungeon_level, hero_hp, hero_max_hp, hero_index, weapon_value, board_value, deck_blueprint, draw_counts, remaining, capacity, seed, ult_charge, hero_ref}:
      stage = _refill_non_hero_slots(config(), empty_board(), hero_index, deck_blueprint, draw_counts, remaining, seed, dungeon_level);
      _state(meta_state, running{_ultimate_run_from_values(hero_hp, hero_max_hp, hero_index, weapon_value, deck_blueprint, capacity, hero_ref, stage)}, next_seed_value, default_ui())
