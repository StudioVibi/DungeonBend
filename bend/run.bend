import /bend/types as Types
import /bend/board as Board
import /bend/deck as Deck
import /bend/combat as Combat

def min_u32(a: U32, b: U32) -> U32:
  match a < b:
    case 0:
      b
    case _:
      a

def add_gold(meta_state: Types.Meta, amount: U32) -> Types.Meta:
  match meta_state:
    case meta{hero_level, gold}:
      meta{hero_level, gold + amount}

def keep_run(
  meta_state: Types.Meta,
  dungeon_level: U32,
  hero_hp: U32,
  hero_max_hp: U32,
  hero_index: U32,
  weapon_state: Types.Weapon,
  board_value: Types.Board,
  deck_blueprint: List(Types.DeckEntry),
  draw_counts: List(Types.DeckEntry),
  remaining: U32,
  capacity: U32,
  seed: U32,
  status: U32,
) -> Types.SwipeResult:
  Types.make_swipe(
    meta_state,
    Types.make_run(
      dungeon_level,
      hero_hp,
      hero_max_hp,
      hero_index,
      weapon_state,
      board_value,
      deck_blueprint,
      draw_counts,
      remaining,
      capacity,
      seed,
      status
    )
  )

def draw_into_slot_result(board_value: Types.Board, slot: U32, result: Types.DrawResult) -> Types.BoardDraw:
  match result:
    case draw_result{tile, next_counts, next_remaining, next_seed, next_level}:
      next_board = Board.board_set(board_value, slot, tile);
      board_draw{next_board, next_counts, next_remaining, next_seed, next_level}

def draw_into_slot(
  config_value: Types.Config,
  board_value: Types.Board,
  slot: U32,
  deck_blueprint: List(Types.DeckEntry),
  draw_counts: List(Types.DeckEntry),
  remaining: U32,
  seed: U32,
  level: U32,
) -> Types.BoardDraw:
  draw_into_slot_result(board_value, slot, Deck.draw_tile(config_value, deck_blueprint, draw_counts, remaining, seed, level))

def seed_after_0(config_value: Types.Config, deck_blueprint: List(Types.DeckEntry), stage0: Types.BoardDraw) -> Types.BoardDraw:
  match stage0:
    case board_draw{board0, counts0, remaining0, seed0, level0}:
      seed_after_1(config_value, deck_blueprint, draw_into_slot(config_value, board0, 1, deck_blueprint, counts0, remaining0, seed0, level0))

def seed_after_1(config_value: Types.Config, deck_blueprint: List(Types.DeckEntry), stage1: Types.BoardDraw) -> Types.BoardDraw:
  match stage1:
    case board_draw{board1, counts1, remaining1, seed1, level1}:
      seed_after_2(config_value, deck_blueprint, draw_into_slot(config_value, board1, 2, deck_blueprint, counts1, remaining1, seed1, level1))

def seed_after_2(config_value: Types.Config, deck_blueprint: List(Types.DeckEntry), stage2: Types.BoardDraw) -> Types.BoardDraw:
  match stage2:
    case board_draw{board2, counts2, remaining2, seed2, level2}:
      seed_after_3(config_value, deck_blueprint, draw_into_slot(config_value, board2, 3, deck_blueprint, counts2, remaining2, seed2, level2))

def seed_after_3(config_value: Types.Config, deck_blueprint: List(Types.DeckEntry), stage3: Types.BoardDraw) -> Types.BoardDraw:
  match stage3:
    case board_draw{board3, counts3, remaining3, seed3, level3}:
      seed_after_4(config_value, deck_blueprint, draw_into_slot(config_value, board3, 5, deck_blueprint, counts3, remaining3, seed3, level3))

def seed_after_4(config_value: Types.Config, deck_blueprint: List(Types.DeckEntry), stage4: Types.BoardDraw) -> Types.BoardDraw:
  match stage4:
    case board_draw{board4, counts4, remaining4, seed4, level4}:
      seed_after_5(config_value, deck_blueprint, draw_into_slot(config_value, board4, 6, deck_blueprint, counts4, remaining4, seed4, level4))

def seed_after_5(config_value: Types.Config, deck_blueprint: List(Types.DeckEntry), stage5: Types.BoardDraw) -> Types.BoardDraw:
  match stage5:
    case board_draw{board5, counts5, remaining5, seed5, level5}:
      seed_after_6(config_value, deck_blueprint, draw_into_slot(config_value, board5, 7, deck_blueprint, counts5, remaining5, seed5, level5))

def seed_after_6(config_value: Types.Config, deck_blueprint: List(Types.DeckEntry), stage6: Types.BoardDraw) -> Types.BoardDraw:
  match stage6:
    case board_draw{board6, counts6, remaining6, seed6, level6}:
      draw_into_slot(config_value, board6, 8, deck_blueprint, counts6, remaining6, seed6, level6)

def seed_initial_board(
  config_value: Types.Config,
  deck_blueprint: List(Types.DeckEntry),
  draw_counts: List(Types.DeckEntry),
  remaining: U32,
  seed: U32,
  level: U32,
) -> Types.BoardDraw:
  seed_after_0(config_value, deck_blueprint, draw_into_slot(config_value, Board.empty_board, 0, deck_blueprint, draw_counts, remaining, seed, level))

def start_run_from_board(hero_max: U32, blueprint: List(Types.DeckEntry), capacity: U32, stage: Types.BoardDraw) -> Types.Run:
  match stage:
    case board_draw{board_value, next_counts, next_remaining, next_seed, next_level}:
      Types.make_run(
        next_level,
        hero_max,
        hero_max,
        4,
        no_weapon{},
        board_value,
        blueprint,
        next_counts,
        next_remaining,
        capacity,
        next_seed,
        0
      )

def start_run_from_meta(
  config_value: Types.Config,
  hero_base_max_hp: U32,
  upgrades: List(Types.Upgrade),
  deck_value: List(Types.DeckEntry),
  base_deck_size: U32,
  starting_dungeon_level: U32,
  meta_state: Types.Meta,
  seed: U32,
) -> Types.Run:
  match meta_state:
    case meta{hero_level, gold}:
      hero_max = Deck.hero_max_hp(hero_base_max_hp, upgrades, hero_level);
      blueprint = Deck.remove_hero_card(deck_value);
      remaining = Deck.sum_counts(blueprint);
      start_run_from_board(hero_max, blueprint, base_deck_size, seed_initial_board(config_value, blueprint, blueprint, remaining, seed, starting_dungeon_level))

def start_run_from_config(config_value: Types.Config, meta_state: Types.Meta, seed: U32) -> Types.Run:
  match config_value:
    case config{hero_base_max_hp, upgrades, monsters, swords, potions, deck_value, base_deck_size, starting_dungeon_level}:
      start_run_from_meta(
        config{hero_base_max_hp, upgrades, monsters, swords, potions, deck_value, base_deck_size, starting_dungeon_level},
        hero_base_max_hp,
        upgrades,
        deck_value,
        base_deck_size,
        starting_dungeon_level,
        meta_state,
        seed
      )

def start_run(config_value: Types.Config, meta_state: Types.Meta, seed: U32) -> Types.Run:
  start_run_from_config(config_value, meta_state, seed)

def upgrade_hero_if_affordable(hero_level: U32, gold_value: U32, meta_state: Types.Meta, cost: U32) -> Types.Meta:
  match gold_value < cost:
    case 0:
      (meta{hero_level + 1, gold_value - cost} :: Types.Meta)
    case _:
      (meta_state :: Types.Meta)

def upgrade_hero_from_known_step(hero_level: U32, gold_value: U32, meta_state: Types.Meta, cost: U32, max_hp: U32) -> Types.Meta:
  match max_hp === 0:
    case 0:
      upgrade_hero_if_affordable(hero_level, gold_value, meta_state, cost)
    case _:
      meta_state

def upgrade_hero_from_step(hero_level: U32, gold_value: U32, meta_state: Types.Meta, step: Types.Upgrade) -> Types.Meta:
  match step:
    case upgrade{cost, max_hp}:
      upgrade_hero_from_known_step(hero_level, gold_value, meta_state, cost, max_hp)

def upgrade_hero_from_meta(upgrades: List(Types.Upgrade), meta_state: Types.Meta) -> Types.Meta:
  match meta_state:
    case meta{hero_level, gold_value}:
      upgrade_hero_from_step(hero_level, gold_value, meta{hero_level, gold_value}, Deck.nth_upgrade(upgrades, hero_level))

def upgrade_hero_from_config(config_value: Types.Config, meta_state: Types.Meta) -> Types.Meta:
  match config_value:
    case config{hero_base_max_hp, upgrades, monsters, swords, potions, deck_value, base_deck_size, starting_dungeon_level}:
      upgrade_hero_from_meta(upgrades, meta_state)

def upgrade_hero(config_value: Types.Config, meta_state: Types.Meta) -> Types.Meta:
  upgrade_hero_from_config(config_value, meta_state)

def move_after_collect_from_draw(
  meta_state: Types.Meta,
  hero_hp: U32,
  hero_max_hp: U32,
  hero_index: U32,
  target_index: U32,
  weapon_state: Types.Weapon,
  board_value: Types.Board,
  deck_blueprint: List(Types.DeckEntry),
  capacity: U32,
  result: Types.DrawResult,
  dir: U32,
) -> Types.SwipeResult:
  match result:
    case draw_result{spawn, next_counts, next_remaining, next_seed, next_level}:
      next_board = Board.shift_after_move(board_value, hero_index, target_index, dir, spawn);
      next_run = Types.make_run(
        next_level,
        hero_hp,
        hero_max_hp,
        target_index,
        weapon_state,
        next_board,
        deck_blueprint,
        next_counts,
        next_remaining,
        capacity,
        next_seed,
        0
      );
      Types.make_swipe(meta_state, next_run)

def move_after_collect(
  config_value: Types.Config,
  meta_state: Types.Meta,
  dungeon_level: U32,
  hero_hp: U32,
  hero_max_hp: U32,
  hero_index: U32,
  target_index: U32,
  weapon_state: Types.Weapon,
  board_value: Types.Board,
  deck_blueprint: List(Types.DeckEntry),
  draw_counts: List(Types.DeckEntry),
  remaining: U32,
  capacity: U32,
  seed: U32,
  dir: U32,
) -> Types.SwipeResult:
  move_after_collect_from_draw(
    meta_state,
    hero_hp,
    hero_max_hp,
    hero_index,
    target_index,
    weapon_state,
    board_value,
    deck_blueprint,
    capacity,
    Deck.draw_tile(config_value, deck_blueprint, draw_counts, remaining, seed, dungeon_level),
    dir
  )

def apply_swipe_from_combat(
  meta_state: Types.Meta,
  dungeon_level: U32,
  hero_max_hp: U32,
  hero_index: U32,
  deck_blueprint: List(Types.DeckEntry),
  draw_counts: List(Types.DeckEntry),
  remaining: U32,
  capacity: U32,
  seed: U32,
  result: Combat.CombatResult,
) -> Types.SwipeResult:
  match result:
    case combat_result{next_hp, next_weapon, next_board, next_status}:
      next_run = Types.make_run(
        dungeon_level,
        next_hp,
        hero_max_hp,
        hero_index,
        next_weapon,
        next_board,
        deck_blueprint,
        draw_counts,
        remaining,
        capacity,
        seed,
        next_status
      );
      Types.make_swipe(meta_state, next_run)

def apply_swipe_to_tile(
  config_value: Types.Config,
  meta_state: Types.Meta,
  dungeon_level: U32,
  hero_hp: U32,
  hero_max_hp: U32,
  hero_index: U32,
  weapon_state: Types.Weapon,
  board_value: Types.Board,
  deck_blueprint: List(Types.DeckEntry),
  draw_counts: List(Types.DeckEntry),
  remaining: U32,
  capacity: U32,
  seed: U32,
  status: U32,
  dir: U32,
  target_index: U32,
  target_tile_value: Types.Tile,
) -> Types.SwipeResult:
  match target_tile_value:
    case none{}:
      keep_run(meta_state, dungeon_level, hero_hp, hero_max_hp, hero_index, weapon_state, board_value, deck_blueprint, draw_counts, remaining, capacity, seed, status)
    case monster{ref, hp}:
      apply_swipe_from_combat(
        meta_state,
        dungeon_level,
        hero_max_hp,
        hero_index,
        deck_blueprint,
        draw_counts,
        remaining,
        capacity,
        seed,
        Combat.resolve_monster(config_value, board_value, hero_hp, weapon_state, target_index, ref, hp)
      )
    case sword{ref, dmg}:
      move_after_collect(
        config_value,
        meta_state,
        dungeon_level,
        hero_hp,
        hero_max_hp,
        hero_index,
        target_index,
        weapon{ref, dmg},
        board_value,
        deck_blueprint,
        draw_counts,
        remaining,
        capacity,
        seed,
        dir
      )
    case potion{ref, heal}:
      next_hp = min_u32(hero_max_hp, hero_hp + heal);
      move_after_collect(
        config_value,
        meta_state,
        dungeon_level,
        next_hp,
        hero_max_hp,
        hero_index,
        target_index,
        weapon_state,
        board_value,
        deck_blueprint,
        draw_counts,
        remaining,
        capacity,
        seed,
        dir
      )
    case gold{amount}:
      next_meta = add_gold(meta_state, amount);
      move_after_collect(
        config_value,
        next_meta,
        dungeon_level,
        hero_hp,
        hero_max_hp,
        hero_index,
        target_index,
        weapon_state,
        board_value,
        deck_blueprint,
        draw_counts,
        remaining,
        capacity,
        seed,
        dir
      )

def apply_swipe_from_run(config_value: Types.Config, meta_state: Types.Meta, dir: U32, run_state: Types.Run) -> Types.SwipeResult:
  match run_state:
    case run{dungeon_level, hero_hp, hero_max_hp, hero_index, weapon_state, board_value, deck_blueprint, draw_counts, remaining, capacity, seed, status}:
      match status === 0:
        case 0:
          keep_run(meta_state, dungeon_level, hero_hp, hero_max_hp, hero_index, weapon_state, board_value, deck_blueprint, draw_counts, remaining, capacity, seed, status)
        case _:
          target_index = Board.adjacent_index(hero_index, dir);
          match target_index === 9:
            case 0:
              target_tile = Board.board_get(board_value, target_index);
              apply_swipe_to_tile(
                config_value,
                meta_state,
                dungeon_level,
                hero_hp,
                hero_max_hp,
                hero_index,
                weapon_state,
                board_value,
                deck_blueprint,
                draw_counts,
                remaining,
                capacity,
                seed,
                status,
                dir,
                target_index,
                target_tile
              )
            case _:
              keep_run(meta_state, dungeon_level, hero_hp, hero_max_hp, hero_index, weapon_state, board_value, deck_blueprint, draw_counts, remaining, capacity, seed, status)

def apply_swipe(config_value: Types.Config, meta_state: Types.Meta, run_state: Types.Run, dir: U32) -> Types.SwipeResult:
  apply_swipe_from_run(config_value, meta_state, dir, run_state)
