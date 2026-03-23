import /Dungeon/Upgrade as Upgrade
import /Dungeon/MonsterDef as MonsterDef
import /Dungeon/SwordDef as SwordDef
import /Dungeon/PotionDef as PotionDef
import /Dungeon/DeckEntry as DeckEntry
import /Dungeon/Weapon as Weapon
import /Dungeon/Tile as Tile
import /Dungeon/Board as Board
import /Dungeon/BoardDraw as BoardDraw
import /Dungeon/DrawResult as DrawResult
import /Dungeon/CombatResult as CombatResult
import /Dungeon/Meta as Meta
import /Dungeon/Config as Config
import /Dungeon/Run as Run
import /Dungeon/SwipeResult as SwipeResult
import /Dungeon/RunSlot as RunSlot
import /Dungeon/DungeonEvent as DungeonEvent
import /Dungeon/DungeonState as DungeonState
import /Dungeon/ImpactState as ImpactState
import /Dungeon/_PickResult as _PickResult

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

def empty_board() -> Board:
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

def _up(hero_index: U32) -> U32:
  match hero_index < 3:
    case 0:
      hero_index - 3
    case _:
      9

def _down(hero_index: U32) -> U32:
  match hero_index < 6:
    case 0:
      9
    case _:
      hero_index + 3

def _left(hero_index: U32) -> U32:
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

def _right(hero_index: U32) -> U32:
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

def adjacent_index(hero_index: U32, dir: U32) -> U32:
  match dir:
    case 0:
      _up(hero_index)
    case 1:
      _down(hero_index)
    case 2:
      _left(hero_index)
    case 3:
      _right(hero_index)
    case _:
      9

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
