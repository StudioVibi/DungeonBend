import /dungeon/data/config as config
import /dungeon/logic/Meta
import /dungeon/logic/Run
import /dungeon/logic/Board
import /dungeon/logic/Tile
import /dungeon/logic/SwipeResult
import /dungeon/logic/Board/empty_board as empty_board
import /dungeon/logic/Board/board_set as board_set
import /dungeon/logic/Board/board_get as board_get
import /dungeon/logic/Run/apply_swipe as apply_swipe

def _eq_u32(a: U32, b: U32) -> U32:
  match a === b:
    case 0:
      0
    case _:
      1

def _status_game_over(run_value: Run) -> U32:
  match run_value:
    case run{dungeon_level, hero_hp, hero_max_hp, hero_index, weapon, board_value, deck_blueprint, draw_counts, remaining, capacity, seed, status}:
      match status === 0:
        case 0:
          1
        case _:
          0

def _status_running(run_value: Run) -> U32:
  match run_value:
    case run{dungeon_level, hero_hp, hero_max_hp, hero_index, weapon, board_value, deck_blueprint, draw_counts, remaining, capacity, seed, status}:
      _eq_u32(status, 0)

def _is_gold(tile: Tile, amount: U32) -> U32:
  match tile:
    case gold{got}:
      _eq_u32(got, amount)
    case _:
      0

def _run_with(board_value: Board, hero_hp: U32) -> Run:
  run{
    1,
    hero_hp,
    10,
    4,
    no_weapon{},
    board_value,
    [deck_entry{1, 0, 1}],
    [deck_entry{1, 0, 1}],
    1,
    20,
    5,
    0
  }

def _run_from_swipe(result: SwipeResult) -> Run:
  match result:
    case swipe_result{next_meta, next_run}:
      next_run

def _assert_unarmed(win_run: Run, equal_run: Run, lower_run: Run) -> U32:
  match win_run:
    case run{lvl_a, hp_a, max_a, idx_a, weapon_a, board_a, deck_a, draw_a, rem_a, cap_a, seed_a, status_a}:
      match equal_run:
        case run{lvl_b, hp_b, max_b, idx_b, weapon_b, board_b, deck_b, draw_b, rem_b, cap_b, seed_b, status_b}:
          match lower_run:
            case run{lvl_c, hp_c, max_c, idx_c, weapon_c, board_c, deck_c, draw_c, rem_c, cap_c, seed_c, status_c}:
              _eq_u32(hp_a, 4)
              * _eq_u32(idx_a, 4)
              * _is_gold(board_get(board_a, 1), 3)
              * _eq_u32(status_a, 0)
              * _eq_u32(hp_b, 0)
              * _eq_u32(status_b, 1)
              * _eq_u32(hp_c, 0)
              * _eq_u32(status_c, 1)

def main() -> U32:
  _assert_unarmed(
    _run_from_swipe(apply_swipe(config(), meta{0, 0}, _run_with(board_set(empty_board(), 1, monster{0, 6}), 10), 0)),
    _run_from_swipe(apply_swipe(config(), meta{0, 0}, _run_with(board_set(empty_board(), 1, monster{0, 3}), 3), 0)),
    _run_from_swipe(apply_swipe(config(), meta{0, 0}, _run_with(board_set(empty_board(), 1, monster{1, 8}), 4), 0))
  )

def test_combat_unarmed() -> U32:
  main()
