import Dungeon/Meta as Meta
import Dungeon/Scene as Scene
import Dungeon/UiState as UiState
import Dungeon/DungeonEvent as DungeonEvent
import Dungeon/DungeonState as DungeonState
import Dungeon/DeckRecord as DeckRecord
import Dungeon/DeckDraft as DeckDraft
import Dungeon/DeckListMode as DeckListMode
import Dungeon/DeckPickerMode as DeckPickerMode
import Dungeon/DeckDetailMode as DeckDetailMode
import Dungeon/DeckCategory as DeckCategory
import Dungeon/CardRef as CardRef
import Dungeon/config as config
import Dungeon/default_ui as default_ui
import Dungeon/App/state_helpers/_state as _state
import Dungeon/profile_helpers/meta_decks as meta_decks
import Dungeon/profile_helpers/set_meta_decks as set_meta_decks
import Dungeon/profile_helpers/set_meta_active_deck_id as set_meta_active_deck_id
import Dungeon/Deck/deck_records/replace_deck as replace_deck
import Dungeon/Deck/deck_records/append_deck as append_deck
import Dungeon/Deck/deck_records/find_deck as find_deck
import Dungeon/Deck/deck_validation/is_deck_valid as is_deck_valid
import Dungeon/Deck/draft_ops/draft_id as draft_id
import Dungeon/Deck/draft_ops/draft_entries as draft_entries
import Dungeon/Deck/draft_ops/draft_dirty as draft_dirty
import Dungeon/Deck/draft_ops/draft_to_record as draft_to_record
import Dungeon/Deck/draft_ops/can_add_card as can_add_card
import Dungeon/Deck/draft_ops/add_card as add_card
import Dungeon/Deck/draft_ops/remove_card as remove_card
import Dungeon/Deck/card_collection/card_category as card_category
import Dungeon/Deck/quotas/deck_quotas_default as deck_quotas_default
import Dungeon/Deck/quotas/category_count as category_count
import Dungeon/Deck/quotas/quota_for_category as quota_for_category

def update_deck_detail(evt: DungeonEvent, meta_state: Meta, deck_id: U32, draft: DeckDraft, picker: DeckPickerMode, detail_mode: DeckDetailMode, next_seed_value: U32, ui_value: UiState) -> DungeonState:
  match evt:
    case request_close_deck_detail{}:
      _request_close(meta_state, deck_id, draft, picker, next_seed_value, ui_value)
    case close_deck_detail{}:
      _state(meta_state, deck_list{deck_list_view{}}, next_seed_value, default_ui())
    case discard_deck_changes{}:
      _state(meta_state, deck_list{deck_list_view{}}, next_seed_value, default_ui())
    case cancel_discard_deck_changes{}:
      _state(meta_state, deck_detail{deck_id, draft, picker, detail_view{}}, next_seed_value, ui_value)
    case add_card_to_deck{card}:
      _try_add(meta_state, deck_id, draft, picker, card, next_seed_value, ui_value)
    case remove_card_from_deck{card}:
      _try_remove(meta_state, deck_id, draft, picker, detail_mode, card, next_seed_value, ui_value)
    case save_deck_changes{}:
      _try_save(meta_state, deck_id, draft, picker, detail_mode, next_seed_value, ui_value)
    case set_active_deck{target_id}:
      _try_set_active(meta_state, deck_id, draft, picker, detail_mode, target_id, next_seed_value, ui_value)
    case open_category_picker{category}:
      _state(meta_state, deck_detail{deck_id, draft, picker_open{category}, detail_view{}}, next_seed_value, ui_value)
    case close_category_picker{}:
      _state(meta_state, deck_detail{deck_id, draft, picker_none{}, detail_view{}}, next_seed_value, ui_value)
    case _:
      _state(meta_state, deck_detail{deck_id, draft, picker, detail_mode}, next_seed_value, ui_value)

def _request_close(meta_state: Meta, deck_id: U32, draft: DeckDraft, picker: DeckPickerMode, next_seed_value: U32, ui_value: UiState) -> DungeonState:
  match draft_dirty(draft):
    case 0:
      _state(meta_state, deck_list{deck_list_view{}}, next_seed_value, default_ui())
    case _:
      _state(meta_state, deck_detail{deck_id, draft, picker, detail_confirm_discard{}}, next_seed_value, ui_value)

def _try_add(meta_state: Meta, deck_id: U32, draft: DeckDraft, picker: DeckPickerMode, card: CardRef, next_seed_value: U32, ui_value: UiState) -> DungeonState:
  match can_add_card(config(), meta_state, draft, card):
    case 1:
      _apply_add(meta_state, deck_id, draft, card, next_seed_value, ui_value)
    case _:
      _state(meta_state, deck_detail{deck_id, draft, picker, detail_view{}}, next_seed_value, ui_value)

def _apply_add(meta_state: Meta, deck_id: U32, draft: DeckDraft, card: CardRef, next_seed_value: U32, ui_value: UiState) -> DungeonState:
  next_draft = add_card(draft, card);
  next_picker = _next_picker_after_add(next_draft, card);
  _state(meta_state, deck_detail{deck_id, next_draft, next_picker, detail_view{}}, next_seed_value, ui_value)

def _try_remove(meta_state: Meta, deck_id: U32, draft: DeckDraft, picker: DeckPickerMode, detail_mode: DeckDetailMode, card: CardRef, next_seed_value: U32, ui_value: UiState) -> DungeonState:
  match _is_armed_for(detail_mode, card):
    case 1:
      _state(meta_state, deck_detail{deck_id, remove_card(draft, card), picker, detail_view{}}, next_seed_value, ui_value)
    case _:
      _state(meta_state, deck_detail{deck_id, draft, picker, detail_pending_delete{card}}, next_seed_value, ui_value)

def _is_armed_for(detail_mode: DeckDetailMode, card: CardRef) -> U32:
  match detail_mode:
    case detail_pending_delete{armed}:
      _card_ref_eq(armed, card)
    case _:
      0

def _card_ref_eq(left: CardRef, right: CardRef) -> U32:
  match left right:
    case hero_card{} hero_card{}:
      1
    case monster_card{l} monster_card{r}:
      l === r
    case sword_card{l} sword_card{r}:
      l === r
    case potion_card{l} potion_card{r}:
      l === r
    case _ _:
      0

def _next_picker_after_add(draft: DeckDraft, card: CardRef) -> DeckPickerMode:
  cat = card_category(card);
  used = category_count(draft_entries(draft), cat);
  cap = quota_for_category(deck_quotas_default(), cat);
  match used < cap:
    case 1:
      picker_open{cat}
    case _:
      picker_none{}

def _try_save(meta_state: Meta, deck_id: U32, draft: DeckDraft, picker: DeckPickerMode, detail_mode: DeckDetailMode, next_seed_value: U32, ui_value: UiState) -> DungeonState:
  match is_deck_valid(config(), meta_state, draft_entries(draft)):
    case 1:
      _apply_save(meta_state, deck_id, draft, picker, detail_mode, next_seed_value)
    case _:
      _state(meta_state, deck_detail{deck_id, draft, picker, detail_mode}, next_seed_value, ui_value)

def _apply_save(meta_state: Meta, deck_id: U32, draft: DeckDraft, picker: DeckPickerMode, detail_mode: DeckDetailMode, next_seed_value: U32) -> DungeonState:
  next_record = draft_to_record(draft);
  next_decks = _upsert_deck(meta_decks(meta_state), next_record);
  next_meta = set_meta_decks(meta_state, next_decks);
  reset_draft : DeckDraft = deck_draft{deck_id, _draft_name(draft), draft_entries(draft), 0};
  _state(next_meta, deck_detail{deck_id, reset_draft, picker, detail_mode}, next_seed_value, default_ui())

def _draft_name(draft: DeckDraft) -> String:
  match draft:
    case deck_draft{id, name, entries, dirty}:
      name

def _upsert_deck(records: List(DeckRecord), next_record: DeckRecord) -> List(DeckRecord):
  match find_deck(records, _record_id_of(next_record)):
    case some{existing}:
      replace_deck(records, next_record)
    case none{}:
      append_deck(records, next_record)

def _record_id_of(record: DeckRecord) -> U32:
  match record:
    case deck_record{id, name, entries}:
      id

def _try_set_active(meta_state: Meta, deck_id: U32, draft: DeckDraft, picker: DeckPickerMode, detail_mode: DeckDetailMode, target_id: U32, next_seed_value: U32, ui_value: UiState) -> DungeonState:
  match draft_dirty(draft):
    case 0:
      _set_active_if_valid(meta_state, deck_id, draft, picker, detail_mode, target_id, next_seed_value)
    case _:
      _state(meta_state, deck_detail{deck_id, draft, picker, detail_mode}, next_seed_value, ui_value)

def _set_active_if_valid(meta_state: Meta, deck_id: U32, draft: DeckDraft, picker: DeckPickerMode, detail_mode: DeckDetailMode, target_id: U32, next_seed_value: U32) -> DungeonState:
  match find_deck(meta_decks(meta_state), target_id):
    case some{record}:
      _state(set_meta_active_deck_id(meta_state, target_id), deck_detail{deck_id, draft, picker, detail_mode}, next_seed_value, default_ui())
    case none{}:
      _state(meta_state, deck_detail{deck_id, draft, picker, detail_mode}, next_seed_value, default_ui())
