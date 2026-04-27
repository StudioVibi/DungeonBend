import Dungeon/PackInventoryEntry as PackInventoryEntry
def _pack_entry_count(entry: PackInventoryEntry) -> U32:
  match entry:
    case pack_inventory_entry{ref, count}:
      count

def _pack_entry_match(entry: PackInventoryEntry, ref: U32) -> U32:
  match entry:
    case pack_inventory_entry{entry_ref, count}:
      entry_ref === ref

def pack_inventory_count(entries: List(PackInventoryEntry), ref: U32) -> U32:
  match entries:
    case []:
      0
    case entry<>rest:
      _pack_inventory_count_match(_pack_entry_match(entry, ref), entry, rest, ref)

def _pack_inventory_count_match(matched: U32, entry: PackInventoryEntry, rest: List(PackInventoryEntry), ref: U32) -> U32:
  match matched:
    case 0:
      pack_inventory_count(rest, ref)
    case _:
      _pack_entry_count(entry)

def pack_inventory_total(entries: List(PackInventoryEntry)) -> U32:
  match entries:
    case []:
      0
    case entry<>rest:
      _pack_entry_count(entry) + pack_inventory_total(rest)

def add_pack(entries: List(PackInventoryEntry), ref: U32) -> List(PackInventoryEntry):
  match entries:
    case []:
      [pack_inventory_entry{ref, 1}]
    case entry<>rest:
      _add_pack_match(_pack_entry_match(entry, ref), entry, rest, ref)

def _add_pack_match(matched: U32, entry: PackInventoryEntry, rest: List(PackInventoryEntry), ref: U32) -> List(PackInventoryEntry):
  match matched:
    case 0:
      entry<>add_pack(rest, ref)
    case _:
      _increment_pack(entry)<>rest

def _increment_pack(entry: PackInventoryEntry) -> PackInventoryEntry:
  match entry:
    case pack_inventory_entry{ref, count}:
      pack_inventory_entry{ref, count + 1}

def consume_pack(entries: List(PackInventoryEntry), ref: U32) -> List(PackInventoryEntry):
  match entries:
    case []:
      []
    case entry<>rest:
      _consume_pack_match(_pack_entry_match(entry, ref), entry, rest, ref)

def _consume_pack_match(matched: U32, entry: PackInventoryEntry, rest: List(PackInventoryEntry), ref: U32) -> List(PackInventoryEntry):
  match matched:
    case 0:
      entry<>consume_pack(rest, ref)
    case _:
      _consume_pack_entry(entry, rest)

def _consume_pack_entry(entry: PackInventoryEntry, rest: List(PackInventoryEntry)) -> List(PackInventoryEntry):
  match entry:
    case pack_inventory_entry{ref, count}:
      match count:
        case 1:
          rest
        case _:
          pack_inventory_entry{ref, count - 1}<>rest
