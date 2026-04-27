import Dungeon/MonsterDef as MonsterDef
import Dungeon/Weapon as Weapon
import Dungeon/Board as Board
import Dungeon/CombatResult as CombatResult
import Dungeon/Config as Config
import Dungeon/Board/indexing/board_set as board_set
import Dungeon/Deck/counts_pick/monster_gold as monster_gold
def _resolve_unarmed(monsters: List(MonsterDef), board_value: Board, hero_hp: U32, target_idx: U32, monster_ref: U32, monster_hp: U32) -> CombatResult:
  _resolve_unarmed_hit(hero_hp > monster_hp, monsters, board_value, hero_hp, target_idx, monster_ref, monster_hp)

def _resolve_unarmed_hit(hero_wins: U32, monsters: List(MonsterDef), board_value: Board, hero_hp: U32, target_idx: U32, monster_ref: U32, monster_hp: U32) -> CombatResult:
  match hero_wins:
    case 0:
      combat_result{0, no_weapon{}, board_value, combat_game_over{}}
    case _:
      gold_drop = monster_gold(monsters, monster_ref);
      next_board = board_set(board_value, target_idx, gold{gold_drop});
      combat_result{hero_hp - monster_hp, no_weapon{}, next_board, combat_continue{}}

def _resolve_armed_equal_or_less(monsters: List(MonsterDef), board_value: Board, hero_hp: U32, target_idx: U32, monster_ref: U32, monster_hp: U32, weapon_ref: U32, dmg: U32) -> CombatResult:
  _resolve_armed_finish(dmg === monster_hp, monsters, board_value, hero_hp, target_idx, monster_ref, monster_hp, dmg)

def _resolve_armed_finish(exact_kill: U32, monsters: List(MonsterDef), board_value: Board, hero_hp: U32, target_idx: U32, monster_ref: U32, monster_hp: U32, dmg: U32) -> CombatResult:
  match exact_kill:
    case 0:
      next_board = board_set(board_value, target_idx, monster{monster_ref, monster_hp - dmg});
      combat_result{hero_hp, no_weapon{}, next_board, combat_continue{}}
    case _:
      gold_drop = monster_gold(monsters, monster_ref);
      next_board = board_set(board_value, target_idx, gold{gold_drop});
      combat_result{hero_hp, no_weapon{}, next_board, combat_continue{}}

def _resolve_armed(monsters: List(MonsterDef), board_value: Board, hero_hp: U32, target_idx: U32, monster_ref: U32, monster_hp: U32, weapon_ref: U32, dmg: U32) -> CombatResult:
  _resolve_armed_hit(dmg > monster_hp, monsters, board_value, hero_hp, target_idx, monster_ref, monster_hp, weapon_ref, dmg)

def _resolve_armed_hit(overkill: U32, monsters: List(MonsterDef), board_value: Board, hero_hp: U32, target_idx: U32, monster_ref: U32, monster_hp: U32, weapon_ref: U32, dmg: U32) -> CombatResult:
  match overkill:
    case 0:
      _resolve_armed_equal_or_less(monsters, board_value, hero_hp, target_idx, monster_ref, monster_hp, weapon_ref, dmg)
    case _:
      gold_drop = monster_gold(monsters, monster_ref);
      next_board = board_set(board_value, target_idx, gold{gold_drop});
      combat_result{hero_hp, weapon{weapon_ref, dmg - monster_hp}, next_board, combat_continue{}}

def resolve_monster(config_value: Config, board_value: Board, hero_hp: U32, weapon_value: Weapon, target_idx: U32, monster_ref: U32, monster_hp: U32) -> CombatResult:
  match config_value:
    case config{heroes, monsters, swords, potions, deck, booster_packs, starting_dungeon_level}:
      match weapon_value:
        case no_weapon{}:
          _resolve_unarmed(monsters, board_value, hero_hp, target_idx, monster_ref, monster_hp)
        case weapon{ref, dmg}:
          _resolve_armed(monsters, board_value, hero_hp, target_idx, monster_ref, monster_hp, ref, dmg)
