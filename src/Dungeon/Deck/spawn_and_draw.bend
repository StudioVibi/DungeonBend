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
import /Dungeon/Deck/counts_pick/sum_counts as sum_counts
import /Dungeon/Deck/counts_pick/_pick_entry as _pick_entry
import /Dungeon/Deck/counts_pick/next_seed as next_seed
import /Dungeon/Deck/counts_pick/_monster_hp as _monster_hp
import /Dungeon/Deck/counts_pick/_sword_damage as _sword_damage
import /Dungeon/Deck/counts_pick/_potion_heal as _potion_heal

def _spawn_tile(config_value: Config, kind: U32, ref: U32, level: U32) -> Tile:
  match config_value:
    case config{hero_base_max_hp, upgrades, monsters, swords, potions, deck, base_deck_size, starting_dungeon_level}:
      match kind:
        case 0:
          monster{ref, _monster_hp(monsters, ref, level)}
        case 1:
          sword{ref, _sword_damage(swords, ref)}
        case 2:
          potion{ref, _potion_heal(potions, ref)}
        case _:
          none{}

def _pick_result_to_draw(
  config_value: Config,
  remaining: U32,
  next_seed_value: U32,
  level: U32,
  result: _PickResult,
) -> DrawResult:
  match result:
    case pick_result{kind, ref, counts}:
      draw_result{
        _spawn_tile(config_value, kind, ref, level),
        counts,
        remaining - 1,
        next_seed_value,
        level
      }

def _draw_from_counts(
  config_value: Config,
  draw_counts: List(DeckEntry),
  remaining: U32,
  seed: U32,
  level: U32,
) -> DrawResult:
  match remaining === 0:
    case 0:
      idx = seed % remaining;
      next = next_seed(seed);
      _pick_result_to_draw(config_value, remaining, next, level, _pick_entry(draw_counts, idx))
    case _:
      draw_result{none{}, draw_counts, 0, next_seed(seed), level}

def draw_tile(
  config_value: Config,
  deck_blueprint: List(DeckEntry),
  draw_counts: List(DeckEntry),
  remaining: U32,
  seed: U32,
  level: U32,
) -> DrawResult:
  match remaining === 0:
    case 0:
      _draw_from_counts(config_value, draw_counts, remaining, seed, level)
    case _:
      refill = sum_counts(deck_blueprint);
      _draw_from_counts(config_value, deck_blueprint, refill, seed, level + 1)
