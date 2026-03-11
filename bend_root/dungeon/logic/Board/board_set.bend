import /dungeon/logic/Board
import /dungeon/logic/Tile

def board_set(board_value: Board, idx: U32, tile: Tile) -> Board:
  match board_value:
    case board{c0, c1, c2, c3, c4, c5, c6, c7, c8}:
      pick = λ{
        0: (board{tile, c1, c2, c3, c4, c5, c6, c7, c8} :: Board);
        1: (board{c0, tile, c2, c3, c4, c5, c6, c7, c8} :: Board);
        2: (board{c0, c1, tile, c3, c4, c5, c6, c7, c8} :: Board);
        3: (board{c0, c1, c2, tile, c4, c5, c6, c7, c8} :: Board);
        4: (board{c0, c1, c2, c3, tile, c5, c6, c7, c8} :: Board);
        5: (board{c0, c1, c2, c3, c4, tile, c6, c7, c8} :: Board);
        6: (board{c0, c1, c2, c3, c4, c5, tile, c7, c8} :: Board);
        7: (board{c0, c1, c2, c3, c4, c5, c6, tile, c8} :: Board);
        8: (board{c0, c1, c2, c3, c4, c5, c6, c7, tile} :: Board);
        _ => (board{c0, c1, c2, c3, c4, c5, c6, c7, c8} :: Board)
      };
      pick(idx)
