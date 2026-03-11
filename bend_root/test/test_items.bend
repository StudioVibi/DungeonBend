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

def _is_sword(tile: Tile, ref: U32, dmg: U32) -> U32:
  match tile:
    case sword{got_ref, got_dmg}:
      _eq_u32(got_ref, ref) * _eq_u32(got_dmg, dmg)
    case _:
      0

def _run_with(board_value: Board, hero_hp: U32, hero_max_hp: U32) -> Run:
  run{
    1,
    hero_hp,
    hero_max_hp,
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

def _meta_from_swipe(result: SwipeResult) -> Meta:
  match result:
    case swipe_result{next_meta, next_run}:
      next_meta

def _run_from_swipe(result: SwipeResult) -> Run:
  match result:
    case swipe_result{next_meta, next_run}:
      next_run

def _assert_items(gold_meta: Meta, gold_run: Run, potion_run: Run) -> U32:
  match gold_meta:
    case meta{gold_level, gold_value}:
      match gold_run:
        case run{lvl_a, hp_a, max_a, idx_a, weapon_a, board_a, deck_a, draw_a, rem_a, cap_a, seed_a, status_a}:
          match potion_run:
            case run{lvl_b, hp_b, max_b, idx_b, weapon_b, board_b, deck_b, draw_b, rem_b, cap_b, seed_b, status_b}:
              _eq_u32(gold_value, 4)
              * _eq_u32(idx_a, 1)
              * _is_sword(board_get(board_a, 4), 0, 5)
              * _is_sword(board_get(board_a, 7), 0, 5)
              * _eq_u32(hp_b, 10)
              * _eq_u32(idx_b, 3)

def main() -> U32:
  gold_board = board_set(board_set(empty_board(), 1, gold{3}), 7, sword{0, 5});
  potion_board = board_set(empty_board(), 3, potion{0, 4});
  gold_result = apply_swipe(config(), meta{0, 1}, _run_with(gold_board, 10, 10), 0);
  potion_result = apply_swipe(config(), meta{0, 0}, _run_with(potion_board, 8, 10), 2);
  _assert_items(_meta_from_swipe(gold_result), _run_from_swipe(gold_result), _run_from_swipe(potion_result))

def test_items() -> U32:
  main()
