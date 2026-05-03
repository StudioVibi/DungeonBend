import HTML as HTML
import Dungeon/CardRef as CardRef
import Dungeon/Meta as Meta
import Dungeon/PackReward as PackReward
import Dungeon/PackDef as PackDef
import Dungeon/PackPoolEntry as PackPoolEntry
import Dungeon/DungeonEvent as DungeonEvent
import Dungeon/config as config
import Dungeon/View/selectors/meta_gold as meta_gold
import Dungeon/View/selectors/meta_pack_total as meta_pack_total
import Dungeon/View/selectors/active_pack_price as active_pack_price
import Dungeon/View/selectors/booster_buy_enabled as booster_buy_enabled
import Dungeon/View/selectors/booster_open_enabled as booster_open_enabled
import Dungeon/View/selectors/booster_is_last_card as booster_is_last_card
import Dungeon/View/selectors/card_copies as card_copies
import Dungeon/Boosters/packs/active_pack as active_pack
import Dungeon/View/menu/_full_button_overrides as _full_button_overrides
import Dungeon/View/menu_screen/_menu_screen_frame as _menu_screen_frame
import Dungeon/View/assets_and_labels/_card_name as _card_name
import Dungeon/View/assets_and_labels/_card_sprite as _card_sprite
import Dungeon/View/assets_and_labels/_card_stat_range as _card_stat_range
import Dungeon/Content as Content
import Dungeon/View/topbar_stats/gold_stat as gold_stat
import Dungeon/View/topbar_stats/stat as topbar_stat
import Midum/Card/neutral as card_neutral
import Midum/Button/neutral as button_neutral
import Midum/Button/primary as button_primary
import Midum/Button/secondary as button_secondary
import Midum/Layout/center as layout_center
import Midum/Layout/frame as layout_frame
import Midum/Layout/group as layout_group
import Midum/Layout/overlay as layout_overlay
import Midum/Layout/shell as layout_shell

def _render_boosters(meta_state: Meta, reward: PackReward, reveal_index: U32) -> HTML(DungeonEvent):
  match reward:
    case no_pack_reward{}:
      _render_boosters_idle(meta_state)
    case pack_reward{cards}:
      _render_boosters_reveal(meta_state, pack_reward{cards}, reveal_index)

def _boosters_shell(body: HTML(DungeonEvent)) -> HTML(DungeonEvent):
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

def _render_boosters_idle(meta_state: Meta) -> HTML(DungeonEvent):
  _boosters_shell(
    layout_frame(
      DungeonEvent,
      _menu_screen_frame(
        _boosters_header(meta_state),
        <section class="boosters-stage">
          <div class="boosters-stage__content">
            {_booster_pack_visual()}
          </div>
        </section>,
        _booster_actions(meta_state)
      ),
      [width_full{}, height_full{}, inset_none{}]
    )
  )

def _booster_pack_visual() -> HTML(DungeonEvent):
  <div class="booster-visual booster-visual--pack">
    <img class="booster-visual__pack-img" src="assets/booster-pack.png" alt={Content.ui_booster_pack_alt()} />
  </div>

def _render_boosters_reveal(meta_state: Meta, reward: PackReward, reveal_index: U32) -> HTML(DungeonEvent):
  card = _reward_card_at(reward, reveal_index);
  _boosters_shell(
    layout_frame(
      DungeonEvent,
      layout_overlay(DungeonEvent, [
        layout_center(DungeonEvent,
          _booster_reveal_panel(meta_state, card, reward, reveal_index)
        )
      ]),
      [width_full{}, height_full{}, inset_none{}]
    )
  )

def _booster_reveal_panel(meta_state: Meta, card: CardRef, reward: PackReward, reveal_index: U32) -> HTML(DungeonEvent):
  <div class="booster-reveal-panel">
    <div class="booster-reveal-panel__visual">
      {_reveal_card(card)}
    </div>
    <div class="booster-reveal-panel__meta">
      {_reveal_meta(meta_state, card)}
    </div>
    <div class="booster-reveal-panel__footer">
      <div class="booster-reveal-panel__action">
        {_reveal_action_button(reward, reveal_index)}
      </div>
    </div>
  </div>

def _reveal_meta(meta_state: Meta, card: CardRef) -> HTML(DungeonEvent):
  <div class="reveal-meta">
    <div class="reveal-meta__top">
      <p class="reveal-name">{text{_card_name(card)}}</p>
      <p class="reveal-copies">{text{Content.ui_booster_copies_prefix() ++ card_copies(meta_state, card)}}</p>
    </div>
    {_reveal_stat_left(card)}
  </div>

def _reveal_stat_left(card: CardRef) -> HTML(DungeonEvent):
  match card:
    case hero_card{}:
      <span class="reveal-stat--empty"></span>
    case _:
      <p class="reveal-stat reveal-stat--detail">{text{_card_stat_range(card)}}</p>

def _reveal_card(card: CardRef) -> HTML(DungeonEvent):
  <div class="booster-visual booster-visual--revealed booster-visual--midum">
    {card_neutral(
      DungeonEvent,
      <div class="booster-visual__detail booster-visual__detail--midum">
        <div class="booster-visual__image-wrap">
          <img class="booster-visual__image booster-visual__image--midum" src={_card_sprite(card)} alt={_card_name(card)} />
        </div>
      </div>,
      _reveal_card_surface_overrides(card)
    )}
  </div>

def _reveal_card_surface_overrides(card: CardRef) -> List(Midum/Card/Override):
  [
    padding_none{},
    background_none{},
    border_none{},
    radius_square{},
    surface_image_sized{
      src: _reveal_card_background(card),
      source_left: U32/to_nat(34),
      source_right: U32/to_nat(34),
      source_top: U32/to_nat(34),
      source_bottom: U32/to_nat(34),
      target_left: U32/to_nat(22),
      target_right: U32/to_nat(22),
      target_top: U32/to_nat(22),
      target_bottom: U32/to_nat(22),
    }
  ]

def _reveal_card_background(card: CardRef) -> String:
  _background_for_weight_share(card, active_pack(config()))

def _background_for_weight_share(card: CardRef, pack: PackDef) -> String:
  match pack:
    case pack_def{name, price, reveal_count, allow_duplicates, pool}:
      _background_for_pool_share(card, pool)

def _background_for_pool_share(card: CardRef, pool: List(PackPoolEntry)) -> String:
  total = _pool_total_weight(pool);
  weighted = _pool_weight_for_card(pool, card) * 100;
  match total:
    case 0:
      "assets/background-comum.png"
    case _:
      match weighted <= (total * 5):
        case 1:
          "assets/background-epic.png"
        case _:
          match weighted <= (total * 12):
            case 1:
              "assets/background-rare.png"
            case _:
              match weighted <= (total * 25):
                case 1:
                  "assets/background-incomum.png"
                case _:
                  "assets/background-comum.png"

def _pool_total_weight(pool: List(PackPoolEntry)) -> U32:
  match pool:
    case []:
      0
    case pack_pool_entry{entry_card, weight}<>rest:
      weight + _pool_total_weight(rest)

def _pool_weight_for_card(pool: List(PackPoolEntry), target_card: CardRef) -> U32:
  match pool:
    case []:
      0
    case pack_pool_entry{entry_card, weight}<>rest:
      match _card_ref_eq(entry_card, target_card):
        case 1:
          weight + _pool_weight_for_card(rest, target_card)
        case _:
          _pool_weight_for_card(rest, target_card)

def _card_ref_eq(left: CardRef, right: CardRef) -> U32:
  match left right:
    case hero_card{} hero_card{}:
      1
    case monster_card{left_ref} monster_card{right_ref}:
      left_ref === right_ref
    case sword_card{left_ref} sword_card{right_ref}:
      left_ref === right_ref
    case potion_card{left_ref} potion_card{right_ref}:
      left_ref === right_ref
    case _ _:
      0

def _reveal_action_button(reward: PackReward, reveal_index: U32) -> HTML(DungeonEvent):
  match booster_is_last_card(reward, reveal_index):
    case 1:
      button_neutral(DungeonEvent, done_reward{}, medium{}, Content.ui_booster_done(), [])
    case _:
      button_neutral(DungeonEvent, next_reward{}, medium{}, Content.ui_booster_next(), [])

def _reward_card_at(reward: PackReward, idx: U32) -> CardRef:
  match reward:
    case no_pack_reward{}:
      hero_card{}
    case pack_reward{cards}:
      _card_at(cards, idx)

def _card_at(cards: List(CardRef), idx: U32) -> CardRef:
  match cards:
    case []:
      hero_card{}
    case card<>rest:
      match idx:
        case 0:
          card
        case _:
          _card_at(rest, idx - 1)

def _boosters_header(meta_state: Meta) -> HTML(DungeonEvent):
  <header class="topbar topbar--boosters">
    <div class="topbar__slot topbar__slot--leading">
      {_back_button()}
    </div>
    <div class="topbar__stats">
      {topbar_stat(Content.ui_topbar_boosters(), meta_pack_total(meta_state))}
      {gold_stat(meta_gold(meta_state))}
    </div>
  </header>

def _back_button() -> HTML(DungeonEvent):
  button_secondary(DungeonEvent, close_boosters{}, medium{}, Content.ui_booster_back(), [])

def _booster_actions(meta_state: Meta) -> HTML(DungeonEvent):
  match booster_open_enabled(meta_state):
    case 1:
      <section class="boosters-actions">
        <div class="boosters-actions__inner">
          {layout_group(
            DungeonEvent,
            [
              button_secondary(DungeonEvent, buy_pack{0}, medium{}, Content.ui_booster_buy_more_prefix() ++ U32/show(active_pack_price()) ++ Content.ui_booster_currency_suffix(), _full_button_overrides(booster_buy_enabled(meta_state))),
              button_primary(DungeonEvent, open_pack{0}, large{}, Content.ui_booster_open(), _full_button_overrides(1))
            ],
            [direction_column{}, gap_sm{}, align_stretch{}]
          )}
        </div>
      </section>
    case _:
      <section class="boosters-actions">
        <div class="boosters-actions__inner">
          {layout_group(
            DungeonEvent,
            [
              button_primary(DungeonEvent, buy_pack{0}, large{}, Content.ui_booster_buy_prefix() ++ U32/show(active_pack_price()) ++ Content.ui_booster_currency_suffix(), _full_button_overrides(booster_buy_enabled(meta_state)))
            ],
            [direction_column{}, gap_sm{}, align_stretch{}]
          )}
        </div>
      </section>
