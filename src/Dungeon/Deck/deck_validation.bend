import Dungeon/DeckEntry as DeckEntry
import Dungeon/DeckQuotas as DeckQuotas
import Dungeon/DeckCategory as DeckCategory
import Dungeon/CardRef as CardRef
import Dungeon/Meta as Meta
import Dungeon/Config as Config
import Dungeon/Deck/quotas/category_count as category_count
import Dungeon/Deck/quotas/quotas_from_config as quotas_from_config
import Dungeon/Deck/quotas/quota_for_category as quota_for_category
import Dungeon/Deck/quotas/quotas_total as quotas_total
import Dungeon/Deck/card_collection/pool_quantity as pool_quantity
import Dungeon/Deck/card_collection/entry_card_ref as entry_card_ref
import Dungeon/Deck/card_collection/entry_count as entry_count

def category_match(entries: List(DeckEntry), q: DeckQuotas, cat: DeckCategory) -> U32:
  category_count(entries, cat) === quota_for_category(q, cat)

def all_quotas_match(entries: List(DeckEntry), q: DeckQuotas) -> U32:
  m = category_match(entries, q, cat_monsters{});
  s = category_match(entries, q, cat_swords{});
  p = category_match(entries, q, cat_potions{});
  h = category_match(entries, q, cat_hero{});
  _and(_and(m, s), _and(p, h))

def _and(a: U32, b: U32) -> U32:
  match a:
    case 0:
      0
    case _:
      b

def entries_within_pool(entries: List(DeckEntry), meta_state: Meta) -> U32:
  match entries:
    case []:
      1
    case current<>rest:
      _entry_within_pool(current, meta_state, rest)

def _entry_within_pool(current: DeckEntry, meta_state: Meta, rest: List(DeckEntry)) -> U32:
  card = entry_card_ref(current);
  used = entry_count(current);
  pool = pool_quantity(meta_state, card);
  _entry_within_match(used <= pool, rest, meta_state)

def _entry_within_match(within: U32, rest: List(DeckEntry), meta_state: Meta) -> U32:
  match within:
    case 0:
      0
    case _:
      entries_within_pool(rest, meta_state)

def is_deck_valid(cfg: Config, meta_state: Meta, entries: List(DeckEntry)) -> U32:
  q = quotas_from_config(cfg);
  _and(all_quotas_match(entries, q), entries_within_pool(entries, meta_state))

def deck_total_count(entries: List(DeckEntry)) -> U32:
  match entries:
    case []:
      0
    case current<>rest:
      entry_count(current) + deck_total_count(rest)
