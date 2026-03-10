type Weapon {
  no_weapon{}
  weapon{ref: U32, dmg: U32}
}

type Tile {
  none{}
  monster{ref: U32, hp: U32}
  sword{ref: U32, dmg: U32}
  potion{ref: U32, heal: U32}
  gold{amount: U32}
}

type Board {
  board{
    c0: Tile,
    c1: Tile,
    c2: Tile,
    c3: Tile,
    c4: Tile,
    c5: Tile,
    c6: Tile,
    c7: Tile,
    c8: Tile
  }
}

type DeckEntry {
  deck_entry{kind: U32, ref: U32, count: U32}
}

type Upgrade {
  upgrade{cost: U32, max_hp: U32}
}

type MonsterDef {
  monster_def{gold_drop: U32, hp_levels: List(U32)}
}

type SwordDef {
  sword_def{dmg: U32}
}

type PotionDef {
  potion_def{heal: U32}
}

type Config {
  config{
    hero_base_max_hp: U32,
    upgrades: List(Upgrade),
    monsters: List(MonsterDef),
    swords: List(SwordDef),
    potions: List(PotionDef),
    deck: List(DeckEntry),
    base_deck_size: U32,
    starting_dungeon_level: U32
  }
}

type Meta {
  meta{hero_level: U32, gold: U32}
}

type Run {
  run{
    dungeon_level: U32,
    hero_hp: U32,
    hero_max_hp: U32,
    hero_index: U32,
    weapon: Weapon,
    board: Board,
    deck_blueprint: List(DeckEntry),
    draw_counts: List(DeckEntry),
    remaining: U32,
    capacity: U32,
    seed: U32,
    status: U32
  }
}

type SwipeResult {
  swipe_result{meta: Meta, run: Run}
}

type DrawResult {
  draw_result{
    tile: Tile,
    counts: List(DeckEntry),
    remaining: U32,
    seed: U32,
    level: U32
  }
}

type BoardDraw {
  board_draw{
    board: Board,
    counts: List(DeckEntry),
    remaining: U32,
    seed: U32,
    level: U32
  }
}

def make_run(
  dungeon_level: U32,
  hero_hp: U32,
  hero_max_hp: U32,
  hero_index: U32,
  weapon: Weapon,
  board: Board,
  deck_blueprint: List(DeckEntry),
  draw_counts: List(DeckEntry),
  remaining: U32,
  capacity: U32,
  seed: U32,
  status: U32,
) -> Run:
  run{
    dungeon_level,
    hero_hp,
    hero_max_hp,
    hero_index,
    weapon,
    board,
    deck_blueprint,
    draw_counts,
    remaining,
    capacity,
    seed,
    status
  }

def make_swipe(meta: Meta, next_run: Run) -> SwipeResult:
  swipe_result{meta, next_run}
