import /dungeon/logic/Config
import /dungeon/logic/Upgrade
import /dungeon/logic/MonsterDef
import /dungeon/logic/SwordDef
import /dungeon/logic/PotionDef
import /dungeon/logic/DeckEntry

def config() -> Config:
  config{
    11,
    [
      upgrade{20, 14},
      upgrade{35, 17},
      upgrade{55, 20},
      upgrade{80, 24}
    ],
    [
      monster_def{3, [3, 5, 7, 9, 11]},
      monster_def{4, [5, 7, 9, 11, 13]},
      monster_def{5, [7, 9, 11, 13, 15]},
      monster_def{6, [9, 11, 14, 17, 20]}
    ],
    [
      sword_def{5},
      sword_def{7},
      sword_def{9}
    ],
    [
      potion_def{4}
    ],
    [
      deck_entry{0, 0, 4},
      deck_entry{0, 1, 3},
      deck_entry{0, 2, 3},
      deck_entry{0, 3, 3},
      deck_entry{1, 0, 1},
      deck_entry{1, 1, 1},
      deck_entry{1, 2, 1},
      deck_entry{2, 0, 3},
      deck_entry{3, 0, 1}
    ],
    20,
    1
  }
