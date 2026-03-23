import /U32/ as U32
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

def _hero_name() -> String:
  "Adventurer"

def _hero_sprite() -> String:
  "assets/player-boy.png"

def _gold_name() -> String:
  "Gold"

def _gold_sprite() -> String:
  "assets/item-gold.png"

def _monster_name(ref: U32) -> String:
  match ref:
    case 0:
      "Rat"
    case 1:
      "Spider"
    case 2:
      "Venom Spider"
    case 3:
      "Orc"
    case _:
      "Monster"

def _monster_sprite(ref: U32) -> String:
  match ref:
    case 0:
      "assets/enemy-rat.png"
    case 1:
      "assets/enemy-spider.png"
    case 2:
      "assets/enemy-spider2.png"
    case 3:
      "assets/enemy-orc.png"
    case _:
      ""

def _sword_name(ref: U32) -> String:
  match ref:
    case 0:
      "Sword"
    case 1:
      "Sword"
    case 2:
      "Sword"
    case _:
      "Sword"

def _sword_sprite(ref: U32) -> String:
  match ref:
    case 0:
      "assets/item-sword.png"
    case 1:
      "assets/item-sword.png"
    case 2:
      "assets/item-sword.png"
    case _:
      ""

def _potion_name(ref: U32) -> String:
  "Potion"

def _potion_sprite(ref: U32) -> String:
  "assets/item-potion.png"

def _tile_name(tile: Tile) -> String:
  match tile:
    case none{}:
      "Empty"
    case monster{ref, hp}:
      _monster_name(ref)
    case sword{ref, dmg}:
      _sword_name(ref)
    case potion{ref, heal}:
      _potion_name(ref)
    case gold{amount}:
      _gold_name()

def _tile_sprite(tile: Tile) -> String:
  match tile:
    case none{}:
      ""
    case monster{ref, hp}:
      _monster_sprite(ref)
    case sword{ref, dmg}:
      _sword_sprite(ref)
    case potion{ref, heal}:
      _potion_sprite(ref)
    case gold{amount}:
      _gold_sprite()

def _tile_badge(tile: Tile) -> String:
  match tile:
    case none{}:
      ""
    case monster{ref, hp}:
      "HP " ++ U32.show(hp)
    case sword{ref, dmg}:
      "DMG " ++ U32.show(dmg)
    case potion{ref, heal}:
      "HEAL " ++ U32.show(heal)
    case gold{amount}:
      "GOLD " ++ U32.show(amount)
