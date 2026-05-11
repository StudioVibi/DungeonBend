import Dungeon/DeckDraft as DeckDraft
import Dungeon/DeckEntry as DeckEntry
import Dungeon/DeckRecord as DeckRecord
import Dungeon/DeckSleeve as DeckSleeve
import Dungeon/DeckCategory as DeckCategory
import Dungeon/DeckQuotas as DeckQuotas
import Dungeon/CardRef as CardRef
import Dungeon/Meta as Meta
import Dungeon/Config as Config
import Dungeon/Deck/sleeves/default_sleeve as default_sleeve
import Dungeon/Deck/counts_pick/card_ref_entry as card_ref_entry
import Dungeon/Deck/counts_pick/add_deck_entry as add_deck_entry
import Dungeon/Deck/counts_pick/deck_count_for_card as deck_count_for_card
import Dungeon/Deck/quotas/category_count as category_count
import Dungeon/Deck/quotas/quota_for_category as quota_for_category
import Dungeon/Deck/quotas/quotas_from_config as quotas_from_config
import Dungeon/Deck/card_collection/card_category as card_category
import Dungeon/Deck/card_collection/available_for_add as available_for_add

def draft_from_record(record: DeckRecord) -> DeckDraft:
  match record:
    case deck_record{id, name, sleeve, entries}:
      deck_draft{id, name, sleeve, entries, 0}

def empty_draft(deck_id: U32, name: String) -> DeckDraft:
  deck_draft{deck_id, name, default_sleeve(), [], 0}

def draft_id(draft: DeckDraft) -> U32:
  match draft:
    case deck_draft{deck_id, name, sleeve, entries, dirty}:
      deck_id

def draft_name(draft: DeckDraft) -> String:
  match draft:
    case deck_draft{deck_id, name, sleeve, entries, dirty}:
      name

def draft_sleeve(draft: DeckDraft) -> DeckSleeve:
  match draft:
    case deck_draft{deck_id, name, sleeve, entries, dirty}:
      sleeve

def draft_entries(draft: DeckDraft) -> List(DeckEntry):
  match draft:
    case deck_draft{deck_id, name, sleeve, entries, dirty}:
      entries

def draft_dirty(draft: DeckDraft) -> U32:
  match draft:
    case deck_draft{deck_id, name, sleeve, entries, dirty}:
      dirty

def draft_with_entries(draft: DeckDraft, next_entries: List(DeckEntry)) -> DeckDraft:
  match draft:
    case deck_draft{deck_id, name, sleeve, entries, dirty}:
      deck_draft{deck_id, name, sleeve, next_entries, 1}

def draft_with_name(draft: DeckDraft, next_name: String) -> DeckDraft:
  match draft:
    case deck_draft{deck_id, name, sleeve, entries, dirty}:
      deck_draft{deck_id, next_name, sleeve, entries, 1}

def draft_with_sleeve(draft: DeckDraft, next_sleeve: DeckSleeve) -> DeckDraft:
  match draft:
    case deck_draft{deck_id, name, sleeve, entries, dirty}:
      deck_draft{deck_id, name, next_sleeve, entries, dirty}

def draft_to_record(draft: DeckDraft) -> DeckRecord:
  match draft:
    case deck_draft{deck_id, name, sleeve, entries, dirty}:
      deck_record{deck_id, name, sleeve, entries}

def can_add_card(cfg: Config, meta_state: Meta, draft: DeckDraft, card: CardRef) -> U32:
  q = quotas_from_config(cfg);
  cat = card_category(card);
  cat_now = category_count(draft_entries(draft), cat);
  cat_max = quota_for_category(q, cat);
  pool_left = available_for_add(meta_state, draft_entries(draft), card);
  _can_add_match(cat_now < cat_max, pool_left)

def _can_add_match(cat_has_room: U32, pool_left: U32) -> U32:
  match cat_has_room:
    case 0:
      0
    case _:
      _pool_match(pool_left)

def _pool_match(pool_left: U32) -> U32:
  match pool_left:
    case 0:
      0
    case _:
      1

def add_card(draft: DeckDraft, card: CardRef) -> DeckDraft:
  next_entries = add_deck_entry(draft_entries(draft), card_ref_entry(card, 1));
  draft_with_entries(draft, next_entries)

def remove_card(draft: DeckDraft, card: CardRef) -> DeckDraft:
  next_entries = _remove_card_from(draft_entries(draft), card);
  draft_with_entries(draft, next_entries)

def _remove_card_from(entries: List(DeckEntry), card: CardRef) -> List(DeckEntry):
  match entries:
    case []:
      []
    case current<>rest:
      _remove_match(_entry_matches(current, card), current, rest, card)

def _remove_match(matched: U32, current: DeckEntry, rest: List(DeckEntry), card: CardRef) -> List(DeckEntry):
  match matched:
    case 0:
      current<>_remove_card_from(rest, card)
    case _:
      _decrement_or_drop(current, rest)

def _entry_matches(entry: DeckEntry, card: CardRef) -> U32:
  match entry card:
    case monster_entry{eref, count} monster_card{cref}:
      eref === cref
    case sword_entry{eref, count} sword_card{cref}:
      eref === cref
    case potion_entry{eref, count} potion_card{cref}:
      eref === cref
    case hero_entry{count} hero_card{}:
      1
    case _ _:
      0

def _decrement_or_drop(entry: DeckEntry, rest: List(DeckEntry)) -> List(DeckEntry):
  match entry:
    case monster_entry{ref, count}:
      _drop_or_keep_monster(ref, count, rest)
    case sword_entry{ref, count}:
      _drop_or_keep_sword(ref, count, rest)
    case potion_entry{ref, count}:
      _drop_or_keep_potion(ref, count, rest)
    case hero_entry{count}:
      _drop_or_keep_hero(count, rest)

def _drop_or_keep_monster(ref: U32, count: U32, rest: List(DeckEntry)) -> List(DeckEntry):
  match count:
    case 0:
      rest
    case 1:
      rest
    case _:
      monster_entry{ref, count - 1}<>rest

def _drop_or_keep_sword(ref: U32, count: U32, rest: List(DeckEntry)) -> List(DeckEntry):
  match count:
    case 0:
      rest
    case 1:
      rest
    case _:
      sword_entry{ref, count - 1}<>rest

def _drop_or_keep_potion(ref: U32, count: U32, rest: List(DeckEntry)) -> List(DeckEntry):
  match count:
    case 0:
      rest
    case 1:
      rest
    case _:
      potion_entry{ref, count - 1}<>rest

def _drop_or_keep_hero(count: U32, rest: List(DeckEntry)) -> List(DeckEntry):
  match count:
    case 0:
      rest
    case 1:
      rest
    case _:
      hero_entry{count - 1}<>rest
