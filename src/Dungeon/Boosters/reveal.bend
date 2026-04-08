import /Dungeon/CardRef as CardRef
import /Dungeon/PackDef as PackDef
import /Dungeon/PackPoolEntry as PackPoolEntry
import /Dungeon/PackReward as PackReward
import /Dungeon/PackOpenResult as PackOpenResult
import /Dungeon/_PackPickResult as _PackPickResult
import /Dungeon/Deck/counts_pick/next_seed as next_seed

def _pool_weight(entry: PackPoolEntry) -> U32:
  match entry:
    case pack_pool_entry{card, weight}:
      weight

def _pool_card(entry: PackPoolEntry) -> CardRef:
  match entry:
    case pack_pool_entry{card, weight}:
      card

def sum_pool_weights(pool: List(PackPoolEntry)) -> U32:
  match pool:
    case []:
      0
    case entry<>rest:
      _pool_weight(entry) + sum_pool_weights(rest)

def _prepend_pool_entry(entry: PackPoolEntry, result: _PackPickResult) -> _PackPickResult:
  match result:
    case no_pack_pick{pool}:
      no_pack_pick{entry<>pool}
    case picked_pack_entry{card, pool}:
      picked_pack_entry{card, entry<>pool}

def _pick_pool_hit_keep(entry: PackPoolEntry, rest: List(PackPoolEntry)) -> _PackPickResult:
  picked_pack_entry{_pool_card(entry), entry<>rest}

def _pick_pool_hit_remove(entry: PackPoolEntry, rest: List(PackPoolEntry)) -> _PackPickResult:
  picked_pack_entry{_pool_card(entry), rest}

def _pick_pool_hit(entry: PackPoolEntry, rest: List(PackPoolEntry), allow_duplicates: U32) -> _PackPickResult:
  match allow_duplicates:
    case 0:
      _pick_pool_hit_remove(entry, rest)
    case _:
      _pick_pool_hit_keep(entry, rest)

def _pick_pool_rest(entry: PackPoolEntry, rest: List(PackPoolEntry), idx: U32, allow_duplicates: U32) -> _PackPickResult:
  _prepend_pool_entry(entry, _pick_pool_entry(rest, idx - _pool_weight(entry), allow_duplicates))

def _pick_pool_entry_step(entry: PackPoolEntry, rest: List(PackPoolEntry), idx: U32, allow_duplicates: U32) -> _PackPickResult:
  _pick_pool_entry_match(idx < _pool_weight(entry), entry, rest, idx, allow_duplicates)

def _pick_pool_entry_match(hit: U32, entry: PackPoolEntry, rest: List(PackPoolEntry), idx: U32, allow_duplicates: U32) -> _PackPickResult:
  match hit:
    case 0:
      _pick_pool_rest(entry, rest, idx, allow_duplicates)
    case _:
      _pick_pool_hit(entry, rest, allow_duplicates)

def _pick_pool_entry(pool: List(PackPoolEntry), idx: U32, allow_duplicates: U32) -> _PackPickResult:
  match pool:
    case []:
      no_pack_pick{[]}
    case entry<>rest:
      _pick_pool_entry_step(entry, rest, idx, allow_duplicates)

def _reverse_cards(cards: List(CardRef), acc: List(CardRef)) -> List(CardRef):
  match cards:
    case []:
      acc
    case card<>rest:
      _reverse_cards(rest, card<>acc)

def _reward_from_cards(cards: List(CardRef)) -> PackReward:
  match cards:
    case []:
      no_pack_reward{}
    case _:
      pack_reward{_reverse_cards(cards, [])}

def _draw_pack_cards_from_pick(remaining: U32, allow_duplicates: U32, seed: U32, cards: List(CardRef), result: _PackPickResult) -> PackOpenResult:
  match result:
    case no_pack_pick{pool}:
      pack_open_result{_reward_from_cards(cards), seed}
    case picked_pack_entry{card, next_pool}:
      _draw_pack_cards(remaining - 1, allow_duplicates, next_pool, seed, card<>cards)

def _draw_pack_cards_with_total(remaining: U32, allow_duplicates: U32, pool: List(PackPoolEntry), total_weight: U32, seed: U32, cards: List(CardRef)) -> PackOpenResult:
  match total_weight:
    case 0:
      pack_open_result{_reward_from_cards(cards), seed}
    case _:
      idx = seed % total_weight;
      next = next_seed(seed);
      _draw_pack_cards_from_pick(remaining, allow_duplicates, next, cards, _pick_pool_entry(pool, idx, allow_duplicates))

def _draw_pack_cards(remaining: U32, allow_duplicates: U32, pool: List(PackPoolEntry), seed: U32, cards: List(CardRef)) -> PackOpenResult:
  match remaining:
    case 0:
      pack_open_result{_reward_from_cards(cards), seed}
    case _:
      _draw_pack_cards_with_total(remaining, allow_duplicates, pool, sum_pool_weights(pool), seed, cards)

def open_pack(pack: PackDef, seed: U32) -> PackOpenResult:
  match pack:
    case pack_def{name, price, reveal_count, allow_duplicates, pool}:
      _draw_pack_cards(reveal_count, allow_duplicates, pool, seed, [])
