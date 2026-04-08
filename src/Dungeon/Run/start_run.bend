import /Dungeon/DeckEntry as DeckEntry
import /Dungeon/Weapon as Weapon
import /Dungeon/HeroDef as HeroDef
import /Dungeon/Upgrade as Upgrade
import /Dungeon/Meta as Meta
import /Dungeon/Config as Config
import /Dungeon/Run as Run
import /Dungeon/BoardDraw as BoardDraw
import /Dungeon/Deck/counts_pick/hero_max_hp as hero_max_hp
import /Dungeon/Deck/counts_pick/remove_hero_card as remove_hero_card
import /Dungeon/Deck/counts_pick/merge_deck_entries as merge_deck_entries
import /Dungeon/Deck/counts_pick/sum_counts as sum_counts
import /Dungeon/Board/indexing/empty_board as empty_board
import /Dungeon/Run/refill/_refill_non_hero_slots as _refill_non_hero_slots

def _start_from_board(hero_max: U32, blueprint: List(DeckEntry), capacity: U32, stage: BoardDraw) -> Run:
  match stage:
    case board_draw{board_value, next_counts, next_remaining, next_seed_value, next_level}:
      run{next_level, hero_max, hero_max, 4, no_weapon{}, board_value, blueprint, next_counts, next_remaining, capacity, next_seed_value, 0}

def start_run(config_value: Config, meta_state: Meta, seed: U32) -> Run:
  match config_value meta_state:
    case config{hero, upgrades, monsters, swords, potions, deck, booster_packs, starting_dungeon_level} meta{hero_level, gold, bonus_deck, pack_inventory}:
      current = (config{hero, upgrades, monsters, swords, potions, deck, booster_packs, starting_dungeon_level} :: Config);
      full_deck = merge_deck_entries(deck, bonus_deck);
      hero_max = _hero_max_from_def(hero, upgrades, hero_level);
      blueprint = remove_hero_card(full_deck);
      remaining = sum_counts(blueprint);
      _start_from_board(hero_max, blueprint, sum_counts(full_deck), _refill_non_hero_slots(current, empty_board(), 4, blueprint, blueprint, remaining, seed, starting_dungeon_level))

def _hero_max_from_def(hero_value: HeroDef, upgrades: List(Upgrade), hero_level: U32) -> U32:
  match hero_value:
    case hero_def{name, sprite, base_max_hp}:
      hero_max_hp(base_max_hp, upgrades, hero_level)
