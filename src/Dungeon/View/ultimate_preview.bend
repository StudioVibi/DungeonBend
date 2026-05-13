import HTML as HTML
import Dungeon/Meta as Meta
import Dungeon/UltimatePreviewFx as UltimatePreviewFx
import Dungeon/DungeonEvent as DungeonEvent
import Dungeon/Content as Content
import Dungeon/profile_helpers/selected_hero as selected_hero
import Dungeon/UltimateCutins/cutin_spec_for_hero_ref as cutin_spec_for_hero_ref
import Dungeon/UltimateCutins/_render_ultimate_cutin as _render_ultimate_cutin
import Dungeon/View/action_button/primary_full as action_primary_full
import Dungeon/View/action_button/back_button as action_back_button
import Midum/Layout/shell as layout_shell

def _render_ultimate_preview(meta_state: Meta, fx: UltimatePreviewFx) -> HTML(DungeonEvent):
  spec = cutin_spec_for_hero_ref(selected_hero(meta_state));
  layout_shell(
    DungeonEvent,
    <section class="ultimate-preview-scene">
      <header class="topbar topbar--menu ultimate-preview-topbar">
        <div class="topbar__back">
          {_ultimate_preview_back_button()}
        </div>
      </header>
      <div class="ultimate-preview-content">
        {_render_ultimate_cutin(spec, _ultimate_preview_stage_class(fx))}
      </div>
      <div class="ultimate-preview-footer">
        <div class="menu-start-action ultimate-preview-footer__action">
          {_ultimate_preview_play_button()}
        </div>
      </div>
    </section>,
    [
      height_viewport{},
      overflow_hidden{},
      safe_area{},
      inset_none{}
    ]
  )

def _ultimate_preview_stage_class(fx: UltimatePreviewFx) -> String:
  match fx:
    case ultimate_preview_idle{}:
      "ultimate-cutin-stage--idle"
    case ultimate_preview_play_a{}:
      "ultimate-cutin-stage--play-a"
    case ultimate_preview_play_b{}:
      "ultimate-cutin-stage--play-b"

def _ultimate_preview_back_button() -> HTML(DungeonEvent):
  action_back_button(DungeonEvent, close_ultimate_preview{}, Content.ui_menu_back())

def _ultimate_preview_play_button() -> HTML(DungeonEvent):
  action_primary_full(DungeonEvent, play_ultimate_preview{}, "TOCAR ANIMACAO", 1)
