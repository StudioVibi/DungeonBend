import /dungeon/logic/Config
import /dungeon/logic/Tile
import /dungeon/logic/DeckEntry
import /dungeon/logic/MonsterDef
import /dungeon/logic/SwordDef
import /dungeon/logic/PotionDef
import /dungeon/logic/DrawResult
import /dungeon/logic/Deck/next_seed as next_seed
import /dungeon/logic/Deck/sum_counts as sum_counts

type _PickResult {
  pick_result{kind: U32, ref: U32, counts: List(DeckEntry)}
}

def _pick_entry(entries: List(DeckEntry), idx: U32) -> _PickResult:
  match entries:
    case []:
      (pick_result{0, 0, []} :: _PickResult)
    case deck_entry{kind, ref, count}<>rest:
      match idx < count:
        case 0:
          _pick_rest(kind, ref, count, rest, idx - count)
        case _:
          _pick_hit(kind, ref, count, rest)

def _prepend_pick(kind: U32, ref: U32, count: U32, result: _PickResult) -> _PickResult:
  match result:
    case pick_result{picked_kind, picked_ref, next_counts}:
      (pick_result{picked_kind, picked_ref, deck_entry{kind, ref, count}<>next_counts} :: _PickResult)

def _pick_rest(kind: U32, ref: U32, count: U32, rest: List(DeckEntry), idx: U32) -> _PickResult:
  _prepend_pick(kind, ref, count, _pick_entry(rest, idx))

def _pick_hit(kind: U32, ref: U32, count: U32, rest: List(DeckEntry)) -> _PickResult:
  match count === 1:
    case 0:
      (pick_result{kind, ref, deck_entry{kind, ref, count - 1}<>rest} :: _PickResult)
    case _:
      (pick_result{kind, ref, rest} :: _PickResult)

def _nth_u32(xs: List(U32), idx: U32, fallback: U32) -> U32:
  match xs:
    case []:
      fallback
    case head<>rest:
      match idx === 0:
        case 0:
          _nth_u32(rest, idx - 1, head)
        case _:
          head

def _monster_hp(monsters: List(MonsterDef), idx: U32, level: U32) -> U32:
  match monsters:
    case []:
      1
    case monster_def{gold_drop, hp_levels}<>rest:
      match idx === 0:
        case 0:
          _monster_hp(rest, idx - 1, level)
        case _:
          _nth_u32(hp_levels, level - 1, 1)

def _sword_damage(swords: List(SwordDef), idx: U32) -> U32:
  match swords:
    case []:
      1
    case sword_def{dmg}<>rest:
      match idx === 0:
        case 0:
          _sword_damage(rest, idx - 1)
        case _:
          dmg

def _potion_heal(potions: List(PotionDef), idx: U32) -> U32:
  match potions:
    case []:
      1
    case potion_def{heal}<>rest:
      match idx === 0:
        case 0:
          _potion_heal(rest, idx - 1)
        case _:
          heal

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
