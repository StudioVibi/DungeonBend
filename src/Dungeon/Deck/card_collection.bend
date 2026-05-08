import Dungeon/DeckEntry as DeckEntry
import Dungeon/DeckCategory as DeckCategory
import Dungeon/CardRef as CardRef
import Dungeon/Meta as Meta
import Dungeon/Config as Config
import Dungeon/config as config
import Dungeon/Deck/counts_pick/merge_deck_entries as merge_deck_entries
import Dungeon/Deck/counts_pick/deck_count_for_card as deck_count_for_card
import Dungeon/profile_helpers/meta_bonus_deck as meta_bonus_deck

def collection_entries(cfg: Config, meta_state: Meta) -> List(DeckEntry):
  match cfg:
    case config{heroes, monsters, swords, potions, deck, booster_packs, starting_dungeon_level}:
      merge_deck_entries(deck, meta_bonus_deck(meta_state))

def collection_entries_default(meta_state: Meta) -> List(DeckEntry):
  collection_entries(config(), meta_state)

def pool_quantity(meta_state: Meta, card: CardRef) -> U32:
  deck_count_for_card(collection_entries_default(meta_state), card)

def deck_quantity(entries: List(DeckEntry), card: CardRef) -> U32:
  deck_count_for_card(entries, card)

def available_for_add(meta_state: Meta, draft_entries: List(DeckEntry), card: CardRef) -> U32:
  pool = pool_quantity(meta_state, card);
  used = deck_quantity(draft_entries, card);
  _saturating_sub(pool, used)

def _saturating_sub(a: U32, b: U32) -> U32:
  match a < b:
    case 1:
      0
    case _:
      a - b

def entry_card_ref(entry: DeckEntry) -> CardRef:
  match entry:
    case monster_entry{ref, count}:
      monster_card{ref}
    case sword_entry{ref, count}:
      sword_card{ref}
    case potion_entry{ref, count}:
      potion_card{ref}
    case hero_entry{count}:
      hero_card{}

def entry_count(entry: DeckEntry) -> U32:
  match entry:
    case monster_entry{ref, count}:
      count
    case sword_entry{ref, count}:
      count
    case potion_entry{ref, count}:
      count
    case hero_entry{count}:
      count

def entry_category(entry: DeckEntry) -> DeckCategory:
  match entry:
    case monster_entry{ref, count}:
      cat_monsters{}
    case sword_entry{ref, count}:
      cat_swords{}
    case potion_entry{ref, count}:
      cat_potions{}
    case hero_entry{count}:
      cat_hero{}

def card_category(card: CardRef) -> DeckCategory:
  match card:
    case monster_card{ref}:
      cat_monsters{}
    case sword_card{ref}:
      cat_swords{}
    case potion_card{ref}:
      cat_potions{}
    case hero_card{}:
      cat_hero{}

def filter_entries_by_category(entries: List(DeckEntry), cat: DeckCategory) -> List(DeckEntry):
  match entries:
    case []:
      []
    case current<>rest:
      _filter_match(_entry_in_category(current, cat), current, rest, cat)

def _filter_match(matches: U32, current: DeckEntry, rest: List(DeckEntry), cat: DeckCategory) -> List(DeckEntry):
  match matches:
    case 0:
      filter_entries_by_category(rest, cat)
    case _:
      current<>filter_entries_by_category(rest, cat)

def _entry_in_category(entry: DeckEntry, cat: DeckCategory) -> U32:
  match entry cat:
    case monster_entry{ref, count} cat_monsters{}:
      1
    case sword_entry{ref, count} cat_swords{}:
      1
    case potion_entry{ref, count} cat_potions{}:
      1
    case hero_entry{count} cat_hero{}:
      1
    case _ _:
      0
