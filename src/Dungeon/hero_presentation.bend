import Dungeon/HeroPresentation as HeroPresentation
import Dungeon/PresentationAlign as PresentationAlign
import Dungeon/generated_hero_presentation as generated_hero_presentation

def hero_presentations() -> List(HeroPresentation):
  generated_hero_presentation()

def hero_presentation_at(hero_ref: U32) -> HeroPresentation:
  _hero_presentation_at_from_list(hero_presentations(), hero_ref)

def _hero_presentation_at_from_list(presentations: List(HeroPresentation), hero_ref: U32) -> HeroPresentation:
  match presentations:
    case []:
      hero_presentation{"hero", presentation_center{}, "", "Ultimate", "assets/item-sword.png", ""}
    case hero_presentation{hero_id, name_align, lore, ultimate_title, ultimate_icon, ultimate_description}<>rest:
      match hero_ref:
        case 0:
          hero_presentation{hero_id, name_align, lore, ultimate_title, ultimate_icon, ultimate_description}
        case _:
          _hero_presentation_at_from_list(rest, hero_ref - 1)

def hero_presentation_name_align(presentation: HeroPresentation) -> PresentationAlign:
  match presentation:
    case hero_presentation{hero_id, name_align, lore, ultimate_title, ultimate_icon, ultimate_description}:
      name_align

def hero_presentation_lore(presentation: HeroPresentation) -> String:
  match presentation:
    case hero_presentation{hero_id, name_align, lore, ultimate_title, ultimate_icon, ultimate_description}:
      lore

def hero_presentation_ultimate_title(presentation: HeroPresentation) -> String:
  match presentation:
    case hero_presentation{hero_id, name_align, lore, ultimate_title, ultimate_icon, ultimate_description}:
      ultimate_title

def hero_presentation_ultimate_icon(presentation: HeroPresentation) -> String:
  match presentation:
    case hero_presentation{hero_id, name_align, lore, ultimate_title, ultimate_icon, ultimate_description}:
      ultimate_icon

def hero_presentation_ultimate_description(presentation: HeroPresentation) -> String:
  match presentation:
    case hero_presentation{hero_id, name_align, lore, ultimate_title, ultimate_icon, ultimate_description}:
      ultimate_description
