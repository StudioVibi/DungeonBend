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
