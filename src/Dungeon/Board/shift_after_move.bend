import /Dungeon/Board as Board
import /Dungeon/Tile as Tile
import /Dungeon/Direction as Direction
import /Dungeon/Board/indexing/board_pos as board_pos
import /Dungeon/Board/indexing/board_get_pos as board_get_pos
import /Dungeon/Board/indexing/board_set_pos as board_set_pos
import /Dungeon/Board/indexing/back_pos as back_pos

def _shift_after_move_back(board_value: Board, board1: Board, hero_pos: Nat/V2, back: Maybe(Nat/V2), spawn: Tile) -> Board:
  match back:
    case none{}:
      board_set_pos(board1, hero_pos, spawn)
    case some{back_pos_value}:
      back_tile = board_get_pos(board_value, back_pos_value);
      board2 = board_set_pos(board1, hero_pos, back_tile);
      board_set_pos(board2, back_pos_value, spawn)

def shift_after_move(board_value: Board, hero_index: U32, target_index: U32, dir: Direction, spawn: Tile) -> Board:
  _shift_after_move_back(
    board_value,
    board_set_pos(board_value, board_pos(target_index), none{}),
    board_pos(hero_index),
    back_pos(hero_index, dir),
    spawn
  )
