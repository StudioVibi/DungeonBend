import /dungeon/logic/DeckEntry

def sum_counts(entries: List(DeckEntry)) -> U32:
  match entries:
    case []:
      0
    case deck_entry{kind, ref, count}<>rest:
      count + sum_counts(rest)
