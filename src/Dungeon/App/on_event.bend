import /App/
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
import /Dungeon/config as config
import /Dungeon/Deck/counts_pick/next_seed as next_seed
import /Dungeon/Board/indexing/adjacent_index as adjacent_index
import /Dungeon/Board/indexing/board_get as board_get
import /Dungeon/Board/indexing/empty_board as empty_board
import /Dungeon/Run/start_refill_upgrade/start_run as start_run
import /Dungeon/Run/start_refill_upgrade/upgrade_hero as upgrade_hero
import /Dungeon/Run/start_refill_upgrade/_refill_non_hero_slots as _refill_non_hero_slots
import /Dungeon/Run/apply_swipe as apply_swipe

def _state_from_run(meta_state: Meta, run_value: Run, next_seed_value: U32, hp_fx: U32, dmg_fx: U32, impact_idx: U32, impact_fx: U32) -> DungeonState:
  dungeon{meta_state, run_slot{run_value}, next_seed_value, hp_fx, dmg_fx, impact_idx, impact_fx}

def _start(meta_state: Meta, seed: U32) -> DungeonState:
  next = next_seed(seed);
  _state_from_run(meta_state, start_run(config(), meta_state, seed), next, 0, 0, 9, 0)

def _hero_hp(run_value: Run) -> U32:
  match run_value:
    case run{dungeon_level, hero_hp, hero_max_hp, hero_index, weapon, board_value, deck_blueprint, draw_counts, remaining, capacity, seed, status, ult_charge}:
      hero_hp

def _weapon_dmg(weapon_value: Weapon) -> U32:
  match weapon_value:
    case no_weapon{}:
      0
    case weapon{ref, dmg}:
      dmg

def _hero_dmg(run_value: Run) -> U32:
  match run_value:
    case run{dungeon_level, hero_hp, hero_max_hp, hero_index, weapon, board_value, deck_blueprint, draw_counts, remaining, capacity, seed, status, ult_charge}:
      _weapon_dmg(weapon)

def _run_status(run_value: Run) -> U32:
  match run_value:
    case run{dungeon_level, hero_hp, hero_max_hp, hero_index, weapon, board_value, deck_blueprint, draw_counts, remaining, capacity, seed, status, ult_charge}:
      status

def _run_ult_charge(run_value: Run) -> U32:
  match run_value:
    case run{dungeon_level, hero_hp, hero_max_hp, hero_index, weapon, board_value, deck_blueprint, draw_counts, remaining, capacity, seed, status, ult_charge}:
      ult_charge

def _run_with_ult_charge(run_value: Run, next_ult_charge: U32) -> Run:
  match run_value:
    case run{dungeon_level, hero_hp, hero_max_hp, hero_index, weapon, board_value, deck_blueprint, draw_counts, remaining, capacity, seed, status, ult_charge}:
      run{
        dungeon_level,
        hero_hp,
        hero_max_hp,
        hero_index,
        weapon,
        board_value,
        deck_blueprint,
        draw_counts,
        remaining,
        capacity,
        seed,
        status,
        next_ult_charge
      }

def _run_charge_after_gain(current_charge: U32) -> U32:
  match current_charge < 6:
    case 0:
      6
    case _:
      current_charge + 1

def _run_moved(current_run: Run, next_run: Run) -> U32:
  match _run_hero_index(current_run) === _run_hero_index(next_run):
    case 0:
      1
    case _:
      0

def _next_ult_charge(current_run: Run, next_run: Run) -> U32:
  current_charge = _run_ult_charge(current_run);
  match _run_moved(current_run, next_run):
    case 0:
      current_charge
    case _:
      _run_charge_after_gain(current_charge)

def _phase_from_run(run_value: Run) -> U32:
  match _run_status(run_value) === 0:
    case 0:
      2
    case _:
      1

def _phase(current_run: RunSlot) -> U32:
  match current_run:
    case idle_run{}:
      0
    case run_slot{run_value}:
      _phase_from_run(run_value)

def _has_run(current_run: RunSlot) -> U32:
  match current_run:
    case idle_run{}:
      0
    case run_slot{run_value}:
      1

def _is_idle(current_run: RunSlot) -> U32:
  match current_run:
    case idle_run{}:
      1
    case run_slot{run_value}:
      0

def _is_active_run(current_run: RunSlot) -> U32:
  match _phase(current_run) === 1:
    case 0:
      0
    case _:
      1

def _is_game_over(current_run: RunSlot) -> U32:
  match current_run:
    case idle_run{}:
      0
    case run_slot{run_value}:
      _is_game_over_run(run_value)

def _is_game_over_run(run_value: Run) -> U32:
  _is_game_over_status(_run_status(run_value))

def _is_game_over_status(status: U32) -> U32:
  match status === 0:
    case 0:
      1
    case _:
      0

def _can_upgrade(current_run: RunSlot) -> U32:
  _is_idle(current_run)

def _toggle_heal_fx(hp_fx: U32) -> U32:
  match hp_fx === 1:
    case 0:
      1
    case _:
      2

def _toggle_hurt_fx(hp_fx: U32) -> U32:
  match hp_fx === 3:
    case 0:
      3
    case _:
      4

def _toggle_dmg_up_fx(dmg_fx: U32) -> U32:
  match dmg_fx === 1:
    case 0:
      1
    case _:
      2

def _toggle_dmg_down_fx(dmg_fx: U32) -> U32:
  match dmg_fx === 3:
    case 0:
      3
    case _:
      4

def _next_hp_fx_values(current_hp: U32, next_hp: U32, current_hp_fx: U32) -> U32:
  match current_hp < next_hp:
    case 0:
      match next_hp < current_hp:
        case 0:
          0
        case _:
          _toggle_hurt_fx(current_hp_fx)
    case _:
      _toggle_heal_fx(current_hp_fx)

def _next_hp_fx(current_run: Run, next_run: Run, current_hp_fx: U32) -> U32:
  _next_hp_fx_values(_hero_hp(current_run), _hero_hp(next_run), current_hp_fx)

def _next_dmg_fx_values(current_dmg: U32, next_dmg: U32, current_dmg_fx: U32) -> U32:
  match current_dmg < next_dmg:
    case 0:
      match next_dmg < current_dmg:
        case 0:
          0
        case _:
          _toggle_dmg_down_fx(current_dmg_fx)
    case _:
      _toggle_dmg_up_fx(current_dmg_fx)

def _next_dmg_fx(current_run: Run, next_run: Run, current_dmg_fx: U32) -> U32:
  _next_dmg_fx_values(_hero_dmg(current_run), _hero_dmg(next_run), current_dmg_fx)

def _toggle_impact_hit_fx(current_impact_fx: U32) -> U32:
  match current_impact_fx === 1:
    case 0:
      1
    case _:
      2

def _toggle_impact_kill_fx(current_impact_fx: U32) -> U32:
  match current_impact_fx === 3:
    case 0:
      3
    case _:
      4

def _run_hero_index(run_value: Run) -> U32:
  match run_value:
    case run{dungeon_level, hero_hp, hero_max_hp, hero_index, weapon, board_value, deck_blueprint, draw_counts, remaining, capacity, seed, status, ult_charge}:
      hero_index

def _run_board(run_value: Run) -> Board:
  match run_value:
    case run{dungeon_level, hero_hp, hero_max_hp, hero_index, weapon, board_value, deck_blueprint, draw_counts, remaining, capacity, seed, status, ult_charge}:
      board_value

def _impact_none() -> ImpactState:
  impact_state{9, 0}

def _impact_hit(target_idx: U32, current_impact_fx: U32) -> ImpactState:
  impact_state{target_idx, _toggle_impact_hit_fx(current_impact_fx)}

def _impact_kill(target_idx: U32, current_impact_fx: U32) -> ImpactState:
  impact_state{target_idx, _toggle_impact_kill_fx(current_impact_fx)}

def _impact_from_monster_hp(target_idx: U32, prev_hp: U32, next_hp: U32, current_impact_fx: U32) -> ImpactState:
  match next_hp < prev_hp:
    case 0:
      _impact_none()
    case _:
      _impact_hit(target_idx, current_impact_fx)

def _impact_from_monster_next(target_idx: U32, prev_hp: U32, next_tile: Tile, current_impact_fx: U32) -> ImpactState:
  match next_tile:
    case monster{next_ref, next_hp}:
      _impact_from_monster_hp(target_idx, prev_hp, next_hp, current_impact_fx)
    case gold{amount}:
      _impact_kill(target_idx, current_impact_fx)
    case _:
      _impact_none()

def _impact_from_target_tile(target_idx: U32, prev_tile: Tile, next_tile: Tile, current_impact_fx: U32) -> ImpactState:
  match prev_tile:
    case monster{ref, prev_hp}:
      _impact_from_monster_next(target_idx, prev_hp, next_tile, current_impact_fx)
    case _:
      _impact_none()

def _impact_from_turn(current_run: Run, next_run: Run, dir: U32, current_impact_fx: U32) -> ImpactState:
  target_idx = adjacent_index(_run_hero_index(current_run), dir);
  prev_tile = board_get(_run_board(current_run), target_idx);
  next_tile = board_get(_run_board(next_run), target_idx);
  _impact_from_target_tile(target_idx, prev_tile, next_tile, current_impact_fx)

def _state_from_swipe_impact(next_meta: Meta, current_run: Run, next_run: Run, next_seed_value: U32, current_hp_fx: U32, current_dmg_fx: U32, impact: ImpactState) -> DungeonState:
  match impact:
    case impact_state{next_impact_idx, next_impact_fx}:
      charged_run = _run_with_ult_charge(next_run, _next_ult_charge(current_run, next_run));
      _state_from_run(
        next_meta,
        charged_run,
        next_seed_value,
        _next_hp_fx(current_run, next_run, current_hp_fx),
        _next_dmg_fx(current_run, next_run, current_dmg_fx),
        next_impact_idx,
        next_impact_fx
      )

def _state_from_swipe(result: SwipeResult, current_run: Run, next_seed_value: U32, current_hp_fx: U32, current_dmg_fx: U32, current_impact_fx: U32, dir: U32) -> DungeonState:
  match result:
    case swipe_result{next_meta, next_run}:
      impact = _impact_from_turn(current_run, next_run, dir, current_impact_fx);
      _state_from_swipe_impact(next_meta, current_run, next_run, next_seed_value, current_hp_fx, current_dmg_fx, impact)

def _apply_turn(meta_state: Meta, run_value: Run, next_seed_value: U32, dir: U32, current_hp_fx: U32, current_dmg_fx: U32, current_impact_fx: U32) -> DungeonState:
  result = apply_swipe(config(), meta_state, run_value, dir);
  _state_from_swipe(result, run_value, next_seed_value, current_hp_fx, current_dmg_fx, current_impact_fx, dir)

def _ultimate_run_from_values(
  hero_hp: U32,
  hero_max_hp: U32,
  hero_index: U32,
  weapon_value: Weapon,
  deck_blueprint: List(DeckEntry),
  capacity: U32,
  status: U32,
  stage: BoardDraw,
) -> Run:
  match stage:
    case board_draw{next_board, next_counts, next_remaining, next_seed_value, next_level}:
      run{
        next_level,
        hero_hp,
        hero_max_hp,
        hero_index,
        weapon_value,
        next_board,
        deck_blueprint,
        next_counts,
        next_remaining,
        capacity,
        next_seed_value,
        status,
        0
      }

def _use_ultimate(meta_state: Meta, run_value: Run, next_seed_value: U32) -> DungeonState:
  match run_value:
    case run{dungeon_level, hero_hp, hero_max_hp, hero_index, weapon_value, board_value, deck_blueprint, draw_counts, remaining, capacity, seed, status, ult_charge}:
      stage = _refill_non_hero_slots(config(), empty_board(), hero_index, deck_blueprint, draw_counts, remaining, seed, dungeon_level);
      _state_from_run(meta_state, _ultimate_run_from_values(hero_hp, hero_max_hp, hero_index, weapon_value, deck_blueprint, capacity, status, stage), next_seed_value, 0, 0, 9, 0)

def _ultimate_ready_charge(ult_charge: U32) -> U32:
  match ult_charge === 6:
    case 0:
      0
    case _:
      1

def _ultimate_ready(run_value: Run) -> U32:
  _ultimate_ready_charge(_run_ult_charge(run_value))

def _can_afford_upgrade(meta_state: Meta, cost: U32) -> U32:
  match meta_state:
    case meta{hero_level, gold}:
      _can_afford_upgrade_gold(gold, cost)

def _can_afford_upgrade_gold(gold: U32, cost: U32) -> U32:
  match cost === 0:
    case 0:
      match gold < cost:
        case 0:
          1
        case _:
          0
    case _:
      0

def _idle_event(evt: DungeonEvent, meta_state: Meta, next_seed_value: U32, hp_fx: U32, dmg_fx: U32, impact_idx: U32, impact_fx: U32) -> DungeonState:
  match evt:
    case start{}:
      _start(meta_state, next_seed_value)
    case upgrade{}:
      dungeon{upgrade_hero(config(), meta_state), idle_run{}, next_seed_value, 0, 0, 9, 0}
    case _:
      dungeon{meta_state, idle_run{}, next_seed_value, hp_fx, dmg_fx, 9, 0}

def _active_run_ultimate(meta_state: Meta, run_value: Run, next_seed_value: U32, hp_fx: U32, dmg_fx: U32, impact_idx: U32, impact_fx: U32) -> DungeonState:
  match _ultimate_ready(run_value):
    case 0:
      _state_from_run(meta_state, run_value, next_seed_value, hp_fx, dmg_fx, impact_idx, impact_fx)
    case _:
      _use_ultimate(meta_state, run_value, next_seed_value)

def _active_run_event(evt: DungeonEvent, meta_state: Meta, run_value: Run, next_seed_value: U32, hp_fx: U32, dmg_fx: U32, impact_idx: U32, impact_fx: U32) -> DungeonState:
  match evt:
    case ultimate{}:
      _active_run_ultimate(meta_state, run_value, next_seed_value, hp_fx, dmg_fx, impact_idx, impact_fx)
    case turn_up{}:
      _apply_turn(meta_state, run_value, next_seed_value, 0, hp_fx, dmg_fx, impact_fx)
    case turn_down{}:
      _apply_turn(meta_state, run_value, next_seed_value, 1, hp_fx, dmg_fx, impact_fx)
    case turn_left{}:
      _apply_turn(meta_state, run_value, next_seed_value, 2, hp_fx, dmg_fx, impact_fx)
    case turn_right{}:
      _apply_turn(meta_state, run_value, next_seed_value, 3, hp_fx, dmg_fx, impact_fx)
    case _:
      _state_from_run(meta_state, run_value, next_seed_value, hp_fx, dmg_fx, impact_idx, impact_fx)

def _ended_run_event(evt: DungeonEvent, meta_state: Meta, run_value: Run, next_seed_value: U32, hp_fx: U32, dmg_fx: U32, impact_idx: U32, impact_fx: U32) -> DungeonState:
  match evt:
    case ok{}:
      dungeon{meta_state, idle_run{}, next_seed_value, 0, 0, 9, 0}
    case _:
      _state_from_run(meta_state, run_value, next_seed_value, hp_fx, dmg_fx, impact_idx, impact_fx)

def _next_state(evt: DungeonEvent, state: DungeonState) -> DungeonState:
  match state:
    case dungeon{meta_state, idle_run{}, next_seed_value, hp_fx, dmg_fx, impact_idx, impact_fx}:
      _idle_event(evt, meta_state, next_seed_value, hp_fx, dmg_fx, impact_idx, impact_fx)
    case dungeon{meta_state, run_slot{run_value}, next_seed_value, hp_fx, dmg_fx, impact_idx, impact_fx}:
      match _run_status(run_value) === 0:
        case 0:
          _ended_run_event(evt, meta_state, run_value, next_seed_value, hp_fx, dmg_fx, impact_idx, impact_fx)
        case _:
          _active_run_event(evt, meta_state, run_value, next_seed_value, hp_fx, dmg_fx, impact_idx, impact_fx)

def on_event(evt: DungeonEvent, state: DungeonState) -> App/Update(DungeonState, DungeonEvent):
  update{_next_state(evt, state), none{}}
