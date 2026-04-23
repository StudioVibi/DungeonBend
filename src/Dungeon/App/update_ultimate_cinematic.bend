import /Dungeon/Meta as Meta
import /Dungeon/Run as Run
import /Dungeon/UiState as UiState
import /Dungeon/DungeonEvent as DungeonEvent
import /Dungeon/DungeonState as DungeonState
import /Dungeon/App/state_helpers/_state as _state
import /Dungeon/App/use_ultimate as use_ultimate

def _advance_ultimate_cinematic(meta_state: Meta, run_value: Run, ticks_remaining: U32, next_seed_value: U32, ui_value: UiState) -> DungeonState:
  _advance_ultimate_cinematic_done(ticks_remaining < 2, meta_state, run_value, ticks_remaining, next_seed_value, ui_value)

def _advance_ultimate_cinematic_done(done: U32, meta_state: Meta, run_value: Run, ticks_remaining: U32, next_seed_value: U32, ui_value: UiState) -> DungeonState:
  match done:
    case 0:
      _state(meta_state, ultimate_cinematic{run_value, ticks_remaining - 1}, next_seed_value, ui_value)
    case _:
      use_ultimate(meta_state, run_value, next_seed_value)

def update_ultimate_cinematic(evt: DungeonEvent, meta_state: Meta, run_value: Run, ticks_remaining: U32, next_seed_value: U32, ui_value: UiState) -> DungeonState:
  match evt:
    case damage_tick{}:
      _advance_ultimate_cinematic(meta_state, run_value, ticks_remaining, next_seed_value, ui_value)
    case _:
      _state(meta_state, ultimate_cinematic{run_value, ticks_remaining}, next_seed_value, ui_value)
