import /Dungeon/Upgrade as Upgrade
import /Dungeon/MonsterDef as MonsterDef
import /Dungeon/SwordDef as SwordDef
import /Dungeon/PotionDef as PotionDef
import /Dungeon/DeckEntry as DeckEntry
import /Dungeon/Weapon as Weapon
import /Dungeon/Tile as Tile
import /Dungeon/Board as Board
import /Dungeon/BoardDraw as BoardDraw
import /Dungeon/DrawResult as DrawResult
import /Dungeon/CombatResult as CombatResult
import /Dungeon/Meta as Meta
import /Dungeon/Config as Config
import /Dungeon/Run as Run
import /Dungeon/SwipeResult as SwipeResult
import /Dungeon/RunSlot as RunSlot
import /Dungeon/DungeonEvent as DungeonEvent
import /Dungeon/DungeonState as DungeonState
import /Dungeon/ImpactState as ImpactState
import /Dungeon/_PickResult as _PickResult

def key_event(key: U32) -> DungeonEvent:
  match key:
    case 37:
      turn_left{}
    case 63234:
      turn_left{}
    case 65:
      turn_left{}
    case 97:
      turn_left{}
    case 38:
      turn_up{}
    case 63232:
      turn_up{}
    case 87:
      turn_up{}
    case 119:
      turn_up{}
    case 39:
      turn_right{}
    case 63235:
      turn_right{}
    case 68:
      turn_right{}
    case 100:
      turn_right{}
    case 40:
      turn_down{}
    case 63233:
      turn_down{}
    case 83:
      turn_down{}
    case 115:
      turn_down{}
    case 32:
      ignore{}
    case 82:
      ignore{}
    case _:
      ignore{}
