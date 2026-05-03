def get(-A: Type, grid: Nat/V2/Map(A), pos: Nat/V2) -> Maybe(A):
  match grid pos:
    case map{rows} v2{x, y}:
      _get_row(A, rows, y, x)

def _get_row(-A: Type, rows: List(List(A)), y: Nat, x: Nat) -> Maybe(A):
  match rows:
    case []:
      none{}
    case row<>rest:
      match Nat.is_zero(y):
        case true{}:
          _get_cell(A, row, x)
        case false{}:
          _get_row(A, rest, Nat.sub(y, 1n), x)

def _get_cell(-A: Type, row: List(A), x: Nat) -> Maybe(A):
  match row:
    case []:
      none{}
    case item<>rest:
      match Nat.is_zero(x):
        case true{}:
          some{item}
        case false{}:
          _get_cell(A, rest, Nat.sub(x, 1n))
