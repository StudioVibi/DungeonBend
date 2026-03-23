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

def _next_seed_value(value: U32) -> U32:
  match value === 0:
    case 0:
      value
    case _:
      1

def next_seed(seed: U32) -> U32:
  _next_seed_value((seed * 1664525) + 1013904223)

def sum_counts(entries: List(DeckEntry)) -> U32:
  match entries:
    case []:
      0
    case deck_entry{kind, ref, count}<>rest:
      count + sum_counts(rest)

def nth_upgrade(upgrades: List(Upgrade), idx: U32) -> Upgrade:
  match upgrades:
    case []:
      upgrade{0, 0}
    case upgrade{cost, max_hp}<>rest:
      match idx === 0:
        case 0:
          nth_upgrade(rest, idx - 1)
        case _:
          upgrade{cost, max_hp}

def _from_upgrade(step: Upgrade, fallback: U32) -> U32:
  match step:
    case upgrade{cost, max_hp}:
      match max_hp === 0:
        case 0:
          max_hp
        case _:
          fallback

def hero_max_hp(base_hp: U32, upgrades: List(Upgrade), hero_level: U32) -> U32:
  match hero_level === 0:
    case 0:
      _from_upgrade(nth_upgrade(upgrades, hero_level - 1), base_hp)
    case _:
      base_hp

def monster_gold(monsters: List(MonsterDef), idx: U32) -> U32:
  match monsters:
    case []:
      0
    case monster_def{gold_drop, hp_levels}<>rest:
      match idx === 0:
        case 0:
          monster_gold(rest, idx - 1)
        case _:
          gold_drop

def _remove_entry(kind: U32, ref: U32, count: U32, rest: List(DeckEntry)) -> List(DeckEntry):
  match kind === 3:
    case 0:
      (deck_entry{kind, ref, count}<>remove_hero_card(rest) :: List(DeckEntry))
    case _:
      _remove_keep(ref, count, rest)

def _remove_keep(ref: U32, count: U32, rest: List(DeckEntry)) -> List(DeckEntry):
  match count === 1:
    case 0:
      (deck_entry{3, ref, count - 1}<>rest :: List(DeckEntry))
    case _:
      (rest :: List(DeckEntry))

def remove_hero_card(entries: List(DeckEntry)) -> List(DeckEntry):
  match entries:
    case []:
      []
    case deck_entry{kind, ref, count}<>rest:
      _remove_entry(kind, ref, count, rest)

def _pick_entry(entries: List(DeckEntry), idx: U32) -> _PickResult:
  match entries:
    case []:
      pick_result{0, 0, []}
    case deck_entry{kind, ref, count}<>rest:
      match idx < count:
        case 0:
          _pick_rest(kind, ref, count, rest, idx - count)
        case _:
          _pick_hit(kind, ref, count, rest)

def _prepend_pick(kind: U32, ref: U32, count: U32, result: _PickResult) -> _PickResult:
  match result:
    case pick_result{picked_kind, picked_ref, next_counts}:
      pick_result{picked_kind, picked_ref, deck_entry{kind, ref, count}<>next_counts}

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
