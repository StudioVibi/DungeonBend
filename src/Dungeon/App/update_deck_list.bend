import Dungeon/Meta as Meta
import Dungeon/Scene as Scene
import Dungeon/UiState as UiState
import Dungeon/DungeonEvent as DungeonEvent
import Dungeon/DungeonState as DungeonState
import Dungeon/DeckListMode as DeckListMode
import Dungeon/DeckEntry as DeckEntry
import Dungeon/DeckRecord as DeckRecord
import Dungeon/DeckDraft as DeckDraft
import Dungeon/DeckDetailMode as DeckDetailMode
import Dungeon/config as config
import Dungeon/default_ui as default_ui
import Dungeon/App/state_helpers/_state as _state
import Dungeon/profile_helpers/meta_decks as meta_decks
import Dungeon/profile_helpers/meta_active_deck_id as meta_active_deck_id
import Dungeon/profile_helpers/meta_next_deck_id as meta_next_deck_id
import Dungeon/profile_helpers/set_meta_decks as set_meta_decks
import Dungeon/profile_helpers/set_meta_active_deck_id as set_meta_active_deck_id
import Dungeon/profile_helpers/set_meta_next_deck_id as set_meta_next_deck_id
import Dungeon/Deck/deck_records/initial_deck_id as initial_deck_id
import Dungeon/Deck/deck_records/find_deck as find_deck
import Dungeon/Deck/deck_records/append_deck as append_deck
import Dungeon/Deck/deck_records/remove_decks_by_ids as remove_decks_by_ids
import Dungeon/Deck/deck_records/list_contains_id as list_contains_id
import Dungeon/Deck/deck_records/toggle_id_in_list as toggle_id_in_list
import Dungeon/Deck/deck_records/list_size as list_size
import Dungeon/Deck/draft_ops/draft_from_record as draft_from_record
import Dungeon/Deck/draft_ops/empty_draft as empty_draft

def update_deck_list(evt: DungeonEvent, meta_state: Meta, mode: DeckListMode, next_seed_value: U32, ui_value: UiState) -> DungeonState:
  match evt:
    case close_deck_list{}:
      _state(meta_state, setup{}, next_seed_value, default_ui())
    case enter_deck_edit_mode{}:
      _state(meta_state, deck_list{deck_list_edit{[]}}, next_seed_value, ui_value)
    case exit_deck_edit_mode{}:
      _state(meta_state, deck_list{deck_list_view{}}, next_seed_value, ui_value)
    case toggle_deck_select{deck_id}:
      _toggle(meta_state, mode, deck_id, next_seed_value, ui_value)
    case request_delete_decks{}:
      _request_delete(meta_state, mode, next_seed_value, ui_value)
    case cancel_delete_decks{}:
      _cancel_delete(meta_state, mode, next_seed_value, ui_value)
    case confirm_delete_decks{}:
      _confirm_delete(meta_state, mode, next_seed_value, ui_value)
    case create_new_deck{}:
      _create_deck(meta_state, next_seed_value, ui_value)
    case open_deck_detail{deck_id}:
      _open_detail(meta_state, deck_id, next_seed_value, ui_value)
    case set_active_deck{deck_id}:
      _set_active(meta_state, deck_id, mode, next_seed_value, ui_value)
    case _:
      _state(meta_state, deck_list{mode}, next_seed_value, ui_value)

def _toggle(meta_state: Meta, mode: DeckListMode, deck_id: U32, next_seed_value: U32, ui_value: UiState) -> DungeonState:
  match deck_id === initial_deck_id():
    case 1:
      _state(meta_state, deck_list{mode}, next_seed_value, ui_value)
    case _:
      _state(meta_state, deck_list{_mode_with_toggle(mode, deck_id)}, next_seed_value, ui_value)

def _mode_with_toggle(mode: DeckListMode, deck_id: U32) -> DeckListMode:
  match mode:
    case deck_list_edit{ids}:
      deck_list_edit{toggle_id_in_list(ids, deck_id)}
    case _:
      mode

def _request_delete(meta_state: Meta, mode: DeckListMode, next_seed_value: U32, ui_value: UiState) -> DungeonState:
  match mode:
    case deck_list_edit{ids}:
      _request_delete_check(meta_state, ids, next_seed_value, ui_value)
    case _:
      _state(meta_state, deck_list{mode}, next_seed_value, ui_value)

def _request_delete_check(meta_state: Meta, ids: List(U32), next_seed_value: U32, ui_value: UiState) -> DungeonState:
  match list_size(ids):
    case 0:
      _state(meta_state, deck_list{deck_list_edit{ids}}, next_seed_value, ui_value)
    case _:
      _state(meta_state, deck_list{deck_list_confirm_delete{ids}}, next_seed_value, ui_value)

def _cancel_delete(meta_state: Meta, mode: DeckListMode, next_seed_value: U32, ui_value: UiState) -> DungeonState:
  match mode:
    case deck_list_confirm_delete{ids}:
      _state(meta_state, deck_list{deck_list_edit{ids}}, next_seed_value, ui_value)
    case _:
      _state(meta_state, deck_list{mode}, next_seed_value, ui_value)

def _confirm_delete(meta_state: Meta, mode: DeckListMode, next_seed_value: U32, ui_value: UiState) -> DungeonState:
  match mode:
    case deck_list_confirm_delete{ids}:
      _apply_delete(meta_state, ids, next_seed_value, ui_value)
    case _:
      _state(meta_state, deck_list{mode}, next_seed_value, ui_value)

def _apply_delete(meta_state: Meta, ids: List(U32), next_seed_value: U32, ui_value: UiState) -> DungeonState:
  next_decks = remove_decks_by_ids(meta_decks(meta_state), ids);
  next_meta = set_meta_decks(meta_state, next_decks);
  next_active = _resolve_active(meta_active_deck_id(meta_state), ids);
  next_meta2 = set_meta_active_deck_id(next_meta, next_active);
  _state(next_meta2, deck_list{deck_list_view{}}, next_seed_value, default_ui())

def _resolve_active(current_active: U32, deleted_ids: List(U32)) -> U32:
  match list_contains_id(deleted_ids, current_active):
    case 1:
      initial_deck_id()
    case _:
      current_active

def _create_deck(meta_state: Meta, next_seed_value: U32, ui_value: UiState) -> DungeonState:
  new_id = meta_next_deck_id(meta_state);
  new_record : DeckRecord = deck_record{new_id, _new_deck_name(new_id), [] :: List(DeckEntry)};
  next_meta = set_meta_next_deck_id(meta_state, new_id + 1);
  _state(next_meta, deck_detail{new_id, draft_from_record(new_record), picker_none{}, detail_view{}}, next_seed_value, default_ui())

def _new_deck_name(new_id: U32) -> String:
  "Deck " ++ U32/show(new_id)

def _open_detail(meta_state: Meta, deck_id: U32, next_seed_value: U32, ui_value: UiState) -> DungeonState:
  match find_deck(meta_decks(meta_state), deck_id):
    case some{record}:
      _state(meta_state, deck_detail{deck_id, draft_from_record(record), picker_none{}, detail_view{}}, next_seed_value, default_ui())
    case none{}:
      _state(meta_state, deck_list{deck_list_view{}}, next_seed_value, ui_value)

def _set_active(meta_state: Meta, deck_id: U32, mode: DeckListMode, next_seed_value: U32, ui_value: UiState) -> DungeonState:
  match find_deck(meta_decks(meta_state), deck_id):
    case some{record}:
      _state(set_meta_active_deck_id(meta_state, deck_id), deck_list{mode}, next_seed_value, ui_value)
    case none{}:
      _state(meta_state, deck_list{mode}, next_seed_value, ui_value)
