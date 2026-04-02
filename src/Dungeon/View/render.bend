import /HTML/
import /HTML/Attr
import /U32/ as U32
import /Dungeon/Weapon as Weapon
import /Dungeon/Tile as Tile
import /Dungeon/Meta as Meta
import /Dungeon/Run as Run
import /Dungeon/Scene as Scene
import /Dungeon/UiState as UiState
import /Dungeon/HpFx as HpFx
import /Dungeon/DmgFx as DmgFx
import /Dungeon/Impact as Impact
import /Dungeon/ImpactFx as ImpactFx
import /Dungeon/DungeonEvent as DungeonEvent
import /Dungeon/DungeonState as DungeonState
import /Dungeon/Board/indexing/board_get as board_get
import /Dungeon/Board/indexing/board_xy_pos as board_xy_pos
import /Dungeon/Board/indexing/same_pos as same_pos
import /Dungeon/App/key_event as key_event
import /Dungeon/View/css as css
import /Dungeon/View/selectors/meta_gold as meta_gold
import /Dungeon/View/selectors/hero_level_text as hero_level_text
import /Dungeon/View/selectors/phase_badge as phase_badge
import /Dungeon/View/selectors/phase_chip_class as phase_chip_class
import /Dungeon/View/selectors/dungeon_level_value as dungeon_level_value
import /Dungeon/View/selectors/remaining_value as remaining_value
import /Dungeon/View/selectors/weapon_value as weapon_value
import /Dungeon/View/selectors/ultimate_label as ultimate_label
import /Dungeon/View/selectors/ultimate_enabled as ultimate_enabled
import /Dungeon/View/selectors/start_enabled as start_enabled
import /Dungeon/View/selectors/upgrade_enabled as upgrade_enabled
import /Dungeon/View/selectors/upgrade_label as upgrade_label
import /Dungeon/View/selectors/next_upgrade_cost as next_upgrade_cost
import /Dungeon/View/selectors/hero_max_hp_value as hero_max_hp_value
import /Dungeon/View/selectors/board_shell_class as board_shell_class
import /Dungeon/View/selectors/game_over_modal_class as game_over_modal_class
import /Midum/screen as screen
import /Midum/Card/ as Card
import /Dungeon/View/assets_and_labels/_hero_name as _hero_name
import /Dungeon/View/assets_and_labels/_hero_sprite as _hero_sprite
import /Dungeon/View/assets_and_labels/_tile_name as _tile_name
import /Dungeon/View/assets_and_labels/_tile_sprite as _tile_sprite
import /Dungeon/View/assets_and_labels/_tile_badge as _tile_badge

def render(state: DungeonState) -> HTML(DungeonEvent):
  match state:
    case dungeon{game_state{meta_state, scene_value, next_seed_value}, ui_value}:
      _frame(_shell_children(meta_state, scene_value, ui_value))

def _frame(kids: List(HTML(DungeonEvent))) -> HTML(DungeonEvent):
  screen(
    DungeonEvent,
    <div class="page" tabindex="0" autofocus="autofocus" style="outline:none" on_key_down={key_event}>
      <style>{text{css()}}</style>
      <div class="shell shell--dungeon">
        {...kids}
      </div>
    </div>
  )

def _shell_children(meta_state: Meta, scene_value: Scene, ui_value: UiState) -> List(HTML(DungeonEvent)):
  [
    _dashboard_header(meta_state),
    _status_panel(scene_value),
    _controls_panel(meta_state, scene_value),
    _board_node(scene_value, meta_state, ui_value)
  ]

def _dashboard_header(meta_state: Meta) -> HTML(DungeonEvent):
  <header class="topbar">
    <p class="resource-bar">
      <span class="resource-bar__label">Gold</span>
      <strong class="resource-bar__value">{text{meta_gold(meta_state)}}</strong>
    </p>
  </header>

def _status_panel(scene_value: Scene) -> HTML(DungeonEvent):
  <section class="status-panel">
    <div class="status-panel__head">
      <p class={phase_chip_class(scene_value)}>{text{phase_badge(scene_value)}}</p>
      <div class="status-meta-row">
        {_status_meta_chip("Lv", dungeon_level_value(scene_value))}
        {_status_meta_chip("Cards", remaining_value(scene_value))}
        {_status_meta_chip("Weapon", weapon_value(scene_value))}
      </div>
    </div>
  </section>

def _status_meta_chip(label: String, value: String) -> HTML(DungeonEvent):
  <p class="status-meta-chip">
    <span class="status-meta-chip__label">{text{label}}</span>
    <strong class="status-meta-chip__value">{text{value}}</strong>
  </p>

def _controls_panel(meta_state: Meta, scene_value: Scene) -> HTML(DungeonEvent):
  <section class="controls">
    <button {..._start_attrs(scene_value)}>
      {text{"Start"}}
    </button>
    <div class="upgrade-slot">
      <button {..._upgrade_attrs(meta_state, scene_value)}>
        {text{upgrade_label(meta_state)}}
      </button>
      <p class="upgrade-slot__meta">{text{hero_level_text(meta_state)}}</p>
    </div>
  </section>

def _board_node(scene_value: Scene, meta_state: Meta, ui_value: UiState) -> HTML(DungeonEvent):
  match scene_value:
    case setup{}:
      cells = U32.grid(HTML(DungeonEvent), 3, 3, _idle_board_slot(meta_state));
      <section class={board_shell_class(scene_value)}>
        <div class="board">{...cells}</div>
        {_ultimate_button(scene_value)}
        {_board_overlay(scene_value)}
      </section>
    case running{run_value}:
      _run_board_node(scene_value, run_value, ui_value)
    case game_over{run_value}:
      _run_board_node(scene_value, run_value, ui_value)

def _run_board_node(scene_value: Scene, run_value: Run, ui_value: UiState) -> HTML(DungeonEvent):
  cells = U32.grid(HTML(DungeonEvent), 3, 3, _board_slot(run_value, ui_value));
  <section class={board_shell_class(scene_value)}>
    <div class="board">{...cells}</div>
    {_ultimate_button(scene_value)}
    {_board_overlay(scene_value)}
  </section>

def _board_overlay(scene_value: Scene) -> HTML(DungeonEvent):
  match scene_value:
    case setup{}:
      <div class="game-over-modal"></div>
    case running{run_value}:
      <div class="game-over-modal"></div>
    case game_over{run_value}:
      <div class={game_over_modal_class(scene_value)}>
        {Card.neutral(
          DungeonEvent,
          <div class="game-over-card">
            <p class="game-over-card__eyebrow">{text{"Run encerrada"}}</p>
            <h2 class="game-over-card__title">{text{"Game Over"}}</h2>
            <button {..._button_attrs("button", ok{}, 1)}>
              {text{"OK"}}
            </button>
          </div>,
          [padding_md{}]
        )}
      </div>

def _board_idx(x: U32, y: U32) -> U32:
  x + (y * 3)

def _idle_board_card_at(meta_state: Meta, idx: U32) -> HTML(DungeonEvent):
  match idx:
    case 4:
      _hero_card_idle(meta_state)
    case _:
      _idle_placeholder_card()

def _idle_board_card(meta_state: Meta, x: U32, y: U32) -> HTML(DungeonEvent):
  _idle_board_card_at(meta_state, _board_idx(x, y))

def _idle_placeholder_card() -> HTML(DungeonEvent):
  Card.neutral(
    DungeonEvent,
    <div class="card card--empty card--idle">
      <div class="card__empty">{text{"Ready"}}</div>
    </div>,
    [padding_none{}]
  )

def _hero_card_idle(meta_state: Meta) -> HTML(DungeonEvent):
  _hero_card_values(hero_max_hp_value(meta_state), hero_max_hp_value(meta_state), no_weapon{}, hp_fx_none{}, dmg_fx_none{})

def _idle_board_slot(meta_state: Meta, x: U32, y: U32) -> HTML(DungeonEvent):
  _board_slot_node(_board_idx(x, y), board_xy_pos(x, y), no_impact{}, _idle_board_card(meta_state, x, y))

def _board_card_at(run_value: Run, ui_value: UiState, idx: U32) -> HTML(DungeonEvent):
  match run_value ui_value:
    case run{dungeon_level, hero_hp, hero_max_hp, hero_index, weapon, board_value, deck_blueprint, draw_counts, remaining, capacity, seed, ult_charge} ui_state{hp_fx, dmg_fx, impact}:
      _board_card_identity(hero_index === idx, hero_hp, hero_max_hp, weapon, hp_fx, dmg_fx, board_get(board_value, idx))

def _board_card_identity(is_hero: U32, hero_hp: U32, hero_max_hp: U32, weapon_value: Weapon, hp_fx: HpFx, dmg_fx: DmgFx, tile_value: Tile) -> HTML(DungeonEvent):
  match is_hero:
    case 0:
      _tile_card(tile_value)
    case _:
      _hero_card_values(hero_hp, hero_max_hp, weapon_value, hp_fx, dmg_fx)

def _board_slot(run_value: Run, ui_value: UiState, x: U32, y: U32) -> HTML(DungeonEvent):
  _board_slot_at(run_value, ui_value, _board_idx(x, y), board_xy_pos(x, y))

def _board_slot_at(run_value: Run, ui_value: UiState, idx: U32, pos: Nat/V2) -> HTML(DungeonEvent):
  match ui_value:
    case ui_state{hp_fx, dmg_fx, impact_value}:
      _board_slot_node(idx, pos, impact_value, _board_card_at(run_value, ui_value, idx))

def _board_slot_node(idx: U32, pos: Nat/V2, impact_value: Impact, body: HTML(DungeonEvent)) -> HTML(DungeonEvent):
  <div class={_board_slot_class(pos, impact_value)}>
    {body}
  </div>

def _board_slot_class(pos: Nat/V2, impact_value: Impact) -> String:
  match impact_value:
    case no_impact{}:
      "board-slot"
    case impact{impact_pos, fx}:
      _board_slot_class_match(same_pos(pos, impact_pos), fx)

def _board_slot_class_match(matched: U32, impact_fx: ImpactFx) -> String:
  match matched:
    case 0:
      "board-slot"
    case _:
      _board_slot_impact_class(impact_fx)

def _board_slot_impact_class(impact_fx: ImpactFx) -> String:
  match impact_fx:
    case impact_hit_a{}:
      "board-slot board-slot--impact-a"
    case impact_hit_b{}:
      "board-slot board-slot--impact-b"
    case impact_kill_a{}:
      "board-slot board-slot--kill-a"
    case impact_kill_b{}:
      "board-slot board-slot--kill-b"

def _hero_card_values(hero_hp: U32, hero_max_hp: U32, weapon_value: Weapon, hp_fx: HpFx, dmg_fx: DmgFx) -> HTML(DungeonEvent):
  Card.neutral(
    DungeonEvent,
    <div class={_hero_card_class(dmg_fx)} data-dmg={_hero_damage_attr(weapon_value)}>
      <div class={_hero_hp_badge_class(hp_fx)}>{text{"HP " ++ U32.show(hero_hp) ++ "/" ++ U32.show(hero_max_hp)}}</div>
      <div class="card__art-wrap">
        <img class="card__art" src={_hero_sprite()} alt={_hero_name()} />
      </div>
    </div>,
    [padding_none{}]
  )

def _hero_card_class(dmg_fx: DmgFx) -> String:
  match dmg_fx:
    case dmg_fx_up_a{}:
      "card card--hero card--hero-dmg-up-a"
    case dmg_fx_up_b{}:
      "card card--hero card--hero-dmg-up-b"
    case dmg_fx_down_a{}:
      "card card--hero card--hero-dmg-down-a"
    case dmg_fx_down_b{}:
      "card card--hero card--hero-dmg-down-b"
    case _:
      "card card--hero"

def _hero_hp_badge_class(hp_fx: HpFx) -> String:
  match hp_fx:
    case hp_fx_heal_a{}:
      "card__badge card__badge--hp card__badge--hp-heal-a"
    case hp_fx_heal_b{}:
      "card__badge card__badge--hp card__badge--hp-heal-b"
    case hp_fx_hurt_a{}:
      "card__badge card__badge--hp card__badge--hp-hurt-a"
    case hp_fx_hurt_b{}:
      "card__badge card__badge--hp card__badge--hp-hurt-b"
    case _:
      "card__badge card__badge--hp"

def _hero_damage_attr(weapon_value: Weapon) -> String:
  match weapon_value:
    case no_weapon{}:
      ""
    case weapon{ref, dmg}:
      "DMG " ++ U32.show(dmg)

def _tile_card(tile: Tile) -> HTML(DungeonEvent):
  match tile:
    case none{}:
      Card.neutral(
        DungeonEvent,
        <div class="card card--empty">
          <div class="card__empty">{text{"Empty"}}</div>
        </div>,
        [padding_none{}]
      )
    case monster{ref, hp}:
      _standard_tile_card(monster{ref, hp}, "card card--tile card--monster")
    case sword{ref, dmg}:
      _standard_tile_card(sword{ref, dmg}, "card card--tile card--sword")
    case potion{ref, heal}:
      _standard_tile_card(potion{ref, heal}, "card card--tile card--potion")
    case gold{amount}:
      _standard_tile_card(gold{amount}, "card card--tile card--gold")

def _standard_card_shell(body: HTML(DungeonEvent)) -> HTML(DungeonEvent):
  Card.neutral(DungeonEvent, body, [padding_none{}])

def _tile_card_body(tile: Tile, class_name: String) -> HTML(DungeonEvent):
  <div class={class_name}>
    {_tile_badge_node(tile)}
    <div class="card__art-wrap">
      <img class="card__art" src={_tile_sprite(tile)} alt={_tile_name(tile)} />
    </div>
  </div>

def _standard_tile_card(tile: Tile, class_name: String) -> HTML(DungeonEvent):
  _standard_card_shell(_tile_card_body(tile, class_name))

def _tile_badge_node(tile: Tile) -> HTML(DungeonEvent):
  <div class="card__badge card__badge--value">{text{_tile_badge(tile)}}</div>

def _ultimate_attrs(scene_value: Scene) -> List(Attr(DungeonEvent)):
  _button_attrs("button button--ultimate", ultimate{}, ultimate_enabled(scene_value))

def _ultimate_button(scene_value: Scene) -> HTML(DungeonEvent):
  <button {..._ultimate_attrs(scene_value)}>
    {text{ultimate_label(scene_value)}}
  </button>

def _button_attrs_enabled(class_name: String, evt: DungeonEvent) -> List(Attr(DungeonEvent)):
  [attr{"type", "button"}, attr{"class", class_name}, on_click{evt}]

def _button_attrs_disabled(class_name: String) -> List(Attr(DungeonEvent)):
  [attr{"type", "button"}, attr{"class", class_name ++ " button--disabled"}, on_click{ignore{}}]

def _button_attrs(class_name: String, evt: DungeonEvent, enabled: U32) -> List(Attr(DungeonEvent)):
  match enabled:
    case 0:
      _button_attrs_disabled(class_name)
    case _:
      _button_attrs_enabled(class_name, evt)

def _start_attrs(scene_value: Scene) -> List(Attr(DungeonEvent)):
  _button_attrs("button", start{}, start_enabled(scene_value))

def _upgrade_attrs(meta_state: Meta, scene_value: Scene) -> List(Attr(DungeonEvent)):
  _button_attrs("button button--secondary", upgrade{}, upgrade_enabled(meta_state, scene_value, next_upgrade_cost(meta_state)))
