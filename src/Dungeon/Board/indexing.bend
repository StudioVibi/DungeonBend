import Nat as Nat
import Nat/V2/Map/fill as map_fill
import Nat/V2/Map/get as map_get
import Nat/V2/Map/set as map_set
import Dungeon/Board as Board
import Dungeon/Tile as Tile
import Dungeon/Direction as Direction

def board_xy_pos(x: U32, y: U32) -> Nat/V2:
  v2{U32/to_nat(x), U32/to_nat(y)}

def board_pos(idx: U32) -> Nat/V2:
  match idx:
    case 0:
      v2{0n, 0n}
    case 1:
      v2{1n, 0n}
    case 2:
      v2{2n, 0n}
    case 3:
      v2{0n, 1n}
    case 4:
      v2{1n, 1n}
    case 5:
      v2{2n, 1n}
    case 6:
      v2{0n, 2n}
    case 7:
      v2{1n, 2n}
    case 8:
      v2{2n, 2n}
    case _:
      v2{0n, 0n}

def board_index(pos: Nat/V2) -> U32:
  match pos:
    case v2{x, y}:
      Nat.to_u32(x) + (Nat.to_u32(y) * 3)

def board_get_pos(board_value: Board, pos: Nat/V2) -> Tile:
  match board_value:
    case board{cells}:
      _board_get_found(map_get(Tile, cells, pos))

def _board_get_found(found: Maybe(Tile)) -> Tile:
  match found:
    case none{}:
      none{}
    case some{tile}:
      tile

def board_get(board_value: Board, idx: U32) -> Tile:
  board_get_pos(board_value, board_pos(idx))

def board_set_pos(board_value: Board, pos: Nat/V2, tile: Tile) -> Board:
  match board_value:
    case board{cells}:
      board{map_set(Tile, cells, pos, tile)}

def board_set(board_value: Board, idx: U32, tile: Tile) -> Board:
  board_set_pos(board_value, board_pos(idx), tile)

def empty_board() -> Board:
  board{map_fill(Tile, 3n, 3n, none{})}

def same_pos(a: Nat/V2, b: Nat/V2) -> U32:
  match a b:
    case v2{ax, ay} v2{bx, by}:
      _same_pos_flags(Nat.eq(ax, bx), Nat.eq(ay, by))

def _same_pos_flags(x_eq: Bool, y_eq: Bool) -> U32:
  match x_eq y_eq:
    case true{} true{}:
      1
    case _ _:
      0

def _step_up(x: Nat, y: Nat) -> Maybe(Nat/V2):
  _step_up_zero(Nat.is_zero(y), x, y)

def _step_up_zero(at_top: Bool, x: Nat, y: Nat) -> Maybe(Nat/V2):
  match at_top:
    case true{}:
      none{}
    case false{}:
      some{v2{x, Nat.sub(y, 1n)}}

def _step_down(x: Nat, y: Nat) -> Maybe(Nat/V2):
  _step_down_edge(Nat.eq(y, 2n), x, y)

def _step_down_edge(at_bottom: Bool, x: Nat, y: Nat) -> Maybe(Nat/V2):
  match at_bottom:
    case true{}:
      none{}
    case false{}:
      some{v2{x, Nat.add(y, 1n)}}

def _step_left(x: Nat, y: Nat) -> Maybe(Nat/V2):
  _step_left_edge(Nat.is_zero(x), x, y)

def _step_left_edge(at_left: Bool, x: Nat, y: Nat) -> Maybe(Nat/V2):
  match at_left:
    case true{}:
      none{}
    case false{}:
      some{v2{Nat.sub(x, 1n), y}}

def _step_right(x: Nat, y: Nat) -> Maybe(Nat/V2):
  _step_right_edge(Nat.eq(x, 2n), x, y)

def _step_right_edge(at_right: Bool, x: Nat, y: Nat) -> Maybe(Nat/V2):
  match at_right:
    case true{}:
      none{}
    case false{}:
      some{v2{Nat.add(x, 1n), y}}

def _step_pos(pos: Nat/V2, dir: Direction) -> Maybe(Nat/V2):
  match pos dir:
    case v2{x, y} up{}:
      _step_up(x, y)
    case v2{x, y} down{}:
      _step_down(x, y)
    case v2{x, y} left{}:
      _step_left(x, y)
    case v2{x, y} right{}:
      _step_right(x, y)

def adjacent_pos(hero_index: U32, dir: Direction) -> Maybe(Nat/V2):
  _step_pos(board_pos(hero_index), dir)

def _back_dir(dir: Direction) -> Direction:
  match dir:
    case up{}:
      down{}
    case down{}:
      up{}
    case left{}:
      right{}
    case right{}:
      left{}

def back_pos(hero_index: U32, dir: Direction) -> Maybe(Nat/V2):
  _step_pos(board_pos(hero_index), _back_dir(dir))
