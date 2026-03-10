import /bend/types as Types

def empty_board() -> Types.Board:
  board{
    none{},
    none{},
    none{},
    none{},
    none{},
    none{},
    none{},
    none{},
    none{}
  }

def board_get(board_value: Types.Board, idx: U32) -> Types.Tile:
  match board_value:
    case board{c0, c1, c2, c3, c4, c5, c6, c7, c8}:
      λ{
        0: (c0 :: Types.Tile);
        1: (c1 :: Types.Tile);
        2: (c2 :: Types.Tile);
        3: (c3 :: Types.Tile);
        4: (c4 :: Types.Tile);
        5: (c5 :: Types.Tile);
        6: (c6 :: Types.Tile);
        7: (c7 :: Types.Tile);
        8: (c8 :: Types.Tile);
        _ => (none{} :: Types.Tile)
      }(idx)

def board_set(board_value: Types.Board, idx: U32, tile: Types.Tile) -> Types.Board:
  match board_value:
    case board{c0, c1, c2, c3, c4, c5, c6, c7, c8}:
      λ{
        0: (board{tile, c1, c2, c3, c4, c5, c6, c7, c8} :: Types.Board);
        1: (board{c0, tile, c2, c3, c4, c5, c6, c7, c8} :: Types.Board);
        2: (board{c0, c1, tile, c3, c4, c5, c6, c7, c8} :: Types.Board);
        3: (board{c0, c1, c2, tile, c4, c5, c6, c7, c8} :: Types.Board);
        4: (board{c0, c1, c2, c3, tile, c5, c6, c7, c8} :: Types.Board);
        5: (board{c0, c1, c2, c3, c4, tile, c6, c7, c8} :: Types.Board);
        6: (board{c0, c1, c2, c3, c4, c5, tile, c7, c8} :: Types.Board);
        7: (board{c0, c1, c2, c3, c4, c5, c6, tile, c8} :: Types.Board);
        8: (board{c0, c1, c2, c3, c4, c5, c6, c7, tile} :: Types.Board);
        _ => (board{c0, c1, c2, c3, c4, c5, c6, c7, c8} :: Types.Board)
      }(idx)

def adjacent_index(hero_index: U32, dir: U32) -> U32:
  λ{
    0: adjacent_up(hero_index);
    1: adjacent_down(hero_index);
    2: adjacent_left(hero_index);
    3: adjacent_right(hero_index);
    _ => 9
  }(dir)

def adjacent_up(hero_index: U32) -> U32:
  match hero_index < 3:
    case 0:
      hero_index - 3
    case _:
      9

def adjacent_down(hero_index: U32) -> U32:
  match hero_index < 6:
    case 0:
      9
    case _:
      hero_index + 3

def adjacent_left(hero_index: U32) -> U32:
  λ{
    0: 9;
    1: 0;
    2: 1;
    3: 9;
    4: 3;
    5: 4;
    6: 9;
    7: 6;
    8: 7;
    _ => 9
  }(hero_index)

def adjacent_right(hero_index: U32) -> U32:
  λ{
    0: 1;
    1: 2;
    2: 9;
    3: 4;
    4: 5;
    5: 9;
    6: 7;
    7: 8;
    8: 9;
    _ => 9
  }(hero_index)

def back_index(hero_index: U32, dir: U32) -> U32:
  λ{
    0: back_up(hero_index);
    1: back_down(hero_index);
    2: back_left(hero_index);
    3: back_right(hero_index);
    _ => 9
  }(dir)

def back_up(hero_index: U32) -> U32:
  match hero_index < 6:
    case 0:
      9
    case _:
      hero_index + 3

def back_down(hero_index: U32) -> U32:
  match hero_index < 3:
    case 0:
      hero_index - 3
    case _:
      9

def back_left(hero_index: U32) -> U32:
  λ{
    0: 1;
    1: 2;
    2: 9;
    3: 4;
    4: 5;
    5: 9;
    6: 7;
    7: 8;
    8: 9;
    _ => 9
  }(hero_index)

def back_right(hero_index: U32) -> U32:
  λ{
    0: 9;
    1: 0;
    2: 1;
    3: 9;
    4: 3;
    5: 4;
    6: 9;
    7: 6;
    8: 7;
    _ => 9
  }(hero_index)

def shift_after_move(
  board_value: Types.Board,
  hero_index: U32,
  target_index: U32,
  dir: U32,
  spawn: Types.Tile,
) -> Types.Board:
  board1 = board_set(board_value, target_index, none{});
  back = back_index(hero_index, dir);
  match back === 9:
    case 0:
      back_tile = board_get(board_value, back);
      board2 = board_set(board1, hero_index, back_tile);
      board_set(board2, back, spawn)
    case _:
      board_set(board1, hero_index, spawn)
