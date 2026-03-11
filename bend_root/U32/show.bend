def _go(n: U32, out: String) -> String:
  match n < 10:
    case 0:
      _go(n / 10, char{48 + (n % 10)}<>out)
    case _:
      char{48 + n}<>out

def show(n: U32) -> String:
  _go(n, [])
