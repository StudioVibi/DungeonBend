import /Dungeon/Upgrade as Upgrade
import /Dungeon/DeckEntry as DeckEntry
import /Dungeon/Weapon as Weapon
import /Dungeon/Tile as Tile
import /Dungeon/Board as Board
import /Dungeon/BoardDraw as BoardDraw
import /Dungeon/DrawResult as DrawResult
import /Dungeon/CombatResult as CombatResult
import /Dungeon/Meta as Meta
import /Dungeon/Config as Config
import /Dungeon/Run as Run
import /Dungeon/SwipeResult as SwipeResult
import /Dungeon/Direction as Direction
import /Dungeon/Deck/counts_pick/hero_max_hp as hero_max_hp
import /Dungeon/Deck/counts_pick/remove_hero_card as remove_hero_card
import /Dungeon/Deck/counts_pick/sum_counts as sum_counts
import /Dungeon/Deck/counts_pick/nth_upgrade as nth_upgrade
import /Dungeon/Deck/spawn_and_draw/draw_tile as draw_tile
import /Dungeon/Board/indexing/empty_board as empty_board
import /Dungeon/Board/indexing/board_set as board_set
import /Dungeon/Board/shift_after_move as shift_after_move
import /Dungeon/Combat/resolve_and_apply/resolve_monster as resolve_monster

def _draw_into_slot(board_value: Board, slot: U32, result: DrawResult) -> BoardDraw:
  match result:
    case draw_result{tile, next_counts, next_remaining, next_seed, next_level}:
      board_draw{board_set(board_value, slot, tile), next_counts, next_remaining, next_seed, next_level}

def _draw_step(config_value: Config, board_value: Board, slot: U32, deck_blueprint: List(DeckEntry), draw_counts: List(DeckEntry), remaining: U32, seed: U32, level: U32) -> BoardDraw:
  _draw_into_slot(board_value, slot, draw_tile(config_value, deck_blueprint, draw_counts, remaining, seed, level))

def _draw_non_hero_step(config_value: Config, hero_index: U32, slot: U32, blueprint: List(DeckEntry), stage: BoardDraw) -> BoardDraw:
  match stage:
    case board_draw{board_value, counts, remaining, seed, level}:
      _draw_non_hero_step_match(slot === hero_index, config_value, board_value, slot, blueprint, counts, remaining, seed, level)

def _draw_non_hero_step_match(is_hero_slot: U32, config_value: Config, board_value: Board, slot: U32, blueprint: List(DeckEntry), counts: List(DeckEntry), remaining: U32, seed: U32, level: U32) -> BoardDraw:
  match is_hero_slot:
    case 0:
      _draw_step(config_value, board_value, slot, blueprint, counts, remaining, seed, level)
    case _:
      board_draw{board_value, counts, remaining, seed, level}

def _refill_after_1(config_value: Config, hero_index: U32, blueprint: List(DeckEntry), stage: BoardDraw) -> BoardDraw:
  match stage:
    case board_draw{board1, counts1, remaining1, seed1, level1}:
      _refill_after_2(config_value, hero_index, blueprint, _draw_non_hero_step(config_value, hero_index, 1, blueprint, board_draw{board1, counts1, remaining1, seed1, level1}))

def _refill_after_2(config_value: Config, hero_index: U32, blueprint: List(DeckEntry), stage: BoardDraw) -> BoardDraw:
  match stage:
    case board_draw{board2, counts2, remaining2, seed2, level2}:
      _refill_after_3(config_value, hero_index, blueprint, _draw_non_hero_step(config_value, hero_index, 2, blueprint, board_draw{board2, counts2, remaining2, seed2, level2}))

def _refill_after_3(config_value: Config, hero_index: U32, blueprint: List(DeckEntry), stage: BoardDraw) -> BoardDraw:
  match stage:
    case board_draw{board3, counts3, remaining3, seed3, level3}:
      _refill_after_4(config_value, hero_index, blueprint, _draw_non_hero_step(config_value, hero_index, 3, blueprint, board_draw{board3, counts3, remaining3, seed3, level3}))

def _refill_after_4(config_value: Config, hero_index: U32, blueprint: List(DeckEntry), stage: BoardDraw) -> BoardDraw:
  match stage:
    case board_draw{board4, counts4, remaining4, seed4, level4}:
      _refill_after_5(config_value, hero_index, blueprint, _draw_non_hero_step(config_value, hero_index, 4, blueprint, board_draw{board4, counts4, remaining4, seed4, level4}))

def _refill_after_5(config_value: Config, hero_index: U32, blueprint: List(DeckEntry), stage: BoardDraw) -> BoardDraw:
  match stage:
    case board_draw{board5, counts5, remaining5, seed5, level5}:
      _refill_after_6(config_value, hero_index, blueprint, _draw_non_hero_step(config_value, hero_index, 5, blueprint, board_draw{board5, counts5, remaining5, seed5, level5}))

def _refill_after_6(config_value: Config, hero_index: U32, blueprint: List(DeckEntry), stage: BoardDraw) -> BoardDraw:
  match stage:
    case board_draw{board6, counts6, remaining6, seed6, level6}:
      _refill_after_7(config_value, hero_index, blueprint, _draw_non_hero_step(config_value, hero_index, 6, blueprint, board_draw{board6, counts6, remaining6, seed6, level6}))

def _refill_after_7(config_value: Config, hero_index: U32, blueprint: List(DeckEntry), stage: BoardDraw) -> BoardDraw:
  match stage:
    case board_draw{board7, counts7, remaining7, seed7, level7}:
      _refill_after_8(config_value, hero_index, blueprint, _draw_non_hero_step(config_value, hero_index, 7, blueprint, board_draw{board7, counts7, remaining7, seed7, level7}))

def _refill_after_8(config_value: Config, hero_index: U32, blueprint: List(DeckEntry), stage: BoardDraw) -> BoardDraw:
  match stage:
    case board_draw{board8, counts8, remaining8, seed8, level8}:
      _draw_non_hero_step(config_value, hero_index, 8, blueprint, board_draw{board8, counts8, remaining8, seed8, level8})

def _refill_non_hero_slots(config_value: Config, board_value: Board, hero_index: U32, deck_blueprint: List(DeckEntry), draw_counts: List(DeckEntry), remaining: U32, seed: U32, level: U32) -> BoardDraw:
  _refill_after_1(
    config_value,
    hero_index,
    deck_blueprint,
    _draw_non_hero_step(config_value, hero_index, 0, deck_blueprint, board_draw{board_value, draw_counts, remaining, seed, level})
  )

def _start_from_board(hero_max: U32, blueprint: List(DeckEntry), capacity: U32, stage: BoardDraw) -> Run:
  match stage:
    case board_draw{board_value, next_counts, next_remaining, next_seed_value, next_level}:
      run{next_level, hero_max, hero_max, 4, no_weapon{}, board_value, blueprint, next_counts, next_remaining, capacity, next_seed_value, 0}

def start_run(config_value: Config, meta_state: Meta, seed: U32) -> Run:
  match config_value meta_state:
    case config{hero_base_max_hp, upgrades, monsters, swords, potions, deck, base_deck_size, starting_dungeon_level} meta{hero_level, gold}:
      current = (config{hero_base_max_hp, upgrades, monsters, swords, potions, deck, base_deck_size, starting_dungeon_level} :: Config);
      hero_max = hero_max_hp(hero_base_max_hp, upgrades, hero_level);
      blueprint = remove_hero_card(deck);
      remaining = sum_counts(blueprint);
      _start_from_board(hero_max, blueprint, base_deck_size, _refill_non_hero_slots(current, empty_board(), 4, blueprint, blueprint, remaining, seed, starting_dungeon_level))

def upgrade_hero(config_value: Config, meta_state: Meta) -> Meta:
  match config_value meta_state:
    case config{hero_base_max_hp, upgrades, monsters, swords, potions, deck, base_deck_size, starting_dungeon_level} meta{hero_level, gold_value}:
      _upgrade_from_step(hero_level, gold_value, meta{hero_level, gold_value}, nth_upgrade(upgrades, hero_level))

def _upgrade_from_step(hero_level: U32, gold_value: U32, meta_state: Meta, step: Upgrade) -> Meta:
  match step:
    case upgrade{cost, max_hp}:
      match max_hp:
        case 0:
          meta_state
        case _:
          _upgrade_if_affordable(hero_level, gold_value, meta_state, cost)

def _upgrade_if_affordable(hero_level: U32, gold_value: U32, meta_state: Meta, cost: U32) -> Meta:
  _upgrade_if_affordable_flag(gold_value < cost, hero_level, gold_value, meta_state, cost)

def _upgrade_if_affordable_flag(gold_lt_cost: U32, hero_level: U32, gold_value: U32, meta_state: Meta, cost: U32) -> Meta:
  match gold_lt_cost:
    case 0:
      meta{hero_level + 1, gold_value - cost}
    case _:
      meta_state

def _min_u32(a: U32, b: U32) -> U32:
  _min_u32_flag(a < b, a, b)

def _min_u32_flag(a_lt_b: U32, a: U32, b: U32) -> U32:
  match a_lt_b:
    case 0:
      b
    case _:
      a

def _add_gold(meta_state: Meta, amount: U32) -> Meta:
  match meta_state:
    case meta{hero_level, gold}:
      meta{hero_level, gold + amount}

def _keep_run(meta_state: Meta, run_value: Run) -> SwipeResult:
  swipe_result{meta_state, keep_running{run_value}}

def _end_run(meta_state: Meta, run_value: Run) -> SwipeResult:
  swipe_result{meta_state, end_run{run_value}}

def _move_after_collect_from_draw(meta_state: Meta, hero_hp: U32, hero_max_hp: U32, hero_index: U32, target_index: U32, weapon_value: Weapon, board_value: Board, deck_blueprint: List(DeckEntry), capacity: U32, ult_charge: U32, result: DrawResult, dir: Direction) -> SwipeResult:
  match result:
    case draw_result{spawn, next_counts, next_remaining, next_seed_value, next_level}:
      _keep_run(
        meta_state,
        run{
          next_level,
          hero_hp,
          hero_max_hp,
          target_index,
          weapon_value,
          shift_after_move(board_value, hero_index, target_index, dir, spawn),
          deck_blueprint,
          next_counts,
          next_remaining,
          capacity,
          next_seed_value,
          ult_charge
        }
      )

def _move_after_collect(config_value: Config, meta_state: Meta, dungeon_level: U32, hero_hp: U32, hero_max_hp: U32, hero_index: U32, target_index: U32, weapon_value: Weapon, board_value: Board, deck_blueprint: List(DeckEntry), draw_counts: List(DeckEntry), remaining: U32, capacity: U32, seed: U32, ult_charge: U32, dir: Direction) -> SwipeResult:
  _move_after_collect_from_draw(
    meta_state,
    hero_hp,
    hero_max_hp,
    hero_index,
    target_index,
    weapon_value,
    board_value,
    deck_blueprint,
    capacity,
    ult_charge,
    draw_tile(config_value, deck_blueprint, draw_counts, remaining, seed, dungeon_level),
    dir
  )

def _combat_run(dungeon_level: U32, hero_hp: U32, hero_max_hp: U32, hero_index: U32, weapon_value: Weapon, board_value: Board, deck_blueprint: List(DeckEntry), draw_counts: List(DeckEntry), remaining: U32, capacity: U32, seed: U32, ult_charge: U32) -> Run:
  run{dungeon_level, hero_hp, hero_max_hp, hero_index, weapon_value, board_value, deck_blueprint, draw_counts, remaining, capacity, seed, ult_charge}

def _from_combat(meta_state: Meta, dungeon_level: U32, hero_max_hp: U32, hero_index: U32, deck_blueprint: List(DeckEntry), draw_counts: List(DeckEntry), remaining: U32, capacity: U32, seed: U32, ult_charge: U32, result: CombatResult) -> SwipeResult:
  match result:
    case combat_result{next_hp, next_weapon, next_board, combat_continue{}}:
      _keep_run(meta_state, _combat_run(dungeon_level, next_hp, hero_max_hp, hero_index, next_weapon, next_board, deck_blueprint, draw_counts, remaining, capacity, seed, ult_charge))
    case combat_result{next_hp, next_weapon, next_board, combat_game_over{}}:
      _end_run(meta_state, _combat_run(dungeon_level, next_hp, hero_max_hp, hero_index, next_weapon, next_board, deck_blueprint, draw_counts, remaining, capacity, seed, ult_charge))

def _apply_to_tile(config_value: Config, meta_state: Meta, dungeon_level: U32, hero_hp: U32, hero_max_hp: U32, hero_index: U32, weapon_value: Weapon, board_value: Board, deck_blueprint: List(DeckEntry), draw_counts: List(DeckEntry), remaining: U32, capacity: U32, seed: U32, ult_charge: U32, dir: Direction, target_index: U32, tile_value: Tile) -> SwipeResult:
  match tile_value:
    case none{}:
      _keep_run(meta_state, run{dungeon_level, hero_hp, hero_max_hp, hero_index, weapon_value, board_value, deck_blueprint, draw_counts, remaining, capacity, seed, ult_charge})
    case monster{ref, hp}:
      _from_combat(
        meta_state,
        dungeon_level,
        hero_max_hp,
        hero_index,
        deck_blueprint,
        draw_counts,
        remaining,
        capacity,
        seed,
        ult_charge,
        resolve_monster(config_value, board_value, hero_hp, weapon_value, target_index, ref, hp)
      )
    case sword{ref, dmg}:
      _move_after_collect(config_value, meta_state, dungeon_level, hero_hp, hero_max_hp, hero_index, target_index, weapon{ref, dmg}, board_value, deck_blueprint, draw_counts, remaining, capacity, seed, ult_charge, dir)
    case potion{ref, heal}:
      _move_after_collect(config_value, meta_state, dungeon_level, _min_u32(hero_max_hp, hero_hp + heal), hero_max_hp, hero_index, target_index, weapon_value, board_value, deck_blueprint, draw_counts, remaining, capacity, seed, ult_charge, dir)
    case gold{amount}:
      _move_after_collect(config_value, _add_gold(meta_state, amount), dungeon_level, hero_hp, hero_max_hp, hero_index, target_index, weapon_value, board_value, deck_blueprint, draw_counts, remaining, capacity, seed, ult_charge, dir)
