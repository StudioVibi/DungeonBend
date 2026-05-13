import HTML as HTML
import Dungeon/CardRef as CardRef
import Dungeon/Meta as Meta
import Dungeon/PackDef as PackDef
import Dungeon/PackPoolEntry as PackPoolEntry
import Dungeon/PackReward as PackReward
import Dungeon/DungeonEvent as DungeonEvent
import Dungeon/config as config
import Dungeon/Boosters/packs/active_pack as active_pack
import Dungeon/View/selectors/meta_gold as meta_gold
import Dungeon/View/selectors/meta_pack_total as meta_pack_total
import Dungeon/View/selectors/active_pack_price as active_pack_price
import Dungeon/View/selectors/booster_buy_enabled as booster_buy_enabled
import Dungeon/View/selectors/booster_open_enabled as booster_open_enabled
import Dungeon/View/selectors/booster_is_last_card as booster_is_last_card
import Dungeon/View/selectors/card_copies as card_copies
import Dungeon/View/action_button/primary_full as action_primary_full
import Dungeon/View/action_button/back_button as action_back_button
import Dungeon/View/action_button/secondary_full as action_secondary_full
import Dungeon/View/menu_screen/_menu_screen_frame as _menu_screen_frame
import Dungeon/View/assets_and_labels/_card_name as _card_name
import Dungeon/View/assets_and_labels/_card_sprite as _card_sprite
import Dungeon/View/assets_and_labels/_card_stat_range as _card_stat_range
import Dungeon/Content as Content
import Dungeon/View/topbar_stats/gold_stat as gold_stat
import Dungeon/View/topbar_stats/boosters_stat as boosters_stat
import Midum/Card/neutral as card_neutral
import Midum/Layout/center as layout_center
import Midum/Layout/frame as layout_frame
import Midum/Layout/group as layout_group
import Midum/Layout/overlay as layout_overlay
import Midum/Layout/shell as layout_shell

type RevealTier {
  tier_common{}
  tier_uncommon{}
  tier_rare{}
  tier_epic{}
  tier_legendary{}
}

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
  tier = _reveal_card_tier(card);
  <div class="booster-visual booster-visual--revealed booster-visual--midum">
    {card_neutral(
      DungeonEvent,
      <div class="booster-visual__detail booster-visual__detail--midum">
        <div class="booster-visual__frame">
          <img class="booster-visual__frame-bg" src={_reveal_card_background(tier)} alt="" aria-hidden="true" />
          <img class="booster-visual__image booster-visual__image--midum" src={_card_sprite(card)} alt={_card_name(card)} />
          <img class="booster-visual__frame-border" src={_reveal_card_border(tier)} alt="" aria-hidden="true" />
        </div>
      </div>,
      _reveal_card_surface_overrides()
    )}
  </div>

def _reveal_card_surface_overrides() -> List(Midum/Card/Override):
  [
    padding_none{},
    background_none{},
    border_none{},
    radius_square{}
  ]

def _reveal_card_tier(card: CardRef) -> RevealTier:
  _tier_for_weight_share(card, active_pack(config()))

def _tier_for_weight_share(card: CardRef, pack: PackDef) -> RevealTier:
  match pack:
    case pack_def{name, price, reveal_count, allow_duplicates, pool}:
      _tier_for_pool_share(card, pool)

def _tier_for_pool_share(card: CardRef, pool: List(PackPoolEntry)) -> RevealTier:
  total = _pool_total_weight(pool);
  weighted = _pool_weight_for_card(pool, card) * 100;
  match total:
    case 0:
      tier_common{}
    case _:
      match weighted <= (total * 2):
        case 1:
          tier_legendary{}
        case _:
          match weighted <= (total * 5):
            case 1:
              tier_epic{}
            case _:
              match weighted <= (total * 12):
                case 1:
                  tier_rare{}
                case _:
                  match weighted <= (total * 25):
                    case 1:
                      tier_uncommon{}
                    case _:
                      tier_common{}

def _reveal_card_background(tier: RevealTier) -> String:
  match tier:
    case tier_common{}:
      "assets/ui/boosters/card-frame/common-bg.png"
    case tier_uncommon{}:
      "assets/ui/boosters/card-frame/uncommon-bg.png"
    case tier_rare{}:
      "assets/ui/boosters/card-frame/rare-bg.png"
    case tier_epic{}:
      "assets/ui/boosters/card-frame/epic-bg.png"
    case tier_legendary{}:
      "assets/ui/boosters/card-frame/legendary-bg.png"

def _reveal_card_border(tier: RevealTier) -> String:
  match tier:
    case tier_common{}:
      "assets/ui/boosters/card-frame/common-border.png"
    case tier_uncommon{}:
      "assets/ui/boosters/card-frame/uncommon-border.png"
    case tier_rare{}:
      "assets/ui/boosters/card-frame/rare-border.png"
    case tier_epic{}:
      "assets/ui/boosters/card-frame/epic-border.png"
    case tier_legendary{}:
      "assets/ui/boosters/card-frame/legendary-border.png"

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
      action_secondary_full(DungeonEvent, done_reward{}, Content.ui_booster_done(), 1)
    case _:
      action_secondary_full(DungeonEvent, next_reward{}, Content.ui_booster_next(), 1)

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
      {boosters_stat(meta_pack_total(meta_state))}
      {gold_stat(meta_gold(meta_state))}
    </div>
  </header>

def _back_button() -> HTML(DungeonEvent):
  action_back_button(DungeonEvent, close_boosters{}, Content.ui_booster_back())

def _booster_actions(meta_state: Meta) -> HTML(DungeonEvent):
  match booster_open_enabled(meta_state):
    case 1:
      <section class="boosters-actions">
        <div class="boosters-actions__inner">
          {layout_group(
            DungeonEvent,
            [
              action_secondary_full(DungeonEvent, buy_pack{0}, Content.ui_booster_buy_more_prefix() ++ U32/show(active_pack_price()) ++ Content.ui_booster_currency_suffix(), booster_buy_enabled(meta_state)),
              action_primary_full(DungeonEvent, open_pack{0}, Content.ui_booster_open(), 1)
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
              action_primary_full(DungeonEvent, buy_pack{0}, Content.ui_booster_buy_prefix() ++ U32/show(active_pack_price()) ++ Content.ui_booster_currency_suffix(), booster_buy_enabled(meta_state))
            ],
            [direction_column{}, gap_sm{}, align_stretch{}]
          )}
        </div>
      </section>
