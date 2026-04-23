import /String/ as String
import /Dungeon/UltimateCutinSpec as UltimateCutinSpec
import /Dungeon/config as config
import /Dungeon/hero_helpers/hero_at as hero_at
import /Dungeon/hero_helpers/hero_id as hero_id
import /Dungeon/UltimateCutins/adventurer as adventurer
import /Dungeon/UltimateCutins/gato_de_botas as gato_de_botas

def cutin_spec_for_hero_ref(hero_ref: U32) -> UltimateCutinSpec:
  _cutin_spec_for_hero_id(hero_id(hero_at(config(), hero_ref)))

def _cutin_spec_for_hero_id(hero_id_value: String) -> UltimateCutinSpec:
  match String/eq(hero_id_value, "gato_de_botas"):
    case true{}:
      gato_de_botas()
    case false{}:
      adventurer()
