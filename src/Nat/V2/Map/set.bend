def set(-A: Type, grid: Nat/V2/Map(A), pos: Nat/V2, value: A) -> Nat/V2/Map(A):
  match grid pos:
    case map{rows} v2{x, y}:
      map{_set_row(A, rows, y, x, value)}

def _set_row(-A: Type, rows: List(List(A)), y: Nat, x: Nat, value: A) -> List(List(A)):
  match rows:
    case []:
      []
    case row<>rest:
      match Nat.is_zero(y):
        case true{}:
          _set_cell(A, row, x, value) <> rest
        case false{}:
          row <> _set_row(A, rest, Nat.sub(y, 1n), x, value)

def _set_cell(-A: Type, row: List(A), x: Nat, value: A) -> List(A):
  match row:
    case []:
      []
    case item<>rest:
      match Nat.is_zero(x):
        case true{}:
          value <> rest
        case false{}:
          item <> _set_cell(A, rest, Nat.sub(x, 1n), value)
