def fill(-A: Type, width: Nat, height: Nat, value: A) -> Nat/V2/Map(A):
  map{_fill_rows(A, width, height, value)}

def _fill_rows(-A: Type, width: Nat, height: Nat, value: A) -> List(List(A)):
  match Nat.is_zero(height):
    case true{}:
      []
    case false{}:
      _fill_row(A, width, value) <> _fill_rows(A, width, Nat.sub(height, 1n), value)

def _fill_row(-A: Type, width: Nat, value: A) -> List(A):
  match Nat.is_zero(width):
    case true{}:
      []
    case false{}:
      value <> _fill_row(A, Nat.sub(width, 1n), value)
