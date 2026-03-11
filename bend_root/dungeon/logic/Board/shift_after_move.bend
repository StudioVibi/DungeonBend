import /dungeon/logic/Board
import /dungeon/logic/Tile
import /dungeon/logic/Board/board_get as board_get
import /dungeon/logic/Board/board_set as board_set

def _back_up(hero_index: U32) -> U32:
  match hero_index < 6:
    case 0:
      9
    case _:
      hero_index + 3

def _back_down(hero_index: U32) -> U32:
  match hero_index < 3:
    case 0:
      hero_index - 3
    case _:
      9

def _back_left(hero_index: U32) -> U32:
  match hero_index:
    case 0:
      1
    case 1:
      2
    case 2:
      9
    case 3:
      4
    case 4:
      5
    case 5:
      9
    case 6:
      7
    case 7:
      8
    case 8:
      9
    case _:
      9

def _back_right(hero_index: U32) -> U32:
  match hero_index:
    case 0:
      9
    case 1:
      0
    case 2:
      1
    case 3:
      9
    case 4:
      3
    case 5:
      4
    case 6:
      9
    case 7:
      6
    case 8:
      7
    case _:
      9

def _back_index(hero_index: U32, dir: U32) -> U32:
  match dir:
    case 0:
      _back_up(hero_index)
    case 1:
      _back_down(hero_index)
    case 2:
      _back_left(hero_index)
    case 3:
      _back_right(hero_index)
    case _:
      9

def shift_after_move(
  board_value: Board,
  hero_index: U32,
  target_index: U32,
  dir: U32,
  spawn: Tile,
) -> Board:
  board1 = board_set(board_value, target_index, none{});
  back = _back_index(hero_index, dir);
  match back === 9:
    case 0:
      back_tile = board_get(board_value, back);
      board2 = board_set(board1, hero_index, back_tile);
      board_set(board2, back, spawn)
    case _:
      board_set(board1, hero_index, spawn)
