import /bend/types as Types

def next_seed(seed: U32) -> U32:
  value = (seed * 1664525) + 1013904223;
  match value === 0:
    case 0:
      value
    case _:
      1

def sum_counts(entries: List(Types.DeckEntry)) -> U32:
  match entries:
    case []:
      0
    case deck_entry{kind, ref, count}<>rest:
      count + sum_counts(rest)

def remove_hero_card(entries: List(Types.DeckEntry)) -> List(Types.DeckEntry):
  match entries:
    case []:
      []
    case deck_entry{kind, ref, count}<>rest:
      remove_hero_card_entry(kind, ref, count, rest)

def remove_hero_card_entry(kind: U32, ref: U32, count: U32, rest: List(Types.DeckEntry)) -> List(Types.DeckEntry):
  match kind === 3:
    case 0:
      (deck_entry{kind, ref, count}<>remove_hero_card(rest) :: List(Types.DeckEntry))
    case _:
      remove_hero_card_keep(ref, count, rest)

def remove_hero_card_keep(ref: U32, count: U32, rest: List(Types.DeckEntry)) -> List(Types.DeckEntry):
  match count === 1:
    case 0:
      (deck_entry{3, ref, count - 1}<>rest :: List(Types.DeckEntry))
    case _:
      (rest :: List(Types.DeckEntry))

def add_card_count(entries: List(Types.DeckEntry), kind: U32, ref: U32) -> List(Types.DeckEntry):
  match entries:
    case []:
      ([deck_entry{kind, ref, 1}] :: List(Types.DeckEntry))
    case deck_entry{entry_kind, entry_ref, count}<>rest:
      add_card_count_entry(kind, ref, entry_kind, entry_ref, count, rest)

def add_card_count_entry(
  kind: U32,
  ref: U32,
  entry_kind: U32,
  entry_ref: U32,
  count: U32,
  rest: List(Types.DeckEntry),
) -> List(Types.DeckEntry):
  match entry_kind === kind:
    case 0:
      (deck_entry{entry_kind, entry_ref, count}<>add_card_count(rest, kind, ref) :: List(Types.DeckEntry))
    case _:
      add_card_count_ref(kind, ref, entry_kind, entry_ref, count, rest)

def add_card_count_ref(
  kind: U32,
  ref: U32,
  entry_kind: U32,
  entry_ref: U32,
  count: U32,
  rest: List(Types.DeckEntry),
) -> List(Types.DeckEntry):
  match entry_ref === ref:
    case 0:
      (deck_entry{entry_kind, entry_ref, count}<>add_card_count(rest, kind, ref) :: List(Types.DeckEntry))
    case _:
      (deck_entry{entry_kind, entry_ref, count + 1}<>rest :: List(Types.DeckEntry))

type PickResult {
  pick_result{kind: U32, ref: U32, counts: List(Types.DeckEntry)}
}

def pick_entry(entries: List(Types.DeckEntry), idx: U32) -> PickResult:
  match entries:
    case []:
      pick_result{0, 0, []}
    case deck_entry{kind, ref, count}<>rest:
      match idx < count:
        case 0:
          pick_entry_rest(kind, ref, count, rest, idx - count)
        case _:
          pick_entry_hit(kind, ref, count, rest)

def pick_entry_rest(
  kind: U32,
  ref: U32,
  count: U32,
  rest: List(Types.DeckEntry),
  idx: U32,
) -> PickResult:
  pick_entry_rest_result(kind, ref, count, pick_entry(rest, idx))

def pick_entry_rest_result(kind: U32, ref: U32, count: U32, result: PickResult) -> PickResult:
  match result:
    case pick_result{picked_kind, picked_ref, next_counts}:
      (pick_result{
        picked_kind,
        picked_ref,
        deck_entry{kind, ref, count}<>next_counts
      } :: PickResult)

def pick_entry_hit(kind: U32, ref: U32, count: U32, rest: List(Types.DeckEntry)) -> PickResult:
  match count === 1:
    case 0:
      (pick_result{kind, ref, deck_entry{kind, ref, count - 1}<>rest} :: PickResult)
    case _:
      (pick_result{kind, ref, rest} :: PickResult)

def nth_u32_or(xs: List(U32), idx: U32, fallback: U32) -> U32:
  match xs:
    case []:
      fallback
    case head<>rest:
      match idx === 0:
        case 0:
          nth_u32_or(rest, idx - 1, head)
        case _:
          head

def nth_upgrade(upgrades: List(Types.Upgrade), idx: U32) -> Types.Upgrade:
  match upgrades:
    case []:
      upgrade{0, 0}
    case upgrade{cost, max_hp}<>rest:
      match idx === 0:
        case 0:
          nth_upgrade(rest, idx - 1)
        case _:
          upgrade{cost, max_hp}

def hero_max_hp(base_hp: U32, upgrades: List(Types.Upgrade), hero_level: U32) -> U32:
  match hero_level === 0:
    case 0:
      hero_max_hp_from_upgrade(nth_upgrade(upgrades, hero_level - 1), base_hp)
    case _:
      base_hp

def hero_max_hp_from_upgrade(upgrade_step: Types.Upgrade, fallback: U32) -> U32:
  match upgrade_step:
    case upgrade{cost, max_hp}:
      match max_hp === 0:
        case 0:
          max_hp
        case _:
          fallback

def nth_monster(monsters: List(Types.MonsterDef), idx: U32) -> Types.MonsterDef:
  match monsters:
    case []:
      monster_def{0, [1]}
    case monster_def{gold_drop, hp_levels}<>rest:
      match idx === 0:
        case 0:
          nth_monster(rest, idx - 1)
        case _:
          monster_def{gold_drop, hp_levels}

def nth_sword(swords: List(Types.SwordDef), idx: U32) -> Types.SwordDef:
  match swords:
    case []:
      sword_def{1}
    case sword_def{dmg}<>rest:
      match idx === 0:
        case 0:
          nth_sword(rest, idx - 1)
        case _:
          sword_def{dmg}

def nth_potion(potions: List(Types.PotionDef), idx: U32) -> Types.PotionDef:
  match potions:
    case []:
      potion_def{1}
    case potion_def{heal}<>rest:
      match idx === 0:
        case 0:
          nth_potion(rest, idx - 1)
        case _:
          potion_def{heal}

def monster_hp(monsters: List(Types.MonsterDef), ref: U32, level: U32) -> U32:
  monster_hp_from_def(level, nth_monster(monsters, ref))

def monster_hp_from_def(level: U32, monster_value: Types.MonsterDef) -> U32:
  match monster_value:
    case monster_def{gold_drop, hp_levels}:
      lvl = level - 1;
      nth_u32_or(hp_levels, lvl, 1)

def monster_gold(monsters: List(Types.MonsterDef), ref: U32) -> U32:
  monster_gold_from_def(nth_monster(monsters, ref))

def monster_gold_from_def(monster_value: Types.MonsterDef) -> U32:
  match monster_value:
    case monster_def{gold_drop, hp_levels}:
      gold_drop

def sword_damage(swords: List(Types.SwordDef), ref: U32) -> U32:
  sword_damage_from_def(nth_sword(swords, ref))

def sword_damage_from_def(sword_value: Types.SwordDef) -> U32:
  match sword_value:
    case sword_def{dmg}:
      dmg

def potion_heal(potions: List(Types.PotionDef), ref: U32) -> U32:
  potion_heal_from_def(nth_potion(potions, ref))

def potion_heal_from_def(potion_value: Types.PotionDef) -> U32:
  match potion_value:
    case potion_def{heal}:
      heal

def spawn_tile(config_value: Types.Config, kind: U32, ref: U32, level: U32) -> Types.Tile:
  match config_value:
    case config{hero_base_max_hp, upgrades, monsters, swords, potions, deck, base_deck_size, starting_dungeon_level}:
      λ{
        0: (monster{ref, monster_hp(monsters, ref, level)} :: Types.Tile);
        1: (sword{ref, sword_damage(swords, ref)} :: Types.Tile);
        2: (potion{ref, potion_heal(potions, ref)} :: Types.Tile);
        _ => (none{} :: Types.Tile)
      }(kind)

def draw_tile(
  config_value: Types.Config,
  deck_blueprint: List(Types.DeckEntry),
  draw_counts: List(Types.DeckEntry),
  remaining: U32,
  seed: U32,
  level: U32,
) -> Types.DrawResult:
  match remaining === 0:
    case 0:
      draw_tile_pick(config_value, draw_counts, remaining, seed, level)
    case _:
      refill = sum_counts(deck_blueprint);
      draw_tile_pick(config_value, deck_blueprint, refill, seed, level + 1)

def draw_tile_pick(
  config_value: Types.Config,
  draw_counts: List(Types.DeckEntry),
  remaining: U32,
  seed: U32,
  level: U32,
) -> Types.DrawResult:
  match remaining === 0:
    case 0:
      idx = seed % remaining;
      nxt = next_seed(seed);
      draw_tile_pick_result(config_value, remaining, nxt, level, pick_entry(draw_counts, idx))
    case _:
      (draw_result{none{}, draw_counts, 0, next_seed(seed), level} :: Types.DrawResult)

def draw_tile_pick_result(
  config_value: Types.Config,
  remaining: U32,
  nxt: U32,
  level: U32,
  result: PickResult,
) -> Types.DrawResult:
  match result:
    case pick_result{kind, ref, next_counts}:
      tile = spawn_tile(config_value, kind, ref, level);
      (draw_result{tile, next_counts, remaining - 1, nxt, level} :: Types.DrawResult)
