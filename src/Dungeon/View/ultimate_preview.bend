import /HTML/
import /Dungeon/UltimatePreviewFx as UltimatePreviewFx
import /Dungeon/DungeonEvent as DungeonEvent
import /Dungeon/Content/ as Content
import /Midum/Button/ as Button
import /Midum/Button/Size
import /Midum/Layout/ as Layout

def _render_ultimate_preview(fx: UltimatePreviewFx) -> HTML(DungeonEvent):
  Layout.shell(
    DungeonEvent,
    <section class="ultimate-preview-scene">
      <header class="topbar topbar--menu ultimate-preview-topbar">
        <div class="topbar__back">
          {_ultimate_preview_back_button()}
        </div>
      </header>
      <div class="ultimate-preview-content">
        <div class={_ultimate_preview_stage_class(fx)}>
          <div class="ultimate-preview-cutin">
            <div class="ultimate-preview-cutin__trail"></div>
            <div class="ultimate-preview-cutin__bar">
              <img class="ultimate-preview-cutin__banner" src="assets/ui/ultimate/banner-test.png" alt="" />
            </div>
            <div class="ultimate-preview-cutin__flash"></div>
            <img class="ultimate-preview-cutin__hero" src="assets/player-boy.png" alt="Adventurer" />
          </div>
        </div>
      </div>
      <div class="ultimate-preview-footer">
        <div class="menu-start-action ultimate-preview-footer__action">
          {_ultimate_preview_play_button()}
        </div>
      </div>
    </section>,
    [
      height_viewport{}
      overflow_hidden{}
      safe_area{}
      inset_none{}
    ]
  )

def _ultimate_preview_stage_class(fx: UltimatePreviewFx) -> String:
  "ultimate-preview-stage " ++ _ultimate_preview_fx_class(fx)

def _ultimate_preview_fx_class(fx: UltimatePreviewFx) -> String:
  match fx:
    case ultimate_preview_idle{}:
      "ultimate-preview-stage--idle"
    case ultimate_preview_play_a{}:
      "ultimate-preview-stage--play-a"
    case ultimate_preview_play_b{}:
      "ultimate-preview-stage--play-b"

def _ultimate_preview_back_button() -> HTML(DungeonEvent):
  Button.secondary(
    DungeonEvent,
    close_ultimate_preview{},
    medium{},
    Content.ui_menu_back(),
    []
  )

def _ultimate_preview_play_button() -> HTML(DungeonEvent):
  Button.primary(
    DungeonEvent,
    play_ultimate_preview{},
    large{},
    "TOCAR ANIMACAO",
    []
  )
