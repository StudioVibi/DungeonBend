import Dungeon/Config as Config
import Dungeon/HeroDef as HeroDef
import Dungeon/Upgrade as Upgrade
import Dungeon/MonsterDef as MonsterDef
import Dungeon/SwordDef as SwordDef
import Dungeon/PotionDef as PotionDef
import Dungeon/DeckEntry as DeckEntry
import Dungeon/CardRef as CardRef
import Dungeon/PackPoolEntry as PackPoolEntry
import Dungeon/PackDef as PackDef
import List/append as append

def generated_hero_0_upgrades_chunk_0() -> List(Upgrade):
  [
    upgrade{40, 14},
    upgrade{70, 16},
    upgrade{100, 18},
    upgrade{130, 20}
  ]

def generated_hero_1_upgrades_chunk_0() -> List(Upgrade):
  [
    upgrade{36, 12},
    upgrade{60, 14},
    upgrade{84, 17},
    upgrade{108, 20}
  ]

def generated_monster_0_hp_levels_chunk_0() -> List(U32):
  [
    3,
    5,
    7,
    9,
    11
  ]

def generated_monster_1_hp_levels_chunk_0() -> List(U32):
  [
    5,
    7,
    9,
    11,
    13
  ]

def generated_monster_2_hp_levels_chunk_0() -> List(U32):
  [
    7,
    9,
    11,
    13,
    15
  ]

def generated_monster_3_hp_levels_chunk_0() -> List(U32):
  [
    9,
    11,
    14,
    17,
    20
  ]

def generated_pack_0_pool_chunk_0() -> List(PackPoolEntry):
  [
    pack_pool_entry{monster_card{1}, 4},
    pack_pool_entry{monster_card{3}, 4},
    pack_pool_entry{sword_card{0}, 3},
    pack_pool_entry{sword_card{1}, 2},
    pack_pool_entry{sword_card{2}, 1},
    pack_pool_entry{potion_card{0}, 3},
    pack_pool_entry{potion_card{1}, 2},
    pack_pool_entry{potion_card{2}, 1}
  ]

def generated_config_heroes_chunk_0() -> List(HeroDef):
  [
    hero_def{"adventurer", "Adventurer", "assets/player-boy.png", 12, 0, 1, generated_hero_0_upgrades_chunk_0()},
    hero_def{"gato_de_botas", "Gato de Botas", "assets/player-gato-de-botas.png", 10, 45, 0, generated_hero_1_upgrades_chunk_0()}
  ]

def generated_config_monsters_chunk_0() -> List(MonsterDef):
  [
    monster_def{"Rat", "assets/enemy-rat.png", 3, generated_monster_0_hp_levels_chunk_0()},
    monster_def{"Spider", "assets/enemy-spider.png", 4, generated_monster_1_hp_levels_chunk_0()},
    monster_def{"Venom Spider", "assets/enemy-spider2.png", 5, generated_monster_2_hp_levels_chunk_0()},
    monster_def{"Orc", "assets/enemy-orc.png", 6, generated_monster_3_hp_levels_chunk_0()}
  ]

def generated_config_swords_chunk_0() -> List(SwordDef):
  [
    sword_def{"Sword A", "assets/item-sword.png", 5},
    sword_def{"Sword S", "assets/item-sword.png", 7},
    sword_def{"Sword S+", "assets/item-sword.png", 9}
  ]

def generated_config_potions_chunk_0() -> List(PotionDef):
  [
    potion_def{"Health Potion", "assets/item-potion.png", 3},
    potion_def{"Big Health Potion", "assets/item-potion.png", 7},
    potion_def{"Giant Health Potion", "assets/item-potion.png", 12}
  ]

def generated_config_base_deck_chunk_0() -> List(DeckEntry):
  [
    monster_entry{0, 6},
    monster_entry{1, 3},
    monster_entry{2, 3},
    monster_entry{3, 3},
    sword_entry{0, 1},
    sword_entry{1, 1},
    potion_entry{0, 1},
    potion_entry{1, 1},
    hero_entry{1}
  ]

def generated_config_packs_chunk_0() -> List(PackDef):
  [
    pack_def{"Starter Booster", 100, 4, 0, generated_pack_0_pool_chunk_0()}
  ]

def generated_config() -> Config:
  config{
    generated_config_heroes_chunk_0(),
    generated_config_monsters_chunk_0(),
    generated_config_swords_chunk_0(),
    generated_config_potions_chunk_0(),
    generated_config_base_deck_chunk_0(),
    generated_config_packs_chunk_0(),
    1
  }
