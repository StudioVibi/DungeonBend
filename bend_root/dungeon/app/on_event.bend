import /dungeon/data/config as config
import /dungeon/logic/Meta
import /dungeon/logic/Run
import /dungeon/logic/SwipeResult
import /dungeon/logic/Deck/next_seed as next_seed
import /dungeon/logic/Run/start_run as start_run
import /dungeon/logic/Run/upgrade_hero as upgrade_hero
import /dungeon/logic/Run/apply_swipe as apply_swipe
import /dungeon/app/DungeonState
import /dungeon/app/DungeonEvent

def _state_from_run(meta_state: Meta, run_value: Run, next_seed_value: U32) -> DungeonState:
  match run_value:
    case run{dungeon_level, hero_hp, hero_max_hp, hero_index, weapon, board_value, deck_blueprint, draw_counts, remaining, capacity, seed, status}:
      current = (run{dungeon_level, hero_hp, hero_max_hp, hero_index, weapon, board_value, deck_blueprint, draw_counts, remaining, capacity, seed, status} :: Run);
      match status === 0:
        case 0:
          (game_over{meta_state, current, next_seed_value} :: DungeonState)
        case _:
          (run_screen{meta_state, current, next_seed_value} :: DungeonState)

def _start(meta_state: Meta, seed: U32) -> DungeonState:
  next = next_seed(seed);
  _state_from_run(meta_state, start_run(config(), meta_state, seed), next)

def _state_from_swipe(result: SwipeResult, next_seed_value: U32) -> DungeonState:
  match result:
    case swipe_result{next_meta, next_run}:
      _state_from_run(next_meta, next_run, next_seed_value)

def _apply_turn(meta_state: Meta, run_value: Run, next_seed_value: U32, dir: U32) -> DungeonState:
  _state_from_swipe(apply_swipe(config(), meta_state, run_value, dir), next_seed_value)

def _hub_event(evt: DungeonEvent, meta_state: Meta, next_seed_value: U32) -> DungeonState:
  match evt:
    case start{}:
      _start(meta_state, next_seed_value)
    case restart{}:
      _start(meta_state, next_seed_value)
    case upgrade{}:
      hub{upgrade_hero(config(), meta_state), next_seed_value}
    case _:
      hub{meta_state, next_seed_value}

def _run_event(evt: DungeonEvent, meta_state: Meta, run_value: Run, next_seed_value: U32) -> DungeonState:
  match evt:
    case turn_up{}:
      _apply_turn(meta_state, run_value, next_seed_value, 0)
    case turn_down{}:
      _apply_turn(meta_state, run_value, next_seed_value, 1)
    case turn_left{}:
      _apply_turn(meta_state, run_value, next_seed_value, 2)
    case turn_right{}:
      _apply_turn(meta_state, run_value, next_seed_value, 3)
    case back_to_hub{}:
      hub{meta_state, next_seed_value}
    case restart{}:
      _start(meta_state, next_seed_value)
    case _:
      run_screen{meta_state, run_value, next_seed_value}

def _game_over_event(evt: DungeonEvent, meta_state: Meta, run_value: Run, next_seed_value: U32) -> DungeonState:
  match evt:
    case start{}:
      _start(meta_state, next_seed_value)
    case restart{}:
      _start(meta_state, next_seed_value)
    case back_to_hub{}:
      hub{meta_state, next_seed_value}
    case _:
      game_over{meta_state, run_value, next_seed_value}

def on_event(evt: DungeonEvent, state: DungeonState) -> DungeonState:
  match state:
    case hub{meta_state, next_seed}:
      _hub_event(evt, meta_state, next_seed)
    case run_screen{meta_state, run_value, next_seed}:
      _run_event(evt, meta_state, run_value, next_seed)
    case game_over{meta_state, run_value, next_seed}:
      _game_over_event(evt, meta_state, run_value, next_seed)
