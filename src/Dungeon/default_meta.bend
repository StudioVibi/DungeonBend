import Dungeon/Meta as Meta
import Dungeon/DeckRecord as DeckRecord
import Dungeon/Config as Config
import Dungeon/config as config
import Dungeon/profile_helpers/default_hero_profiles as default_hero_profiles
import Dungeon/rules/starting_gold as starting_gold
import Dungeon/rules/starting_selected_hero as starting_selected_hero
import Dungeon/rules/starting_selection_confirmed as starting_selection_confirmed
import Dungeon/Deck/deck_records/initial_deck_id as initial_deck_id
import Dungeon/Deck/deck_records/initial_deck_name as initial_deck_name
import Dungeon/Deck/sleeves/default_sleeve as default_sleeve

def default_meta() -> Meta:
  cfg = config();
  initial = _initial_deck_record(cfg);
  meta{
    starting_selected_hero(),
    starting_selection_confirmed(),
    starting_gold(),
    [],
    [],
    default_hero_profiles(cfg),
    [initial],
    initial_deck_id(),
    initial_deck_id() + 1
  }

def _initial_deck_record(cfg: Config) -> DeckRecord:
  match cfg:
    case config{heroes, monsters, swords, potions, deck, booster_packs, starting_dungeon_level}:
      deck_record{initial_deck_id(), initial_deck_name(), default_sleeve(), deck}
