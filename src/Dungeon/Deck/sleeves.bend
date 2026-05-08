import Dungeon/DeckSleeve as DeckSleeve

def default_sleeve() -> DeckSleeve:
  sleeve_blue{}

def sleeve_code(sleeve: DeckSleeve) -> String:
  match sleeve:
    case sleeve_blue{}:
      "blue"
    case sleeve_chromatic{}:
      "chromatic"

def sleeve_from_code(code: String) -> DeckSleeve:
  match String/eq(code, "chromatic"):
    case true{}:
      sleeve_chromatic{}
    case false{}:
      sleeve_blue{}

def sleeve_eq(left: DeckSleeve, right: DeckSleeve) -> U32:
  match left right:
    case sleeve_blue{} sleeve_blue{}:
      1
    case sleeve_chromatic{} sleeve_chromatic{}:
      1
    case _ _:
      0
