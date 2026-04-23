import /Dungeon/UltimateCutinSpec as UltimateCutinSpec
import /Dungeon/UltimateCutins/cutin_spec_for_hero_ref as cutin_spec_for_hero_ref

def duration_ticks_for_hero_ref(hero_ref: U32) -> U32:
  match cutin_spec_for_hero_ref(hero_ref):
    case ultimate_cutin_spec{banner_src, character_src, desktop_y_offset, mobile_y_offset, character_width, band_height, duration_ticks, sound_placeholder}:
      duration_ticks
