import /dungeon/logic/Weapon
import /dungeon/logic/Board

type CombatResult {
  combat_result{
    hero_hp: U32,
    weapon: Weapon,
    board: Board,
    status: U32
  }
}
