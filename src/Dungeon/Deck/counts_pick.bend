import Dungeon/Upgrade as Upgrade
import Dungeon/MonsterDef as MonsterDef
import Dungeon/SwordDef as SwordDef
import Dungeon/PotionDef as PotionDef
import Dungeon/DeckEntry as DeckEntry
import Dungeon/CardRef as CardRef
import Dungeon/_PickResult as _PickResult
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

def _same_entry_key(current: DeckEntry, target: DeckEntry) -> U32:
  match current target:
    case monster_entry{current_ref, current_count} monster_entry{target_ref, target_count}:
      current_ref === target_ref
    case sword_entry{current_ref, current_count} sword_entry{target_ref, target_count}:
      current_ref === target_ref
    case potion_entry{current_ref, current_count} potion_entry{target_ref, target_count}:
      current_ref === target_ref
    case hero_entry{current_count} hero_entry{target_count}:
      1
    case _ _:
      0

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

def card_ref_entry(card: CardRef, count: U32) -> DeckEntry:
  match card:
    case monster_card{ref}:
      monster_entry{ref, count}
    case sword_card{ref}:
      sword_entry{ref, count}
    case potion_card{ref}:
      potion_entry{ref, count}
    case hero_card{}:
      hero_entry{count}

def _count_for_card(entry: DeckEntry, rest: List(DeckEntry), card: CardRef) -> U32:
  _count_for_card_match(_entry_matches_card(entry, card), entry, rest, card)

def _count_for_card_match(matched: U32, entry: DeckEntry, rest: List(DeckEntry), card: CardRef) -> U32:
  match matched:
    case 0:
      deck_count_for_card(rest, card)
    case _:
      _entry_count(entry)

def _entry_matches_card(entry: DeckEntry, card: CardRef) -> U32:
  match entry card:
    case monster_entry{entry_ref, count} monster_card{card_ref}:
      entry_ref === card_ref
    case sword_entry{entry_ref, count} sword_card{card_ref}:
      entry_ref === card_ref
    case potion_entry{entry_ref, count} potion_card{card_ref}:
      entry_ref === card_ref
    case hero_entry{count} hero_card{}:
      1
    case _ _:
      0

def deck_count_for_card(entries: List(DeckEntry), card: CardRef) -> U32:
  match entries:
    case []:
      0
    case entry<>rest:
      _count_for_card(entry, rest, card)

def _add_deck_entry_match(matched: U32, current: DeckEntry, rest: List(DeckEntry), entry: DeckEntry) -> List(DeckEntry):
  match matched:
    case 0:
      current<>add_deck_entry(rest, entry)
    case _:
      _entry_with_count(current, _entry_count(current) + _entry_count(entry))<>rest

def add_deck_entry(entries: List(DeckEntry), entry: DeckEntry) -> List(DeckEntry):
  match entries:
    case []:
      [entry]
    case current<>rest:
      _add_deck_entry_match(_same_entry_key(current, entry), current, rest, entry)

def merge_deck_entries(base: List(DeckEntry), extra: List(DeckEntry)) -> List(DeckEntry):
  match extra:
    case []:
      base
    case entry<>rest:
      merge_deck_entries(add_deck_entry(base, entry), rest)

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
    case monster_def{name, sprite, gold_drop, hp_levels}<>rest:
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
    case monster_def{name, sprite, gold_drop, hp_levels}<>rest:
      match idx:
        case 0:
          _nth_u32(hp_levels, level - 1, 1)
        case _:
          _monster_hp(rest, idx - 1, level)

def _sword_damage(swords: List(SwordDef), idx: U32) -> U32:
  match swords:
    case []:
      1
    case sword_def{name, sprite, dmg}<>rest:
      match idx:
        case 0:
          dmg
        case _:
          _sword_damage(rest, idx - 1)

def _potion_heal(potions: List(PotionDef), idx: U32) -> U32:
  match potions:
    case []:
      1
    case potion_def{name, sprite, heal}<>rest:
      match idx:
        case 0:
          heal
        case _:
          _potion_heal(rest, idx - 1)
