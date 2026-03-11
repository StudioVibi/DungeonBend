import /dungeon/data/config as config
import /dungeon/logic/Meta
import /dungeon/logic/Run
import /dungeon/logic/Board
import /dungeon/logic/Tile
import /dungeon/logic/Weapon
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

def _is_gold(tile: Tile, amount: U32) -> U32:
  match tile:
    case gold{got}:
      _eq_u32(got, amount)
    case _:
      0

def _is_monster(tile: Tile, ref: U32, hp: U32) -> U32:
  match tile:
    case monster{got_ref, got_hp}:
      _eq_u32(got_ref, ref) * _eq_u32(got_hp, hp)
    case _:
      0

def _is_potion(tile: Tile, ref: U32, heal: U32) -> U32:
  match tile:
    case potion{got_ref, got_heal}:
      _eq_u32(got_ref, ref) * _eq_u32(got_heal, heal)
    case _:
      0

def _run_with(board_value: Board, hero_hp: U32, weapon_value: Weapon) -> Run:
  run{
    1,
    hero_hp,
    10,
    4,
    weapon_value,
    board_value,
    [deck_entry{2, 0, 1}],
    [deck_entry{2, 0, 1}],
    1,
    20,
    5,
    0
  }

def _run_from_swipe(result: SwipeResult) -> Run:
  match result:
    case swipe_result{next_meta, next_run}:
      next_run

def _assert_weapon_state(
  weapon_a: Weapon,
  weapon_b: Weapon,
  weapon_c: Weapon,
  hp_a: U32,
  board_a: Board,
  board_b: Board,
  idx_c: U32,
  rem_c: U32,
  seed_c: U32,
  board_c: Board,
) -> U32:
  match weapon_a:
    case weapon{ref_a, dmg_a}:
      match weapon_b:
        case no_weapon{}:
          match weapon_c:
            case no_weapon{}:
              _eq_u32(hp_a, 8)
              * _eq_u32(dmg_a, 2)
              * _is_gold(board_get(board_a, 1), 3)
              * _is_gold(board_get(board_b, 1), 4)
              * _eq_u32(idx_c, 4)
              * _eq_u32(rem_c, 1)
              * _eq_u32(seed_c, 5)
              * _is_monster(board_get(board_c, 1), 2, 2)
              * _is_potion(board_get(board_c, 7), 0, 4)
            case _:
              0
        case _:
          0
    case _:
      0

def _assert_weapon_runs(run_a: Run, run_b: Run, run_c: Run) -> U32:
  match run_a:
    case run{lvl_a, hp_a, max_a, idx_a, weapon_a, board_a, deck_a, draw_a, rem_a, cap_a, seed_a, status_a}:
      match run_b:
        case run{lvl_b, hp_b, max_b, idx_b, weapon_b, board_b, deck_b, draw_b, rem_b, cap_b, seed_b, status_b}:
          match run_c:
            case run{lvl_c, hp_c, max_c, idx_c, weapon_c, board_c, deck_c, draw_c, rem_c, cap_c, seed_c, status_c}:
              _assert_weapon_state(weapon_a, weapon_b, weapon_c, hp_a, board_a, board_b, idx_c, rem_c, seed_c, board_c)

def main() -> U32:
  lower_board = board_set(board_set(empty_board(), 1, monster{2, 7}), 7, potion{0, 4});
  _assert_weapon_runs(
    _run_from_swipe(apply_swipe(config(), meta{0, 0}, _run_with(board_set(empty_board(), 1, monster{0, 3}), 8, weapon{0, 5}), 0)),
    _run_from_swipe(apply_swipe(config(), meta{0, 0}, _run_with(board_set(empty_board(), 1, monster{1, 5}), 8, weapon{0, 5}), 0)),
    _run_from_swipe(apply_swipe(config(), meta{0, 0}, _run_with(lower_board, 9, weapon{0, 5}), 0))
  )

def test_combat_weapon() -> U32:
  main()
