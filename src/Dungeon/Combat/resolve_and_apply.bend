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
import /Dungeon/Board/indexing/board_set as board_set
import /Dungeon/Deck/counts_pick/monster_gold as monster_gold

def _resolve_unarmed(
  monsters: List(MonsterDef),
  board_value: Board,
  hero_hp: U32,
  target_idx: U32,
  monster_ref: U32,
  monster_hp: U32,
) -> CombatResult:
  match hero_hp > monster_hp:
    case 0:
      (combat_result{0, no_weapon{}, board_value, 1} :: CombatResult)
    case _:
      gold = monster_gold(monsters, monster_ref);
      next_board = board_set(board_value, target_idx, gold{gold});
      (combat_result{hero_hp - monster_hp, no_weapon{}, next_board, 0} :: CombatResult)

def _resolve_armed_equal_or_less(
  monsters: List(MonsterDef),
  board_value: Board,
  hero_hp: U32,
  target_idx: U32,
  monster_ref: U32,
  monster_hp: U32,
  weapon_ref: U32,
  dmg: U32,
) -> CombatResult:
  match dmg === monster_hp:
    case 0:
      next_board = board_set(board_value, target_idx, monster{monster_ref, monster_hp - dmg});
      (combat_result{hero_hp, no_weapon{}, next_board, 0} :: CombatResult)
    case _:
      gold = monster_gold(monsters, monster_ref);
      next_board = board_set(board_value, target_idx, gold{gold});
      (combat_result{hero_hp, no_weapon{}, next_board, 0} :: CombatResult)

def _resolve_armed(
  monsters: List(MonsterDef),
  board_value: Board,
  hero_hp: U32,
  target_idx: U32,
  monster_ref: U32,
  monster_hp: U32,
  weapon_ref: U32,
  dmg: U32,
) -> CombatResult:
  match dmg > monster_hp:
    case 0:
      _resolve_armed_equal_or_less(monsters, board_value, hero_hp, target_idx, monster_ref, monster_hp, weapon_ref, dmg)
    case _:
      gold = monster_gold(monsters, monster_ref);
      next_board = board_set(board_value, target_idx, gold{gold});
      combat_result{hero_hp, weapon{weapon_ref, dmg - monster_hp}, next_board, 0}

def resolve_monster(
  config_value: Config,
  board_value: Board,
  hero_hp: U32,
  weapon_value: Weapon,
  target_idx: U32,
  monster_ref: U32,
  monster_hp: U32,
) -> CombatResult:
  match config_value:
    case config{hero_base_max_hp, upgrades, monsters, swords, potions, deck, base_deck_size, starting_dungeon_level}:
      match weapon_value:
        case no_weapon{}:
          _resolve_unarmed(monsters, board_value, hero_hp, target_idx, monster_ref, monster_hp)
        case weapon{ref, dmg}:
          _resolve_armed(monsters, board_value, hero_hp, target_idx, monster_ref, monster_hp, ref, dmg)
