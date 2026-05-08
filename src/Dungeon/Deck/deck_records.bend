import Dungeon/DeckEntry as DeckEntry
import Dungeon/DeckRecord as DeckRecord

def initial_deck_id() -> U32:
  0

def initial_deck_name() -> String:
  "Initial Deck"

def is_initial_deck(deck_id: U32) -> U32:
  deck_id === initial_deck_id()

def deck_record_id(record: DeckRecord) -> U32:
  match record:
    case deck_record{id, name, entries}:
      id

def deck_record_name(record: DeckRecord) -> String:
  match record:
    case deck_record{id, name, entries}:
      name

def deck_record_entries(record: DeckRecord) -> List(DeckEntry):
  match record:
    case deck_record{id, name, entries}:
      entries

def deck_record_with_name(record: DeckRecord, next_name: String) -> DeckRecord:
  match record:
    case deck_record{id, name, entries}:
      deck_record{id, next_name, entries}

def deck_record_with_entries(record: DeckRecord, next_entries: List(DeckEntry)) -> DeckRecord:
  match record:
    case deck_record{id, name, entries}:
      deck_record{id, name, next_entries}

def find_deck(records: List(DeckRecord), deck_id: U32) -> Maybe(DeckRecord):
  match records:
    case []:
      none{}
    case current<>rest:
      _find_deck_match(deck_record_id(current) === deck_id, current, rest, deck_id)

def _find_deck_match(matched: U32, current: DeckRecord, rest: List(DeckRecord), deck_id: U32) -> Maybe(DeckRecord):
  match matched:
    case 0:
      find_deck(rest, deck_id)
    case _:
      some{current}

def find_deck_or(records: List(DeckRecord), deck_id: U32, fallback: DeckRecord) -> DeckRecord:
  match find_deck(records, deck_id):
    case some{record}:
      record
    case none{}:
      fallback

def deck_count(records: List(DeckRecord)) -> U32:
  match records:
    case []:
      0
    case current<>rest:
      1 + deck_count(rest)

def replace_deck(records: List(DeckRecord), next_record: DeckRecord) -> List(DeckRecord):
  match records:
    case []:
      [next_record]
    case current<>rest:
      _replace_deck_match(deck_record_id(current) === deck_record_id(next_record), current, rest, next_record)

def _replace_deck_match(matched: U32, current: DeckRecord, rest: List(DeckRecord), next_record: DeckRecord) -> List(DeckRecord):
  match matched:
    case 0:
      current<>replace_deck(rest, next_record)
    case _:
      next_record<>rest

def append_deck(records: List(DeckRecord), next_record: DeckRecord) -> List(DeckRecord):
  match records:
    case []:
      [next_record]
    case current<>rest:
      current<>append_deck(rest, next_record)

def remove_deck_by_id(records: List(DeckRecord), deck_id: U32) -> List(DeckRecord):
  match records:
    case []:
      []
    case current<>rest:
      _remove_deck_match(deck_record_id(current) === deck_id, current, rest, deck_id)

def _remove_deck_match(matched: U32, current: DeckRecord, rest: List(DeckRecord), deck_id: U32) -> List(DeckRecord):
  match matched:
    case 0:
      current<>remove_deck_by_id(rest, deck_id)
    case _:
      remove_deck_by_id(rest, deck_id)

def remove_decks_by_ids(records: List(DeckRecord), ids: List(U32)) -> List(DeckRecord):
  match ids:
    case []:
      records
    case head<>rest:
      _remove_decks_filter_initial(records, head, rest)

def _remove_decks_filter_initial(records: List(DeckRecord), head: U32, rest: List(U32)) -> List(DeckRecord):
  match head === initial_deck_id():
    case 1:
      remove_decks_by_ids(records, rest)
    case _:
      remove_decks_by_ids(remove_deck_by_id(records, head), rest)

def list_contains_id(ids: List(U32), value: U32) -> U32:
  match ids:
    case []:
      0
    case head<>rest:
      _contains_id_match(head === value, rest, value)

def _contains_id_match(matched: U32, rest: List(U32), value: U32) -> U32:
  match matched:
    case 0:
      list_contains_id(rest, value)
    case _:
      1

def toggle_id_in_list(ids: List(U32), value: U32) -> List(U32):
  match list_contains_id(ids, value):
    case 1:
      _remove_id(ids, value)
    case _:
      value<>ids

def _remove_id(ids: List(U32), value: U32) -> List(U32):
  match ids:
    case []:
      []
    case head<>rest:
      _remove_id_match(head === value, head, rest, value)

def _remove_id_match(matched: U32, head: U32, rest: List(U32), value: U32) -> List(U32):
  match matched:
    case 0:
      head<>_remove_id(rest, value)
    case _:
      rest

def list_size(ids: List(U32)) -> U32:
  match ids:
    case []:
      0
    case head<>rest:
      1 + list_size(rest)
