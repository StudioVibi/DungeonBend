import /bend/types as Types
import /bend/board as Board
import /bend/deck as Deck

type CombatResult {
  combat_result{
    hero_hp: U32,
    weapon: Types.Weapon,
    board: Types.Board,
    status: U32
  }
}

def resolve_monster(
  config_value: Types.Config,
  board_value: Types.Board,
  hero_hp: U32,
  weapon_state: Types.Weapon,
  target_idx: U32,
  monster_ref: U32,
  monster_hp: U32,
) -> CombatResult:
  match config_value:
    case config{hero_base_max_hp, upgrades, monsters, swords, potions, deck, base_deck_size, starting_dungeon_level}:
      match weapon_state:
        case no_weapon{}:
          resolve_unarmed(monsters, board_value, hero_hp, target_idx, monster_ref, monster_hp)
        case weapon{ref, dmg}:
          resolve_armed(monsters, board_value, hero_hp, target_idx, monster_ref, monster_hp, ref, dmg)

def resolve_unarmed(
  monsters: List(Types.MonsterDef),
  board_value: Types.Board,
  hero_hp: U32,
  target_idx: U32,
  monster_ref: U32,
  monster_hp: U32,
) -> CombatResult:
  match hero_hp > monster_hp:
    case 0:
      (combat_result{0, no_weapon{}, board_value, 1} :: CombatResult)
    case _:
      gold = Deck.monster_gold(monsters, monster_ref);
      next_board = Board.board_set(board_value, target_idx, gold{gold});
      (combat_result{hero_hp - monster_hp, no_weapon{}, next_board, 0} :: CombatResult)

def resolve_armed(
  monsters: List(Types.MonsterDef),
  board_value: Types.Board,
  hero_hp: U32,
  target_idx: U32,
  monster_ref: U32,
  monster_hp: U32,
  weapon_ref: U32,
  dmg: U32,
) -> CombatResult:
  match dmg > monster_hp:
    case 0:
      resolve_armed_equal_or_less(monsters, board_value, hero_hp, target_idx, monster_ref, monster_hp, weapon_ref, dmg)
    case _:
      gold = Deck.monster_gold(monsters, monster_ref);
      next_board = Board.board_set(board_value, target_idx, gold{gold});
      combat_result{hero_hp, weapon{weapon_ref, dmg}, next_board, 0}

def resolve_armed_equal_or_less(
  monsters: List(Types.MonsterDef),
  board_value: Types.Board,
  hero_hp: U32,
  target_idx: U32,
  monster_ref: U32,
  monster_hp: U32,
  weapon_ref: U32,
  dmg: U32,
) -> CombatResult:
  match dmg === monster_hp:
    case 0:
      next_board = Board.board_set(board_value, target_idx, monster{monster_ref, monster_hp - dmg});
      (combat_result{hero_hp, weapon{weapon_ref, dmg}, next_board, 0} :: CombatResult)
    case _:
      gold = Deck.monster_gold(monsters, monster_ref);
      next_board = Board.board_set(board_value, target_idx, gold{gold});
      (combat_result{hero_hp, no_weapon{}, next_board, 0} :: CombatResult)
