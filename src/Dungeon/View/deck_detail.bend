import HTML as HTML
import Dungeon/Meta as Meta
import Dungeon/Scene as Scene
import Dungeon/UiState as UiState
import Dungeon/DeckDraft as DeckDraft
import Dungeon/DeckPickerMode as DeckPickerMode
import Dungeon/DeckDetailMode as DeckDetailMode
import Dungeon/DeckEntry as DeckEntry
import Dungeon/DeckCategory as DeckCategory
import Dungeon/DeckQuotas as DeckQuotas
import Dungeon/CardRef as CardRef
import Dungeon/MonsterDef as MonsterDef
import Dungeon/SwordDef as SwordDef
import Dungeon/PotionDef as PotionDef
import Dungeon/Config as Config
import Dungeon/DungeonEvent as DungeonEvent
import Dungeon/config as config
import Dungeon/View/topbar_stats/gold_stat as gold_stat
import Dungeon/View/menu/_full_button_overrides as _full_button_overrides
import Dungeon/View/menu/_fit_button_overrides as _fit_button_overrides
import Dungeon/View/deck_chrome/render as deck_chrome
import Dungeon/View/selectors/meta_gold as meta_gold_text
import Dungeon/View/deck_card_tile/render_tile as render_tile
import Dungeon/View/deck_card_tile/render_empty as render_empty
import Midum/Button/primary as button_primary
import Midum/Button/secondary as button_secondary
import Midum/Card/neutral as card_neutral
import Midum/Layout/frame as layout_frame
import Midum/Layout/shell as layout_shell
import Dungeon/profile_helpers/meta_decks as meta_decks
import Dungeon/profile_helpers/meta_active_deck_id as meta_active_deck_id
import Dungeon/Deck/draft_ops/draft_id as draft_id
import Dungeon/Deck/draft_ops/draft_name as draft_name
import Dungeon/Deck/draft_ops/draft_entries as draft_entries
import Dungeon/Deck/draft_ops/draft_dirty as draft_dirty
import Dungeon/Deck/draft_ops/can_add_card as can_add_card
import Dungeon/Deck/quotas/deck_quotas_default as deck_quotas_default
import Dungeon/Deck/quotas/quotas_total as quotas_total
import Dungeon/Deck/quotas/quota_for_category as quota_for_category
import Dungeon/Deck/quotas/category_count as category_count
import Dungeon/Deck/quotas/category_label as category_label
import Dungeon/Deck/card_collection/pool_quantity as pool_quantity
import Dungeon/Deck/card_collection/available_for_add as available_for_add
import Dungeon/Deck/card_collection/entry_card_ref as entry_card_ref
import Dungeon/Deck/card_collection/entry_count as entry_count
import Dungeon/Deck/card_collection/filter_entries_by_category as filter_entries_by_category
import Dungeon/Deck/deck_validation/is_deck_valid as is_deck_valid
import Dungeon/Deck/deck_validation/deck_total_count as deck_total_count

def _render_deck_detail(meta_state: Meta, deck_id: U32, draft: DeckDraft, picker: DeckPickerMode, detail_mode: DeckDetailMode) -> HTML(DungeonEvent):
  _shell(
    layout_frame(
      DungeonEvent,
      deck_chrome(
        request_close_deck_detail{},
        _mobile_back(picker),
        _trailing(meta_state),
        _mobile_title(meta_state, draft, picker),
        _actions(meta_state, deck_id, draft, picker),
        _body(meta_state, draft, picker, detail_mode)
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

def _mobile_back(picker: DeckPickerMode) -> DungeonEvent:
  match picker:
    case picker_open{category}:
      close_category_picker{}
    case picker_none{}:
      request_close_deck_detail{}

def _trailing(meta_state: Meta) -> HTML(DungeonEvent):
  <div class="deck-chrome-trailing">
    {gold_stat(meta_gold_text(meta_state))}
  </div>

def _mobile_title(meta_state: Meta, draft: DeckDraft, picker: DeckPickerMode) -> HTML(DungeonEvent):
  match picker:
    case picker_open{category}:
      _picker_title_block(draft, category)
    case picker_none{}:
      _trailing(meta_state)

def _picker_title_block(draft: DeckDraft, cat: DeckCategory) -> HTML(DungeonEvent):
  used = category_count(draft_entries(draft), cat);
  cap = quota_for_category(deck_quotas_default(), cat);
  <div class="deck-detail__picker-title-block">
    <span class="deck-detail__picker-title">{text{"YOUR " ++ _upper_label(cat) ++ " CARDS"}}</span>
    <span class="deck-detail__picker-progress">{text{_progress_text(used, cap)}}</span>
  </div>

def _progress_text(used: U32, cap: U32) -> String:
  match used < cap:
    case 1:
      "Filling slot " ++ U32/show(used + 1) ++ "/" ++ U32/show(cap)
    case _:
      "Full · tap a card twice to remove"

def _upper_label(cat: DeckCategory) -> String:
  match cat:
    case cat_monsters{}:
      "MONSTER"
    case cat_swords{}:
      "SWORD"
    case cat_potions{}:
      "POTION"
    case cat_hero{}:
      "HERO"

def _actions(meta_state: Meta, deck_id: U32, draft: DeckDraft, picker: DeckPickerMode) -> List(HTML(DungeonEvent)):
  match picker:
    case picker_open{category}:
      []
    case picker_none{}:
      _main_actions(meta_state, deck_id, draft)

def _main_actions(meta_state: Meta, deck_id: U32, draft: DeckDraft) -> List(HTML(DungeonEvent)):
  valid = is_deck_valid(config(), meta_state, draft_entries(draft));
  dirty = draft_dirty(draft);
  is_active = meta_active_deck_id(meta_state) === deck_id;
  _concat_html(_save_action(valid, dirty), _set_active_action(deck_id, valid, dirty, is_active))

def _save_action(valid: U32, dirty: U32) -> List(HTML(DungeonEvent)):
  match dirty:
    case 0:
      []
    case _:
      [button_primary(DungeonEvent, save_deck_changes{}, medium{}, "SAVE", _full_button_overrides(valid))]

def _set_active_action(deck_id: U32, valid: U32, dirty: U32, is_active: U32) -> List(HTML(DungeonEvent)):
  match _set_active_visible(valid, dirty, is_active):
    case 0:
      []
    case _:
      [button_secondary(DungeonEvent, set_active_deck{deck_id}, medium{}, "SET ACTIVE", _full_button_overrides(1))]

def _set_active_visible(valid: U32, dirty: U32, is_active: U32) -> U32:
  match is_active:
    case 1:
      0
    case _:
      _and(valid, _not(dirty))

def _body(meta_state: Meta, draft: DeckDraft, picker: DeckPickerMode, detail_mode: DeckDetailMode) -> HTML(DungeonEvent):
  <section class={_stage_class(picker)}>
    <div class="deck-stage__content">
      {_main_layout(meta_state, draft, picker, detail_mode)}
    </div>
    {_modal_layer(detail_mode)}
  </section>

def _stage_class(picker: DeckPickerMode) -> String:
  match picker:
    case picker_open{category}:
      "deck-stage deck-stage--picker-open"
    case picker_none{}:
      "deck-stage"

def _main_layout(meta_state: Meta, draft: DeckDraft, picker: DeckPickerMode, detail_mode: DeckDetailMode) -> HTML(DungeonEvent):
  <section class="deck-detail">
    {_title_row(draft)}
    <div class={_main_class(picker)}>
      {_deck_panel(meta_state, draft, picker, detail_mode)}
    </div>
    <aside class={_side_class(picker)}>
      {_pool_panel(meta_state, draft, picker, detail_mode)}
    </aside>
  </section>

def _title_row(draft: DeckDraft) -> HTML(DungeonEvent):
  q = deck_quotas_default();
  entries = draft_entries(draft);
  total_q = quotas_total(q);
  count_text = U32/show(deck_total_count(entries)) ++ "/" ++ U32/show(total_q);
  <div class="deck-detail__title-row">
    <h2 class="deck-detail__deck-name">{text{draft_name(draft)}}</h2>
    <span class="deck-detail__deck-count">{text{"DECK " ++ count_text}}</span>
  </div>

def _main_class(picker: DeckPickerMode) -> String:
  match picker:
    case picker_open{category}:
      "deck-detail__main deck-detail__main--picker-open"
    case picker_none{}:
      "deck-detail__main"

def _side_class(picker: DeckPickerMode) -> String:
  match picker:
    case picker_open{category}:
      "deck-detail__side deck-detail__side--picker-open"
    case picker_none{}:
      "deck-detail__side"

def _deck_panel(meta_state: Meta, draft: DeckDraft, picker: DeckPickerMode, detail_mode: DeckDetailMode) -> HTML(DungeonEvent):
  q = deck_quotas_default();
  entries = draft_entries(draft);
  <div class="deck-detail__deck-panel">
    {_section(meta_state, entries, q, cat_monsters{}, picker, detail_mode)}
    {_section(meta_state, entries, q, cat_swords{}, picker, detail_mode)}
    {_section(meta_state, entries, q, cat_potions{}, picker, detail_mode)}
    {_section(meta_state, entries, q, cat_hero{}, picker, detail_mode)}
  </div>

def _section(meta_state: Meta, entries: List(DeckEntry), q: DeckQuotas, cat: DeckCategory, picker: DeckPickerMode, detail_mode: DeckDetailMode) -> HTML(DungeonEvent):
  used = category_count(entries, cat);
  cap = quota_for_category(q, cat);
  match cap:
    case 0:
      text{""}
    case _:
      _section_render(meta_state, entries, cat, used, cap, _is_target_section(picker, cat), detail_mode)

def _is_target_section(picker: DeckPickerMode, cat: DeckCategory) -> U32:
  match picker:
    case picker_none{}:
      0
    case picker_open{category}:
      _category_eq(category, cat)

def _category_eq(a: DeckCategory, b: DeckCategory) -> U32:
  match a:
    case cat_monsters{}:
      _is_monsters(b)
    case cat_swords{}:
      _is_swords(b)
    case cat_potions{}:
      _is_potions(b)
    case cat_hero{}:
      _is_hero(b)

def _is_monsters(c: DeckCategory) -> U32:
  match c:
    case cat_monsters{}:
      1
    case _:
      0

def _is_swords(c: DeckCategory) -> U32:
  match c:
    case cat_swords{}:
      1
    case _:
      0

def _is_potions(c: DeckCategory) -> U32:
  match c:
    case cat_potions{}:
      1
    case _:
      0

def _is_hero(c: DeckCategory) -> U32:
  match c:
    case cat_hero{}:
      1
    case _:
      0

def _section_render(meta_state: Meta, entries: List(DeckEntry), cat: DeckCategory, used: U32, cap: U32, is_target: U32, detail_mode: DeckDetailMode) -> HTML(DungeonEvent):
  <section class="deck-section">
    <div class="deck-section__header">
      <button class="deck-section__title" type="button" on_click={open_category_picker{cat}}>
        <span class="deck-section__label">{text{category_label(cat)}}</span>
        <span class="deck-section__count">{text{U32/show(used) ++ "/" ++ U32/show(cap)}}</span>
      </button>
    </div>
    <div class="deck-section__grid">
      {..._slots(entries, cat, used, cap, is_target, detail_mode)}
    </div>
  </section>

def _slots(entries: List(DeckEntry), cat: DeckCategory, used: U32, cap: U32, is_target: U32, detail_mode: DeckDetailMode) -> List(HTML(DungeonEvent)):
  filled = filter_entries_by_category(entries, cat);
  filled_html = _filled_slots(filled, detail_mode);
  empty_count = _saturating_sub(cap, used);
  _concat_html(filled_html, _empty_slots(empty_count, cat, is_target))

def _concat_html(a: List(HTML(DungeonEvent)), b: List(HTML(DungeonEvent))) -> List(HTML(DungeonEvent)):
  match a:
    case []:
      b
    case head<>rest:
      head<>_concat_html(rest, b)

def _saturating_sub(a: U32, b: U32) -> U32:
  match a < b:
    case 1:
      0
    case _:
      a - b

def _filled_slots(entries: List(DeckEntry), detail_mode: DeckDetailMode) -> List(HTML(DungeonEvent)):
  match entries:
    case []:
      []
    case current<>rest:
      _concat_html(_entry_to_tiles(current, detail_mode), _filled_slots(rest, detail_mode))

def _entry_to_tiles(entry: DeckEntry, detail_mode: DeckDetailMode) -> List(HTML(DungeonEvent)):
  _repeat_tile(entry_card_ref(entry), entry_count(entry), detail_mode)

def _repeat_tile(card: CardRef, count: U32, detail_mode: DeckDetailMode) -> List(HTML(DungeonEvent)):
  match count:
    case 0:
      []
    case _:
      _filled_tile(card, detail_mode)<>_repeat_tile(card, count - 1, detail_mode)

def _filled_tile(card: CardRef, detail_mode: DeckDetailMode) -> HTML(DungeonEvent):
  render_tile(card, _filled_modifier(detail_mode, card), "", remove_card_from_deck{card})

def _filled_modifier(detail_mode: DeckDetailMode, card: CardRef) -> String:
  match _is_armed(detail_mode, card):
    case 0:
      " deck-tile--filled"
    case _:
      " deck-tile--filled deck-tile--armed"

def _is_armed(detail_mode: DeckDetailMode, card: CardRef) -> U32:
  match detail_mode:
    case detail_pending_delete{armed}:
      _card_ref_eq_local(armed, card)
    case _:
      0

def _card_ref_eq_local(left: CardRef, right: CardRef) -> U32:
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

def _empty_slots(count: U32, cat: DeckCategory, is_target: U32) -> List(HTML(DungeonEvent)):
  match count:
    case 0:
      []
    case _:
      render_empty(open_category_picker{cat}, _empty_modifier(is_target))<>_rest_empty_slots(count - 1, cat)

def _rest_empty_slots(count: U32, cat: DeckCategory) -> List(HTML(DungeonEvent)):
  match count:
    case 0:
      []
    case _:
      render_empty(open_category_picker{cat}, "")<>_rest_empty_slots(count - 1, cat)

def _empty_modifier(is_target: U32) -> String:
  match is_target:
    case 0:
      ""
    case _:
      " deck-tile--target"

def _pool_panel(meta_state: Meta, draft: DeckDraft, picker: DeckPickerMode, detail_mode: DeckDetailMode) -> HTML(DungeonEvent):
  match picker:
    case picker_none{}:
      _pool_placeholder()
    case picker_open{category}:
      _picker_panel(meta_state, draft, picker, detail_mode, category)

def _pool_placeholder() -> HTML(DungeonEvent):
  <div class="deck-pool-empty">
    <p class="deck-pool-empty__text">{text{"Tap a slot to start editing."}}</p>
  </div>

def _picker_panel(meta_state: Meta, draft: DeckDraft, picker: DeckPickerMode, detail_mode: DeckDetailMode, cat: DeckCategory) -> HTML(DungeonEvent):
  q = deck_quotas_default();
  entries = draft_entries(draft);
  <div class="deck-picker">
    <div class="deck-picker__preview">
      {_section(meta_state, entries, q, cat, picker, detail_mode)}
    </div>
    <div class="deck-picker__pool">
      {_pool_for_category(meta_state, draft, cat)}
    </div>
  </div>

def _pool_for_category(meta_state: Meta, draft: DeckDraft, cat: DeckCategory) -> HTML(DungeonEvent):
  cards = _pool_cards_for(cat);
  <div class="deck-pool">
    <div class="deck-pool__header">
      <h3 class="deck-pool__title">{text{"your " ++ category_label(cat) ++ " cards"}}</h3>
    </div>
    <div class="deck-pool__grid">
      {..._pool_tiles(meta_state, draft, cards)}
    </div>
  </div>

def _pool_cards_for(cat: DeckCategory) -> List(CardRef):
  match cat:
    case cat_monsters{}:
      _monster_cards(_monster_count_in_config())
    case cat_swords{}:
      _sword_cards(_sword_count_in_config())
    case cat_potions{}:
      _potion_cards(_potion_count_in_config())
    case cat_hero{}:
      [hero_card{}]

def _monster_count_in_config() -> U32:
  _count_monsters(config())

def _count_monsters(cfg: Config) -> U32:
  match cfg:
    case config{heroes, monsters, swords, potions, deck, booster_packs, starting_dungeon_level}:
      _list_size_monsters(monsters)

def _list_size_monsters(xs: List(MonsterDef)) -> U32:
  match xs:
    case []:
      0
    case head<>rest:
      1 + _list_size_monsters(rest)

def _sword_count_in_config() -> U32:
  _count_swords(config())

def _count_swords(cfg: Config) -> U32:
  match cfg:
    case config{heroes, monsters, swords, potions, deck, booster_packs, starting_dungeon_level}:
      _list_size_swords(swords)

def _list_size_swords(xs: List(SwordDef)) -> U32:
  match xs:
    case []:
      0
    case head<>rest:
      1 + _list_size_swords(rest)

def _potion_count_in_config() -> U32:
  _count_potions(config())

def _count_potions(cfg: Config) -> U32:
  match cfg:
    case config{heroes, monsters, swords, potions, deck, booster_packs, starting_dungeon_level}:
      _list_size_potions(potions)

def _list_size_potions(xs: List(PotionDef)) -> U32:
  match xs:
    case []:
      0
    case head<>rest:
      1 + _list_size_potions(rest)

def _monster_cards(n: U32) -> List(CardRef):
  _monster_cards_from(0, n)

def _monster_cards_from(idx: U32, n: U32) -> List(CardRef):
  match idx < n:
    case 0:
      []
    case _:
      monster_card{idx}<>_monster_cards_from(idx + 1, n)

def _sword_cards(n: U32) -> List(CardRef):
  _sword_cards_from(0, n)

def _sword_cards_from(idx: U32, n: U32) -> List(CardRef):
  match idx < n:
    case 0:
      []
    case _:
      sword_card{idx}<>_sword_cards_from(idx + 1, n)

def _potion_cards(n: U32) -> List(CardRef):
  _potion_cards_from(0, n)

def _potion_cards_from(idx: U32, n: U32) -> List(CardRef):
  match idx < n:
    case 0:
      []
    case _:
      potion_card{idx}<>_potion_cards_from(idx + 1, n)

def _pool_tiles(meta_state: Meta, draft: DeckDraft, cards: List(CardRef)) -> List(HTML(DungeonEvent)):
  match cards:
    case []:
      []
    case current<>rest:
      _pool_tile(meta_state, draft, current)<>_pool_tiles(meta_state, draft, rest)

def _pool_tile(meta_state: Meta, draft: DeckDraft, card: CardRef) -> HTML(DungeonEvent):
  pool = pool_quantity(meta_state, card);
  available = available_for_add(meta_state, draft_entries(draft), card);
  match pool:
    case 0:
      text{""}
    case _:
      _pool_tile_visible(card, available, pool)

def _pool_tile_visible(card: CardRef, available: U32, pool: U32) -> HTML(DungeonEvent):
  modifier = _pool_tile_modifier(available);
  badge = U32/show(available) ++ "/" ++ U32/show(pool);
  render_tile(card, modifier, badge, _pool_click(card, available))

def _pool_tile_modifier(available: U32) -> String:
  match available:
    case 0:
      " deck-tile--depleted"
    case _:
      ""

def _pool_click(card: CardRef, available: U32) -> DungeonEvent:
  match available:
    case 0:
      ignore{}
    case _:
      add_card_to_deck{card}

def _and(a: U32, b: U32) -> U32:
  match a:
    case 0:
      0
    case _:
      b

def _not(a: U32) -> U32:
  match a:
    case 0:
      1
    case _:
      0

def _modal_layer(detail_mode: DeckDetailMode) -> HTML(DungeonEvent):
  match detail_mode:
    case detail_view{}:
      text{""}
    case detail_confirm_discard{}:
      _discard_modal()
    case detail_pending_delete{card}:
      text{""}

def _discard_modal() -> HTML(DungeonEvent):
  <div class="game-over-modal game-over-modal--visible deck-confirm-modal">
    {card_neutral(
      DungeonEvent,
      <div class="game-over-card">
        <p class="game-over-card__eyebrow">{text{"UNSAVED"}}</p>
        <h2 class="game-over-card__title">{text{"Discard changes?"}}</h2>
        <p class="game-over-card__body">{text{"You have unsaved deck edits."}}</p>
        <section class="game-over-card__actions">
          <div class="menu-secondary-action game-over-card__secondary">
            {button_secondary(DungeonEvent, cancel_discard_deck_changes{}, medium{}, "KEEP EDITING", _full_button_overrides(1))}
          </div>
          <div class="menu-start-action game-over-card__primary">
            {button_primary(DungeonEvent, discard_deck_changes{}, medium{}, "DISCARD", _full_button_overrides(1))}
          </div>
        </section>
      </div>,
      [padding_md{}]
    )}
  </div>
