import /dungeon/logic/Upgrade
import /dungeon/logic/MonsterDef
import /dungeon/logic/SwordDef
import /dungeon/logic/PotionDef
import /dungeon/logic/DeckEntry

type Config {
  config{
    hero_base_max_hp: U32,
    upgrades: List(Upgrade),
    monsters: List(MonsterDef),
    swords: List(SwordDef),
    potions: List(PotionDef),
    deck: List(DeckEntry),
    base_deck_size: U32,
    starting_dungeon_level: U32
  }
}
