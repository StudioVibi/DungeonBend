import /Dungeon/CardRef as CardRef
import /Dungeon/Tile as Tile
import /Dungeon/Config as Config
import /Dungeon/Deck/counts_pick/_monster_hp as _monster_hp
import /Dungeon/Deck/counts_pick/_sword_damage as _sword_damage
import /Dungeon/Deck/counts_pick/_potion_heal as _potion_heal

def card_to_tile(config_value: Config, card: CardRef) -> Tile:
  match config_value card:
    case config{heroes, monsters, swords, potions, deck, booster_packs, starting_dungeon_level} monster_card{ref}:
      monster{ref, _monster_hp(monsters, ref, 1)}
    case config{heroes, monsters, swords, potions, deck, booster_packs, starting_dungeon_level} sword_card{ref}:
      sword{ref, _sword_damage(swords, ref)}
    case config{heroes, monsters, swords, potions, deck, booster_packs, starting_dungeon_level} potion_card{ref}:
      potion{ref, _potion_heal(potions, ref)}
    case config{heroes, monsters, swords, potions, deck, booster_packs, starting_dungeon_level} hero_card{}:
      none{}
