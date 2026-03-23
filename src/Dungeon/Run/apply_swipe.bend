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
import /Dungeon/Run/start_refill_upgrade/_keep_run as _keep_run
import /Dungeon/Run/start_refill_upgrade/_apply_to_tile as _apply_to_tile
import /Dungeon/Board/indexing/adjacent_index as adjacent_index
import /Dungeon/Board/indexing/board_get as board_get

def apply_swipe(config_value: Config, meta_state: Meta, run_value: Run, dir: U32) -> SwipeResult:
  match run_value:
    case run{dungeon_level, hero_hp, hero_max_hp, hero_index, weapon_value, board_value, deck_blueprint, draw_counts, remaining, capacity, seed, status, ult_charge}:
      match status === 0:
        case 0:
          _keep_run(meta_state, dungeon_level, hero_hp, hero_max_hp, hero_index, weapon_value, board_value, deck_blueprint, draw_counts, remaining, capacity, seed, status, ult_charge)
        case _:
          _apply_swipe_target(
            config_value,
            meta_state,
            dungeon_level,
            hero_hp,
            hero_max_hp,
            hero_index,
            weapon_value,
            board_value,
            deck_blueprint,
            draw_counts,
            remaining,
            capacity,
            seed,
            status,
            ult_charge,
            dir,
            adjacent_index(hero_index, dir)
          )

def _apply_swipe_target(
  config_value: Config,
  meta_state: Meta,
  dungeon_level: U32,
  hero_hp: U32,
  hero_max_hp: U32,
  hero_index: U32,
  weapon_value: Weapon,
  board_value: Board,
  deck_blueprint: List(DeckEntry),
  draw_counts: List(DeckEntry),
  remaining: U32,
  capacity: U32,
  seed: U32,
  status: U32,
  ult_charge: U32,
  dir: U32,
  target_index: U32,
) -> SwipeResult:
  match target_index === 9:
    case 0:
      _apply_to_tile(
        config_value,
        meta_state,
        dungeon_level,
        hero_hp,
        hero_max_hp,
        hero_index,
        weapon_value,
        board_value,
        deck_blueprint,
        draw_counts,
        remaining,
        capacity,
        seed,
        status,
        ult_charge,
        dir,
        target_index,
        board_get(board_value, target_index)
      )
    case _:
      _keep_run(meta_state, dungeon_level, hero_hp, hero_max_hp, hero_index, weapon_value, board_value, deck_blueprint, draw_counts, remaining, capacity, seed, status, ult_charge)
