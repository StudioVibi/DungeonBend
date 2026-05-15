import Dungeon/HeroPresentation as HeroPresentation
import Dungeon/PresentationAlign as PresentationAlign
import List/append as append

def generated_hero_presentation_items_chunk_0() -> List(HeroPresentation):
  [
    hero_presentation{"adventurer", presentation_center{}, "assets/ui/characters/selection/portrait-adventurer.png", "Ultimate", "assets/ui/characters/selection/icon-ultimate.png", "Refills the dungeon with new cards while keeping the hero in place."},
    hero_presentation{"gato_de_botas", presentation_center{}, "", "Ultimate", "assets/ui/characters/selection/icon-ultimate.png", "Refills the dungeon with new cards while keeping the hero in place."}
  ]

def generated_hero_presentation() -> List(HeroPresentation):
  generated_hero_presentation_items_chunk_0()
