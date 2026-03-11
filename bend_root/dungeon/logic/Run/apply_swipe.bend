import /dungeon/logic/Config
import /dungeon/logic/Meta
import /dungeon/logic/Run
import /dungeon/logic/Board
import /dungeon/logic/Weapon
import /dungeon/logic/DeckEntry
import /dungeon/logic/Tile
import /dungeon/logic/SwipeResult
import /dungeon/logic/CombatResult
import /dungeon/logic/DrawResult
import /dungeon/logic/Board/adjacent_index as adjacent_index
import /dungeon/logic/Board/board_get as board_get
import /dungeon/logic/Board/shift_after_move as shift_after_move
import /dungeon/logic/Combat/resolve_monster as resolve_monster
import /dungeon/logic/Deck/draw_tile as draw_tile

def _min_u32(a: U32, b: U32) -> U32:
  match a < b:
    case 0:
      b
    case _:
      a

def _add_gold(meta_state: Meta, amount: U32) -> Meta:
  match meta_state:
    case meta{hero_level, gold}:
      meta{hero_level, gold + amount}

def _keep_run(
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
) -> SwipeResult:
  swipe_result{
    meta_state,
    run{
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
      status
    }
  }

def _move_after_collect_from_draw(
  meta_state: Meta,
  hero_hp: U32,
  hero_max_hp: U32,
  hero_index: U32,
  target_index: U32,
  weapon_value: Weapon,
  board_value: Board,
  deck_blueprint: List(DeckEntry),
  capacity: U32,
  result: DrawResult,
  dir: U32,
) -> SwipeResult:
  match result:
    case draw_result{spawn, next_counts, next_remaining, next_seed, next_level}:
      swipe_result{
        meta_state,
        run{
          next_level,
          hero_hp,
          hero_max_hp,
          target_index,
          weapon_value,
          shift_after_move(board_value, hero_index, target_index, dir, spawn),
          deck_blueprint,
          next_counts,
          next_remaining,
          capacity,
          next_seed,
          0
        }
      }

def _move_after_collect(
  config_value: Config,
  meta_state: Meta,
  dungeon_level: U32,
  hero_hp: U32,
  hero_max_hp: U32,
  hero_index: U32,
  target_index: U32,
  weapon_value: Weapon,
  board_value: Board,
  deck_blueprint: List(DeckEntry),
  draw_counts: List(DeckEntry),
  remaining: U32,
  capacity: U32,
  seed: U32,
  dir: U32,
) -> SwipeResult:
  _move_after_collect_from_draw(
    meta_state,
    hero_hp,
    hero_max_hp,
    hero_index,
    target_index,
    weapon_value,
    board_value,
    deck_blueprint,
    capacity,
    draw_tile(config_value, deck_blueprint, draw_counts, remaining, seed, dungeon_level),
    dir
  )

def _from_combat(
  meta_state: Meta,
  dungeon_level: U32,
  hero_max_hp: U32,
  hero_index: U32,
  deck_blueprint: List(DeckEntry),
  draw_counts: List(DeckEntry),
  remaining: U32,
  capacity: U32,
  seed: U32,
  result: CombatResult,
) -> SwipeResult:
  match result:
    case combat_result{next_hp, next_weapon, next_board, next_status}:
      swipe_result{
        meta_state,
        run{
          dungeon_level,
          next_hp,
          hero_max_hp,
          hero_index,
          next_weapon,
          next_board,
          deck_blueprint,
          draw_counts,
          remaining,
          capacity,
          seed,
          next_status
        }
      }

def _apply_to_tile(
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
  dir: U32,
  target_index: U32,
  tile_value: Tile,
) -> SwipeResult:
  match tile_value:
    case none{}:
      _keep_run(meta_state, dungeon_level, hero_hp, hero_max_hp, hero_index, weapon_value, board_value, deck_blueprint, draw_counts, remaining, capacity, seed, status)
    case monster{ref, hp}:
      _from_combat(
        meta_state,
        dungeon_level,
        hero_max_hp,
        hero_index,
        deck_blueprint,
        draw_counts,
        remaining,
        capacity,
        seed,
        resolve_monster(config_value, board_value, hero_hp, weapon_value, target_index, ref, hp)
      )
    case sword{ref, dmg}:
      _move_after_collect(config_value, meta_state, dungeon_level, hero_hp, hero_max_hp, hero_index, target_index, weapon{ref, dmg}, board_value, deck_blueprint, draw_counts, remaining, capacity, seed, dir)
    case potion{ref, heal}:
      next_hp = _min_u32(hero_max_hp, hero_hp + heal);
      _move_after_collect(config_value, meta_state, dungeon_level, next_hp, hero_max_hp, hero_index, target_index, weapon_value, board_value, deck_blueprint, draw_counts, remaining, capacity, seed, dir)
    case gold{amount}:
      next_meta = _add_gold(meta_state, amount);
      _move_after_collect(config_value, next_meta, dungeon_level, hero_hp, hero_max_hp, hero_index, target_index, weapon_value, board_value, deck_blueprint, draw_counts, remaining, capacity, seed, dir)

def apply_swipe(config_value: Config, meta_state: Meta, run_value: Run, dir: U32) -> SwipeResult:
  match run_value:
    case run{dungeon_level, hero_hp, hero_max_hp, hero_index, weapon_value, board_value, deck_blueprint, draw_counts, remaining, capacity, seed, status}:
      match status === 0:
        case 0:
          _keep_run(meta_state, dungeon_level, hero_hp, hero_max_hp, hero_index, weapon_value, board_value, deck_blueprint, draw_counts, remaining, capacity, seed, status)
        case _:
          target_index = adjacent_index(hero_index, dir);
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
                dir,
                target_index,
                board_get(board_value, target_index)
              )
            case _:
              _keep_run(meta_state, dungeon_level, hero_hp, hero_max_hp, hero_index, weapon_value, board_value, deck_blueprint, draw_counts, remaining, capacity, seed, status)
