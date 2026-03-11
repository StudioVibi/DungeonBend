import /dungeon/data/config as config
import /dungeon/data/default_meta as default_meta
import /dungeon/data/initial_seed as initial_seed
import /dungeon/logic/Run
import /dungeon/logic/Board
import /dungeon/logic/Tile
import /dungeon/logic/Board/board_get as board_get
import /dungeon/logic/Run/start_run as start_run

def _eq_u32(a: U32, b: U32) -> U32:
  match a === b:
    case 0:
      0
    case _:
      1

def _populated(board_value: Board, idx: U32) -> U32:
  match idx === 9:
    case 0:
      _slot(board_get(board_value, idx)) + _populated(board_value, idx + 1)
    case _:
      0

def _slot(tile: Tile) -> U32:
  match tile:
    case none{}:
      0
    case _:
      1

def _assert_start_run(run_value: Run) -> U32:
  match run_value:
    case run{dungeon_level, hero_hp, hero_max_hp, hero_index, weapon, board_value, deck_blueprint, draw_counts, remaining, capacity, seed, status}:
      _eq_u32(hero_index, 4)
      * _eq_u32(_populated(board_value, 0), 8)
      * _eq_u32(remaining, 11)
      * _eq_u32(capacity, 20)
      * _eq_u32(status, 0)

def main() -> U32:
  _assert_start_run(start_run(config(), default_meta(), initial_seed()))

def test_start_run() -> U32:
  main()
