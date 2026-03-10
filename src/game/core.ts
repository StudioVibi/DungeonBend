import { applySwipeCore, startRunCore, upgradeHeroCore } from "../generated/bend-api";
import type {
  CoreBoardTile,
  CoreConfig,
  CoreDeckEntry,
  CoreMonster,
  CorePotion,
  CoreSword,
  CoreUpgrade,
  CoreWeaponState,
  Direction,
  MetaState,
  NormalizedBalance,
  RunState,
  SwipeResult,
} from "./types";

type BendList<T> =
  | { $: "nil" }
  | { $: "cons"; head: T; tail: BendList<T> };

type BendUpgrade = {
  $: "upgrade";
  cost: number;
  max_hp: number;
};

type BendMonster = {
  $: "monster_def";
  gold_drop: number;
  hp_levels: BendList<number>;
};

type BendSword = {
  $: "sword_def";
  dmg: number;
};

type BendPotion = {
  $: "potion_def";
  heal: number;
};

type BendDeckEntry = {
  $: "deck_entry";
  kind: number;
  ref: number;
  count: number;
};

type BendConfig = {
  $: "config";
  hero_base_max_hp: number;
  upgrades: BendList<BendUpgrade>;
  monsters: BendList<BendMonster>;
  swords: BendList<BendSword>;
  potions: BendList<BendPotion>;
  deck: BendList<BendDeckEntry>;
  base_deck_size: number;
  starting_dungeon_level: number;
};

type BendMeta = {
  $: "meta";
  hero_level: number;
  gold: number;
};

type BendWeapon =
  | { $: "no_weapon" }
  | { $: "weapon"; ref: number; dmg: number };

type BendTile =
  | { $: "none" }
  | { $: "monster"; ref: number; hp: number }
  | { $: "sword"; ref: number; dmg: number }
  | { $: "potion"; ref: number; heal: number }
  | { $: "gold"; amount: number };

type BendBoard = {
  $: "board";
  c0: BendTile;
  c1: BendTile;
  c2: BendTile;
  c3: BendTile;
  c4: BendTile;
  c5: BendTile;
  c6: BendTile;
  c7: BendTile;
  c8: BendTile;
};

type BendRun = {
  $: "run";
  dungeon_level: number;
  hero_hp: number;
  hero_max_hp: number;
  hero_index: number;
  weapon: BendWeapon;
  board: BendBoard;
  deck_blueprint: BendList<BendDeckEntry>;
  draw_counts: BendList<BendDeckEntry>;
  remaining: number;
  capacity: number;
  seed: number;
  status: number;
};

type BendSwipeResult = {
  $: "swipe_result";
  meta: BendMeta;
  run: BendRun;
};

var configCache = new WeakMap<CoreConfig, BendConfig>();

var startRunCoreFn = startRunCore as unknown as (config: BendConfig, meta: BendMeta, seed: number) => BendRun;
var upgradeHeroCoreFn = upgradeHeroCore as unknown as (config: BendConfig, meta: BendMeta) => BendMeta;
var applySwipeCoreFn = applySwipeCore as unknown as (
  config: BendConfig,
  meta: BendMeta,
  run: BendRun,
  dir: number,
) => BendSwipeResult;

function encodeList<TSource, TEncoded>(
  values: readonly TSource[],
  encodeValue: (value: TSource) => TEncoded,
): BendList<TEncoded> {
  var list: BendList<TEncoded> = { $: "nil" };

  for (var index = values.length - 1; index >= 0; index -= 1) {
    list = {
      $: "cons",
      head: encodeValue(values[index]),
      tail: list,
    };
  }

  return list;
}

function decodeList<TSource, TDecoded>(
  list: BendList<TSource>,
  decodeValue: (value: TSource) => TDecoded,
): TDecoded[] {
  var out: TDecoded[] = [];
  var cursor = list;

  while (cursor.$ !== "nil") {
    out.push(decodeValue(cursor.head));
    cursor = cursor.tail;
  }

  return out;
}

function encodeUpgrade(value: CoreUpgrade): BendUpgrade {
  return {
    $: "upgrade",
    cost: value.cost,
    max_hp: value.max_hp,
  };
}

function encodeMonster(value: CoreMonster): BendMonster {
  return {
    $: "monster_def",
    gold_drop: value.gold_drop,
    hp_levels: encodeList(value.hp_levels, hp => hp),
  };
}

function encodeSword(value: CoreSword): BendSword {
  return {
    $: "sword_def",
    dmg: value.dmg,
  };
}

function encodePotion(value: CorePotion): BendPotion {
  return {
    $: "potion_def",
    heal: value.heal,
  };
}

function encodeDeckEntry(value: CoreDeckEntry): BendDeckEntry {
  return {
    $: "deck_entry",
    kind: value.kind,
    ref: value.ref,
    count: value.count,
  };
}

function decodeDeckEntry(value: BendDeckEntry): CoreDeckEntry {
  return {
    kind: value.kind,
    ref: value.ref,
    count: value.count,
  };
}

function encodeWeapon(value: CoreWeaponState): BendWeapon {
  if (value.tag === "none") {
    return { $: "no_weapon" };
  }

  return {
    $: "weapon",
    ref: value.ref,
    dmg: value.dmg,
  };
}

function decodeWeapon(value: BendWeapon): CoreWeaponState {
  if (value.$ === "no_weapon") {
    return { tag: "none" };
  }

  return {
    tag: "weapon",
    ref: value.ref,
    dmg: value.dmg,
  };
}

function encodeTile(value: CoreBoardTile): BendTile {
  switch (value.tag) {
    case "none":
      return { $: "none" };
    case "monster":
      return { $: "monster", ref: value.ref, hp: value.hp };
    case "sword":
      return { $: "sword", ref: value.ref, dmg: value.dmg };
    case "potion":
      return { $: "potion", ref: value.ref, heal: value.heal };
    case "gold":
      return { $: "gold", amount: value.amount };
  }
}

function decodeTile(value: BendTile): CoreBoardTile {
  switch (value.$) {
    case "none":
      return { tag: "none" };
    case "monster":
      return { tag: "monster", ref: value.ref, hp: value.hp };
    case "sword":
      return { tag: "sword", ref: value.ref, dmg: value.dmg };
    case "potion":
      return { tag: "potion", ref: value.ref, heal: value.heal };
    case "gold":
      return { tag: "gold", amount: value.amount };
  }
}

function encodeBoard(board: CoreBoardTile[]): BendBoard {
  return {
    $: "board",
    c0: encodeTile(board[0] ?? { tag: "none" }),
    c1: encodeTile(board[1] ?? { tag: "none" }),
    c2: encodeTile(board[2] ?? { tag: "none" }),
    c3: encodeTile(board[3] ?? { tag: "none" }),
    c4: encodeTile(board[4] ?? { tag: "none" }),
    c5: encodeTile(board[5] ?? { tag: "none" }),
    c6: encodeTile(board[6] ?? { tag: "none" }),
    c7: encodeTile(board[7] ?? { tag: "none" }),
    c8: encodeTile(board[8] ?? { tag: "none" }),
  };
}

function decodeBoard(board: BendBoard): CoreBoardTile[] {
  return [
    decodeTile(board.c0),
    decodeTile(board.c1),
    decodeTile(board.c2),
    decodeTile(board.c3),
    decodeTile(board.c4),
    decodeTile(board.c5),
    decodeTile(board.c6),
    decodeTile(board.c7),
    decodeTile(board.c8),
  ];
}

function encodeStatus(status: RunState["status"]): number {
  return status === "game_over" ? 1 : 0;
}

function decodeStatus(status: number): RunState["status"] {
  return status === 0 ? "running" : "game_over";
}

function encodeDirection(direction: Direction): number {
  switch (direction) {
    case "up":
      return 0;
    case "down":
      return 1;
    case "left":
      return 2;
    case "right":
      return 3;
  }
}

function normalizeSeed(seed: number): number {
  var normalized = Math.abs(Math.trunc(seed)) >>> 0;
  return normalized === 0 ? 1 : normalized;
}

export function encodeConfig(config: CoreConfig): BendConfig {
  return {
    $: "config",
    hero_base_max_hp: config.hero_base_max_hp,
    upgrades: encodeList(config.upgrades, encodeUpgrade),
    monsters: encodeList(config.monsters, encodeMonster),
    swords: encodeList(config.swords, encodeSword),
    potions: encodeList(config.potions, encodePotion),
    deck: encodeList(config.deck, encodeDeckEntry),
    base_deck_size: config.base_deck_size,
    starting_dungeon_level: config.starting_dungeon_level,
  };
}

function encodeConfigCached(config: CoreConfig): BendConfig {
  var cached = configCache.get(config);
  if (cached !== undefined) {
    return cached;
  }

  var encoded = encodeConfig(config);
  configCache.set(config, encoded);
  return encoded;
}

export function encodeMeta(meta: MetaState): BendMeta {
  return {
    $: "meta",
    hero_level: meta.heroLevel,
    gold: meta.gold,
  };
}

export function decodeMeta(value: BendMeta, heroId: string): MetaState {
  return {
    heroId,
    heroLevel: value.hero_level,
    gold: value.gold,
  };
}

export function encodeRun(run: RunState): BendRun {
  return {
    $: "run",
    dungeon_level: run.dungeonLevel,
    hero_hp: run.heroHp,
    hero_max_hp: run.heroMaxHp,
    hero_index: run.heroIndex,
    weapon: encodeWeapon(run.weapon),
    board: encodeBoard(run.board),
    deck_blueprint: encodeList(run.deckBlueprint, encodeDeckEntry),
    draw_counts: encodeList(run.drawCounts, encodeDeckEntry),
    remaining: run.remaining,
    capacity: run.capacity,
    seed: run.seed,
    status: encodeStatus(run.status),
  };
}

export function decodeRun(value: BendRun): RunState {
  return {
    dungeonLevel: value.dungeon_level,
    heroHp: value.hero_hp,
    heroMaxHp: value.hero_max_hp,
    heroIndex: value.hero_index,
    weapon: decodeWeapon(value.weapon),
    board: decodeBoard(value.board),
    deckBlueprint: decodeList(value.deck_blueprint, decodeDeckEntry),
    drawCounts: decodeList(value.draw_counts, decodeDeckEntry),
    remaining: value.remaining,
    capacity: value.capacity,
    seed: value.seed,
    status: decodeStatus(value.status),
  };
}

export function decodeSwipeResult(value: BendSwipeResult, heroId: string): SwipeResult {
  return {
    meta: decodeMeta(value.meta, heroId),
    run: decodeRun(value.run),
  };
}

export function startRun(balance: NormalizedBalance, meta: MetaState, seed: number): RunState {
  var run = startRunCoreFn(encodeConfigCached(balance.core), encodeMeta(meta), normalizeSeed(seed));
  return decodeRun(run);
}

export function upgradeHero(balance: NormalizedBalance, meta: MetaState): MetaState {
  var next = upgradeHeroCoreFn(encodeConfigCached(balance.core), encodeMeta(meta));
  return decodeMeta(next, meta.heroId);
}

export function applySwipe(
  balance: NormalizedBalance,
  meta: MetaState,
  run: RunState,
  direction: Direction,
): SwipeResult {
  var result = applySwipeCoreFn(
    encodeConfigCached(balance.core),
    encodeMeta(meta),
    encodeRun(run),
    encodeDirection(direction),
  );
  return decodeSwipeResult(result, meta.heroId);
}
