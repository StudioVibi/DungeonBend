import Dungeon/UiState as UiState
import Dungeon/HpFx as HpFx
import Dungeon/DmgFx as DmgFx
import Dungeon/Impact as Impact
import Dungeon/DamageOverlay as DamageOverlay
import Dungeon/DeckCounterFx as DeckCounterFx
import Midum/Image/reset_state as image_reset_state

def default_ui() -> UiState:
  ui_state{hp_fx_none{}, dmg_fx_none{}, no_impact{}, no_damage_overlay{}, deck_counter_idle{}, image_reset_state()}
