import /Dungeon/Upgrade as Upgrade
import /Dungeon/MonsterDef as MonsterDef
import /Dungeon/SwordDef as SwordDef
import /Dungeon/PotionDef as PotionDef
import /Dungeon/DeckEntry as DeckEntry
import /Dungeon/_PickResult as _PickResult

def _next_seed_value(value: U32) -> U32:
  match value:
    case 0:
      1
    case _:
      value

def next_seed(seed: U32) -> U32:
  _next_seed_value((seed * 1664525) + 1013904223)

def _entry_count(entry: DeckEntry) -> U32:
  match entry:
    case monster_entry{ref, count}:
      count
    case sword_entry{ref, count}:
      count
    case potion_entry{ref, count}:
      count
    case hero_entry{count}:
      count

def _entry_with_count(entry: DeckEntry, count: U32) -> DeckEntry:
  match entry:
    case monster_entry{ref, current}:
      monster_entry{ref, count}
    case sword_entry{ref, current}:
      sword_entry{ref, count}
    case potion_entry{ref, current}:
      potion_entry{ref, count}
    case hero_entry{current}:
      hero_entry{count}

def sum_counts(entries: List(DeckEntry)) -> U32:
  match entries:
    case []:
      0
    case entry<>rest:
      _entry_count(entry) + sum_counts(rest)

def nth_upgrade(upgrades: List(Upgrade), idx: U32) -> Upgrade:
  match upgrades:
    case []:
      upgrade{0, 0}
    case upgrade{cost, max_hp}<>rest:
      match idx:
        case 0:
          upgrade{cost, max_hp}
        case _:
          nth_upgrade(rest, idx - 1)

def _from_upgrade(step: Upgrade, fallback: U32) -> U32:
  match step:
    case upgrade{cost, max_hp}:
      match max_hp:
        case 0:
          fallback
        case _:
          max_hp

def hero_max_hp(base_hp: U32, upgrades: List(Upgrade), hero_level: U32) -> U32:
  match hero_level:
    case 0:
      base_hp
    case _:
      _from_upgrade(nth_upgrade(upgrades, hero_level - 1), base_hp)

def monster_gold(monsters: List(MonsterDef), idx: U32) -> U32:
  match monsters:
    case []:
      0
    case monster_def{gold_drop, hp_levels}<>rest:
      match idx:
        case 0:
          gold_drop
        case _:
          monster_gold(rest, idx - 1)

def _remove_hero_entry(count: U32, rest: List(DeckEntry)) -> List(DeckEntry):
  match count:
    case 1:
      rest
    case _:
      hero_entry{count - 1}<>rest

def remove_hero_card(entries: List(DeckEntry)) -> List(DeckEntry):
  match entries:
    case []:
      []
    case monster_entry{ref, count}<>rest:
      monster_entry{ref, count}<>remove_hero_card(rest)
    case sword_entry{ref, count}<>rest:
      sword_entry{ref, count}<>remove_hero_card(rest)
    case potion_entry{ref, count}<>rest:
      potion_entry{ref, count}<>remove_hero_card(rest)
    case hero_entry{count}<>rest:
      _remove_hero_entry(count, rest)

def _prepend_pick(entry: DeckEntry, result: _PickResult) -> _PickResult:
  match result:
    case no_pick{counts}:
      no_pick{entry<>counts}
    case picked_entry{picked, counts}:
      picked_entry{picked, entry<>counts}

def _pick_rest(entry: DeckEntry, rest: List(DeckEntry), idx: U32) -> _PickResult:
  _prepend_pick(entry, _pick_entry(rest, idx - _entry_count(entry)))

def _pick_hit_keep(entry: DeckEntry, rest: List(DeckEntry), count: U32) -> _PickResult:
  picked_entry{entry, _entry_with_count(entry, count - 1)<>rest}

def _pick_hit(entry: DeckEntry, rest: List(DeckEntry)) -> _PickResult:
  _pick_hit_count(entry, rest, _entry_count(entry))

def _pick_hit_count(entry: DeckEntry, rest: List(DeckEntry), count: U32) -> _PickResult:
  match count:
    case 1:
      picked_entry{entry, rest}
    case _:
      _pick_hit_keep(entry, rest, count)

def _pick_entry(entries: List(DeckEntry), idx: U32) -> _PickResult:
  match entries:
    case []:
      no_pick{[]}
    case entry<>rest:
      _pick_entry_step(entry, rest, idx, _entry_count(entry))

def _pick_entry_step(entry: DeckEntry, rest: List(DeckEntry), idx: U32, count: U32) -> _PickResult:
  _pick_entry_cmp(idx < count, entry, rest, idx)

def _pick_entry_cmp(idx_lt_count: U32, entry: DeckEntry, rest: List(DeckEntry), idx: U32) -> _PickResult:
  match idx_lt_count:
    case 0:
      _pick_rest(entry, rest, idx)
    case _:
      _pick_hit(entry, rest)

def _nth_u32(xs: List(U32), idx: U32, fallback: U32) -> U32:
  match xs:
    case []:
      fallback
    case head<>rest:
      match idx:
        case 0:
          head
        case _:
          _nth_u32(rest, idx - 1, head)

def _monster_hp(monsters: List(MonsterDef), idx: U32, level: U32) -> U32:
  match monsters:
    case []:
      1
    case monster_def{gold_drop, hp_levels}<>rest:
      match idx:
        case 0:
          _nth_u32(hp_levels, level - 1, 1)
        case _:
          _monster_hp(rest, idx - 1, level)

def _sword_damage(swords: List(SwordDef), idx: U32) -> U32:
  match swords:
    case []:
      1
    case sword_def{dmg}<>rest:
      match idx:
        case 0:
          dmg
        case _:
          _sword_damage(rest, idx - 1)

def _potion_heal(potions: List(PotionDef), idx: U32) -> U32:
  match potions:
    case []:
      1
    case potion_def{heal}<>rest:
      match idx:
        case 0:
          heal
        case _:
          _potion_heal(rest, idx - 1)
