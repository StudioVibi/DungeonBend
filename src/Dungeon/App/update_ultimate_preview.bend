import Dungeon/Meta as Meta
import Dungeon/UltimatePreviewFx as UltimatePreviewFx
import Dungeon/UiState as UiState
import Dungeon/DungeonEvent as DungeonEvent
import Dungeon/DungeonState as DungeonState
import Dungeon/default_ui as default_ui
import Dungeon/App/state_helpers/_state as _state

def update_ultimate_preview(evt: DungeonEvent, meta_state: Meta, fx: UltimatePreviewFx, next_seed_value: U32, ui_value: UiState) -> DungeonState:
  match evt:
    case close_ultimate_preview{}:
      _state(meta_state, setup{}, next_seed_value, default_ui())
    case play_ultimate_preview{}:
      _state(meta_state, ultimate_preview{_next_preview_fx(fx)}, next_seed_value, ui_value)
    case _:
      _state(meta_state, ultimate_preview{fx}, next_seed_value, ui_value)

def _next_preview_fx(fx: UltimatePreviewFx) -> UltimatePreviewFx:
  match fx:
    case ultimate_preview_play_a{}:
      ultimate_preview_play_b{}
    case _:
      ultimate_preview_play_a{}
