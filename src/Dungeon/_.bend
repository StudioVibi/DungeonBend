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

type DeckEntry {
  deck_entry{kind: U32, ref: U32, count: U32}
}

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

type BoardDraw {
  board_draw{
    board: Board,
    counts: List(DeckEntry),
    remaining: U32,
    seed: U32,
    level: U32
  }
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

type CombatResult {
  combat_result{
    hero_hp: U32,
    weapon: Weapon,
    board: Board,
    status: U32
  }
}

type Meta {
  meta{hero_level: U32, gold: U32}
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
    status: U32,
    ult_charge: U32
  }
}

type SwipeResult {
  swipe_result{meta: Meta, run: Run}
}

type RunSlot {
  idle_run{}
  run_slot{run: Run}
}

type DungeonEvent {
  start{}
  upgrade{}
  ultimate{}
  turn_up{}
  turn_down{}
  turn_left{}
  turn_right{}
  ok{}
  ignore{}
}

type DungeonState {
  dungeon{meta: Meta, current_run: RunSlot, next_seed: U32, hp_fx: U32, dmg_fx: U32, impact_idx: U32, impact_fx: U32}
}

type ImpactState {
  impact_state{idx: U32, fx: U32}
}

type _PickResult {
  pick_result{kind: U32, ref: U32, counts: List(DeckEntry)}
}

def default_meta() -> Meta:
  meta{0, 0}

def initial_seed() -> U32:
  1

def config() -> Config:
  config{
    11,
    [
      upgrade{20, 14},
      upgrade{35, 17},
      upgrade{55, 20},
      upgrade{80, 24}
    ],
    [
      monster_def{3, [3, 5, 7, 9, 11]},
      monster_def{4, [5, 7, 9, 11, 13]},
      monster_def{5, [7, 9, 11, 13, 15]},
      monster_def{6, [9, 11, 14, 17, 20]}
    ],
    [
      sword_def{5},
      sword_def{7},
      sword_def{9}
    ],
    [
      potion_def{4}
    ],
    [
      deck_entry{0, 0, 4},
      deck_entry{0, 1, 3},
      deck_entry{0, 2, 3},
      deck_entry{0, 3, 3},
      deck_entry{1, 0, 1},
      deck_entry{1, 1, 1},
      deck_entry{1, 2, 1},
      deck_entry{2, 0, 3},
      deck_entry{3, 0, 1}
    ],
    20,
    1
  }
