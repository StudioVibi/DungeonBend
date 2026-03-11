import /dungeon/logic/Board
import /dungeon/logic/Tile

def board_get(board_value: Board, idx: U32) -> Tile:
  match board_value:
    case board{c0, c1, c2, c3, c4, c5, c6, c7, c8}:
      pick = λ{
        0: c0;
        1: c1;
        2: c2;
        3: c3;
        4: c4;
        5: c5;
        6: c6;
        7: c7;
        8: c8;
        _ => none{}
      };
      pick(idx)
