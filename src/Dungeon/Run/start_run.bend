import Dungeon/DeckEntry as DeckEntry
import Dungeon/Weapon as Weapon
import Dungeon/Meta as Meta
import Dungeon/Config as Config
import Dungeon/Run as Run
import Dungeon/BoardDraw as BoardDraw
import Dungeon/Deck/counts_pick/hero_max_hp as hero_max_hp
import Dungeon/Deck/counts_pick/remove_hero_card as remove_hero_card
import Dungeon/Deck/counts_pick/merge_deck_entries as merge_deck_entries
import Dungeon/Deck/counts_pick/sum_counts as sum_counts
import Dungeon/Board/indexing/empty_board as empty_board
import Dungeon/Run/refill/_refill_non_hero_slots as _refill_non_hero_slots
import Dungeon/hero_helpers/hero_at as hero_at
import Dungeon/hero_helpers/hero_base_max_hp as hero_base_max_hp
import Dungeon/hero_helpers/hero_upgrades as hero_upgrades
import Dungeon/profile_helpers/selected_hero as selected_hero
import Dungeon/profile_helpers/active_profile as active_profile
import Dungeon/profile_helpers/meta_bonus_deck as meta_bonus_deck
import Dungeon/profile_helpers/profile_hero_level as profile_hero_level

def _start_from_board(hero_max: U32, blueprint: List(DeckEntry), capacity: U32, hero_ref: U32, stage: BoardDraw) -> Run:
  match stage:
    case board_draw{board_value, next_counts, next_remaining, next_seed_value, next_level}:
      run{next_level, hero_max, hero_max, 4, no_weapon{}, board_value, blueprint, next_counts, next_remaining, capacity, next_seed_value, 0, hero_ref}

def start_run(config_value: Config, meta_state: Meta, seed: U32) -> Run:
  match config_value:
    case config{heroes, monsters, swords, potions, deck, booster_packs, starting_dungeon_level}:
      hero_ref = selected_hero(meta_state);
      hero_value = hero_at(config_value, hero_ref);
      profile = active_profile(meta_state);
      full_deck = merge_deck_entries(deck, meta_bonus_deck(meta_state));
      hero_max = hero_max_hp(hero_base_max_hp(hero_value), hero_upgrades(hero_value), profile_hero_level(profile));
      blueprint = remove_hero_card(full_deck);
      remaining = sum_counts(blueprint);
      _start_from_board(hero_max, blueprint, sum_counts(full_deck), hero_ref, _refill_non_hero_slots(config_value, empty_board(), 4, blueprint, blueprint, remaining, seed, starting_dungeon_level))
