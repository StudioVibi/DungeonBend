import /dungeon/logic/Config
import /dungeon/logic/Meta
import /dungeon/logic/Run
import /dungeon/logic/Board
import /dungeon/logic/DeckEntry
import /dungeon/logic/BoardDraw
import /dungeon/logic/DrawResult
import /dungeon/logic/Board/empty_board as empty_board
import /dungeon/logic/Board/board_set as board_set
import /dungeon/logic/Deck/hero_max_hp as hero_max_hp
import /dungeon/logic/Deck/remove_hero_card as remove_hero_card
import /dungeon/logic/Deck/sum_counts as sum_counts
import /dungeon/logic/Deck/draw_tile as draw_tile

def _draw_into_slot(board_value: Board, slot: U32, result: DrawResult) -> BoardDraw:
  match result:
    case draw_result{tile, next_counts, next_remaining, next_seed, next_level}:
      board_draw{board_set(board_value, slot, tile), next_counts, next_remaining, next_seed, next_level}

def _draw_step(
  config_value: Config,
  board_value: Board,
  slot: U32,
  deck_blueprint: List(DeckEntry),
  draw_counts: List(DeckEntry),
  remaining: U32,
  seed: U32,
  level: U32,
) -> BoardDraw:
  _draw_into_slot(board_value, slot, draw_tile(config_value, deck_blueprint, draw_counts, remaining, seed, level))

def _seed_after_1(config_value: Config, blueprint: List(DeckEntry), stage: BoardDraw) -> BoardDraw:
  match stage:
    case board_draw{board1, counts1, remaining1, seed1, level1}:
      _seed_after_2(config_value, blueprint, _draw_step(config_value, board1, 2, blueprint, counts1, remaining1, seed1, level1))

def _seed_after_2(config_value: Config, blueprint: List(DeckEntry), stage: BoardDraw) -> BoardDraw:
  match stage:
    case board_draw{board2, counts2, remaining2, seed2, level2}:
      _seed_after_3(config_value, blueprint, _draw_step(config_value, board2, 3, blueprint, counts2, remaining2, seed2, level2))

def _seed_after_3(config_value: Config, blueprint: List(DeckEntry), stage: BoardDraw) -> BoardDraw:
  match stage:
    case board_draw{board3, counts3, remaining3, seed3, level3}:
      _seed_after_4(config_value, blueprint, _draw_step(config_value, board3, 5, blueprint, counts3, remaining3, seed3, level3))

def _seed_after_4(config_value: Config, blueprint: List(DeckEntry), stage: BoardDraw) -> BoardDraw:
  match stage:
    case board_draw{board4, counts4, remaining4, seed4, level4}:
      _seed_after_5(config_value, blueprint, _draw_step(config_value, board4, 6, blueprint, counts4, remaining4, seed4, level4))

def _seed_after_5(config_value: Config, blueprint: List(DeckEntry), stage: BoardDraw) -> BoardDraw:
  match stage:
    case board_draw{board5, counts5, remaining5, seed5, level5}:
      _seed_after_6(config_value, blueprint, _draw_step(config_value, board5, 7, blueprint, counts5, remaining5, seed5, level5))

def _seed_after_6(config_value: Config, blueprint: List(DeckEntry), stage: BoardDraw) -> BoardDraw:
  match stage:
    case board_draw{board6, counts6, remaining6, seed6, level6}:
      _draw_step(config_value, board6, 8, blueprint, counts6, remaining6, seed6, level6)

def _seed_after_0(config_value: Config, blueprint: List(DeckEntry), stage: BoardDraw) -> BoardDraw:
  match stage:
    case board_draw{board0, counts0, remaining0, seed0, level0}:
      _seed_after_1(config_value, blueprint, _draw_step(config_value, board0, 1, blueprint, counts0, remaining0, seed0, level0))

def _seed_initial_board(
  config_value: Config,
  deck_blueprint: List(DeckEntry),
  draw_counts: List(DeckEntry),
  remaining: U32,
  seed: U32,
  level: U32,
) -> BoardDraw:
  _seed_after_0(config_value, deck_blueprint, _draw_step(config_value, empty_board, 0, deck_blueprint, draw_counts, remaining, seed, level))

def _start_from_board(hero_max: U32, blueprint: List(DeckEntry), capacity: U32, stage: BoardDraw) -> Run:
  match stage:
    case board_draw{board_value, next_counts, next_remaining, next_seed, next_level}:
      run{
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
      }

def start_run(config_value: Config, meta_state: Meta, seed: U32) -> Run:
  match config_value meta_state:
    case config{hero_base_max_hp, upgrades, monsters, swords, potions, deck, base_deck_size, starting_dungeon_level} meta{hero_level, gold}:
      current = (config{hero_base_max_hp, upgrades, monsters, swords, potions, deck, base_deck_size, starting_dungeon_level} :: Config);
      hero_max = hero_max_hp(hero_base_max_hp, upgrades, hero_level);
      blueprint = remove_hero_card(deck);
      remaining = sum_counts(blueprint);
      _start_from_board(hero_max, blueprint, base_deck_size, _seed_initial_board(current, blueprint, blueprint, remaining, seed, starting_dungeon_level))
