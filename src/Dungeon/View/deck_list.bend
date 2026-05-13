import HTML as HTML
import Dungeon/Meta as Meta
import Dungeon/Scene as Scene
import Dungeon/UiState as UiState
import Dungeon/DeckListMode as DeckListMode
import Dungeon/DeckSleeve as DeckSleeve
import Dungeon/DeckSleevePicker as DeckSleevePicker
import Dungeon/DeckRecord as DeckRecord
import Dungeon/DungeonEvent as DungeonEvent
import Dungeon/config as config
import Dungeon/View/topbar_stats/gold_stat as gold_stat
import Dungeon/View/topbar_stats/boosters_stat as boosters_stat
import Dungeon/View/selectors/meta_pack_total as meta_pack_total
import Dungeon/View/menu/_full_button_overrides as _full_button_overrides
import Dungeon/View/menu/_fit_button_overrides as _fit_button_overrides
import Dungeon/View/deck_chrome/render as deck_chrome
import Dungeon/View/deck_sleeve_picker/render_card_control as render_card_control
import Dungeon/View/selectors/meta_gold as meta_gold_text
import Dungeon/View/assets_and_labels/_deck_cover_sprite_for_sleeve as _deck_cover_sprite_for_sleeve
import Midum/Button/primary as button_primary
import Midum/Button/secondary as button_secondary
import Midum/Image/view as image_view
import Midum/Card/neutral as card_neutral
import Midum/Layout/frame as layout_frame
import Midum/Layout/shell as layout_shell
import Dungeon/profile_helpers/meta_decks as meta_decks
import Dungeon/profile_helpers/meta_active_deck_id as meta_active_deck_id
import Dungeon/Deck/deck_records/initial_deck_id as initial_deck_id
import Dungeon/Deck/deck_records/deck_record_id as deck_record_id
import Dungeon/Deck/deck_records/deck_record_name as deck_record_name
import Dungeon/Deck/deck_records/deck_record_sleeve as deck_record_sleeve
import Dungeon/Deck/deck_records/deck_record_entries as deck_record_entries
import Dungeon/Deck/deck_records/list_contains_id as list_contains_id
import Dungeon/Deck/deck_records/list_size as list_size
import Dungeon/Deck/deck_records/deck_count as deck_count
import Dungeon/Deck/deck_validation/deck_total_count as deck_total_count
import Dungeon/Deck/quotas/deck_quotas_default as deck_quotas_default
import Dungeon/Deck/quotas/quotas_total as quotas_total

def _render_deck_list(meta_state: Meta, mode: DeckListMode, sleeve_picker: DeckSleevePicker) -> HTML(DungeonEvent):
  _shell(
    layout_frame(
      DungeonEvent,
      deck_chrome(
        close_deck_list{},
        close_deck_list{},
        _trailing(meta_state, mode),
        _trailing(meta_state, mode),
        [],
        <section class="deck-stage">
          <div class="deck-stage__content">
            {_grid(meta_state, mode, sleeve_picker)}
          </div>
          {_modal_layer(mode)}
        </section>
      ),
      [width_full{}, height_full{}, inset_none{}]
    )
  )

def _shell(body: HTML(DungeonEvent)) -> HTML(DungeonEvent):
  layout_shell(
    DungeonEvent,
    body,
    [
      max_width_px{value: 1080n},
      height_viewport{},
      overflow_hidden{},
      safe_area{},
      inset_px{top: 24n, right: 14n, bottom: 20n, left: 14n},
      compact_inset_px{top: 20n, right: 12n, bottom: 18n, left: 12n}
    ]
  )

def _trailing(meta_state: Meta, mode: DeckListMode) -> HTML(DungeonEvent):
  <div class="deck-chrome-trailing">
    {boosters_stat(meta_pack_total(meta_state))}
    {gold_stat(meta_gold_text(meta_state))}
    {_edit_toggle(meta_state, mode)}
  </div>

def _edit_toggle(meta_state: Meta, mode: DeckListMode) -> HTML(DungeonEvent):
  match _show_edit_toggle(meta_state, mode):
    case 0:
      text{""}
    case _:
      <div class="menu-club-btn-wrap menu-club-btn-wrap--fit">
        {_edit_toggle_button(mode)}
      </div>

def _edit_toggle_button(mode: DeckListMode) -> HTML(DungeonEvent):
  match mode:
    case deck_list_view{}:
      button_secondary(DungeonEvent, enter_deck_edit_mode{}, small{}, "EDIT", _fit_button_overrides(1))
    case deck_list_edit{ids}:
      button_secondary(DungeonEvent, exit_deck_edit_mode{}, small{}, "DONE", _fit_button_overrides(1))
    case deck_list_confirm_delete{ids}:
      text{""}

def _show_edit_toggle(meta_state: Meta, mode: DeckListMode) -> U32:
  match deck_count(meta_decks(meta_state)) > 1:
    case 1:
      _show_edit_toggle_mode(mode)
    case _:
      0

def _show_edit_toggle_mode(mode: DeckListMode) -> U32:
  match mode:
    case deck_list_confirm_delete{ids}:
      0
    case _:
      1

def _grid(meta_state: Meta, mode: DeckListMode, sleeve_picker: DeckSleevePicker) -> HTML(DungeonEvent):
  <section class="deck-list">
    <div class="deck-list__grid">
      {_create_card(mode)}
      {..._deck_cards(meta_decks(meta_state), meta_active_deck_id(meta_state), mode, sleeve_picker)}
    </div>
    {_delete_action(mode)}
  </section>

def _create_card(mode: DeckListMode) -> HTML(DungeonEvent):
  match mode:
    case deck_list_view{}:
      <button class="deck-list-card deck-list-card--create" type="button" on_click={create_new_deck{}}>
        <span class="deck-list-card__plus">+</span>
        <span class="deck-list-card__label">{text{"NEW DECK"}}</span>
      </button>
    case _:
      text{""}

def _deck_cards(records: List(DeckRecord), active_id: U32, mode: DeckListMode, sleeve_picker: DeckSleevePicker) -> List(HTML(DungeonEvent)):
  match records:
    case []:
      []
    case current<>rest:
      _deck_card(current, active_id, mode, sleeve_picker)<>_deck_cards(rest, active_id, mode, sleeve_picker)

def _deck_card(record: DeckRecord, active_id: U32, mode: DeckListMode, sleeve_picker: DeckSleevePicker) -> HTML(DungeonEvent):
  id = deck_record_id(record);
  is_active = id === active_id;
  is_initial = id === initial_deck_id();
  selected = _is_selected_in_mode(mode, id);
  cls = _deck_card_class(is_active, is_initial, selected);
  sleeve = deck_record_sleeve(record);
  <div class={cls}>
    <button class="deck-list-card__body" type="button" on_click={_card_click_event(mode, id)}>
      <span class="deck-list-card__cover">
        {image_view(DungeonEvent, _deck_cover_sprite_for_sleeve(sleeve), deck_record_name(record), [])}
      </span>
      <span class="deck-list-card__name">{text{deck_record_name(record)}}</span>
      <span class="deck-list-card__count">{text{_count_text(record)}}</span>
    </button>
    {_sleeve_control(mode, id, sleeve, sleeve_picker)}
    {_select_bullet(mode, id, is_initial)}
    {_active_badge(is_active)}
  </div>

def _card_click_event(mode: DeckListMode, deck_id: U32) -> DungeonEvent:
  match mode:
    case deck_list_view{}:
      open_deck_detail{deck_id}
    case deck_list_edit{ids}:
      toggle_deck_select{deck_id}
    case deck_list_confirm_delete{ids}:
      ignore{}

def _deck_card_class(is_active: U32, is_initial: U32, selected: U32) -> String:
  base = "deck-list-card";
  with_active = _append_class(base, is_active, " deck-list-card--active");
  with_initial = _append_class(with_active, is_initial, " deck-list-card--initial");
  _append_class(with_initial, selected, " deck-list-card--selected")

def _append_class(base: String, flag: U32, suffix: String) -> String:
  match flag:
    case 0:
      base
    case _:
      base ++ suffix

def _is_selected_in_mode(mode: DeckListMode, id: U32) -> U32:
  match mode:
    case deck_list_edit{ids}:
      list_contains_id(ids, id)
    case deck_list_confirm_delete{ids}:
      list_contains_id(ids, id)
    case _:
      0

def _count_text(record: DeckRecord) -> String:
  total = quotas_total(deck_quotas_default());
  current = deck_total_count(deck_record_entries(record));
  U32/show(current) ++ "/" ++ U32/show(total)

def _select_bullet(mode: DeckListMode, deck_id: U32, is_initial: U32) -> HTML(DungeonEvent):
  match _show_bullet(mode, is_initial):
    case 0:
      text{""}
    case _:
      _bullet_node(_is_selected_in_mode(mode, deck_id), deck_id)

def _show_bullet(mode: DeckListMode, is_initial: U32) -> U32:
  match is_initial:
    case 1:
      0
    case _:
      _show_bullet_mode(mode)

def _show_bullet_mode(mode: DeckListMode) -> U32:
  match mode:
    case deck_list_edit{ids}:
      1
    case deck_list_confirm_delete{ids}:
      1
    case _:
      0

def _bullet_node(selected: U32, deck_id: U32) -> HTML(DungeonEvent):
  cls = _bullet_class(selected);
  <button class={cls} type="button" on_click={toggle_deck_select{deck_id}}>
    <span class="deck-list-card__bullet-dot"></span>
  </button>

def _bullet_class(selected: U32) -> String:
  match selected:
    case 0:
      "deck-list-card__bullet"
    case _:
      "deck-list-card__bullet deck-list-card__bullet--checked"

def _active_badge(is_active: U32) -> HTML(DungeonEvent):
  match is_active:
    case 0:
      text{""}
    case _:
      <span class="deck-list-card__active-badge">{text{"ACTIVE"}}</span>

def _sleeve_control(mode: DeckListMode, deck_id: U32, sleeve: DeckSleeve, sleeve_picker: DeckSleevePicker) -> HTML(DungeonEvent):
  match _show_sleeve_control(mode):
    case 0:
      text{""}
    case _:
      render_card_control(deck_id, sleeve, _is_sleeve_picker_open(sleeve_picker, deck_id))

def _show_sleeve_control(mode: DeckListMode) -> U32:
  match mode:
    case deck_list_view{}:
      1
    case _:
      0

def _is_sleeve_picker_open(sleeve_picker: DeckSleevePicker, deck_id: U32) -> U32:
  match sleeve_picker:
    case sleeve_picker_open{open_id}:
      open_id === deck_id
    case sleeve_picker_closed{}:
      0

def _delete_action(mode: DeckListMode) -> HTML(DungeonEvent):
  match mode:
    case deck_list_edit{ids}:
      _delete_button(list_size(ids))
    case _:
      text{""}

def _delete_button(count: U32) -> HTML(DungeonEvent):
  enabled = _delete_enabled(count);
  label = "DELETE (" ++ U32/show(count) ++ ")";
  <div class="deck-list-delete-action">
    {button_primary(DungeonEvent, request_delete_decks{}, medium{}, label, _full_button_overrides(enabled))}
  </div>

def _delete_enabled(count: U32) -> U32:
  match count:
    case 0:
      0
    case _:
      1

def _modal_layer(mode: DeckListMode) -> HTML(DungeonEvent):
  match mode:
    case deck_list_confirm_delete{ids}:
      _confirm_modal(list_size(ids))
    case _:
      text{""}

def _confirm_modal(count: U32) -> HTML(DungeonEvent):
  <div class="game-over-modal game-over-modal--visible deck-confirm-modal">
    {card_neutral(
      DungeonEvent,
      <div class="game-over-card">
        <p class="game-over-card__eyebrow">{text{"CONFIRM"}}</p>
        <h2 class="game-over-card__title">{text{"Delete decks?"}}</h2>
        <p class="game-over-card__body">{text{_confirm_body(count)}}</p>
        <section class="game-over-card__actions">
          <div class="menu-secondary-action game-over-card__secondary">
            {button_secondary(DungeonEvent, cancel_delete_decks{}, medium{}, "CANCEL", _full_button_overrides(1))}
          </div>
          <div class="menu-start-action game-over-card__primary">
            {button_primary(DungeonEvent, confirm_delete_decks{}, medium{}, "DELETE", _full_button_overrides(1))}
          </div>
        </section>
      </div>,
      [padding_md{}]
    )}
  </div>

def _confirm_body(count: U32) -> String:
  "This will permanently delete " ++ U32/show(count) ++ " deck(s)."
