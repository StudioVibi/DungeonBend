import HTML
import Dungeon/UltimateCutinSpec as UltimateCutinSpec
import Dungeon/DungeonEvent as DungeonEvent
def _render_ultimate_cutin(spec: UltimateCutinSpec, stage_fx_class: String) -> HTML(DungeonEvent):
  node{
    "div",
    _ultimate_cutin_attrs(stage_fx_class, spec),
    [_ultimate_cutin_body(spec)]
  }

def _ultimate_cutin_attrs(stage_fx_class: String, spec: UltimateCutinSpec) -> List(HTML/Attr(DungeonEvent)):
  match spec:
    case ultimate_cutin_spec{banner_src, character_src, desktop_y_offset, mobile_y_offset, character_width, band_height, duration_ticks, sound_placeholder}:
      [
        attr{"class", "ultimate-cutin-stage " ++ stage_fx_class}
        style{"--ultimate-cutin-band-height", band_height}
        style{"--ultimate-cutin-character-width", character_width}
        style{"--ultimate-cutin-desktop-y-offset", desktop_y_offset}
        style{"--ultimate-cutin-mobile-y-offset", mobile_y_offset}
      ]

def _ultimate_cutin_body(spec: UltimateCutinSpec) -> HTML(DungeonEvent):
  match spec:
    case ultimate_cutin_spec{banner_src, character_src, desktop_y_offset, mobile_y_offset, character_width, band_height, duration_ticks, sound_placeholder}:
      <div class="ultimate-cutin">
        <div class="ultimate-cutin__trail"></div>
        <div class="ultimate-cutin__bar">
          <img class="ultimate-cutin__banner" src={banner_src} alt="" />
        </div>
        <div class="ultimate-cutin__flash"></div>
        <img class="ultimate-cutin__hero" src={character_src} alt="" />
      </div>
