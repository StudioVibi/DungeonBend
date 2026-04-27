import /Dungeon/HeroPresentation as HeroPresentation
import /Dungeon/PresentationAlign as PresentationAlign

def generated_hero_presentation() -> List(HeroPresentation):
  [
    hero_presentation{"adventurer", presentation_center{}, "A steady explorer ready for the next dungeon.", "Ultimate", "assets/item-sword.png", "Refills the dungeon with new cards while keeping the hero in place."},
    hero_presentation{"gato_de_botas", presentation_center{}, "A sly duelist who turns quick moves into clean wins.", "Ultimate", "assets/item-sword.png", "Refills the dungeon with new cards while keeping the hero in place."}
  ]
