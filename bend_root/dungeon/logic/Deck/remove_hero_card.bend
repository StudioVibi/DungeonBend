import /dungeon/logic/DeckEntry

def _remove_entry(kind: U32, ref: U32, count: U32, rest: List(DeckEntry)) -> List(DeckEntry):
  match kind === 3:
    case 0:
      (deck_entry{kind, ref, count}<>remove_hero_card(rest) :: List(DeckEntry))
    case _:
      _remove_keep(ref, count, rest)

def _remove_keep(ref: U32, count: U32, rest: List(DeckEntry)) -> List(DeckEntry):
  match count === 1:
    case 0:
      (deck_entry{3, ref, count - 1}<>rest :: List(DeckEntry))
    case _:
      (rest :: List(DeckEntry))

def remove_hero_card(entries: List(DeckEntry)) -> List(DeckEntry):
  match entries:
    case []:
      []
    case deck_entry{kind, ref, count}<>rest:
      _remove_entry(kind, ref, count, rest)
